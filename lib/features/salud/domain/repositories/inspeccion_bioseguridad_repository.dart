/// Repositorio para inspecciones de bioseguridad.
library;

import '../entities/entities.dart';

/// Repositorio abstracto para gestión de inspecciones de bioseguridad.
abstract class InspeccionBioseguridadRepository {
  /// Obtiene todas las inspecciones de una granja.
  Future<List<InspeccionBioseguridad>> obtenerInspecciones(String granjaId);

  /// Obtiene una inspección por su ID.
  Future<InspeccionBioseguridad?> obtenerInspeccionPorId(
    String granjaId,
    String id,
  );

  /// Obtiene inspecciones por rango de fechas.
  Future<List<InspeccionBioseguridad>> obtenerInspeccionesPorFecha({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  /// Obtiene la última inspección de una granja o galpón.
  Future<InspeccionBioseguridad?> obtenerUltimaInspeccion({
    required String granjaId,
    String? galponId,
  });

  /// Crea una nueva inspección.
  Future<void> crearInspeccion(InspeccionBioseguridad inspeccion);

  /// Actualiza una inspección existente.
  Future<void> actualizarInspeccion(InspeccionBioseguridad inspeccion);

  /// Elimina una inspección.
  Future<void> eliminarInspeccion(String granjaId, String id);

  /// Obtiene el historial de cumplimiento por categoría.
  Future<Map<String, double>> obtenerHistorialCumplimiento({
    required String granjaId,
    required int meses,
  });

  /// Obtiene inspecciones con incumplimientos críticos.
  Future<List<InspeccionBioseguridad>> obtenerConIncumplimientosCriticos(
    String granjaId,
  );

  /// Escucha cambios en las inspecciones de una granja.
  Stream<List<InspeccionBioseguridad>> watchInspecciones(String granjaId);
}
