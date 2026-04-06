/// Providers para gestión del calendario de salud.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/core/errors/error_messages.dart';
import '../../domain/entities/entities.dart';
import '../../infrastructure/datasources/calendario_salud_datasource.dart';

// Datasource provider
final calendarioSaludDatasourceProvider = Provider<CalendarioSaludDatasource>((
  ref,
) {
  return CalendarioSaludDatasource(firestore: FirebaseFirestore.instance);
});

/// Estado del calendario de salud.
class CalendarioSaludState {
  final List<EventoSalud> eventos;
  final EventoSalud? eventoSeleccionado;
  final List<EventoSalud> eventosPendientes;
  final List<EventoSalud> eventosVencidos;
  final List<EventoSalud> eventosProximos;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final bool isLoading;
  final String? error;

  const CalendarioSaludState({
    this.eventos = const [],
    this.eventoSeleccionado,
    this.eventosPendientes = const [],
    this.eventosVencidos = const [],
    this.eventosProximos = const [],
    this.fechaInicio,
    this.fechaFin,
    this.isLoading = false,
    this.error,
  });

  factory CalendarioSaludState.initial() {
    return CalendarioSaludState(
      fechaInicio: DateTime.now().subtract(const Duration(days: 30)),
      fechaFin: DateTime.now().add(const Duration(days: 30)),
    );
  }

  CalendarioSaludState copyWith({
    List<EventoSalud>? eventos,
    EventoSalud? eventoSeleccionado,
    List<EventoSalud>? eventosPendientes,
    List<EventoSalud>? eventosVencidos,
    List<EventoSalud>? eventosProximos,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    bool? isLoading,
    String? error,
  }) {
    return CalendarioSaludState(
      eventos: eventos ?? this.eventos,
      eventoSeleccionado: eventoSeleccionado ?? this.eventoSeleccionado,
      eventosPendientes: eventosPendientes ?? this.eventosPendientes,
      eventosVencidos: eventosVencidos ?? this.eventosVencidos,
      eventosProximos: eventosProximos ?? this.eventosProximos,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Eventos por tipo.
  Map<TipoEventoSalud, List<EventoSalud>> get eventosPorTipo {
    final Map<TipoEventoSalud, List<EventoSalud>> resultado = {};
    for (final evento in eventos) {
      resultado.putIfAbsent(evento.tipo, () => []).add(evento);
    }
    return resultado;
  }

  /// Eventos de hoy.
  List<EventoSalud> get eventosHoy {
    final hoy = DateTime.now();
    return eventos.where((e) {
      return e.fechaProgramada.year == hoy.year &&
          e.fechaProgramada.month == hoy.month &&
          e.fechaProgramada.day == hoy.day;
    }).toList();
  }

  /// Eventos de esta semana.
  List<EventoSalud> get eventosSemana {
    final ahora = DateTime.now();
    final inicioSemana = ahora.subtract(Duration(days: ahora.weekday - 1));
    final finSemana = inicioSemana.add(const Duration(days: 7));
    return eventos.where((e) {
      return e.fechaProgramada.isAfter(inicioSemana) &&
          e.fechaProgramada.isBefore(finSemana);
    }).toList();
  }

  /// Total de eventos vencidos pendientes.
  int get totalVencidos => eventosVencidos.length;

  /// Tiene eventos urgentes.
  bool get tieneEventosUrgentes =>
      eventosVencidos.isNotEmpty ||
      eventos.any((e) => e.prioridad == PrioridadEvento.urgente);
}

/// Notifier para gestión del calendario de salud.
class CalendarioSaludNotifier extends StateNotifier<CalendarioSaludState> {
  final CalendarioSaludDatasource _datasource;
  String? _granjaId;

  CalendarioSaludNotifier(this._datasource)
    : super(CalendarioSaludState.initial());

  /// Carga eventos de una granja.
  Future<void> cargarEventos(String granjaId) async {
    _granjaId = granjaId;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final eventos = await _datasource.obtenerEventos(granjaId);
      state = state.copyWith(eventos: eventos, isLoading: false);
      _actualizarEventosFiltrados();
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_LOADING_EVENTS', {'e': '$e'}),
      );
    }
  }

  /// Carga eventos por rango de fechas.
  Future<void> cargarEventosPorFecha({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
    try {
      final eventos = await _datasource.obtenerEventosPorFecha(
        granjaId: granjaId,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );
      state = state.copyWith(eventos: eventos, isLoading: false);
      _actualizarEventosFiltrados();
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_LOADING_EVENTS', {'e': '$e'}),
      );
    }
  }

