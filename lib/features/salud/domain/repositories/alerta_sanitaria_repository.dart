/// Repositorio para alertas sanitarias.
library;

import '../entities/entities.dart';

/// Repositorio abstracto para gestión de alertas sanitarias.
abstract class AlertaSanitariaRepository {
  /// Obtiene todas las alertas de una granja.
  Future<List<AlertaSanitaria>> obtenerAlertas(String granjaId);

  /// Obtiene una alerta por su ID.
  Future<AlertaSanitaria?> obtenerAlertaPorId(String id);

  /// Obtiene alertas activas.
  Future<List<AlertaSanitaria>> obtenerAlertasActivas(String granjaId);

  /// Obtiene alertas críticas.
  Future<List<AlertaSanitaria>> obtenerAlertasCriticas(String granjaId);

  /// Obtiene alertas por rango de fechas.
  Future<List<AlertaSanitaria>> obtenerAlertasPorFecha({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  /// Obtiene alertas por tipo.
  Future<List<AlertaSanitaria>> obtenerAlertasPorTipo(
    String granjaId,
    TipoAlertaSanitaria tipo,
  );

  /// Crea una nueva alerta.
  Future<void> crearAlerta(AlertaSanitaria alerta);

  /// Actualiza una alerta existente.
  Future<void> actualizarAlerta(AlertaSanitaria alerta);

  /// Resuelve una alerta.
  Future<void> resolverAlerta({
    required String alertaId,
    required String resolvedPor,
    required String comentario,
    required EstadoAlerta nuevoEstado,
  });

  /// Descarta una alerta (falsa alarma).
  Future<void> descartarAlerta({
    required String alertaId,
    required String resolvedPor,
    required String motivo,
  });

  /// Elimina una alerta.
  Future<void> eliminarAlerta(String id);

  /// Cuenta alertas activas por nivel.
  Future<Map<NivelAlerta, int>> contarAlertasPorNivel(String granjaId);

  /// Obtiene el historial de alertas resueltas.
  Future<List<AlertaSanitaria>> obtenerHistorialResueltas({
    required String granjaId,
    required int limite,
  });

  /// Escucha cambios en las alertas de una granja.
  Stream<List<AlertaSanitaria>> watchAlertas(String granjaId);

  /// Escucha alertas activas en tiempo real.
  Stream<List<AlertaSanitaria>> watchAlertasActivas(String granjaId);
}
