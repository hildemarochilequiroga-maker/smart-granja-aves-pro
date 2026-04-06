import 'package:equatable/equatable.dart';

import '../../domain/entities/lote.dart';
import '../../domain/enums/estado_lote.dart';
import '../../domain/enums/tipo_ave.dart';

/// Estado para operaciones de lotes.
///
/// Utiliza sealed class para tipado seguro y exhaustivo.
sealed class LoteState extends Equatable {
  const LoteState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial.
final class LoteInitial extends LoteState {
  const LoteInitial();
}

/// Estado de carga (preserva datos previos para UX sin parpadeo).
final class LoteLoading extends LoteState {
  const LoteLoading({this.mensaje, this.lote, this.lotes});

  final String? mensaje;
  final Lote? lote;
  final List<Lote>? lotes;

  @override
  List<Object?> get props => [mensaje, lote, lotes];
}

/// Estado de éxito con un lote.
final class LoteSuccess extends LoteState {
  const LoteSuccess({required this.lote, this.mensaje});

  final Lote lote;
  final String? mensaje;

  @override
  List<Object?> get props => [lote, mensaje];
}

/// Estado de éxito con lista de lotes.
final class LotesLoaded extends LoteState {
  const LotesLoaded({required this.lotes});

  final List<Lote> lotes;

  @override
  List<Object?> get props => [lotes];
}

/// Estado de error (preserva datos previos para retry).
final class LoteError extends LoteState {
  const LoteError({required this.mensaje, this.code, this.lote, this.lotes});

  final String mensaje;
  final String? code;
  final Lote? lote;
  final List<Lote>? lotes;

  @override
  List<Object?> get props => [mensaje, code, lote, lotes];
}

/// Estado de lote eliminado.
final class LoteDeleted extends LoteState {
  const LoteDeleted({this.mensaje});

  final String? mensaje;

  @override
  List<Object?> get props => [mensaje];
}

// =============================================================================
// EXTENSIONES DE ESTADO
// =============================================================================

extension LoteStateX on LoteState {
  /// Verifica si está cargando.
  bool get isLoading => this is LoteLoading;

  /// Verifica si tiene error.
  bool get hasError => this is LoteError;

  /// Verifica si tiene éxito.
  bool get isSuccess => this is LoteSuccess || this is LotesLoaded;

  /// Obtiene el lote si existe (incluye datos previos en Loading/Error).
  Lote? get lote => switch (this) {
    LoteSuccess(:final lote) => lote,
    LoteLoading(:final lote) => lote,
    LoteError(:final lote) => lote,
    _ => null,
  };

  /// Obtiene la lista de lotes si existe (incluye datos previos en Loading/Error).
  List<Lote> get lotes => switch (this) {
    LotesLoaded(:final lotes) => lotes,
    LoteLoading(lotes: final l?) => l,
    LoteError(lotes: final l?) => l,
    _ => [],
  };

  /// Obtiene el mensaje de error si existe.
  String? get errorMessage => switch (this) {
    LoteError(:final mensaje) => mensaje,
    _ => null,
  };
}

// =============================================================================
// ESTADO DEL FORMULARIO
// =============================================================================

/// Estado para formularios de lote.
class LoteFormState extends Equatable {
  const LoteFormState({
    this.isValid = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.lote,
    this.currentStep = 0,
    this.codigo,
    this.nombre,
    this.tipoAve,
    this.cantidadInicial,
    this.fechaIngreso,
    this.proveedor,
    this.raza,
    this.edadIngresoDias = 0,
    this.pesoPromedioObjetivo,
    this.fechaCierreEstimada,
    this.costoAveInicial,
    this.observaciones,
    this.codigoError,
    this.nombreError,
    this.tipoAveError,
    this.cantidadError,
    this.fechaError,
  });

  final bool isValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final Lote? lote;
  final int currentStep;

  // Campos del formulario
  final String? codigo;
  final String? nombre;
  final TipoAve? tipoAve;
  final int? cantidadInicial;
  final DateTime? fechaIngreso;
  final String? proveedor;
  final String? raza;
  final int edadIngresoDias;
  final double? pesoPromedioObjetivo;
  final DateTime? fechaCierreEstimada;
  final double? costoAveInicial;
  final String? observaciones;

