import '../../domain/entities/venta_pedido.dart';

class VentasState {
  final List<VentaPedido> ventas;
  final bool isLoading;
  final String? error;

  VentasState({required this.ventas, this.isLoading = false, this.error});

  VentasState copyWith({
    List<VentaPedido>? ventas,
    bool? isLoading,
    String? error,
  }) {
    return VentasState(
      ventas: ventas ?? this.ventas,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
