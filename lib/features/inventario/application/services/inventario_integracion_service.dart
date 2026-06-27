/// Servicio de integración entre el feature de Inventario y otros features.
///
/// Proporciona métodos para:
/// - Registrar entradas desde Costos (compras de alimento, medicamentos)
/// - Registrar salidas desde Consumo (uso de alimento en lotes)
/// - Registrar salidas desde Salud (uso de medicamentos/vacunas)
///
/// Cada método devuelve un [ResultadoIntegracion] explícito en vez de `null`:
/// el llamador sabe si la actualización de stock se completó, se omitió por una
/// razón de negocio, o se difirió para reintento. Ante un fallo transitorio
/// (red/Firestore), la integración se encola en `integraciones_pendientes` y la
/// reconcilia [InventarioReconciliador] más tarde, de modo que el inventario
/// nunca se desincroniza en silencio del dato primario (costo, consumo, etc.).
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_messages.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/value_objects/resultado_integracion.dart';
import '../../infrastructure/datasources/datasources.dart';
import '../../infrastructure/repositories/repositories.dart';

/// Provider del servicio de integración de inventario.
final inventarioIntegracionServiceProvider =
    Provider<InventarioIntegracionService>((ref) {
      final firestore = FirebaseFirestore.instance;
      final datasource = InventarioRemoteDatasourceImpl(firestore);
      final repository = InventarioRepositoryImpl(datasource);
      final pendientesDatasource = IntegracionPendienteDatasource(firestore);
      return InventarioIntegracionService(repository, pendientesDatasource);
    });

/// Excepción interna que marca un fallo de negocio NO reintentable dentro de
/// una integración (el reintento no lo resolvería; requiere acción del usuario).
class _FalloNegocioIntegracion implements Exception {
  const _FalloNegocioIntegracion(this.razon);
  final String razon;
}

/// Excepción interna que marca que la integración no aplicaba y debe omitirse
/// sin avisar como problema (p. ej. no se eligió ningún item).
class _OmitirIntegracion implements Exception {
  const _OmitirIntegracion(this.razon);
  final String razon;
}

/// Servicio para integrar el inventario con otros módulos del sistema.
class InventarioIntegracionService {
  InventarioIntegracionService(this._repository, this._pendientes);

  final InventarioRepository _repository;
  final IntegracionPendienteDatasource _pendientes;

  /// Cuando es `true` (durante [reejecutar]), un fallo transitorio NO encola una
  /// nueva pendiente: el reconciliador gestiona el contador de la existente.
  bool _enReconciliacion = false;

  // ===========================================================================
  // INTEGRACIÓN CON COSTOS
  // ===========================================================================

