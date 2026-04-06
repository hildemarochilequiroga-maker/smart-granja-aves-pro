/// Modelo Firestore para RegistroConsumo.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/registro_consumo.dart';
import '../../domain/enums/enums.dart';

/// Modelo de datos para registros de consumo en Firestore.
class RegistroConsumoModel {
  const RegistroConsumoModel({
    required this.id,
    required this.loteId,
    required this.granjaId,
    required this.galponId,
    required this.fecha,
    required this.cantidadKg,
    required this.tipoAlimento,
    required this.cantidadAvesActual,
    required this.edadDias,
    required this.usuarioRegistro,
    required this.nombreUsuario,
    required this.createdAt,
    this.consumoAcumuladoAnterior = 0,
    this.loteAlimento,
    this.proveedorId,
    this.costoPorKg,
    this.observaciones,
    this.updatedAt,
    this.itemInventarioId,
    this.nombreItemInventario,
  });

  final String id;
  final String loteId;
  final String granjaId;
  final String galponId;
  final DateTime fecha;
  final double cantidadKg;
  final TipoAlimento tipoAlimento;
  final int cantidadAvesActual;
  final double consumoAcumuladoAnterior;
  final int edadDias;
  final String? loteAlimento;
  final String? proveedorId;
  final double? costoPorKg;
  final String? observaciones;
  final String usuarioRegistro;
  final String nombreUsuario;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? itemInventarioId;
  final String? nombreItemInventario;

  /// Convierte a mapa para Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'loteId': loteId,
      'granjaId': granjaId,
      'galponId': galponId,
      'fecha': Timestamp.fromDate(fecha),
      'cantidadKg': cantidadKg,
      'tipoAlimento': tipoAlimento.toJson(),
      'cantidadAvesActual': cantidadAvesActual,
      'consumoAcumuladoAnterior': consumoAcumuladoAnterior,
      'edadDias': edadDias,
      if (loteAlimento != null) 'loteAlimento': loteAlimento,
      if (proveedorId != null) 'proveedorId': proveedorId,
      if (costoPorKg != null) 'costoPorKg': costoPorKg,
      if (observaciones != null) 'observaciones': observaciones,
      'usuarioRegistro': usuarioRegistro,
      'nombreUsuario': nombreUsuario,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
      if (itemInventarioId != null) 'itemInventarioId': itemInventarioId,
      if (nombreItemInventario != null)
        'nombreItemInventario': nombreItemInventario,
    };
  }

  /// Crea desde snapshot de Firestore.
  factory RegistroConsumoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RegistroConsumoModel(
      id: doc.id,
      loteId: data['loteId'] as String? ?? '',
      granjaId: data['granjaId'] as String? ?? '',
      galponId: data['galponId'] as String? ?? '',
      fecha: (data['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
      cantidadKg: (data['cantidadKg'] as num?)?.toDouble() ?? 0.0,
      tipoAlimento: TipoAlimento.fromJson(
        data['tipoAlimento'] as String? ?? 'otro',
      ),
      cantidadAvesActual: data['cantidadAvesActual'] as int? ?? 0,
      consumoAcumuladoAnterior:
          (data['consumoAcumuladoAnterior'] as num?)?.toDouble() ?? 0,
      edadDias: data['edadDias'] as int? ?? 0,
      loteAlimento: data['loteAlimento'] as String?,
      proveedorId: data['proveedorId'] as String?,
      costoPorKg: (data['costoPorKg'] as num?)?.toDouble(),
      observaciones: data['observaciones'] as String?,
      usuarioRegistro: data['usuarioRegistro'] as String? ?? '',
      nombreUsuario: data['nombreUsuario'] as String? ?? 'Desconocido',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      itemInventarioId: data['itemInventarioId'] as String?,
      nombreItemInventario: data['nombreItemInventario'] as String?,
    );
  }

  /// Crea desde entidad.
  factory RegistroConsumoModel.fromEntity(RegistroConsumo entity) {
    return RegistroConsumoModel(
      id: entity.id,
      loteId: entity.loteId,
      granjaId: entity.granjaId,
      galponId: entity.galponId,
      fecha: entity.fecha,
      cantidadKg: entity.cantidadKg,
      tipoAlimento: entity.tipoAlimento,
      cantidadAvesActual: entity.cantidadAvesActual,
      consumoAcumuladoAnterior: entity.consumoAcumuladoAnterior,
      edadDias: entity.edadDias,
      loteAlimento: entity.loteAlimento,
      proveedorId: entity.proveedorId,
      costoPorKg: entity.costoPorKg,
      observaciones: entity.observaciones,
      usuarioRegistro: entity.usuarioRegistro,
      nombreUsuario: entity.nombreUsuario,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      itemInventarioId: entity.itemInventarioId,
      nombreItemInventario: entity.nombreItemInventario,
    );
  }

  /// Convierte a entidad de dominio.
  RegistroConsumo toEntity() {
    return RegistroConsumo(
      id: id,
      loteId: loteId,
      granjaId: granjaId,
      galponId: galponId,
      fecha: fecha,
      cantidadKg: cantidadKg,
      tipoAlimento: tipoAlimento,
      cantidadAvesActual: cantidadAvesActual,
      consumoAcumuladoAnterior: consumoAcumuladoAnterior,
      edadDias: edadDias,
      loteAlimento: loteAlimento,
      proveedorId: proveedorId,
      costoPorKg: costoPorKg,
      observaciones: observaciones,
      usuarioRegistro: usuarioRegistro,
      nombreUsuario: nombreUsuario,
      createdAt: createdAt,
      updatedAt: updatedAt,
      itemInventarioId: itemInventarioId,
      nombreItemInventario: nombreItemInventario,
    );
  }
}
