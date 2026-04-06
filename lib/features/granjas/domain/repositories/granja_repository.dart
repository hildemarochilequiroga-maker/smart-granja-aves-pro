library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/entities.dart';
import '../enums/enums.dart';

/// Interface del repositorio de Granja
///
/// Define el contrato para operaciones de persistencia de granjas.
/// Sigue el patrón Repository de DDD, abstrayendo la capa de datos.
abstract class GranjaRepository {
  // ==================== OPERACIONES CRUD BÁSICAS ====================

  /// Crea una nueva granja en el sistema
  Future<Either<Failure, Granja>> crear(Granja granja);

  /// Obtiene una granja por su ID
  Future<Either<Failure, Granja?>> obtenerPorId(String id);

  /// Obtiene todas las granjas del usuario actual
  Future<Either<Failure, List<Granja>>> obtenerTodas();

  /// Obtiene todas las granjas de un usuario específico
  Future<Either<Failure, List<Granja>>> obtenerPorUsuario(String usuarioId);

  /// Actualiza una granja existente
  Future<Either<Failure, Granja>> actualizar(Granja granja);

  /// Elimina una granja del sistema
  Future<Either<Failure, bool>> eliminar(String id);

  // ==================== CONSULTAS ESPECIALIZADAS ====================

  /// Obtiene todas las granjas activas del usuario
  Future<Either<Failure, List<Granja>>> obtenerActivas(String usuarioId);

  /// Obtiene granjas por estado
  Future<Either<Failure, List<Granja>>> obtenerPorEstado(
    String usuarioId,
    EstadoGranja estado,
  );

  /// Busca granjas por nombre (búsqueda parcial)
  Future<Either<Failure, List<Granja>>> buscarPorNombre(
    String usuarioId,
    String nombre,
  );

  /// Obtiene granjas cercanas a unas coordenadas (radio en km)
  Future<Either<Failure, List<Granja>>> obtenerCercanas({
    required double latitud,
    required double longitud,
    required double radioKm,
  });

  /// Verifica si existe una granja con un RUC específico
  Future<Either<Failure, bool>> existeConRuc(String ruc);

  /// Obtiene una granja por su RUC
  Future<Either<Failure, Granja?>> obtenerPorRuc(String ruc);

  // ==================== OPERACIONES DE STREAM (TIEMPO REAL) ====================

  /// Stream que emite cambios en una granja específica
  Stream<Granja?> observarGranja(String id);

  /// Stream que emite la lista de granjas del usuario
  Stream<List<Granja>> observarGranjasDelUsuario(String usuarioId);

  /// Stream que emite las granjas activas del usuario
  Stream<List<Granja>> observarGranjasActivas(String usuarioId);

  // ==================== ESTADÍSTICAS ====================

  /// Cuenta el total de granjas del usuario
  Future<Either<Failure, int>> contarPorUsuario(String usuarioId);

  /// Cuenta granjas por estado
  Future<Either<Failure, int>> contarPorEstado(
    String usuarioId,
    EstadoGranja estado,
  );

  /// Obtiene estadísticas generales de granjas del usuario
  Future<Either<Failure, Map<String, dynamic>>> obtenerEstadisticas(
    String usuarioId,
  );
}
