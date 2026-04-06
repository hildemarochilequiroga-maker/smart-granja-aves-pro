/// Servicio de integración Inventario → Costos.
///
/// Genera automáticamente registros de costos cuando:
/// - Se crea un item con stock inicial y precio
/// - Se registra una entrada (compra/reposición) con precio
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../costos/domain/entities/costo_gasto.dart';
import '../../../../core/errors/error_messages.dart';
import '../../../costos/domain/enums/tipo_gasto.dart';
import '../../../costos/domain/repositories/costo_repository.dart';
import '../../../costos/infrastructure/datasources/costo_remote_datasource_impl.dart';
import '../../../costos/infrastructure/repositories/costo_repository_impl.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';

/// Provider del servicio de integración Inventario → Costos.
final inventarioCostosServiceProvider = Provider<InventarioCostosService>((
  ref,
) {
  final datasource = ref.watch(costoRemoteDatasourceProvider);
  final repository = CostoRepositoryImpl(datasource);
  return InventarioCostosService(repository);
});

/// Servicio para generar costos automáticamente desde el inventario.
class InventarioCostosService {
  const InventarioCostosService(this._costoRepository);

  final CostoRepository _costoRepository;

  // ===========================================================================
  // MAPEO DE TIPOS
  // ===========================================================================

  /// Mapea un TipoItem de inventario a un TipoGasto de costos.
  TipoGasto mapearTipoItemATipoGasto(TipoItem tipoItem) {
    switch (tipoItem) {
      case TipoItem.alimento:
        return TipoGasto.alimento;
      case TipoItem.medicamento:
      case TipoItem.vacuna:
        return TipoGasto.medicamento;
      case TipoItem.equipo:
        return TipoGasto.mantenimiento;
      case TipoItem.limpieza:
        return TipoGasto.mantenimiento;
      case TipoItem.insumo:
      case TipoItem.otro:
        return TipoGasto.otros;
    }
  }

  /// Obtiene la categoría de costo según el tipo de item.
  String obtenerCategoria(TipoItem tipoItem) {
    switch (tipoItem) {
      case TipoItem.alimento:
        return ErrorMessages.get('CAT_ALIMENTACION');
      case TipoItem.medicamento:
      case TipoItem.vacuna:
        return ErrorMessages.get('CAT_SANIDAD');
      case TipoItem.equipo:
        return ErrorMessages.get('CAT_EQUIPAMIENTO');
      case TipoItem.limpieza:
        return ErrorMessages.get('CAT_LIMPIEZA');
      case TipoItem.insumo:
        return ErrorMessages.get('CAT_INSUMOS');
      case TipoItem.otro:
        return ErrorMessages.get('CAT_OTROS');
    }
  }

  // ===========================================================================
  // GENERACIÓN DE COSTOS
  // ===========================================================================

  /// Genera un costo automáticamente cuando se crea un item con stock inicial.
  ///
  /// Solo genera el costo si:
  /// - El stock actual es mayor a 0
  /// - El precio unitario está definido y es mayor a 0
  ///
  /// Retorna el costo creado o null si no se pudo crear.
  Future<CostoGasto?> generarCostoDesdeNuevoItem({
    required ItemInventario item,
    required String registradoPor,
    String? observaciones,
  }) async {
    // Validar que tenga stock y precio
    if (item.stockActual <= 0) {
      debugPrint('No se genera costo: stock actual es 0 o negativo');
      return null;
    }

    if (item.precioUnitario == null || item.precioUnitario! <= 0) {
      debugPrint('No se genera costo: precio unitario no definido');
      return null;
    }

    try {
      final montoTotal = item.stockActual * item.precioUnitario!;
      final tipoGasto = mapearTipoItemATipoGasto(item.tipo);
      final categoria = obtenerCategoria(item.tipo);

      final costo = CostoGasto.crear(
        id: const Uuid().v4(),
        granjaId: item.granjaId,
        tipo: tipoGasto,
        concepto: ErrorMessages.format('CONCEPTO_COMPRA_ITEM', {
          'item': item.nombre,
          'cantidad': '${item.stockActual}',
          'unidad': item.unidad.simbolo,
        }),
        monto: montoTotal,
        registradoPor: registradoPor,
        fecha: DateTime.now(),
        proveedor: item.proveedor,
        categoria: categoria,
        observaciones:
            observaciones ??
            ErrorMessages.format('OBS_AUTO_INVENTARIO', {
              'item': item.nombre,
              'cantidad': '${item.stockActual}',
              'unidad': item.unidad.simbolo,
              'precio': item.precioUnitario!.toStringAsFixed(2),
            }),
      );

      final costoGuardado = await _costoRepository.crear(costo);
      debugPrint('Costo generado exitosamente: ${costoGuardado.id}');
      return costoGuardado;
    } on Exception catch (e) {
      debugPrint('Error al generar costo desde item: $e');
      return null;
    }
  }

  /// Genera un costo automáticamente cuando se registra una entrada de inventario.
  ///
  /// Solo genera el costo si el movimiento tiene costo total definido.
  Future<CostoGasto?> generarCostoDesdeMovimientoEntrada({
    required MovimientoInventario movimiento,
    required ItemInventario item,
    required String registradoPor,
    String? observaciones,
  }) async {
    // Validar que tenga costo
    if (movimiento.costoTotal == null || movimiento.costoTotal! <= 0) {
      debugPrint('No se genera costo: movimiento sin costo total');
      return null;
    }

    // Solo para movimientos de entrada
    if (!movimiento.esEntrada) {
      debugPrint('No se genera costo: no es un movimiento de entrada');
      return null;
    }

    try {
      final tipoGasto = mapearTipoItemATipoGasto(item.tipo);
      final categoria = obtenerCategoria(item.tipo);

      final costo = CostoGasto.crear(
        id: const Uuid().v4(),
        granjaId: movimiento.granjaId,
        tipo: tipoGasto,
        concepto: ErrorMessages.format('CONCEPTO_MOVIMIENTO', {
          'tipo': movimiento.tipo.displayName,
          'item': item.nombre,
          'cantidad': '${movimiento.cantidad}',
          'unidad': item.unidad.simbolo,
        }),
        monto: movimiento.costoTotal!,
        registradoPor: registradoPor,
        fecha: movimiento.fecha,
        proveedor: movimiento.proveedor,
        categoria: categoria,
        numeroFactura: movimiento.numeroDocumento,
        observaciones:
            observaciones ??
            ErrorMessages.format('OBS_AUTO_MOVIMIENTO', {
              'motivo': movimiento.motivo ?? '',
            }),
      );

      final costoGuardado = await _costoRepository.crear(costo);
      debugPrint('Costo generado desde movimiento: ${costoGuardado.id}');
      return costoGuardado;
    } on Exception catch (e) {
      debugPrint('Error al generar costo desde movimiento: $e');
      return null;
    }
  }

  /// Verifica si se debe generar un costo para un item.
  bool debeGenerarCosto(ItemInventario item) {
    return item.stockActual > 0 &&
        item.precioUnitario != null &&
        item.precioUnitario! > 0;
  }

  /// Calcula el monto total de un item.
  double calcularMontoTotal(ItemInventario item) {
    if (item.precioUnitario == null) return 0;
    return item.stockActual * item.precioUnitario!;
  }
}
