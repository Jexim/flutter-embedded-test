import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:math' as math;

final class UdpAngleSensorReader {
  static const int _port = 6001;
  bool _starting = false;
  RawDatagramSocket? _socket;
  final StreamController<Uint8List> _streamController = StreamController<Uint8List>.broadcast();

  Stream<Uint8List> get stream {
    return _streamController.stream;
  }

  Future<void> start() async {
    if (_starting || _socket != null) return;

    try {
      _starting = true;
      _socket = await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, _port);

      _socket!.listen((event) {
        if (event != RawSocketEvent.read) return;

        while (true) {
          final dg = _socket!.receive();

          if (dg == null) break;

          _streamController.add(dg.data);
        }
      });
    } finally {
      _starting = false;
    }
  }

  Future<void> stop() async {
    _socket?.close();
    _socket = null;
  }

  Future<void> dispose() async {
    await stop();
    await _streamController.close();
  }
}

final class AngleSensorRepository {
  AngleSensorRepository(this._reader);

  final UdpAngleSensorReader _reader;
  StreamSubscription<Uint8List>? _subscription;
  final _streamController = StreamController<double>.broadcast();
  DateTime? _lastEmitTime;

  Stream<double> get stream => _streamController.stream;

  Future<void> start() async {
    if (_subscription != null) return;

    await _reader.start();

    _subscription = _reader.stream.listen((data) {
      final value = double.tryParse(utf8.decode(data).trim());

      if (value == null || !value.isFinite) return;

      final now = DateTime.now();

      if (_lastEmitTime != null && now.difference(_lastEmitTime!).inMilliseconds < 1000) {
        return;
      }

      _lastEmitTime = now;

      final clampedValue = value.clamp(-math.pi, math.pi).toDouble();

      _streamController.add(clampedValue);
    });
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    _lastEmitTime = null;
    await _reader.stop();
  }

  Future<void> dispose() async {
    await stop();
    await _streamController.close();
    await _reader.dispose();
  }
}
