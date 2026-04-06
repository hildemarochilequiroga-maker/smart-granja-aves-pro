import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/error_messages.dart';
import '../../domain/entities/costo_gasto.dart';
import '../../domain/repositories/costo_repository.dart';
import '../../domain/usecases/costo_usecases.dart';
import '../../infrastructure/repositories/costo_repository_impl.dart';
import '../../infrastructure/datasources/costo_remote_datasource_impl.dart';

// Repository provider
final costoRepositoryProvider = Provider<CostoRepository>((ref) {
  final datasource = ref.watch(costoRemoteDatasourceProvider);
  return CostoRepositoryImpl(datasource);
});

// Use case providers
final registrarCostoUseCaseProvider = Provider((ref) {
  final repository = ref.watch(costoRepositoryProvider);
  return RegistrarCostoUseCase(repository);
});

final obtenerCostosPorLoteUseCaseProvider = Provider((ref) {
  final repository = ref.watch(costoRepositoryProvider);
  return ObtenerCostosPorLoteUseCase(repository);
});

final calcularCostoTotalLoteUseCaseProvider = Provider((ref) {
  final repository = ref.watch(costoRepositoryProvider);
  return CalcularCostoTotalLoteUseCase(repository);
});

final aprobarCostoUseCaseProvider = Provider((ref) {
  final repository = ref.watch(costoRepositoryProvider);
  return AprobarCostoUseCase(repository);
});

/// Provider para obtener un costo por su ID (cached, no recrea future en cada build)
final costoByIdProvider = FutureProvider.autoDispose
    .family<CostoGasto?, String>((ref, costoId) {
      final repository = ref.read(costoRepositoryProvider);
      return repository.obtenerPorId(costoId);
    });

// State management
class CostoCrudState {
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  CostoCrudState({
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  CostoCrudState copyWith({
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return CostoCrudState(
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}

class CostoCrudNotifier extends StateNotifier<CostoCrudState> {
  final RegistrarCostoUseCase _registrarUseCase;
  final AprobarCostoUseCase _aprobarUseCase;
  final RechazarCostoUseCase _rechazarUseCase;
  final CostoRepository _repository;

  CostoCrudNotifier({
    required RegistrarCostoUseCase registrarUseCase,
    required AprobarCostoUseCase aprobarUseCase,
    required RechazarCostoUseCase rechazarUseCase,
    required CostoRepository repository,
  }) : _registrarUseCase = registrarUseCase,
       _aprobarUseCase = aprobarUseCase,
       _rechazarUseCase = rechazarUseCase,
       _repository = repository,
       super(CostoCrudState());

  Future<CostoGasto?> registrarCosto(CostoGasto costo) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    final resultado = await _registrarUseCase(costo);

    return resultado.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return null;
      },
      (costoGuardado) {
        state = state.copyWith(
          isLoading: false,
          successMessage: ErrorMessages.get('COSTO_REGISTRADO_OK'),
        );
        return costoGuardado;
      },
    );
  }

  Future<bool> actualizarCosto(CostoGasto costo) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      await _repository.actualizar(costo);
      state = state.copyWith(
        isLoading: false,
        successMessage: ErrorMessages.get('COSTO_ACTUALIZADO_OK'),
      );
      return true;
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '${ErrorMessages.get('ERROR_ACTUALIZAR_COSTO')}: $e',
      );
      return false;
    }
  }

  Future<bool> eliminarCosto(String id) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      await _repository.eliminar(id);
      state = state.copyWith(
        isLoading: false,
        successMessage: ErrorMessages.get('COSTO_ELIMINADO_OK'),
      );
      return true;
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '${ErrorMessages.get('ERROR_ELIMINAR_COSTO')}: $e',
      );
      return false;
    }
  }

  Future<bool> aprobarCosto(String costoId, String aprobadoPor) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    final resultado = await _aprobarUseCase(costoId, aprobadoPor);

    return resultado.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: ErrorMessages.get('COSTO_APROBADO_OK'),
        );
        return true;
      },
    );
  }

  Future<bool> rechazarCosto(String costoId, String motivo) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    final resultado = await _rechazarUseCase(costoId, motivo);

    return resultado.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: ErrorMessages.get('COSTO_RECHAZADO_OK'),
        );
        return true;
      },
    );
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}

