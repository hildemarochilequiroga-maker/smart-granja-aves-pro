library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../../domain/repositories/granja_repository.dart';
import '../datasources/datasources.dart';
import '../models/granja_model.dart';

/// Implementación del repositorio de granjas
class GranjaRepositoryImpl implements GranjaRepository {
  GranjaRepositoryImpl({
    required GranjaFirebaseDatasource firebaseDatasource,
    required GranjaLocalDatasource localDatasource,
    required NetworkInfo networkInfo,
  }) : _firebaseDatasource = firebaseDatasource,
       _localDatasource = localDatasource,
       _networkInfo = networkInfo;

  final GranjaFirebaseDatasource _firebaseDatasource;
  final GranjaLocalDatasource _localDatasource;
  final NetworkInfo _networkInfo;

  // ==================== CRUD ====================

  @override
  Future<Either<Failure, Granja>> crear(Granja granja) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure.noConnection());
    }

    try {
      final model = GranjaModel.fromEntity(granja);
      final result = await _firebaseDatasource.crear(model);
      final entity = result.toEntity();

      // Guardar en cache
      await _localDatasource.guardarGranja(result);

      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.details ?? ErrorMessages.get('ERR_UNKNOWN')));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Granja?>> obtenerPorId(String id) async {
    try {
      // Intentar desde cache primero
      final cached = await _localDatasource.obtenerGranja(id);
      if (cached != null && !await _networkInfo.isConnected) {
        return Right(cached.toEntity());
      }

      // Obtener desde Firebase
      if (await _networkInfo.isConnected) {
        final result = await _firebaseDatasource.obtenerPorId(id);
        if (result != null) {
          await _localDatasource.guardarGranja(result);
          return Right(result.toEntity());
        }
        return const Right(null);
      }

      return Right(cached?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Granja>>> obtenerTodas() async {
    // Este método no debería usarse directamente, usar obtenerPorUsuario
    return const Right([]);
  }

  @override
  Future<Either<Failure, List<Granja>>> obtenerPorUsuario(
    String usuarioId,
  ) async {
    try {
      // Intentar desde cache primero si no hay conexión
      if (!await _networkInfo.isConnected) {
        final cached = await _localDatasource.obtenerGranjas(usuarioId);
        if (cached != null) {
          return Right(cached.map((m) => m.toEntity()).toList());
        }
        return Left(NetworkFailure.noConnection());
      }

      // Obtener desde Firebase
      final result = await _firebaseDatasource.obtenerPorUsuario(usuarioId);

      // Actualizar cache
      await _localDatasource.guardarGranjas(usuarioId, result);

      return Right(result.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Granja>> actualizar(Granja granja) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure.noConnection());
    }

    try {
      final model = GranjaModel.fromEntity(granja);
      final result = await _firebaseDatasource.actualizar(model);

      // Actualizar cache
      await _localDatasource.guardarGranja(result);

      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> eliminar(String id) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure.noConnection());
    }

    try {
      final result = await _firebaseDatasource.eliminar(id);

      // Eliminar del cache
      await _localDatasource.eliminarGranja(id);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // ==================== CONSULTAS ====================

  @override
  Future<Either<Failure, List<Granja>>> obtenerActivas(String usuarioId) async {
    try {
      if (!await _networkInfo.isConnected) {
        final cached = await _localDatasource.obtenerGranjas(usuarioId);
        if (cached != null) {
          final activas = cached
              .where((m) => m.estado == EstadoGranja.activo)
              .map((m) => m.toEntity())
              .toList();
          return Right(activas);
        }
        return Left(NetworkFailure.noConnection());
      }

      final result = await _firebaseDatasource.obtenerActivas(usuarioId);
      return Right(result.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Granja>>> obtenerPorEstado(
    String usuarioId,
    EstadoGranja estado,
  ) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(NetworkFailure.noConnection());
      }

      final result = await _firebaseDatasource.obtenerPorEstado(
        usuarioId,
        estado,
      );
      return Right(result.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Granja>>> buscarPorNombre(
    String usuarioId,
    String nombre,
  ) async {
    try {
      if (!await _networkInfo.isConnected) {
        final cached = await _localDatasource.obtenerGranjas(usuarioId);
        if (cached != null) {
          final filtradas = cached
              .where(
                (m) => m.nombre.toLowerCase().contains(nombre.toLowerCase()),
              )
              .map((m) => m.toEntity())
              .toList();
          return Right(filtradas);
        }
        return Left(NetworkFailure.noConnection());
      }

      final result = await _firebaseDatasource.buscarPorNombre(
        usuarioId,
        nombre,
      );
      return Right(result.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Granja>>> obtenerCercanas({
    required double latitud,
    required double longitud,
    required double radioKm,
  }) async {
    // Nota: La búsqueda geoespacial real requeriría GeoFirestore o similar.
    // Por ahora, obtenemos todas las granjas y filtramos localmente.
    // En producción, esto debería implementarse con índices geoespaciales.
    try {
      if (!await _networkInfo.isConnected) {
        return Left(NetworkFailure.noConnection());
      }

      // Por ahora retornamos lista vacía - se necesita implementar
      // índices geoespaciales en Firestore para búsqueda eficiente
      return const Right([]);
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> existeConRuc(String ruc) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(NetworkFailure.noConnection());
      }
      final result = await _firebaseDatasource.existeConRuc(ruc);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Granja?>> obtenerPorRuc(String ruc) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(NetworkFailure.noConnection());
      }
      final result = await _firebaseDatasource.obtenerPorRuc(ruc);
      return Right(result?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // ==================== STREAMS ====================

  @override
  Stream<Granja?> observarGranja(String id) {
    return _firebaseDatasource
        .observarGranja(id)
        .map((model) => model?.toEntity());
  }

  @override
  Stream<List<Granja>> observarGranjasDelUsuario(String usuarioId) {
    return _firebaseDatasource
        .observarGranjasDelUsuario(usuarioId)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Stream<List<Granja>> observarGranjasActivas(String usuarioId) {
    return _firebaseDatasource
        .observarGranjasActivas(usuarioId)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  // ==================== ESTADÍSTICAS ====================

  @override
  Future<Either<Failure, int>> contarPorUsuario(String usuarioId) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(NetworkFailure.noConnection());
      }
      final result = await _firebaseDatasource.contarPorUsuario(usuarioId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> contarPorEstado(
    String usuarioId,
    EstadoGranja estado,
  ) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(NetworkFailure.noConnection());
      }
      final result = await _firebaseDatasource.contarPorEstado(
        usuarioId,
        estado,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> obtenerEstadisticas(
    String usuarioId,
  ) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(NetworkFailure.noConnection());
      }

      final granjas = await _firebaseDatasource.obtenerPorUsuario(usuarioId);

      final total = granjas.length;
      final activas = granjas
          .where((g) => g.estado == EstadoGranja.activo)
          .length;
      final inactivas = granjas
          .where((g) => g.estado == EstadoGranja.inactivo)
          .length;
      final enMantenimiento = granjas
          .where((g) => g.estado == EstadoGranja.mantenimiento)
          .length;

      final capacidadTotal = granjas.fold<int>(
        0,
        (sum, g) => sum + (g.capacidadTotalAves ?? 0),
      );
      final areaTotal = granjas.fold<double>(
        0.0,
        (sum, g) => sum + (g.areaTotalM2 ?? 0.0),
      );

      return Right({
        'total': total,
        'activas': activas,
        'inactivas': inactivas,
        'enMantenimiento': enMantenimiento,
        'capacidadTotal': capacidadTotal,
        'areaTotal': areaTotal,
      });
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
