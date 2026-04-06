/// Datasource remoto para inventario usando Firebase.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../models/models.dart';

/// Interfaz del datasource de inventario.
abstract class InventarioRemoteDatasource {
  // Items
  Future<List<ItemInventario>> fetchItems(String granjaId);
  Future<ItemInventario?> fetchItemPorId(String itemId);
  Future<List<ItemInventario>> fetchItemsPorTipo(
    String granjaId,
    TipoItem tipo,
  );
  Future<List<ItemInventario>> buscarItems(String granjaId, String query);
  Future<ItemInventario> crearItem(ItemInventario item);
  Future<void> actualizarItem(ItemInventario item);
  Future<void> eliminarItem(String itemId);
  Stream<List<ItemInventario>> streamItems(String granjaId);

  // Movimientos
  Future<List<MovimientoInventario>> fetchMovimientos(
    String itemId, {
    DateTime? desde,
    DateTime? hasta,
    int? limite,
  });
  Future<List<MovimientoInventario>> fetchMovimientosGranja(
    String granjaId, {
    DateTime? desde,
    DateTime? hasta,
    TipoMovimiento? tipo,
    int? limite,
  });
  Future<MovimientoInventario> crearMovimiento(MovimientoInventario movimiento);
  Future<void> actualizarStockItem(String itemId, double nuevoStock);

  /// Registra un movimiento y actualiza el stock en una operación atómica.
  /// Si una de las dos escrituras falla, ambas se revierten.
  Future<MovimientoInventario> registrarMovimientoYActualizarStock(
    MovimientoInventario movimiento,
    double nuevoStock,
  );

  Stream<List<MovimientoInventario>> streamMovimientos(String itemId);
}

/// Implementación de datasource usando Firestore.
class InventarioRemoteDatasourceImpl implements InventarioRemoteDatasource {
  InventarioRemoteDatasourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  static const String _itemsCollection = 'inventario_items';
  static const String _movimientosCollection = 'inventario_movimientos';

  CollectionReference<Map<String, dynamic>> get _itemsRef =>
      _firestore.collection(_itemsCollection);

  CollectionReference<Map<String, dynamic>> get _movimientosRef =>
      _firestore.collection(_movimientosCollection);

  // ==================== ITEMS ====================

  @override
  Future<List<ItemInventario>> fetchItems(String granjaId) async {
    final snapshot = await _itemsRef
        .where('granjaId', isEqualTo: granjaId)
        .where('activo', isEqualTo: true)
        .orderBy('nombre')
        .get();

    return snapshot.docs
        .map((doc) => ItemInventarioModel.fromFirestore(doc).toEntity())
        .toList();
  }

  @override
  Future<ItemInventario?> fetchItemPorId(String itemId) async {
    final doc = await _itemsRef.doc(itemId).get();
    if (!doc.exists) return null;
    return ItemInventarioModel.fromFirestore(doc).toEntity();
  }

  @override
  Future<List<ItemInventario>> fetchItemsPorTipo(
    String granjaId,
    TipoItem tipo,
  ) async {
    final snapshot = await _itemsRef
        .where('granjaId', isEqualTo: granjaId)
        .where('tipo', isEqualTo: tipo.toJson())
        .where('activo', isEqualTo: true)
        .orderBy('nombre')
        .get();

    return snapshot.docs
        .map((doc) => ItemInventarioModel.fromFirestore(doc).toEntity())
        .toList();
  }

  @override
  Future<List<ItemInventario>> buscarItems(
    String granjaId,
    String query,
  ) async {
    final queryLower = query.toLowerCase();
    final snapshot = await _itemsRef
        .where('granjaId', isEqualTo: granjaId)
        .where('activo', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => ItemInventarioModel.fromFirestore(doc).toEntity())
        .where(
          (item) =>
              item.nombre.toLowerCase().contains(queryLower) ||
              (item.codigo?.toLowerCase().contains(queryLower) ?? false),
        )
        .toList();
  }

  @override
  Future<ItemInventario> crearItem(ItemInventario item) async {
    final model = ItemInventarioModel.fromEntity(item);
    final docRef = await _itemsRef.add(model.toFirestore());
    return item.copyWith(id: docRef.id);
  }

  @override
  Future<void> actualizarItem(ItemInventario item) async {
    final model = ItemInventarioModel.fromEntity(item);
    await _itemsRef.doc(item.id).update(model.toFirestore());
  }

