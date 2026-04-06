/// Implementación del repositorio de necropsias.
library;

import '../../../../core/errors/error_messages.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../../domain/repositories/necropsia_repository.dart';
import '../datasources/necropsia_datasource.dart';

/// Implementación del repositorio de necropsias.
class NecropsiaRepositoryImpl implements NecropsiaRepository {
  final NecropsiaDatasource _datasource;
  final String _granjaId;

  NecropsiaRepositoryImpl(this._datasource, this._granjaId);

  @override
  Future<List<Necropsia>> obtenerNecropsias(String granjaId) async {
    return _datasource.obtenerNecropsias(granjaId);
  }

  @override
  Future<Necropsia?> obtenerNecropsiaPorId(String id) async {
    final necropsias = await _datasource.obtenerNecropsias(_granjaId);
    try {
      return necropsias.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Necropsia>> obtenerNecropsiasPorlote(String loteId) async {
    return _datasource.obtenerNecropsiasPorlote(_granjaId, loteId);
  }

  @override
  Future<List<Necropsia>> obtenerNecropsiaPorFecha({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    final necropsias = await _datasource.obtenerNecropsias(granjaId);
    return necropsias
        .where(
          (n) => n.fecha.isAfter(fechaInicio) && n.fecha.isBefore(fechaFin),
        )
        .toList();
  }

  @override
  Future<List<Necropsia>> obtenerNecropsiaPorEnfermedad(
    String granjaId,
    EnfermedadAvicola enfermedad,
  ) async {
    return _datasource.obtenerNecropsiaPorEnfermedad(granjaId, enfermedad);
  }

  @override
  Future<void> crearNecropsia(Necropsia necropsia) async {
    await _datasource.crearNecropsia(_granjaId, necropsia);
  }

  @override
  Future<void> actualizarNecropsia(Necropsia necropsia) async {
    await _datasource.actualizarNecropsia(_granjaId, necropsia);
  }

  @override
  Future<void> actualizarResultadoLaboratorio({
    required String necropsiaId,
    required String muestraId,
    required String resultado,
    required DateTime fechaResultado,
  }) async {
    final necropsia = await obtenerNecropsiaPorId(necropsiaId);
    if (necropsia == null) {
      throw Exception(ErrorMessages.get('ERR_NECROPSY_NOT_FOUND'));
    }

    final muestrasActualizadas = necropsia.muestrasLaboratorio.map((m) {
      if (m.id == muestraId) {
        return MuestraLaboratorio(
          id: m.id,
          tipo: m.tipo,
          fechaEnvio: m.fechaEnvio,
          laboratorio: m.laboratorio,
          fechaResultado: fechaResultado,
          resultado: resultado,
        );
      }
      return m;
    }).toList();

    final necropsiaActualizada = necropsia.copyWith(
      muestrasLaboratorio: muestrasActualizadas,
    );

    await actualizarNecropsia(necropsiaActualizada);
  }

  @override
  Future<void> confirmarDiagnostico({
    required String necropsiaId,
    required String diagnosticoConfirmado,
    EnfermedadAvicola? enfermedadDetectada,
  }) async {
    final necropsia = await obtenerNecropsiaPorId(necropsiaId);
    if (necropsia == null) {
      throw Exception(ErrorMessages.get('ERR_NECROPSY_NOT_FOUND'));
    }

    final necropsiaActualizada = necropsia.copyWith(
      diagnosticoConfirmado: diagnosticoConfirmado,
      enfermedadDetectada: enfermedadDetectada,
    );

    await actualizarNecropsia(necropsiaActualizada);
  }

  @override
  Future<void> eliminarNecropsia(String id) async {
    await _datasource.eliminarNecropsia(_granjaId, id);
  }

  @override
  Future<Map<EnfermedadAvicola, int>> obtenerEstadisticasEnfermedades({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    final necropsias = await obtenerNecropsiaPorFecha(
      granjaId: granjaId,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );

    final estadisticas = <EnfermedadAvicola, int>{};
    for (final necropsia in necropsias) {
      if (necropsia.enfermedadDetectada != null) {
        estadisticas[necropsia.enfermedadDetectada!] =
            (estadisticas[necropsia.enfermedadDetectada!] ?? 0) + 1;
      }
    }

    return estadisticas;
  }

  @override
  Stream<List<Necropsia>> watchNecropsias(String granjaId) {
    return _datasource.watchNecropsias(granjaId);
  }
}
