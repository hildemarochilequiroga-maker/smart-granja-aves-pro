import '../models/venta_pedido_model.dart';
import '../../domain/entities/venta_producto.dart';

abstract class VentaRemoteDatasource {
  // VentaPedido methods
  Future<List<VentaPedidoModel>> fetchVentas();
  Future<VentaPedidoModel?> fetchVentaPorId(String id);
  Future<void> createVenta(VentaPedidoModel venta);
  Future<void> updateVenta(VentaPedidoModel venta);
  Future<void> deleteVenta(String id);

  // VentaProducto methods
  Future<VentaProducto> createVentaProducto(VentaProducto venta);

  /// Crea una venta de producto y actualiza atómicamente los campos
  /// indicados en el documento de lote (p.ej. `ventasAcumuladas` con
  /// `FieldValue.increment`). Garantiza que ambos cambios suceden
  /// dentro de la misma transacción.
  Future<VentaProducto> createVentaProductoConActualizacionLote({
    required VentaProducto venta,
    required Map<String, dynamic> camposLote,
  });
  Future<VentaProducto?> fetchVentaProductoPorId(String id);
  Future<List<VentaProducto>> fetchVentasProductoPorLote(String loteId);
  Future<List<VentaProducto>> fetchVentasProductoPorGranja(String granjaId);
  Future<List<VentaProducto>> fetchTodasVentasProductos();
  Future<void> updateVentaProducto(VentaProducto venta);
  Future<void> deleteVentaProducto(String id);
  Stream<List<VentaProducto>> streamVentasProductoPorLote(String loteId);
  Stream<List<VentaProducto>> streamVentasProductoPorGranja(String granjaId);
  Stream<List<VentaProducto>> streamTodasVentasProductos();
}
