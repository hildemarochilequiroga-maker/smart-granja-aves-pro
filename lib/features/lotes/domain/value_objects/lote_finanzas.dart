/// Value object que encapsula las finanzas y ciclo de vida del lote.
///
/// Gestiona las fechas de cierre y venta del lote.
library;

import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';

/// Finanzas y ciclo de vida del lote.
class LoteFinanzas extends Equatable {
  const LoteFinanzas({
    this.fechaCierre,
    this.fechaVenta,
    this.motivoCierre,
    this.costoTotal,
    this.ingresoTotal,
  });

  /// Fecha de cierre del lote.
  final DateTime? fechaCierre;

  /// Fecha de venta del lote.
  final DateTime? fechaVenta;

  /// Motivo del cierre.
  final String? motivoCierre;

  /// Costo total del lote.
  final double? costoTotal;

  /// Ingreso total del lote.
  final double? ingresoTotal;

  /// Factory para crear finanzas iniciales (sin fechas).
  factory LoteFinanzas.inicial() {
    return const LoteFinanzas();
  }

  /// Verifica si el lote está cerrado.
  bool get estaCerrado => fechaCierre != null;

  /// Verifica si el lote está vendido.
  bool get estaVendido => fechaVenta != null;

  /// Ganancia neta del lote.
  double? get gananciaTotal {
    if (costoTotal == null || ingresoTotal == null) return null;
    return ingresoTotal! - costoTotal!;
  }

  /// Rentabilidad del lote como porcentaje.
  double? get rentabilidadPorcentaje {
    if (costoTotal == null || ingresoTotal == null || costoTotal == 0) {
      return null;
    }
    return ((ingresoTotal! - costoTotal!) / costoTotal!) * 100;
  }

  /// Días desde el cierre hasta una fecha de referencia.
  int? diasDesdeCierre(DateTime referencia) {
    if (fechaCierre == null) return null;
    return referencia.difference(fechaCierre!).inDays;
  }

  /// Días desde la venta hasta una fecha de referencia.
  int? diasDesdeVenta(DateTime referencia) {
    if (fechaVenta == null) return null;
    return referencia.difference(fechaVenta!).inDays;
  }

  /// Días transcurridos entre cierre y venta.
  int? get diasEntreCierreYVenta {
    if (fechaCierre == null || fechaVenta == null) return null;
    return fechaVenta!.difference(fechaCierre!).inDays;
  }

  /// Cierra el lote.
  LoteFinanzas cerrar({DateTime? fecha, String? motivo}) {
    if (estaCerrado) {
      throw StateError(ErrorMessages.get('LOTE_FINANZAS_YA_CERRADO'));
    }

    return LoteFinanzas(
      fechaCierre: fecha ?? DateTime.now(),
      fechaVenta: fechaVenta,
      motivoCierre: motivo,
      costoTotal: costoTotal,
      ingresoTotal: ingresoTotal,
    );
  }

  /// Registra la venta del lote.
  LoteFinanzas vender({DateTime? fecha, double? ingreso}) {
    if (estaVendido) {
      throw StateError(ErrorMessages.get('LOTE_FINANZAS_YA_VENDIDO'));
    }

    final fechaVentaFinal = fecha ?? DateTime.now();

    // Si se vende pero no está cerrado, cerrarlo también
    final nuevaFechaCierre = fechaCierre ?? fechaVentaFinal;

    return LoteFinanzas(
      fechaCierre: nuevaFechaCierre,
      fechaVenta: fechaVentaFinal,
      motivoCierre: motivoCierre ?? 'Venta',
      costoTotal: costoTotal,
      ingresoTotal: ingreso ?? ingresoTotal,
    );
  }

  /// Crea una copia con campos modificados.
  LoteFinanzas copyWith({
    DateTime? fechaCierre,
    DateTime? fechaVenta,
    String? motivoCierre,
    double? costoTotal,
    double? ingresoTotal,
  }) {
    return LoteFinanzas(
      fechaCierre: fechaCierre ?? this.fechaCierre,
      fechaVenta: fechaVenta ?? this.fechaVenta,
      motivoCierre: motivoCierre ?? this.motivoCierre,
      costoTotal: costoTotal ?? this.costoTotal,
      ingresoTotal: ingresoTotal ?? this.ingresoTotal,
    );
  }

  @override
  List<Object?> get props => [
    fechaCierre,
    fechaVenta,
    motivoCierre,
    costoTotal,
    ingresoTotal,
  ];
}
