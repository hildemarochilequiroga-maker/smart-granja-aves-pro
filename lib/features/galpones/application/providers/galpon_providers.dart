import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/providers/auth_provider.dart';
import '../../../lotes/application/providers/lote_providers.dart';
import '../../domain/entities/galpon.dart';
import '../../domain/enums/estado_galpon.dart';
import '../../domain/repositories/galpon_repository.dart';
import '../../domain/usecases/usecases.dart';
import '../../infrastructure/datasources/datasources.dart';
import '../../infrastructure/repositories/galpon_repository_impl.dart';
import '../state/galpon_state.dart';
import 'galpon_notifiers.dart';

// =============================================================================
// PROVIDERS DE INFRAESTRUCTURA
// =============================================================================

/// Provider del datasource de Firebase.
final galponFirebaseDatasourceProvider = Provider<GalponFirebaseDatasource>((
  ref,
) {
  return GalponFirebaseDatasource();
});

/// Provider del datasource local.
final galponLocalDatasourceProvider = Provider<GalponLocalDatasource>((ref) {
  final storage = ref.watch(localStorageProvider);
  return GalponLocalDatasource(storage);
});

/// Provider del repositorio de galpones.
final galponRepositoryProvider = Provider<GalponRepository>((ref) {
  return GalponRepositoryImpl(
    firebaseDatasource: ref.watch(galponFirebaseDatasourceProvider),
    localDatasource: ref.watch(galponLocalDatasourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

// =============================================================================
// PROVIDERS DE USE CASES
// =============================================================================

final crearGalponUseCaseProvider = Provider<CrearGalponUseCase>((ref) {
  return CrearGalponUseCase(repository: ref.watch(galponRepositoryProvider));
});

final actualizarGalponUseCaseProvider = Provider<ActualizarGalponUseCase>((
  ref,
) {
  return ActualizarGalponUseCase(
    repository: ref.watch(galponRepositoryProvider),
  );
});

final eliminarGalponUseCaseProvider = Provider<EliminarGalponUseCase>((ref) {
  return EliminarGalponUseCase(repository: ref.watch(galponRepositoryProvider));
});

final obtenerPorGranjaUseCaseProvider = Provider<ObtenerPorGranjaUseCase>((
  ref,
) {
  return ObtenerPorGranjaUseCase(
    repository: ref.watch(galponRepositoryProvider),
  );
});

final obtenerDisponiblesUseCaseProvider = Provider<ObtenerDisponiblesUseCase>((
  ref,
) {
  return ObtenerDisponiblesUseCase(
    repository: ref.watch(galponRepositoryProvider),
  );
});

final cambiarEstadoUseCaseProvider = Provider<CambiarEstadoUseCase>((ref) {
  return CambiarEstadoUseCase(repository: ref.watch(galponRepositoryProvider));
});

final asignarLoteUseCaseProvider = Provider<AsignarLoteUseCase>((ref) {
  return AsignarLoteUseCase(repository: ref.watch(galponRepositoryProvider));
});

final liberarGalponUseCaseProvider = Provider<LiberarGalponUseCase>((ref) {
  return LiberarGalponUseCase(repository: ref.watch(galponRepositoryProvider));
});

final programarMantenimientoUseCaseProvider =
    Provider<ProgramarMantenimientoUseCase>((ref) {
      return ProgramarMantenimientoUseCase(
        repository: ref.watch(galponRepositoryProvider),
      );
    });

final registrarDesinfeccionUseCaseProvider =
    Provider<RegistrarDesinfeccionUseCase>((ref) {
      return RegistrarDesinfeccionUseCase(
        repository: ref.watch(galponRepositoryProvider),
      );
    });

final obtenerEstadisticasUseCaseProvider = Provider<ObtenerEstadisticasUseCase>(
  (ref) {
    return ObtenerEstadisticasUseCase(
      repository: ref.watch(galponRepositoryProvider),
    );
  },
);

// =============================================================================
// PROVIDERS DE NOTIFIERS
// =============================================================================

/// Provider principal de estado de galpones.
final galponNotifierProvider =
    StateNotifierProvider.autoDispose<GalponNotifier, GalponState>((ref) {
      return GalponNotifier(
        crearUseCase: ref.watch(crearGalponUseCaseProvider),
        actualizarUseCase: ref.watch(actualizarGalponUseCaseProvider),
        eliminarUseCase: ref.watch(eliminarGalponUseCaseProvider),
        cambiarEstadoUseCase: ref.watch(cambiarEstadoUseCaseProvider),
        asignarLoteUseCase: ref.watch(asignarLoteUseCaseProvider),
        liberarUseCase: ref.watch(liberarGalponUseCaseProvider),
        programarMantenimientoUseCase: ref.watch(
          programarMantenimientoUseCaseProvider,
        ),
        registrarDesinfeccionUseCase: ref.watch(
          registrarDesinfeccionUseCaseProvider,
        ),
      );
    });

/// Provider del notifier de búsqueda.
final galponSearchNotifierProvider =
    StateNotifierProvider.autoDispose<GalponSearchNotifier, GalponSearchState>((
      ref,
    ) {
      return GalponSearchNotifier(
        obtenerPorGranjaUseCase: ref.watch(obtenerPorGranjaUseCaseProvider),
        obtenerDisponiblesUseCase: ref.watch(obtenerDisponiblesUseCaseProvider),
      );
    });

/// Provider del notifier de formulario.
final galponFormNotifierProvider =
    StateNotifierProvider.autoDispose<GalponFormNotifier, GalponFormState>((
      ref,
    ) {
      return GalponFormNotifier();
    });

/// Provider del notifier de estadísticas.
final galponStatsNotifierProvider =
    StateNotifierProvider.autoDispose<GalponStatsNotifier, GalponStatsState>((
      ref,
    ) {
      return GalponStatsNotifier(
        obtenerEstadisticasUseCase: ref.watch(
          obtenerEstadisticasUseCaseProvider,
        ),
      );
    });

// =============================================================================
// PROVIDERS DE DATOS (StreamProvider para reactividad)
// =============================================================================

/// Provider que observa todos los galpones de una granja específica.
final galponesStreamProvider = StreamProvider.autoDispose
    .family<List<Galpon>, String>((ref, granjaId) {
      final repository = ref.watch(galponRepositoryProvider);
      return repository.watchPorGranja(granjaId).map((either) {
        return either.fold((failure) => <Galpon>[], (galpones) => galpones);
      });
    });

/// Provider que observa un galpón específico por ID.
final galponByIdProvider = StreamProvider.autoDispose.family<Galpon?, String>((
  ref,
  id,
) {
  final repository = ref.watch(galponRepositoryProvider);
  return repository.watchPorId(id).map((either) {
    return either.fold((failure) => null, (galpon) => galpon);
  });
});

// =============================================================================
// PROVIDERS COMPUTADOS
// =============================================================================

/// Provider que cuenta los galpones de una granja.
final conteoGalponesProvider = Provider.family<AsyncValue<int>, String>((
  ref,
  granjaId,
) {
  final galponesAsync = ref.watch(galponesStreamProvider(granjaId));
  return galponesAsync.whenData((galpones) => galpones.length);
});

/// Provider que cuenta los galpones disponibles.
final conteoGalponesDisponiblesProvider =
    Provider.family<AsyncValue<int>, String>((ref, granjaId) {
      final galponesAsync = ref.watch(galponesStreamProvider(granjaId));
      return galponesAsync.whenData(
        (galpones) => galpones.where((g) => g.estaDisponible).length,
      );
    });

/// Provider de estadísticas de galpones.
/// Usa datos de lotes activos para calcular aves actuales y ocupación correctamente.
final estadisticasGalponesProvider =
    Provider.family<AsyncValue<GalponStatsState>, String>((ref, granjaId) {
      final galponesAsync = ref.watch(galponesStreamProvider(granjaId));
      final lotesAsync = ref.watch(lotesStreamProvider(granjaId));

      // Combinar ambos providers
      return galponesAsync.when(
        data: (galpones) {
          if (galpones.isEmpty) {
            return const AsyncData(GalponStatsState());
          }

          // Obtener datos de lotes activos
          final lotesData = lotesAsync.whenOrNull(data: (lotes) => lotes);
          final lotesActivos =
              lotesData?.where((l) => l.estaActivo).toList() ?? [];

          // Calcular aves actuales desde lotes activos
          final avesActuales = lotesActivos.fold<int>(
            0,
            (sum, l) => sum + l.avesActuales,
          );

          // Obtener IDs de galpones con lotes activos
          final galponIdsConLoteActivo = lotesActivos
              .map((l) => l.galponId)
              .toSet();

          // Galpones que tienen lotes activos
          final galponesConLoteActivo = galpones
              .where((g) => galponIdsConLoteActivo.contains(g.id))
              .toList();

          final activos = galpones
              .where((g) => g.estado == EstadoGalpon.activo)
              .length;
          final disponibles = galpones.where((g) => g.estaDisponible).length;
          final ocupados = galponesConLoteActivo.length;

          final enMantenimiento = galpones
              .where((g) => g.estado == EstadoGalpon.mantenimiento)
              .length;
          final enDesinfeccion = galpones
              .where((g) => g.estado == EstadoGalpon.desinfeccion)
              .length;
          final enCuarentena = galpones
              .where((g) => g.estado == EstadoGalpon.cuarentena)
              .length;
          final inactivos = galpones
              .where((g) => g.estado == EstadoGalpon.inactivo)
              .length;

          // Capacidad total de TODOS los galpones
          final capacidadTotal = galpones.fold<int>(
            0,
            (sum, g) => sum + g.capacidadMaxima,
          );

          // Capacidad solo de galpones con lotes activos (para calcular ocupación real)
          final capacidadOcupada = galponesConLoteActivo.fold<int>(
            0,
            (sum, g) => sum + g.capacidadMaxima,
          );

          final areaTotal = galpones.fold<double>(
            0.0,
            (sum, g) => sum + (g.areaM2 ?? 0.0),
          );

          return AsyncData(
            GalponStatsState(
              totalGalpones: galpones.length,
              galponesActivos: activos,
              galponesDisponibles: disponibles,
              galponesOcupados: ocupados,
              galponesEnMantenimiento: enMantenimiento,
              galponesEnDesinfeccion: enDesinfeccion,
              galponesEnCuarentena: enCuarentena,
              galponesInactivos: inactivos,
              capacidadTotal: capacidadTotal,
              capacidadOcupada: capacidadOcupada,
              avesActuales: avesActuales,
              areaTotalM2: areaTotal,
            ),
          );
        },
        loading: () => const AsyncLoading(),
        error: (e, st) => AsyncError(e, st),
      );
    });

/// Provider del galpón seleccionado actualmente.
final galponSeleccionadoProvider = StateProvider.autoDispose<Galpon?>(
  (ref) => null,
);

/// Provider de la granja seleccionada actualmente (para filtrar galpones).
final granjaSeleccionadaParaGalponesProvider =
    StateProvider.autoDispose<String?>((ref) => null);

/// Provider que indica si la granja tiene al menos un galpón.
final tieneGalponesProvider = Provider.family<AsyncValue<bool>, String>((
  ref,
  granjaId,
) {
  final galponesAsync = ref.watch(galponesStreamProvider(granjaId));
  return galponesAsync.whenData((galpones) => galpones.isNotEmpty);
});

/// Provider de galpones filtrados por estado.
final galponesPorEstadoProvider =
    Provider.family<
      AsyncValue<List<Galpon>>,
      ({String granjaId, EstadoGalpon estado})
    >((ref, params) {
      final galponesAsync = ref.watch(galponesStreamProvider(params.granjaId));
      return galponesAsync.whenData(
        (galpones) => galpones.where((g) => g.estado == params.estado).toList(),
      );
    });
