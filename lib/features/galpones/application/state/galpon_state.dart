import 'package:equatable/equatable.dart';

import '../../domain/entities/galpon.dart';
import '../../domain/enums/estado_galpon.dart';

/// Estado para operaciones de galpones.
///
/// Utiliza sealed class para tipado seguro y exhaustivo.
sealed class GalponState extends Equatable {
  const GalponState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial.
final class GalponInitial extends GalponState {
  const GalponInitial();
}

/// Estado de carga (preserva datos previos para UX sin parpadeo).
final class GalponLoading extends GalponState {
  const GalponLoading({this.mensaje, this.galpon, this.galpones});

  final String? mensaje;
  final Galpon? galpon;
  final List<Galpon>? galpones;

  @override
  List<Object?> get props => [mensaje, galpon, galpones];
}

/// Estado de éxito con un galpón.
final class GalponSuccess extends GalponState {
  const GalponSuccess({required this.galpon, this.mensaje});

  final Galpon galpon;
  final String? mensaje;

  @override
  List<Object?> get props => [galpon, mensaje];
}

/// Estado de éxito con lista de galpones.
final class GalponesLoaded extends GalponState {
  const GalponesLoaded({required this.galpones});

  final List<Galpon> galpones;

  @override
  List<Object?> get props => [galpones];
}

/// Estado de error (preserva datos previos para retry).
final class GalponError extends GalponState {
  const GalponError({
    required this.mensaje,
    this.code,
    this.galpon,
    this.galpones,
  });

  final String mensaje;
  final String? code;
  final Galpon? galpon;
  final List<Galpon>? galpones;

  @override
  List<Object?> get props => [mensaje, code, galpon, galpones];
}

/// Estado de galpón eliminado.
final class GalponDeleted extends GalponState {
  const GalponDeleted({this.mensaje});

  final String? mensaje;

  @override
  List<Object?> get props => [mensaje];
}

// =============================================================================
// EXTENSIONES DE ESTADO
// =============================================================================

extension GalponStateX on GalponState {
  /// Verifica si está cargando.
  bool get isLoading => this is GalponLoading;

  /// Verifica si tiene error.
  bool get hasError => this is GalponError;

  /// Verifica si tiene éxito.
  bool get isSuccess => this is GalponSuccess || this is GalponesLoaded;

  /// Obtiene el galpón si existe (incluye datos previos en Loading/Error).
  Galpon? get galpon => switch (this) {
    GalponSuccess(:final galpon) => galpon,
    GalponLoading(:final galpon) => galpon,
    GalponError(:final galpon) => galpon,
    _ => null,
  };

  /// Obtiene la lista de galpones si existe (incluye datos previos en Loading/Error).
  List<Galpon> get galpones => switch (this) {
    GalponesLoaded(:final galpones) => galpones,
    GalponLoading(galpones: final g?) => g,
    GalponError(galpones: final g?) => g,
    _ => [],
  };

  /// Obtiene el mensaje de error si existe.
  String? get errorMessage => switch (this) {
    GalponError(:final mensaje) => mensaje,
    _ => null,
  };
}

// =============================================================================
// ESTADO DEL FORMULARIO
// =============================================================================

/// Estado para formularios de galpón.
class GalponFormState extends Equatable {
  const GalponFormState({
    this.isValid = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.galpon,
    this.currentStep = 0,
    this.codigo,
    this.nombre,
    this.tipo,
    this.capacidadMaxima,
    this.areaM2,
    this.descripcion,
    this.ubicacion,
    this.numeroCorrales,
    this.sistemaBebederos,
    this.sistemaComederos,
    this.sistemaVentilacion,
    this.sistemaCalefaccion,
    this.sistemaIluminacion,
    this.tieneBalanza = false,
    this.sensorTemperatura = false,
    this.sensorHumedad = false,
    this.sensorCO2 = false,
    this.sensorAmoniaco = false,
    this.codigoError,
    this.nombreError,
    this.tipoError,
    this.capacidadError,
  });

  final bool isValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final Galpon? galpon;
  final int currentStep;

  // Campos del formulario
  final String? codigo;
  final String? nombre;
  final String? tipo;
  final int? capacidadMaxima;
  final double? areaM2;
  final String? descripcion;
  final String? ubicacion;
  final int? numeroCorrales;
  final String? sistemaBebederos;
  final String? sistemaComederos;
  final String? sistemaVentilacion;
  final String? sistemaCalefaccion;
  final String? sistemaIluminacion;
  final bool tieneBalanza;
  final bool sensorTemperatura;
  final bool sensorHumedad;
  final bool sensorCO2;
  final bool sensorAmoniaco;

  // Errores de validación
  final String? codigoError;
  final String? nombreError;
  final String? tipoError;
  final String? capacidadError;

  /// Estado inicial.
  factory GalponFormState.initial() => const GalponFormState();

