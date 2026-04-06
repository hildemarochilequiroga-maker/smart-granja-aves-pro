/// Providers para inspecciones de bioseguridad.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/core/errors/error_messages.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../../infrastructure/datasources/inspeccion_bioseguridad_datasource.dart';

/// Provider del datasource de inspecciones de bioseguridad.
final inspeccionBioseguridadDatasourceProvider =
    Provider<InspeccionBioseguridadDatasource>((ref) {
      return InspeccionBioseguridadDatasource(
        firestore: FirebaseFirestore.instance,
      );
    });

/// Estado de inspecciones de bioseguridad.
class InspeccionesBioseguridadState {
  final List<InspeccionBioseguridad> inspecciones;
  final InspeccionBioseguridad? inspeccionEnProgreso;
  final bool isLoading;
  final String? error;

  const InspeccionesBioseguridadState({
    this.inspecciones = const [],
    this.inspeccionEnProgreso,
    this.isLoading = false,
    this.error,
  });

  factory InspeccionesBioseguridadState.initial() {
    return const InspeccionesBioseguridadState();
  }

  InspeccionesBioseguridadState copyWith({
    List<InspeccionBioseguridad>? inspecciones,
    InspeccionBioseguridad? inspeccionEnProgreso,
    bool? isLoading,
    String? error,
    bool clearInspeccionEnProgreso = false,
  }) {
    return InspeccionesBioseguridadState(
      inspecciones: inspecciones ?? this.inspecciones,
      inspeccionEnProgreso: clearInspeccionEnProgreso
          ? null
          : (inspeccionEnProgreso ?? this.inspeccionEnProgreso),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Última inspección realizada.
  InspeccionBioseguridad? get ultimaInspeccion {
    if (inspecciones.isEmpty) return null;
    return inspecciones.reduce((a, b) => a.fecha.isAfter(b.fecha) ? a : b);
  }

  /// Promedio de cumplimiento.
  double get promedioCumplimiento {
    if (inspecciones.isEmpty) return 0;
    return inspecciones
            .map((i) => i.porcentajeCumplimiento)
            .reduce((a, b) => a + b) /
        inspecciones.length;
  }
}

/// Notifier para gestión de inspecciones de bioseguridad.
class InspeccionesBioseguridadNotifier
    extends StateNotifier<InspeccionesBioseguridadState> {
  final InspeccionBioseguridadDatasource _datasource;

  InspeccionesBioseguridadNotifier(this._datasource)
    : super(InspeccionesBioseguridadState.initial());

  /// Carga inspecciones de una granja.
  Future<void> cargarInspecciones(String granjaId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final inspecciones = await _datasource.obtenerInspecciones(granjaId);
      state = state.copyWith(inspecciones: inspecciones, isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_LOADING_INSPECTIONS', {'e': '$e'}),
      );
    }
  }

  /// Inicia una nueva inspección con el checklist estándar.
  void iniciarNuevaInspeccion({
    required String granjaId,
    required String inspectorId,
    required String inspectorNombre,
    String? galponId,
  }) {
    final inspeccion = InspeccionBioseguridad(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      granjaId: granjaId,
      galponId: galponId,
      fecha: DateTime.now(),
      items: PlantillaBioseguridad.itemsEstandar(),
      inspectorId: inspectorId,
      inspectorNombre: inspectorNombre,
      fechaCreacion: DateTime.now(),
    );
    state = state.copyWith(inspeccionEnProgreso: inspeccion);
  }

  /// Actualiza la ubicación de la inspección en progreso.
  void actualizarUbicacion({required String granjaId, String? galponId}) {
    if (state.inspeccionEnProgreso == null) return;

    state = state.copyWith(
      inspeccionEnProgreso: state.inspeccionEnProgreso!.copyWith(
        granjaId: granjaId,
        galponId: galponId,
      ),
    );
  }

  /// Actualiza el estado de un item en la inspección.
  void actualizarItem(String codigoItem, EstadoBioseguridad nuevoEstado) {
    if (state.inspeccionEnProgreso == null) return;

    final items = state.inspeccionEnProgreso!.items.map((item) {
      if (item.codigo == codigoItem) {
        return item.copyWith(estado: nuevoEstado);
      }
      return item;
    }).toList();

    state = state.copyWith(
      inspeccionEnProgreso: state.inspeccionEnProgreso!.copyWith(items: items),
    );
  }

  /// Agrega observación a un item.
  void agregarObservacionItem(String codigoItem, String observacion) {
    if (state.inspeccionEnProgreso == null) return;

    final items = state.inspeccionEnProgreso!.items.map((item) {
      if (item.codigo == codigoItem) {
        return item.copyWith(observacion: observacion);
      }
      return item;
    }).toList();

    state = state.copyWith(
      inspeccionEnProgreso: state.inspeccionEnProgreso!.copyWith(items: items),
    );
  }

  /// Agrega foto de evidencia a un item.
  void agregarEvidenciaItem(String codigoItem, String urlEvidencia) {
    if (state.inspeccionEnProgreso == null) return;

    final items = state.inspeccionEnProgreso!.items.map((item) {
      if (item.codigo == codigoItem) {
        return item.copyWith(evidenciaUrl: urlEvidencia);
      }
      return item;
    }).toList();

    state = state.copyWith(
      inspeccionEnProgreso: state.inspeccionEnProgreso!.copyWith(items: items),
    );
  }

  /// Establece observaciones generales.
  void setObservacionesGenerales(String observaciones) {
    if (state.inspeccionEnProgreso == null) return;
    state = state.copyWith(
      inspeccionEnProgreso: state.inspeccionEnProgreso!.copyWith(
        observaciones: observaciones,
      ),
    );
  }

  /// Establece acciones correctivas.
  void setAccionesCorrectivas(String acciones) {
    if (state.inspeccionEnProgreso == null) return;
    state = state.copyWith(
      inspeccionEnProgreso: state.inspeccionEnProgreso!.copyWith(
        accionesCorrectivas: acciones,
      ),
    );
  }

  /// Guarda la inspección en progreso.
  Future<InspeccionBioseguridad> guardarInspeccion() async {
    if (state.inspeccionEnProgreso == null) {
      throw StateError(ErrorMessages.get('ERR_NO_INSPECTION_IN_PROGRESS'));
    }

    state = state.copyWith(isLoading: true);
    try {
      final inspeccion = state.inspeccionEnProgreso!;
      final idPersistido = await _datasource.crearInspeccion(inspeccion);
      final inspeccionGuardada = inspeccion.copyWith(id: idPersistido);
      final nuevaLista = [...state.inspecciones, inspeccionGuardada]
        ..sort((a, b) => b.fecha.compareTo(a.fecha));
      state = state.copyWith(
        inspecciones: nuevaLista,
        isLoading: false,
        clearInspeccionEnProgreso: true,
      );
      return inspeccionGuardada;
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_SAVING_INSPECTION', {'e': '$e'}),
      );
      rethrow;
    }
  }

