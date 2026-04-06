/// Provider para el scheduler de notificaciones automáticas.
///
/// Gestiona las verificaciones periódicas y genera alertas automáticas.
library;

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../application/services/alertas_service.dart';
import '../../../granjas/application/providers/granja_providers.dart';

/// Estado del scheduler de notificaciones.
class NotificacionesSchedulerState {
  const NotificacionesSchedulerState({
    this.isRunning = false,
    this.lastRun,
    this.nextRun,
    this.error,
  });

  final bool isRunning;
  final DateTime? lastRun;
  final DateTime? nextRun;
  final String? error;

  NotificacionesSchedulerState copyWith({
    bool? isRunning,
    DateTime? lastRun,
    DateTime? nextRun,
    String? error,
  }) {
    return NotificacionesSchedulerState(
      isRunning: isRunning ?? this.isRunning,
      lastRun: lastRun ?? this.lastRun,
      nextRun: nextRun ?? this.nextRun,
      error: error,
    );
  }
}

/// Provider del scheduler de notificaciones.
final notificacionesSchedulerProvider =
    StateNotifierProvider.autoDispose<
      NotificacionesSchedulerNotifier,
      NotificacionesSchedulerState
    >((ref) {
      return NotificacionesSchedulerNotifier(ref);
    });

/// Notifier del scheduler.
class NotificacionesSchedulerNotifier
    extends StateNotifier<NotificacionesSchedulerState> {
  NotificacionesSchedulerNotifier(this._ref)
    : super(const NotificacionesSchedulerState());

  final Ref _ref;
  Timer? _timer;
  final AlertasService _alertasService = AlertasService();

  /// Intervalo de verificación (15 minutos).
  static const _intervalo = Duration(minutes: 15);

  /// Inicia el scheduler.
  void iniciar() {
    if (state.isRunning) return;

    debugPrint('🔔 Iniciando scheduler de notificaciones...');

    // Ejecutar inmediatamente
    _ejecutarVerificaciones();

    // Programar ejecuciones periódicas
    _timer = Timer.periodic(_intervalo, (_) => _ejecutarVerificaciones());

    state = state.copyWith(
      isRunning: true,
      nextRun: DateTime.now().add(_intervalo),
    );
  }

  /// Detiene el scheduler.
  void detener() {
    debugPrint('🔔 Deteniendo scheduler de notificaciones...');
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(isRunning: false, nextRun: null);
  }

  /// Ejecuta las verificaciones manualmente.
  Future<void> ejecutarAhora() async {
    await _ejecutarVerificaciones();
  }

  /// Ejecuta las verificaciones para la granja seleccionada.
  Future<void> _ejecutarVerificaciones() async {
    try {
      final granjaId = _ref.read(granjaSeleccionadaProvider)?.id;

      if (granjaId == null) {
        debugPrint('⚠️ No hay granja seleccionada para verificar');
        return;
      }

      debugPrint('🔄 Ejecutando verificaciones de alertas...');

      await _alertasService.ejecutarVerificacionesProgramadas(granjaId);

      if (!mounted) return;

      state = state.copyWith(
        lastRun: DateTime.now(),
        nextRun: DateTime.now().add(_intervalo),
        error: null,
      );

      debugPrint('✅ Verificaciones completadas');
    } on Exception catch (e) {
      debugPrint('❌ Error en verificaciones: $e');
      if (!mounted) return;
      state = state.copyWith(error: e.toString());
    }
  }

  @override
  void dispose() {
    detener();
    super.dispose();
  }
}
