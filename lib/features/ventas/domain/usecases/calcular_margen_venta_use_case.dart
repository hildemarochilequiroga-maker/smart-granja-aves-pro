import '../entities/venta_pedido.dart';

class CalcularMargenVentaUseCase {
  double call(VentaPedido venta, double costoTotal) {
    return venta.totalFinal - costoTotal;
  }
}
