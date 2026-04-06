library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/entities.dart';

/// Contrato del repositorio de autenticación
///
/// Define las operaciones disponibles para la autenticación
/// de usuarios. Las implementaciones deben manejar los errores
/// y retornar `Either<Failure, T>`.
abstract class AuthRepository {
  // ===========================================================================
  // AUTENTICACIÓN
  // ===========================================================================

  /// Inicia sesión con email y contraseña
  Future<Either<Failure, Usuario>> loginConEmail({
    required String email,
    required String password,
  });

  /// Inicia sesión con Google
  Future<Either<Failure, Usuario>> loginConGoogle();

  /// Inicia sesión con Apple
  Future<Either<Failure, Usuario>> loginConApple();

  /// Registra un nuevo usuario con email y contraseña
  Future<Either<Failure, Usuario>> registrarConEmail({
    required String email,
    required String password,
    String? nombre,
    String? apellido,
  });

  /// Cierra la sesión del usuario actual
  Future<Either<Failure, void>> cerrarSesion();

  // ===========================================================================
  // VINCULACIÓN DE CUENTAS (ACCOUNT LINKING)
  // ===========================================================================

  /// Vincula una credencial pendiente al usuario actual
  ///
  /// Se usa cuando un usuario intenta iniciar sesión con un proveedor
  /// (ej: Google) pero ya tiene una cuenta con email/password.
  Future<Either<Failure, Usuario>> vincularCredencial({
    required dynamic pendingCredential,
  });

  /// Obtiene los proveedores de autenticación vinculados al usuario actual
  List<String> obtenerProveedoresVinculados();

  // ===========================================================================
  // RECUPERACIÓN DE CONTRASEÑA
  // ===========================================================================

  /// Envía un email para restablecer la contraseña
  Future<Either<Failure, void>> enviarEmailRestablecerPassword({
    required String email,
  });

  /// Cambia la contraseña del usuario actual
  Future<Either<Failure, void>> cambiarPassword({
    required String passwordActual,
    required String passwordNuevo,
  });

  // ===========================================================================
  // VERIFICACIÓN
  // ===========================================================================

  /// Envía email de verificación al usuario actual
  Future<Either<Failure, void>> enviarEmailVerificacion();

  /// Recarga los datos del usuario desde el servidor
  Future<Either<Failure, void>> recargarUsuario();

  // ===========================================================================
  // USUARIO ACTUAL
  // ===========================================================================

  /// Obtiene el usuario actualmente autenticado
  Future<Either<Failure, Usuario?>> obtenerUsuarioActual();

  /// Verifica si hay una sesión activa válida
  Future<Either<Failure, bool>> verificarSesionActiva();

  /// Stream de cambios en el estado de autenticación
  Stream<Usuario?> get estadoAutenticacion;

  // ===========================================================================
  // PERFIL DE USUARIO
  // ===========================================================================

  /// Actualiza el perfil del usuario
  Future<Either<Failure, Usuario>> actualizarPerfil({
    String? nombre,
    String? apellido,
    String? telefono,
    String? fotoUrl,
  });

  /// Actualiza la foto de perfil
  Future<Either<Failure, String>> actualizarFotoPerfil({
    required String rutaArchivo,
  });

  /// Elimina la cuenta del usuario
  Future<Either<Failure, void>> eliminarCuenta({required String password});
}
