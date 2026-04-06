/// Modelo de Firestore para MovimientoInventario.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';

/// Modelo para serialización de MovimientoInventario.
class MovimientoInventarioModel extends MovimientoInventario {
  const MovimientoInventarioModel({
    required super.id,
    required super.itemId,
    required super.granjaId,
    required super.tipo,
    required super.cantidad,
    required super.stockAnterior,
    required super.stockNuevo,
    required super.fecha,
    required super.registradoPor,
    required super.fechaRegistro,
    super.motivo,
    super.referenciaId,
    super.referenciaTipo,
    super.loteId,
    super.proveedor,
    super.costoTotal,
    super.costoUnitario,
    super.observaciones,
    super.numeroDocumento,
  });

  /// Crea un modelo desde un documento de Firestore.
  factory MovimientoInventarioModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return MovimientoInventarioModel(
      id: doc.id,
      itemId: data['itemId'] as String? ?? '',
      granjaId: data['granjaId'] as String? ?? '',
      tipo: TipoMovimiento.fromJson(data['tipo'] as String? ?? 'usoGeneral'),
      cantidad: (data['cantidad'] as num?)?.toDouble() ?? 0,
      stockAnterior: (data['stockAnterior'] as num?)?.toDouble() ?? 0,
      stockNuevo: (data['stockNuevo'] as num?)?.toDouble() ?? 0,
      fecha: (data['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
      motivo: data['motivo'] as String?,
      referenciaId: data['referenciaId'] as String?,
      referenciaTipo: data['referenciaTipo'] as String?,
      loteId: data['loteId'] as String?,
      proveedor: data['proveedor'] as String?,
      costoTotal: (data['costoTotal'] as num?)?.toDouble(),
      costoUnitario: (data['costoUnitario'] as num?)?.toDouble(),
      observaciones: data['observaciones'] as String?,
      numeroDocumento: data['numeroDocumento'] as String?,
      registradoPor: data['registradoPor'] as String? ?? '',
      fechaRegistro:
          (data['fechaRegistro'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Crea un modelo desde una entidad.
  factory MovimientoInventarioModel.fromEntity(MovimientoInventario entity) {
    return MovimientoInventarioModel(
      id: entity.id,
      itemId: entity.itemId,
      granjaId: entity.granjaId,
      tipo: entity.tipo,
      cantidad: entity.cantidad,
      stockAnterior: entity.stockAnterior,
      stockNuevo: entity.stockNuevo,
      fecha: entity.fecha,
      motivo: entity.motivo,
      referenciaId: entity.referenciaId,
      referenciaTipo: entity.referenciaTipo,
      loteId: entity.loteId,
      proveedor: entity.proveedor,
      costoTotal: entity.costoTotal,
      costoUnitario: entity.costoUnitario,
      observaciones: entity.observaciones,
      numeroDocumento: entity.numeroDocumento,
      registradoPor: entity.registradoPor,
      fechaRegistro: entity.fechaRegistro,
    );
  }

  /// Convierte a Map para Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'itemId': itemId,
      'granjaId': granjaId,
      'tipo': tipo.toJson(),
      'cantidad': cantidad,
      'stockAnterior': stockAnterior,
      'stockNuevo': stockNuevo,
      'fecha': Timestamp.fromDate(fecha),
      'motivo': motivo,
      'referenciaId': referenciaId,
      'referenciaTipo': referenciaTipo,
      'loteId': loteId,
      'proveedor': proveedor,
      'costoTotal': costoTotal,
      'costoUnitario': costoUnitario,
      'observaciones': observaciones,
      'numeroDocumento': numeroDocumento,
      'registradoPor': registradoPor,
      'fechaRegistro': Timestamp.fromDate(fechaRegistro),
    };
  }

  /// Convierte a entidad.
  MovimientoInventario toEntity() {
    return MovimientoInventario(
      id: id,
      itemId: itemId,
      granjaId: granjaId,
      tipo: tipo,
      cantidad: cantidad,
      stockAnterior: stockAnterior,
      stockNuevo: stockNuevo,
      fecha: fecha,
      motivo: motivo,
      referenciaId: referenciaId,
      referenciaTipo: referenciaTipo,
      loteId: loteId,
      proveedor: proveedor,
      costoTotal: costoTotal,
      costoUnitario: costoUnitario,
      observaciones: observaciones,
      numeroDocumento: numeroDocumento,
      registradoPor: registradoPor,
      fechaRegistro: fechaRegistro,
    );
  }
}
