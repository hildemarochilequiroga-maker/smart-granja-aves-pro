/// Repositorio para uso de antimicrobianos.
library;

import '../entities/entities.dart';
import '../enums/enums.dart';

/// Repositorio abstracto para gestión de uso de antimicrobianos.
abstract class UsoAntimicrobianoRepository {
  /// Obtiene todos los usos de antimicrobianos de una granja.
  Future<List<UsoAntimicrobiano>> obtenerUsos(String granjaId);

  /// Obtiene un uso por su ID.
  Future<UsoAntimicrobiano?> obtenerUsoPorId(String id);

  /// Obtiene usos por lote.
  Future<List<UsoAntimicrobiano>> obtenerUsosPorLote(String loteId);

  /// Obtiene usos por rango de fechas.
  Future<List<UsoAntimicrobiano>> obtenerUsosPorFecha({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  /// Obtiene lotes en período de retiro.
  Future<List<UsoAntimicrobiano>> obtenerLotesEnRetiro(String granjaId);

  /// Crea un nuevo registro de uso.
  Future<void> crearUso(UsoAntimicrobiano uso);

  /// Actualiza un registro existente.
  Future<void> actualizarUso(UsoAntimicrobiano uso);

  /// Elimina un registro.
  Future<void> eliminarUso(String id);

  /// Genera reporte de uso de antimicrobianos.
  Future<ReporteAntimicrobianos> generarReporte({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  /// Obtiene uso por familia de antimicrobiano.
  Future<Map<FamiliaAntimicrobiano, int>> obtenerUsoPorFamilia({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  /// Verifica si un lote está en retiro.
  Future<bool> verificarRetiroActivo(String loteId);

  /// Obtiene la fecha de liberación de un lote.
  Future<DateTime?> obtenerFechaLiberacion(String loteId);

  /// Escucha cambios en los usos de una granja.
  Stream<List<UsoAntimicrobiano>> watchUsos(String granjaId);
}
