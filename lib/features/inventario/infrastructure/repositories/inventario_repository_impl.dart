/// Implementación del repositorio de inventario.
library;

import 'package:uuid/uuid.dart';
import '../../../../core/errors/error_messages.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';

/// Implementación de InventarioRepository.
class InventarioRepositoryImpl implements InventarioRepository {
  InventarioRepositoryImpl(this._datasource);

  final InventarioRemoteDatasource _datasource;
  final _uuid = const Uuid();

  // ==================== ITEMS ====================

  @override
  Future<List<ItemInventario>> obtenerItems(String granjaId) {
    return _datasource.fetchItems(granjaId);
  }

  @override
  Future<ItemInventario?> obtenerItemPorId(String itemId) {
    return _datasource.fetchItemPorId(itemId);
  }

  @override
  Future<List<ItemInventario>> obtenerItemsPorTipo(
    String granjaId,
    TipoItem tipo,
  ) {
    return _datasource.fetchItemsPorTipo(granjaId, tipo);
  }

  @override
  Future<List<ItemInventario>> obtenerItemsStockBajo(String granjaId) async {
    final items = await _datasource.fetchItems(granjaId);
    return items.where((item) => item.stockBajo || item.agotado).toList();
  }

  @override
  Future<List<ItemInventario>> obtenerItemsProximosVencer(
    String granjaId, {
    int diasLimite = 30,
  }) async {
    final items = await _datasource.fetchItems(granjaId);
    final ahora = DateTime.now();
    return items.where((item) {
      if (item.fechaVencimiento == null) return false;
      final dias = item.fechaVencimiento!.difference(ahora).inDays;
      return dias <= diasLimite && dias >= 0;
    }).toList();
  }

  @override
  Future<List<ItemInventario>> buscarItems(String granjaId, String query) {
    return _datasource.buscarItems(granjaId, query);
  }

  @override
  Future<ItemInventario> crearItem(ItemInventario item) async {
    final nuevoItem = item.copyWith(
      id: item.id.isEmpty ? _uuid.v4() : item.id,
      fechaCreacion: DateTime.now(),
    );
    return _datasource.crearItem(nuevoItem);
  }

  @override
  Future<void> actualizarItem(ItemInventario item) {
    final itemActualizado = item.copyWith(fechaActualizacion: DateTime.now());
    return _datasource.actualizarItem(itemActualizado);
  }

  @override
  Future<void> eliminarItem(String itemId) {
    return _datasource.eliminarItem(itemId);
  }

  @override
  Stream<List<ItemInventario>> observarItems(String granjaId) {
    return _datasource.streamItems(granjaId);
  }

  @override
  Stream<List<ItemInventario>> observarItemsConAlertas(String granjaId) {
    return _datasource.streamItems(granjaId).map((items) {
      return items
          .where(
            (item) =>
                item.stockBajo ||
                item.agotado ||
                item.proximoVencer ||
                item.vencido,
          )
          .toList();
    });
  }

  // ==================== MOVIMIENTOS ====================

  @override
  Future<List<MovimientoInventario>> obtenerMovimientos(
    String itemId, {
    DateTime? desde,
    DateTime? hasta,
    int? limite,
  }) {
    return _datasource.fetchMovimientos(
      itemId,
      desde: desde,
      hasta: hasta,
      limite: limite,
    );
  }

  @override
  Future<List<MovimientoInventario>> obtenerMovimientosGranja(
    String granjaId, {
    DateTime? desde,
    DateTime? hasta,
    TipoMovimiento? tipo,
    int? limite,
  }) {
    return _datasource.fetchMovimientosGranja(
      granjaId,
      desde: desde,
      hasta: hasta,
      tipo: tipo,
      limite: limite,
    );
  }

