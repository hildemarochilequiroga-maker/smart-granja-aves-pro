import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/galpon.dart';
import '../enums/estado_galpon.dart';

/// Interfaz del repositorio para la gestión de galpones.
///
/// Define las operaciones disponibles para el manejo de galpones
/// siguiendo los principios de Clean Architecture.
abstract class GalponRepository {
  // ============================================================
  // OPERACIONES CRUD BÁSICAS
  // ============================================================

  /// Crea un nuevo galpón en el sistema.
  ///
  /// [galpon] - La entidad del galpón a crear.
  /// Retorna [Right(Galpon)] con el galpón creado (incluye ID generado)
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Galpon>> crear(Galpon galpon);

  /// Actualiza un galpón existente.
  ///
  /// [galpon] - La entidad del galpón con los datos actualizados.
  /// Retorna [Right(Galpon)] con el galpón actualizado
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Galpon>> actualizar(Galpon galpon);

  /// Elimina un galpón del sistema.
  ///
  /// [id] - Identificador único del galpón a eliminar.
  /// Retorna [Right(unit)] si se eliminó correctamente
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Unit>> eliminar(String id);

  /// Obtiene un galpón por su identificador.
  ///
  /// [id] - Identificador único del galpón.
  /// Retorna [Right(Galpon)] si se encontró
  /// o [Left(Failure)] si no existe o hay error.
  Future<Either<Failure, Galpon>> obtenerPorId(String id);

  // ============================================================
  // CONSULTAS Y FILTROS
  // ============================================================

  /// Obtiene todos los galpones de una granja específica.
  ///
  /// [granjaId] - Identificador de la granja.
  /// Retorna [Right(List<Galpon>)] con los galpones encontrados
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, List<Galpon>>> obtenerPorGranja(String granjaId);

  /// Obtiene todos los galpones disponibles (sin lote asignado).
  ///
  /// [granjaId] - Identificador de la granja.
  /// Retorna [Right(List<Galpon>)] con los galpones disponibles
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, List<Galpon>>> obtenerDisponibles(String granjaId);

  /// Obtiene galpones por estado.
  ///
  /// [granjaId] - Identificador de la granja.
  /// [estado] - Estado de los galpones a filtrar.
  /// Retorna [Right(List<Galpon>)] con los galpones en ese estado
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, List<Galpon>>> obtenerPorEstado(
    String granjaId,
    EstadoGalpon estado,
  );

  /// Busca galpones por nombre o código.
  ///
  /// [granjaId] - Identificador de la granja.
  /// [query] - Texto a buscar en nombre o código.
  /// Retorna [Right(List<Galpon>)] con los resultados
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, List<Galpon>>> buscar(String granjaId, String query);

  // ============================================================
  // STREAMS EN TIEMPO REAL
  // ============================================================

  /// Stream de galpones de una granja con actualizaciones en tiempo real.
  ///
  /// [granjaId] - Identificador de la granja.
  /// Retorna un Stream que emite la lista actualizada de galpones.
  Stream<Either<Failure, List<Galpon>>> watchPorGranja(String granjaId);

  /// Stream de un galpón específico con actualizaciones en tiempo real.
  ///
  /// [id] - Identificador del galpón.
  /// Retorna un Stream que emite el galpón actualizado.
  Stream<Either<Failure, Galpon>> watchPorId(String id);

  // ============================================================
  // OPERACIONES DE ESTADO
  // ============================================================

  /// Cambia el estado de un galpón.
  ///
  /// [id] - Identificador del galpón.
  /// [nuevoEstado] - Nuevo estado a asignar.
  /// [motivo] - Motivo del cambio de estado.
  /// Retorna [Right(Galpon)] con el galpón actualizado
  /// o [Left(Failure)] si la transición no es válida.
  Future<Either<Failure, Galpon>> cambiarEstado(
    String id,
    EstadoGalpon nuevoEstado, {
    String? motivo,
  });

  /// Asigna un lote a un galpón.
  ///
  /// [galponId] - Identificador del galpón.
  /// [loteId] - Identificador del lote a asignar.
  /// Retorna [Right(Galpon)] con el galpón actualizado
  /// o [Left(Failure)] si no se puede asignar.
  Future<Either<Failure, Galpon>> asignarLote(String galponId, String loteId);

  /// Libera un galpón del lote asignado.
  ///
  /// [galponId] - Identificador del galpón.
  /// Retorna [Right(Galpon)] con el galpón liberado
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Galpon>> liberar(String galponId);

  // ============================================================
  // OPERACIONES DE MANTENIMIENTO
  // ============================================================

  /// Programa un mantenimiento para el galpón.
  ///
  /// [galponId] - Identificador del galpón.
  /// [fechaInicio] - Fecha de inicio del mantenimiento.
  /// [descripcion] - Descripción del mantenimiento.
  /// Retorna [Right(Galpon)] con el galpón actualizado
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Galpon>> programarMantenimiento(
    String galponId,
    DateTime fechaInicio,
    String descripcion,
  );

  /// Registra una desinfección realizada.
  ///
  /// [galponId] - Identificador del galpón.
  /// [fechaDesinfeccion] - Fecha de la desinfección.
  /// [productos] - Productos utilizados.
  /// [observaciones] - Observaciones adicionales.
  /// Retorna [Right(Galpon)] con el galpón actualizado
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Galpon>> registrarDesinfeccion(
    String galponId,
    DateTime fechaDesinfeccion,
    List<String> productos, {
    String? observaciones,
  });

  // ============================================================
  // ESTADÍSTICAS
  // ============================================================

  /// Obtiene estadísticas de los galpones de una granja.
  ///
  /// [granjaId] - Identificador de la granja.
  /// Retorna [Right(Map<String, dynamic>)] con las estadísticas
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Map<String, dynamic>>> obtenerEstadisticas(
    String granjaId,
  );

  /// Obtiene el conteo de galpones por estado.
  ///
  /// [granjaId] - Identificador de la granja.
  /// Retorna un mapa con el conteo por cada estado.
  Future<Either<Failure, Map<EstadoGalpon, int>>> contarPorEstado(
    String granjaId,
  );

  // ============================================================
  // OPERACIONES DE CACHÉ
  // ============================================================

  /// Sincroniza los datos locales con el servidor.
  ///
  /// [granjaId] - Identificador de la granja.
  /// Retorna [Right(unit)] si sincronizó correctamente
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Unit>> sincronizar(String granjaId);

  /// Limpia la caché local de galpones.
  Future<Either<Failure, Unit>> limpiarCache();

  /// Verifica si hay datos pendientes de sincronizar.
  Future<bool> hayPendientesSincronizar();
}
