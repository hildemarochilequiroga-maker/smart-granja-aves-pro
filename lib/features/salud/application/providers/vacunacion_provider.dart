import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/error_messages.dart';
import '../state/vacunacion_state.dart';
import '../../domain/entities/vacunacion.dart';
import '../../domain/repositories/vacunacion_repository.dart';
import '../../domain/usecases/usecases.dart';
import '../../infrastructure/datasources/vacunacion_remote_datasource.dart';
import '../../infrastructure/repositories/vacunacion_repository_impl.dart';

// Datasource provider
final vacunacionRemoteDatasourceProvider = Provider<VacunacionRemoteDatasource>(
  (ref) {
    return VacunacionRemoteDatasourceImpl(FirebaseFirestore.instance);
  },
);

// Repository provider
final vacunacionRepositoryProvider = Provider<VacunacionRepository>((ref) {
  final datasource = ref.watch(vacunacionRemoteDatasourceProvider);
  return VacunacionRepositoryImpl(datasource);
});

// Use case providers
final programarVacunacionUseCaseProvider = Provider<ProgramarVacunacionUseCase>(
  (ref) {
    final repository = ref.watch(vacunacionRepositoryProvider);
    return ProgramarVacunacionUseCase(vacunacionRepository: repository);
  },
);

final marcarVacunacionAplicadaUseCaseProvider =
    Provider<MarcarVacunacionAplicadaUseCase>((ref) {
      final repository = ref.watch(vacunacionRepositoryProvider);
      return MarcarVacunacionAplicadaUseCase(vacunacionRepository: repository);
    });

// Notifier provider for state management
final vacunacionNotifierProvider =
    StateNotifierProvider.autoDispose<VacunacionNotifier, VacunacionState>((
      ref,
    ) {
      final repository = ref.watch(vacunacionRepositoryProvider);
      final programarUseCase = ref.watch(programarVacunacionUseCaseProvider);
      final marcarAplicadaUseCase = ref.watch(
        marcarVacunacionAplicadaUseCaseProvider,
      );
      return VacunacionNotifier(
        repository: repository,
        programarVacunacion: programarUseCase,
        marcarAplicada: marcarAplicadaUseCase,
      );
    });

// Notifier class
class VacunacionNotifier extends StateNotifier<VacunacionState> {
  final VacunacionRepository repository;
  final ProgramarVacunacionUseCase programarVacunacion;
  final MarcarVacunacionAplicadaUseCase marcarAplicada;

  VacunacionNotifier({
    required this.repository,
    required this.programarVacunacion,
    required this.marcarAplicada,
  }) : super(const VacunacionState.initial());

  Future<void> programar(ProgramarVacunacionParams params) async {
    state = const VacunacionState.loading();
    final result = await programarVacunacion(params);
    result.fold(
      (failure) => state = VacunacionState.failure(failure.message),
      (vacunacion) => state = VacunacionState.success(vacunacion),
    );
  }

  Future<void> crear(Vacunacion vacunacion) async {
    state = const VacunacionState.loading();
    final result = await repository.crear(vacunacion);
    result.fold(
      (failure) => state = VacunacionState.failure(failure.message),
      (created) => state = VacunacionState.success(created),
    );
  }

  Future<void> actualizar(Vacunacion vacunacion) async {
    state = const VacunacionState.loading();
    final result = await repository.actualizar(vacunacion);
    result.fold(
      (failure) => state = VacunacionState.failure(failure.message),
      (updated) => state = VacunacionState.success(updated),
    );
  }

