import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/salud_registro.dart';
import '../../domain/repositories/salud_repository.dart';
import '../datasources/salud_remote_datasource.dart';

class SaludRepositoryImpl implements SaludRepository {
  final SaludRemoteDatasource _remoteDatasource;

  SaludRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, SaludRegistro>> crear(SaludRegistro registro) async {
    try {
      final result = await _remoteDatasource.crear(registro);
      return Right(result);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SaludRegistro?>> obtenerPorId(String id) async {
    try {
      final result = await _remoteDatasource.obtenerPorId(id);
      return Right(result);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SaludRegistro>>> obtenerTodos() async {
    try {
      final result = await _remoteDatasource.obtenerTodos();
      return Right(result);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SaludRegistro>> actualizar(
    SaludRegistro registro,
  ) async {
    try {
      final actualizado = await _remoteDatasource.actualizar(registro);
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
  Future<Either<Failure, List<SaludRegistro>>> obtenerPorLote(
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
  Future<Either<Failure, List<SaludRegistro>>> obtenerAbiertos(
    String loteId,
  ) async {
    try {
      final registros = await _remoteDatasource.obtenerPorLote(loteId);
      return Right(registros.where((r) => r.estaAbierto).toList());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SaludRegistro>>> obtenerCerrados(
    String loteId,
  ) async {
    try {
      final registros = await _remoteDatasource.obtenerPorLote(loteId);
      return Right(registros.where((r) => r.estaCerrado).toList());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SaludRegistro>>> obtenerPorGranja(
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
  Future<Either<Failure, List<SaludRegistro>>> obtenerPorPeriodo({
    required DateTime desde,
    required DateTime hasta,
  }) async {
    try {
      final registros = await _remoteDatasource.obtenerTodos();
      final filtered = registros.where((r) {
        return r.fecha.isAfter(desde.subtract(const Duration(days: 1))) &&
            r.fecha.isBefore(hasta.add(const Duration(days: 1)));
      }).toList();
      return Right(filtered);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<SaludRegistro>> observarTodos() {
    return _remoteDatasource.observarTodos();
  }

  @override
  Stream<List<SaludRegistro>> observarPorLote(String loteId) {
    return _remoteDatasource.observarPorLote(loteId);
  }

  @override
  Stream<List<SaludRegistro>> observarPorGranja(String granjaId) {
    return _remoteDatasource.observarPorGranja(granjaId);
  }

  @override
  Future<Either<Failure, int>> contarRegistrosLote(String loteId) async {
    try {
      final registros = await _remoteDatasource.obtenerPorLote(loteId);
      return Right(registros.length);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> contarAbiertosLote(String loteId) async {
    try {
      final registros = await _remoteDatasource.obtenerPorLote(loteId);
      return Right(registros.where((r) => r.estaAbierto).length);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> obtenerDistribucionDiagnosticos(
    String granjaId,
  ) async {
    try {
      final registros = await _remoteDatasource.obtenerPorGranja(granjaId);
      final distribucion = <String, int>{};
      for (final registro in registros) {
        final diagnostico = registro.diagnostico;
        distribucion[diagnostico] = (distribucion[diagnostico] ?? 0) + 1;
      }
      return Right(distribucion);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