  /// Estado para edición.
  factory GalponFormState.edit(Galpon galpon) => GalponFormState(
    galpon: galpon,
    codigo: galpon.codigo,
    nombre: galpon.nombre,
    tipo: galpon.tipo.toJson(),
    capacidadMaxima: galpon.capacidadMaxima,
    areaM2: galpon.areaM2,
    descripcion: galpon.descripcion,
    ubicacion: galpon.ubicacion,
    numeroCorrales: galpon.numeroCorrales,
    sistemaBebederos: galpon.sistemaBebederos,
    sistemaComederos: galpon.sistemaComederos,
    sistemaVentilacion: galpon.sistemaVentilacion,
    sistemaCalefaccion: galpon.sistemaCalefaccion,
    sistemaIluminacion: galpon.sistemaIluminacion,
    tieneBalanza: galpon.tieneBalanza,
    sensorTemperatura: galpon.sensorTemperatura,
    sensorHumedad: galpon.sensorHumedad,
    sensorCO2: galpon.sensorCO2,
    sensorAmoniaco: galpon.sensorAmoniaco,
  );

  /// Verifica si hay errores de validación.
  bool get hasValidationErrors =>
      codigoError != null ||
      nombreError != null ||
      tipoError != null ||
      capacidadError != null;

  /// Verifica si el formulario puede enviarse.
  bool get canSubmit => isValid && !hasValidationErrors && !isSubmitting;

  /// Verifica si es modo edición.
  bool get isEditing => galpon != null;

  /// Número total de pasos del formulario.
  int get totalSteps => 3;

  /// Crea una copia con campos modificados.
  GalponFormState copyWith({
    bool? isValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    Galpon? galpon,
    int? currentStep,
    String? codigo,
    String? nombre,
    String? tipo,
    int? capacidadMaxima,
    double? areaM2,
    String? descripcion,
    String? ubicacion,
    int? numeroCorrales,
    String? sistemaBebederos,
    String? sistemaComederos,
    String? sistemaVentilacion,
    String? sistemaCalefaccion,
    String? sistemaIluminacion,
    bool? tieneBalanza,
    bool? sensorTemperatura,
    bool? sensorHumedad,
    bool? sensorCO2,
    bool? sensorAmoniaco,
    String? codigoError,
    String? nombreError,
    String? tipoError,
    String? capacidadError,
  }) {
    return GalponFormState(
      isValid: isValid ?? this.isValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      galpon: galpon ?? this.galpon,
      currentStep: currentStep ?? this.currentStep,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      capacidadMaxima: capacidadMaxima ?? this.capacidadMaxima,
      areaM2: areaM2 ?? this.areaM2,
      descripcion: descripcion ?? this.descripcion,
      ubicacion: ubicacion ?? this.ubicacion,
      numeroCorrales: numeroCorrales ?? this.numeroCorrales,
      sistemaBebederos: sistemaBebederos ?? this.sistemaBebederos,
      sistemaComederos: sistemaComederos ?? this.sistemaComederos,
      sistemaVentilacion: sistemaVentilacion ?? this.sistemaVentilacion,
      sistemaCalefaccion: sistemaCalefaccion ?? this.sistemaCalefaccion,
      sistemaIluminacion: sistemaIluminacion ?? this.sistemaIluminacion,
      tieneBalanza: tieneBalanza ?? this.tieneBalanza,
      sensorTemperatura: sensorTemperatura ?? this.sensorTemperatura,
      sensorHumedad: sensorHumedad ?? this.sensorHumedad,
      sensorCO2: sensorCO2 ?? this.sensorCO2,
      sensorAmoniaco: sensorAmoniaco ?? this.sensorAmoniaco,
      codigoError: codigoError,
      nombreError: nombreError,
      tipoError: tipoError,
      capacidadError: capacidadError,
    );
  }

  @override
  List<Object?> get props => [
    isValid,
    isSubmitting,
    isSuccess,
    errorMessage,
    galpon,
    currentStep,
    codigo,
    nombre,
    tipo,
    capacidadMaxima,
    areaM2,
    descripcion,
    ubicacion,
    numeroCorrales,
    sistemaBebederos,
    sistemaComederos,
    sistemaVentilacion,
    sistemaCalefaccion,
    sistemaIluminacion,
    tieneBalanza,
    sensorTemperatura,
    sensorHumedad,
    sensorCO2,
    sensorAmoniaco,
    codigoError,
    nombreError,
    tipoError,
    capacidadError,
  ];
}

// =============================================================================
// ESTADO DE BÚSQUEDA
// =============================================================================

/// Estado para búsqueda de galpones.
class GalponSearchState extends Equatable {
  const GalponSearchState({
    this.query = '',
    this.results = const [],
    this.isSearching = false,
    this.estadoFiltro,
    this.errorMessage,
  });

  final String query;
  final List<Galpon> results;
  final bool isSearching;
  final EstadoGalpon? estadoFiltro;
  final String? errorMessage;

  /// Estado inicial.
  factory GalponSearchState.initial() => const GalponSearchState();

