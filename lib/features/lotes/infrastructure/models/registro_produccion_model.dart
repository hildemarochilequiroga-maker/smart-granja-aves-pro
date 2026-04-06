/// Modelo Firestore para RegistroProduccion.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/registro_produccion.dart';

/// Modelo de datos para registros de producción en Firestore.
class RegistroProduccionModel {
  const RegistroProduccionModel({
    required this.id,
    required this.loteId,
    required this.granjaId,
    required this.galponId,
    required this.fecha,
    required this.huevosRecolectados,
    required this.huevosBuenos,
    required this.cantidadAvesActual,
    required this.edadDias,
    required this.usuarioRegistro,
    required this.nombreUsuario,
    required this.createdAt,
    this.huevosRotos,
    this.huevosSucios,
    this.huevosDobleYema,
    this.huevosPequenos,
    this.huevosMedianos,
    this.huevosGrandes,
    this.huevosExtraGrandes,
    this.pesoPromedioHuevoGramos,
    this.observaciones,
    this.fotosUrls = const [],
    this.updatedAt,
  });

  final String id;
  final String loteId;
  final String granjaId;
  final String galponId;
  final DateTime fecha;
  final int huevosRecolectados;
  final int huevosBuenos;
  final int? huevosRotos;
  final int? huevosSucios;
  final int? huevosDobleYema;
  final int? huevosPequenos;
  final int? huevosMedianos;
  final int? huevosGrandes;
  final int? huevosExtraGrandes;
  final double? pesoPromedioHuevoGramos;
  final int cantidadAvesActual;
  final int edadDias;
  final String? observaciones;
  final List<String> fotosUrls;
  final String usuarioRegistro;
  final String nombreUsuario;
  final DateTime createdAt;
  final DateTime? updatedAt;

  /// Convierte a mapa para Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'loteId': loteId,
      'granjaId': granjaId,
      'galponId': galponId,
      'fecha': Timestamp.fromDate(fecha),
      'huevosRecolectados': huevosRecolectados,
      'huevosBuenos': huevosBuenos,
      if (huevosRotos != null) 'huevosRotos': huevosRotos,
      if (huevosSucios != null) 'huevosSucios': huevosSucios,
      if (huevosDobleYema != null) 'huevosDobleYema': huevosDobleYema,
      if (huevosPequenos != null) 'huevosPequenos': huevosPequenos,
      if (huevosMedianos != null) 'huevosMedianos': huevosMedianos,
      if (huevosGrandes != null) 'huevosGrandes': huevosGrandes,
      if (huevosExtraGrandes != null) 'huevosExtraGrandes': huevosExtraGrandes,
      if (pesoPromedioHuevoGramos != null)
        'pesoPromedioHuevoGramos': pesoPromedioHuevoGramos,
      'cantidadAvesActual': cantidadAvesActual,
      'edadDias': edadDias,
      if (observaciones != null) 'observaciones': observaciones,
      'fotosUrls': fotosUrls,
      'usuarioRegistro': usuarioRegistro,
      'nombreUsuario': nombreUsuario,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }

  /// Crea desde snapshot de Firestore.
  factory RegistroProduccionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RegistroProduccionModel(
      id: doc.id,
      loteId: data['loteId'] as String? ?? '',
      granjaId: data['granjaId'] as String? ?? '',
      galponId: data['galponId'] as String? ?? '',
      fecha: (data['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
      huevosRecolectados: data['huevosRecolectados'] as int? ?? 0,
      huevosBuenos: data['huevosBuenos'] as int? ?? 0,
      huevosRotos: data['huevosRotos'] as int?,
      huevosSucios: data['huevosSucios'] as int?,
      huevosDobleYema: data['huevosDobleYema'] as int?,
      huevosPequenos: data['huevosPequenos'] as int?,
      huevosMedianos: data['huevosMedianos'] as int?,
      huevosGrandes: data['huevosGrandes'] as int?,
      huevosExtraGrandes: data['huevosExtraGrandes'] as int?,
      pesoPromedioHuevoGramos: (data['pesoPromedioHuevoGramos'] as num?)
          ?.toDouble(),
      cantidadAvesActual: data['cantidadAvesActual'] as int? ?? 0,
      edadDias: data['edadDias'] as int? ?? 0,
      observaciones: data['observaciones'] as String?,
      fotosUrls: List<String>.from(data['fotosUrls'] as List? ?? []),
      usuarioRegistro: data['usuarioRegistro'] as String? ?? '',
      nombreUsuario: data['nombreUsuario'] as String? ?? 'Desconocido',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Crea desde entidad.
  factory RegistroProduccionModel.fromEntity(RegistroProduccion entity) {
    return RegistroProduccionModel(
      id: entity.id,
      loteId: entity.loteId,
      granjaId: entity.granjaId,
      galponId: entity.galponId,
      fecha: entity.fecha,
      huevosRecolectados: entity.huevosRecolectados,
      huevosBuenos: entity.huevosBuenos,
      huevosRotos: entity.huevosRotos,
      huevosSucios: entity.huevosSucios,
      huevosDobleYema: entity.huevosDobleYema,
      huevosPequenos: entity.huevosPequenos,
      huevosMedianos: entity.huevosMedianos,
      huevosGrandes: entity.huevosGrandes,
      huevosExtraGrandes: entity.huevosExtraGrandes,
      pesoPromedioHuevoGramos: entity.pesoPromedioHuevoGramos,
      cantidadAvesActual: entity.cantidadAvesActual,
      edadDias: entity.edadDias,
      observaciones: entity.observaciones,
      fotosUrls: entity.fotosUrls,
      usuarioRegistro: entity.usuarioRegistro,
      nombreUsuario: entity.nombreUsuario,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convierte a entidad de dominio.
  RegistroProduccion toEntity() {
    return RegistroProduccion(
      id: id,
      loteId: loteId,
      granjaId: granjaId,
      galponId: galponId,
      fecha: fecha,
      huevosRecolectados: huevosRecolectados,
      huevosBuenos: huevosBuenos,
      huevosRotos: huevosRotos,
      huevosSucios: huevosSucios,
      huevosDobleYema: huevosDobleYema,
      huevosPequenos: huevosPequenos,
      huevosMedianos: huevosMedianos,
      huevosGrandes: huevosGrandes,
      huevosExtraGrandes: huevosExtraGrandes,
      pesoPromedioHuevoGramos: pesoPromedioHuevoGramos,
      cantidadAvesActual: cantidadAvesActual,
      edadDias: edadDias,
      observaciones: observaciones,
      fotosUrls: fotosUrls,
      usuarioRegistro: usuarioRegistro,
      nombreUsuario: nombreUsuario,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
