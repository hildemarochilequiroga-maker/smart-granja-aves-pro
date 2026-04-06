import '../entities/venta_pedido.dart';
import '../repositories/venta_repository.dart';

class ObtenerVentasUseCase {
  final VentaRepository repository;
  ObtenerVentasUseCase(this.repository);

  Future<List<VentaPedido>> call() async {
    return await repository.obtenerVentas();
  }
}
