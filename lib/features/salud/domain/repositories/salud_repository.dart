import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/salud_registro.dart';

/// Repository interface para SaludRegistro.
abstract class SaludRepository {
  // CRUD
  Future<Either<Failure, SaludRegistro>> crear(SaludRegistro registro);
  Future<Either<Failure, SaludRegistro?>> obtenerPorId(String id);
  Future<Either<Failure, List<SaludRegistro>>> obtenerTodos();
  Future<Either<Failure, SaludRegistro>> actualizar(SaludRegistro registro);
  Future<Either<Failure, Unit>> eliminar(String id);

  // Consultas
  Future<Either<Failure, List<SaludRegistro>>> obtenerPorLote(String loteId);
  Future<Either<Failure, List<SaludRegistro>>> obtenerAbiertos(String loteId);
  Future<Either<Failure, List<SaludRegistro>>> obtenerCerrados(String loteId);
  Future<Either<Failure, List<SaludRegistro>>> obtenerPorGranja(
    String granjaId,
  );
  Future<Either<Failure, List<SaludRegistro>>> obtenerPorPeriodo({
    required DateTime desde,
    required DateTime hasta,
  });

  // Streams
  Stream<List<SaludRegistro>> observarTodos();
  Stream<List<SaludRegistro>> observarPorLote(String loteId);
  Stream<List<SaludRegistro>> observarPorGranja(String granjaId);

  // Estadísticas
  Future<Either<Failure, int>> contarRegistrosLote(String loteId);
  Future<Either<Failure, int>> contarAbiertosLote(String loteId);
  Future<Either<Failure, Map<String, int>>> obtenerDistribucionDiagnosticos(
    String granjaId,
  );
}
