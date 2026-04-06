import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/galpon_evento.dart';
import '../enums/tipo_evento_galpon.dart';

/// Interfaz del repositorio para la gestión de eventos de galpones.
///
/// Maneja el historial de cambios y eventos importantes
/// que ocurren en los galpones.
abstract class GalponEventoRepository {
  // ============================================================
  // OPERACIONES CRUD
  // ============================================================

  /// Registra un nuevo evento para un galpón.
  ///
  /// [evento] - El evento a registrar.
  /// Retorna [Right(GalponEvento)] con el evento creado
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, GalponEvento>> registrar(GalponEvento evento);

  /// Obtiene un evento por su identificador.
  ///
  /// [id] - Identificador único del evento.
  /// Retorna [Right(GalponEvento)] si se encontró
  /// o [Left(Failure)] si no existe o hay error.
  Future<Either<Failure, GalponEvento>> obtenerPorId(String id);

  /// Elimina un evento del historial.
  ///
  /// [id] - Identificador del evento a eliminar.
  /// Retorna [Right(unit)] si se eliminó correctamente
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Unit>> eliminar(String id);

  // ============================================================
  // CONSULTAS
  // ============================================================

  /// Obtiene todos los eventos de un galpón.
  ///
  /// [galponId] - Identificador del galpón.
  /// [limite] - Cantidad máxima de eventos a retornar.
  /// Retorna [Right(List<GalponEvento>)] ordenados por fecha descendente
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, List<GalponEvento>>> obtenerPorGalpon(
    String galponId, {
    int? limite,
  });

  /// Obtiene eventos por tipo.
  ///
  /// [galponId] - Identificador del galpón.
  /// [tipo] - Tipo de evento a filtrar.
  /// Retorna [Right(List<GalponEvento>)] con los eventos del tipo especificado
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, List<GalponEvento>>> obtenerPorTipo(
    String galponId,
    TipoEventoGalpon tipo,
  );

  /// Obtiene eventos en un rango de fechas.
  ///
  /// [galponId] - Identificador del galpón.
  /// [fechaInicio] - Fecha de inicio del rango.
  /// [fechaFin] - Fecha de fin del rango.
  /// Retorna [Right(List<GalponEvento>)] dentro del rango
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, List<GalponEvento>>> obtenerPorRangoFecha(
    String galponId,
    DateTime fechaInicio,
    DateTime fechaFin,
  );

  /// Obtiene el último evento de un galpón.
  ///
  /// [galponId] - Identificador del galpón.
  /// Retorna [Right(GalponEvento)] si existe
  /// o [Left(Failure)] si no hay eventos o hay error.
  Future<Either<Failure, GalponEvento?>> obtenerUltimoEvento(String galponId);

  /// Obtiene el último evento de un tipo específico.
  ///
  /// [galponId] - Identificador del galpón.
  /// [tipo] - Tipo de evento.
  /// Retorna [Right(GalponEvento?)] si existe
  /// o [Left(Failure)] si hay error.
  Future<Either<Failure, GalponEvento?>> obtenerUltimoEventoPorTipo(
    String galponId,
    TipoEventoGalpon tipo,
  );

  // ============================================================
  // STREAMS EN TIEMPO REAL
  // ============================================================

  /// Stream de eventos de un galpón con actualizaciones en tiempo real.
  ///
  /// [galponId] - Identificador del galpón.
  /// [limite] - Cantidad máxima de eventos en el stream.
  /// Retorna un Stream con la lista de eventos actualizada.
  Stream<Either<Failure, List<GalponEvento>>> watchPorGalpon(
    String galponId, {
    int? limite,
  });

  // ============================================================
  // CONSULTAS AGREGADAS
  // ============================================================

  /// Obtiene el conteo de eventos por tipo para un galpón.
  ///
  /// [galponId] - Identificador del galpón.
  /// Retorna un mapa con el conteo por cada tipo de evento.
  Future<Either<Failure, Map<TipoEventoGalpon, int>>> contarPorTipo(
    String galponId,
  );

  /// Obtiene todos los eventos de una granja.
  ///
  /// [granjaId] - Identificador de la granja.
  /// [limite] - Cantidad máxima de eventos a retornar.
  /// Retorna [Right(List<GalponEvento>)] ordenados por fecha descendente
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, List<GalponEvento>>> obtenerPorGranja(
    String granjaId, {
    int? limite,
  });

  // ============================================================
  // OPERACIONES DE MANTENIMIENTO
  // ============================================================

  /// Elimina eventos antiguos.
  ///
  /// [galponId] - Identificador del galpón.
  /// [antiguedadDias] - Eliminar eventos más antiguos que estos días.
  /// Retorna [Right(int)] con la cantidad de eventos eliminados
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, int>> limpiarEventosAntiguos(
    String galponId,
    int antiguedadDias,
  );

  /// Sincroniza los eventos locales con el servidor.
  ///
  /// [galponId] - Identificador del galpón.
  /// Retorna [Right(unit)] si sincronizó correctamente
  /// o [Left(Failure)] si ocurre un error.
  Future<Either<Failure, Unit>> sincronizar(String galponId);
}
