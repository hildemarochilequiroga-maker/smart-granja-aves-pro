import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/galpon.dart';
import '../../domain/enums/estado_galpon.dart';
import '../../domain/enums/tipo_evento_galpon.dart';
import '../../domain/repositories/galpon_repository.dart';
import '../datasources/datasources.dart';
import '../models/galpon_model.dart';
import '../models/galpon_evento_model.dart';

/// Implementación del repositorio de galpones.
class GalponRepositoryImpl implements GalponRepository {
  GalponRepositoryImpl({
    required GalponFirebaseDatasource firebaseDatasource,
    required GalponLocalDatasource localDatasource,
    required NetworkInfo networkInfo,
  }) : _firebaseDatasource = firebaseDatasource,
       _localDatasource = localDatasource,
       _networkInfo = networkInfo;

  final GalponFirebaseDatasource _firebaseDatasource;
  final GalponLocalDatasource _localDatasource;
  final NetworkInfo _networkInfo;

  // ==================== CRUD ====================

  @override
  Future<Either<Failure, Galpon>> crear(Galpon galpon) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure.noConnection());
    }

    try {
      final model = GalponModel.fromEntity(galpon);
      final result = await _firebaseDatasource.crear(model);
      final entity = result.toEntity();

      // Guardar en cache
      await _localDatasource.guardarGalpon(result);

      // Registrar evento de creación
      await _registrarEvento(
        galponId: result.id,
        granjaId: galpon.granjaId,
        tipo: TipoEventoGalpon.creacion,
        descripcion: ErrorMessages.format('EVT_SHED_CREATED', {'name': galpon.nombre}),
      );

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
  Future<Either<Failure, Galpon>> actualizar(Galpon galpon) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure.noConnection());
    }

    try {
      final model = GalponModel.fromEntity(galpon);
      final result = await _firebaseDatasource.actualizar(model);

      // Actualizar cache
      await _localDatasource.guardarGalpon(result);

      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> eliminar(String id) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure.noConnection());
    }

    try {
      await _firebaseDatasource.eliminar(id);

      // Eliminar del cache
      await _localDatasource.eliminarGalpon(id);

      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Galpon>> obtenerPorId(String id) async {
    try {
      // Intentar desde cache primero
      final cached = await _localDatasource.obtenerGalpon(id);
      if (cached != null && !await _networkInfo.isConnected) {
        return Right(cached.toEntity());
      }

      // Obtener desde Firebase
      if (await _networkInfo.isConnected) {
        final result = await _firebaseDatasource.obtenerPorId(id);
        if (result != null) {
          await _localDatasource.guardarGalpon(result);
          return Right(result.toEntity());
        }
        return Left(
          ServerFailure(message: ErrorMessages.get('ERR_SHED_NOT_FOUND'), code: 'NOT_FOUND'),
        );
      }

      if (cached != null) {
        return Right(cached.toEntity());
      }

      return Left(NetworkFailure.noConnection());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // ==================== CONSULTAS ====================

  @override
  Future<Either<Failure, List<Galpon>>> obtenerPorGranja(
    String granjaId,
  ) async {
    try {
      // Intentar desde cache primero si no hay conexión
      if (!await _networkInfo.isConnected) {
        final cached = await _localDatasource.obtenerGalpones(granjaId);
        if (cached != null) {
          return Right(cached.map((m) => m.toEntity()).toList());
        }
        return Left(NetworkFailure.noConnection());
      }

      // Obtener desde Firebase
      final result = await _firebaseDatasource.obtenerPorGranja(granjaId);

      // Actualizar cache
      await _localDatasource.guardarGalpones(granjaId, result);

      return Right(result.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Galpon>>> obtenerDisponibles(
    String granjaId,
  ) async {
    try {
      if (!await _networkInfo.isConnected) {
        final cached = await _localDatasource.obtenerGalpones(granjaId);
        if (cached != null) {
          final disponibles = cached
              .where(
                (m) =>
                    m.estado == EstadoGalpon.activo && m.loteActualId == null,
              )
              .map((m) => m.toEntity())
              .toList();
          return Right(disponibles);
        }
        return Left(NetworkFailure.noConnection());
      }

      final result = await _firebaseDatasource.obtenerDisponibles(granjaId);
      return Right(result.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Galpon>>> obtenerPorEstado(
    String granjaId,
    EstadoGalpon estado,
  ) async {
    try {
      if (!await _networkInfo.isConnected) {
        final cached = await _localDatasource.obtenerGalpones(granjaId);
        if (cached != null) {
          final filtrados = cached
              .where((m) => m.estado == estado)
              .map((m) => m.toEntity())
              .toList();
          return Right(filtrados);
        }
        return Left(NetworkFailure.noConnection());
      }

      final result = await _firebaseDatasource.obtenerPorEstado(
        granjaId,
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
  Future<Either<Failure, List<Galpon>>> buscar(
    String granjaId,
    String query,
  ) async {
    try {
      if (!await _networkInfo.isConnected) {
        final cached = await _localDatasource.obtenerGalpones(granjaId);
        if (cached != null) {
          final queryLower = query.toLowerCase();
          final filtrados = cached
              .where(
                (m) =>
                    m.nombre.toLowerCase().contains(queryLower) ||
                    m.codigo.toLowerCase().contains(queryLower),
              )
              .map((m) => m.toEntity())
              .toList();
          return Right(filtrados);
        }
        return Left(NetworkFailure.noConnection());
      }

      final result = await _firebaseDatasource.buscar(granjaId, query);
      return Right(result.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // ==================== STREAMS ====================

  @override
  Stream<Either<Failure, List<Galpon>>> watchPorGranja(String granjaId) {
    return _firebaseDatasource
        .watchPorGranja(granjaId)
        .map<Either<Failure, List<Galpon>>>((models) {
          return Right<Failure, List<Galpon>>(
            models.map((m) => m.toEntity()).toList(),
          );
        })
        .transform(
          StreamTransformer<
            Either<Failure, List<Galpon>>,
            Either<Failure, List<Galpon>>
          >.fromHandlers(
            handleData: (data, sink) => sink.add(data),
            handleError: (error, stackTrace, sink) {
              sink.add(
                Left<Failure, List<Galpon>>(
                  UnknownFailure(message: error.toString()),
                ),
              );
            },
          ),
        );
  }

  @override
  Stream<Either<Failure, Galpon>> watchPorId(String id) {
    return _firebaseDatasource
        .watchPorId(id)
        .map<Either<Failure, Galpon>>((model) {
          if (model == null) {
            return Left<Failure, Galpon>(
              ServerFailure(
                message: ErrorMessages.get('ERR_SHED_NOT_FOUND'),
                code: 'NOT_FOUND',
              ),
            );
          }
          return Right<Failure, Galpon>(model.toEntity());
        })
        .transform(
          StreamTransformer<
            Either<Failure, Galpon>,
            Either<Failure, Galpon>
          >.fromHandlers(
            handleData: (data, sink) => sink.add(data),
            handleError: (error, stackTrace, sink) {
              sink.add(
                Left<Failure, Galpon>(
                  UnknownFailure(message: error.toString()),
                ),
              );
            },
          ),
        );
  }

  // ==================== OPERACIONES DE ESTADO ====================

  @override
  Future<Either<Failure, Galpon>> cambiarEstado(
    String id,
    EstadoGalpon nuevoEstado, {
    String? motivo,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure.noConnection());
    }

    try {
      final galponResult = await obtenerPorId(id);
      return await galponResult.fold((failure) => Left(failure), (
        galpon,
      ) async {
        final galponActualizado = galpon.cambiarEstado(nuevoEstado);
        final result = await actualizar(galponActualizado);

        // Registrar evento de cambio de estado
        await _registrarEvento(
          galponId: id,
          granjaId: galpon.granjaId,
          tipo: TipoEventoGalpon.cambioEstado,
          descripcion:
              'Estado cambiado de ${galpon.estado.displayName} a ${nuevoEstado.displayName}',
          datosAdicionales: {
            'estadoAnterior': galpon.estado.toJson(),
            'estadoNuevo': nuevoEstado.toJson(),
            if (motivo != null) 'motivo': motivo,
          },
        );

        return result;
      });
    } on GalponException catch (e) {
      return Left(ValidationFailure(message: e.mensaje));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Galpon>> asignarLote(
    String galponId,
    String loteId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure.noConnection());
    }

    try {
      final galponResult = await obtenerPorId(galponId);
      return await galponResult.fold((failure) => Left(failure), (
        galpon,
      ) async {
        final galponActualizado = galpon.asignarLote(loteId);
        final result = await actualizar(galponActualizado);

        // Registrar evento
        await _registrarEvento(
          galponId: galponId,
          granjaId: galpon.granjaId,
          tipo: TipoEventoGalpon.asignacionLote,
          descripcion: ErrorMessages.format('EVT_BATCH_ASSIGNED', {'id': loteId}),
          loteId: loteId,
        );

        return result;
      });
    } on GalponException catch (e) {
      return Left(ValidationFailure(message: e.mensaje));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Galpon>> liberar(String galponId) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure.noConnection());
    }

    try {
      final galponResult = await obtenerPorId(galponId);
      return await galponResult.fold((failure) => Left(failure), (
        galpon,
      ) async {
        final loteAnterior = galpon.loteActualId;
        // Usar el método de la entidad que ya maneja la lógica correctamente
        final galponLiberado = galpon.liberarLote();
        final result = await actualizar(galponLiberado);

        // Registrar evento
        await _registrarEvento(
          galponId: galponId,
          granjaId: galpon.granjaId,
          tipo: TipoEventoGalpon.liberacionLote,
          descripcion: ErrorMessages.format('EVT_SHED_RELEASED', {'id': loteAnterior ?? ''}),
          loteId: loteAnterior,
        );

        return result;
      });
    } on GalponException catch (e) {
      return Left(ValidationFailure(message: e.mensaje));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // ==================== OPERACIONES DE MANTENIMIENTO ====================

  @override
  Future<Either<Failure, Galpon>> programarMantenimiento(
    String galponId,
    DateTime fechaInicio,
    String descripcion,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure.noConnection());
    }

    try {
      final galponResult = await obtenerPorId(galponId);
      return await galponResult.fold((failure) => Left(failure), (
        galpon,
      ) async {
        // Solo programar la fecha, no cambiar el estado inmediatamente.
        // El estado se cambiará cuando llegue la fecha o el usuario lo haga manualmente.
        final galponActualizado = galpon.copyWith(
          proximoMantenimiento: fechaInicio,
        );
        final result = await actualizar(galponActualizado);

        // Registrar evento
        await _registrarEvento(
          galponId: galponId,
          granjaId: galpon.granjaId,
          tipo: TipoEventoGalpon.mantenimiento,
          descripcion: descripcion,
          datosAdicionales: {'fechaInicio': fechaInicio.toIso8601String()},
        );

        return result;
      });
    } on GalponException catch (e) {
      return Left(ValidationFailure(message: e.mensaje));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Galpon>> registrarDesinfeccion(
    String galponId,
    DateTime fechaDesinfeccion,
    List<String> productos, {
    String? observaciones,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure.noConnection());
    }

    try {
      final galponResult = await obtenerPorId(galponId);
      return await galponResult.fold((failure) => Left(failure), (
        galpon,
      ) async {
        // Usar copyWith para actualizar la fecha de desinfección
        final galponActualizado = galpon.copyWith(
          ultimaDesinfeccion: fechaDesinfeccion,
          estado: EstadoGalpon.desinfeccion,
        );
        final result = await actualizar(galponActualizado);

        // Registrar evento
        await _registrarEvento(
          galponId: galponId,
          granjaId: galpon.granjaId,
          tipo: TipoEventoGalpon.desinfeccion,
          descripcion: observaciones ?? ErrorMessages.get('EVT_DISINFECTION_DONE'),
          datosAdicionales: {
            'fecha': fechaDesinfeccion.toIso8601String(),
            'productos': productos,
          },
        );

        return result;
      });
    } on GalponException catch (e) {
      return Left(ValidationFailure(message: e.mensaje));
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // ==================== ESTADÍSTICAS ====================

  @override
  Future<Either<Failure, Map<String, dynamic>>> obtenerEstadisticas(
    String granjaId,
  ) async {
    try {
      final galponesResult = await obtenerPorGranja(granjaId);
      return galponesResult.fold((failure) => Left(failure), (galpones) {
        final total = galpones.length;
        final activos = galpones
            .where((g) => g.estado == EstadoGalpon.activo)
            .length;
        final disponibles = galpones.where((g) => g.estaDisponible).length;
        final ocupados = galpones.where((g) => g.loteActualId != null).length;
        final enMantenimiento = galpones
            .where((g) => g.estado == EstadoGalpon.mantenimiento)
            .length;
        final capacidadTotal = galpones.fold<int>(
          0,
          (sum, g) => sum + g.capacidadMaxima,
        );
        final avesActuales = galpones.fold<int>(
          0,
          (sum, g) => sum + g.avesActuales,
        );

        return Right({
          'total': total,
          'activos': activos,
          'disponibles': disponibles,
          'ocupados': ocupados,
          'enMantenimiento': enMantenimiento,
          'capacidadTotal': capacidadTotal,
          'avesActuales': avesActuales,
          'porcentajeOcupacion': capacidadTotal > 0
              ? (avesActuales / capacidadTotal * 100)
              : 0,
        });
      });
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<EstadoGalpon, int>>> contarPorEstado(
    String granjaId,
  ) async {
    try {
      final galponesResult = await obtenerPorGranja(granjaId);
      return galponesResult.fold((failure) => Left(failure), (galpones) {
        final conteo = <EstadoGalpon, int>{};
        for (final estado in EstadoGalpon.values) {
          conteo[estado] = galpones.where((g) => g.estado == estado).length;
        }
        return Right(conteo);
      });
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // ==================== CACHE ====================

  @override
  Future<Either<Failure, Unit>> sincronizar(String granjaId) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(NetworkFailure.noConnection());
      }

      final result = await _firebaseDatasource.obtenerPorGranja(granjaId);
      await _localDatasource.guardarGalpones(granjaId, result);

      return const Right(unit);
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> limpiarCache() async {
    try {
      // No implementado a nivel global, se limpia por granja
      return const Right(unit);
    } on Exception catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> hayPendientesSincronizar() async {
    // Verificar si hay datos en cache local que podrían necesitar sincronización
    // En una implementación más completa, se mantendría un registro de operaciones
    // pendientes que no se han podido sincronizar con el servidor.
    // Por ahora, verificamos si hay conexión y datos locales disponibles.
    try {
      final isConnected = await _networkInfo.isConnected;
      // Si no hay conexión, asumimos que podría haber pendientes
      return !isConnected;
    } catch (_) {
      return false;
    }
  }

  // ==================== HELPERS ====================

  Future<void> _registrarEvento({
    required String galponId,
    required String granjaId,
    required TipoEventoGalpon tipo,
    required String descripcion,
    Map<String, dynamic>? datosAdicionales,
    String? loteId,
  }) async {
    try {
      final evento = GalponEventoModel(
        id: '',
        galponId: galponId,
        granjaId: granjaId,
        tipo: tipo,
        descripcion: descripcion,
        fecha: DateTime.now(),
        datosAdicionales: datosAdicionales ?? {},
        loteId: loteId,
      );
      await _firebaseDatasource.registrarEvento(evento);
    } catch (_) {
      // Ignorar errores al registrar eventos
    }
  }
}
