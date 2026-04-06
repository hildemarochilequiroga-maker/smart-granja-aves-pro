/// Providers para gestión de uso de antimicrobianos.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/core/errors/error_messages.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../../infrastructure/datasources/uso_antimicrobiano_datasource.dart';

/// Provider del datasource de uso de antimicrobianos.
final usoAntimicrobianoDatasourceProvider =
    Provider<UsoAntimicrobianoDatasource>((ref) {
      return UsoAntimicrobianoDatasource(firestore: FirebaseFirestore.instance);
    });

/// Estado de uso de antimicrobianos.
class UsoAntimicrobianosState {
  final List<UsoAntimicrobiano> usos;
  final UsoAntimicrobiano? usoSeleccionado;
  final List<UsoAntimicrobiano> lotesEnRetiro;
  final Map<FamiliaAntimicrobiano, int> usoPorFamilia;
  final ReporteAntimicrobianos? reporteActual;
  final bool isLoading;
  final String? error;

  const UsoAntimicrobianosState({
    this.usos = const [],
    this.usoSeleccionado,
    this.lotesEnRetiro = const [],
    this.usoPorFamilia = const {},
    this.reporteActual,
    this.isLoading = false,
    this.error,
  });

  factory UsoAntimicrobianosState.initial() {
    return const UsoAntimicrobianosState();
  }

  UsoAntimicrobianosState copyWith({
    List<UsoAntimicrobiano>? usos,
    UsoAntimicrobiano? usoSeleccionado,
    List<UsoAntimicrobiano>? lotesEnRetiro,
    Map<FamiliaAntimicrobiano, int>? usoPorFamilia,
    ReporteAntimicrobianos? reporteActual,
    bool? isLoading,
    String? error,
  }) {
    return UsoAntimicrobianosState(
      usos: usos ?? this.usos,
      usoSeleccionado: usoSeleccionado ?? this.usoSeleccionado,
      lotesEnRetiro: lotesEnRetiro ?? this.lotesEnRetiro,
      usoPorFamilia: usoPorFamilia ?? this.usoPorFamilia,
      reporteActual: reporteActual ?? this.reporteActual,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Usos activos (en período de tratamiento o retiro).
  List<UsoAntimicrobiano> get usosActivos {
    final ahora = DateTime.now();
    return usos
        .where(
          (u) => u.fechaFin.isAfter(ahora) || u.fechaLiberacion.isAfter(ahora),
        )
        .toList();
  }

  /// Verifica si hay lotes en retiro.
  bool get hayLotesEnRetiro => lotesEnRetiro.isNotEmpty;

  /// Uso de antimicrobianos críticos (HP-CIA).
  List<UsoAntimicrobiano> get usoAntimicrobianosCriticos {
    return usos.where((u) {
      return u.categoriaOms == CategoriaOmsAntimicrobiano.criticamente;
    }).toList();
  }

  /// Porcentaje de uso de antimicrobianos críticos.
  double get porcentajeUsoCritico {
    if (usos.isEmpty) return 0;
    return (usoAntimicrobianosCriticos.length / usos.length) * 100;
  }
}

/// Notifier para gestión de uso de antimicrobianos.
class UsoAntimicrobianosNotifier
    extends StateNotifier<UsoAntimicrobianosState> {
  final UsoAntimicrobianoDatasource _datasource;

  UsoAntimicrobianosNotifier(this._datasource)
    : super(UsoAntimicrobianosState.initial());

  /// Carga usos de antimicrobianos de una granja.
  Future<void> cargarUsos(String granjaId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final usos = await _datasource.obtenerUsos(granjaId);
      state = state.copyWith(usos: usos, isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_LOADING_ANTIMICROBIAL_USES', {'e': '$e'}),
      );
    }
  }

  /// Carga lotes en período de retiro.
  Future<void> cargarLotesEnRetiro(String granjaId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final ahora = DateTime.now();
      final enRetiro = state.usos
          .where((u) => u.fechaLiberacion.isAfter(ahora))
          .toList();
      state = state.copyWith(lotesEnRetiro: enRetiro, isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_LOADING_WITHDRAWAL_BATCHES', {'e': '$e'}),
      );
    }
  }

