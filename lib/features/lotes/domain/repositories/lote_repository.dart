import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/lote.dart';
import '../enums/estado_lote.dart';

/// Interfaz del repositorio para la gestión de lotes.
///
/// Define las operaciones disponibles para el manejo de lotes
/// siguiendo los principios de Clean Architecture.
abstract class LoteRepository {
  // ============================================================
  // OPERACIONES CRUD BÁSICAS
  // ============================================================

  /// Crea un nuevo lote en el sistema.
  ///
  /// [lote] - La entidad del lote a crear.
  /// Retorna [Right(Lote)] con el lote creado (incluye ID generado)
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Lote>> crear(Lote lote);

  /// Actualiza un lote existente.
  ///
  /// [lote] - La entidad del lote con los datos actualizados.
  /// Retorna [Right(Lote)] con el lote actualizado
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Lote>> actualizar(Lote lote);

  /// Elimina un lote del sistema.
  ///
  /// [id] - Identificador único del lote a eliminar.
  /// Retorna [Right(unit)] si se eliminó correctamente
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Unit>> eliminar(String id);

  /// Obtiene un lote por su identificador.
  ///
  /// [id] - Identificador único del lote.
  /// Retorna [Right(Lote)] si se encontró
  /// o [Left(Failure)] si no existe o hay error.
  Future<Either<Failure, Lote>> obtenerPorId(String id);

  // ============================================================
  // CONSULTAS Y FILTROS
  // ============================================================

  /// Obtiene todos los lotes de una granja específica.
  ///
  /// [granjaId] - Identificador de la granja.
  /// Retorna [Right(List<Lote>)] con los lotes encontrados
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, List<Lote>>> obtenerPorGranja(String granjaId);

  /// Obtiene todos los lotes de un galpón específico.
  ///
  /// [galponId] - Identificador del galpón.
  /// Retorna [Right(List<Lote>)] con los lotes encontrados
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, List<Lote>>> obtenerPorGalpon(String galponId);

  /// Obtiene el lote activo de un galpón.
  ///
  /// [galponId] - Identificador del galpón.
  /// Retorna [Right(Lote?)] con el lote activo o null si no hay
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Lote?>> obtenerLoteActivoDeGalpon(String galponId);

  /// Obtiene todos los lotes activos de una granja.
  ///
  /// [granjaId] - Identificador de la granja.
  /// Retorna [Right(List<Lote>)] con los lotes activos
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, List<Lote>>> obtenerActivos(String granjaId);

  /// Obtiene lotes por estado.
  ///
  /// [granjaId] - Identificador de la granja.
  /// [estado] - Estado de los lotes a filtrar.
  /// Retorna [Right(List<Lote>)] con los lotes en ese estado
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, List<Lote>>> obtenerPorEstado(
    String granjaId,
    EstadoLote estado,
  );

  /// Busca lotes por código o nombre.
  ///
  /// [granjaId] - Identificador de la granja.
  /// [query] - Texto a buscar en código o nombre.
  /// Retorna [Right(List<Lote>)] con los resultados
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, List<Lote>>> buscar(String granjaId, String query);

  // ============================================================
  // STREAMS EN TIEMPO REAL
  // ============================================================

  /// Stream de lotes de una granja con actualizaciones en tiempo real.
  ///
  /// [granjaId] - Identificador de la granja.
  /// Retorna un Stream que emite la lista actualizada de lotes.
  Stream<Either<Failure, List<Lote>>> watchPorGranja(String granjaId);

  /// Stream de lotes de un galpón con actualizaciones en tiempo real.
  ///
  /// [galponId] - Identificador del galpón.
  /// Retorna un Stream que emite la lista actualizada de lotes.
  Stream<Either<Failure, List<Lote>>> watchPorGalpon(String galponId);

  /// Stream de un lote específico con actualizaciones en tiempo real.
  ///
  /// [id] - Identificador del lote.
  /// Retorna un Stream que emite el lote actualizado.
  Stream<Either<Failure, Lote>> watchPorId(String id);

  // ============================================================
  // OPERACIONES DE NEGOCIO
  // ============================================================

  /// Registra mortalidad en un lote.
  ///
  /// [loteId] - Identificador del lote.
  /// [cantidad] - Cantidad de aves muertas.
  /// [observacion] - Observación opcional.
  /// Retorna [Right(Lote)] con el lote actualizado
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Lote>> registrarMortalidad(
    String loteId,
    int cantidad, {
    String? observacion,
  });

  /// Registra descarte en un lote.
  ///
  /// [loteId] - Identificador del lote.
  /// [cantidad] - Cantidad de aves descartadas.
  /// [motivo] - Motivo del descarte.
  /// Retorna [Right(Lote)] con el lote actualizado
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Lote>> registrarDescarte(
    String loteId,
    int cantidad, {
    String? motivo,
  });

  /// Registra venta parcial de aves.
  ///
  /// [loteId] - Identificador del lote.
  /// [cantidad] - Cantidad de aves vendidas.
  /// Retorna [Right(Lote)] con el lote actualizado
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Lote>> registrarVenta(String loteId, int cantidad);

  /// Actualiza el peso promedio del lote.
  ///
  /// [loteId] - Identificador del lote.
  /// [nuevoPeso] - Nuevo peso promedio (kg).
  /// Retorna [Right(Lote)] con el lote actualizado
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Lote>> actualizarPeso(String loteId, double nuevoPeso);

  /// Cambia el estado de un lote.
  ///
  /// [loteId] - Identificador del lote.
  /// [nuevoEstado] - Nuevo estado a asignar.
  /// [motivo] - Motivo del cambio de estado.
  /// Retorna [Right(Lote)] con el lote actualizado
  /// o [Left(Failure)] si la transición no es válida.
  Future<Either<Failure, Lote>> cambiarEstado(
    String loteId,
    EstadoLote nuevoEstado, {
    String? motivo,
  });

  /// Cierra un lote.
  ///
  /// [loteId] - Identificador del lote.
  /// [motivo] - Motivo del cierre.
  /// Retorna [Right(Lote)] con el lote cerrado
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Lote>> cerrar(String loteId, {String? motivo});

  /// Marca un lote como vendido.
  ///
  /// [loteId] - Identificador del lote.
  /// [comprador] - Nombre del comprador (opcional).
  /// Retorna [Right(Lote)] con el lote actualizado
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Lote>> marcarVendido(
    String loteId, {
    String? comprador,
  });

  /// Transfiere un lote a otro galpón.
  ///
  /// [loteId] - Identificador del lote.
  /// [nuevoGalponId] - ID del galpón destino.
  /// Retorna [Right(Lote)] con el lote transferido
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Lote>> transferir(String loteId, String nuevoGalponId);

  // ============================================================
  // ESTADÍSTICAS
  // ============================================================

  /// Obtiene estadísticas de los lotes de una granja.
  ///
  /// [granjaId] - Identificador de la granja.
  /// Retorna [Right(Map<String, dynamic>)] con las estadísticas
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Map<String, dynamic>>> obtenerEstadisticas(
    String granjaId,
  );

  /// Obtiene el conteo de lotes por estado.
  ///
  /// [granjaId] - Identificador de la granja.
  /// Retorna un mapa con el conteo por cada estado.
  Future<Either<Failure, Map<EstadoLote, int>>> contarPorEstado(
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

  /// Limpia la caché local de lotes.
  Future<Either<Failure, Unit>> limpiarCache();

  /// Verifica si hay datos pendientes de sincronizar.
  Future<bool> hayPendientesSincronizar();
}
