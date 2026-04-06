/// Modelo Firestore para RegistroPeso.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/registro_peso.dart';
import '../../domain/enums/enums.dart';

/// Modelo de datos para registros de peso en Firestore.
class RegistroPesoModel {
  const RegistroPesoModel({
    required this.id,
    required this.loteId,
    required this.granjaId,
    required this.galponId,
    required this.fecha,
    required this.pesoPromedio,
    required this.cantidadAvesPesadas,
    required this.pesoTotal,
    required this.pesoMinimo,
    required this.pesoMaximo,
    required this.edadDias,
    required this.metodoPesaje,
    required this.usuarioRegistro,
    required this.nombreUsuario,
    required this.createdAt,
    this.observaciones,
    this.fotosUrls = const [],
    this.updatedAt,
  });

  final String id;
  final String loteId;
  final String granjaId;
  final String galponId;
  final DateTime fecha;
  final double pesoPromedio;
  final int cantidadAvesPesadas;
  final double pesoTotal;
  final double pesoMinimo;
  final double pesoMaximo;
  final int edadDias;
  final MetodoPesaje metodoPesaje;
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
      'pesoPromedio': pesoPromedio,
      'cantidadAvesPesadas': cantidadAvesPesadas,
      'pesoTotal': pesoTotal,
      'pesoMinimo': pesoMinimo,
      'pesoMaximo': pesoMaximo,
      'edadDias': edadDias,
      'metodoPesaje': metodoPesaje.toJson(),
      if (observaciones != null) 'observaciones': observaciones,
      'fotosUrls': fotosUrls,
      'usuarioRegistro': usuarioRegistro,
      'nombreUsuario': nombreUsuario,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }

  /// Crea desde snapshot de Firestore.
  factory RegistroPesoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RegistroPesoModel(
      id: doc.id,
      loteId: data['loteId'] as String? ?? '',
      granjaId: data['granjaId'] as String? ?? '',
      galponId: data['galponId'] as String? ?? '',
      fecha: (data['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
      pesoPromedio: (data['pesoPromedio'] as num?)?.toDouble() ?? 0.0,
      cantidadAvesPesadas: data['cantidadAvesPesadas'] as int? ?? 0,
      pesoTotal: (data['pesoTotal'] as num?)?.toDouble() ?? 0.0,
      pesoMinimo: (data['pesoMinimo'] as num?)?.toDouble() ?? 0.0,
      pesoMaximo: (data['pesoMaximo'] as num?)?.toDouble() ?? 0.0,
      edadDias: data['edadDias'] as int? ?? 0,
      metodoPesaje: MetodoPesaje.fromJson(
        data['metodoPesaje'] as String? ?? 'manual',
      ),
      observaciones: data['observaciones'] as String?,
      fotosUrls: List<String>.from(data['fotosUrls'] as List? ?? []),
      usuarioRegistro: data['usuarioRegistro'] as String? ?? '',
      nombreUsuario: data['nombreUsuario'] as String? ?? 'Desconocido',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Crea desde entidad.
  factory RegistroPesoModel.fromEntity(RegistroPeso entity) {
    return RegistroPesoModel(
      id: entity.id,
      loteId: entity.loteId,
      granjaId: entity.granjaId,
      galponId: entity.galponId,
      fecha: entity.fecha,
      pesoPromedio: entity.pesoPromedio,
      cantidadAvesPesadas: entity.cantidadAvesPesadas,
      pesoTotal: entity.pesoTotal,
      pesoMinimo: entity.pesoMinimo,
      pesoMaximo: entity.pesoMaximo,
      edadDias: entity.edadDias,
      metodoPesaje: entity.metodoPesaje,
      observaciones: entity.observaciones,
      fotosUrls: entity.fotosUrls,
      usuarioRegistro: entity.usuarioRegistro,
      nombreUsuario: entity.nombreUsuario,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convierte a entidad de dominio.
  RegistroPeso toEntity() {
    return RegistroPeso(
      id: id,
      loteId: loteId,
      granjaId: granjaId,
      galponId: galponId,
      fecha: fecha,
      pesoPromedio: pesoPromedio,
      cantidadAvesPesadas: cantidadAvesPesadas,
      pesoTotal: pesoTotal,
      pesoMinimo: pesoMinimo,
      pesoMaximo: pesoMaximo,
      edadDias: edadDias,
      metodoPesaje: metodoPesaje,
      observaciones: observaciones,
      fotosUrls: fotosUrls,
      usuarioRegistro: usuarioRegistro,
      nombreUsuario: nombreUsuario,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
