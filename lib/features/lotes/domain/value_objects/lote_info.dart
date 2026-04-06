/// Value object que encapsula información básica del lote.
///
/// Agrupa los datos de identificación y configuración inicial del lote.
library;

import 'package:equatable/equatable.dart';

/// Información básica del lote.
class LoteInfo extends Equatable {
  const LoteInfo({
    required this.codigo,
    required this.edadIngresoSemanas,
    required this.fechaIngreso,
    this.observaciones,
    this.ultimaActualizacion,
  }) : assert(
         edadIngresoSemanas >= 0,
         'La edad de ingreso no puede ser negativa',
       );

  /// Código identificador del lote (ej: "L001-2024").
  final String? codigo;

  /// Edad de las aves al ingresar (en semanas).
  /// Típicamente 0 para pollitos de 1 día.
  final int edadIngresoSemanas;

  /// Fecha de ingreso del lote a la granja.
  final DateTime fechaIngreso;

  /// Observaciones o notas del lote.
  final String? observaciones;

  /// Fecha de última actualización de datos.
  final DateTime? ultimaActualizacion;

  /// Días transcurridos desde el ingreso hasta una fecha de referencia.
  int diasDeVidaHasta(DateTime referencia) {
    return referencia.difference(fechaIngreso).inDays;
  }

  /// Días transcurridos desde el ingreso hasta ahora.
  int get diasDeVida => diasDeVidaHasta(DateTime.now());

  /// Edad actual del lote en semanas.
  int edadActualEn(DateTime referencia) {
    final semanasVividas = (diasDeVidaHasta(referencia) / 7).floor();
    return edadIngresoSemanas + semanasVividas;
  }

  /// Edad actual del lote en semanas (hasta ahora).
  int get edadActualSemanas => edadActualEn(DateTime.now());

  /// Edad actual del lote en días.
  int get edadActualDias {
    return (edadIngresoSemanas * 7) + diasDeVida;
  }

  /// Crea una copia con campos modificados.
  LoteInfo copyWith({
    String? codigo,
    int? edadIngresoSemanas,
    DateTime? fechaIngreso,
    String? observaciones,
    DateTime? ultimaActualizacion,
  }) {
    return LoteInfo(
      codigo: codigo ?? this.codigo,
      edadIngresoSemanas: edadIngresoSemanas ?? this.edadIngresoSemanas,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
      observaciones: observaciones ?? this.observaciones,
      ultimaActualizacion: ultimaActualizacion ?? this.ultimaActualizacion,
    );
  }

  @override
  List<Object?> get props => [
    codigo,
    edadIngresoSemanas,
    fechaIngreso,
    observaciones,
    ultimaActualizacion,
  ];
}
