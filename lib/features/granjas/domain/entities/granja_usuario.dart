library;

import 'package:equatable/equatable.dart';

import '../enums/rol_granja_enum.dart';

/// Entidad que representa la relación usuario-granja
///
/// Representa que un usuario tiene un rol específico en una granja
/// (relación many-to-many entre usuarios y granjas)
class GranjaUsuario extends Equatable {
  const GranjaUsuario({
    required this.id,
    required this.granjaId,
    required this.usuarioId,
    required this.rol,
    required this.fechaAsignacion,
    this.fechaExpiracion,
    this.activo = true,
    this.notas,
    this.nombreCompleto,
    this.email,
  });

  /// ID único de la relación
  final String id;

  /// ID de la granja
  final String granjaId;

  /// ID del usuario
  final String usuarioId;

  /// Rol del usuario en la granja
  final RolGranja rol;

  /// Fecha en que se asignó el usuario
  final DateTime fechaAsignacion;

  /// Fecha de expiración de acceso (opcional)
  final DateTime? fechaExpiracion;

  /// Indica si el acceso está activo
  final bool activo;

  /// Notas adicionales
  final String? notas;

  /// Nombre completo del usuario (desnormalizado para display)
  final String? nombreCompleto;

  /// Email del usuario (desnormalizado para display)
  final String? email;

  /// Verifica si el acceso está expirado
  bool get espirado =>
      fechaExpiracion != null && fechaExpiracion!.isBefore(DateTime.now());

  /// Verifica si el acceso es válido (activo y no expirado)
  bool get esValido => activo && !espirado;

  /// Crea una copia con campos opcionalmente reemplazados
  GranjaUsuario copyWith({
    String? id,
    String? granjaId,
    String? usuarioId,
    RolGranja? rol,
    DateTime? fechaAsignacion,
    DateTime? fechaExpiracion,
    bool? activo,
    String? notas,
    String? nombreCompleto,
    String? email,
  }) {
    return GranjaUsuario(
      id: id ?? this.id,
      granjaId: granjaId ?? this.granjaId,
      usuarioId: usuarioId ?? this.usuarioId,
      rol: rol ?? this.rol,
      fechaAsignacion: fechaAsignacion ?? this.fechaAsignacion,
      fechaExpiracion: fechaExpiracion ?? this.fechaExpiracion,
      activo: activo ?? this.activo,
      notas: notas ?? this.notas,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [
    id,
    granjaId,
    usuarioId,
    rol,
    fechaAsignacion,
    fechaExpiracion,
    activo,
    notas,
    nombreCompleto,
    email,
  ];
}
