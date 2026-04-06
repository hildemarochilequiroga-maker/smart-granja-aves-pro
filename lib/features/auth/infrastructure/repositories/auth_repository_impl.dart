library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_firebase_datasource.dart';
import '../datasources/auth_local_datasource.dart';

/// Implementación del repositorio de autenticación
///
/// Coordina las operaciones entre el datasource remoto (Firebase)
/// y el datasource local para cacheo y persistencia.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthFirebaseDatasource firebaseDatasource,
    required AuthLocalDatasource localDatasource,
    required NetworkInfo networkInfo,
  }) : _firebase = firebaseDatasource,
       _local = localDatasource,
       _network = networkInfo;

  final AuthFirebaseDatasource _firebase;
  final AuthLocalDatasource _local;
  final NetworkInfo _network;

  // ===========================================================================
  // AUTENTICACIÓN
  // ===========================================================================

  @override
  Future<Either<Failure, Usuario>> loginConEmail({
    required String email,
    required String password,
  }) async {
    if (!await _network.isConnected) {
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      final usuario = await _firebase.loginConEmail(
        email: email,
        password: password,
      );
      await _local.guardarUsuario(usuario);
      await _local.guardarUltimoEmail(email);
      return Right(usuario.toEntity());
    } on Exception catch (e) {
      return Left(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Either<Failure, Usuario>> loginConGoogle() async {
    if (!await _network.isConnected) {
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      final usuario = await _firebase.loginConGoogle();
      await _local.guardarUsuario(usuario);
      return Right(usuario.toEntity());
    } on Exception catch (e) {
      return Left(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Either<Failure, Usuario>> loginConApple() async {
    if (!await _network.isConnected) {
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      final usuario = await _firebase.loginConApple();
      await _local.guardarUsuario(usuario);
      return Right(usuario.toEntity());
    } on Exception catch (e) {
      return Left(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Either<Failure, Usuario>> registrarConEmail({
    required String email,
    required String password,
    String? nombre,
    String? apellido,
  }) async {
    if (!await _network.isConnected) {
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      final usuario = await _firebase.registrarConEmail(
        email: email,
        password: password,
        nombre: nombre,
        apellido: apellido,
      );
      await _local.guardarUsuario(usuario);
      await _local.guardarUltimoEmail(email);
      return Right(usuario.toEntity());
    } on Exception catch (e) {
      return Left(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> cerrarSesion() async {
    try {
      await _firebase.cerrarSesion();
      await _local.limpiarDatos();
      return const Right(null);
    } on Exception catch (e) {
      return Left(ErrorHandler.toFailure(e));
    }
  }

  // ===========================================================================
  // VINCULACIÓN DE CUENTAS (ACCOUNT LINKING)
  // ===========================================================================

  @override
  Future<Either<Failure, Usuario>> vincularCredencial({
    required dynamic pendingCredential,
  }) async {
    if (!await _network.isConnected) {
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      final usuario = await _firebase.vincularCredencial(
        pendingCredential: pendingCredential,
      );
      await _local.guardarUsuario(usuario);
      return Right(usuario.toEntity());
    } on Exception catch (e) {
      return Left(ErrorHandler.toFailure(e));
    }
  }

  @override
  List<String> obtenerProveedoresVinculados() {
    return _firebase.obtenerProveedoresVinculados();
  }

  // ===========================================================================
  // RECUPERACIÓN DE CONTRASEÑA
  // ===========================================================================

  @override
  Future<Either<Failure, void>> enviarEmailRestablecerPassword({
    required String email,
  }) async {
    if (!await _network.isConnected) {
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      await _firebase.enviarEmailRestablecerPassword(email: email);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> cambiarPassword({
    required String passwordActual,
    required String passwordNuevo,
  }) async {
    if (!await _network.isConnected) {
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      await _firebase.cambiarPassword(
        passwordActual: passwordActual,
        passwordNuevo: passwordNuevo,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ErrorHandler.toFailure(e));
    }
  }

  // ===========================================================================
  // VERIFICACIÓN
  // ===========================================================================

  @override
  Future<Either<Failure, void>> enviarEmailVerificacion() async {
    if (!await _network.isConnected) {
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      await _firebase.enviarEmailVerificacion();
      return const Right(null);
    } on Exception catch (e) {
      return Left(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> recargarUsuario() async {
    try {
      await _firebase.recargarUsuario();
      return const Right(null);
    } on Exception catch (e) {
      return Left(ErrorHandler.toFailure(e));
    }
  }

  // ===========================================================================
  // USUARIO ACTUAL
  // ===========================================================================

  @override
  Future<Either<Failure, Usuario?>> obtenerUsuarioActual() async {
    try {
      // Intentar obtener de Firebase primero si hay conexión
      if (await _network.isConnected) {
        final usuario = await _firebase.obtenerUsuarioActual();
        if (usuario != null) {
          await _local.guardarUsuario(usuario);
          return Right(usuario.toEntity());
        }
        return const Right(null);
      }

      // Si no hay conexión, usar cache local
      final usuarioLocal = _local.obtenerUsuario();
      return Right(usuarioLocal?.toEntity());
    } on Exception catch (e) {
      // En caso de error, intentar cache local
      final usuarioLocal = _local.obtenerUsuario();
      if (usuarioLocal != null) {
        return Right(usuarioLocal.toEntity());
      }
      return Left(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> verificarSesionActiva() async {
    try {
      final activa = await _firebase.verificarSesionActiva();
      return Right(activa);
    } on Exception catch (e) {
      return Left(ErrorHandler.toFailure(e));
    }
  }

  @override
  Stream<Usuario?> get estadoAutenticacion {
    return _firebase.estadoAutenticacion.asyncMap((modelo) async {
      if (modelo != null) {
        await _local.guardarUsuario(modelo);
        return modelo.toEntity();
      }
      return null;
    });
  }

  // ===========================================================================
  // PERFIL
  // ===========================================================================

  @override
  Future<Either<Failure, Usuario>> actualizarPerfil({
    String? nombre,
    String? apellido,
    String? telefono,
    String? fotoUrl,
  }) async {
    if (!await _network.isConnected) {
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      final usuario = await _firebase.actualizarPerfil(
        nombre: nombre,
        apellido: apellido,
        telefono: telefono,
        fotoUrl: fotoUrl,
      );
      await _local.guardarUsuario(usuario);
      return Right(usuario.toEntity());
    } on Exception catch (e) {
      return Left(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> actualizarFotoPerfil({
    required String rutaArchivo,
  }) async {
    if (!await _network.isConnected) {
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      final url = await _firebase.actualizarFotoPerfil(
        rutaArchivo: rutaArchivo,
      );
      return Right(url);
    } on Exception catch (e) {
      return Left(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> eliminarCuenta({
    required String password,
  }) async {
    if (!await _network.isConnected) {
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      await _firebase.eliminarCuenta(password: password);
      await _local.limpiarTodo();
      return const Right(null);
    } on Exception catch (e) {
      return Left(ErrorHandler.toFailure(e));
    }
  }
}
