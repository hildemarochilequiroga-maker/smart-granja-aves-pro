/// Modelo de Firestore para ItemInventario.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';

/// Modelo para serialización de ItemInventario.
class ItemInventarioModel extends ItemInventario {
  const ItemInventarioModel({
    required super.id,
    required super.granjaId,
    required super.tipo,
    required super.nombre,
    required super.stockActual,
    required super.unidad,
    required super.registradoPor,
    required super.fechaCreacion,
    super.codigo,
    super.descripcion,
    super.stockMinimo,
    super.stockMaximo,
    super.precioUnitario,
    super.proveedor,
    super.ubicacion,
    super.fechaVencimiento,
    super.loteProveedor,
    super.activo,
    super.fechaActualizacion,
    super.imagenUrl,
  });

  /// Crea un modelo desde un documento de Firestore.
  factory ItemInventarioModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ItemInventarioModel(
      id: doc.id,
      granjaId: data['granjaId'] as String? ?? '',
      tipo: TipoItem.fromJson(data['tipo'] as String? ?? 'otro'),
      nombre: data['nombre'] as String? ?? '',
      codigo: data['codigo'] as String?,
      descripcion: data['descripcion'] as String?,
      stockActual: (data['stockActual'] as num?)?.toDouble() ?? 0,
      stockMinimo: (data['stockMinimo'] as num?)?.toDouble() ?? 0,
      stockMaximo: (data['stockMaximo'] as num?)?.toDouble(),
      unidad: UnidadMedida.fromJson(data['unidad'] as String? ?? 'unidad'),
      precioUnitario: (data['precioUnitario'] as num?)?.toDouble(),
      proveedor: data['proveedor'] as String?,
      ubicacion: data['ubicacion'] as String?,
      fechaVencimiento: data['fechaVencimiento'] != null
          ? (data['fechaVencimiento'] as Timestamp).toDate()
          : null,
      loteProveedor: data['loteProveedor'] as String?,
      activo: data['activo'] as bool? ?? true,
      registradoPor: data['registradoPor'] as String? ?? '',
      fechaCreacion:
          (data['fechaCreacion'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fechaActualizacion: data['fechaActualizacion'] != null
          ? (data['fechaActualizacion'] as Timestamp).toDate()
          : null,
      imagenUrl: data['imagenUrl'] as String?,
    );
  }

  /// Crea un modelo desde una entidad.
  factory ItemInventarioModel.fromEntity(ItemInventario entity) {
    return ItemInventarioModel(
      id: entity.id,
      granjaId: entity.granjaId,
      tipo: entity.tipo,
      nombre: entity.nombre,
      codigo: entity.codigo,
      descripcion: entity.descripcion,
      stockActual: entity.stockActual,
      stockMinimo: entity.stockMinimo,
      stockMaximo: entity.stockMaximo,
      unidad: entity.unidad,
      precioUnitario: entity.precioUnitario,
      proveedor: entity.proveedor,
      ubicacion: entity.ubicacion,
      fechaVencimiento: entity.fechaVencimiento,
      loteProveedor: entity.loteProveedor,
      activo: entity.activo,
      registradoPor: entity.registradoPor,
      fechaCreacion: entity.fechaCreacion,
      fechaActualizacion: entity.fechaActualizacion,
      imagenUrl: entity.imagenUrl,
    );
  }

  /// Convierte a Map para Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'granjaId': granjaId,
      'tipo': tipo.toJson(),
      'nombre': nombre,
      'codigo': codigo,
      'descripcion': descripcion,
      'stockActual': stockActual,
      'stockMinimo': stockMinimo,
      'stockMaximo': stockMaximo,
      'unidad': unidad.toJson(),
      'precioUnitario': precioUnitario,
      'proveedor': proveedor,
      'ubicacion': ubicacion,
      'fechaVencimiento': fechaVencimiento != null
          ? Timestamp.fromDate(fechaVencimiento!)
          : null,
      'loteProveedor': loteProveedor,
      'activo': activo,
      'registradoPor': registradoPor,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'fechaActualizacion': fechaActualizacion != null
          ? Timestamp.fromDate(fechaActualizacion!)
          : null,
      'imagenUrl': imagenUrl,
    };
  }

  /// Convierte a entidad.
  ItemInventario toEntity() {
    return ItemInventario(
      id: id,
      granjaId: granjaId,
      tipo: tipo,
      nombre: nombre,
      codigo: codigo,
      descripcion: descripcion,
      stockActual: stockActual,
      stockMinimo: stockMinimo,
      stockMaximo: stockMaximo,
      unidad: unidad,
      precioUnitario: precioUnitario,
      proveedor: proveedor,
      ubicacion: ubicacion,
      fechaVencimiento: fechaVencimiento,
      loteProveedor: loteProveedor,
      activo: activo,
      registradoPor: registradoPor,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      imagenUrl: imagenUrl,
    );
  }
}
