import 'dart:io';
import 'dart:async';
import 'dart:convert';

class UdpSensorService {
  static const int _port = 6001;
  bool _starting = false;
  RawDatagramSocket? _socket;
  StreamController<double>? _streamController;

  Future<void> start() async {
    if (_starting || _socket != null) return;

    try {
      _starting = true;
      _socket = await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, _port);
      _streamController ??= StreamController<double>.broadcast();

      _socket!.listen((event) {
        if (event != RawSocketEvent.read) return;

        Datagram? dg;
        while ((dg = _socket!.receive()) != null) {
          final msg = utf8.decode(dg!.data).trim();
          final value = double.tryParse(msg);

          if (value == null) continue;

          _streamController?.add(value);
        }
      });
    } finally {
      _starting = false;
    }
  }

  Stream<double> get stream {
    if (_streamController == null) {
      throw StateError('Stream controller is not initialized');
    }

    return _streamController!.stream;
  }

  Future<void> dispose() async {
    _socket?.close();
    _socket = null;
    await _streamController?.close();
    _streamController = null;
  }
}
