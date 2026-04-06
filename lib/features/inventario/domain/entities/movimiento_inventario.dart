/// Entidad que representa un movimiento de inventario.
library;

import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../enums/enums.dart';

/// Registro de entrada o salida de inventario.
class MovimientoInventario extends Equatable {
  const MovimientoInventario({
    required this.id,
    required this.itemId,
    required this.granjaId,
    required this.tipo,
    required this.cantidad,
    required this.stockAnterior,
    required this.stockNuevo,
    required this.fecha,
    required this.registradoPor,
    required this.fechaRegistro,
    this.motivo,
    this.referenciaId,
    this.referenciaTipo,
    this.loteId,
    this.proveedor,
    this.costoTotal,
    this.costoUnitario,
    this.observaciones,
    this.numeroDocumento,
  });

  /// ID único del movimiento.
  final String id;

  /// ID del item de inventario.
  final String itemId;

  /// ID de la granja.
  final String granjaId;

  /// Tipo de movimiento.
  final TipoMovimiento tipo;

  /// Cantidad del movimiento.
  final double cantidad;

  /// Stock antes del movimiento.
  final double stockAnterior;

  /// Stock después del movimiento.
  final double stockNuevo;

  /// Fecha del movimiento.
  final DateTime fecha;

  /// Motivo o descripción.
  final String? motivo;

  /// ID de referencia (costo, consumo, tratamiento).
  final String? referenciaId;

  /// Tipo de referencia (costo, consumo, tratamiento, vacunacion).
  final String? referenciaTipo;

  /// ID del lote relacionado (para salidas a lote).
  final String? loteId;

  /// Proveedor (para entradas).
  final String? proveedor;

  /// Costo total del movimiento.
  final double? costoTotal;

  /// Costo unitario.
  final double? costoUnitario;

  /// Observaciones adicionales.
  final String? observaciones;

  /// Número de documento (factura, guía, etc.).
  final String? numeroDocumento;

  /// Usuario que registró.
  final String registradoPor;

  /// Fecha de registro.
  final DateTime fechaRegistro;

  // ==================== COMPUTED PROPERTIES ====================

  /// Verifica si es una entrada.
  bool get esEntrada => tipo.esEntrada;

  /// Verifica si es una salida.
  bool get esSalida => tipo.esSalida;

  /// Diferencia de stock.
  double get diferencia => stockNuevo - stockAnterior;

  // ==================== FACTORY METHODS ====================

  /// Crea un movimiento de entrada.
  factory MovimientoInventario.entrada({
    required String id,
    required String itemId,
    required String granjaId,
    required TipoMovimiento tipo,
    required double cantidad,
    required double stockAnterior,
    required String registradoPor,
    String? motivo,
    String? proveedor,
    double? costoTotal,
    String? numeroDocumento,
    String? observaciones,
    String? referenciaId,
    String? referenciaTipo,
    DateTime? fecha,
  }) {
    assert(tipo.esEntrada, ErrorMessages.get('MOVIMIENTO_TIPO_ENTRADA'));
    return MovimientoInventario(
      id: id,
      itemId: itemId,
      granjaId: granjaId,
      tipo: tipo,
      cantidad: cantidad,
      stockAnterior: stockAnterior,
      stockNuevo: stockAnterior + cantidad,
      fecha: fecha ?? DateTime.now(),
      motivo: motivo,
      proveedor: proveedor,
      costoTotal: costoTotal,
      costoUnitario: costoTotal != null && cantidad > 0
          ? costoTotal / cantidad
          : null,
      observaciones: observaciones,
      numeroDocumento: numeroDocumento,
      referenciaId: referenciaId,
      referenciaTipo: referenciaTipo,
      registradoPor: registradoPor,
      fechaRegistro: DateTime.now(),
    );
  }

  /// Crea un movimiento de salida.
  factory MovimientoInventario.salida({
    required String id,
    required String itemId,
    required String granjaId,
    required TipoMovimiento tipo,
    required double cantidad,
    required double stockAnterior,
    required String registradoPor,
    String? motivo,
    String? referenciaId,
    String? referenciaTipo,
    String? loteId,
    String? observaciones,
    DateTime? fecha,
  }) {
    assert(tipo.esSalida, ErrorMessages.get('MOVIMIENTO_TIPO_SALIDA'));
    return MovimientoInventario(
      id: id,
      itemId: itemId,
      granjaId: granjaId,
      tipo: tipo,
      cantidad: cantidad,
      stockAnterior: stockAnterior,
      stockNuevo: (stockAnterior - cantidad).clamp(0, double.infinity),
      fecha: fecha ?? DateTime.now(),
      motivo: motivo,
      referenciaId: referenciaId,
      referenciaTipo: referenciaTipo,
      loteId: loteId,
      observaciones: observaciones,
      registradoPor: registradoPor,
      fechaRegistro: DateTime.now(),
    );
  }

  // ==================== COPYWIDTH ====================

  MovimientoInventario copyWith({
    String? id,
    String? itemId,
    String? granjaId,
    TipoMovimiento? tipo,
    double? cantidad,
    double? stockAnterior,
    double? stockNuevo,
    DateTime? fecha,
    String? motivo,
    String? referenciaId,
    String? referenciaTipo,
    String? loteId,
    String? proveedor,
    double? costoTotal,
    double? costoUnitario,
    String? observaciones,
    String? numeroDocumento,
    String? registradoPor,
    DateTime? fechaRegistro,
  }) {
    return MovimientoInventario(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      granjaId: granjaId ?? this.granjaId,
      tipo: tipo ?? this.tipo,
      cantidad: cantidad ?? this.cantidad,
      stockAnterior: stockAnterior ?? this.stockAnterior,
      stockNuevo: stockNuevo ?? this.stockNuevo,
      fecha: fecha ?? this.fecha,
      motivo: motivo ?? this.motivo,
      referenciaId: referenciaId ?? this.referenciaId,
      referenciaTipo: referenciaTipo ?? this.referenciaTipo,
      loteId: loteId ?? this.loteId,
      proveedor: proveedor ?? this.proveedor,
      costoTotal: costoTotal ?? this.costoTotal,
      costoUnitario: costoUnitario ?? this.costoUnitario,
      observaciones: observaciones ?? this.observaciones,
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
      registradoPor: registradoPor ?? this.registradoPor,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
    );
  }

  @override
  List<Object?> get props => [
    id,
    itemId,
    granjaId,
    tipo,
    cantidad,
    stockAnterior,
    stockNuevo,
    fecha,
    motivo,
    referenciaId,
    referenciaTipo,
    loteId,
    proveedor,
    costoTotal,
    costoUnitario,
    observaciones,
    numeroDocumento,
    registradoPor,
    fechaRegistro,
  ];
}
