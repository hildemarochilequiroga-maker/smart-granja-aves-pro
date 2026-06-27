import 'package:equatable/equatable.dart';

import '../../domain/entities/galpon.dart';

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
