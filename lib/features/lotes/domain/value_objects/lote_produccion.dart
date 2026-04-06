/// Value object que encapsula los datos de producción del lote.
///
/// Gestiona el crecimiento (peso) y consumo de alimento.
library;

import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';

/// Datos de producción del lote.
class LoteProduccion extends Equatable {
  const LoteProduccion({
    this.pesoPromedioGramos,
    this.consumoAcumuladoKg,
    this.huevosProducidos,
    this.fechaPrimerHuevo,
  }) : assert(
         pesoPromedioGramos == null || pesoPromedioGramos > 0,
         'El peso promedio debe ser positivo',
       ),
       assert(
         consumoAcumuladoKg == null || consumoAcumuladoKg >= 0,
         'El consumo acumulado no puede ser negativo',
       ),
       assert(
         huevosProducidos == null || huevosProducidos >= 0,
         'Los huevos producidos no pueden ser negativos',
       );

  /// Peso promedio actual de las aves en gramos.
  final double? pesoPromedioGramos;

  /// Consumo acumulado de alimento en kilogramos.
  final double? consumoAcumuladoKg;

  /// Total de huevos producidos (solo para lotes de postura).
  final int? huevosProducidos;

  /// Fecha del primer huevo (solo para postura).
  final DateTime? fechaPrimerHuevo;

  /// Factory para crear producción inicial (sin datos).
  factory LoteProduccion.inicial() {
    return const LoteProduccion(
      pesoPromedioGramos: null,
      consumoAcumuladoKg: 0.0,
      huevosProducidos: null,
    );
  }

  /// Factory para crear producción inicial de lote de postura.
  factory LoteProduccion.inicialPostura() {
    return const LoteProduccion(
      pesoPromedioGramos: null,
      consumoAcumuladoKg: 0.0,
      huevosProducidos: 0,
    );
  }

  /// Peso promedio en kilogramos.
  double? get pesoPromedioKg {
    if (pesoPromedioGramos == null) return null;
    return pesoPromedioGramos! / 1000.0;
  }

  /// Calcula la conversión alimenticia (FCR - Feed Conversion Ratio).
  ///
  /// FCR = Consumo de alimento (kg) / Peso vivo promedio (kg)
  /// Un FCR más bajo indica mejor eficiencia.
  double? calcularConversionAlimenticia() {
    if (consumoAcumuladoKg == null ||
        pesoPromedioGramos == null ||
        pesoPromedioGramos == 0) {
      return null;
    }

    final pesoKg = pesoPromedioGramos! / 1000.0;
    return consumoAcumuladoKg! / pesoKg;
  }

  /// Verifica si la conversión alimenticia es buena.
  ///
  /// Para pollos de engorde: FCR < 1.8 es excelente, < 2.0 es bueno.
  bool get conversionAlimenticiaEsBuena {
    final fcr = calcularConversionAlimenticia();
    if (fcr == null) return false;
    return fcr < 2.0;
  }

  /// Verifica si la conversión alimenticia es excelente.
  bool get conversionAlimenticiaEsExcelente {
    final fcr = calcularConversionAlimenticia();
    if (fcr == null) return false;
    return fcr < 1.8;
  }

  /// Verifica si el lote ya produjo huevos.
  bool get haProducidoHuevos {
    return huevosProducidos != null && huevosProducidos! > 0;
  }

  /// Verifica si tiene fecha de primer huevo registrada.
  bool get tieneFechaPrimerHuevo {
    return fechaPrimerHuevo != null;
  }

  /// Días desde el primer huevo hasta una fecha de referencia.
  int? diasDesdePrimerHuevo(DateTime referencia) {
    if (fechaPrimerHuevo == null) return null;
    return referencia.difference(fechaPrimerHuevo!).inDays;
  }

  /// Actualiza el peso promedio.
  LoteProduccion actualizarPeso(double nuevoPesoGramos) {
    if (nuevoPesoGramos <= 0) {
      throw ArgumentError(ErrorMessages.get('LOTE_PROD_PESO_POSITIVO'));
    }

    return LoteProduccion(
      pesoPromedioGramos: nuevoPesoGramos,
      consumoAcumuladoKg: consumoAcumuladoKg,
      huevosProducidos: huevosProducidos,
      fechaPrimerHuevo: fechaPrimerHuevo,
    );
  }

  /// Registra consumo de alimento.
  LoteProduccion registrarConsumo(double cantidadKg) {
    if (cantidadKg <= 0) {
      throw ArgumentError(ErrorMessages.get('LOTE_PROD_CONSUMO_POSITIVO'));
    }

    final nuevoConsumo = (consumoAcumuladoKg ?? 0.0) + cantidadKg;

    return LoteProduccion(
      pesoPromedioGramos: pesoPromedioGramos,
      consumoAcumuladoKg: nuevoConsumo,
      huevosProducidos: huevosProducidos,
      fechaPrimerHuevo: fechaPrimerHuevo,
    );
  }

  /// Registra producción de huevos.
  LoteProduccion registrarHuevos(int cantidad, {DateTime? primerHuevo}) {
    if (cantidad <= 0) {
      throw ArgumentError(ErrorMessages.get('LOTE_PROD_HUEVOS_POSITIVO'));
    }

    final nuevaCantidad = (huevosProducidos ?? 0) + cantidad;
    final nuevaFechaPrimerHuevo = fechaPrimerHuevo ?? primerHuevo;

    return LoteProduccion(
      pesoPromedioGramos: pesoPromedioGramos,
      consumoAcumuladoKg: consumoAcumuladoKg,
      huevosProducidos: nuevaCantidad,
      fechaPrimerHuevo: nuevaFechaPrimerHuevo,
    );
  }

  /// Crea una copia con campos modificados.
  LoteProduccion copyWith({
    double? pesoPromedioGramos,
    double? consumoAcumuladoKg,
    int? huevosProducidos,
    DateTime? fechaPrimerHuevo,
  }) {
    return LoteProduccion(
      pesoPromedioGramos: pesoPromedioGramos ?? this.pesoPromedioGramos,
      consumoAcumuladoKg: consumoAcumuladoKg ?? this.consumoAcumuladoKg,
      huevosProducidos: huevosProducidos ?? this.huevosProducidos,
      fechaPrimerHuevo: fechaPrimerHuevo ?? this.fechaPrimerHuevo,
    );
  }

  @override
  List<Object?> get props => [
    pesoPromedioGramos,
    consumoAcumuladoKg,
    huevosProducidos,
    fechaPrimerHuevo,
  ];
}
