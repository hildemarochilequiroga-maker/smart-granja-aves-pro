/// Entidad que representa un item en el inventario de la granja.
library;

import 'package:equatable/equatable.dart';
import '../enums/enums.dart';

/// Entidad principal de inventario.
class ItemInventario extends Equatable {
  const ItemInventario({
    required this.id,
    required this.granjaId,
    required this.tipo,
    required this.nombre,
    required this.stockActual,
    required this.unidad,
    required this.registradoPor,
    required this.fechaCreacion,
    this.codigo,
    this.descripcion,
    this.stockMinimo = 0,
    this.stockMaximo,
    this.precioUnitario,
    this.proveedor,
    this.ubicacion,
    this.fechaVencimiento,
    this.loteProveedor,
    this.activo = true,
    this.fechaActualizacion,
    this.imagenUrl,
  });

  /// ID único del item.
  final String id;

  /// ID de la granja a la que pertenece.
  final String granjaId;

  /// Tipo de item (alimento, medicamento, etc.).
  final TipoItem tipo;

  /// Nombre del item.
  final String nombre;

  /// Código o SKU interno.
  final String? codigo;

  /// Descripción detallada.
  final String? descripcion;

  /// Stock actual disponible.
  final double stockActual;

  /// Stock mínimo para alertas.
  final double stockMinimo;

  /// Stock máximo recomendado.
  final double? stockMaximo;

  /// Unidad de medida.
  final UnidadMedida unidad;

  /// Precio unitario promedio.
  final double? precioUnitario;

  /// Proveedor principal.
  final String? proveedor;

  /// Ubicación en almacén.
  final String? ubicacion;

  /// Fecha de vencimiento.
  final DateTime? fechaVencimiento;

  /// Lote del proveedor.
  final String? loteProveedor;

  /// Si el item está activo.
  final bool activo;

  /// Usuario que registró el item.
  final String registradoPor;

  /// Fecha de creación.
  final DateTime fechaCreacion;

  /// Fecha de última actualización.
  final DateTime? fechaActualizacion;

  /// URL de imagen del producto.
  final String? imagenUrl;

  // ==================== COMPUTED PROPERTIES ====================

  /// Verifica si el stock está bajo el mínimo.
  bool get stockBajo => stockActual <= stockMinimo && stockActual > 0;

  /// Verifica si está agotado.
  bool get agotado => stockActual <= 0;

  /// Verifica si tiene stock disponible.
  bool get disponible => stockActual > 0;

  /// Verifica si está próximo a vencer (30 días).
  bool get proximoVencer {
    if (fechaVencimiento == null) return false;
    final diasRestantes = fechaVencimiento!.difference(DateTime.now()).inDays;
    return diasRestantes <= 30 && diasRestantes > 0;
  }

  /// Verifica si ya venció.
  bool get vencido {
    if (fechaVencimiento == null) return false;
    return fechaVencimiento!.isBefore(DateTime.now());
  }

  /// Días hasta el vencimiento.
  int? get diasParaVencer {
    if (fechaVencimiento == null) return null;
    return fechaVencimiento!.difference(DateTime.now()).inDays;
  }

  /// Valor total del stock.
  double? get valorTotal {
    if (precioUnitario == null) return null;
    return stockActual * precioUnitario!;
  }

  /// Porcentaje de stock respecto al mínimo.
  double get porcentajeStock {
    if (stockMinimo <= 0) return 100;
    return (stockActual / stockMinimo * 100).clamp(0, 200);
  }

  // ==================== COPYWIDTH ====================

  ItemInventario copyWith({
    String? id,
    String? granjaId,
    TipoItem? tipo,
    String? nombre,
    String? codigo,
    String? descripcion,
    double? stockActual,
    double? stockMinimo,
    double? stockMaximo,
    UnidadMedida? unidad,
    double? precioUnitario,
    String? proveedor,
    String? ubicacion,
    DateTime? fechaVencimiento,
    String? loteProveedor,
    bool? activo,
    String? registradoPor,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
    String? imagenUrl,
  }) {
    return ItemInventario(
      id: id ?? this.id,
      granjaId: granjaId ?? this.granjaId,
      tipo: tipo ?? this.tipo,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      stockActual: stockActual ?? this.stockActual,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      stockMaximo: stockMaximo ?? this.stockMaximo,
      unidad: unidad ?? this.unidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      proveedor: proveedor ?? this.proveedor,
      ubicacion: ubicacion ?? this.ubicacion,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      loteProveedor: loteProveedor ?? this.loteProveedor,
      activo: activo ?? this.activo,
      registradoPor: registradoPor ?? this.registradoPor,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      imagenUrl: imagenUrl ?? this.imagenUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    granjaId,
    tipo,
    nombre,
    codigo,
    descripcion,
    stockActual,
    stockMinimo,
    stockMaximo,
    unidad,
    precioUnitario,
    proveedor,
    ubicacion,
    fechaVencimiento,
    loteProveedor,
    activo,
    registradoPor,
    fechaCreacion,
    fechaActualizacion,
    imagenUrl,
  ];
}

/// Excepción específica para errores de inventario.
class ItemInventarioException implements Exception {
  const ItemInventarioException(this.message);
  final String message;

  @override
  String toString() => 'ItemInventarioException: $message';
}