  /// Selecciona un uso para ver detalle.
  void seleccionarUso(UsoAntimicrobiano uso) {
    state = state.copyWith(usoSeleccionado: uso);
  }

  /// Limpia la selección.
  void limpiarSeleccion() {
    state = state.copyWith(usoSeleccionado: null);
  }

  /// Registra un nuevo uso de antimicrobiano.
  Future<void> registrarUso({
    required String granjaId,
    required String galponId,
    required String loteId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String antimicrobiano,
    required String principioActivo,
    required FamiliaAntimicrobiano familia,
    required CategoriaOmsAntimicrobiano categoriaOms,
    required double dosis,
    required String unidadDosis,
    required ViaAdministracion viaAdministracion,
    required MotivoUsoAntimicrobiano motivoUso,
    required int tiempoRetiro,
    String? diagnostico,
    EnfermedadAvicola? enfermedadTratada,
    int? avesAfectadas,
    String? veterinarioId,
    String? veterinarioNombre,
    String? numeroReceta,
    String? proveedor,
    String? loteProducto,
    DateTime? fechaVencimiento,
    String? observaciones,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final fechaLiberacion = fechaFin.add(Duration(days: tiempoRetiro));

      final uso = UsoAntimicrobiano(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        granjaId: granjaId,
        galponId: galponId,
        loteId: loteId,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        antimicrobiano: antimicrobiano,
        principioActivo: principioActivo,
        familia: familia,
        categoriaOms: categoriaOms,
        dosis: dosis,
        unidadDosis: unidadDosis,
        viaAdministracion: viaAdministracion,
        motivoUso: motivoUso,
        diagnostico: diagnostico,
        enfermedadTratada: enfermedadTratada,
        avesAfectadas: avesAfectadas ?? 0,
        tiempoRetiro: tiempoRetiro,
        fechaLiberacion: fechaLiberacion,
        veterinarioId: veterinarioId,
        veterinarioNombre: veterinarioNombre,
        numeroReceta: numeroReceta,
        proveedor: proveedor,
        loteProducto: loteProducto,
        fechaVencimiento: fechaVencimiento,
        observaciones: observaciones,
        creadoPor: 'Usuario',
        fechaCreacion: DateTime.now(),
      );

      state = state.copyWith(usos: [...state.usos, uso], isLoading: false);

      // Actualizar lotes en retiro si aplica
      if (fechaLiberacion.isAfter(DateTime.now())) {
        state = state.copyWith(lotesEnRetiro: [...state.lotesEnRetiro, uso]);
      }
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_REGISTERING_ANTIMICROBIAL_USE', {'e': '$e'}),
      );
    }
  }

  /// Verifica si un lote está en retiro.
  bool verificarRetiroActivo(String loteId) {
    final ahora = DateTime.now();
    return state.usos.any(
      (u) => u.loteId == loteId && u.fechaLiberacion.isAfter(ahora),
    );
  }

  /// Obtiene la fecha de liberación de un lote.
  DateTime? obtenerFechaLiberacion(String loteId) {
    final usosLote = state.usos.where((u) => u.loteId == loteId).toList();
    if (usosLote.isEmpty) return null;

    final ahora = DateTime.now();
    final enRetiro = usosLote
        .where((u) => u.fechaLiberacion.isAfter(ahora))
        .toList();
    if (enRetiro.isEmpty) return null;

    // Retornar la fecha de liberación más lejana
    enRetiro.sort((a, b) => b.fechaLiberacion.compareTo(a.fechaLiberacion));
    return enRetiro.first.fechaLiberacion;
  }

  /// Genera reporte de uso de antimicrobianos.
  Future<void> generarReporte({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final usosPeriodo = state.usos.where((u) {
        return u.fechaInicio.isAfter(fechaInicio) &&
            u.fechaFin.isBefore(fechaFin);
      }).toList();

      // Calcular uso por familia
      final porFamilia = <FamiliaAntimicrobiano, int>{};
      for (final uso in usosPeriodo) {
        porFamilia[uso.familia] = (porFamilia[uso.familia] ?? 0) + 1;
      }

      // Calcular uso por categoría OMS
      final porCategoria = <CategoriaOmsAntimicrobiano, int>{};
      for (final uso in usosPeriodo) {
        porCategoria[uso.categoriaOms] =
            (porCategoria[uso.categoriaOms] ?? 0) + 1;
      }

      // Calcular uso por motivo
      final porMotivo = <MotivoUsoAntimicrobiano, int>{};
      for (final uso in usosPeriodo) {
        porMotivo[uso.motivoUso] = (porMotivo[uso.motivoUso] ?? 0) + 1;
      }

      final reporte = ReporteAntimicrobianos(
        granjaId: granjaId,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        registros: usosPeriodo,
        totalTratamientos: usosPeriodo.length,
        totalAvesTratadas: usosPeriodo.fold<int>(
          0,
          (total, u) => total + u.avesAfectadas,
        ),
        usoPorFamilia: porFamilia,
        usoPorCategoria: porCategoria,
        usoPorMotivo: porMotivo,
      );

      state = state.copyWith(
        usoPorFamilia: porFamilia,
        reporteActual: reporte,
        isLoading: false,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_GENERATING_REPORT', {'e': '$e'}),
      );
    }
  }

  /// Actualiza un uso existente.
  Future<void> actualizarUso(UsoAntimicrobiano uso) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final usos = state.usos.map((u) {
        if (u.id == uso.id) return uso;
        return u;
      }).toList();
      state = state.copyWith(usos: usos, isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_UPDATING_USE', {'e': '$e'}),
      );
    }
  }

  /// Elimina un uso.
  Future<void> eliminarUso(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final usos = state.usos.where((u) => u.id != id).toList();
      final lotesEnRetiro = state.lotesEnRetiro
          .where((u) => u.id != id)
          .toList();
      state = state.copyWith(
        usos: usos,
        lotesEnRetiro: lotesEnRetiro,
        isLoading: false,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_DELETING_USE', {'e': '$e'}),
      );
    }
  }
}

