/// Servicio de integración entre el feature de Inventario y otros features.
///
/// Proporciona métodos para:
/// - Registrar entradas desde Costos (compras de alimento, medicamentos)
/// - Registrar salidas desde Consumo (uso de alimento en lotes)
/// - Registrar salidas desde Salud (uso de medicamentos/vacunas)
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_messages.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../../domain/repositories/repositories.dart';
import '../../infrastructure/datasources/datasources.dart';
import '../../infrastructure/repositories/repositories.dart';

/// Provider del servicio de integración de inventario.
final inventarioIntegracionServiceProvider =
    Provider<InventarioIntegracionService>((ref) {
      final datasource = InventarioRemoteDatasourceImpl(
        FirebaseFirestore.instance,
      );
      final repository = InventarioRepositoryImpl(datasource);
      return InventarioIntegracionService(repository);
    });

/// Servicio para integrar el inventario con otros módulos del sistema.
class InventarioIntegracionService {
  const InventarioIntegracionService(this._repository);

  final InventarioRepository _repository;

  // ===========================================================================
  // INTEGRACIÓN CON COSTOS
  // ===========================================================================

  /// Registra una entrada de inventario desde un registro de costo.
  ///
  /// Utilizado cuando se registra una compra de alimento, medicamento, etc.
  /// en el módulo de Costos.
  ///
  /// Parámetros:
  /// - [granjaId]: ID de la granja.
  /// - [itemId]: ID del item de inventario (opcional si se crea nuevo).
  /// - [tipoItem]: Tipo de item (alimento, medicamento, etc.).
  /// - [nombreItem]: Nombre del item (usado si se crea nuevo).
  /// - [cantidad]: Cantidad comprada.
  /// - [unidad]: Unidad de medida.
  /// - [costoTotal]: Costo total de la compra.
  /// - [proveedor]: Proveedor (opcional).
  /// - [numeroDocumento]: Número de factura/documento (opcional).
  /// - [registradoPor]: ID del usuario que registra.
  /// - [costoId]: ID del registro de costo asociado.
  Future<MovimientoInventario?> registrarEntradaDesdeCosto({
    required String granjaId,
    String? itemId,
    required TipoItem tipoItem,
    String? nombreItem,
    required double cantidad,
    required UnidadMedida unidad,
    required double costoTotal,
    String? proveedor,
    String? numeroDocumento,
    required String registradoPor,
    String? costoId,
  }) async {
    try {
      String finalItemId = itemId ?? '';

      // Si no se proporcionó itemId, buscar item existente o crear uno nuevo
      if (finalItemId.isEmpty && nombreItem != null) {
        final items = await _repository.buscarItems(granjaId, nombreItem);
        final itemExistente = items.isNotEmpty
            ? items.firstWhere(
                (i) => i.nombre.toLowerCase() == nombreItem.toLowerCase(),
                orElse: () => items.first,
              )
            : null;

        if (itemExistente != null) {
          finalItemId = itemExistente.id;
        } else {
          // Crear nuevo item
          final nuevoItem = ItemInventario(
            id: '',
            granjaId: granjaId,
            tipo: tipoItem,
            nombre: nombreItem,
            stockActual: 0, // Se actualizará con el movimiento
            stockMinimo: 0,
            unidad: unidad,
            precioUnitario: cantidad > 0 ? costoTotal / cantidad : null,
            proveedor: proveedor,
            registradoPor: registradoPor,
            fechaCreacion: DateTime.now(),
            fechaActualizacion: DateTime.now(),
            activo: true,
          );

          final itemCreado = await _repository.crearItem(nuevoItem);
          finalItemId = itemCreado.id;
        }
      }

      if (finalItemId.isEmpty) {
        return null;
      }

      // Registrar el movimiento de entrada
      final movimiento = await _repository.registrarEntrada(
        itemId: finalItemId,
        granjaId: granjaId,
        tipo: TipoMovimiento.compra,
        cantidad: cantidad,
        registradoPor: registradoPor,
        motivo: ErrorMessages.get('MOTIVO_COMPRA_COSTOS'),
        proveedor: proveedor,
        costoTotal: costoTotal,
        numeroDocumento: numeroDocumento,
        referenciaId: costoId,
        referenciaTipo: 'costo',
      );

      return movimiento;
    } on Exception catch (e) {
      // Log error pero no propagamos la excepción para no bloquear el flujo de costos
      debugPrint('Error al registrar entrada en inventario: $e');
      return null;
    }
  }

