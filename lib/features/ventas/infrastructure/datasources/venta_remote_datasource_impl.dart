import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/venta_producto.dart';
import '../models/venta_pedido_model.dart';
import '../models/venta_producto_model.dart';
import 'venta_remote_datasource.dart';

final ventaRemoteDatasourceProvider = Provider<VentaRemoteDatasource>((ref) {
  return VentaRemoteDatasourceImpl(FirebaseFirestore.instance);
});

class VentaRemoteDatasourceImpl implements VentaRemoteDatasource {
  final FirebaseFirestore firestore;
  static const String _collectionVentas = 'ventas_pedidos';
  static const String _collectionProductos = 'ventas_productos';

  VentaRemoteDatasourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get _ventasCollection =>
      firestore.collection(_collectionVentas);

  CollectionReference<Map<String, dynamic>> get _productosCollection =>
      firestore.collection(_collectionProductos);

  // ============================================================================
  // VENTA PEDIDO METHODS
  // ============================================================================

  @override
  Future<List<VentaPedidoModel>> fetchVentas() async {
    try {
      final snapshot = await _ventasCollection
          .orderBy('fechaPedido', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => VentaPedidoModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_GET_SALES', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<VentaPedidoModel?> fetchVentaPorId(String id) async {
    try {
      final doc = await _ventasCollection.doc(id).get();
      if (!doc.exists || doc.data() == null) return null;
      return VentaPedidoModel.fromFirestore(doc.data()!, doc.id);
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_GET_SALE', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<void> createVenta(VentaPedidoModel venta) async {
    try {
      final data = venta.toFirestore();
      if (venta.id.isEmpty) {
        await _ventasCollection.add(data);
      } else {
        await _ventasCollection.doc(venta.id).set(data);
      }
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_CREATE_SALE', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<void> updateVenta(VentaPedidoModel venta) async {
    try {
      await _ventasCollection.doc(venta.id).update(venta.toFirestore());
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_UPDATE_SALE', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<void> deleteVenta(String id) async {
    try {
      await _ventasCollection.doc(id).delete();
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_DELETE_SALE', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  // ============================================================================
  // VENTA PRODUCTO METHODS
  // ============================================================================

  @override
  Future<VentaProducto> createVentaProducto(VentaProducto venta) async {
    try {
      final data = VentaProductoModel.toFirestore(venta);
      final docRef = await _productosCollection.add(data);
      final doc = await docRef.get();
      return VentaProductoModel.fromFirestore(doc);
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_CREATE_SALE_PRODUCT', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<VentaProducto?> fetchVentaProductoPorId(String id) async {
    try {
      final doc = await _productosCollection.doc(id).get();
      if (!doc.exists) return null;
      return VentaProductoModel.fromFirestore(doc);
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_GET_SALE_PRODUCT', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<List<VentaProducto>> fetchVentasProductoPorLote(String loteId) async {
    try {
      final snapshot = await _productosCollection
          .where('loteId', isEqualTo: loteId)
          .orderBy('fechaVenta', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => VentaProductoModel.fromFirestore(doc))
          .toList();
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_GET_SALES_BY_BATCH', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<List<VentaProducto>> fetchVentasProductoPorGranja(
    String granjaId,
  ) async {
    try {
      final snapshot = await _productosCollection
          .where('granjaId', isEqualTo: granjaId)
          .orderBy('fechaVenta', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => VentaProductoModel.fromFirestore(doc))
          .toList();
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_GET_SALES_BY_FARM', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<List<VentaProducto>> fetchTodasVentasProductos() async {
    try {
      final snapshot = await _productosCollection
          .orderBy('fechaVenta', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => VentaProductoModel.fromFirestore(doc))
          .toList();
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_GET_ALL_SALES', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<void> updateVentaProducto(VentaProducto venta) async {
    try {
      final data = VentaProductoModel.toFirestore(venta);
      await _productosCollection.doc(venta.id).update(data);
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_UPDATE_SALE_PRODUCT', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<void> deleteVentaProducto(String id) async {
    try {
      await _productosCollection.doc(id).delete();
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_DELETE_SALE_PRODUCT', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Stream<List<VentaProducto>> streamVentasProductoPorLote(String loteId) {
    return _productosCollection
        .where('loteId', isEqualTo: loteId)
        .orderBy('fechaVenta', descending: true)
        .limit(200)
        .snapshots()
        .map((snapshot) {
          final ventas = <VentaProducto>[];
          for (final doc in snapshot.docs) {
            try {
              ventas.add(VentaProductoModel.fromFirestore(doc));
            } on Exception catch (e) {
              debugPrint('Error parseando venta ${doc.id}: $e');
            }
          }
          return ventas;
        })
        .handleError((error) {
          debugPrint('Error en stream ventas por lote: $error');
          throw error;
        });
  }

  @override
  Stream<List<VentaProducto>> streamVentasProductoPorGranja(String granjaId) {
    return _productosCollection
        .where('granjaId', isEqualTo: granjaId)
        .orderBy('fechaVenta', descending: true)
        .limit(200)
        .snapshots()
        .map((snapshot) {
          final ventas = <VentaProducto>[];
          for (final doc in snapshot.docs) {
            try {
              ventas.add(VentaProductoModel.fromFirestore(doc));
            } on Exception catch (e) {
              debugPrint('Error parseando venta ${doc.id}: $e');
            }
          }
          return ventas;
        })
        .handleError((error) {
          debugPrint('Error en stream ventas por granja: $error');
          throw error;
        });
  }

  @override
  Stream<List<VentaProducto>> streamTodasVentasProductos() {
    return _productosCollection
        .orderBy('fechaVenta', descending: true)
        .limit(200)
        .snapshots()
        .map((snapshot) {
          final ventas = <VentaProducto>[];
          for (final doc in snapshot.docs) {
            try {
              ventas.add(VentaProductoModel.fromFirestore(doc));
            } on Exception catch (e) {
              debugPrint('Error parseando venta ${doc.id}: $e');
            }
          }
          return ventas;
        })
        .handleError((error) {
          debugPrint('Error en stream todas las ventas: $error');
          throw error;
        });
  }
}