/// Provider principal para uso de antimicrobianos.
final usoAntimicrobianosNotifierProvider =
    StateNotifierProvider.autoDispose<
      UsoAntimicrobianosNotifier,
      UsoAntimicrobianosState
    >((ref) {
      final datasource = ref.watch(usoAntimicrobianoDatasourceProvider);
      return UsoAntimicrobianosNotifier(datasource);
    });

/// Provider de usos filtrados por lote.
final usosLoteProvider = Provider.family<List<UsoAntimicrobiano>, String>((
  ref,
  loteId,
) {
  final state = ref.watch(usoAntimicrobianosNotifierProvider);
  return state.usos.where((u) => u.loteId == loteId).toList();
});

/// Provider de lotes en período de retiro.
final lotesEnRetiroProvider = Provider<List<UsoAntimicrobiano>>((ref) {
  return ref.watch(usoAntimicrobianosNotifierProvider).lotesEnRetiro;
});

/// Provider para verificar si un lote está en retiro.
final loteEnRetiroProvider = Provider.family<bool, String>((ref, loteId) {
  final notifier = ref.watch(usoAntimicrobianosNotifierProvider.notifier);
  return notifier.verificarRetiroActivo(loteId);
});

/// Provider de fecha de liberación de un lote.
final fechaLiberacionLoteProvider = Provider.family<DateTime?, String>((
  ref,
  loteId,
) {
  final notifier = ref.watch(usoAntimicrobianosNotifierProvider.notifier);
  return notifier.obtenerFechaLiberacion(loteId);
});

/// Provider del reporte actual.
final reporteAntimicrobianosProvider = Provider<ReporteAntimicrobianos?>((ref) {
  return ref.watch(usoAntimicrobianosNotifierProvider).reporteActual;
});

/// Provider de uso por familia.
final usoPorFamiliaProvider = Provider<Map<FamiliaAntimicrobiano, int>>((ref) {
  return ref.watch(usoAntimicrobianosNotifierProvider).usoPorFamilia;
});

/// Provider de usos de antimicrobianos críticos.
final usosCriticosProvider = Provider<List<UsoAntimicrobiano>>((ref) {
  return ref
      .watch(usoAntimicrobianosNotifierProvider)
      .usoAntimicrobianosCriticos;
});
