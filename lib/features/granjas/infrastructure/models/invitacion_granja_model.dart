library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/invitacion_granja.dart';
import '../../domain/enums/rol_granja_enum.dart';

/// Modelo de datos para invitación a granja
class InvitacionGranjaModel extends InvitacionGranja {
  const InvitacionGranjaModel({
    required super.id,
    required super.codigo,
    required super.granjaId,
    required super.granjaNombre,
    required super.creadoPorId,
    required super.creadoPorNombre,
    required super.rol,
    required super.fechaCreacion,
    required super.fechaExpiracion,
    super.emailDestino,
    super.usado = false,
    super.usadoPorId,
    super.usadoEn,
  });

  /// Crea desde JSON
  factory InvitacionGranjaModel.fromJson(Map<String, dynamic> json) {
    return InvitacionGranjaModel(
      id: json['id'] as String? ?? '',
      codigo: json['codigo'] as String? ?? '',
      granjaId: json['granjaId'] as String? ?? '',
      granjaNombre: json['granjaNombre'] as String? ?? '',
      creadoPorId: json['creadoPorId'] as String? ?? '',
      creadoPorNombre: json['creadoPorNombre'] as String? ?? '',
      rol: RolGranja.fromString(json['rol'] as String? ?? 'viewer'),
      fechaCreacion: _parseDateTime(json['fechaCreacion']) ?? DateTime.now(),
      fechaExpiracion:
          _parseDateTime(json['fechaExpiracion']) ?? DateTime.now(),
      emailDestino: json['emailDestino'] as String?,
      usado: json['usado'] as bool? ?? false,
      usadoPorId: json['usadoPorId'] as String?,
      usadoEn: _parseDateTime(json['usadoEn']),
    );
  }

  /// Crea desde Firestore
  factory InvitacionGranjaModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return InvitacionGranjaModel.fromJson({'id': doc.id, ...data});
  }

  /// Crea desde entidad de dominio
  factory InvitacionGranjaModel.fromEntity(InvitacionGranja entity) {
    return InvitacionGranjaModel(
      id: entity.id,
      codigo: entity.codigo,
      granjaId: entity.granjaId,
      granjaNombre: entity.granjaNombre,
      creadoPorId: entity.creadoPorId,
      creadoPorNombre: entity.creadoPorNombre,
      rol: entity.rol,
      fechaCreacion: entity.fechaCreacion,
      fechaExpiracion: entity.fechaExpiracion,
      emailDestino: entity.emailDestino,
      usado: entity.usado,
      usadoPorId: entity.usadoPorId,
      usadoEn: entity.usadoEn,
    );
  }

  /// Convierte a JSON para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'codigo': codigo,
      'granjaId': granjaId,
      'granjaNombre': granjaNombre,
      'creadoPorId': creadoPorId,
      'creadoPorNombre': creadoPorNombre,
      'rol': rol.name,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'fechaExpiracion': Timestamp.fromDate(fechaExpiracion),
      'emailDestino': emailDestino,
      'usado': usado,
      'usadoPorId': usadoPorId,
      'usadoEn': usadoEn != null ? Timestamp.fromDate(usadoEn!) : null,
    };
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
