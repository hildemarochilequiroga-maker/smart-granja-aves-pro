/// Servicio de compras in-app (Google Play Billing) para suscripciones.
///
/// Principio de seguridad: el cliente NUNCA decide el plan. Tras una compra,
/// el `purchaseToken` se envía a una Cloud Function que lo valida contra la
/// Google Play Developer API y escribe `suscripciones/{uid}`. El cliente solo
/// inicia el flujo y refleja el resultado validado por el servidor.
library;

import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../domain/enums/plan_suscripcion.dart';

/// Resultado de un intento de compra, ya resuelto de cara a la UI.
enum ResultadoCompra {
  /// Compra validada por el servidor; el plan se activará vía el stream.
  exito,

  /// El usuario canceló el flujo de pago.
  cancelada,

  /// Error en la compra o en la validación servidor.
  error,

  /// Las compras no están disponibles (Play no disponible / sin productos).
  noDisponible,
}

class BillingService {
  BillingService({
    InAppPurchase? iap,
    FirebaseFunctions? functions,
  })  : _iap = iap ?? InAppPurchase.instance,
        _functions = functions ?? FirebaseFunctions.instance;

  final InAppPurchase _iap;
  final FirebaseFunctions _functions;

  StreamSubscription<List<PurchaseDetails>>? _sub;
  final Map<String, ProductDetails> _productos = {};

  /// Completer del intento de compra en curso (para await del resultado).
  Completer<ResultadoCompra>? _compraEnCurso;

  bool _inicializado = false;

  /// Identificadores de producto que vendemos (planes de pago).
  static final Set<String> _productIds = {
    PlanSuscripcion.pro.playProductId!,
    PlanSuscripcion.plus.playProductId!,
  };

  /// Inicializa el servicio: verifica disponibilidad, carga productos y
  /// engancha el listener de compras. Idempotente.
  Future<bool> inicializar() async {
    if (_inicializado) return true;

    final disponible = await _iap.isAvailable();
    if (!disponible) {
      debugPrint('BillingService: Play Billing no disponible');
      return false;
    }

    _sub = _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onError: (Object e) => debugPrint('BillingService: error en stream: $e'),
    );

    final response = await _iap.queryProductDetails(_productIds);
    for (final p in response.productDetails) {
      _productos[p.id] = p;
    }
    if (response.error != null) {
      debugPrint('BillingService: error productos: ${response.error}');
    }

    _inicializado = true;
    return _productos.isNotEmpty;
  }

  /// Precio formateado por Google Play para [plan] (incluye moneda local),
  /// o `null` si el producto no está cargado.
  String? precioDe(PlanSuscripcion plan) {
    final id = plan.playProductId;
    if (id == null) return null;
    return _productos[id]?.price;
  }

  /// Inicia la compra del [plan]. Devuelve el resultado tras la validación
  /// servidor (o cancelación/error). Un único intento a la vez.
  Future<ResultadoCompra> comprar(PlanSuscripcion plan) async {
    if (!_inicializado) {
      final ok = await inicializar();
      if (!ok) return ResultadoCompra.noDisponible;
    }

    final id = plan.playProductId;
    if (id == null) return ResultadoCompra.error;

    final producto = _productos[id];
    if (producto == null) return ResultadoCompra.noDisponible;

    // Evitar compras concurrentes.
    if (_compraEnCurso != null && !_compraEnCurso!.isCompleted) {
      return ResultadoCompra.error;
    }
    _compraEnCurso = Completer<ResultadoCompra>();

    final param = PurchaseParam(productDetails: producto);
    try {
      // Las suscripciones se compran como non-consumable.
      await _iap.buyNonConsumable(purchaseParam: param);
    } on Exception catch (e) {
      debugPrint('BillingService: error al iniciar compra: $e');
      _completar(ResultadoCompra.error);
    }

    return _compraEnCurso!.future;
  }

  /// Restaura compras previas (p. ej. tras reinstalar). El resultado se
  /// refleja vía el stream y la posterior validación servidor.
  Future<void> restaurarCompras() async {
    if (!_inicializado) await inicializar();
    await _iap.restorePurchases();
  }

  /// Maneja las actualizaciones del stream de compras.
  Future<void> _onPurchaseUpdated(List<PurchaseDetails> compras) async {
    for (final compra in compras) {
      switch (compra.status) {
        case PurchaseStatus.pending:
          // En progreso: no hacemos nada, esperamos el estado final.
          break;
        case PurchaseStatus.canceled:
          _completar(ResultadoCompra.cancelada);
          await _finalizar(compra);
        case PurchaseStatus.error:
          debugPrint('BillingService: compra con error: ${compra.error}');
          _completar(ResultadoCompra.error);
          await _finalizar(compra);
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final ok = await _validarEnServidor(compra);
          _completar(ok ? ResultadoCompra.exito : ResultadoCompra.error);
          await _finalizar(compra);
      }
    }
  }

  /// Envía la compra a la Cloud Function de validación. El servidor valida
  /// contra Google Play y escribe la suscripción. Devuelve `true` si fue
  /// aceptada.
  Future<bool> _validarEnServidor(PurchaseDetails compra) async {
    try {
      final token =
          compra.verificationData.serverVerificationData;
      final productId = compra.productID;
      final callable = _functions.httpsCallable('validarCompraPlay');
      final result = await callable.call<Map<String, dynamic>>({
        'purchaseToken': token,
        'productId': productId,
      });
      final data = result.data;
      return data['valida'] == true;
    } on Exception catch (e) {
      debugPrint('BillingService: validación servidor falló: $e');
      return false;
    }
  }

  /// Confirma la entrega de la compra a Play (obligatorio para no reembolsar).
  Future<void> _finalizar(PurchaseDetails compra) async {
    if (compra.pendingCompletePurchase) {
      await _iap.completePurchase(compra);
    }
  }

  void _completar(ResultadoCompra resultado) {
    final c = _compraEnCurso;
    if (c != null && !c.isCompleted) {
      c.complete(resultado);
    }
  }

  /// Libera recursos.
  void dispose() {
    _sub?.cancel();
    _sub = null;
    _inicializado = false;
  }
}
