import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/lote.dart';
import '../../domain/enums/estado_lote.dart';
import '../../domain/repositories/lote_repository.dart';
import '../datasources/lote_firebase_datasource.dart';
import '../datasources/lote_local_datasource.dart';
import '../models/lote_model.dart';

/// Implementación del repositorio de lotes.
///
/// Implementa patrón offline-first:
/// - Intenta operaciones en Firebase primero
/// - Usa cache local como fallback para lecturas
/// - Sincroniza cuando hay conexión
class LoteRepositoryImpl implements LoteRepository {
  LoteRepositoryImpl({
    required this.firebaseDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  final LoteFirebaseDatasource firebaseDatasource;
  final LoteLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  // ============================================================
  // OPERACIONES CRUD
  // ============================================================

  @override
  Future<Either<Failure, Lote>> crear(Lote lote) async {
    try {
      // Validar entidad
      final error = lote.validar();
      if (error != null) {
        return Left(ValidationFailure(message: error));
      }

      // Verificar conexión
      if (!await networkInfo.isConnected) {
        return Left(
          NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')),
        );
      }

      // Crear en Firebase
      final loteCreado = await firebaseDatasource.crear(lote);

      // Guardar en cache local
      await localDatasource.guardarLote(LoteModel.fromEntity(loteCreado));

      return Right(loteCreado);
    } on LoteException catch (e) {
      return Left(ValidationFailure(message: e.mensaje));
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_CREATE_BATCH', {'e': '$e'}),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Lote>> actualizar(Lote lote) async {
    try {
      // Validar entidad
      final error = lote.validar();
      if (error != null) {
        return Left(ValidationFailure(message: error));
      }

      // Verificar conexión
      if (!await networkInfo.isConnected) {
        return Left(
          NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')),
        );
      }

      // Actualizar en Firebase
      final loteActualizado = await firebaseDatasource.actualizar(lote);

      // Actualizar cache local
      await localDatasource.guardarLote(LoteModel.fromEntity(loteActualizado));

      return Right(loteActualizado);
    } on LoteException catch (e) {
      return Left(ValidationFailure(message: e.mensaje));
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_UPDATE_BATCH', {'e': '$e'}),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> eliminar(String id) async {
    try {
      // Verificar conexión
      if (!await networkInfo.isConnected) {
        return Left(
          NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')),
        );
      }

      // Eliminar de Firebase
      await firebaseDatasource.eliminar(id);

      // Eliminar de cache local
      await localDatasource.eliminarLote(id);

      return const Right(unit);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_DELETE_BATCH', {'e': '$e'}),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Lote>> obtenerPorId(String id) async {
    try {
      // Intentar obtener de Firebase primero
      if (await networkInfo.isConnected) {
        final lote = await firebaseDatasource.obtenerPorId(id);
        if (lote != null) {
          // Actualizar cache
          await localDatasource.guardarLote(LoteModel.fromEntity(lote));
          return Right(lote);
        }
        return Left(
          CacheFailure(message: ErrorMessages.get('ERR_BATCH_NOT_FOUND')),
        );
      }

      // Sin conexión, buscar en cache
      final loteLocal = await localDatasource.obtenerLote(id);
      if (loteLocal != null) {
        return Right(loteLocal.toEntity());
      }

      return Left(
        CacheFailure(message: ErrorMessages.get('ERR_BATCH_OFFLINE')),
      );
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_GET_BATCH', {'e': '$e'}),
        ),
      );
    }
  }

  // ============================================================
  // CONSULTAS
  // ============================================================

  @override
  Future<Either<Failure, List<Lote>>> obtenerPorGranja(String granjaId) async {
    try {
      // Intentar obtener de Firebase
      if (await networkInfo.isConnected) {
        final lotes = await firebaseDatasource.obtenerPorGranja(granjaId);

        // Actualizar cache
        await localDatasource.guardarLotesPorGranja(
          granjaId,
          lotes.map((l) => LoteModel.fromEntity(l)).toList(),
        );

        return Right(lotes);
      }

      // Sin conexión, usar cache
      final lotesLocal = await localDatasource.obtenerLotesPorGranja(granjaId);
      if (lotesLocal != null) {
        return Right(lotesLocal.map((m) => m.toEntity()).toList());
      }

      return const Right([]);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_GET_BATCHES', {'e': '$e'}),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> obtenerPorGalpon(String galponId) async {
    try {
      // Intentar obtener de Firebase
      if (await networkInfo.isConnected) {
        final lotes = await firebaseDatasource.obtenerPorGalpon(galponId);

        // Actualizar cache
        await localDatasource.guardarLotesPorGalpon(
          galponId,
          lotes.map((l) => LoteModel.fromEntity(l)).toList(),
        );

        return Right(lotes);
      }

      // Sin conexión, usar cache
      final lotesLocal = await localDatasource.obtenerLotesPorGalpon(galponId);
      if (lotesLocal != null) {
        return Right(lotesLocal.map((m) => m.toEntity()).toList());
      }

      return const Right([]);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_GET_SHED_BATCHES', {'e': '$e'}),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Lote?>> obtenerLoteActivoDeGalpon(
    String galponId,
  ) async {
    try {
      // Intentar obtener de Firebase
      if (await networkInfo.isConnected) {
        final lote = await firebaseDatasource.obtenerLoteActivoDeGalpon(
          galponId,
        );
        if (lote != null) {
          await localDatasource.guardarLote(LoteModel.fromEntity(lote));
        }
        return Right(lote);
      }

      // Sin conexión, buscar en cache local
      final lotesLocal = await localDatasource.obtenerLotesPorGalpon(galponId);
      if (lotesLocal != null) {
        final activo = lotesLocal.firstWhere(
          (l) => l.estado == EstadoLote.activo,
          orElse: () =>
              throw Exception(ErrorMessages.get('ERR_NO_ACTIVE_BATCH')),
        );
        return Right(activo.toEntity());
      }

      return const Right(null);
    } on Exception {
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> obtenerActivos(String granjaId) async {
    try {
      if (await networkInfo.isConnected) {
        final lotes = await firebaseDatasource.obtenerActivos(granjaId);
        return Right(lotes);
      }

      // Fallback: obtener todos y filtrar
      final result = await obtenerPorGranja(granjaId);
      return result.map((lotes) => lotes.where((l) => l.estaActivo).toList());
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_GET_ACTIVE_BATCHES', {'e': '$e'}),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> obtenerPorEstado(
    String granjaId,
    EstadoLote estado,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final lotes = await firebaseDatasource.obtenerPorEstado(
          granjaId,
          estado,
        );
        return Right(lotes);
      }

      // Fallback: obtener todos y filtrar
      final result = await obtenerPorGranja(granjaId);
      return result.map(
        (lotes) => lotes.where((l) => l.estado == estado).toList(),
      );
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_GET_BATCHES_BY_STATE', {
            'e': '$e',
          }),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> buscar(
    String granjaId,
    String query,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final lotes = await firebaseDatasource.buscar(granjaId, query);
        return Right(lotes);
      }

      // Fallback: buscar en cache
      final result = await obtenerPorGranja(granjaId);
      return result.map((lotes) {
        final queryLower = query.toLowerCase();
        return lotes.where((l) {
          return l.codigo.toLowerCase().contains(queryLower) ||
              (l.nombre?.toLowerCase().contains(queryLower) ?? false);
        }).toList();
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: ErrorMessages.format('ERR_SEARCH', {'e': '$e'})),
      );
    }
  }

  // ============================================================
  // STREAMS
  // ============================================================

  @override
  Stream<Either<Failure, List<Lote>>> watchPorGranja(String granjaId) {
    return firebaseDatasource
        .watchPorGranja(granjaId)
        .map<Either<Failure, List<Lote>>>((lotes) {
          return Right<Failure, List<Lote>>(lotes);
        })
        .onErrorReturnWith((error, _) {
          return Left<Failure, List<Lote>>(
            ServerFailure(
              message: ErrorMessages.format('ERR_STREAM', {'e': '$error'}),
            ),
          );
        });
  }

  @override
  Stream<Either<Failure, List<Lote>>> watchPorGalpon(String galponId) {
    return firebaseDatasource
        .watchPorGalpon(galponId)
        .map<Either<Failure, List<Lote>>>((lotes) {
          return Right<Failure, List<Lote>>(lotes);
        })
        .onErrorReturnWith((error, _) {
          return Left<Failure, List<Lote>>(
            ServerFailure(
              message: ErrorMessages.format('ERR_STREAM', {'e': '$error'}),
            ),
          );
        });
  }

  @override
  Stream<Either<Failure, Lote>> watchPorId(String id) {
    return firebaseDatasource
        .watchPorId(id)
        .map<Either<Failure, Lote>>((lote) {
          if (lote == null) {
            return Left<Failure, Lote>(
              CacheFailure(message: ErrorMessages.get('ERR_BATCH_NOT_FOUND')),
            );
          }
          return Right<Failure, Lote>(lote);
        })
        .onErrorReturnWith((error, _) {
          return Left<Failure, Lote>(
            ServerFailure(
              message: ErrorMessages.format('ERR_STREAM', {'e': '$error'}),
            ),
          );
        });
  }

  // ============================================================
  // OPERACIONES DE NEGOCIO
  // ============================================================

  @override
  Future<Either<Failure, Lote>> registrarMortalidad(
    String loteId,
    int cantidad, {
    String? observacion,
  }) async {
    try {
      final result = await obtenerPorId(loteId);
      return result.fold((failure) => Left(failure), (lote) async {
        final loteActualizado = lote.registrarMortalidad(
          cantidad,
          observacion: observacion,
        );
        return actualizar(loteActualizado);
      });
    } on LoteException catch (e) {
      return Left(ValidationFailure(message: e.mensaje));
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_REGISTER_MORTALITY', {'e': '$e'}),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Lote>> registrarDescarte(
    String loteId,
    int cantidad, {
    String? motivo,
  }) async {
    try {
      final result = await obtenerPorId(loteId);
      return result.fold((failure) => Left(failure), (lote) async {
        final loteActualizado = lote.registrarDescarte(
          cantidad,
          motivo: motivo,
        );
        return actualizar(loteActualizado);
      });
    } on LoteException catch (e) {
      return Left(ValidationFailure(message: e.mensaje));
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_REGISTER_DISCARD', {'e': '$e'}),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Lote>> registrarVenta(
    String loteId,
    int cantidad,
  ) async {
    try {
      final result = await obtenerPorId(loteId);
      return result.fold((failure) => Left(failure), (lote) async {
        final loteActualizado = lote.registrarVenta(cantidad);
        return actualizar(loteActualizado);
      });
    } on LoteException catch (e) {
      return Left(ValidationFailure(message: e.mensaje));
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_REGISTER_SALE', {'e': '$e'}),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Lote>> actualizarPeso(
    String loteId,
    double nuevoPeso,
  ) async {
    try {
      final result = await obtenerPorId(loteId);
      return result.fold((failure) => Left(failure), (lote) async {
        final loteActualizado = lote.actualizarPeso(nuevoPeso);
        return actualizar(loteActualizado);
      });
    } on LoteException catch (e) {
      return Left(ValidationFailure(message: e.mensaje));
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_UPDATE_WEIGHT', {'e': '$e'}),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Lote>> cambiarEstado(
    String loteId,
    EstadoLote nuevoEstado, {
    String? motivo,
  }) async {
    try {
      final result = await obtenerPorId(loteId);
      return result.fold((failure) => Left(failure), (lote) async {
        final loteActualizado = lote.cambiarEstado(nuevoEstado, motivo: motivo);
        return actualizar(loteActualizado);
      });
    } on LoteException catch (e) {
      return Left(ValidationFailure(message: e.mensaje));
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_CHANGE_STATE', {'e': '$e'}),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Lote>> cerrar(String loteId, {String? motivo}) async {
    try {
      final result = await obtenerPorId(loteId);
      return result.fold((failure) => Left(failure), (lote) async {
        final loteCerrado = lote.cerrar(motivo: motivo);
        return actualizar(loteCerrado);
      });
    } on LoteException catch (e) {
      return Left(ValidationFailure(message: e.mensaje));
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_CLOSE_BATCH', {'e': '$e'}),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Lote>> marcarVendido(
    String loteId, {
    String? comprador,
  }) async {
    try {
      final result = await obtenerPorId(loteId);
      return result.fold((failure) => Left(failure), (lote) async {
        final loteVendido = lote.marcarVendido(comprador: comprador);
        return actualizar(loteVendido);
      });
    } on LoteException catch (e) {
      return Left(ValidationFailure(message: e.mensaje));
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_MARK_SOLD', {'e': '$e'}),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Lote>> transferir(
    String loteId,
    String nuevoGalponId,
  ) async {
    try {
      final result = await obtenerPorId(loteId);
      return result.fold((failure) => Left(failure), (lote) async {
        final loteTransferido = lote.transferirAGalpon(nuevoGalponId);
        return actualizar(loteTransferido);
      });
    } on LoteException catch (e) {
      return Left(ValidationFailure(message: e.mensaje));
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_TRANSFER_BATCH', {'e': '$e'}),
        ),
      );
    }
  }

  // ============================================================
  // ESTADÍSTICAS
  // ============================================================

  @override
  Future<Either<Failure, Map<String, dynamic>>> obtenerEstadisticas(
    String granjaId,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final stats = await firebaseDatasource.obtenerEstadisticas(granjaId);
        return Right(stats);
      }

      // Calcular desde cache
      final result = await obtenerPorGranja(granjaId);
      return result.map((lotes) {
        if (lotes.isEmpty) {
          return {
            'totalLotes': 0,
            'lotesActivos': 0,
            'lotesCerrados': 0,
            'totalAves': 0,
            'mortalidadPromedio': 0.0,
          };
        }

        final activos = lotes.where((l) => l.estaActivo).toList();
        final totalAves = activos.fold<int>(
          0,
          (total, l) => total + l.avesActuales,
        );
        final mortalidadPromedio =
            lotes.fold<double>(
              0,
              (total, l) => total + l.porcentajeMortalidad,
            ) /
            lotes.length;

        return {
          'totalLotes': lotes.length,
          'lotesActivos': activos.length,
          'lotesCerrados': lotes.where((l) => l.estaFinalizado).length,
          'totalAves': totalAves,
          'mortalidadPromedio': mortalidadPromedio,
        };
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_GET_STATS', {'e': '$e'}),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Map<EstadoLote, int>>> contarPorEstado(
    String granjaId,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final conteo = await firebaseDatasource.contarPorEstado(granjaId);
        return Right(conteo);
      }

      // Calcular desde cache
      final result = await obtenerPorGranja(granjaId);
      return result.map((lotes) {
        final conteo = <EstadoLote, int>{};
        for (final estado in EstadoLote.values) {
          conteo[estado] = lotes.where((l) => l.estado == estado).length;
        }
        return conteo;
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERR_COUNT_BY_STATE', {'e': '$e'}),
        ),
      );
    }
  }

  // ============================================================
  // CACHÉ
  // ============================================================

  @override
  Future<Either<Failure, Unit>> sincronizar(String granjaId) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(
          NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION_SYNC')),
        );
      }

      // Obtener datos frescos de Firebase
      final lotes = await firebaseDatasource.obtenerPorGranja(granjaId);

      // Actualizar cache
      await localDatasource.guardarLotesPorGranja(
        granjaId,
        lotes.map((l) => LoteModel.fromEntity(l)).toList(),
      );

      return const Right(unit);
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: ErrorMessages.format('ERR_SYNC', {'e': '$e'})),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> limpiarCache() async {
    try {
      await localDatasource.limpiarTodoElCache();
      return const Right(unit);
    } on Exception catch (e) {
      return Left(
        CacheFailure(
          message: ErrorMessages.format('ERR_CLEAR_CACHE', {'e': '$e'}),
        ),
      );
    }
  }

  @override
  Future<bool> hayPendientesSincronizar() async {
    // Por ahora, no hay cola de sincronización pendiente
    // Se podría implementar con una lista de operaciones pendientes
    return false;
  }
}