final costoCrudProvider =
    StateNotifierProvider.autoDispose<CostoCrudNotifier, CostoCrudState>((ref) {
      return CostoCrudNotifier(
        registrarUseCase: ref.watch(registrarCostoUseCaseProvider),
        aprobarUseCase: ref.watch(aprobarCostoUseCaseProvider),
        rechazarUseCase: ref.watch(rechazarCostoUseCaseProvider),
        repository: ref.watch(costoRepositoryProvider),
      );
    });

// Use case providers adicionales
final rechazarCostoUseCaseProvider = Provider((ref) {
  final repository = ref.watch(costoRepositoryProvider);
  return RechazarCostoUseCase(repository);
});

final obtenerCostosPendientesUseCaseProvider = Provider((ref) {
  final repository = ref.watch(costoRepositoryProvider);
  return ObtenerCostosPendientesUseCase(repository);
});

final obtenerCostosPorPeriodoUseCaseProvider = Provider((ref) {
  final repository = ref.watch(costoRepositoryProvider);
  return ObtenerCostosPorPeriodoUseCase(repository);
});

final obtenerDistribucionCostosUseCaseProvider = Provider((ref) {
  final repository = ref.watch(costoRepositoryProvider);
  return ObtenerDistribucionCostosUseCase(repository);
});

// Future providers
final costosPorLoteProvider = FutureProvider.autoDispose
    .family<List<CostoGasto>, String>((ref, String loteId) async {
      final repository = ref.watch(costoRepositoryProvider);
      return await repository.obtenerPorLote(loteId);
    });

final costoTotalLoteProvider = FutureProvider.autoDispose
    .family<double, String>((ref, String loteId) async {
      final repository = ref.watch(costoRepositoryProvider);
      return await repository.calcularCostoTotalLote(loteId);
    });

final costosPorGranjaProvider = FutureProvider.autoDispose
    .family<List<CostoGasto>, String>((ref, String granjaId) async {
      final repository = ref.watch(costoRepositoryProvider);
      return await repository.obtenerPorGranja(granjaId);
    });

final costosPendientesProvider = FutureProvider.autoDispose
    .family<List<CostoGasto>, String>((ref, String granjaId) async {
      final repository = ref.watch(costoRepositoryProvider);
      return await repository.obtenerPendientesAprobacion(granjaId);
    });

final distribucionCostosProvider = FutureProvider.autoDispose
    .family<Map<dynamic, double>, String>((ref, String granjaId) async {
      final repository = ref.watch(costoRepositoryProvider);
      return await repository.obtenerDistribucionPorTipo(granjaId);
    });

// Stream providers
final streamTodosCostosProvider = StreamProvider.autoDispose<List<CostoGasto>>((
  ref,
) {
  final repository = ref.watch(costoRepositoryProvider);
  return repository.observarTodos();
});

final streamCostosPorLoteProvider = StreamProvider.autoDispose
    .family<List<CostoGasto>, String>((ref, String loteId) {
      final repository = ref.watch(costoRepositoryProvider);
      return repository.observarPorLote(loteId);
    });

final streamCostosPorGranjaProvider = StreamProvider.autoDispose
    .family<List<CostoGasto>, String>((ref, String granjaId) {
      final repository = ref.watch(costoRepositoryProvider);
      return repository.observarPorGranja(granjaId);
    });

/// Provider para obtener un costo por ID
final costoPorIdProvider = FutureProvider.autoDispose
    .family<CostoGasto?, String>((ref, String costoId) async {
      final repository = ref.watch(costoRepositoryProvider);
      return await repository.obtenerPorId(costoId);
    });