  // Errores de validación
  final String? codigoError;
  final String? nombreError;
  final String? tipoAveError;
  final String? cantidadError;
  final String? fechaError;

  /// Estado inicial.
  factory LoteFormState.initial() => LoteFormState(
    fechaIngreso: DateTime.now(),
    tipoAve: TipoAve.polloEngorde,
  );

  /// Estado para edición.
  factory LoteFormState.edit(Lote lote) => LoteFormState(
    lote: lote,
    codigo: lote.codigo,
    nombre: lote.nombre,
    tipoAve: lote.tipoAve,
    cantidadInicial: lote.cantidadInicial,
    fechaIngreso: lote.fechaIngreso,
    proveedor: lote.proveedor,
    raza: lote.raza,
    edadIngresoDias: lote.edadIngresoDias,
    pesoPromedioObjetivo: lote.pesoPromedioObjetivo,
    fechaCierreEstimada: lote.fechaCierreEstimada,
    costoAveInicial: lote.costoAveInicial,
    observaciones: lote.observaciones,
  );

  /// Verifica si hay errores de validación.
  bool get hasValidationErrors =>
      codigoError != null ||
      nombreError != null ||
      tipoAveError != null ||
      cantidadError != null ||
      fechaError != null;

  /// Verifica si el formulario puede enviarse.
  bool get canSubmit => isValid && !hasValidationErrors && !isSubmitting;

  /// Verifica si es modo edición.
  bool get isEditing => lote != null;

  /// Número total de pasos del formulario.
  int get totalSteps => 2;

  /// Crea una copia con campos modificados.
  LoteFormState copyWith({
    bool? isValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    Lote? lote,
    int? currentStep,
    String? codigo,
    String? nombre,
    TipoAve? tipoAve,
    int? cantidadInicial,
    DateTime? fechaIngreso,
    String? proveedor,
    String? raza,
    int? edadIngresoDias,
    double? pesoPromedioObjetivo,
    DateTime? fechaCierreEstimada,
    double? costoAveInicial,
    String? observaciones,
    String? codigoError,
    String? nombreError,
    String? tipoAveError,
    String? cantidadError,
    String? fechaError,
  }) {
    return LoteFormState(
      isValid: isValid ?? this.isValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      lote: lote ?? this.lote,
      currentStep: currentStep ?? this.currentStep,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      tipoAve: tipoAve ?? this.tipoAve,
      cantidadInicial: cantidadInicial ?? this.cantidadInicial,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
      proveedor: proveedor ?? this.proveedor,
      raza: raza ?? this.raza,
      edadIngresoDias: edadIngresoDias ?? this.edadIngresoDias,
      pesoPromedioObjetivo: pesoPromedioObjetivo ?? this.pesoPromedioObjetivo,
      fechaCierreEstimada: fechaCierreEstimada ?? this.fechaCierreEstimada,
      costoAveInicial: costoAveInicial ?? this.costoAveInicial,
      observaciones: observaciones ?? this.observaciones,
      codigoError: codigoError,
      nombreError: nombreError,
      tipoAveError: tipoAveError,
      cantidadError: cantidadError,
      fechaError: fechaError,
    );
  }

  @override
  List<Object?> get props => [
    isValid,
    isSubmitting,
    isSuccess,
    errorMessage,
    lote,
    currentStep,
    codigo,
    nombre,
    tipoAve,
    cantidadInicial,
    fechaIngreso,
    proveedor,
    raza,
    edadIngresoDias,
    pesoPromedioObjetivo,
    fechaCierreEstimada,
    costoAveInicial,
    observaciones,
    codigoError,
    nombreError,
    tipoAveError,
    cantidadError,
    fechaError,
  ];
}

// =============================================================================
// ESTADO DE BÚSQUEDA
// =============================================================================

/// Estado para búsqueda de lotes.
class LoteSearchState extends Equatable {
  const LoteSearchState({
    this.query = '',
    this.results = const [],
    this.isSearching = false,
    this.estadoFiltro,
    this.tipoAveFiltro,
    this.errorMessage,
  });

