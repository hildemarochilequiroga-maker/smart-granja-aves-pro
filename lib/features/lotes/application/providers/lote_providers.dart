import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/providers/auth_provider.dart';
import '../../domain/entities/lote.dart';
import '../../domain/enums/estado_lote.dart';
import '../../domain/repositories/lote_repository.dart';
import '../../infrastructure/datasources/datasources.dart';
import '../../infrastructure/repositories/lote_repository_impl.dart';
import '../state/lote_state.dart';
import 'lote_notifiers.dart';

// =============================================================================
// PROVIDERS DE INFRAESTRUCTURA
// =============================================================================

/// Provider del datasource de Firebase.
final loteFirebaseDatasourceProvider = Provider<LoteFirebaseDatasource>((ref) {
  return LoteFirebaseDatasource();
});

/// Provider del datasource local.
final loteLocalDatasourceProvider = Provider<LoteLocalDatasource>((ref) {
  final storage = ref.watch(localStorageProvider);
  return LoteLocalDatasource(storage);
});

/// Provider del repositorio de lotes.
final loteRepositoryProvider = Provider<LoteRepository>((ref) {
  return LoteRepositoryImpl(
    firebaseDatasource: ref.watch(loteFirebaseDatasourceProvider),
    localDatasource: ref.watch(loteLocalDatasourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

// =============================================================================
// PROVIDERS DE NOTIFIERS
// =============================================================================

/// Provider principal de estado de lotes.
final loteNotifierProvider =
    StateNotifierProvider.autoDispose<LoteNotifier, LoteState>((ref) {
      return LoteNotifier(repository: ref.watch(loteRepositoryProvider));
    });

/// Provider del notifier de formulario.
final loteFormNotifierProvider =
    StateNotifierProvider.autoDispose<LoteFormNotifier, LoteFormState>((ref) {
      return LoteFormNotifier();
    });

/// Provider del notifier de búsqueda.
final loteSearchNotifierProvider =
    StateNotifierProvider.autoDispose<LoteSearchNotifier, LoteSearchState>((
      ref,
    ) {
      return LoteSearchNotifier(repository: ref.watch(loteRepositoryProvider));
    });

/// Provider del notifier de estadísticas.
final loteStatsNotifierProvider =
    StateNotifierProvider.autoDispose<LoteStatsNotifier, LoteStatsState>((ref) {
      return LoteStatsNotifier(repository: ref.watch(loteRepositoryProvider));
    });

// =============================================================================
// PROVIDERS DE DATOS (StreamProvider para reactividad)
// =============================================================================

/// Provider que observa todos los lotes de una granja específica.
final lotesStreamProvider = StreamProvider.autoDispose
    .family<List<Lote>, String>((ref, granjaId) {
      final repository = ref.watch(loteRepositoryProvider);
      return repository.watchPorGranja(granjaId).map((either) {
        return either.fold((failure) => <Lote>[], (lotes) => lotes);
      });
    });

/// Provider que observa todos los lotes de un galpón específico.
final lotesGalponStreamProvider = StreamProvider.autoDispose
    .family<List<Lote>, String>((ref, galponId) {
      final repository = ref.watch(loteRepositoryProvider);
      return repository.watchPorGalpon(galponId).map((either) {
        return either.fold((failure) => <Lote>[], (lotes) => lotes);
      });
    });

/// Provider que observa un lote específico por ID.
final loteByIdProvider = StreamProvider.autoDispose.family<Lote?, String>((
  ref,
  id,
) {
  final repository = ref.watch(loteRepositoryProvider);
  return repository.watchPorId(id).map((either) {
    return either.fold((failure) => null, (lote) => lote);
  });
});

// =============================================================================
// PROVIDERS COMPUTADOS
// =============================================================================

/// Provider que cuenta los lotes de una granja.
final conteoLotesProvider = Provider.family<AsyncValue<int>, String>((
  ref,
  granjaId,
) {
  final lotesAsync = ref.watch(lotesStreamProvider(granjaId));
  return lotesAsync.whenData((lotes) => lotes.length);
});

/// Provider que cuenta los lotes activos de una granja.
final conteoLotesActivosProvider = Provider.family<AsyncValue<int>, String>((
  ref,
  granjaId,
) {
  final lotesAsync = ref.watch(lotesStreamProvider(granjaId));
  return lotesAsync.whenData(
    (lotes) => lotes.where((l) => l.estaActivo).length,
  );
});

/// Provider que obtiene el lote activo de un galpón.
final loteActivoGalponProvider = Provider.family<AsyncValue<Lote?>, String>((
  ref,
  galponId,
) {
  final lotesAsync = ref.watch(lotesGalponStreamProvider(galponId));
  return lotesAsync.whenData((lotes) {
    try {
      return lotes.firstWhere((l) => l.estaActivo);
    } catch (_) {
      return null;
    }
  });
});

/// Provider de estadísticas de lotes.
final estadisticasLotesProvider =
    Provider.family<AsyncValue<LoteStatsState>, String>((ref, granjaId) {
      final lotesAsync = ref.watch(lotesStreamProvider(granjaId));

      return lotesAsync.whenData((lotes) {
        if (lotes.isEmpty) {
          return LoteStatsState.initial();
        }

        final activos = lotes.where((l) => l.estaActivo).length;
        final cerrados = lotes
            .where((l) => l.estado == EstadoLote.cerrado)
            .length;
        final enCuarentena = lotes
            .where((l) => l.estado == EstadoLote.cuarentena)
            .length;
        final vendidos = lotes
            .where((l) => l.estado == EstadoLote.vendido)
            .length;

        final totalAvesActuales = lotes
            .where((l) => l.estaActivo)
            .fold<int>(0, (sum, l) => sum + l.avesActuales);
        final totalAvesInicial = lotes.fold<int>(
          0,
          (sum, l) => sum + l.cantidadInicial,
        );
        final mortalidadTotal = lotes.fold<int>(
          0,
          (sum, l) => sum + l.mortalidadAcumulada,
        );
        final mortalidadPromedio = lotes.isNotEmpty
            ? lotes.fold<double>(0, (sum, l) => sum + l.porcentajeMortalidad) /
                  lotes.length
            : 0.0;

        return LoteStatsState(
          totalLotes: lotes.length,
          lotesActivos: activos,
          lotesCerrados: cerrados,
          lotesEnCuarentena: enCuarentena,
          lotesVendidos: vendidos,
          totalAvesActuales: totalAvesActuales,
          totalAvesInicial: totalAvesInicial,
          mortalidadTotal: mortalidadTotal,
          mortalidadPromedio: mortalidadPromedio,
        );
      });
    });

/// Provider del lote seleccionado actualmente.
final loteSeleccionadoProvider = StateProvider.autoDispose<Lote?>(
  (ref) => null,
);

/// Provider de la granja seleccionada actualmente (para filtrar lotes).
final granjaSeleccionadaParaLotesProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

/// Provider que indica si la granja tiene al menos un lote activo.
final tieneLoteActivoProvider = Provider.family<AsyncValue<bool>, String>((
  ref,
  granjaId,
) {
  final lotesAsync = ref.watch(lotesStreamProvider(granjaId));
  return lotesAsync.whenData((lotes) => lotes.any((l) => l.estaActivo));
});

/// Provider de lotes filtrados por estado.
final lotesPorEstadoProvider =
    Provider.family<
      AsyncValue<List<Lote>>,
      ({String granjaId, EstadoLote estado})
    >((ref, params) {
      final lotesAsync = ref.watch(lotesStreamProvider(params.granjaId));
      return lotesAsync.whenData(
        (lotes) => lotes.where((l) => l.estado == params.estado).toList(),
      );
    });

/// Provider que cuenta las aves totales activas de una granja.
final totalAvesActivasProvider = Provider.family<AsyncValue<int>, String>((
  ref,
  granjaId,
) {
  final lotesAsync = ref.watch(lotesStreamProvider(granjaId));
  return lotesAsync.whenData((lotes) {
    return lotes
        .where((l) => l.estaActivo)
        .fold<int>(0, (sum, l) => sum + l.avesActuales);
  });
});
