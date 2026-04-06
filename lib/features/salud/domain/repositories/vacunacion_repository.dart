import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vacunacion.dart';

/// Repository interface para Vacunacion.
abstract class VacunacionRepository {
  // CRUD
  Future<Either<Failure, Vacunacion>> crear(Vacunacion vacunacion);
  Future<Either<Failure, Vacunacion?>> obtenerPorId(String id);
  Future<Either<Failure, List<Vacunacion>>> obtenerTodos();
  Future<Either<Failure, Vacunacion>> actualizar(Vacunacion vacunacion);
  Future<Either<Failure, Unit>> eliminar(String id);

  // Consultas
  Future<Either<Failure, List<Vacunacion>>> obtenerPorLote(String loteId);
  Future<Either<Failure, List<Vacunacion>>> obtenerPendientes(String loteId);
  Future<Either<Failure, List<Vacunacion>>> obtenerAplicadas(String loteId);
  Future<Either<Failure, List<Vacunacion>>> obtenerProximas({
    int diasUmbral = 7,
  });
  Future<Either<Failure, List<Vacunacion>>> obtenerVencidas(String loteId);
  Future<Either<Failure, List<Vacunacion>>> obtenerPorGranja(String granjaId);

  // Streams
  Stream<List<Vacunacion>> observarPorLote(String loteId);
  Stream<List<Vacunacion>> observarPorGranja(String granjaId);
  Stream<List<Vacunacion>> observarProximas();

  // Estadísticas
  Future<Either<Failure, int>> contarVacunacionesLote(String loteId);
  Future<Either<Failure, int>> contarPendientesLote(String loteId);
  Future<Either<Failure, Map<String, int>>> obtenerDistribucionVacunas(
    String granjaId,
  );
}