  @override
  Future<void> eliminarItem(String itemId) async {
    await _itemsRef.doc(itemId).update({
      'activo': false,
      'fechaActualizacion': Timestamp.now(),
    });
  }

  @override
  Stream<List<ItemInventario>> streamItems(String granjaId) {
    return _itemsRef
        .where('granjaId', isEqualTo: granjaId)
        .where('activo', isEqualTo: true)
        .orderBy('nombre')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ItemInventarioModel.fromFirestore(doc).toEntity())
              .toList(),
        );
  }

  // ==================== MOVIMIENTOS ====================

  @override
  Future<List<MovimientoInventario>> fetchMovimientos(
    String itemId, {
    DateTime? desde,
    DateTime? hasta,
    int? limite,
  }) async {
    Query<Map<String, dynamic>> query = _movimientosRef.where(
      'itemId',
      isEqualTo: itemId,
    );

    if (desde != null) {
      query = query.where(
        'fecha',
        isGreaterThanOrEqualTo: Timestamp.fromDate(desde),
      );
    }
    if (hasta != null) {
      query = query.where(
        'fecha',
        isLessThanOrEqualTo: Timestamp.fromDate(hasta),
      );
    }

    query = query.orderBy('fecha', descending: true);

    if (limite != null) {
      query = query.limit(limite);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => MovimientoInventarioModel.fromFirestore(doc).toEntity())
        .toList();
  }

  @override
  Future<List<MovimientoInventario>> fetchMovimientosGranja(
    String granjaId, {
    DateTime? desde,
    DateTime? hasta,
    TipoMovimiento? tipo,
    int? limite,
  }) async {
    Query<Map<String, dynamic>> query = _movimientosRef.where(
      'granjaId',
      isEqualTo: granjaId,
    );

    if (tipo != null) {
      query = query.where('tipo', isEqualTo: tipo.toJson());
    }

    query = query.orderBy('fecha', descending: true);

    if (limite != null) {
      query = query.limit(limite);
    }

    final snapshot = await query.get();

    var results = snapshot.docs
        .map((doc) => MovimientoInventarioModel.fromFirestore(doc).toEntity())
        .toList();

    // Filtrar por fechas en memoria si es necesario
    if (desde != null) {
      results = results
          .where(
            (m) => m.fecha.isAfter(desde) || m.fecha.isAtSameMomentAs(desde),
          )
          .toList();
    }
    if (hasta != null) {
      results = results
          .where(
            (m) => m.fecha.isBefore(hasta) || m.fecha.isAtSameMomentAs(hasta),
          )
          .toList();
    }

    return results;
  }

  @override
  Future<MovimientoInventario> crearMovimiento(
    MovimientoInventario movimiento,
  ) async {
    final model = MovimientoInventarioModel.fromEntity(movimiento);
    final docRef = await _movimientosRef.add(model.toFirestore());
    return movimiento.copyWith(id: docRef.id);
  }

  @override
  Future<void> actualizarStockItem(String itemId, double nuevoStock) async {
    await _itemsRef.doc(itemId).update({
      'stockActual': nuevoStock,
      'fechaActualizacion': Timestamp.now(),
    });
  }

  @override
  Future<MovimientoInventario> registrarMovimientoYActualizarStock(
    MovimientoInventario movimiento,
    double nuevoStock,
  ) async {
    final batch = _firestore.batch();

    // 1. Actualizar stock del item
    batch.update(_itemsRef.doc(movimiento.itemId), {
      'stockActual': nuevoStock,
      'fechaActualizacion': Timestamp.now(),
    });

    // 2. Crear documento de movimiento
    final model = MovimientoInventarioModel.fromEntity(movimiento);
    final movDocRef = _movimientosRef.doc();
    batch.set(movDocRef, model.toFirestore());

    // Ejecutar ambas escrituras atómicamente
    await batch.commit();

    return movimiento.copyWith(id: movDocRef.id);
  }

  @override
  Stream<List<MovimientoInventario>> streamMovimientos(String itemId) {
    return _movimientosRef
        .where('itemId', isEqualTo: itemId)
        .orderBy('fecha', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    MovimientoInventarioModel.fromFirestore(doc).toEntity(),
              )
              .toList(),
        );
  }
}
