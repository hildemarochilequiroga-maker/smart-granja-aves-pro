library;

import 'package:equatable/equatable.dart';

import '../enums/rol_granja_enum.dart';

/// Entidad que representa una invitación a una granja
///
/// Los usuarios pueden ser invitados a granjas mediante un código temporal
/// que expira después de 30 días
class InvitacionGranja extends Equatable {
  const InvitacionGranja({
    required this.id,
    required this.codigo,
    required this.granjaId,
    required this.granjaNombre,
    required this.creadoPorId,
    required this.creadoPorNombre,
    required this.rol,
    required this.fechaCreacion,
    required this.fechaExpiracion,
    this.emailDestino,
    this.usado = false,
    this.usadoPorId,
    this.usadoEn,
  });

  /// ID único de la invitación
  final String id;

  /// Código único (ej: "GRANJA-ABC123-XYZ789")
  /// Formato: GRANJA-{6 caracteres aleatorios}-{6 caracteres aleatorios}
  final String codigo;

  /// ID de la granja
  final String granjaId;

  /// Nombre de la granja (para referencia)
  final String granjaNombre;

  /// ID del usuario que creó la invitación
  final String creadoPorId;

  /// Nombre completo del usuario que creó la invitación
  final String creadoPorNombre;

  /// Rol que se asignará
  final RolGranja rol;

  /// Fecha de creación
  final DateTime fechaCreacion;

  /// Fecha de expiración (máximo 30 días desde creación)
  final DateTime fechaExpiracion;

  /// Email al que fue invitado (para referencia)
  final String? emailDestino;

  /// Si ya fue utilizado
  final bool usado;

  /// ID del usuario que la utilizó
  final String? usadoPorId;

  /// Fecha en que se utilizó
  final DateTime? usadoEn;

  /// Verifica si la invitación es válida (no usada y no expirada)
  bool get esValida => !usado && fechaExpiracion.isAfter(DateTime.now());

  /// Días restantes para usar la invitación
  int get diasRestantes {
    final diferencia = fechaExpiracion.difference(DateTime.now()).inDays;
    return diferencia.isNegative ? 0 : diferencia;
  }

  /// Crea una copia con campos opcionalmente reemplazados
  InvitacionGranja copyWith({
    String? id,
    String? codigo,
    String? granjaId,
    String? granjaNombre,
    String? creadoPorId,
    String? creadoPorNombre,
    RolGranja? rol,
    DateTime? fechaCreacion,
    DateTime? fechaExpiracion,
    String? emailDestino,
    bool? usado,
    String? usadoPorId,
    DateTime? usadoEn,
  }) {
    return InvitacionGranja(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      granjaId: granjaId ?? this.granjaId,
      granjaNombre: granjaNombre ?? this.granjaNombre,
      creadoPorId: creadoPorId ?? this.creadoPorId,
      creadoPorNombre: creadoPorNombre ?? this.creadoPorNombre,
      rol: rol ?? this.rol,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaExpiracion: fechaExpiracion ?? this.fechaExpiracion,
      emailDestino: emailDestino ?? this.emailDestino,
      usado: usado ?? this.usado,
      usadoPorId: usadoPorId ?? this.usadoPorId,
      usadoEn: usadoEn ?? this.usadoEn,
    );
  }

  @override
  List<Object?> get props => [
    id,
    codigo,
    granjaId,
    granjaNombre,
    creadoPorId,
    creadoPorNombre,
    rol,
    fechaCreacion,
    fechaExpiracion,
    emailDestino,
    usado,
    usadoPorId,
    usadoEn,
  ];
}