  /// Actualiza los eventos filtrados (pendientes, vencidos, próximos).
  void _actualizarEventosFiltrados() {
    final ahora = DateTime.now();
    final en7Dias = ahora.add(const Duration(days: 7));

    final pendientes = state.eventos.where((e) {
      return e.estado == EstadoEventoSalud.pendiente;
    }).toList();

    final vencidos = state.eventos.where((e) {
      return e.estado == EstadoEventoSalud.pendiente &&
          e.fechaProgramada.isBefore(ahora);
    }).toList();

    final proximos = state.eventos.where((e) {
      return e.estado == EstadoEventoSalud.pendiente &&
          e.fechaProgramada.isAfter(ahora) &&
          e.fechaProgramada.isBefore(en7Dias);
    }).toList();

    state = state.copyWith(
      eventosPendientes: pendientes,
      eventosVencidos: vencidos,
      eventosProximos: proximos,
    );
  }

  /// Selecciona un evento para ver detalle.
  void seleccionarEvento(EventoSalud evento) {
    state = state.copyWith(eventoSeleccionado: evento);
  }

  /// Limpia la selección.
  void limpiarSeleccion() {
    state = state.copyWith(eventoSeleccionado: null);
  }

  /// Crea un nuevo evento.
  Future<void> crearEvento({
    required String granjaId,
    required String titulo,
    required TipoEventoSalud tipo,
    required DateTime fechaProgramada,
    required PrioridadEvento prioridad,
    String? galponId,
    String? loteId,
    String? descripcion,
    String? creadoPor,
    int? recordatorioHoras,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final evento = EventoSalud(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        granjaId: granjaId,
        galponId: galponId,
        loteId: loteId,
        titulo: titulo,
        descripcion: descripcion,
        tipo: tipo,
        fechaProgramada: fechaProgramada,
        prioridad: prioridad,
        estado: EstadoEventoSalud.pendiente,
        recordatorioHoras: recordatorioHoras ?? 24,
        creadoPor: creadoPor ?? 'Sistema',
        fechaCreacion: DateTime.now(),
      );

      state = state.copyWith(eventos: [...state.eventos, evento]);
      _actualizarEventosFiltrados();

      await _datasource.crearEvento(granjaId, evento);

      state = state.copyWith(isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_CREATING_EVENT', {'e': '$e'}),
      );
    }
  }

  /// Marca un evento como completado.
  Future<void> completarEvento({
    required String eventoId,
    required String ejecutadoPor,
    String? observaciones,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final eventos = state.eventos.map((e) {
        if (e.id == eventoId) {
          return e.copyWith(
            estado: EstadoEventoSalud.completado,
            fechaEjecucion: DateTime.now(),
            ejecutadoPor: ejecutadoPor,
            observaciones: observaciones ?? e.observaciones,
          );
        }
        return e;
      }).toList();

      state = state.copyWith(eventos: eventos);
      _actualizarEventosFiltrados();

      // Persistir en Firestore
      if (_granjaId != null) {
        await _datasource.completarEvento(
          granjaId: _granjaId!,
          eventoId: eventoId,
          ejecutadoPor: ejecutadoPor,
          observaciones: observaciones,
        );
      }

      state = state.copyWith(isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_COMPLETING_EVENT', {'e': '$e'}),
      );
    }
  }

  /// Cancela un evento.
  Future<void> cancelarEvento({
    required String eventoId,
    required String motivo,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final eventos = state.eventos.map((e) {
        if (e.id == eventoId) {
          return e.copyWith(
            estado: EstadoEventoSalud.cancelado,
            observaciones: motivo,
          );
        }
        return e;
      }).toList();

      state = state.copyWith(eventos: eventos);
      _actualizarEventosFiltrados();

      // Persistir en Firestore
      if (_granjaId != null) {
        await _datasource.cancelarEvento(
          granjaId: _granjaId!,
          eventoId: eventoId,
          motivo: motivo,
        );
      }

      state = state.copyWith(isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_CANCELING_EVENT', {'e': '$e'}),
      );
    }
  }

  /// Reprograma un evento.
  Future<void> reprogramarEvento({
    required String eventoId,
    required DateTime nuevaFecha,
    String? motivo,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final eventos = state.eventos.map((e) {
        if (e.id == eventoId) {
          return e.copyWith(
            fechaProgramada: nuevaFecha,
            observaciones: motivo != null
                ? '${e.observaciones ?? ''}\nReprogramado: $motivo'
                : e.observaciones,
          );
        }
        return e;
      }).toList();

      state = state.copyWith(eventos: eventos);
      _actualizarEventosFiltrados();

      // Persistir en Firestore
      if (_granjaId != null) {
        final updated = eventos.firstWhere((e) => e.id == eventoId);
        await _datasource.actualizarEvento(_granjaId!, updated);
      }

      state = state.copyWith(isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_RESCHEDULING_EVENT', {'e': '$e'}),
      );
    }
  }