  /// Verifica si hay resultados.
  bool get hasResults => results.isNotEmpty;

  /// Verifica si hay búsqueda activa.
  bool get hasActiveSearch => query.isNotEmpty || estadoFiltro != null;

  /// Crea una copia con campos modificados.
  GalponSearchState copyWith({
    String? query,
    List<Galpon>? results,
    bool? isSearching,
    EstadoGalpon? estadoFiltro,
    String? errorMessage,
  }) {
    return GalponSearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
      estadoFiltro: estadoFiltro ?? this.estadoFiltro,
      errorMessage: errorMessage,
    );
  }

  /// Limpia el filtro de estado.
  GalponSearchState clearEstadoFiltro() {
    return GalponSearchState(
      query: query,
      results: results,
      isSearching: isSearching,
      estadoFiltro: null,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    query,
    results,
    isSearching,
    estadoFiltro,
    errorMessage,
  ];
}

// =============================================================================
// ESTADO DE ESTADÍSTICAS
// =============================================================================

/// Estado para estadísticas de galpones.
class GalponStatsState extends Equatable {
  const GalponStatsState({
    this.totalGalpones = 0,
    this.galponesActivos = 0,
    this.galponesDisponibles = 0,
    this.galponesOcupados = 0,
    this.galponesEnMantenimiento = 0,
    this.galponesEnDesinfeccion = 0,
    this.galponesEnCuarentena = 0,
    this.galponesInactivos = 0,
    this.capacidadTotal = 0,
    this.capacidadOcupada = 0,
    this.avesActuales = 0,
    this.areaTotalM2 = 0.0,
    this.isLoading = false,
    this.errorMessage,
  });

  final int totalGalpones;
  final int galponesActivos;
  final int galponesDisponibles;
  final int galponesOcupados;
  final int galponesEnMantenimiento;
  final int galponesEnDesinfeccion;
  final int galponesEnCuarentena;
  final int galponesInactivos;
  final int capacidadTotal;

  /// Capacidad solo de galpones con lotes asignados.
  final int capacidadOcupada;
  final int avesActuales;
  final double areaTotalM2;
  final bool isLoading;
  final String? errorMessage;

  /// Estado inicial.
  factory GalponStatsState.initial() => const GalponStatsState();

  /// Capacidad disponible.
  int get capacidadDisponible => capacidadTotal - avesActuales;

  /// Porcentaje de ocupación (aves actuales / capacidad de galpones con lotes).
  double get porcentajeOcupacion =>
      capacidadOcupada > 0 ? (avesActuales / capacidadOcupada * 100) : 0;

  /// Porcentaje de galpones disponibles.
  double get porcentajeDisponibles =>
      totalGalpones > 0 ? (galponesDisponibles / totalGalpones * 100) : 0;

  /// Promedio de capacidad por galpón.
  double get capacidadPromedio =>
      totalGalpones > 0 ? capacidadTotal / totalGalpones : 0;

  /// Promedio de área por galpón.
  double get areaPromedio =>
      totalGalpones > 0 ? areaTotalM2 / totalGalpones : 0;

  /// Crea una copia con campos modificados.
  GalponStatsState copyWith({
    int? totalGalpones,
    int? galponesActivos,
    int? galponesDisponibles,
    int? galponesOcupados,
    int? galponesEnMantenimiento,
    int? galponesEnDesinfeccion,
    int? galponesEnCuarentena,
    int? galponesInactivos,
    int? capacidadTotal,
    int? capacidadOcupada,
    int? avesActuales,
    double? areaTotalM2,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GalponStatsState(
      totalGalpones: totalGalpones ?? this.totalGalpones,
      galponesActivos: galponesActivos ?? this.galponesActivos,
      galponesDisponibles: galponesDisponibles ?? this.galponesDisponibles,
      galponesOcupados: galponesOcupados ?? this.galponesOcupados,
      galponesEnMantenimiento:
          galponesEnMantenimiento ?? this.galponesEnMantenimiento,
      galponesEnDesinfeccion:
          galponesEnDesinfeccion ?? this.galponesEnDesinfeccion,
      galponesEnCuarentena: galponesEnCuarentena ?? this.galponesEnCuarentena,
      galponesInactivos: galponesInactivos ?? this.galponesInactivos,
      capacidadTotal: capacidadTotal ?? this.capacidadTotal,
      capacidadOcupada: capacidadOcupada ?? this.capacidadOcupada,
      avesActuales: avesActuales ?? this.avesActuales,
      areaTotalM2: areaTotalM2 ?? this.areaTotalM2,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    totalGalpones,
    galponesActivos,
    galponesDisponibles,
    galponesOcupados,
    galponesEnMantenimiento,
    galponesEnDesinfeccion,
    galponesEnCuarentena,
    galponesInactivos,
    capacidadTotal,
    capacidadOcupada,
    avesActuales,
    areaTotalM2,
    isLoading,
    errorMessage,
  ];
}
