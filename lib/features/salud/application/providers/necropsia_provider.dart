/// Providers para gestión de necropsias.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/core/errors/error_messages.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../../infrastructure/datasources/necropsia_datasource.dart';

/// Provider del datasource de necropsias.
final necropsiaDatasourceProvider = Provider<NecropsiaDatasource>((ref) {
  return NecropsiaDatasource(firestore: FirebaseFirestore.instance);
});

/// Estado de necropsias.
class NecropsiasState {
  final List<Necropsia> necropsias;
  final Necropsia? necropsiaSeleccionada;
  final Map<EnfermedadAvicola, int> estadisticasEnfermedades;
  final bool isLoading;
  final String? error;

  const NecropsiasState({
    this.necropsias = const [],
    this.necropsiaSeleccionada,
    this.estadisticasEnfermedades = const {},
    this.isLoading = false,
    this.error,
  });

  factory NecropsiasState.initial() {
    return const NecropsiasState();
  }

  NecropsiasState copyWith({
    List<Necropsia>? necropsias,
    Necropsia? necropsiaSeleccionada,
    Map<EnfermedadAvicola, int>? estadisticasEnfermedades,
    bool? isLoading,
    String? error,
  }) {
    return NecropsiasState(
      necropsias: necropsias ?? this.necropsias,
      necropsiaSeleccionada:
          necropsiaSeleccionada ?? this.necropsiaSeleccionada,
      estadisticasEnfermedades:
          estadisticasEnfermedades ?? this.estadisticasEnfermedades,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Necropsias con diagnóstico confirmado.
  List<Necropsia> get necropsiasConfirmadas {
    return necropsias.where((n) => n.diagnosticoConfirmado != null).toList();
  }

  /// Necropsias pendientes de diagnóstico.
  List<Necropsia> get necropsiaPendientes {
    return necropsias.where((n) => n.diagnosticoConfirmado == null).toList();
  }

  /// Necropsias con muestras de laboratorio pendientes.
  List<Necropsia> get necropsiasConMuestrasPendientes {
    return necropsias.where((n) {
      return n.muestrasLaboratorio.any((m) => m.resultado == null);
    }).toList();
  }

  /// Enfermedades más frecuentes.
  List<MapEntry<EnfermedadAvicola, int>> get enfermedadesMasFrecuentes {
    final entries = estadisticasEnfermedades.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries.take(5).toList();
  }
}

/// Notifier para gestión de necropsias.
class NecropsiasNotifier extends StateNotifier<NecropsiasState> {
  final NecropsiaDatasource _datasource;
  String? _granjaId;

  NecropsiasNotifier(this._datasource) : super(NecropsiasState.initial());

  /// Carga necropsias de una granja.
  Future<void> cargarNecropsias(String granjaId) async {
    _granjaId = granjaId;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final necropsias = await _datasource.obtenerNecropsias(granjaId);
      state = state.copyWith(necropsias: necropsias, isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_LOADING_NECROPSIES', {'e': '$e'}),
      );
    }
  }

  /// Carga necropsias de un lote.
  Future<void> cargarNecropsiasLote(String loteId) async {
    if (_granjaId == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final necropsias = await _datasource.obtenerNecropsiasPorlote(
        _granjaId!,
        loteId,
      );
      state = state.copyWith(necropsias: necropsias, isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_LOADING_BATCH_NECROPSIES', {'e': '$e'}),
      );
    }
  }

  /// Selecciona una necropsia para ver detalle.
  void seleccionarNecropsia(Necropsia necropsia) {
    state = state.copyWith(necropsiaSeleccionada: necropsia);
  }

  /// Limpia la selección.
  void limpiarSeleccion() {
    state = state.copyWith(necropsiaSeleccionada: null);
  }

  /// Registra una nueva necropsia.
  Future<void> registrarNecropsia({
    required String granjaId,
    required String galponId,
    required String loteId,
    required int numeroAvesExaminadas,
    required String realizadoPor,
    required List<HallazgoNecropsia> hallazgos,
    String? diagnosticoPresuntivo,
    EnfermedadAvicola? enfermedadDetectada,
    List<MuestraLaboratorio>? muestrasLaboratorio,
    String? recomendaciones,
    List<String>? fotografias,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final necropsia = Necropsia(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        granjaId: granjaId,
        galponId: galponId,
        loteId: loteId,
        fecha: DateTime.now(),
        numeroAvesExaminadas: numeroAvesExaminadas,
        realizadoPor: realizadoPor,
        hallazgos: hallazgos,
        diagnosticoPresuntivo: diagnosticoPresuntivo,
        enfermedadDetectada: enfermedadDetectada,
        muestrasLaboratorio: muestrasLaboratorio ?? [],
        recomendaciones: recomendaciones,
        fotografias: fotografias ?? [],
        fechaCreacion: DateTime.now(),
      );

      await _datasource.crearNecropsia(granjaId, necropsia);

      state = state.copyWith(
        necropsias: [...state.necropsias, necropsia],
        isLoading: false,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_REGISTERING_NECROPSY', {'e': '$e'}),
      );
    }
  }

  /// Actualiza resultados de laboratorio.
  Future<void> actualizarResultadoLaboratorio({
    required String necropsiaId,
    required String muestraId,
    required String resultado,
    required DateTime fechaResultado,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final necropsias = state.necropsias.map((n) {
        if (n.id == necropsiaId) {
          final muestrasActualizadas = n.muestrasLaboratorio.map((m) {
            if (m.id == muestraId) {
              return MuestraLaboratorio(
                id: m.id,
                tipo: m.tipo,
                fechaEnvio: m.fechaEnvio,
                laboratorio: m.laboratorio,
                resultado: resultado,
                fechaResultado: fechaResultado,
              );
            }
            return m;
          }).toList();
          return n.copyWith(muestrasLaboratorio: muestrasActualizadas);
        }
        return n;
      }).toList();

      // Persistir en Firestore
      if (_granjaId != null) {
        final updated = necropsias.firstWhere((n) => n.id == necropsiaId);
        await _datasource.actualizarNecropsia(_granjaId!, updated);
      }

      state = state.copyWith(necropsias: necropsias, isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_UPDATING_RESULT', {'e': '$e'}),
      );
    }
  }

  /// Confirma el diagnóstico de una necropsia.
  Future<void> confirmarDiagnostico({
    required String necropsiaId,
    required String diagnosticoConfirmado,
    EnfermedadAvicola? enfermedadDetectada,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final necropsias = state.necropsias.map((n) {
        if (n.id == necropsiaId) {
          return n.copyWith(
            diagnosticoConfirmado: diagnosticoConfirmado,
            enfermedadDetectada: enfermedadDetectada,
          );
        }
        return n;
      }).toList();

      // Persistir en Firestore
      if (_granjaId != null) {
        final updated = necropsias.firstWhere((n) => n.id == necropsiaId);
        await _datasource.actualizarNecropsia(_granjaId!, updated);
      }

      // Actualizar estadísticas si hay enfermedad detectada
      final Map<EnfermedadAvicola, int> stats = Map.from(
        state.estadisticasEnfermedades,
      );
      if (enfermedadDetectada != null) {
        stats[enfermedadDetectada] = (stats[enfermedadDetectada] ?? 0) + 1;
      }

      state = state.copyWith(
        necropsias: necropsias,
        estadisticasEnfermedades: stats,
        isLoading: false,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_CONFIRMING_DIAGNOSIS', {'e': '$e'}),
      );
    }
  }

  /// Elimina una necropsia.
  Future<void> eliminarNecropsia(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      if (_granjaId != null) {
        await _datasource.eliminarNecropsia(_granjaId!, id);
      }
      final necropsias = state.necropsias.where((n) => n.id != id).toList();
      state = state.copyWith(necropsias: necropsias, isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_DELETING_NECROPSY', {'e': '$e'}),
      );
    }
  }

