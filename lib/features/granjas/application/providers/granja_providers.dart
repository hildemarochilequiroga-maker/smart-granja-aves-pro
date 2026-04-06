library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/providers/auth_provider.dart';
import '../../../galpones/application/providers/galpon_providers.dart';
import '../../../lotes/application/providers/lote_providers.dart';
import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';
import '../state/state.dart';
import 'granja_notifiers.dart';

// =============================================================================
// PROVIDERS DE INFRAESTRUCTURA
// =============================================================================

/// Provider del datasource de Firebase
final granjaFirebaseDatasourceProvider = Provider<GranjaFirebaseDatasource>((
  ref,
) {
  return GranjaFirebaseDatasource();
});

/// Provider del datasource local
final granjaLocalDatasourceProvider = Provider<GranjaLocalDatasource>((ref) {
  final storage = ref.watch(localStorageProvider);
  return GranjaLocalDatasource(storage);
});

/// Provider del repositorio de granjas
final granjaRepositoryProvider = Provider<GranjaRepository>((ref) {
  return GranjaRepositoryImpl(
    firebaseDatasource: ref.watch(granjaFirebaseDatasourceProvider),
    localDatasource: ref.watch(granjaLocalDatasourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

// =============================================================================
// PROVIDERS DE USE CASES
// =============================================================================

final crearGranjaUseCaseProvider = Provider<CrearGranjaUseCase>((ref) {
  return CrearGranjaUseCase(repository: ref.watch(granjaRepositoryProvider));
});

final actualizarGranjaUseCaseProvider = Provider<ActualizarGranjaUseCase>((
  ref,
) {
  return ActualizarGranjaUseCase(
    repository: ref.watch(granjaRepositoryProvider),
  );
});

final eliminarGranjaUseCaseProvider = Provider<EliminarGranjaUseCase>((ref) {
  return EliminarGranjaUseCase(
    repository: ref.watch(granjaRepositoryProvider),
    galponRepository: ref.watch(galponRepositoryProvider),
    loteRepository: ref.watch(loteRepositoryProvider),
  );
});

final obtenerGranjaPorIdUseCaseProvider = Provider<ObtenerGranjaPorIdUseCase>((
  ref,
) {
  return ObtenerGranjaPorIdUseCase(
    repository: ref.watch(granjaRepositoryProvider),
  );
});

final obtenerGranjasDelUsuarioUseCaseProvider =
    Provider<ObtenerGranjasDelUsuarioUseCase>((ref) {
      return ObtenerGranjasDelUsuarioUseCase(
        repository: ref.watch(granjaRepositoryProvider),
      );
    });

final activarGranjaUseCaseProvider = Provider<ActivarGranjaUseCase>((ref) {
  return ActivarGranjaUseCase(repository: ref.watch(granjaRepositoryProvider));
});

final suspenderGranjaUseCaseProvider = Provider<SuspenderGranjaUseCase>((ref) {
  return SuspenderGranjaUseCase(
    repository: ref.watch(granjaRepositoryProvider),
  );
});

final ponerEnMantenimientoUseCaseProvider =
    Provider<PonerEnMantenimientoGranjaUseCase>((ref) {
      return PonerEnMantenimientoGranjaUseCase(
        repository: ref.watch(granjaRepositoryProvider),
      );
    });

final buscarGranjasUseCaseProvider = Provider<BuscarGranjasUseCase>((ref) {
  return BuscarGranjasUseCase(repository: ref.watch(granjaRepositoryProvider));
});

final obtenerDashboardGranjaUseCaseProvider =
    Provider<ObtenerDashboardGranjaUseCase>((ref) {
      return ObtenerDashboardGranjaUseCase(
        granjaRepository: ref.watch(granjaRepositoryProvider),
        loteRepository: ref.watch(loteRepositoryProvider),
        galponRepository: ref.watch(galponRepositoryProvider),
      );
    });

// =============================================================================
// PROVIDERS DE NOTIFIERS
// =============================================================================

/// Provider principal de estado de granjas
final granjaNotifierProvider =
    StateNotifierProvider.autoDispose<GranjaNotifier, GranjaState>((ref) {
      return GranjaNotifier(
        crearUseCase: ref.watch(crearGranjaUseCaseProvider),
        actualizarUseCase: ref.watch(actualizarGranjaUseCaseProvider),
        eliminarUseCase: ref.watch(eliminarGranjaUseCaseProvider),
        activarUseCase: ref.watch(activarGranjaUseCaseProvider),
        suspenderUseCase: ref.watch(suspenderGranjaUseCaseProvider),
        ponerEnMantenimientoUseCase: ref.watch(
          ponerEnMantenimientoUseCaseProvider,
        ),
        buscarUseCase: ref.watch(buscarGranjasUseCaseProvider),
      );
    });

/// Provider del notifier de búsqueda
final granjaSearchNotifierProvider =
    StateNotifierProvider.autoDispose<GranjaSearchNotifier, GranjaSearchState>((
      ref,
    ) {
      return GranjaSearchNotifier(
        buscarUseCase: ref.watch(buscarGranjasUseCaseProvider),
      );
    });

/// Provider del notifier de formulario
final granjaFormNotifierProvider =
    StateNotifierProvider.autoDispose<GranjaFormNotifier, GranjaFormState>((
      ref,
    ) {
      return GranjaFormNotifier();
    });

// =============================================================================
// PROVIDERS DE DATOS (StreamProvider para reactividad)
// =============================================================================

/// Provider que observa todas las granjas del usuario actual
final granjasStreamProvider = StreamProvider.autoDispose<List<Granja>>((ref) {
  final repository = ref.watch(granjaRepositoryProvider);
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) {
    return Stream.value([]);
  }

  return repository.observarGranjasDelUsuario(currentUser.id);
});

/// Provider que observa las granjas activas del usuario
final granjasActivasStreamProvider = StreamProvider.autoDispose<List<Granja>>((
  ref,
) {
  final repository = ref.watch(granjaRepositoryProvider);
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) {
    return Stream.value([]);
  }

  return repository.observarGranjasActivas(currentUser.id);
});

/// Provider que observa una granja específica por ID
final granjaByIdProvider = StreamProvider.autoDispose.family<Granja?, String>((
  ref,
  String id,
) {
  final repository = ref.watch(granjaRepositoryProvider);
  return repository.observarGranja(id);
});

// =============================================================================
// PROVIDERS COMPUTADOS
// =============================================================================

/// Provider que cuenta las granjas del usuario
final conteoGranjasProvider = Provider<AsyncValue<int>>((ref) {
  final granjasAsync = ref.watch(granjasStreamProvider);
  return granjasAsync.whenData((granjas) => granjas.length);
});

/// Provider que cuenta las granjas activas
final conteoGranjasActivasProvider = Provider<AsyncValue<int>>((ref) {
  final granjasAsync = ref.watch(granjasActivasStreamProvider);
  return granjasAsync.whenData((granjas) => granjas.length);
});

/// Provider de estadísticas de granjas
final estadisticasGranjasProvider = Provider<AsyncValue<GranjaStatsState>>((
  ref,
) {
  final granjasAsync = ref.watch(granjasStreamProvider);

  return granjasAsync.whenData((granjas) {
    if (granjas.isEmpty) {
      return GranjaStatsState.initial();
    }

    final activas = granjas.where((g) => g.estaActiva).length;
    final inactivas = granjas.where((g) => g.estaSuspendida).length;
    final enMantenimiento = granjas.where((g) => g.estaEnMantenimiento).length;

    final capacidadTotal = granjas.fold<int>(
      0,
      (sum, g) => sum + (g.capacidadTotalAves ?? 0),
    );
    final areaTotal = granjas.fold<double>(
      0.0,
      (sum, g) => sum + (g.areaTotalM2 ?? 0.0),
    );

    return GranjaStatsState(
      totalGranjas: granjas.length,
      granjasActivas: activas,
      granjasInactivas: inactivas,
      granjasEnMantenimiento: enMantenimiento,
      capacidadTotalAves: capacidadTotal,
      areaTotalM2: areaTotal,
    );
  });
});

/// Provider de la granja seleccionada actualmente
final granjaSeleccionadaProvider = StateProvider.autoDispose<Granja?>(
  (ref) => null,
);

/// Provider que indica si el usuario tiene al menos una granja
final tieneGranjasProvider = Provider<AsyncValue<bool>>((ref) {
  final granjasAsync = ref.watch(granjasStreamProvider);
  return granjasAsync.whenData((granjas) => granjas.isNotEmpty);
});

/// Provider del dashboard de una granja específica
final dashboardGranjaProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, granjaId) async {
      final useCase = ref.watch(obtenerDashboardGranjaUseCaseProvider);
      final result = await useCase(granjaId);

      return result.fold(
        (failure) => throw Exception(failure.message),
        (dashboard) => dashboard,
      );
    });