  /// Elimina un evento.
  Future<void> eliminarEvento(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      if (_granjaId != null) {
        await _datasource.eliminarEvento(_granjaId!, id);
      }
      final eventos = state.eventos.where((e) => e.id != id).toList();
      state = state.copyWith(eventos: eventos);
      _actualizarEventosFiltrados();
      state = state.copyWith(isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_DELETING_EVENT', {'e': '$e'}),
      );
    }
  }

  /// Crea eventos desde un programa de vacunación.
  Future<void> crearEventosDesdePrograma({
    required String granjaId,
    required String loteId,
    required String programaId,
    required DateTime fechaInicio,
    required List<VacunaProgramada> vacunas,
    String? creadoPor,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final nuevosEventos = <EventoSalud>[];

      for (final vacuna in vacunas) {
        final fechaEvento = fechaInicio.add(Duration(days: vacuna.edadDias));
        final evento = EventoSalud(
          id: '${programaId}_${vacuna.id}',
          granjaId: granjaId,
          loteId: loteId,
          titulo: ErrorMessages.format('EVT_VACCINATION_TITLE', {'name': vacuna.nombre}),
          descripcion: ErrorMessages.format('EVT_VACCINATION_DESC', {'name': vacuna.nombre}),
          tipo: TipoEventoSalud.vacunacion,
          fechaProgramada: fechaEvento,
          prioridad: vacuna.esObligatoria
              ? PrioridadEvento.alta
              : PrioridadEvento.normal,
          estado: EstadoEventoSalud.pendiente,
          creadoPor: creadoPor ?? ErrorMessages.get('LABEL_SYSTEM'),
          fechaCreacion: DateTime.now(),
        );
        nuevosEventos.add(evento);
      }

      state = state.copyWith(eventos: [...state.eventos, ...nuevosEventos]);
      _actualizarEventosFiltrados();

      // Persistir todos los eventos en Firestore
      for (final evento in nuevosEventos) {
        await _datasource.crearEvento(granjaId, evento);
      }

      state = state.copyWith(isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_CREATING_EVENTS_FROM_PROGRAM', {'e': '$e'}),
      );
    }
  }
}

/// Provider principal para calendario de salud.
final calendarioSaludNotifierProvider =
    StateNotifierProvider.autoDispose<
      CalendarioSaludNotifier,
      CalendarioSaludState
    >((ref) {
      final datasource = ref.watch(calendarioSaludDatasourceProvider);
      return CalendarioSaludNotifier(datasource);
    });

/// Provider de eventos filtrados por tipo.
final eventosPorTipoProvider =
    Provider.family<List<EventoSalud>, TipoEventoSalud>((ref, tipo) {
      final state = ref.watch(calendarioSaludNotifierProvider);
      return state.eventos.where((e) => e.tipo == tipo).toList();
    });

/// Provider de eventos filtrados por lote.
final eventosLoteProvider = Provider.family<List<EventoSalud>, String>((
  ref,
  loteId,
) {
  final state = ref.watch(calendarioSaludNotifierProvider);
  return state.eventos.where((e) => e.loteId == loteId).toList();
});

/// Provider de evento seleccionado.
final eventoSeleccionadoProvider = Provider<EventoSalud?>((ref) {
  return ref.watch(calendarioSaludNotifierProvider).eventoSeleccionado;
});

/// Provider de eventos pendientes.
final eventosPendientesProvider = Provider<List<EventoSalud>>((ref) {
  return ref.watch(calendarioSaludNotifierProvider).eventosPendientes;
});

/// Provider de eventos vencidos.
final eventosVencidosProvider = Provider<List<EventoSalud>>((ref) {
  return ref.watch(calendarioSaludNotifierProvider).eventosVencidos;
});

/// Provider de eventos próximos (7 días).
final eventosProximosProvider = Provider<List<EventoSalud>>((ref) {
  return ref.watch(calendarioSaludNotifierProvider).eventosProximos;
});

/// Provider de eventos de hoy.
final eventosHoyProvider = Provider<List<EventoSalud>>((ref) {
  return ref.watch(calendarioSaludNotifierProvider).eventosHoy;
});

/// Provider de eventos de esta semana.
final eventosSemanaProvider = Provider<List<EventoSalud>>((ref) {
  return ref.watch(calendarioSaludNotifierProvider).eventosSemana;
});

/// Provider de conteo de eventos vencidos.
final conteoVencidosProvider = Provider<int>((ref) {
  return ref.watch(calendarioSaludNotifierProvider).totalVencidos;
});

/// Provider de alerta de eventos urgentes.
final tieneEventosUrgentesProvider = Provider<bool>((ref) {
  return ref.watch(calendarioSaludNotifierProvider).tieneEventosUrgentes;
});