  // ===========================================================================
  // INTEGRACIÓN CON CONSUMO (LOTES)
  // ===========================================================================

  /// Registra una salida de inventario desde un registro de consumo.
  ///
  /// Utilizado cuando se registra consumo de alimento en un lote.
  ///
  /// Parámetros:
  /// - [granjaId]: ID de la granja.
  /// - [itemId]: ID del item de inventario (opcional).
  /// - [nombreItem]: Nombre del item (usado para buscar si no se da itemId).
  /// - [cantidad]: Cantidad consumida.
  /// - [loteId]: ID del lote que consumió.
  /// - [registradoPor]: ID del usuario que registra.
  /// - [consumoId]: ID del registro de consumo asociado.
  Future<MovimientoInventario?> registrarSalidaDesdeConsumo({
    required String granjaId,
    String? itemId,
    String? nombreItem,
    required double cantidad,
    required String loteId,
    required String registradoPor,
    String? consumoId,
  }) async {
    try {
      String finalItemId = itemId ?? '';

      // Si no se proporcionó itemId, buscar item existente
      if (finalItemId.isEmpty && nombreItem != null) {
        final items = await _repository.buscarItems(granjaId, nombreItem);
        if (items.isNotEmpty) {
          final itemExistente = items.firstWhere(
            (i) => i.nombre.toLowerCase() == nombreItem.toLowerCase(),
            orElse: () => items.first,
          );
          finalItemId = itemExistente.id;
        }
      }

      if (finalItemId.isEmpty) {
        return null;
      }

      // Registrar el movimiento de salida
      final movimiento = await _repository.registrarSalida(
        itemId: finalItemId,
        granjaId: granjaId,
        tipo: TipoMovimiento.consumoLote,
        cantidad: cantidad,
        registradoPor: registradoPor,
        motivo: ErrorMessages.get('MOTIVO_CONSUMO_LOTE'),
        loteId: loteId,
        referenciaId: consumoId,
        referenciaTipo: 'consumo',
      );

      return movimiento;
    } on Exception catch (e) {
      debugPrint('Error al registrar salida en inventario: $e');
      return null;
    }
  }

  // ===========================================================================
  // INTEGRACIÓN CON VENTAS
  // ===========================================================================

