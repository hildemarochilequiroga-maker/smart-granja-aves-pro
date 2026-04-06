/// Providers de Riverpod para inventario.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../../domain/repositories/repositories.dart';
import '../../infrastructure/datasources/datasources.dart';
import '../../infrastructure/repositories/repositories.dart';

// ==================== DATASOURCE PROVIDER ====================

final inventarioRemoteDatasourceProvider = Provider<InventarioRemoteDatasource>(
  (ref) {
    return InventarioRemoteDatasourceImpl(FirebaseFirestore.instance);
  },
);

// ==================== REPOSITORY PROVIDER ====================

final inventarioRepositoryProvider = Provider<InventarioRepository>((ref) {
  final datasource = ref.watch(inventarioRemoteDatasourceProvider);
  return InventarioRepositoryImpl(datasource);
});

// ==================== ITEMS PROVIDERS ====================

/// Stream de todos los items de una granja.
final inventarioItemsStreamProvider =
    StreamProvider.family<List<ItemInventario>, String>((ref, granjaId) {
      final repository = ref.watch(inventarioRepositoryProvider);
      return repository.observarItems(granjaId);
    });

/// Stream de items con alertas.
final inventarioAlertasStreamProvider =
    StreamProvider.family<List<ItemInventario>, String>((ref, granjaId) {
      final repository = ref.watch(inventarioRepositoryProvider);
      return repository.observarItemsConAlertas(granjaId);
    });

/// Future de items por tipo.
final inventarioItemsPorTipoProvider = FutureProvider.autoDispose
    .family<List<ItemInventario>, ({String granjaId, TipoItem tipo})>((
      ref,
      params,
    ) {
      final repository = ref.watch(inventarioRepositoryProvider);
      return repository.obtenerItemsPorTipo(params.granjaId, params.tipo);
    });

/// Future de item por ID.
final inventarioItemPorIdProvider = FutureProvider.autoDispose
    .family<ItemInventario?, String>((ref, itemId) {
      final repository = ref.watch(inventarioRepositoryProvider);
      return repository.obtenerItemPorId(itemId);
    });

/// Búsqueda de items.
final inventarioBusquedaProvider = FutureProvider.autoDispose
    .family<List<ItemInventario>, ({String granjaId, String query})>((
      ref,
      params,
    ) {
      final repository = ref.watch(inventarioRepositoryProvider);
      return repository.buscarItems(params.granjaId, params.query);
    });

// ==================== MOVIMIENTOS PROVIDERS ====================

/// Stream de movimientos de un item.
final inventarioMovimientosStreamProvider =
    StreamProvider.family<List<MovimientoInventario>, String>((ref, itemId) {
      final repository = ref.watch(inventarioRepositoryProvider);
      return repository.observarMovimientos(itemId);
    });

/// Future de movimientos de una granja.
final inventarioMovimientosGranjaProvider = FutureProvider.autoDispose
    .family<
      List<MovimientoInventario>,
      ({String granjaId, DateTime? desde, DateTime? hasta, int? limite})
    >((ref, params) {
      final repository = ref.watch(inventarioRepositoryProvider);
      return repository.obtenerMovimientosGranja(
        params.granjaId,
        desde: params.desde,
        hasta: params.hasta,
        limite: params.limite,
      );
    });

// ==================== RESUMEN PROVIDER ====================

/// Stream del resumen de inventario.
final inventarioResumenStreamProvider =
    StreamProvider.family<ResumenInventario, String>((ref, granjaId) {
      final repository = ref.watch(inventarioRepositoryProvider);
      return repository.observarResumen(granjaId);
    });

// ==================== NOTIFIERS ====================

/// Notifier para operaciones de items.
final inventarioItemNotifierProvider =
    StateNotifierProvider.autoDispose<InventarioItemNotifier, AsyncValue<void>>(
      (ref) {
        final repository = ref.watch(inventarioRepositoryProvider);
        return InventarioItemNotifier(repository);
      },
    );

/// State notifier para operaciones de items.
class InventarioItemNotifier extends StateNotifier<AsyncValue<void>> {
  InventarioItemNotifier(this._repository) : super(const AsyncValue.data(null));

  final InventarioRepository _repository;

