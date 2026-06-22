/// Providers para la guía diaria interactiva con persistencia Firestore.
library;

import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/providers/auth_provider.dart';
import '../../../lotes/domain/entities/lote.dart';
import '../../domain/entities/tarea_diaria.dart';
import '../../infrastructure/datasources/tareas_diarias_datasource.dart';
import '../services/guia_diaria_generator.dart';

/// Datasource singleton provider.
final _tareasDatasourceProvider = Provider<TareasDiariasDatasource>((ref) {
  return TareasDiariasDatasource();
});

/// Estado de la guía diaria con tareas que se pueden marcar/desmarcar.
class GuiaDiariaState {
  const GuiaDiariaState({
    required this.diaActual,
    required this.tareas,
    required this.avesActuales,
    required this.diasCiclo,
    this.guardando = false,
  });

  final int diaActual;
  final List<TareaDiaria> tareas;
  final int avesActuales;
  final int diasCiclo;

  /// True mientras se persiste un cambio en Firestore.
  final bool guardando;

  int get tareasCompletadas => tareas.where((t) => t.completada).length;

  int get tareasTotal => tareas.length;

  double get progreso => tareasTotal > 0 ? tareasCompletadas / tareasTotal : 0;

  GuiaDiariaState copyWith({
    int? diaActual,
    List<TareaDiaria>? tareas,
    int? avesActuales,
    int? diasCiclo,
    bool? guardando,
  }) {
    return GuiaDiariaState(
      diaActual: diaActual ?? this.diaActual,
      tareas: tareas ?? this.tareas,
      avesActuales: avesActuales ?? this.avesActuales,
      diasCiclo: diasCiclo ?? this.diasCiclo,
      guardando: guardando ?? this.guardando,
    );
  }
}

/// Notifier que maneja el estado de la guía diaria con persistencia.
class GuiaDiariaNotifier extends StateNotifier<GuiaDiariaState> {
  GuiaDiariaNotifier(this._lote, this._datasource, this._userId)
    : super(_buildInitial(_lote)) {
    _cargarDesdeFirestore();
    _suscribirCambios();
  }

  final Lote _lote;
  final TareasDiariasDatasource _datasource;
  final String _userId;
  StreamSubscription<TareasDiariasRecord?>? _subscription;

  static GuiaDiariaState _buildInitial(Lote lote) {
    final result = GuiaDiariaGenerator.generar(lote);
    return GuiaDiariaState(
      diaActual: result.diaActual,
      tareas: result.tareas,
      avesActuales: result.avesActuales,
      diasCiclo: result.diasCiclo,
    );
  }

  Future<void> _cargarDesdeFirestore() async {
    final record = await _datasource.obtener(_lote.id, state.diaActual);
    if (record != null && mounted) {
      _aplicarRecord(record);
    }
  }

  void _suscribirCambios() {
    _subscription = _datasource.watch(_lote.id, state.diaActual).listen((
      record,
    ) {
      if (record != null && mounted) {
        _aplicarRecord(record);
      }
    });
  }

  void _aplicarRecord(TareasDiariasRecord record) {
    // Ignorar eventos del stream mientras hay una escritura pendiente.
    // La actualización optimista ya muestra el estado correcto y el
    // siguiente evento del stream (post‑transacción) lo confirmará.
    if (state.guardando) return;

    final nuevasTareas = state.tareas.map((t) {
      final estaCompletada = record.tareasCompletadas.contains(t.id);
      return t.copyWith(completada: estaCompletada);
    }).toList();

    state = state.copyWith(tareas: nuevasTareas);
  }

  /// Alterna el estado completado de una tarea y persiste en Firestore.
  Future<void> toggleTarea(String tareaId) async {
    final tarea = state.tareas.firstWhere((t) => t.id == tareaId);
    final nuevoEstado = !tarea.completada;

    // Actualización optimista local
    final nuevasTareas = state.tareas.map((t) {
      if (t.id == tareaId) return t.copyWith(completada: nuevoEstado);
      return t;
    }).toList();
    state = state.copyWith(tareas: nuevasTareas, guardando: true);

    // Persistir en Firestore
    try {
      await _datasource.toggleTarea(
        loteId: _lote.id,
        dia: state.diaActual,
        tareaId: tareaId,
        userId: _userId,
        totalTareas: state.tareasTotal,
        completar: nuevoEstado,
      );
      if (mounted) {
        state = state.copyWith(guardando: false);
      }
    } catch (e, st) {
      developer.log(
        'Error al persistir tarea: $e',
        name: 'GuiaDiaria',
        error: e,
        stackTrace: st,
      );
      // Revertir en caso de error
      if (mounted) {
        final revert = state.tareas.map((t) {
          if (t.id == tareaId) return t.copyWith(completada: !nuevoEstado);
          return t;
        }).toList();
        state = state.copyWith(tareas: revert, guardando: false);
      }
    }
  }

  /// Nombre del usuario que completó una tarea (para mostrar en UI).
  String? completadoPor(String tareaId) => null;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// Provider de la guía diaria para un lote.
final guiaDiariaProvider = StateNotifierProvider.autoDispose
    .family<GuiaDiariaNotifier, GuiaDiariaState, Lote>((ref, lote) {
      final datasource = ref.watch(_tareasDatasourceProvider);
      final usuario = ref.watch(currentUserProvider);
      final userId = usuario?.id ?? 'anon';
      return GuiaDiariaNotifier(lote, datasource, userId);
    });
