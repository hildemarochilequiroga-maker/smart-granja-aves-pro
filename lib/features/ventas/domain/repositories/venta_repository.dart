import '../entities/venta_pedido.dart';
import '../entities/venta_producto.dart';

abstract class VentaRepository {
  // VentaPedido methods
  Future<List<VentaPedido>> obtenerVentas();
  Future<VentaPedido?> obtenerVentaPorId(String id);
  Future<void> registrarVenta(VentaPedido venta);
  Future<void> actualizarVenta(VentaPedido venta);
  Future<void> eliminarVenta(String id);

  // VentaProducto methods
  Future<VentaProducto> registrarVentaProducto(VentaProducto venta);
  Future<VentaProducto?> obtenerVentaProductoPorId(String id);
  Future<List<VentaProducto>> obtenerVentasProductoPorLote(String loteId);
  Future<List<VentaProducto>> obtenerVentasProductoPorGranja(String granjaId);
  Future<List<VentaProducto>> obtenerTodasVentasProductos();
  Future<void> actualizarVentaProducto(VentaProducto venta);
  Future<void> eliminarVentaProducto(String id);
  Stream<List<VentaProducto>> observarVentasProductoPorLote(String loteId);
  Stream<List<VentaProducto>> observarVentasProductoPorGranja(String granjaId);
  Stream<List<VentaProducto>> observarTodasVentasProductos();
}