  /// Crea un nuevo item.
  Future<ItemInventario?> crearItem(ItemInventario item) async {
    state = const AsyncValue.loading();
    try {
      final nuevoItem = await _repository.crearItem(item);
      if (mounted) state = const AsyncValue.data(null);
      return nuevoItem;
    } on Exception catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
      rethrow; // Re-lanzar para que el UI pueda capturarlo
    }
  }

  /// Actualiza un item existente.
  Future<bool> actualizarItem(ItemInventario item) async {
    if (mounted) state = const AsyncValue.loading();
    try {
      await _repository.actualizarItem(item);
      if (mounted) state = const AsyncValue.data(null);
      return true;
    } on Exception catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
      rethrow; // Re-lanzar para que el UI pueda capturarlo
    }
  }

  /// Elimina un item.
  Future<bool> eliminarItem(String itemId) async {
    if (mounted) state = const AsyncValue.loading();
    try {
      await _repository.eliminarItem(itemId);
      if (mounted) state = const AsyncValue.data(null);
      return true;
    } on Exception catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Notifier para operaciones de movimientos.
final inventarioMovimientoNotifierProvider =
    StateNotifierProvider.autoDispose<
      InventarioMovimientoNotifier,
      AsyncValue<void>
    >((ref) {
      final repository = ref.watch(inventarioRepositoryProvider);
      return InventarioMovimientoNotifier(repository);
    });

/// State notifier para operaciones de movimientos.
class InventarioMovimientoNotifier extends StateNotifier<AsyncValue<void>> {
  InventarioMovimientoNotifier(this._repository)
    : super(const AsyncValue.data(null));

  final InventarioRepository _repository;

  /// Registra una entrada de inventario.
  Future<MovimientoInventario?> registrarEntrada({
    required String itemId,
    required String granjaId,
    required TipoMovimiento tipo,
    required double cantidad,
    required String registradoPor,
    String? motivo,
    String? proveedor,
    double? costoTotal,
    String? numeroDocumento,
    String? observaciones,
    String? referenciaId,
    String? referenciaTipo,
  }) async {
    state = const AsyncValue.loading();
    try {
      final movimiento = await _repository.registrarEntrada(
        itemId: itemId,
        granjaId: granjaId,
        tipo: tipo,
        cantidad: cantidad,
        registradoPor: registradoPor,
        motivo: motivo,
        proveedor: proveedor,
        costoTotal: costoTotal,
        numeroDocumento: numeroDocumento,
        observaciones: observaciones,
        referenciaId: referenciaId,
        referenciaTipo: referenciaTipo,
      );
      state = const AsyncValue.data(null);
      return movimiento;
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Registra una salida de inventario.
  Future<MovimientoInventario?> registrarSalida({
    required String itemId,
    required String granjaId,
    required TipoMovimiento tipo,
    required double cantidad,
    required String registradoPor,
    String? motivo,
    String? referenciaId,
    String? referenciaTipo,
    String? loteId,
    String? observaciones,
  }) async {
    state = const AsyncValue.loading();
    try {
      final movimiento = await _repository.registrarSalida(
        itemId: itemId,
        granjaId: granjaId,
        tipo: tipo,
        cantidad: cantidad,
        registradoPor: registradoPor,
        motivo: motivo,
        referenciaId: referenciaId,
        referenciaTipo: referenciaTipo,
        loteId: loteId,
        observaciones: observaciones,
      );
      state = const AsyncValue.data(null);
      return movimiento;
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Ajusta el stock de un item.
  Future<MovimientoInventario?> ajustarStock({
    required String itemId,
    required String granjaId,
    required double nuevoStock,
    required String registradoPor,
    required String motivo,
  }) async {
    state = const AsyncValue.loading();
    try {
      final movimiento = await _repository.ajustarStock(
        itemId: itemId,
        granjaId: granjaId,
        nuevoStock: nuevoStock,
        registradoPor: registradoPor,
        motivo: motivo,
      );
      state = const AsyncValue.data(null);
      return movimiento;
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

// ==================== VALIDACIONES ====================

/// Provider para verificar stock suficiente.
final hayStockSuficienteProvider =
    FutureProvider.family<bool, ({String itemId, double cantidad})>((
      ref,
      params,
    ) {
      final repository = ref.watch(inventarioRepositoryProvider);
      return repository.hayStockSuficiente(params.itemId, params.cantidad);
    });

/// Provider para obtener stock actual.
final stockActualProvider = FutureProvider.family<double, String>((
  ref,
  itemId,
) {
  final repository = ref.watch(inventarioRepositoryProvider);
  return repository.obtenerStockActual(itemId);
});
