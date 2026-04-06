/// Value object que encapsula las estadísticas demográficas del lote.
///
/// Gestiona la población de aves (cantidad, mortalidad, supervivencia).
library;

import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';

/// Estadísticas demográficas del lote.
class LoteEstadisticas extends Equatable {
  const LoteEstadisticas({
    required this.cantidadInicial,
    required this.cantidadActual,
    required this.mortalidadAcumulada,
  }) : assert(cantidadInicial > 0, 'La cantidad inicial debe ser positiva'),
       assert(cantidadActual >= 0, 'La cantidad actual no puede ser negativa'),
       assert(mortalidadAcumulada >= 0, 'La mortalidad no puede ser negativa');

  /// Cantidad de aves al inicio del lote.
  final int cantidadInicial;

  /// Cantidad actual de aves vivas.
  final int cantidadActual;

  /// Mortalidad acumulada (número de aves muertas).
  final int mortalidadAcumulada;

  /// Factory para crear estadísticas iniciales.
  factory LoteEstadisticas.inicial(int cantidadInicial) {
    return LoteEstadisticas(
      cantidadInicial: cantidadInicial,
      cantidadActual: cantidadInicial,
      mortalidadAcumulada: 0,
    );
  }

  /// Tasa de mortalidad acumulada como porcentaje.
  double get tasaMortalidadPorcentaje {
    if (cantidadInicial == 0) return 0.0;
    return (mortalidadAcumulada / cantidadInicial) * 100;
  }

  /// Tasa de supervivencia como porcentaje.
  double get tasaSupervivenciaPorcentaje {
    if (cantidadInicial == 0) return 0.0;
    return (cantidadActual / cantidadInicial) * 100;
  }

  /// Verifica si la mortalidad está en niveles aceptables (< 5%).
  bool get mortalidadAceptable {
    return tasaMortalidadPorcentaje < 5.0;
  }

  /// Verifica si la mortalidad es crítica (> 10%).
  bool get mortalidadCritica {
    return tasaMortalidadPorcentaje > 10.0;
  }

  /// Verifica si la mortalidad es de advertencia (5-10%).
  bool get mortalidadAdvertencia {
    final tasa = tasaMortalidadPorcentaje;
    return tasa >= 5.0 && tasa <= 10.0;
  }

  /// Registra una nueva mortalidad.
  LoteEstadisticas registrarMortalidad(int cantidad) {
    if (cantidad <= 0) {
      throw ArgumentError(ErrorMessages.get('LOTE_EST_MORTALIDAD_POSITIVA'));
    }

    if (cantidad > cantidadActual) {
      throw ArgumentError(
        ErrorMessages.format('LOTE_EST_MORTALIDAD_EXCEDE', {
          'cantidad': cantidad.toString(),
          'cantidadActual': cantidadActual.toString(),
        }),
      );
    }

    return LoteEstadisticas(
      cantidadInicial: cantidadInicial,
      cantidadActual: cantidadActual - cantidad,
      mortalidadAcumulada: mortalidadAcumulada + cantidad,
    );
  }

  /// Crea una copia con campos modificados.
  LoteEstadisticas copyWith({
    int? cantidadInicial,
    int? cantidadActual,
    int? mortalidadAcumulada,
  }) {
    return LoteEstadisticas(
      cantidadInicial: cantidadInicial ?? this.cantidadInicial,
      cantidadActual: cantidadActual ?? this.cantidadActual,
      mortalidadAcumulada: mortalidadAcumulada ?? this.mortalidadAcumulada,
    );
  }

  @override
  List<Object?> get props => [
    cantidadInicial,
    cantidadActual,
    mortalidadAcumulada,
  ];
}
