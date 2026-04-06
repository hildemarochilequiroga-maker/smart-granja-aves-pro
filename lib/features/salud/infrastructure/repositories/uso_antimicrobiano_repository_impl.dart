/// Implementación del repositorio de uso de antimicrobianos.
library;

import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../../domain/repositories/uso_antimicrobiano_repository.dart';
import '../datasources/uso_antimicrobiano_datasource.dart';

/// Implementación del repositorio de uso de antimicrobianos.
class UsoAntimicrobianoRepositoryImpl implements UsoAntimicrobianoRepository {
  final UsoAntimicrobianoDatasource _datasource;
  final String _granjaId;

  UsoAntimicrobianoRepositoryImpl(this._datasource, this._granjaId);

  @override
  Future<List<UsoAntimicrobiano>> obtenerUsos(String granjaId) async {
    return _datasource.obtenerUsos(granjaId);
  }

  @override
  Future<UsoAntimicrobiano?> obtenerUsoPorId(String id) async {
    final usos = await _datasource.obtenerUsos(_granjaId);
    try {
      return usos.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<UsoAntimicrobiano>> obtenerUsosPorLote(String loteId) async {
    return _datasource.obtenerUsosPorLote(_granjaId, loteId);
  }

  @override
  Future<List<UsoAntimicrobiano>> obtenerUsosPorFecha({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    final usos = await _datasource.obtenerUsos(granjaId);
    return usos
        .where(
          (u) =>
              u.fechaInicio.isAfter(fechaInicio) &&
              u.fechaInicio.isBefore(fechaFin),
        )
        .toList();
  }

  @override
  Future<List<UsoAntimicrobiano>> obtenerLotesEnRetiro(String granjaId) async {
    return _datasource.obtenerLotesEnRetiro(granjaId);
  }

  @override
  Future<void> crearUso(UsoAntimicrobiano uso) async {
    await _datasource.crearUso(_granjaId, uso);
  }

  @override
  Future<void> actualizarUso(UsoAntimicrobiano uso) async {
    await _datasource.actualizarUso(_granjaId, uso);
  }

  @override
  Future<void> eliminarUso(String id) async {
    await _datasource.eliminarUso(_granjaId, id);
  }

  @override
  Future<ReporteAntimicrobianos> generarReporte({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    final usos = await obtenerUsosPorFecha(
      granjaId: granjaId,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );

    // Calcular estadísticas
    final usoPorFamilia = <FamiliaAntimicrobiano, int>{};
    final usoPorCategoria = <CategoriaOmsAntimicrobiano, int>{};
    final usoPorMotivo = <MotivoUsoAntimicrobiano, int>{};
    int totalAvesTratadas = 0;

    for (final uso in usos) {
      usoPorFamilia[uso.familia] = (usoPorFamilia[uso.familia] ?? 0) + 1;
      usoPorCategoria[uso.categoriaOms] =
          (usoPorCategoria[uso.categoriaOms] ?? 0) + 1;
      usoPorMotivo[uso.motivoUso] = (usoPorMotivo[uso.motivoUso] ?? 0) + 1;
      totalAvesTratadas += uso.avesAfectadas;
    }

    return ReporteAntimicrobianos(
      granjaId: granjaId,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
      registros: usos,
      totalTratamientos: usos.length,
      totalAvesTratadas: totalAvesTratadas,
      usoPorFamilia: usoPorFamilia,
      usoPorCategoria: usoPorCategoria,
      usoPorMotivo: usoPorMotivo,
    );
  }

  @override
  Future<Map<FamiliaAntimicrobiano, int>> obtenerUsoPorFamilia({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    final usos = await obtenerUsosPorFecha(
      granjaId: granjaId,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );

    final usoPorFamilia = <FamiliaAntimicrobiano, int>{};
    for (final uso in usos) {
      usoPorFamilia[uso.familia] = (usoPorFamilia[uso.familia] ?? 0) + 1;
    }

    return usoPorFamilia;
  }

  @override
  Future<bool> verificarRetiroActivo(String loteId) async {
    final usos = await _datasource.obtenerUsosPorLote(_granjaId, loteId);
    final ahora = DateTime.now();
    return usos.any((u) => u.fechaLiberacion.isAfter(ahora));
  }

  @override
  Future<DateTime?> obtenerFechaLiberacion(String loteId) async {
    final usos = await _datasource.obtenerUsosPorLote(_granjaId, loteId);
    final ahora = DateTime.now();
    final usosEnRetiro = usos
        .where((u) => u.fechaLiberacion.isAfter(ahora))
        .toList();

    if (usosEnRetiro.isEmpty) return null;

    // Retornar la fecha de fin de retiro más lejana
    return usosEnRetiro
        .map((u) => u.fechaLiberacion)
        .reduce((a, b) => a.isAfter(b) ? a : b);
  }

  @override
  Stream<List<UsoAntimicrobiano>> watchUsos(String granjaId) {
    return _datasource.watchUsos(granjaId);
  }
}
