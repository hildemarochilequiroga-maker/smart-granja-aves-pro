library;

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../errors/error_messages.dart';

/// Servicio para monitorear el estado de la conexión de red
class NetworkInfo {
  NetworkInfo({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Stream del estado de conexion
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      return results.isNotEmpty && !results.contains(ConnectivityResult.none);
    });
  }

  /// Verifica si hay conexion a internet
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }

  /// Obtiene el tipo de conexion actual
  Future<ConnectivityResult> get connectionType async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty ? results.first : ConnectivityResult.none;
  }

  /// Verifica si esta conectado por WiFi
  Future<bool> get isWifi async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.wifi);
  }

  /// Verifica si esta conectado por datos moviles
  Future<bool> get isMobile async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.mobile);
  }

  /// Verifica si esta conectado por Ethernet
  Future<bool> get isEthernet async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.ethernet);
  }

  /// Inicia el monitoreo de conectividad
  void startMonitoring(void Function(bool isConnected) onStatusChange) {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final connected =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);
      onStatusChange(connected);
    });
  }

  /// Detiene el monitoreo de conectividad
  void stopMonitoring() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Obtiene descripcion legible del tipo de conexion
  Future<String> get connectionDescription async {
    final type = await connectionType;
    switch (type) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return ErrorMessages.get('CONN_MOBILE_DATA');
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.none:
        return ErrorMessages.get('CONN_NO_CONNECTION');
      case ConnectivityResult.other:
        return ErrorMessages.get('CONN_OTHER');
    }
  }

  /// Espera hasta que haya conexion
  Future<void> waitForConnection({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (await isConnected) return;

    final completer = Completer<void>();
    Timer? timeoutTimer;

    final subscription = onConnectivityChanged.listen((connected) {
      if (connected && !completer.isCompleted) {
        completer.complete();
      }
    });

    timeoutTimer = Timer(timeout, () {
      if (!completer.isCompleted) {
        completer.completeError(TimeoutException('Timeout esperando conexión'));
      }
    });

    try {
      await completer.future;
    } finally {
      unawaited(subscription.cancel());
      timeoutTimer.cancel();
    }
  }

  /// Dispose
  void dispose() {
    stopMonitoring();
  }
}
