/// Providers para programas de vacunación.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/core/errors/error_messages.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../../infrastructure/datasources/programa_vacunacion_datasource.dart';

/// Provider del datasource de programas de vacunación.
final programaVacunacionDatasourceProvider =
    Provider<ProgramaVacunacionDatasource>((ref) {
      return ProgramaVacunacionDatasource(
        firestore: FirebaseFirestore.instance,
      );
    });

/// Estado de programas de vacunación.
class ProgramasVacunacionState {
  final List<ProgramaVacunacion> programas;
  final ProgramaVacunacion? programaSeleccionado;
  final bool isLoading;
  final String? error;

  const ProgramasVacunacionState({
    this.programas = const [],
    this.programaSeleccionado,
    this.isLoading = false,
    this.error,
  });

  factory ProgramasVacunacionState.initial() {
    return const ProgramasVacunacionState();
  }

  ProgramasVacunacionState copyWith({
    List<ProgramaVacunacion>? programas,
    ProgramaVacunacion? programaSeleccionado,
    bool? isLoading,
    String? error,
  }) {
    return ProgramasVacunacionState(
      programas: programas ?? this.programas,
      programaSeleccionado: programaSeleccionado ?? this.programaSeleccionado,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier para gestión de programas de vacunación.
class ProgramasVacunacionNotifier
    extends StateNotifier<ProgramasVacunacionState> {
  final ProgramaVacunacionDatasource _datasource;

  ProgramasVacunacionNotifier(this._datasource)
    : super(ProgramasVacunacionState.initial());

  /// Inicializa con los programas predefinidos.
  void inicializarProgramasPredefinidos() {
    state = state.copyWith(
      programas: [
        ProgramaVacunacion.plantillaBroiler(),
        ProgramaVacunacion.plantillaPonedora(),
      ],
      isLoading: false,
    );
  }

  /// Carga programas desde el repositorio.
  Future<void> cargarProgramas(String granjaId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final programas = await _datasource.obtenerProgramas(granjaId);
      if (programas.isEmpty) {
        // Si no hay programas, usar las plantillas predefinidas
        inicializarProgramasPredefinidos();
      } else {
        state = state.copyWith(programas: programas, isLoading: false);
      }
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_LOADING_PROGRAMS', {'e': '$e'}),
      );
    }
  }

  /// Selecciona un programa.
  void seleccionarPrograma(ProgramaVacunacion programa) {
    state = state.copyWith(programaSeleccionado: programa);
  }

  /// Crea un nuevo programa personalizado.
  void crearPrograma(ProgramaVacunacion programa) {
    state = state.copyWith(programas: [...state.programas, programa]);
  }

  /// Duplica un programa existente.
  ProgramaVacunacion duplicarPrograma(
    ProgramaVacunacion original,
    String nuevoNombre,
  ) {
    final duplicado = original.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: nuevoNombre,
      esPlantilla: false,
    );
    state = state.copyWith(programas: [...state.programas, duplicado]);
    return duplicado;
  }

  /// Actualiza un programa.
  void actualizarPrograma(ProgramaVacunacion programa) {
    final index = state.programas.indexWhere((p) => p.id == programa.id);
    if (index >= 0) {
      final nuevaLista = [...state.programas];
      nuevaLista[index] = programa;
      state = state.copyWith(programas: nuevaLista);
    }
  }

  /// Agrega una vacuna a un programa.
  void agregarVacuna(String programaId, VacunaProgramada vacuna) {
    final index = state.programas.indexWhere((p) => p.id == programaId);
    if (index >= 0) {
      final programa = state.programas[index];
      final programaActualizado = programa.copyWith(
        vacunas: [...programa.vacunas, vacuna],
      );
      actualizarPrograma(programaActualizado);
    }
  }

  /// Elimina una vacuna de un programa.
  void eliminarVacuna(String programaId, String vacunaId) {
    final index = state.programas.indexWhere((p) => p.id == programaId);
    if (index >= 0) {
      final programa = state.programas[index];
      final programaActualizado = programa.copyWith(
        vacunas: programa.vacunas.where((v) => v.id != vacunaId).toList(),
      );
      actualizarPrograma(programaActualizado);
    }
  }

  /// Elimina un programa.
  void eliminarPrograma(String programaId) {
    state = state.copyWith(
      programas: state.programas.where((p) => p.id != programaId).toList(),
      programaSeleccionado: state.programaSeleccionado?.id == programaId
          ? null
          : state.programaSeleccionado,
    );
  }

  /// Limpia el error.
  void limpiarError() {
    state = state.copyWith(error: null);
  }
}

/// Provider del notifier de programas de vacunación.
final programasVacunacionProvider =
    StateNotifierProvider.autoDispose<
      ProgramasVacunacionNotifier,
      ProgramasVacunacionState
    >((ref) {
      final datasource = ref.watch(programaVacunacionDatasourceProvider);
      return ProgramasVacunacionNotifier(datasource)
        ..inicializarProgramasPredefinidos();
    });

/// Provider de programas por tipo de ave.
final programasPorTipoAveProvider =
    Provider.family<List<ProgramaVacunacion>, TipoAveProduccion>((
      ref,
      tipoAve,
    ) {
      final state = ref.watch(programasVacunacionProvider);
      return state.programas.where((p) => p.tipoAve == tipoAve).toList();
    });

/// Provider de vacunas próximas a aplicar.
final vacunasProximasProvider = Provider.family<List<VacunaProgramada>, int>((
  ref,
  diasFuturo,
) {
  final state = ref.watch(programasVacunacionProvider);
  final List<VacunaProgramada> proximas = [];

  for (final programa in state.programas) {
    proximas.addAll(programa.vacunas.where((v) => v.edadDias <= diasFuturo));
  }

  proximas.sort((a, b) => a.edadDias.compareTo(b.edadDias));
  return proximas;
});
