import '../../domain/entities/venta_pedido.dart';
import '../../domain/entities/venta_producto.dart';
import '../../domain/repositories/venta_repository.dart';
import '../datasources/venta_remote_datasource.dart';
import '../models/venta_pedido_model.dart';

class VentaRepositoryImpl implements VentaRepository {
  final VentaRemoteDatasource remoteDatasource;
  VentaRepositoryImpl(this.remoteDatasource);

  // ============================================================================
  // VENTA PEDIDO METHODS
  // ============================================================================

  @override
  Future<List<VentaPedido>> obtenerVentas() async {
    final models = await remoteDatasource.fetchVentas();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<VentaPedido?> obtenerVentaPorId(String id) async {
    final model = await remoteDatasource.fetchVentaPorId(id);
    return model?.toEntity();
  }

  @override
  Future<void> registrarVenta(VentaPedido venta) async {
    final model = VentaPedidoModel.fromEntity(venta);
    await remoteDatasource.createVenta(model);
  }

  @override
  Future<void> actualizarVenta(VentaPedido venta) async {
    final model = VentaPedidoModel.fromEntity(venta);
    await remoteDatasource.updateVenta(model);
  }

  @override
  Future<void> eliminarVenta(String id) async {
    await remoteDatasource.deleteVenta(id);
  }

  // ============================================================================
  // VENTA PRODUCTO METHODS
  // ============================================================================

  @override
  Future<VentaProducto> registrarVentaProducto(VentaProducto venta) async {
    return await remoteDatasource.createVentaProducto(venta);
  }

  @override
  Future<VentaProducto?> obtenerVentaProductoPorId(String id) async {
    return await remoteDatasource.fetchVentaProductoPorId(id);
  }

  @override
  Future<List<VentaProducto>> obtenerVentasProductoPorLote(
    String loteId,
  ) async {
    return await remoteDatasource.fetchVentasProductoPorLote(loteId);
  }

  @override
  Future<List<VentaProducto>> obtenerVentasProductoPorGranja(
    String granjaId,
  ) async {
    return await remoteDatasource.fetchVentasProductoPorGranja(granjaId);
  }

  @override
  Future<List<VentaProducto>> obtenerTodasVentasProductos() async {
    return await remoteDatasource.fetchTodasVentasProductos();
  }

  @override
  Future<void> actualizarVentaProducto(VentaProducto venta) async {
    await remoteDatasource.updateVentaProducto(venta);
  }

  @override
  Future<void> eliminarVentaProducto(String id) async {
    await remoteDatasource.deleteVentaProducto(id);
  }

  @override
  Stream<List<VentaProducto>> observarVentasProductoPorLote(String loteId) {
    return remoteDatasource.streamVentasProductoPorLote(loteId);
  }

  @override
  Stream<List<VentaProducto>> observarVentasProductoPorGranja(String granjaId) {
    return remoteDatasource.streamVentasProductoPorGranja(granjaId);
  }

  @override
  Stream<List<VentaProducto>> observarTodasVentasProductos() {
    return remoteDatasource.streamTodasVentasProductos();
  }
}
