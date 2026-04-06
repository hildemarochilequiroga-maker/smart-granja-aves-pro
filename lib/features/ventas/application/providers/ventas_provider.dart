import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/error_messages.dart';
import '../state/ventas_state.dart';
import '../../domain/entities/venta_producto.dart';
import '../../domain/repositories/venta_repository.dart';
import '../../domain/usecases/obtener_ventas_usecase.dart';
import '../../domain/usecases/venta_producto_usecases.dart';
import '../../infrastructure/repositories/venta_repository_impl.dart';
import '../../infrastructure/datasources/venta_remote_datasource_impl.dart';

// Repository provider
final ventaRepositoryProvider = Provider<VentaRepository>((ref) {
  final datasource = ref.watch(ventaRemoteDatasourceProvider);
  return VentaRepositoryImpl(datasource);
});

// Use case providers
final obtenerVentasUseCaseProvider = Provider((ref) {
  final repository = ref.watch(ventaRepositoryProvider);
  return ObtenerVentasUseCase(repository);
});

// Use case providers - VentaProducto
final registrarVentaProductoUseCaseProvider = Provider((ref) {
  final repository = ref.watch(ventaRepositoryProvider);
  return RegistrarVentaProductoUseCase(repository);
});

final actualizarVentaProductoUseCaseProvider = Provider((ref) {
  final repository = ref.watch(ventaRepositoryProvider);
  return ActualizarVentaProductoUseCase(repository);
});

final obtenerVentasProductoPorLoteUseCaseProvider = Provider((ref) {
  final repository = ref.watch(ventaRepositoryProvider);
  return ObtenerVentasProductoPorLoteUseCase(repository);
});

final obtenerTodasVentasProductoUseCaseProvider = Provider((ref) {
  final repository = ref.watch(ventaRepositoryProvider);
  return ObtenerTodasVentasProductoUseCase(repository);
});

final eliminarVentaProductoUseCaseProvider = Provider((ref) {
  final repository = ref.watch(ventaRepositoryProvider);
  return EliminarVentaProductoUseCase(repository);
});

final ventasProvider =
    StateNotifierProvider.autoDispose<VentasNotifier, VentasState>((ref) {
      final obtenerVentasUseCase = ref.watch(obtenerVentasUseCaseProvider);
      return VentasNotifier(obtenerVentasUseCase);
    });

class VentasNotifier extends StateNotifier<VentasState> {
  final ObtenerVentasUseCase obtenerVentasUseCase;
  VentasNotifier(this.obtenerVentasUseCase) : super(VentasState(ventas: []));

  Future<void> cargarVentas() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final ventas = await obtenerVentasUseCase();
      state = state.copyWith(ventas: ventas, isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// ============================================================================
// VENTA PRODUCTO STATE MANAGEMENT
// ============================================================================

class VentaProductoCrudState {
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  VentaProductoCrudState({
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  VentaProductoCrudState copyWith({
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return VentaProductoCrudState(
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}

class VentaProductoCrudNotifier extends StateNotifier<VentaProductoCrudState> {
  final RegistrarVentaProductoUseCase _registrarUseCase;
  final ActualizarVentaProductoUseCase _actualizarUseCase;
  final EliminarVentaProductoUseCase _eliminarUseCase;

  VentaProductoCrudNotifier({
    required RegistrarVentaProductoUseCase registrarUseCase,
    required ActualizarVentaProductoUseCase actualizarUseCase,
    required EliminarVentaProductoUseCase eliminarUseCase,
  }) : _registrarUseCase = registrarUseCase,
       _actualizarUseCase = actualizarUseCase,
       _eliminarUseCase = eliminarUseCase,
       super(VentaProductoCrudState());

  Future<VentaProducto?> registrarVenta(VentaProducto venta) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    final resultado = await _registrarUseCase(venta);

    return resultado.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return null;
      },
      (ventaGuardada) {
        state = state.copyWith(
          isLoading: false,
          successMessage: ErrorMessages.get('VENTA_REGISTRADA_OK'),
        );
        return ventaGuardada;
      },
    );
  }

  Future<bool> actualizarVenta(VentaProducto venta) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    final resultado = await _actualizarUseCase(venta);

    return resultado.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: ErrorMessages.get('VENTA_ACTUALIZADA_OK'),
        );
        return true;
      },
    );
  }

  Future<bool> eliminarVenta(String id) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    final resultado = await _eliminarUseCase(id);

    return resultado.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: ErrorMessages.get('VENTA_ELIMINADA_OK'),
        );
        return true;
      },
    );
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}

final ventaProductoCrudProvider =
    StateNotifierProvider.autoDispose<
      VentaProductoCrudNotifier,
      VentaProductoCrudState
    >((ref) {
      return VentaProductoCrudNotifier(
        registrarUseCase: ref.watch(registrarVentaProductoUseCaseProvider),
        actualizarUseCase: ref.watch(actualizarVentaProductoUseCaseProvider),
        eliminarUseCase: ref.watch(eliminarVentaProductoUseCaseProvider),
      );
    });

// Future providers para ventas de productos
final ventasProductoPorLoteProvider = FutureProvider.autoDispose
    .family<List<VentaProducto>, String>((ref, String loteId) async {
      final repository = ref.watch(ventaRepositoryProvider);
      return await repository.obtenerVentasProductoPorLote(loteId);
    });

final todasVentasProductoProvider =
    FutureProvider.autoDispose<List<VentaProducto>>((ref) async {
      final repository = ref.watch(ventaRepositoryProvider);
      return await repository.obtenerTodasVentasProductos();
    });

/// Provider para obtener una venta de producto por ID.
final ventaProductoPorIdProvider = FutureProvider.autoDispose
    .family<VentaProducto?, String>((ref, String ventaId) async {
      final repository = ref.watch(ventaRepositoryProvider);
      return await repository.obtenerVentaProductoPorId(ventaId);
    });

// Stream providers para observar ventas en tiempo real
final streamVentasProductoPorLoteProvider = StreamProvider.autoDispose
    .family<List<VentaProducto>, String>((ref, String loteId) {
      final repository = ref.watch(ventaRepositoryProvider);
      return repository.observarVentasProductoPorLote(loteId);
    });

final streamVentasProductoPorGranjaProvider = StreamProvider.autoDispose
    .family<List<VentaProducto>, String>((ref, String granjaId) {
      final repository = ref.watch(ventaRepositoryProvider);
      return repository.observarVentasProductoPorGranja(granjaId);
    });

final streamTodasVentasProductoProvider =
    StreamProvider.autoDispose<List<VentaProducto>>((ref) {
      final repository = ref.watch(ventaRepositoryProvider);
      return repository.observarTodasVentasProductos();
    });
