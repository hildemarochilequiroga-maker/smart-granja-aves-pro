/// Modelo de datos para reportes de producción de lotes.
library;

import 'package:equatable/equatable.dart';

/// Datos agregados de producción para un lote.
class DatosProduccionLote extends Equatable {
  const DatosProduccionLote({
    required this.loteId,
    required this.loteCodigo,
    required this.loteNombre,
    required this.tipoAve,
    required this.galponNombre,
    required this.fechaIngreso,
    required this.cantidadInicial,
    required this.cantidadActual,
    required this.mortalidadTotal,
    required this.porcentajeMortalidad,
    required this.descartesTotal,
    required this.ventasTotal,
    required this.pesoPromedioActual,
    required this.pesoPromedioObjetivo,
    required this.consumoTotalKg,
    required this.conversionAlimenticia,
    required this.edadActualDias,
    required this.diasEnGranja,
    this.huevosProducidos,
    this.porcentajePostura,
    this.fechaCierreEstimada,
    this.costoTotalAves,
    this.costoTotalAlimento,
    this.ingresosTotales,
  });

  final String loteId;
  final String loteCodigo;
  final String? loteNombre;
  final String tipoAve;
  final String galponNombre;
  final DateTime fechaIngreso;
  final int cantidadInicial;
  final int cantidadActual;
  final int mortalidadTotal;
  final double porcentajeMortalidad;
  final int descartesTotal;
  final int ventasTotal;
  final double? pesoPromedioActual;
  final double? pesoPromedioObjetivo;
  final double consumoTotalKg;
  final double? conversionAlimenticia;
  final int edadActualDias;
  final int diasEnGranja;
  final int? huevosProducidos;
  final double? porcentajePostura;
  final DateTime? fechaCierreEstimada;
  final double? costoTotalAves;
  final double? costoTotalAlimento;
  final double? ingresosTotales;

  /// Calcula el balance (ingresos - costos).
  double get balance {
    final ingresos = ingresosTotales ?? 0;
    final costos = (costoTotalAves ?? 0) + (costoTotalAlimento ?? 0);
    return ingresos - costos;
  }

  /// Indica si el lote es rentable.
  bool get esRentable => balance > 0;

  /// Porcentaje de supervivencia.
  double get porcentajeSupervivencia => 100 - porcentajeMortalidad;

  @override
  List<Object?> get props => [
    loteId,
    loteCodigo,
    loteNombre,
    tipoAve,
    galponNombre,
    fechaIngreso,
    cantidadInicial,
    cantidadActual,
    mortalidadTotal,
    porcentajeMortalidad,
    descartesTotal,
    ventasTotal,
    pesoPromedioActual,
    pesoPromedioObjetivo,
    consumoTotalKg,
    conversionAlimenticia,
    edadActualDias,
    diasEnGranja,
    huevosProducidos,
    porcentajePostura,
    fechaCierreEstimada,
    costoTotalAves,
    costoTotalAlimento,
    ingresosTotales,
  ];
}

/// Datos agregados de mortalidad para reportes.
class DatosMortalidad extends Equatable {
  const DatosMortalidad({
    required this.fecha,
    required this.cantidad,
    required this.causaPrincipal,
    this.observaciones,
  });

  final DateTime fecha;
  final int cantidad;
  final String causaPrincipal;
  final String? observaciones;

  @override
  List<Object?> get props => [fecha, cantidad, causaPrincipal, observaciones];
}

/// Datos de costos para reportes financieros.
class DatosCostos extends Equatable {
  const DatosCostos({
    required this.categoria,
    required this.concepto,
    required this.monto,
    required this.fecha,
    this.proveedor,
    this.numeroFactura,
  });

  final String categoria;
  final String concepto;
  final double monto;
  final DateTime fecha;
  final String? proveedor;
  final String? numeroFactura;

  @override
  List<Object?> get props => [
    categoria,
    concepto,
    monto,
    fecha,
    proveedor,
    numeroFactura,
  ];
}

/// Datos de ventas para reportes.
class DatosVentas extends Equatable {
  const DatosVentas({
    required this.tipoProducto,
    required this.cantidad,
    required this.unidad,
    required this.precioUnitario,
    required this.subtotal,
    required this.fecha,
    required this.cliente,
    this.estado,
  });

  final String tipoProducto;
  final double cantidad;
  final String unidad;
  final double precioUnitario;
  final double subtotal;
  final DateTime fecha;
  final String cliente;
  final String? estado;

  @override
  List<Object?> get props => [
    tipoProducto,
    cantidad,
    unidad,
    precioUnitario,
    subtotal,
    fecha,
    cliente,
    estado,
  ];
}

/// Resumen consolidado para reporte ejecutivo.
class ResumenEjecutivo extends Equatable {
  const ResumenEjecutivo({
    required this.totalLotesActivos,
    required this.totalAvesActivas,
    required this.mortalidadPromedio,
    required this.pesoPromedioGeneral,
    required this.consumoTotal,
    required this.costosTotales,
    required this.ventasTotales,
    required this.utilidadNeta,
    required this.margenUtilidad,
    required this.conversionPromedio,
  });

  final int totalLotesActivos;
  final int totalAvesActivas;
  final double mortalidadPromedio;
  final double pesoPromedioGeneral;
  final double consumoTotal;
  final double costosTotales;
  final double ventasTotales;
  final double utilidadNeta;
  final double margenUtilidad;
  final double conversionPromedio;

  @override
  List<Object?> get props => [
    totalLotesActivos,
    totalAvesActivas,
    mortalidadPromedio,
    pesoPromedioGeneral,
    consumoTotal,
    costosTotales,
    ventasTotales,
    utilidadNeta,
    margenUtilidad,
    conversionPromedio,
  ];
}