  /// Registra una entrada de inventario desde un registro de costo (compra de
  /// alimento, medicamento, etc.).
  Future<ResultadoIntegracion> registrarEntradaDesdeCosto({
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
  }) {
    return _ejecutarConReintento(
      granjaId: granjaId,
      tipo: TipoIntegracionPendiente.entradaDesdeCosto,
      parametros: {
        'granjaId': granjaId,
        'itemId': itemId,
        'tipoItem': tipoItem.toJson(),
        'nombreItem': nombreItem,
        'cantidad': cantidad,
        'unidad': unidad.toJson(),
        'costoTotal': costoTotal,
        'proveedor': proveedor,
        'numeroDocumento': numeroDocumento,
        'registradoPor': registradoPor,
        'costoId': costoId,
      },
      ejecutar: () async {
        final finalItemId = await _resolverItemId(
          granjaId: granjaId,
          itemId: itemId,
          nombreItem: nombreItem,
          // Para entradas: si el item no existe, se crea.
          crearSiNoExiste: () => ItemInventario(
            id: '',
            granjaId: granjaId,
            tipo: tipoItem,
            nombre: nombreItem ?? '',
            stockActual: 0,
            stockMinimo: 0,
            unidad: unidad,
            precioUnitario: cantidad > 0 ? costoTotal / cantidad : null,
            proveedor: proveedor,
            registradoPor: registradoPor,
            fechaCreacion: DateTime.now(),
            fechaActualizacion: DateTime.now(),
            activo: true,
          ),
        );

        return _repository.registrarEntrada(
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
      },
    );
  }

  // ===========================================================================
  // INTEGRACIÓN CON CONSUMO (LOTES)
  // ===========================================================================

  /// Registra una salida de inventario desde un registro de consumo de un lote.
  Future<ResultadoIntegracion> registrarSalidaDesdeConsumo({
    required String granjaId,
    String? itemId,
    String? nombreItem,
    required double cantidad,
    required String loteId,
    required String registradoPor,
    String? consumoId,
  }) {
    return _ejecutarConReintento(
      granjaId: granjaId,
      tipo: TipoIntegracionPendiente.salidaDesdeConsumo,
      parametros: {
        'granjaId': granjaId,
        'itemId': itemId,
        'nombreItem': nombreItem,
        'cantidad': cantidad,
        'loteId': loteId,
        'registradoPor': registradoPor,
        'consumoId': consumoId,
      },
      ejecutar: () async {
        final finalItemId = await _resolverItemId(
          granjaId: granjaId,
          itemId: itemId,
          nombreItem: nombreItem,
        );
        return _repository.registrarSalida(
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
      },
    );
  }

  // ===========================================================================
  // INTEGRACIÓN CON VENTAS
  // ===========================================================================

  /// Registra una salida de inventario desde una venta.
  Future<ResultadoIntegracion> registrarSalidaDesdeVenta({
    required String granjaId,
    String? itemId,
    String? nombreItem,
    required double cantidad,
    String? loteId,
    required String registradoPor,
    String? ventaId,
    String? tipoProducto,
  }) {
    return _ejecutarConReintento(
      granjaId: granjaId,
      tipo: TipoIntegracionPendiente.salidaDesdeVenta,
      parametros: {
        'granjaId': granjaId,
        'itemId': itemId,
        'nombreItem': nombreItem,
        'cantidad': cantidad,
        'loteId': loteId,
        'registradoPor': registradoPor,
        'ventaId': ventaId,
        'tipoProducto': tipoProducto,
      },
      ejecutar: () async {
        final finalItemId = await _resolverItemId(
          granjaId: granjaId,
          itemId: itemId,
          nombreItem: nombreItem,
        );
        return _repository.registrarSalida(
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
      },
    );
  }

  // ===========================================================================
  // INTEGRACIÓN CON SALUD
  // ===========================================================================

  /// Registra una salida de inventario desde un tratamiento (medicamento).
  Future<ResultadoIntegracion> registrarSalidaDesdeTratamiento({
    required String granjaId,
    String? itemId,
    String? nombreMedicamento,
    required double cantidad,
    required String loteId,
    required String registradoPor,
    String? tratamientoId,
  }) {
    return _ejecutarConReintento(
      granjaId: granjaId,
      tipo: TipoIntegracionPendiente.salidaDesdeTratamiento,
      parametros: {
        'granjaId': granjaId,
        'itemId': itemId,
        'nombreMedicamento': nombreMedicamento,
        'cantidad': cantidad,
        'loteId': loteId,
        'registradoPor': registradoPor,
        'tratamientoId': tratamientoId,
      },
      ejecutar: () async {
        final finalItemId = await _resolverItemId(
          granjaId: granjaId,
          itemId: itemId,
          nombreItem: nombreMedicamento,
          tipoEsperado: TipoItem.medicamento,
        );
        return _repository.registrarSalida(
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
      },
    );
  }

  /// Registra una salida de inventario desde una vacunación.
  Future<ResultadoIntegracion> registrarSalidaDesdeVacunacion({
    required String granjaId,
    String? itemId,
    String? nombreVacuna,
    required double dosis,
    required String loteId,
    required String registradoPor,
    String? vacunacionId,
  }) {
    return _ejecutarConReintento(
      granjaId: granjaId,
      tipo: TipoIntegracionPendiente.salidaDesdeVacunacion,
      parametros: {
        'granjaId': granjaId,
        'itemId': itemId,
        'nombreVacuna': nombreVacuna,
        'dosis': dosis,
        'loteId': loteId,
        'registradoPor': registradoPor,
        'vacunacionId': vacunacionId,
      },
      ejecutar: () async {
        final finalItemId = await _resolverItemId(
          granjaId: granjaId,
          itemId: itemId,
          nombreItem: nombreVacuna,
          tipoEsperado: TipoItem.vacuna,
        );
        return _repository.registrarSalida(
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
      },
    );
  }

  // ===========================================================================
  // INTEGRACIÓN CON DESINFECCIÓN DE GALPONES
  // ===========================================================================

  /// Registra una salida de inventario desde una desinfección de galpón.
  Future<ResultadoIntegracion> registrarSalidaDesdeDesinfeccion({
    required String granjaId,
    required String itemId,
    required double cantidad,
    required String galponId,
    required String registradoPor,
    String? desinfeccionId,
  }) {
    return _ejecutarConReintento(
      granjaId: granjaId,
      tipo: TipoIntegracionPendiente.salidaDesdeDesinfeccion,
      parametros: {
        'granjaId': granjaId,
        'itemId': itemId,
        'cantidad': cantidad,
        'galponId': galponId,
        'registradoPor': registradoPor,
        'desinfeccionId': desinfeccionId,
      },
      ejecutar: () async {
        if (itemId.isEmpty) {
          throw const _OmitirIntegracion('item no especificado');
        }
        return _repository.registrarSalida(
          itemId: itemId,
          granjaId: granjaId,
          tipo: TipoMovimiento.usoGeneral,
          cantidad: cantidad,
          registradoPor: registradoPor,
          motivo: ErrorMessages.get('MOTIVO_DESINFECCION'),
          referenciaId: desinfeccionId ?? galponId,
          referenciaTipo: 'desinfeccion',
        );
      },
    );
  }

  // ===========================================================================
  // RECONCILIACIÓN — reejecuta una integración encolada
  // ===========================================================================

  /// Re-ejecuta una integración pendiente a partir de sus parámetros
  /// serializados. Usado por [InventarioReconciliador]. Devuelve el resultado
  /// para que el reconciliador decida si eliminar la pendiente (éxito/omitido/
  /// negocio) o conservarla para otro intento (pendienteReintento).
  ///
  /// Durante la reconciliación NO se vuelve a encolar ante un fallo transitorio
  /// (evita duplicar la pendiente): el reconciliador gestiona el contador de
  /// intentos sobre el documento existente.
  Future<ResultadoIntegracion> reejecutar(IntegracionPendiente pendiente) {
    _enReconciliacion = true;
    return _reejecutar(pendiente).whenComplete(() {
      _enReconciliacion = false;
    });
  }

  Future<ResultadoIntegracion> _reejecutar(IntegracionPendiente pendiente) {
    final p = pendiente.parametros;
    double asDouble(Object? v) => (v as num?)?.toDouble() ?? 0;
    return switch (pendiente.tipo) {
      TipoIntegracionPendiente.entradaDesdeCosto => registrarEntradaDesdeCosto(
        granjaId: p['granjaId'] as String,
        itemId: p['itemId'] as String?,
        tipoItem: TipoItem.fromJson(p['tipoItem'] as String? ?? 'alimento'),
        nombreItem: p['nombreItem'] as String?,
        cantidad: asDouble(p['cantidad']),
        unidad: UnidadMedida.fromJson(p['unidad'] as String? ?? 'unidad'),
        costoTotal: asDouble(p['costoTotal']),
        proveedor: p['proveedor'] as String?,
        numeroDocumento: p['numeroDocumento'] as String?,
        registradoPor: p['registradoPor'] as String,
        costoId: p['costoId'] as String?,
      ),
      TipoIntegracionPendiente.salidaDesdeConsumo => registrarSalidaDesdeConsumo(
        granjaId: p['granjaId'] as String,
        itemId: p['itemId'] as String?,
        nombreItem: p['nombreItem'] as String?,
        cantidad: asDouble(p['cantidad']),
        loteId: p['loteId'] as String,
        registradoPor: p['registradoPor'] as String,
        consumoId: p['consumoId'] as String?,
      ),
      TipoIntegracionPendiente.salidaDesdeVenta => registrarSalidaDesdeVenta(
        granjaId: p['granjaId'] as String,
        itemId: p['itemId'] as String?,
        nombreItem: p['nombreItem'] as String?,
        cantidad: asDouble(p['cantidad']),
        loteId: p['loteId'] as String?,
        registradoPor: p['registradoPor'] as String,
        ventaId: p['ventaId'] as String?,
        tipoProducto: p['tipoProducto'] as String?,
      ),
      TipoIntegracionPendiente.salidaDesdeTratamiento =>
        registrarSalidaDesdeTratamiento(
          granjaId: p['granjaId'] as String,
          itemId: p['itemId'] as String?,
          nombreMedicamento: p['nombreMedicamento'] as String?,
          cantidad: asDouble(p['cantidad']),
          loteId: p['loteId'] as String,
          registradoPor: p['registradoPor'] as String,
          tratamientoId: p['tratamientoId'] as String?,
        ),
      TipoIntegracionPendiente.salidaDesdeVacunacion =>
        registrarSalidaDesdeVacunacion(
          granjaId: p['granjaId'] as String,
          itemId: p['itemId'] as String?,
          nombreVacuna: p['nombreVacuna'] as String?,
          dosis: asDouble(p['dosis']),
          loteId: p['loteId'] as String,
          registradoPor: p['registradoPor'] as String,
          vacunacionId: p['vacunacionId'] as String?,
        ),
      TipoIntegracionPendiente.salidaDesdeDesinfeccion =>
        registrarSalidaDesdeDesinfeccion(
          granjaId: p['granjaId'] as String,
          itemId: p['itemId'] as String? ?? '',
          cantidad: asDouble(p['cantidad']),
          galponId: p['galponId'] as String? ?? '',
          registradoPor: p['registradoPor'] as String,
          desinfeccionId: p['desinfeccionId'] as String?,
        ),
    };
  }

  // ===========================================================================
  // NÚCLEO — ejecución con clasificación de error y encolado de reintentos
  // ===========================================================================

  /// Ejecuta [ejecutar] y clasifica el desenlace:
  /// - éxito → [ResultadoIntegracion.exitoso].
  /// - [_OmitirIntegracion] → [ResultadoIntegracion.omitido] (no aplica).
  /// - [_FalloNegocioIntegracion] / [StockInsuficienteException] →
  ///   [ResultadoIntegracion.fallidoNegocio] (no se reintenta).
  /// - cualquier otra excepción (red/Firestore) → se encola una
  ///   [IntegracionPendiente] y se devuelve [ResultadoIntegracion.pendienteReintento].
  ///
  /// Cuando [encolarSiFallaTransitorio] es `false` (lo usa el reconciliador),
  /// los fallos transitorios NO se vuelven a encolar; el reconciliador maneja
  /// el contador de intentos sobre la pendiente existente.
  Future<ResultadoIntegracion> _ejecutarConReintento({
    required String granjaId,
    required TipoIntegracionPendiente tipo,
    required Map<String, dynamic> parametros,
    required Future<MovimientoInventario> Function() ejecutar,
    bool encolarSiFallaTransitorio = true,
  }) async {
    try {
      final movimiento = await ejecutar();
      return ResultadoIntegracion.exitoso(movimiento);
    } on _OmitirIntegracion catch (e) {
      return ResultadoIntegracion.omitido(e.razon);
    } on _FalloNegocioIntegracion catch (e) {
      return ResultadoIntegracion.fallidoNegocio(e.razon);
    } on StockInsuficienteException catch (e) {
      return ResultadoIntegracion.fallidoNegocio(
        ErrorMessages.format('STOCK_INSUFICIENTE_DETALLE', {
          'disponible': e.stockDisponible.toString(),
          'solicitado': e.solicitado.toString(),
        }),
      );
    } on Exception catch (e) {
      // Fallo transitorio (red/Firestore): encolar para reintento si procede.
      // Durante la reconciliación no se re-encola (la pendiente ya existe).
      if (encolarSiFallaTransitorio && !_enReconciliacion) {
        try {
          await _pendientes.encolar(
            IntegracionPendiente(
              id: '',
              granjaId: granjaId,
              tipo: tipo,
              parametros: parametros,
              creadoEn: DateTime.now(),
              ultimoError: e.toString(),
            ),
          );
        } on Exception catch (encolarError) {
          // Si incluso encolar falla, no perdemos el diagnóstico.
          debugPrint('No se pudo encolar integración pendiente: $encolarError');
        }
      }
      return ResultadoIntegracion.pendienteReintento(e.toString());
    }
  }

  /// Resuelve el `itemId` a usar: usa [itemId] si viene; si no, busca por
  /// [nombreItem]; si no existe y se da [crearSiNoExiste], crea el item.
  ///
  /// Lanza [_OmitirIntegracion] si no hay forma de resolver un item (no se dio
  /// itemId ni nombre, o no se encontró y no se permite crear): es una omisión
  /// intencional, no un error que deba reintentarse.
  Future<String> _resolverItemId({
    required String granjaId,
    String? itemId,
    String? nombreItem,
    TipoItem? tipoEsperado,
    ItemInventario Function()? crearSiNoExiste,
  }) async {
    if (itemId != null && itemId.isNotEmpty) return itemId;

    if (nombreItem != null && nombreItem.isNotEmpty) {
      final items = await _repository.buscarItems(granjaId, nombreItem);
      if (items.isNotEmpty) {
        final existente = items.firstWhere(
          (i) =>
              i.nombre.toLowerCase() == nombreItem.toLowerCase() &&
              (tipoEsperado == null || i.tipo == tipoEsperado),
          orElse: () => items.first,
        );
        return existente.id;
      }
      if (crearSiNoExiste != null) {
        final creado = await _repository.crearItem(crearSiNoExiste());
        return creado.id;
      }
    }

    throw const _OmitirIntegracion('no se encontró item de inventario');
  }

  // ===========================================================================
  // UTILIDADES
  // ===========================================================================

  /// Obtiene items de inventario disponibles para selección (dropdowns).
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