  @override
  Future<MovimientoInventario> registrarEntrada({
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
    // Obtener item actual
    final item = await _datasource.fetchItemPorId(itemId);
    if (item == null) {
      throw ItemInventarioException(ErrorMessages.get('ERR_ITEM_NOT_FOUND'));
    }

    final stockAnterior = item.stockActual;
    final stockNuevo = stockAnterior + cantidad;

    // Crear movimiento
    final movimiento = MovimientoInventario.entrada(
      id: _uuid.v4(),
      itemId: itemId,
      granjaId: granjaId,
      tipo: tipo,
      cantidad: cantidad,
      stockAnterior: stockAnterior,
      registradoPor: registradoPor,
      motivo: motivo,
      proveedor: proveedor,
      costoTotal: costoTotal,
      numeroDocumento: numeroDocumento,
      observaciones: observaciones,
      referenciaId: referenciaId,
      referenciaTipo: referenciaTipo,
    );

    // Actualizar stock + guardar movimiento atómicamente
    return _datasource.registrarMovimientoYActualizarStock(
      movimiento,
      stockNuevo,
    );
  }

  @override
  Future<MovimientoInventario> registrarSalida({
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
    // Obtener item actual
    final item = await _datasource.fetchItemPorId(itemId);
    if (item == null) {
      throw ItemInventarioException(ErrorMessages.get('ERR_ITEM_NOT_FOUND'));
    }

    final stockAnterior = item.stockActual;

    // Validar stock suficiente
    if (stockAnterior < cantidad) {
      throw ItemInventarioException(
        ErrorMessages.format('ERR_INSUFFICIENT_STOCK', {
          'stock': '$stockAnterior',
          'unit': item.unidad.simbolo,
        }),
      );
    }

    final stockNuevo = (stockAnterior - cantidad).clamp(0.0, double.infinity);

    // Crear movimiento
    final movimiento = MovimientoInventario.salida(
      id: _uuid.v4(),
      itemId: itemId,
      granjaId: granjaId,
      tipo: tipo,
      cantidad: cantidad,
      stockAnterior: stockAnterior,
      registradoPor: registradoPor,
      motivo: motivo,
      referenciaId: referenciaId,
      referenciaTipo: referenciaTipo,
      loteId: loteId,
      observaciones: observaciones,
    );

    // Actualizar stock + guardar movimiento atómicamente
    return _datasource.registrarMovimientoYActualizarStock(
      movimiento,
      stockNuevo,
    );
  }

  @override
  Future<MovimientoInventario> ajustarStock({
    required String itemId,
    required String granjaId,
    required double nuevoStock,
    required String registradoPor,
    required String motivo,
  }) async {
    // Obtener item actual
    final item = await _datasource.fetchItemPorId(itemId);
    if (item == null) {
      throw ItemInventarioException(ErrorMessages.get('ERR_ITEM_NOT_FOUND'));
    }

    final stockAnterior = item.stockActual;
    final diferencia = nuevoStock - stockAnterior;

    // Determinar tipo de movimiento
    final tipo = diferencia >= 0
        ? TipoMovimiento.ajustePositivo
        : TipoMovimiento.ajusteNegativo;

    // Crear movimiento
    final movimiento = MovimientoInventario(
      id: _uuid.v4(),
      itemId: itemId,
      granjaId: granjaId,
      tipo: tipo,
      cantidad: diferencia.abs(),
      stockAnterior: stockAnterior,
      stockNuevo: nuevoStock,
      fecha: DateTime.now(),
      motivo: motivo,
      registradoPor: registradoPor,
      fechaRegistro: DateTime.now(),
    );

    // Actualizar stock + guardar movimiento atómicamente
    return _datasource.registrarMovimientoYActualizarStock(
      movimiento,
      nuevoStock,
    );
  }

  @override
  Stream<List<MovimientoInventario>> observarMovimientos(String itemId) {
    return _datasource.streamMovimientos(itemId);
  }

  // ==================== RESUMEN ====================

  @override
  Future<ResumenInventario> obtenerResumen(String granjaId) async {
    final items = await _datasource.fetchItems(granjaId);
    return ResumenInventario.fromItems(items);
  }

  @override
  Stream<ResumenInventario> observarResumen(String granjaId) {
    return _datasource.streamItems(granjaId).map((items) {
      return ResumenInventario.fromItems(items);
    });
  }

  // ==================== VALIDACIONES ====================

  @override
  Future<bool> hayStockSuficiente(String itemId, double cantidad) async {
    final stock = await obtenerStockActual(itemId);
    return stock >= cantidad;
  }

  @override
  Future<bool> verificarStockSuficiente(String itemId, double cantidad) {
    return hayStockSuficiente(itemId, cantidad);
  }

  @override
  Future<double> obtenerStockActual(String itemId) async {
    final item = await _datasource.fetchItemPorId(itemId);
    return item?.stockActual ?? 0;
  }
}
