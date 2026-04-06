/// Implementación del repositorio de alertas sanitarias.
library;

import '../../domain/entities/entities.dart';
import '../../domain/repositories/alerta_sanitaria_repository.dart';
import '../datasources/alerta_sanitaria_datasource.dart';

/// Implementación del repositorio de alertas sanitarias.
class AlertaSanitariaRepositoryImpl implements AlertaSanitariaRepository {
  final AlertaSanitariaDatasource _datasource;
  final String _granjaId;

  AlertaSanitariaRepositoryImpl(this._datasource, this._granjaId);

  @override
  Future<List<AlertaSanitaria>> obtenerAlertas(String granjaId) async {
    return _datasource.obtenerAlertas(granjaId);
  }

  @override
  Future<AlertaSanitaria?> obtenerAlertaPorId(String id) async {
    final alertas = await _datasource.obtenerAlertas(_granjaId);
    try {
      return alertas.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<AlertaSanitaria>> obtenerAlertasActivas(String granjaId) async {
    return _datasource.obtenerAlertasActivas(granjaId);
  }

  @override
  Future<List<AlertaSanitaria>> obtenerAlertasCriticas(String granjaId) async {
    final alertas = await _datasource.obtenerAlertasActivas(granjaId);
    return alertas.where((a) => a.esCritica).toList();
  }

  @override
  Future<List<AlertaSanitaria>> obtenerAlertasPorFecha({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    final alertas = await _datasource.obtenerAlertas(granjaId);
    return alertas
        .where(
          (a) =>
              a.fechaGeneracion.isAfter(fechaInicio) &&
              a.fechaGeneracion.isBefore(fechaFin),
        )
        .toList();
  }

  @override
  Future<List<AlertaSanitaria>> obtenerAlertasPorTipo(
    String granjaId,
    TipoAlertaSanitaria tipo,
  ) async {
    final alertas = await _datasource.obtenerAlertas(granjaId);
    return alertas.where((a) => a.tipo == tipo).toList();
  }

  @override
  Future<void> crearAlerta(AlertaSanitaria alerta) async {
    await _datasource.crearAlerta(alerta);
  }

  @override
  Future<void> actualizarAlerta(AlertaSanitaria alerta) async {
    await _datasource.actualizarAlerta(alerta);
  }

  @override
  Future<void> resolverAlerta({
    required String alertaId,
    required String resolvedPor,
    required String comentario,
    required EstadoAlerta nuevoEstado,
  }) async {
    await _datasource.resolverAlerta(
      granjaId: _granjaId,
      alertaId: alertaId,
      resolvedPor: resolvedPor,
      comentario: comentario,
      nuevoEstado: nuevoEstado,
    );
  }

  @override
  Future<void> descartarAlerta({
    required String alertaId,
    required String resolvedPor,
    required String motivo,
  }) async {
    await _datasource.resolverAlerta(
      granjaId: _granjaId,
      alertaId: alertaId,
      resolvedPor: resolvedPor,
      comentario: motivo,
      nuevoEstado: EstadoAlerta.descartada,
    );
  }

  @override
  Future<void> eliminarAlerta(String id) async {
    await _datasource.eliminarAlerta(_granjaId, id);
  }

  @override
  Future<Map<NivelAlerta, int>> contarAlertasPorNivel(String granjaId) async {
    final alertas = await _datasource.obtenerAlertasActivas(granjaId);
    final conteo = <NivelAlerta, int>{};
    for (final alerta in alertas) {
      conteo[alerta.nivel] = (conteo[alerta.nivel] ?? 0) + 1;
    }
    return conteo;
  }

  @override
  Future<List<AlertaSanitaria>> obtenerHistorialResueltas({
    required String granjaId,
    required int limite,
  }) async {
    final alertas = await _datasource.obtenerAlertas(granjaId);
    final resueltas =
        alertas.where((a) => a.estado == EstadoAlerta.resuelta).toList()..sort(
          (a, b) => (b.fechaResolucion ?? b.fechaGeneracion).compareTo(
            a.fechaResolucion ?? a.fechaGeneracion,
          ),
        );
    return resueltas.take(limite).toList();
  }

  @override
  Stream<List<AlertaSanitaria>> watchAlertas(String granjaId) {
    return _datasource.watchAlertas(granjaId);
  }

  @override
  Stream<List<AlertaSanitaria>> watchAlertasActivas(String granjaId) {
    return _datasource.watchAlertasActivas(granjaId);
  }
}