  /// Registra una salida de inventario desde una venta.
  ///
  /// Utilizado cuando se registra una venta de huevos, pollinaza, etc.
  ///
  /// Parámetros:
  /// - [granjaId]: ID de la granja.
  /// - [itemId]: ID del item de inventario (opcional).
  /// - [nombreItem]: Nombre del producto vendido.
  /// - [cantidad]: Cantidad vendida.
  /// - [loteId]: ID del lote asociado (opcional).
  /// - [registradoPor]: ID del usuario que registra.
  /// - [ventaId]: ID del registro de venta asociado.
  /// - [tipoProducto]: Tipo de producto vendido (huevos, pollinaza, etc.).
  Future<MovimientoInventario?> registrarSalidaDesdeVenta({
    required String granjaId,
    String? itemId,
    String? nombreItem,
    required double cantidad,
    String? loteId,
    required String registradoPor,
    String? ventaId,
    String? tipoProducto,
  }) async {
    try {
      String finalItemId = itemId ?? '';

      if (finalItemId.isEmpty && nombreItem != null) {
        final items = await _repository.buscarItems(granjaId, nombreItem);
        if (items.isNotEmpty) {
          final itemExistente = items.firstWhere(
            (i) => i.nombre.toLowerCase() == nombreItem.toLowerCase(),
            orElse: () => items.first,
          );
          finalItemId = itemExistente.id;
        }
      }

      if (finalItemId.isEmpty) {
        debugPrint('No se encontró item de inventario para la venta');
        return null;
      }

      final movimiento = await _repository.registrarSalida(
        itemId: finalItemId,
        granjaId: granjaId,
        tipo: TipoMovimiento.venta,
        cantidad: cantidad,
        registradoPor: registradoPor,
        motivo: ErrorMessages.format('MOTIVO_VENTA', {
          'producto':
              tipoProducto ?? ErrorMessages.get('MOTIVO_FALLBACK_PRODUCTO'),
        }),
        loteId: loteId,
        referenciaId: ventaId,
        referenciaTipo: 'venta',
      );

      return movimiento;
    } on Exception catch (e) {
      debugPrint('Error al registrar salida por venta: $e');
      return null;
    }
  }

  // ===========================================================================
  // INTEGRACIÓN CON SALUD
  // ===========================================================================

  /// Registra una salida de inventario desde un tratamiento de salud.
  ///
  /// Utilizado cuando se aplica un medicamento a un lote.
  ///
  /// Parámetros:
  /// - [granjaId]: ID de la granja.
  /// - [itemId]: ID del item de inventario (opcional).
  /// - [nombreMedicamento]: Nombre del medicamento.
  /// - [cantidad]: Cantidad usada (dosis).
  /// - [loteId]: ID del lote tratado.
  /// - [registradoPor]: ID del usuario que registra.
  /// - [tratamientoId]: ID del registro de tratamiento asociado.
  Future<MovimientoInventario?> registrarSalidaDesdeTratamiento({
    required String granjaId,
    String? itemId,
    String? nombreMedicamento,
    required double cantidad,
    required String loteId,
    required String registradoPor,
    String? tratamientoId,
  }) async {
    try {
      String finalItemId = itemId ?? '';

      if (finalItemId.isEmpty && nombreMedicamento != null) {
        final items = await _repository.buscarItems(
          granjaId,
          nombreMedicamento,
        );
        if (items.isNotEmpty) {
          final itemExistente = items.firstWhere(
            (i) =>
                i.nombre.toLowerCase() == nombreMedicamento.toLowerCase() &&
                i.tipo == TipoItem.medicamento,
            orElse: () => items.first,
          );
          finalItemId = itemExistente.id;
        }
      }

      if (finalItemId.isEmpty) {
        return null;
      }

      final movimiento = await _repository.registrarSalida(
        itemId: finalItemId,
        granjaId: granjaId,
        tipo: TipoMovimiento.tratamiento,
        cantidad: cantidad,
        registradoPor: registradoPor,
        motivo: ErrorMessages.get('MOTIVO_TRATAMIENTO'),
        loteId: loteId,
        referenciaId: tratamientoId,
        referenciaTipo: 'tratamiento',
      );

      return movimiento;
    } on Exception catch (e) {
      debugPrint('Error al registrar salida por tratamiento: $e');
      return null;
    }
  }

