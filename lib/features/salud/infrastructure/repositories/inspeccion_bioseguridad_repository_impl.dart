/// Implementación del repositorio de inspecciones de bioseguridad.
library;

import '../../domain/entities/entities.dart';
import '../../domain/repositories/inspeccion_bioseguridad_repository.dart';
import '../datasources/inspeccion_bioseguridad_datasource.dart';

/// Implementación del repositorio de inspecciones de bioseguridad.
class InspeccionBioseguridadRepositoryImpl
    implements InspeccionBioseguridadRepository {
  final InspeccionBioseguridadDatasource _datasource;

  InspeccionBioseguridadRepositoryImpl(this._datasource);

  @override
  Future<List<InspeccionBioseguridad>> obtenerInspecciones(
    String granjaId,
  ) async {
    return _datasource.obtenerInspecciones(granjaId);
  }

  @override
  Future<InspeccionBioseguridad?> obtenerInspeccionPorId(
    String granjaId,
    String id,
  ) async {
    return _datasource.obtenerInspeccionPorId(granjaId, id);
  }

  @override
  Future<List<InspeccionBioseguridad>> obtenerInspeccionesPorFecha({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    return _datasource.obtenerInspeccionesPorFecha(
      granjaId: granjaId,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
  }

  @override
  Future<InspeccionBioseguridad?> obtenerUltimaInspeccion({
    required String granjaId,
    String? galponId,
  }) async {
    return _datasource.obtenerUltimaInspeccion(
      granjaId: granjaId,
      galponId: galponId,
    );
  }

  @override
  Future<void> crearInspeccion(InspeccionBioseguridad inspeccion) async {
    await _datasource.crearInspeccion(inspeccion);
  }

  @override
  Future<void> actualizarInspeccion(InspeccionBioseguridad inspeccion) async {
    await _datasource.actualizarInspeccion(inspeccion);
  }

  @override
  Future<void> eliminarInspeccion(String granjaId, String id) async {
    await _datasource.eliminarInspeccion(granjaId, id);
  }

  @override
  Future<Map<String, double>> obtenerHistorialCumplimiento({
    required String granjaId,
    required int meses,
  }) async {
    final fechaFin = DateTime.now();
    final fechaInicio = DateTime(
      fechaFin.year,
      fechaFin.month - meses,
      fechaFin.day,
    );

    final inspecciones = await _datasource.obtenerInspeccionesPorFecha(
      granjaId: granjaId,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );

    if (inspecciones.isEmpty) return {};

    // Calcular promedio de cumplimiento por mes
    final resultados = <String, List<double>>{};
    for (final inspeccion in inspecciones) {
      final mesKey =
          '${inspeccion.fecha.year}-${inspeccion.fecha.month.toString().padLeft(2, '0')}';
      resultados.putIfAbsent(mesKey, () => []);
      resultados[mesKey]!.add(inspeccion.porcentajeCumplimiento);
    }

    return resultados.map(
      (key, value) =>
          MapEntry(key, value.reduce((a, b) => a + b) / value.length),
    );
  }

  @override
  Future<List<InspeccionBioseguridad>> obtenerConIncumplimientosCriticos(
    String granjaId,
  ) async {
    return _datasource.obtenerConIncumplimientosCriticos(granjaId);
  }

  @override
  Stream<List<InspeccionBioseguridad>> watchInspecciones(String granjaId) {
    return _datasource.watchInspecciones(granjaId);
  }
}
