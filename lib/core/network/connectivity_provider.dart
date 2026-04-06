/// Provider global de conectividad para la aplicación.
library;

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/error_messages.dart';

/// Estado de conectividad de la aplicación
enum ConnectivityStatus {
  /// Conectado a internet
  online,

  /// Sin conexión a internet
  offline,

  /// Verificando estado de conexión
  checking,
}

/// Estado completo de conectividad y sincronización
@immutable
class AppConnectivityState {
  const AppConnectivityState({
    required this.status,
    required this.connectionType,
    this.hasPendingWrites = false,
    this.lastSyncTime,
  });

  /// Estado de conectividad actual
  final ConnectivityStatus status;

  /// Tipo de conexión actual
  final ConnectivityResult connectionType;

  /// Si hay escrituras pendientes de sincronizar
  final bool hasPendingWrites;

  /// Última vez que se sincronizó con el servidor
  final DateTime? lastSyncTime;

  /// Si está online
  bool get isOnline => status == ConnectivityStatus.online;

  /// Si está offline
  bool get isOffline => status == ConnectivityStatus.offline;

  /// Si está verificando
  bool get isChecking => status == ConnectivityStatus.checking;

  /// Descripción legible del tipo de conexión
  String get connectionDescription {
    switch (connectionType) {
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

  AppConnectivityState copyWith({
    ConnectivityStatus? status,
    ConnectivityResult? connectionType,
    bool? hasPendingWrites,
    DateTime? lastSyncTime,
  }) {
    return AppConnectivityState(
      status: status ?? this.status,
      connectionType: connectionType ?? this.connectionType,
      hasPendingWrites: hasPendingWrites ?? this.hasPendingWrites,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppConnectivityState &&
        other.status == status &&
        other.connectionType == connectionType &&
        other.hasPendingWrites == hasPendingWrites &&
        other.lastSyncTime == lastSyncTime;
  }

  @override
  int get hashCode =>
      Object.hash(status, connectionType, hasPendingWrites, lastSyncTime);
}

/// Notifier para manejar el estado de conectividad
class ConnectivityNotifier extends StateNotifier<AppConnectivityState> {
  ConnectivityNotifier()
    : super(
        const AppConnectivityState(
          status: ConnectivityStatus.checking,
          connectionType: ConnectivityResult.none,
        ),
      ) {
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<void>? _firestoreSnapshotsSubscription;

  void _init() {
    // Verificar estado inicial
    _checkConnectivity();

    // Escuchar cambios de conectividad
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
    );

    // Monitorear escrituras pendientes de Firestore
    _monitorPendingWrites();
  }

  Future<void> _checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _handleConnectivityChange(results);
    } on Exception catch (e) {
      debugPrint('Error verificando conectividad: $e');
      state = state.copyWith(
        status: ConnectivityStatus.offline,
        connectionType: ConnectivityResult.none,
      );
    }
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final hasConnection =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);

    final primaryConnection = results.isNotEmpty
        ? results.first
        : ConnectivityResult.none;

    final newStatus = hasConnection
        ? ConnectivityStatus.online
        : ConnectivityStatus.offline;

    // Solo actualizar si hay cambio real
    if (state.status != newStatus ||
        state.connectionType != primaryConnection) {
      state = state.copyWith(
        status: newStatus,
        connectionType: primaryConnection,
        lastSyncTime: hasConnection ? DateTime.now() : state.lastSyncTime,
      );

      debugPrint(
        '🌐 Conectividad: ${hasConnection ? "ONLINE" : "OFFLINE"} '
        '(${state.connectionDescription})',
      );
    }
  }

  void _monitorPendingWrites() {
    // Escuchar un documento dummy para detectar escrituras pendientes
    // Firestore maneja esto automáticamente, pero podemos observar metadata
    try {
      _firestoreSnapshotsSubscription = FirebaseFirestore.instance
          .collection('_app_status')
          .doc('connectivity_check')
          .snapshots(includeMetadataChanges: true)
          .listen(
            (snapshot) {
              final hasPendingWrites = snapshot.metadata.hasPendingWrites;
              if (state.hasPendingWrites != hasPendingWrites) {
                state = state.copyWith(
                  hasPendingWrites: hasPendingWrites,
                  lastSyncTime: !hasPendingWrites
                      ? DateTime.now()
                      : state.lastSyncTime,
                );

                if (hasPendingWrites) {
                  debugPrint('📝 Hay escrituras pendientes de sincronizar');
                } else {
                  debugPrint('✅ Todas las escrituras sincronizadas');
                }
              }
            },
            onError: (e) {
              // Ignorar errores - el documento puede no existir
              debugPrint('Nota: Documento de status no disponible');
            },
          );
    } on Exception catch (e) {
      debugPrint('Error configurando monitor de escrituras: $e');
    }
  }

  /// Fuerza una verificación de conectividad
  Future<void> refresh() async {
    state = state.copyWith(status: ConnectivityStatus.checking);
    await _checkConnectivity();
  }

  /// Habilita el modo offline forzado (para testing)
  Future<void> forceOfflineMode() async {
    await FirebaseFirestore.instance.disableNetwork();
    state = state.copyWith(
      status: ConnectivityStatus.offline,
      connectionType: ConnectivityResult.none,
    );
    debugPrint('🔌 Modo offline forzado activado');
  }

  /// Restaura el acceso a la red
  Future<void> enableNetwork() async {
    await FirebaseFirestore.instance.enableNetwork();
    await _checkConnectivity();
    debugPrint('🌐 Acceso a red restaurado');
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _firestoreSnapshotsSubscription?.cancel();
    super.dispose();
  }
}

/// Provider principal de conectividad
final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, AppConnectivityState>((ref) {
      return ConnectivityNotifier();
    });

/// Provider simple para verificar si está online
final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityProvider).isOnline;
});

/// Provider simple para verificar si está offline
final isOfflineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityProvider).isOffline;
});

/// Provider para verificar si hay escrituras pendientes
final hasPendingWritesProvider = Provider<bool>((ref) {
  return ref.watch(connectivityProvider).hasPendingWrites;
});

/// Stream provider para cambios de conectividad
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  return Connectivity().onConnectivityChanged.map((results) {
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  });
});
