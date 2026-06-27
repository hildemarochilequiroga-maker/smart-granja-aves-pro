library;

import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

/// Estado para operaciones de granjas
///
/// Utiliza sealed class para tipado seguro y exhaustivo
sealed class GranjaState extends Equatable {
  const GranjaState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
final class GranjaInitial extends GranjaState {
  const GranjaInitial();
}

/// Estado de carga (preserva datos previos para UX sin parpadeo)
final class GranjaLoading extends GranjaState {
  const GranjaLoading({this.mensaje, this.granja, this.granjas});

  final String? mensaje;
  final Granja? granja;
  final List<Granja>? granjas;

  @override
  List<Object?> get props => [mensaje, granja, granjas];
}

/// Estado de éxito con una granja
final class GranjaSuccess extends GranjaState {
  const GranjaSuccess({required this.granja, this.mensaje});

  final Granja granja;
  final String? mensaje;

  @override
  List<Object?> get props => [granja, mensaje];
}

/// Estado de éxito con lista de granjas
final class GranjasLoaded extends GranjaState {
  const GranjasLoaded({required this.granjas});

  final List<Granja> granjas;

  @override
  List<Object?> get props => [granjas];
}

/// Estado de error (preserva datos previos para retry)
final class GranjaError extends GranjaState {
  const GranjaError({
    required this.mensaje,
    this.code,
    this.granja,
    this.granjas,
  });

  final String mensaje;
  final String? code;
  final Granja? granja;
  final List<Granja>? granjas;

  @override
  List<Object?> get props => [mensaje, code, granja, granjas];
}

/// Estado de granja eliminada
final class GranjaDeleted extends GranjaState {
  const GranjaDeleted({this.mensaje});

  final String? mensaje;

  @override
  List<Object?> get props => [mensaje];
}

// =============================================================================
// EXTENSIONES DE ESTADO
// =============================================================================

extension GranjaStateX on GranjaState {
  /// Verifica si está cargando
  bool get isLoading => this is GranjaLoading;

  /// Verifica si tiene error
  bool get hasError => this is GranjaError;

  /// Verifica si tiene éxito
  bool get isSuccess => this is GranjaSuccess || this is GranjasLoaded;

  /// Obtiene la granja si existe (incluye datos previos en Loading/Error)
  Granja? get granja => switch (this) {
    GranjaSuccess(:final granja) => granja,
    GranjaLoading(:final granja) => granja,
    GranjaError(:final granja) => granja,
    _ => null,
  };

  /// Obtiene la lista de granjas si existe (incluye datos previos en Loading/Error)
  List<Granja> get granjas => switch (this) {
    GranjasLoaded(:final granjas) => granjas,
    GranjaLoading(granjas: final g?) => g,
    GranjaError(granjas: final g?) => g,
    _ => [],
  };

  /// Obtiene el mensaje de error si existe
  String? get errorMessage => switch (this) {
    GranjaError(:final mensaje) => mensaje,
    _ => null,
  };
}

// =============================================================================
// ESTADO DE ESTADÍSTICAS
// =============================================================================

/// Estado para estadísticas de granjas
class GranjaStatsState extends Equatable {
  const GranjaStatsState({
    this.totalGranjas = 0,
    this.granjasActivas = 0,
    this.granjasInactivas = 0,
    this.granjasEnMantenimiento = 0,
    this.capacidadTotalAves = 0,
    this.areaTotalM2 = 0.0,
    this.isLoading = false,
    this.errorMessage,
  });

  final int totalGranjas;
  final int granjasActivas;
  final int granjasInactivas;
  final int granjasEnMantenimiento;
  final int capacidadTotalAves;
  final double areaTotalM2;
  final bool isLoading;
  final String? errorMessage;

  /// Estado inicial
  factory GranjaStatsState.initial() => const GranjaStatsState();

  /// Promedio de capacidad por granja
  double get capacidadPromedio =>
      totalGranjas > 0 ? capacidadTotalAves / totalGranjas : 0;

  /// Promedio de área por granja
  double get areaPromedio => totalGranjas > 0 ? areaTotalM2 / totalGranjas : 0;

  /// Porcentaje de granjas activas
  double get porcentajeActivas =>
      totalGranjas > 0 ? (granjasActivas / totalGranjas) * 100 : 0;

  /// Crea una copia con campos modificados
  GranjaStatsState copyWith({
    int? totalGranjas,
    int? granjasActivas,
    int? granjasInactivas,
    int? granjasEnMantenimiento,
    int? capacidadTotalAves,
    double? areaTotalM2,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GranjaStatsState(
      totalGranjas: totalGranjas ?? this.totalGranjas,
      granjasActivas: granjasActivas ?? this.granjasActivas,
      granjasInactivas: granjasInactivas ?? this.granjasInactivas,
      granjasEnMantenimiento:
          granjasEnMantenimiento ?? this.granjasEnMantenimiento,
      capacidadTotalAves: capacidadTotalAves ?? this.capacidadTotalAves,
      areaTotalM2: areaTotalM2 ?? this.areaTotalM2,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    totalGranjas,
    granjasActivas,
    granjasInactivas,
    granjasEnMantenimiento,
    capacidadTotalAves,
    areaTotalM2,
    isLoading,
    errorMessage,
  ];
}
