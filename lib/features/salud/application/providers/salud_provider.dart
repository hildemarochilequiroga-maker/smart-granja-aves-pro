import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/error_messages.dart';
import '../state/salud_state.dart';
import '../../domain/entities/salud_registro.dart';
import '../../domain/repositories/salud_repository.dart';
import '../../domain/usecases/usecases.dart';
import '../../infrastructure/datasources/salud_remote_datasource.dart';
import '../../infrastructure/repositories/salud_repository_impl.dart';

// Datasource provider
final saludRemoteDatasourceProvider = Provider<SaludRemoteDatasource>((ref) {
  return SaludRemoteDatasourceImpl(FirebaseFirestore.instance);
});

// Repository provider
final saludRepositoryProvider = Provider<SaludRepository>((ref) {
  final datasource = ref.watch(saludRemoteDatasourceProvider);
  return SaludRepositoryImpl(datasource);
});

// Use case providers
final registrarTratamientoUseCaseProvider =
    Provider<RegistrarTratamientoUseCase>((ref) {
      final repository = ref.watch(saludRepositoryProvider);
      return RegistrarTratamientoUseCase(saludRepository: repository);
    });

final cerrarRegistroSaludUseCaseProvider = Provider<CerrarRegistroSaludUseCase>(
  (ref) {
    final repository = ref.watch(saludRepositoryProvider);
    return CerrarRegistroSaludUseCase(saludRepository: repository);
  },
);

// Notifier provider for state management
final saludNotifierProvider =
    StateNotifierProvider.autoDispose<SaludNotifier, SaludState>((ref) {
      final repository = ref.watch(saludRepositoryProvider);
      final registrarUseCase = ref.watch(registrarTratamientoUseCaseProvider);
      final cerrarUseCase = ref.watch(cerrarRegistroSaludUseCaseProvider);
      return SaludNotifier(
        repository: repository,
        registrarTratamiento: registrarUseCase,
        cerrarRegistro: cerrarUseCase,
      );
    });

// Notifier class
class SaludNotifier extends StateNotifier<SaludState> {
  final SaludRepository repository;
  final RegistrarTratamientoUseCase registrarTratamiento;
  final CerrarRegistroSaludUseCase cerrarRegistro;

  SaludNotifier({
    required this.repository,
    required this.registrarTratamiento,
    required this.cerrarRegistro,
  }) : super(const SaludState.initial());

  Future<void> registrarNuevoTratamiento(
    RegistrarTratamientoParams params,
  ) async {
    state = const SaludState.loading();
    final result = await registrarTratamiento(params);
    if (!mounted) return;
    result.fold(
      (failure) => state = SaludState.failure(failure.message),
      (registro) => state = SaludState.success(registro),
    );
  }

  Future<void> crear(SaludRegistro registro) async {
    state = const SaludState.loading();
    final result = await repository.crear(registro);
    if (!mounted) return;
    result.fold(
      (failure) => state = SaludState.failure(failure.message),
      (created) => state = SaludState.success(created),
    );
  }

  Future<void> actualizar(SaludRegistro registro) async {
    state = const SaludState.loading();
    final result = await repository.actualizar(registro);
    if (!mounted) return;
    result.fold(
      (failure) => state = SaludState.failure(failure.message),
      (updated) => state = SaludState.success(updated),
    );
  }

  Future<void> cerrar({
    required String registroId,
    required String resultado,
    String? observacionesFinales,
  }) async {
    state = const SaludState.loading();
    final result = await cerrarRegistro(
      CerrarRegistroSaludParams(
        registroId: registroId,
        resultado: resultado,
        observacionesFinales: observacionesFinales,
      ),
    );
    if (!mounted) return;
    result.fold(
      (failure) => state = SaludState.failure(failure.message),
      (registro) => state = SaludState.success(registro),
    );
  }

  Future<void> eliminar(String id) async {
    state = const SaludState.loading();
    final result = await repository.eliminar(id);
    if (!mounted) return;
    result.fold(
      (failure) => state = SaludState.failure(failure.message),
      (_) => state = const SaludState.initial(),
    );
  }

  /// Cierra un registro de salud con fecha y resultado.
  Future<void> cerrarRegistroSalud(
    String registroId, {
    required DateTime fechaCierre,
    String? resultado,
  }) async {
    state = const SaludState.loading();
    final registroResult = await repository.obtenerPorId(registroId);
    if (!mounted) return;

    await registroResult.fold(
      (failure) async {
        if (!mounted) return;
        state = SaludState.failure(failure.message);
      },
      (registro) async {
        if (!mounted) return;
        if (registro == null) {
          state = SaludState.failure(ErrorMessages.get('ERR_RECORD_NOT_FOUND'));
          return;
        }
        final updated = registro.copyWith(
          fechaCierre: fechaCierre,
          resultado: resultado,
          ultimaActualizacion: DateTime.now(),
        );
        final result = await repository.actualizar(updated);
        if (!mounted) return;
        result.fold(
          (failure) => state = SaludState.failure(failure.message),
          (r) => state = SaludState.success(r),
        );
      },
    );
  }

  /// Elimina un registro de salud por ID.
  Future<void> eliminarRegistro(String id) async {
    await eliminar(id);
  }

  void reset() {
    state = const SaludState.initial();
  }
}

// Data providers - unwrap Either
final saludByIdProvider = FutureProvider.autoDispose
    .family<SaludRegistro?, String>((ref, id) async {
      final repository = ref.watch(saludRepositoryProvider);
      final result = await repository.obtenerPorId(id);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (registro) => registro,
      );
    });

final saludPorLoteProvider = FutureProvider.autoDispose
    .family<List<SaludRegistro>, String>((ref, loteId) async {
      final repository = ref.watch(saludRepositoryProvider);
      final result = await repository.obtenerPorLote(loteId);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (registros) => registros,
      );
    });

// Stream providers
final streamTodosSaludProvider =
    StreamProvider.autoDispose<List<SaludRegistro>>((ref) {
      final repository = ref.watch(saludRepositoryProvider);
      return repository.observarTodos();
    });

final saludStreamProvider = StreamProvider.autoDispose
    .family<List<SaludRegistro>, String>((ref, loteId) {
      final repository = ref.watch(saludRepositoryProvider);
      return repository.observarPorLote(loteId);
    });

// Alias for compatibility
final streamSaludPorLoteProvider = saludStreamProvider;

/// Stream de registros de salud filtrados por granja
final streamSaludPorGranjaProvider = StreamProvider.autoDispose
    .family<List<SaludRegistro>, String>((ref, String granjaId) {
      final repository = ref.watch(saludRepositoryProvider);
      return repository.observarPorGranja(granjaId);
    });

final saludAbiertosProvider = FutureProvider.autoDispose
    .family<List<SaludRegistro>, String>((ref, loteId) async {
      final repository = ref.watch(saludRepositoryProvider);
      final result = await repository.obtenerAbiertos(loteId);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (registros) => registros,
      );
    });