  final String query;
  final List<Lote> results;
  final bool isSearching;
  final EstadoLote? estadoFiltro;
  final TipoAve? tipoAveFiltro;
  final String? errorMessage;

  /// Estado inicial.
  factory LoteSearchState.initial() => const LoteSearchState();

  /// Verifica si hay resultados.
  bool get hasResults => results.isNotEmpty;

  /// Verifica si hay búsqueda activa.
  bool get hasActiveSearch =>
      query.isNotEmpty || estadoFiltro != null || tipoAveFiltro != null;

  /// Crea una copia con campos modificados.
  LoteSearchState copyWith({
    String? query,
    List<Lote>? results,
    bool? isSearching,
    EstadoLote? estadoFiltro,
    TipoAve? tipoAveFiltro,
    String? errorMessage,
  }) {
    return LoteSearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
      estadoFiltro: estadoFiltro ?? this.estadoFiltro,
      tipoAveFiltro: tipoAveFiltro ?? this.tipoAveFiltro,
      errorMessage: errorMessage,
    );
  }

  /// Limpia todos los filtros.
  LoteSearchState clearFiltros() {
    return LoteSearchState(
      query: query,
      results: results,
      isSearching: isSearching,
      estadoFiltro: null,
      tipoAveFiltro: null,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    query,
    results,
    isSearching,
    estadoFiltro,
    tipoAveFiltro,
    errorMessage,
  ];
}

// =============================================================================
// ESTADO DE ESTADÍSTICAS
// =============================================================================

/// Estado para estadísticas de lotes.
class LoteStatsState extends Equatable {
  const LoteStatsState({
    this.totalLotes = 0,
    this.lotesActivos = 0,
    this.lotesCerrados = 0,
    this.lotesEnCuarentena = 0,
    this.lotesVendidos = 0,
    this.totalAvesActuales = 0,
    this.totalAvesInicial = 0,
    this.mortalidadTotal = 0,
    this.mortalidadPromedio = 0.0,
    this.isLoading = false,
    this.errorMessage,
  });

  final int totalLotes;
  final int lotesActivos;
  final int lotesCerrados;
  final int lotesEnCuarentena;
  final int lotesVendidos;
  final int totalAvesActuales;
  final int totalAvesInicial;
  final int mortalidadTotal;
  final double mortalidadPromedio;
  final bool isLoading;
  final String? errorMessage;

  /// Estado inicial.
  factory LoteStatsState.initial() => const LoteStatsState();

  /// Porcentaje de supervivencia global.
  double get porcentajeSupervivencia =>
      totalAvesInicial > 0 ? ((totalAvesActuales / totalAvesInicial) * 100) : 0;

  /// Aves perdidas (mortalidad + descartes).
  int get avesPerdidas => totalAvesInicial - totalAvesActuales;

  /// Crea una copia con campos modificados.
  LoteStatsState copyWith({
    int? totalLotes,
    int? lotesActivos,
    int? lotesCerrados,
    int? lotesEnCuarentena,
    int? lotesVendidos,
    int? totalAvesActuales,
    int? totalAvesInicial,
    int? mortalidadTotal,
    double? mortalidadPromedio,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoteStatsState(
      totalLotes: totalLotes ?? this.totalLotes,
      lotesActivos: lotesActivos ?? this.lotesActivos,
      lotesCerrados: lotesCerrados ?? this.lotesCerrados,
      lotesEnCuarentena: lotesEnCuarentena ?? this.lotesEnCuarentena,
      lotesVendidos: lotesVendidos ?? this.lotesVendidos,
      totalAvesActuales: totalAvesActuales ?? this.totalAvesActuales,
      totalAvesInicial: totalAvesInicial ?? this.totalAvesInicial,
      mortalidadTotal: mortalidadTotal ?? this.mortalidadTotal,
      mortalidadPromedio: mortalidadPromedio ?? this.mortalidadPromedio,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    totalLotes,
    lotesActivos,
    lotesCerrados,
    lotesEnCuarentena,
    lotesVendidos,
    totalAvesActuales,
    totalAvesInicial,
    mortalidadTotal,
    mortalidadPromedio,
    isLoading,
    errorMessage,
  ];
}