  Future<void> marcar({
    required String vacunacionId,
    required DateTime fechaAplicacion,
    required String aplicadoPor,
    required int edadAplicacionSemanas,
    required String dosis,
    required String via,
    String? loteVacuna,
    String? observaciones,
  }) async {
    state = const VacunacionState.loading();
    final result = await marcarAplicada(
      MarcarVacunacionAplicadaParams(
        vacunacionId: vacunacionId,
        fechaAplicacion: fechaAplicacion,
        aplicadoPor: aplicadoPor,
        edadAplicacionSemanas: edadAplicacionSemanas,
        dosis: dosis,
        via: via,
        loteVacuna: loteVacuna,
        observaciones: observaciones,
      ),
    );
    result.fold(
      (failure) => state = VacunacionState.failure(failure.message),
      (vacunacion) => state = VacunacionState.success(vacunacion),
    );
  }

  Future<void> eliminar(String id) async {
    state = const VacunacionState.loading();
    final result = await repository.eliminar(id);
    result.fold(
      (failure) => state = VacunacionState.failure(failure.message),
      (_) => state = const VacunacionState.initial(),
    );
  }

  /// Marca una vacunación como aplicada de forma simplificada.
  ///
  /// Actualiza solo el estado de aplicada y la fecha de aplicación.
  Future<void> marcarComoAplicada(
    String vacunacionId, {
    required DateTime fechaAplicacion,
  }) async {
    state = const VacunacionState.loading();
    final vacunacionResult = await repository.obtenerPorId(vacunacionId);

    await vacunacionResult.fold(
      (failure) async {
        state = VacunacionState.failure(failure.message);
      },
      (vacunacion) async {
        if (vacunacion == null) {
          state = VacunacionState.failure(ErrorMessages.get('ERR_VACCINATION_NOT_FOUND'));
          return;
        }
        final updated = vacunacion.copyWith(
          aplicada: true,
          fechaAplicacion: fechaAplicacion,
          ultimaActualizacion: DateTime.now(),
        );
        final result = await repository.actualizar(updated);
        result.fold(
          (failure) => state = VacunacionState.failure(failure.message),
          (v) => state = VacunacionState.success(v),
        );
      },
    );
  }

  /// Elimina una vacunación por ID.
  Future<void> eliminarVacunacion(String id) async {
    await eliminar(id);
  }

  void reset() {
    state = const VacunacionState.initial();
  }
}

// Data providers - unwrap Either
final vacunacionByIdProvider = FutureProvider.family<Vacunacion?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(vacunacionRepositoryProvider);
  final result = await repository.obtenerPorId(id);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (vacunacion) => vacunacion,
  );
});

final vacunacionPorLoteProvider =
    FutureProvider.family<List<Vacunacion>, String>((ref, loteId) async {
      final repository = ref.watch(vacunacionRepositoryProvider);
      final result = await repository.obtenerPorLote(loteId);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (vacunaciones) => vacunaciones,
      );
    });

final vacunacionPendientesProvider =
    FutureProvider.family<List<Vacunacion>, String>((ref, loteId) async {
      final repository = ref.watch(vacunacionRepositoryProvider);
      final result = await repository.obtenerPendientes(loteId);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (vacunaciones) => vacunaciones,
      );
    });

final vacunacionAplicadasProvider =
    FutureProvider.family<List<Vacunacion>, String>((ref, loteId) async {
      final repository = ref.watch(vacunacionRepositoryProvider);
      final result = await repository.obtenerAplicadas(loteId);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (vacunaciones) => vacunaciones,
      );
    });

// Stream provider
final vacunacionStreamProvider =
    StreamProvider.family<List<Vacunacion>, String>((ref, loteId) {
      final repository = ref.watch(vacunacionRepositoryProvider);
      return repository.observarPorLote(loteId);
    });

// Stream provider para vacunaciones por granja
final vacunacionPorGranjaStreamProvider =
    StreamProvider.family<List<Vacunacion>, String>((ref, granjaId) {
      final repository = ref.watch(vacunacionRepositoryProvider);
      return repository.observarPorGranja(granjaId);
    });

// Alias for compatibility
final streamVacunacionesPorLoteProvider = vacunacionStreamProvider;
final streamVacunacionesPorGranjaProvider = vacunacionPorGranjaStreamProvider;
