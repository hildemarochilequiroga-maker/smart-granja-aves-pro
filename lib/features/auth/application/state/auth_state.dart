library;

import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

/// Estado de autenticación de la aplicación
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial - verificando sesión
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Estado de carga durante operaciones de autenticación
class AuthLoading extends AuthState {
  const AuthLoading({this.mensaje});

  /// Mensaje opcional para mostrar durante la carga
  final String? mensaje;

  @override
  List<Object?> get props => [mensaje];
}

/// Estado de usuario autenticado
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.usuario});

  /// Usuario autenticado
  final Usuario usuario;

  @override
  List<Object?> get props => [usuario];
}

/// Estado de usuario no autenticado
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.mensaje});

  /// Mensaje opcional (ej: "Sesión cerrada")
  final String? mensaje;

  @override
  List<Object?> get props => [mensaje];
}

/// Estado de error durante autenticación
class AuthError extends AuthState {
  const AuthError({required this.mensaje, this.codigo});

  /// Mensaje de error para mostrar
  final String mensaje;

  /// Código de error opcional
  final String? codigo;

  @override
  List<Object?> get props => [mensaje, codigo];
}

/// Estado de éxito para operaciones específicas
class AuthSuccess extends AuthState {
  const AuthSuccess({required this.mensaje, this.usuario});

  /// Mensaje de éxito
  final String mensaje;

  /// Usuario actualizado (opcional)
  final Usuario? usuario;

  @override
  List<Object?> get props => [mensaje, usuario];
}

/// Estado para email de verificación/recuperación enviado
class AuthEmailEnviado extends AuthState {
  const AuthEmailEnviado({required this.email, required this.tipo});

  /// Email al que se envió
  final String email;

  /// Tipo de email enviado
  final TipoEmailAuth tipo;

  @override
  List<Object?> get props => [email, tipo];
}

/// Estado cuando se detecta que el email ya existe con otro método de auth
/// Permite al usuario vincular su cuenta
class AuthAccountLinkRequired extends AuthState {
  const AuthAccountLinkRequired({
    required this.email,
    required this.existingProvider,
    required this.pendingCredential,
    required this.newProvider,
  });

  /// Email del usuario
  final String email;

  /// Proveedor existente (ej: 'password', 'google.com')
  final String existingProvider;

  /// Credencial pendiente para vincular después de autenticar
  final dynamic pendingCredential;

  /// Nuevo proveedor que se intenta usar (ej: 'google', 'apple')
  final String newProvider;

  @override
  List<Object?> get props => [
    email,
    existingProvider,
    pendingCredential,
    newProvider,
  ];
}

/// Estado de vinculación de cuentas en progreso
class AuthLinkingInProgress extends AuthState {
  const AuthLinkingInProgress({this.mensaje});

  final String? mensaje;

  @override
  List<Object?> get props => [mensaje];
}

/// Estado de vinculación exitosa
class AuthLinkingSuccess extends AuthState {
  const AuthLinkingSuccess({
    required this.usuario,
    required this.linkedProvider,
  });

  final Usuario usuario;
  final String linkedProvider;

  @override
  List<Object?> get props => [usuario, linkedProvider];
}

/// Tipos de email de autenticación
enum TipoEmailAuth { verificacion, restablecerPassword }

/// Extensiones para facilitar verificaciones de estado
extension AuthStateX on AuthState {
  /// Verifica si está cargando
  bool get isLoading => this is AuthLoading;

  /// Verifica si está autenticado
  bool get isAuthenticated => this is AuthAuthenticated;

  /// Verifica si no está autenticado
  bool get isUnauthenticated => this is AuthUnauthenticated;

  /// Verifica si hay error
  bool get isError => this is AuthError;

  /// Obtiene el usuario si está autenticado
  Usuario? get usuario {
    if (this is AuthAuthenticated) {
      return (this as AuthAuthenticated).usuario;
    }
    if (this is AuthSuccess) {
      return (this as AuthSuccess).usuario;
    }
    return null;
  }

  /// Obtiene el mensaje de error si hay uno
  String? get errorMensaje {
    if (this is AuthError) {
      return (this as AuthError).mensaje;
    }
    return null;
  }
}
