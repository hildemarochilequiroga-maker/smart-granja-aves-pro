/// Repositorio para gestión de inventario.
library;

import '../entities/entities.dart';
import '../enums/enums.dart';

/// Interfaz del repositorio de inventario.
abstract class InventarioRepository {
  // ==================== ITEMS ====================

  /// Obtiene todos los items de una granja.
  Future<List<ItemInventario>> obtenerItems(String granjaId);

  /// Obtiene un item por ID.
  Future<ItemInventario?> obtenerItemPorId(String itemId);

  /// Obtiene items por tipo.
  Future<List<ItemInventario>> obtenerItemsPorTipo(
    String granjaId,
    TipoItem tipo,
  );

  /// Obtiene items con stock bajo.
  Future<List<ItemInventario>> obtenerItemsStockBajo(String granjaId);

  /// Obtiene items próximos a vencer.
  Future<List<ItemInventario>> obtenerItemsProximosVencer(
    String granjaId, {
    int diasLimite = 30,
  });

  /// Busca items por nombre o código.
  Future<List<ItemInventario>> buscarItems(String granjaId, String query);

  /// Crea un nuevo item.
  Future<ItemInventario> crearItem(ItemInventario item);

  /// Actualiza un item existente.
  Future<void> actualizarItem(ItemInventario item);

  /// Elimina un item (soft delete).
  Future<void> eliminarItem(String itemId);

  /// Stream de items de una granja.
  Stream<List<ItemInventario>> observarItems(String granjaId);

  /// Stream de items con alertas.
  Stream<List<ItemInventario>> observarItemsConAlertas(String granjaId);

  // ==================== MOVIMIENTOS ====================

  /// Obtiene movimientos de un item.
  Future<List<MovimientoInventario>> obtenerMovimientos(
    String itemId, {
    DateTime? desde,
    DateTime? hasta,
    int? limite,
  });

  /// Obtiene movimientos de una granja.
  Future<List<MovimientoInventario>> obtenerMovimientosGranja(
    String granjaId, {
    DateTime? desde,
    DateTime? hasta,
    TipoMovimiento? tipo,
    int? limite,
  });

  /// Registra un movimiento de entrada.
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
  });

  /// Registra un movimiento de salida.
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
  });

  /// Ajusta el stock de un item.
  Future<MovimientoInventario> ajustarStock({
    required String itemId,
    required String granjaId,
    required double nuevoStock,
    required String registradoPor,
    required String motivo,
  });

  /// Stream de movimientos de un item.
  Stream<List<MovimientoInventario>> observarMovimientos(String itemId);

  // ==================== RESUMEN ====================

  /// Obtiene el resumen de inventario de una granja.
  Future<ResumenInventario> obtenerResumen(String granjaId);

  /// Stream del resumen de inventario.
  Stream<ResumenInventario> observarResumen(String granjaId);

  // ==================== VALIDACIONES ====================

  /// Verifica si hay stock suficiente.
  Future<bool> hayStockSuficiente(String itemId, double cantidad);

  /// Verifica si hay stock suficiente (alias).
  Future<bool> verificarStockSuficiente(String itemId, double cantidad);

  /// Obtiene el stock actual de un item.
  Future<double> obtenerStockActual(String itemId);
}
