import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/vacunacion.dart';
import '../../domain/repositories/vacunacion_repository.dart';
import '../datasources/vacunacion_remote_datasource.dart';

class VacunacionRepositoryImpl implements VacunacionRepository {
  final VacunacionRemoteDatasource _remoteDatasource;

  VacunacionRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, Vacunacion>> crear(Vacunacion vacunacion) async {
    try {
      final result = await _remoteDatasource.crear(vacunacion);
      return Right(result);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Vacunacion?>> obtenerPorId(String id) async {
    try {
      final result = await _remoteDatasource.obtenerPorId(id);
      return Right(result);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Vacunacion>>> obtenerTodos() async {
    try {
      final result = await _remoteDatasource.obtenerTodos();
      return Right(result);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Vacunacion>> actualizar(Vacunacion vacunacion) async {
    try {
      final actualizado = await _remoteDatasource.actualizar(vacunacion);
      return Right(actualizado);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> eliminar(String id) async {
    try {
      await _remoteDatasource.eliminar(id);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Vacunacion>>> obtenerPorLote(
    String loteId,
  ) async {
    try {
      final result = await _remoteDatasource.obtenerPorLote(loteId);
      return Right(result);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Vacunacion>>> obtenerPendientes(
    String loteId,
  ) async {
    try {
      final vacunaciones = await _remoteDatasource.obtenerPorLote(loteId);
      return Right(vacunaciones.where((v) => !v.aplicada).toList());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Vacunacion>>> obtenerAplicadas(
    String loteId,
  ) async {
    try {
      final vacunaciones = await _remoteDatasource.obtenerPorLote(loteId);
      return Right(vacunaciones.where((v) => v.aplicada).toList());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Vacunacion>>> obtenerProximas({
    int diasUmbral = 7,
  }) async {
    try {
      final vacunaciones = await _remoteDatasource.obtenerTodos();
      final ahora = DateTime.now();
      final umbral = ahora.add(Duration(days: diasUmbral));

      final proximas = vacunaciones
          .where(
            (v) =>
                !v.aplicada &&
                v.fechaProgramada.isAfter(ahora) &&
                v.fechaProgramada.isBefore(umbral),
          )
          .toList();

      return Right(proximas);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Vacunacion>>> obtenerVencidas(
    String loteId,
  ) async {
    try {
      final vacunaciones = await _remoteDatasource.obtenerPorLote(loteId);
      final ahora = DateTime.now();

      final vencidas = vacunaciones
          .where((v) => !v.aplicada && v.fechaProgramada.isBefore(ahora))
          .toList();

      return Right(vencidas);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Vacunacion>>> obtenerPorGranja(
    String granjaId,
  ) async {
    try {
      final result = await _remoteDatasource.obtenerPorGranja(granjaId);
      return Right(result);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<Vacunacion>> observarPorLote(String loteId) {
    return _remoteDatasource.observarPorLote(loteId);
  }

  @override
  Stream<List<Vacunacion>> observarPorGranja(String granjaId) {
    return _remoteDatasource.observarPorGranja(granjaId);
  }

  @override
  Stream<List<Vacunacion>> observarProximas() {
    // Retorna stream vacío o implementa lógica específica
    return Stream.value([]);
  }

  @override
  Future<Either<Failure, int>> contarVacunacionesLote(String loteId) async {
    try {
      final vacunaciones = await _remoteDatasource.obtenerPorLote(loteId);
      return Right(vacunaciones.length);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> contarPendientesLote(String loteId) async {
    try {
      final vacunaciones = await _remoteDatasource.obtenerPorLote(loteId);
      return Right(vacunaciones.where((v) => !v.aplicada).length);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> obtenerDistribucionVacunas(
    String granjaId,
  ) async {
    try {
      final vacunaciones = await _remoteDatasource.obtenerPorGranja(granjaId);
      final distribucion = <String, int>{};

      for (final vacunacion in vacunaciones) {
        final nombre = vacunacion.nombreVacuna;
        distribucion[nombre] = (distribucion[nombre] ?? 0) + 1;
      }

      return Right(distribucion);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
