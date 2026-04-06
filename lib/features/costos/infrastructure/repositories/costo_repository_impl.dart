import '../../domain/entities/costo_gasto.dart';
import '../../domain/enums/tipo_gasto.dart';
import '../../domain/repositories/costo_repository.dart';
import '../datasources/costo_remote_datasource.dart';

class CostoRepositoryImpl implements CostoRepository {
  final CostoRemoteDatasource remoteDatasource;

  CostoRepositoryImpl(this.remoteDatasource);

  @override
  Future<CostoGasto> crear(CostoGasto costo) async {
    return await remoteDatasource.crear(costo);
  }

  @override
  Future<CostoGasto?> obtenerPorId(String id) async {
    return await remoteDatasource.obtenerPorId(id);
  }

  @override
  Future<List<CostoGasto>> obtenerTodos() async {
    return await remoteDatasource.obtenerTodos();
  }

  @override
  Future<CostoGasto> actualizar(CostoGasto costo) async {
    await remoteDatasource.actualizar(costo);
    return costo;
  }

  @override
  Future<void> eliminar(String id) async {
    await remoteDatasource.eliminar(id);
  }

  @override
  Future<List<CostoGasto>> obtenerPorGranja(String granjaId) async {
    return await remoteDatasource.obtenerPorGranja(granjaId);
  }

  @override
  Future<List<CostoGasto>> obtenerPorLote(String loteId) async {
    return await remoteDatasource.obtenerPorLote(loteId);
  }

  @override
  Future<List<CostoGasto>> obtenerPorTipo(
    TipoGasto tipo,
    String granjaId,
  ) async {
    return await remoteDatasource.obtenerPorTipo(tipo, granjaId);
  }

  @override
  Future<List<CostoGasto>> obtenerPendientesAprobacion(String granjaId) async {
    return await remoteDatasource.obtenerPendientesAprobacion(granjaId);
  }

  @override
  Future<List<CostoGasto>> obtenerPorPeriodo({
    required String granjaId,
    required DateTime desde,
    required DateTime hasta,
  }) async {
    return await remoteDatasource.obtenerPorPeriodo(
      granjaId: granjaId,
      desde: desde,
      hasta: hasta,
    );
  }

  @override
  Future<double> calcularCostoTotalLote(String loteId) async {
    final costos = await obtenerPorLote(loteId);
    return costos.fold<double>(0, (sum, costo) => sum + costo.monto);
  }

  @override
  Future<double> calcularCostoPorAve(String loteId, int cantidadAves) async {
    final total = await calcularCostoTotalLote(loteId);
    if (cantidadAves <= 0) return 0;
    return total / cantidadAves;
  }

  @override
  Future<Map<TipoGasto, double>> obtenerDistribucionPorTipo(
    String granjaId,
  ) async {
    final costos = await obtenerPorGranja(granjaId);
    final Map<TipoGasto, double> distribucion = {};

    for (var costo in costos) {
      distribucion[costo.tipo] = (distribucion[costo.tipo] ?? 0) + costo.monto;
    }

    return distribucion;
  }

  @override
  Stream<List<CostoGasto>> observarTodos() {
    return remoteDatasource.observarTodos();
  }

  @override
  Stream<List<CostoGasto>> observarPorGranja(String granjaId) {
    return remoteDatasource.observarPorGranja(granjaId);
  }

  @override
  Stream<List<CostoGasto>> observarPorLote(String loteId) {
    return remoteDatasource.observarPorLote(loteId);
  }
}