  /// Cancela la inspección en progreso.
  void cancelarInspeccion() {
    state = state.copyWith(clearInspeccionEnProgreso: true);
  }

  /// Elimina una inspección.
  void eliminarInspeccion(String inspeccionId) {
    state = state.copyWith(
      inspecciones: state.inspecciones
          .where((i) => i.id != inspeccionId)
          .toList(),
    );
  }

  /// Limpia el error.
  void limpiarError() {
    state = state.copyWith(error: null);
  }
}

/// Provider del notifier de inspecciones de bioseguridad.
final inspeccionesBioseguridadProvider =
    StateNotifierProvider.autoDispose<
      InspeccionesBioseguridadNotifier,
      InspeccionesBioseguridadState
    >((ref) {
      final datasource = ref.watch(inspeccionBioseguridadDatasourceProvider);
      return InspeccionesBioseguridadNotifier(datasource);
    });

/// Provider de items agrupados por categoría.
final itemsPorCategoriaProvider =
    Provider<Map<CategoriaBioseguridad, List<ItemInspeccion>>>((ref) {
      final state = ref.watch(inspeccionesBioseguridadProvider);
      if (state.inspeccionEnProgreso == null) return {};

      final Map<CategoriaBioseguridad, List<ItemInspeccion>> agrupados = {};
      for (final item in state.inspeccionEnProgreso!.items) {
        agrupados.putIfAbsent(item.categoria, () => []).add(item);
      }
      return agrupados;
    });

/// Provider de progreso de la inspección actual.
final progresoInspeccionProvider = Provider<double>((ref) {
  final state = ref.watch(inspeccionesBioseguridadProvider);
  if (state.inspeccionEnProgreso == null) return 0;

  final items = state.inspeccionEnProgreso!.items;
  final evaluados = items
      .where((i) => i.estado != EstadoBioseguridad.pendiente)
      .length;
  return items.isEmpty ? 0 : evaluados / items.length;
});

/// Stream de inspecciones de bioseguridad por granja.
final inspeccionesBioseguridadStreamProvider = StreamProvider.autoDispose
    .family<List<InspeccionBioseguridad>, String>((ref, granjaId) {
      final datasource = ref.watch(inspeccionBioseguridadDatasourceProvider);
      return datasource.watchInspecciones(granjaId);
    });