  /// Registra una salida de inventario desde una vacunación.
  ///
  /// Utilizado cuando se aplica una vacuna a un lote.
  ///
  /// Parámetros:
  /// - [granjaId]: ID de la granja.
  /// - [itemId]: ID del item de inventario (opcional).
  /// - [nombreVacuna]: Nombre de la vacuna.
  /// - [dosis]: Cantidad de dosis aplicadas.
  /// - [loteId]: ID del lote vacunado.
  /// - [registradoPor]: ID del usuario que registra.
  /// - [vacunacionId]: ID del registro de vacunación asociado.
  Future<MovimientoInventario?> registrarSalidaDesdeVacunacion({
    required String granjaId,
    String? itemId,
    String? nombreVacuna,
    required double dosis,
    required String loteId,
    required String registradoPor,
    String? vacunacionId,
  }) async {
    try {
      String finalItemId = itemId ?? '';

      if (finalItemId.isEmpty && nombreVacuna != null) {
        final items = await _repository.buscarItems(granjaId, nombreVacuna);
        if (items.isNotEmpty) {
          final itemExistente = items.firstWhere(
            (i) =>
                i.nombre.toLowerCase() == nombreVacuna.toLowerCase() &&
                i.tipo == TipoItem.vacuna,
            orElse: () => items.first,
          );
          finalItemId = itemExistente.id;
        }
      }

      if (finalItemId.isEmpty) {
        return null;
      }

      final movimiento = await _repository.registrarSalida(
        itemId: finalItemId,
        granjaId: granjaId,
        tipo: TipoMovimiento.vacunacion,
        cantidad: dosis,
        registradoPor: registradoPor,
        motivo: ErrorMessages.get('MOTIVO_VACUNA'),
        loteId: loteId,
        referenciaId: vacunacionId,
        referenciaTipo: 'vacunacion',
      );

      return movimiento;
    } on Exception catch (e) {
      debugPrint('Error al registrar salida por vacunación: $e');
      return null;
    }
  }

  // ===========================================================================
  // INTEGRACIÓN CON DESINFECCIÓN DE GALPONES
  // ===========================================================================

  /// Registra una salida de inventario desde un registro de desinfección.
  ///
  /// Utilizado cuando se registra una desinfección de galpón y se usaron
  /// productos de limpieza/desinfección del inventario.
  ///
  /// Parámetros:
  /// - [granjaId]: ID de la granja.
  /// - [itemId]: ID del item de inventario.
  /// - [cantidad]: Cantidad utilizada.
  /// - [galponId]: ID del galpón desinfectado.
  /// - [registradoPor]: ID del usuario que registra.
  /// - [desinfeccionId]: ID del registro de desinfección (opcional).
  Future<MovimientoInventario?> registrarSalidaDesdeDesinfeccion({
    required String granjaId,
    required String itemId,
    required double cantidad,
    required String galponId,
    required String registradoPor,
    String? desinfeccionId,
  }) async {
    try {
      final movimiento = await _repository.registrarSalida(
        itemId: itemId,
        granjaId: granjaId,
        tipo: TipoMovimiento.usoGeneral,
        cantidad: cantidad,
        registradoPor: registradoPor,
        motivo: ErrorMessages.get('MOTIVO_DESINFECCION'),
        referenciaId: desinfeccionId ?? galponId,
        referenciaTipo: 'desinfeccion',
      );

      return movimiento;
    } on Exception catch (e) {
      debugPrint('Error al registrar salida por desinfección: $e');
      return null;
    }
  }

  // ===========================================================================
  // UTILIDADES
  // ===========================================================================

  /// Obtiene items de inventario disponibles para selección.
  ///
  /// Útil para mostrar en dropdowns de selección de items.
  Future<List<ItemInventario>> obtenerItemsParaSeleccion(
    String granjaId, {
    TipoItem? tipo,
  }) async {
    if (tipo != null) {
      return _repository.obtenerItemsPorTipo(granjaId, tipo);
    }
    return _repository.obtenerItems(granjaId);
  }

  /// Verifica si hay stock suficiente para una salida.
  Future<bool> verificarStockDisponible(String itemId, double cantidad) async {
    return _repository.verificarStockSuficiente(itemId, cantidad);
  }

  /// Obtiene el stock actual de un item.
  Future<double?> obtenerStockActual(String itemId) async {
    final item = await _repository.obtenerItemPorId(itemId);
    return item?.stockActual;
  }
}
