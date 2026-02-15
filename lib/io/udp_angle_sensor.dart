import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

final class UdpAngleSensorReader extends Stream<double> {
  static UdpAngleSensorReader? _instance;

  late final StreamController<double> _controller;

  RawDatagramSocket? _socket;
  StreamSubscription<RawSocketEvent>? _socketSub;

  static const int _port = 6001;

  factory UdpAngleSensorReader() {
    _instance ??= UdpAngleSensorReader._internal();
    return _instance!;
  }

  UdpAngleSensorReader._internal() {
    _controller = StreamController<double>.broadcast(onListen: _onListen, onCancel: _onCancel, sync: true);
  }

  @override
  StreamSubscription<double> listen(void Function(double)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) =>
      _controller.stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);

  void _onListen() async {
    try {
      _socket ??= await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, _port);

      _socketSub ??= _socket!
          .where((event) => event == RawSocketEvent.read)
          .listen(
            (_) {
              try {
                Datagram? dg;
                while ((dg = _socket!.receive()) != null) {
                  final msg = utf8.decode(dg!.data);
                  final value = double.tryParse(msg);

                  if (value == null) continue;
                  if (value < -math.pi * 2 || value > math.pi * 2) continue;

                  _controller.add(value);
                }
              } catch (e, st) {
                _controller.addError(e, st);
              }
            },
            onError: (e, st) => _controller.addError(e, st),
            onDone: _cleanupSocket,
          );
    } catch (e, st) {
      _controller.addError(e, st);
    }
  }

  void _onCancel() {
    _cleanupSocket();
    _controller.close();
    _instance = null;
  }

  void _cleanupSocket() {
    _socketSub?.cancel();
    _socketSub = null;

    _socket?.close();
    _socket = null;
  }
}
