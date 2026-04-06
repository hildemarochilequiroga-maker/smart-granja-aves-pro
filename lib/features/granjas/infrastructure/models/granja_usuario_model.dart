library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/granja_usuario.dart';
import '../../domain/enums/rol_granja_enum.dart';

/// Modelo de datos para la relación usuario-granja
class GranjaUsuarioModel extends GranjaUsuario {
  const GranjaUsuarioModel({
    required super.id,
    required super.granjaId,
    required super.usuarioId,
    required super.rol,
    required super.fechaAsignacion,
    super.fechaExpiracion,
    super.activo = true,
    super.notas,
    super.nombreCompleto,
    super.email,
  });

  /// Crea desde JSON
  factory GranjaUsuarioModel.fromJson(Map<String, dynamic> json) {
    return GranjaUsuarioModel(
      id: json['id'] as String? ?? '',
      granjaId: json['granjaId'] as String? ?? '',
      usuarioId: json['usuarioId'] as String? ?? '',
      rol: RolGranja.fromString(json['rol'] as String? ?? 'viewer'),
      fechaAsignacion:
          _parseDateTime(json['fechaAsignacion']) ?? DateTime.now(),
      fechaExpiracion: _parseDateTime(json['fechaExpiracion']),
      activo: json['activo'] as bool? ?? true,
      notas: json['notas'] as String?,
      nombreCompleto: json['nombreCompleto'] as String?,
      email: json['email'] as String?,
    );
  }

  /// Crea desde Firestore
  factory GranjaUsuarioModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return GranjaUsuarioModel.fromJson({'id': doc.id, ...data});
  }

  /// Crea desde entidad de dominio
  factory GranjaUsuarioModel.fromEntity(GranjaUsuario entity) {
    return GranjaUsuarioModel(
      id: entity.id,
      granjaId: entity.granjaId,
      usuarioId: entity.usuarioId,
      rol: entity.rol,
      fechaAsignacion: entity.fechaAsignacion,
      fechaExpiracion: entity.fechaExpiracion,
      activo: entity.activo,
      notas: entity.notas,
      nombreCompleto: entity.nombreCompleto,
      email: entity.email,
    );
  }

  /// Convierte a JSON para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'granjaId': granjaId,
      'usuarioId': usuarioId,
      'rol': rol.name,
      'fechaAsignacion': Timestamp.fromDate(fechaAsignacion),
      'fechaExpiracion': fechaExpiracion != null
          ? Timestamp.fromDate(fechaExpiracion!)
          : null,
      'activo': activo,
      'notas': notas,
      'nombreCompleto': nombreCompleto,
      'email': email,
    };
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
