import '../entities/costo_gasto.dart';
import '../enums/tipo_gasto.dart';

/// Repository interface para CostoGasto.
abstract class CostoRepository {
  // CRUD
  Future<CostoGasto> crear(CostoGasto costo);
  Future<CostoGasto?> obtenerPorId(String id);
  Future<List<CostoGasto>> obtenerTodos();
  Future<CostoGasto> actualizar(CostoGasto costo);
  Future<void> eliminar(String id);

  // Consultas
  Future<List<CostoGasto>> obtenerPorGranja(String granjaId);
  Future<List<CostoGasto>> obtenerPorLote(String loteId);
  Future<List<CostoGasto>> obtenerPorTipo(TipoGasto tipo, String granjaId);
  Future<List<CostoGasto>> obtenerPendientesAprobacion(String granjaId);
  Future<List<CostoGasto>> obtenerPorPeriodo({
    required String granjaId,
    required DateTime desde,
    required DateTime hasta,
  });

  // Estadísticas
  Future<double> calcularCostoTotalLote(String loteId);
  Future<double> calcularCostoPorAve(String loteId, int cantidadAves);
  Future<Map<TipoGasto, double>> obtenerDistribucionPorTipo(String granjaId);

  // Streams
  Stream<List<CostoGasto>> observarTodos();
  Stream<List<CostoGasto>> observarPorGranja(String granjaId);
  Stream<List<CostoGasto>> observarPorLote(String loteId);
}
