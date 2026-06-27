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
final conteoLotesProvider = Provider.autoDispose
    .family<AsyncValue<int>, String>((ref, granjaId) {
      final lotesAsync = ref.watch(lotesStreamProvider(granjaId));
      return lotesAsync.whenData((lotes) => lotes.length);
    });

/// Provider que cuenta los lotes activos de una granja.
final conteoLotesActivosProvider = Provider.autoDispose
    .family<AsyncValue<int>, String>((ref, granjaId) {
      final lotesAsync = ref.watch(lotesStreamProvider(granjaId));
      return lotesAsync.whenData(
        (lotes) => lotes.where((l) => l.estaActivo).length,
      );
    });

/// Provider que obtiene el lote activo de un galpón.
final loteActivoGalponProvider = Provider.autoDispose
    .family<AsyncValue<Lote?>, String>((ref, galponId) {
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
/// Calcula todas las estadísticas en un solo recorrido O(N).
final estadisticasLotesProvider = Provider.autoDispose
    .family<AsyncValue<LoteStatsState>, String>((ref, granjaId) {
      final lotesAsync = ref.watch(lotesStreamProvider(granjaId));

      return lotesAsync.whenData((lotes) {
        if (lotes.isEmpty) {
          return LoteStatsState.initial();
        }

        // Calcular todo en un solo recorrido
        int activos = 0;
        int cerrados = 0;
        int enCuarentena = 0;
        int vendidos = 0;
        int totalAvesActuales = 0;
        int totalAvesInicial = 0;
        int mortalidadTotal = 0;
        double sumMortalidadPct = 0.0;

        for (final l in lotes) {
          totalAvesInicial += l.cantidadInicial;
          mortalidadTotal += l.mortalidadAcumulada;
          sumMortalidadPct += l.porcentajeMortalidad;

          if (l.estaActivo) {
            activos++;
            totalAvesActuales += l.avesActuales;
          }
          switch (l.estado) {
            case EstadoLote.cerrado:
              cerrados++;
            case EstadoLote.cuarentena:
              enCuarentena++;
            case EstadoLote.vendido:
              vendidos++;
            default:
              break;
          }
        }

        return LoteStatsState(
          totalLotes: lotes.length,
          lotesActivos: activos,
          lotesCerrados: cerrados,
          lotesEnCuarentena: enCuarentena,
          lotesVendidos: vendidos,
          totalAvesActuales: totalAvesActuales,
          totalAvesInicial: totalAvesInicial,
          mortalidadTotal: mortalidadTotal,
          mortalidadPromedio: sumMortalidadPct / lotes.length,
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
final tieneLoteActivoProvider = Provider.autoDispose
    .family<AsyncValue<bool>, String>((ref, granjaId) {
      final lotesAsync = ref.watch(lotesStreamProvider(granjaId));
      return lotesAsync.whenData((lotes) => lotes.any((l) => l.estaActivo));
    });

/// Provider de lotes filtrados por estado.
final lotesPorEstadoProvider = Provider.autoDispose
    .family<AsyncValue<List<Lote>>, ({String granjaId, EstadoLote estado})>((
      ref,
      params,
    ) {
      final lotesAsync = ref.watch(lotesStreamProvider(params.granjaId));
      return lotesAsync.whenData(
        (lotes) => lotes.where((l) => l.estado == params.estado).toList(),
      );
    });

/// Provider que cuenta las aves totales activas de una granja.
final totalAvesActivasProvider = Provider.autoDispose
    .family<AsyncValue<int>, String>((ref, granjaId) {
      final lotesAsync = ref.watch(lotesStreamProvider(granjaId));
      return lotesAsync.whenData((lotes) {
        return lotes
            .where((l) => l.estaActivo)
            .fold<int>(0, (sum, l) => sum + l.avesActuales);
      });
    });