  /// Carga estadísticas de enfermedades.
  Future<void> cargarEstadisticasEnfermedades({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Calcular estadísticas a partir de las necropsias existentes
      final necropsiasFiltradas = state.necropsias.where((n) {
        return n.fecha.isAfter(fechaInicio) &&
            n.fecha.isBefore(fechaFin.add(const Duration(days: 1)));
      }).toList();

      final Map<EnfermedadAvicola, int> stats = {};
      for (final necropsia in necropsiasFiltradas) {
        if (necropsia.enfermedadDetectada != null) {
          stats[necropsia.enfermedadDetectada!] =
              (stats[necropsia.enfermedadDetectada!] ?? 0) + 1;
        }
      }

      state = state.copyWith(estadisticasEnfermedades: stats, isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_LOADING_STATISTICS', {'e': '$e'}),
      );
    }
  }
}

/// Provider principal para necropsias.
final necropsiasNotifierProvider =
    StateNotifierProvider.autoDispose<NecropsiasNotifier, NecropsiasState>((
      ref,
    ) {
      final datasource = ref.watch(necropsiaDatasourceProvider);
      return NecropsiasNotifier(datasource);
    });

/// Provider de necropsias filtradas por lote.
final necropsiasLoteProvider = Provider.family<List<Necropsia>, String>((
  ref,
  loteId,
) {
  final state = ref.watch(necropsiasNotifierProvider);
  return state.necropsias.where((n) => n.loteId == loteId).toList();
});

/// Provider de necropsia seleccionada.
final necropsiaSeleccionadaProvider = Provider<Necropsia?>((ref) {
  return ref.watch(necropsiasNotifierProvider).necropsiaSeleccionada;
});

/// Provider de necropsias pendientes de diagnóstico.
final necropsiaPendientesProvider = Provider<List<Necropsia>>((ref) {
  return ref.watch(necropsiasNotifierProvider).necropsiaPendientes;
});

/// Provider de estadísticas de enfermedades.
final estadisticasEnfermedadesProvider = Provider<Map<EnfermedadAvicola, int>>((
  ref,
) {
  return ref.watch(necropsiasNotifierProvider).estadisticasEnfermedades;
});
