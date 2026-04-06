library;

import 'package:equatable/equatable.dart';

import 'auth_method.dart';

/// Entidad de usuario del dominio
///
/// Representa un usuario autenticado en el sistema.
/// Es inmutable y usa Equatable para comparaciones.
class Usuario extends Equatable {
  const Usuario({
    required this.id,
    required this.email,
    this.nombre,
    this.apellido,
    this.telefono,
    this.fotoUrl,
    this.emailVerificado = false,
    this.activo = true,
    this.metodoAuth = AuthMethod.email,
    this.fechaCreacion,
    this.ultimoAcceso,
    this.metadata,
    this.proveedoresVinculados = const [],
  });

  /// ID único del usuario (Firebase UID)
  final String id;

  /// Correo electrónico del usuario
  final String email;

  /// Nombre del usuario
  final String? nombre;

  /// Apellido del usuario
  final String? apellido;

  /// Número de teléfono
  final String? telefono;

  /// URL de la foto de perfil
  final String? fotoUrl;

  /// Indica si el email ha sido verificado
  final bool emailVerificado;

  /// Indica si la cuenta está activa
  final bool activo;

  /// Método de autenticación usado
  final AuthMethod metodoAuth;

  /// Fecha de creación de la cuenta
  final DateTime? fechaCreacion;

  /// Fecha del último acceso
  final DateTime? ultimoAcceso;

  /// Metadata adicional del usuario
  final Map<String, dynamic>? metadata;

  /// Lista de proveedores de autenticación vinculados
  /// Ej: ['password', 'google.com', 'apple.com']
  final List<String> proveedoresVinculados;

  /// Nombre completo del usuario
  String get nombreCompleto {
    if (nombre == null && apellido == null) return '';
    if (nombre == null) return apellido ?? '';
    if (apellido == null) return nombre ?? '';
    return '$nombre $apellido';
  }

  /// Iniciales del usuario para avatares
  String get iniciales {
    if (nombre == null && apellido == null) {
      return email.isNotEmpty ? email[0].toUpperCase() : '?';
    }
    final n = nombre?.isNotEmpty == true ? nombre![0] : '';
    final a = apellido?.isNotEmpty == true ? apellido![0] : '';
    return '$n$a'.toUpperCase();
  }

  /// Verifica si el perfil está completo
  bool get perfilCompleto =>
      nombre != null &&
      nombre!.isNotEmpty &&
      apellido != null &&
      apellido!.isNotEmpty;

  /// Verifica si tiene Google vinculado
  bool get tieneGoogleVinculado => proveedoresVinculados.contains('google.com');

  /// Verifica si tiene Apple vinculado
  bool get tieneAppleVinculado => proveedoresVinculados.contains('apple.com');

  /// Verifica si tiene password vinculado
  bool get tienePasswordVinculado => proveedoresVinculados.contains('password');

  /// Crea una copia del usuario con campos actualizados
  Usuario copyWith({
    String? id,
    String? email,
    String? nombre,
    String? apellido,
    String? telefono,
    String? fotoUrl,
    bool? emailVerificado,
    bool? activo,
    AuthMethod? metodoAuth,
    DateTime? fechaCreacion,
    DateTime? ultimoAcceso,
    Map<String, dynamic>? metadata,
    List<String>? proveedoresVinculados,
  }) {
    return Usuario(
      id: id ?? this.id,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      telefono: telefono ?? this.telefono,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      emailVerificado: emailVerificado ?? this.emailVerificado,
      activo: activo ?? this.activo,
      metodoAuth: metodoAuth ?? this.metodoAuth,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      ultimoAcceso: ultimoAcceso ?? this.ultimoAcceso,
      metadata: metadata ?? this.metadata,
      proveedoresVinculados:
          proveedoresVinculados ?? this.proveedoresVinculados,
    );
  }

  /// Usuario vacío para estados iniciales
  static const empty = Usuario(id: '', email: '');

  /// Verifica si el usuario está vacío
  bool get isEmpty => this == empty;

  /// Verifica si el usuario no está vacío
  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [
    id,
    email,
    nombre,
    apellido,
    telefono,
    fotoUrl,
    emailVerificado,
    activo,
    metodoAuth,
    fechaCreacion,
    ultimoAcceso,
    metadata,
    proveedoresVinculados,
  ];

  @override
  String toString() =>
      'Usuario(id: $id, email: $email, nombre: $nombreCompleto)';
}
