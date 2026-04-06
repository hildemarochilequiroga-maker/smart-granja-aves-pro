import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/galpon_evento.dart';
import '../../domain/enums/tipo_evento_galpon.dart';

/// Modelo de infraestructura para la entidad GalponEvento.
///
/// Maneja la conversión entre Firestore y la entidad del dominio.
class GalponEventoModel {
  const GalponEventoModel({
    required this.id,
    required this.galponId,
    required this.granjaId,
    required this.tipo,
    required this.descripcion,
    required this.fecha,
    this.usuarioId,
    this.usuarioNombre,
    this.datosAdicionales = const {},
    this.loteId,
  });

  final String id;
  final String galponId;
  final String granjaId;
  final TipoEventoGalpon tipo;
  final String descripcion;
  final DateTime fecha;
  final String? usuarioId;
  final String? usuarioNombre;
  final Map<String, dynamic> datosAdicionales;
  final String? loteId;

  /// Convierte desde Firestore DocumentSnapshot.
  factory GalponEventoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return GalponEventoModel.fromMap(data, doc.id);
  }

  /// Convierte desde Map (con ID opcional).
  factory GalponEventoModel.fromMap(
    Map<String, dynamic> data, [
    String? documentId,
  ]) {
    return GalponEventoModel(
      id: documentId ?? data['id'] as String? ?? '',
      galponId: data['galponId'] as String? ?? '',
      granjaId: data['granjaId'] as String? ?? '',
      tipo:
          TipoEventoGalpon.tryFromJson(data['tipo'] as String?) ??
          TipoEventoGalpon.otro,
      descripcion: data['descripcion'] as String? ?? '',
      fecha: _parseDateTime(data['fecha']) ?? DateTime.now(),
      usuarioId: data['usuarioId'] as String?,
      usuarioNombre: data['usuarioNombre'] as String?,
      datosAdicionales:
          (data['datosAdicionales'] as Map<String, dynamic>?) ?? const {},
      loteId: data['loteId'] as String?,
    );
  }

  /// Convierte desde la entidad de dominio.
  factory GalponEventoModel.fromEntity(GalponEvento evento) {
    return GalponEventoModel(
      id: evento.id,
      galponId: evento.galponId,
      granjaId: evento.granjaId,
      tipo: evento.tipo,
      descripcion: evento.descripcion,
      fecha: evento.fecha,
      usuarioId: evento.usuarioId,
      usuarioNombre: evento.usuarioNombre,
      datosAdicionales: evento.datosAdicionales,
      loteId: evento.loteId,
    );
  }

  /// Convierte a Map para Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'galponId': galponId,
      'granjaId': granjaId,
      'tipo': tipo.toJson(),
      'descripcion': descripcion,
      'fecha': Timestamp.fromDate(fecha),
      if (usuarioId != null) 'usuarioId': usuarioId,
      if (usuarioNombre != null) 'usuarioNombre': usuarioNombre,
      if (datosAdicionales.isNotEmpty) 'datosAdicionales': datosAdicionales,
      if (loteId != null) 'loteId': loteId,
    };
  }

  /// Convierte a Map para almacenamiento local (JSON serializable).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'galponId': galponId,
      'granjaId': granjaId,
      'tipo': tipo.toJson(),
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
      if (usuarioId != null) 'usuarioId': usuarioId,
      if (usuarioNombre != null) 'usuarioNombre': usuarioNombre,
      if (datosAdicionales.isNotEmpty) 'datosAdicionales': datosAdicionales,
      if (loteId != null) 'loteId': loteId,
    };
  }

  /// Convierte a entidad del dominio.
  GalponEvento toEntity() {
    return GalponEvento(
      id: id,
      galponId: galponId,
      granjaId: granjaId,
      tipo: tipo,
      descripcion: descripcion,
      fecha: fecha,
      usuarioId: usuarioId,
      usuarioNombre: usuarioNombre,
      datosAdicionales: datosAdicionales,
      loteId: loteId,
    );
  }

  /// Copia con modificaciones.
  GalponEventoModel copyWith({
    String? id,
    String? galponId,
    String? granjaId,
    TipoEventoGalpon? tipo,
    String? descripcion,
    DateTime? fecha,
    String? usuarioId,
    String? usuarioNombre,
    Map<String, dynamic>? datosAdicionales,
    String? loteId,
  }) {
    return GalponEventoModel(
      id: id ?? this.id,
      galponId: galponId ?? this.galponId,
      granjaId: granjaId ?? this.granjaId,
      tipo: tipo ?? this.tipo,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      datosAdicionales: datosAdicionales ?? this.datosAdicionales,
      loteId: loteId ?? this.loteId,
    );
  }

  /// Parsea DateTime desde varios formatos.
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
