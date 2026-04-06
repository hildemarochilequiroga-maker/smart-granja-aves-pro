import '../../domain/entities/costo_gasto.dart';
import '../../domain/enums/tipo_gasto.dart';

abstract class CostoRemoteDatasource {
  Future<CostoGasto> crear(CostoGasto costo);
  Future<CostoGasto?> obtenerPorId(String id);
  Future<List<CostoGasto>> obtenerTodos();
  Future<void> actualizar(CostoGasto costo);
  Future<void> eliminar(String id);
  Future<List<CostoGasto>> obtenerPorGranja(String granjaId);
  Future<List<CostoGasto>> obtenerPorLote(String loteId);
  Future<List<CostoGasto>> obtenerPorTipo(TipoGasto tipo, String granjaId);
  Future<List<CostoGasto>> obtenerPendientesAprobacion(String granjaId);
  Future<List<CostoGasto>> obtenerPorPeriodo({
    required String granjaId,
    required DateTime desde,
    required DateTime hasta,
  });
  Stream<List<CostoGasto>> observarTodos();
  Stream<List<CostoGasto>> observarPorGranja(String granjaId);
  Stream<List<CostoGasto>> observarPorLote(String loteId);
}
