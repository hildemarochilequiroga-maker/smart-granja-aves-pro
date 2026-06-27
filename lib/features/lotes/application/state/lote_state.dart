import 'package:equatable/equatable.dart';

import '../../domain/entities/lote.dart';

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
