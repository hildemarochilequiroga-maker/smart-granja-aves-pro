import '../entities/venta_pedido.dart';
import '../repositories/venta_repository.dart';

class RegistrarVentaUseCase {
  final VentaRepository repository;
  RegistrarVentaUseCase(this.repository);

  Future<void> call(VentaPedido venta) async {
    await repository.registrarVenta(venta);
  }
}
