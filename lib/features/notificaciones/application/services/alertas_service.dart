/// Servicio de alertas automáticas.
///
/// Monitorea eventos en la granja y genera notificaciones automáticas.
/// Soporta 77 tipos de notificaciones organizadas por categoría.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/error_messages.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../granjas/domain/enums/rol_granja_enum.dart';
import '../../domain/entities/notificacion.dart';
import '../../domain/enums/tipo_notificacion.dart';
import '../../domain/enums/prioridad_notificacion.dart';
import '../../infrastructure/repositories/notificaciones_repository.dart';
import '../services/notification_service.dart';

/// Servicio para generar alertas automáticas.
class AlertasService {
  AlertasService({
    FirebaseFirestore? firestore,
    NotificacionesRepository? notificacionesRepository,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _notificacionesRepo =
           notificacionesRepository ?? NotificacionesRepository();

  final FirebaseFirestore _firestore;
  final NotificacionesRepository _notificacionesRepo;

  // ============================================================
  // INVENTARIO
  // ============================================================

  /// Verifica y genera alertas de stock bajo.
  Future<void> verificarStockBajo(String granjaId) async {
    try {
      final snapshot = await _firestore
          .collection('granjas')
          .doc(granjaId)
          .collection('inventario')
          .where('activo', isEqualTo: true)
          .get();

      final itemsStockBajo = snapshot.docs.where((doc) {
        final data = doc.data();
        final stockActual = (data['stockActual'] ?? 0).toDouble();
        final stockMinimo = (data['stockMinimo'] ?? 0).toDouble();
        return stockActual <= stockMinimo && stockActual > 0;
      }).toList();

      final itemsAgotados = snapshot.docs.where((doc) {
        final data = doc.data();
        final stockActual = (data['stockActual'] ?? 0).toDouble();
        return stockActual <= 0;
      }).toList();

      if (itemsStockBajo.isEmpty && itemsAgotados.isEmpty) return;

      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);

      final granjaName = await _getGranjaName(granjaId);

      // Stock bajo
      for (final itemDoc in itemsStockBajo) {
        final data = itemDoc.data();
        final nombreItem = data['nombre'] ?? 'Producto';
        final stockActual = (data['stockActual'] ?? 0).toDouble();
        final unidad = data['unidad']?['simbolo'] ?? 'unid';

        await _crearNotificacion(
          usuarioIds: usuariosNotificar,
          tipo: TipoNotificacion.stockBajo,
          titulo: ErrorMessages.format('ALERT_STOCK_BAJO', {
            'item': nombreItem,
          }),
          mensaje: ErrorMessages.format('ALERT_STOCK_BAJO_MSG', {
            'cantidad': stockActual.toStringAsFixed(1),
            'unidad': unidad,
          }),
          granjaId: granjaId,
          granjaName: granjaName,
          prioridad: PrioridadNotificacion.alta,
          data: {
            'itemId': itemDoc.id,
            'itemNombre': nombreItem,
            'stockActual': stockActual,
          },
          accionUrl: AppRoutes.inventarioPorGranjaId(granjaId),
        );
      }

      // Stock agotado
      for (final itemDoc in itemsAgotados) {
        final data = itemDoc.data();
        final nombreItem = data['nombre'] ?? 'Producto';

        await _crearNotificacion(
          usuarioIds: usuariosNotificar,
          tipo: TipoNotificacion.stockAgotado,
          titulo: ErrorMessages.format('ALERT_AGOTADO', {'item': nombreItem}),
          mensaje: ErrorMessages.get('ALERT_AGOTADO_MSG'),
          granjaId: granjaId,
          granjaName: granjaName,
          prioridad: PrioridadNotificacion.urgente,
          data: {'itemId': itemDoc.id, 'itemNombre': nombreItem},
          accionUrl: AppRoutes.inventarioPorGranjaId(granjaId),
        );
      }

      debugPrint(
        '✅ Alertas inventario: ${itemsStockBajo.length + itemsAgotados.length}',
      );
    } on Exception catch (e) {
      debugPrint('Error verificando stock: $e');
    }
  }

  /// Verifica productos próximos a vencer y vencidos.
  Future<void> verificarVencimientos(String granjaId) async {
    try {
      final ahora = DateTime.now();

      final snapshot = await _firestore
          .collection('granjas')
          .doc(granjaId)
          .collection('inventario')
          .where('activo', isEqualTo: true)
          .get();

      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
      ]);

      final granjaName = await _getGranjaName(granjaId);

      for (final doc in snapshot.docs) {
        final data = doc.data();
        if (data['fechaVencimiento'] == null) continue;

        final fechaVenc = (data['fechaVencimiento'] as Timestamp).toDate();
        final nombreItem = data['nombre'] ?? 'Producto';
        final diasRestantes = fechaVenc.difference(ahora).inDays;

        // Vencido
        if (diasRestantes < 0) {
          await _crearNotificacion(
            usuarioIds: usuariosNotificar,
            tipo: TipoNotificacion.productoVencido,
            titulo: ErrorMessages.format('ALERT_VENCIDO', {'item': nombreItem}),
            mensaje: ErrorMessages.format('ALERT_VENCIDO_MSG', {
              'dias': '${diasRestantes.abs()}',
            }),
            granjaId: granjaId,
            granjaName: granjaName,
            prioridad: PrioridadNotificacion.urgente,
            data: {
              'itemId': doc.id,
              'fechaVencimiento': fechaVenc.toIso8601String(),
            },
            accionUrl: AppRoutes.inventarioPorGranjaId(granjaId),
          );
        }
        // Próximo a vencer
        else if (diasRestantes <= 7 && diasRestantes >= 0) {
          await _crearNotificacion(
            usuarioIds: usuariosNotificar,
            tipo: TipoNotificacion.proximoVencer,
            titulo: ErrorMessages.format('ALERT_PROXIMO_VENCER', {
              'item': nombreItem,
            }),
            mensaje: diasRestantes == 0
                ? ErrorMessages.get('ALERT_VENCE_HOY')
                : ErrorMessages.format('ALERT_VENCE_EN_DIAS', {
                    'dias': '$diasRestantes',
                  }),
            granjaId: granjaId,
            granjaName: granjaName,
            prioridad: diasRestantes <= 3
                ? PrioridadNotificacion.alta
                : PrioridadNotificacion.normal,
            data: {
              'itemId': doc.id,
              'fechaVencimiento': fechaVenc.toIso8601String(),
              'diasRestantes': diasRestantes,
            },
            accionUrl: AppRoutes.inventarioPorGranjaId(granjaId),
          );
        }
      }
    } on Exception catch (e) {
      debugPrint('Error verificando vencimientos: $e');
    }
  }

  /// Notifica reabastecimiento de inventario.
  Future<void> notificarReabastecimiento({
    required String granjaId,
    required String itemId,
    required String itemNombre,
    required double cantidadAgregada,
    required String unidad,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.stockReabastecido,
        titulo: ErrorMessages.format('ALERT_REABASTECIDO', {
          'item': itemNombre,
        }),
        mensaje: ErrorMessages.format('ALERT_REABASTECIDO_MSG', {
          'cantidad': cantidadAgregada.toStringAsFixed(1),
          'unidad': unidad,
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.baja,
        data: {'itemId': itemId, 'cantidadAgregada': cantidadAgregada},
        accionUrl: AppRoutes.inventarioPorGranjaId(granjaId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando reabastecimiento: $e');
    }
  }

  /// Notifica movimiento de inventario.
  Future<void> notificarMovimientoInventario({
    required String granjaId,
    required String itemNombre,
    required String tipoMovimiento,
    required double cantidad,
    required String unidad,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.movimientoInventario,
        titulo: ErrorMessages.format('ALERT_MOVIMIENTO', {
          'tipo': tipoMovimiento,
          'item': itemNombre,
        }),
        mensaje: ErrorMessages.format('ALERT_MOVIMIENTO_MSG', {
          'cantidad': cantidad.toStringAsFixed(1),
          'unidad': unidad,
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.baja,
        data: {
          'itemNombre': itemNombre,
          'tipoMovimiento': tipoMovimiento,
          'cantidad': cantidad,
        },
        accionUrl: AppRoutes.inventarioPorGranjaId(granjaId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando movimiento: $e');
    }
  }

  // ============================================================
  // LOTES
  // ============================================================

  /// Verifica mortalidad alta en un lote.
  Future<void> verificarMortalidadAlta({
    required String granjaId,
    required String loteId,
    required int cantidadMuertos,
    required int cantidadTotal,
  }) async {
    try {
      final porcentaje = (cantidadMuertos / cantidadTotal) * 100;
      if (porcentaje <= 2) return;

      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);

      final granjaName = await _getGranjaName(granjaId);
      final loteNombre = await _getLoteNombre(granjaId, loteId);

      final esCritica = porcentaje > 5;

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: esCritica
            ? TipoNotificacion.mortalidadCritica
            : TipoNotificacion.mortalidadAlta,
        titulo: esCritica
            ? ErrorMessages.format('ALERT_MORTALIDAD_CRITICA', {
                'lote': loteNombre,
              })
            : ErrorMessages.format('ALERT_MORTALIDAD_ALTA', {
                'lote': loteNombre,
              }),
        mensaje: ErrorMessages.format('ALERT_MORTALIDAD_MSG', {
          'porcentaje': porcentaje.toStringAsFixed(1),
          'cantidad': '$cantidadMuertos',
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: esCritica
            ? PrioridadNotificacion.urgente
            : PrioridadNotificacion.alta,
        data: {
          'loteId': loteId,
          'loteNombre': loteNombre,
          'cantidadMuertos': cantidadMuertos,
          'porcentaje': porcentaje,
        },
        accionUrl: AppRoutes.loteDashboardById(granjaId, loteId),
      );

      debugPrint('✅ Alerta mortalidad generada');
    } on Exception catch (e) {
      debugPrint('Error verificando mortalidad: $e');
    }
  }

  /// Notifica que se registró mortalidad (siempre, sin importar porcentaje).
  Future<void> notificarMortalidadRegistrada({
    required String granjaId,
    required String loteId,
    required int cantidadMuertos,
    required int mortalidadAcumulada,
    required int cantidadTotal,
    required String causa,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);

      if (usuariosNotificar.isEmpty) {
        debugPrint('⚠️ No hay usuarios para notificar mortalidad registrada');
        return;
      }

      final granjaName = await _getGranjaName(granjaId);
      final loteNombre = await _getLoteNombre(granjaId, loteId);
      final porcentaje = cantidadTotal > 0
          ? (mortalidadAcumulada / cantidadTotal) * 100
          : 0.0;

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.mortalidadRegistrada,
        titulo: ErrorMessages.format('ALERT_MORTALIDAD_REG', {
          'lote': loteNombre,
        }),
        mensaje: ErrorMessages.format('ALERT_MORTALIDAD_REG_MSG', {
          'cantidad': '$cantidadMuertos',
          'causa': causa,
          'porcentaje': porcentaje.toStringAsFixed(1),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.normal,
        data: {
          'loteId': loteId,
          'loteNombre': loteNombre,
          'cantidadMuertos': cantidadMuertos,
          'mortalidadAcumulada': mortalidadAcumulada,
          'porcentaje': porcentaje,
          'causa': causa,
        },
        accionUrl: AppRoutes.loteDashboardById(granjaId, loteId),
      );

      debugPrint('✅ Notificación mortalidad registrada enviada');
    } on Exception catch (e) {
      debugPrint('Error notificando mortalidad registrada: $e');
    }
  }

  /// Notifica creación de nuevo lote.
  Future<void> notificarLoteCreado({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required int cantidadAves,
    required String galponNombre,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
        RolGranja.operator,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.loteCreado,
        titulo: ErrorMessages.format('ALERT_NUEVO_LOTE', {'lote': loteNombre}),
        mensaje: ErrorMessages.format('ALERT_NUEVO_LOTE_MSG', {
          'cantidad': '$cantidadAves',
          'galpon': galponNombre,
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.normal,
        data: {
          'loteId': loteId,
          'loteNombre': loteNombre,
          'cantidadAves': cantidadAves,
          'galponNombre': galponNombre,
        },
        accionUrl: AppRoutes.loteDashboardById(granjaId, loteId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando lote creado: $e');
    }
  }

  /// Notifica finalización de lote.
  Future<void> notificarLoteFinalizado({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required int diasCiclo,
    String? motivo,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.loteFinalizado,
        titulo: ErrorMessages.format('ALERT_LOTE_FINALIZADO', {
          'lote': loteNombre,
        }),
        mensaje:
            '${ErrorMessages.format('ALERT_LOTE_FINALIZADO_MSG', {'dias': '$diasCiclo'})}${motivo != null ? ' - $motivo' : ''}',
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.normal,
        data: {
          'loteId': loteId,
          'loteNombre': loteNombre,
          'diasCiclo': diasCiclo,
          'motivo': motivo,
        },
        accionUrl: AppRoutes.loteDashboardById(granjaId, loteId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando lote finalizado: $e');
    }
  }

  /// Notifica peso bajo del objetivo.
  Future<void> notificarPesoBajoObjetivo({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required double pesoActual,
    required double pesoObjetivo,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);
      final diferencia = ((pesoActual / pesoObjetivo) * 100 - 100).abs();

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.pesoBajoObjetivo,
        titulo: ErrorMessages.format('ALERT_PESO_BAJO', {'lote': loteNombre}),
        mensaje: ErrorMessages.format('ALERT_PESO_BAJO_MSG', {
          'peso': pesoActual.toStringAsFixed(0),
          'diferencia': diferencia.toStringAsFixed(1),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: diferencia > 10
            ? PrioridadNotificacion.alta
            : PrioridadNotificacion.normal,
        data: {
          'loteId': loteId,
          'pesoActual': pesoActual,
          'pesoObjetivo': pesoObjetivo,
          'diferenciaPorcentaje': diferencia,
        },
        accionUrl: AppRoutes.loteDashboardById(granjaId, loteId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando peso bajo: $e');
    }
  }

  /// Verifica lotes próximos a cerrar.
  Future<void> verificarLotesCierreProximo(String granjaId) async {
    try {
      final ahora = DateTime.now();

      final snapshot = await _firestore
          .collection('granjas')
          .doc(granjaId)
          .collection('lotes')
          .where('estado', isEqualTo: 'activo')
          .get();

      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      for (final doc in snapshot.docs) {
        final data = doc.data();
        if (data['fechaCierreEstimada'] == null) continue;

        final fechaCierre = (data['fechaCierreEstimada'] as Timestamp).toDate();
        final diasRestantes = fechaCierre.difference(ahora).inDays;

        if (diasRestantes <= 7 && diasRestantes >= 0) {
          final loteNombre = data['nombre'] ?? 'Lote';

          await _crearNotificacion(
            usuarioIds: usuariosNotificar,
            tipo: TipoNotificacion.loteCierreProximo,
            titulo: ErrorMessages.format('ALERT_CIERRE_PROXIMO', {
              'lote': loteNombre,
            }),
            mensaje: diasRestantes == 0
                ? ErrorMessages.get('ALERT_CIERRE_HOY')
                : ErrorMessages.format('ALERT_CIERRE_EN_DIAS', {
                    'dias': '$diasRestantes',
                  }),
            granjaId: granjaId,
            granjaName: granjaName,
            prioridad: diasRestantes <= 3
                ? PrioridadNotificacion.alta
                : PrioridadNotificacion.normal,
            data: {
              'loteId': doc.id,
              'loteNombre': loteNombre,
              'fechaCierre': fechaCierre.toIso8601String(),
              'diasRestantes': diasRestantes,
            },
            accionUrl: AppRoutes.loteDashboardById(granjaId, doc.id),
          );
        }
      }
    } on Exception catch (e) {
      debugPrint('Error verificando cierres: $e');
    }
  }

  /// Notifica conversión alimenticia anormal.
  Future<void> notificarConversionAnormal({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required double conversionActual,
    required double conversionEsperada,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.conversionAnormal,
        titulo: ErrorMessages.format('ALERT_CONVERSION_ANORMAL', {
          'lote': loteNombre,
        }),
        mensaje: ErrorMessages.format('ALERT_CONVERSION_MSG', {
          'actual': conversionActual.toStringAsFixed(2),
          'esperado': conversionEsperada.toStringAsFixed(2),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.alta,
        data: {
          'loteId': loteId,
          'conversionActual': conversionActual,
          'conversionEsperada': conversionEsperada,
        },
        accionUrl: AppRoutes.loteDashboardById(granjaId, loteId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando conversión: $e');
    }
  }

  /// Verifica lotes sin registros recientes.
  Future<void> verificarLotesSinRegistros(String granjaId) async {
    try {
      final hace3Dias = DateTime.now().subtract(const Duration(days: 3));

      final lotesSnapshot = await _firestore
          .collection('granjas')
          .doc(granjaId)
          .collection('lotes')
          .where('estado', isEqualTo: 'activo')
          .get();

      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      for (final loteDoc in lotesSnapshot.docs) {
        final loteId = loteDoc.id;
        final loteNombre = loteDoc.data()['nombre'] ?? 'Lote';

        // Verificar último registro
        final ultimoRegistro = await _firestore
            .collection('granjas')
            .doc(granjaId)
            .collection('lotes')
            .doc(loteId)
            .collection('registros_diarios')
            .orderBy('fecha', descending: true)
            .limit(1)
            .get();

        if (ultimoRegistro.docs.isEmpty) continue;

        final fechaUltimo =
            (ultimoRegistro.docs.first.data()['fecha'] as Timestamp).toDate();

        if (fechaUltimo.isBefore(hace3Dias)) {
          final diasSinRegistro = DateTime.now().difference(fechaUltimo).inDays;

          await _crearNotificacion(
            usuarioIds: usuariosNotificar,
            tipo: TipoNotificacion.loteSinRegistros,
            titulo: ErrorMessages.format('ALERT_SIN_REGISTROS', {
              'lote': loteNombre,
            }),
            mensaje: ErrorMessages.format('ALERT_SIN_REGISTROS_MSG', {
              'dias': '$diasSinRegistro',
            }),
            granjaId: granjaId,
            granjaName: granjaName,
            prioridad: diasSinRegistro > 5
                ? PrioridadNotificacion.alta
                : PrioridadNotificacion.normal,
            data: {
              'loteId': loteId,
              'loteNombre': loteNombre,
              'diasSinRegistro': diasSinRegistro,
            },
            accionUrl: AppRoutes.loteDashboardById(granjaId, loteId),
          );
        }
      }
    } on Exception catch (e) {
      debugPrint('Error verificando registros: $e');
    }
  }

  // ============================================================
  // PRODUCCIÓN
  // ============================================================

  /// Notifica producción registrada.
  Future<void> notificarProduccionRegistrada({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required int cantidadHuevos,
    required double porcentajeProduccion,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.produccionRegistrada,
        titulo: ErrorMessages.format('ALERT_PRODUCCION', {'lote': loteNombre}),
        mensaje: ErrorMessages.format('ALERT_PRODUCCION_MSG', {
          'cantidad': '$cantidadHuevos',
          'porcentaje': porcentajeProduccion.toStringAsFixed(1),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.baja,
        data: {
          'loteId': loteId,
          'cantidadHuevos': cantidadHuevos,
          'porcentajeProduccion': porcentajeProduccion,
        },
        accionUrl: AppRoutes.loteDashboardById(granjaId, loteId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando producción: $e');
    }
  }

  /// Notifica producción baja.
  Future<void> notificarProduccionBaja({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required double porcentajeActual,
    required double porcentajeEsperado,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.produccionBaja,
        titulo: ErrorMessages.format('ALERT_PRODUCCION_BAJA', {
          'lote': loteNombre,
        }),
        mensaje: ErrorMessages.format('ALERT_PRODUCCION_BAJA_MSG', {
          'actual': porcentajeActual.toStringAsFixed(1),
          'esperado': porcentajeEsperado.toStringAsFixed(1),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.alta,
        data: {
          'loteId': loteId,
          'porcentajeActual': porcentajeActual,
          'porcentajeEsperado': porcentajeEsperado,
        },
        accionUrl: AppRoutes.loteDashboardById(granjaId, loteId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando producción baja: $e');
    }
  }

  /// Notifica caída brusca de producción.
  Future<void> notificarCaidaProduccion({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required double porcentajeAnterior,
    required double porcentajeActual,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);
      final caida = porcentajeAnterior - porcentajeActual;

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.produccionCaida,
        titulo: ErrorMessages.format('ALERT_CAIDA_PRODUCCION', {
          'lote': loteNombre,
        }),
        mensaje: ErrorMessages.format('ALERT_CAIDA_MSG', {
          'caida': caida.toStringAsFixed(1),
          'anterior': porcentajeAnterior.toStringAsFixed(1),
          'actual': porcentajeActual.toStringAsFixed(1),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.urgente,
        data: {
          'loteId': loteId,
          'porcentajeAnterior': porcentajeAnterior,
          'porcentajeActual': porcentajeActual,
          'caida': caida,
        },
        accionUrl: AppRoutes.loteDashboardById(granjaId, loteId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando caída: $e');
    }
  }

  /// Notifica primer huevo del lote.
  Future<void> notificarPrimerHuevo({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required int edadSemanas,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
        RolGranja.operator,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.primerHuevo,
        titulo: ErrorMessages.format('ALERT_PRIMER_HUEVO', {
          'lote': loteNombre,
        }),
        mensaje: ErrorMessages.format('ALERT_PRIMER_HUEVO_MSG', {
          'semanas': '$edadSemanas',
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.normal,
        data: {'loteId': loteId, 'edadSemanas': edadSemanas},
        accionUrl: AppRoutes.loteDashboardById(granjaId, loteId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando primer huevo: $e');
    }
  }

  /// Notifica récord de producción.
  Future<void> notificarRecordProduccion({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required int cantidadHuevos,
    required double porcentaje,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
        RolGranja.operator,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.recordProduccion,
        titulo: ErrorMessages.format('ALERT_RECORD', {'lote': loteNombre}),
        mensaje: ErrorMessages.format('ALERT_RECORD_MSG', {
          'cantidad': '$cantidadHuevos',
          'porcentaje': porcentaje.toStringAsFixed(1),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.normal,
        data: {
          'loteId': loteId,
          'cantidadHuevos': cantidadHuevos,
          'porcentaje': porcentaje,
        },
        accionUrl: AppRoutes.loteDashboardById(granjaId, loteId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando récord: $e');
    }
  }

  /// Notifica meta de producción alcanzada.
  Future<void> notificarMetaProduccion({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required int totalAcumulado,
    required int meta,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.metaProduccionAlcanzada,
        titulo: ErrorMessages.format('ALERT_META', {'lote': loteNombre}),
        mensaje: ErrorMessages.format('ALERT_META_MSG', {
          'total': '$totalAcumulado',
          'meta': '$meta',
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.normal,
        data: {
          'loteId': loteId,
          'totalAcumulado': totalAcumulado,
          'meta': meta,
        },
        accionUrl: AppRoutes.loteDashboardById(granjaId, loteId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando meta: $e');
    }
  }

  // ============================================================
  // SALUD / VACUNACIONES
  // ============================================================

  /// Verifica vacunaciones próximas.
  Future<void> verificarVacunacionesProgramadas(String granjaId) async {
    try {
      final ahora = DateTime.now();
      final hoy = DateTime(ahora.year, ahora.month, ahora.day);
      final manana = hoy.add(const Duration(days: 1));
      final en7Dias = hoy.add(const Duration(days: 7));

      final snapshot = await _firestore
          .collection('granjas')
          .doc(granjaId)
          .collection('vacunaciones_programadas')
          .where('aplicada', isEqualTo: false)
          .get();

      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final fechaProgramada = (data['fechaProgramada'] as Timestamp).toDate();
        final vacunaNombre = data['vacunaNombre'] ?? 'Vacuna';
        final loteNombre = data['loteNombre'] ?? 'Lote';

        final fechaSinHora = DateTime(
          fechaProgramada.year,
          fechaProgramada.month,
          fechaProgramada.day,
        );

        TipoNotificacion tipo;
        String titulo;
        String mensaje;
        PrioridadNotificacion prioridad;

        if (fechaSinHora.isBefore(hoy)) {
          // Vencida
          tipo = TipoNotificacion.vacunacionVencida;
          titulo = ErrorMessages.get('ALERT_VAC_VENCIDA');
          mensaje = ErrorMessages.format('ALERT_VAC_VENCIDA_MSG', {
            'vacuna': vacunaNombre,
            'lote': loteNombre,
          });
          prioridad = PrioridadNotificacion.urgente;
        } else if (fechaSinHora.isAtSameMomentAs(hoy)) {
          // Hoy
          tipo = TipoNotificacion.vacunacionHoy;
          titulo = ErrorMessages.get('ALERT_VAC_HOY');
          mensaje = ErrorMessages.format('ALERT_VAC_PARA_LOTE', {
            'vacuna': vacunaNombre,
            'lote': loteNombre,
          });
          prioridad = PrioridadNotificacion.urgente;
        } else if (fechaSinHora.isAtSameMomentAs(manana)) {
          // Mañana
          tipo = TipoNotificacion.vacunacionManana;
          titulo = ErrorMessages.get('ALERT_VAC_MANANA');
          mensaje = ErrorMessages.format('ALERT_VAC_PARA_LOTE', {
            'vacuna': vacunaNombre,
            'lote': loteNombre,
          });
          prioridad = PrioridadNotificacion.alta;
        } else if (fechaSinHora.isBefore(en7Dias)) {
          // Próximos 7 días
          final dias = fechaSinHora.difference(hoy).inDays;
          tipo = TipoNotificacion.recordatorioVacunacion;
          titulo = ErrorMessages.format('ALERT_VAC_EN_DIAS', {'dias': '$dias'});
          mensaje = ErrorMessages.format('ALERT_VAC_PARA_LOTE', {
            'vacuna': vacunaNombre,
            'lote': loteNombre,
          });
          prioridad = PrioridadNotificacion.normal;
        } else {
          continue;
        }

        await _crearNotificacion(
          usuarioIds: usuariosNotificar,
          tipo: tipo,
          titulo: titulo,
          mensaje: mensaje,
          granjaId: granjaId,
          granjaName: granjaName,
          prioridad: prioridad,
          data: {
            'vacunacionId': doc.id,
            'vacunaNombre': vacunaNombre,
            'loteNombre': loteNombre,
            'fechaProgramada': fechaProgramada.toIso8601String(),
          },
          accionUrl: AppRoutes.vacunaciones,
        );
      }
    } on Exception catch (e) {
      debugPrint('Error verificando vacunaciones: $e');
    }
  }

  /// Notifica vacunación aplicada.
  Future<void> notificarVacunacionAplicada({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required String vacunaNombre,
    required int avesVacunadas,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.vacunacionAplicada,
        titulo: ErrorMessages.get('ALERT_VAC_COMPLETADA'),
        mensaje: ErrorMessages.format('ALERT_VAC_COMPLETADA_MSG', {
          'vacuna': vacunaNombre,
          'aves': '$avesVacunadas',
          'lote': loteNombre,
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.baja,
        data: {
          'loteId': loteId,
          'vacunaNombre': vacunaNombre,
          'avesVacunadas': avesVacunadas,
        },
        accionUrl: AppRoutes.saludPorLoteId(loteId, granjaId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando vacunación: $e');
    }
  }

  /// Notifica inicio de tratamiento.
  Future<void> notificarTratamientoIniciado({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required String tratamiento,
    required int duracionDias,
    int? diasRetiro,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.tratamientoIniciado,
        titulo: ErrorMessages.format('ALERT_TRATAMIENTO', {'lote': loteNombre}),
        mensaje:
            '${ErrorMessages.format('ALERT_TRATAMIENTO_MSG', {'tratamiento': tratamiento, 'dias': '$duracionDias'})}${diasRetiro != null ? ErrorMessages.format('ALERT_TRATAMIENTO_RETIRO', {'diasRetiro': '$diasRetiro'}) : ''}',
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.alta,
        data: {
          'loteId': loteId,
          'tratamiento': tratamiento,
          'duracionDias': duracionDias,
          'diasRetiro': diasRetiro,
        },
        accionUrl: AppRoutes.saludPorLoteId(loteId, granjaId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando tratamiento: $e');
    }
  }

  /// Notifica período de retiro activo.
  Future<void> notificarPeriodoRetiro({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required String medicamento,
    required DateTime fechaFinRetiro,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);
      final diasRestantes = fechaFinRetiro.difference(DateTime.now()).inDays;

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.periodoRetiroActivo,
        titulo: ErrorMessages.format('ALERT_RETIRO_ACTIVO', {
          'lote': loteNombre,
        }),
        mensaje: ErrorMessages.format('ALERT_RETIRO_ACTIVO_MSG', {
          'medicamento': medicamento,
          'dias': '$diasRestantes',
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.urgente,
        data: {
          'loteId': loteId,
          'medicamento': medicamento,
          'fechaFinRetiro': fechaFinRetiro.toIso8601String(),
          'diasRestantes': diasRestantes,
        },
        accionUrl: AppRoutes.saludPorLoteId(loteId, granjaId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando retiro: $e');
    }
  }

  /// Notifica fin de período de retiro.
  Future<void> notificarFinPeriodoRetiro({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required String medicamento,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.periodoRetiroFin,
        titulo: ErrorMessages.format('ALERT_RETIRO_FIN', {'lote': loteNombre}),
        mensaje: ErrorMessages.format('ALERT_RETIRO_FIN_MSG', {
          'medicamento': medicamento,
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.alta,
        data: {'loteId': loteId, 'medicamento': medicamento},
        accionUrl: AppRoutes.saludPorLoteId(loteId, granjaId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando fin retiro: $e');
    }
  }

  /// Notifica nuevo diagnóstico/registro de salud.
  Future<void> notificarNuevoDiagnostico({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required String diagnostico,
    required String severidad,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      final prioridad = switch (severidad.toLowerCase()) {
        'critico' || 'grave' => PrioridadNotificacion.urgente,
        'moderado' => PrioridadNotificacion.alta,
        _ => PrioridadNotificacion.normal,
      };

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.nuevoDiagnostico,
        titulo: ErrorMessages.format('ALERT_DIAGNOSTICO', {'lote': loteNombre}),
        mensaje: ErrorMessages.format('ALERT_DIAGNOSTICO_MSG', {
          'diagnostico': diagnostico,
          'severidad': severidad,
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: prioridad,
        data: {
          'loteId': loteId,
          'diagnostico': diagnostico,
          'severidad': severidad,
        },
        accionUrl: AppRoutes.saludPorLoteId(loteId, granjaId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando diagnóstico: $e');
    }
  }

  // ============================================================
  // ALERTAS SANITARIAS
  // ============================================================

  /// Notifica síntomas respiratorios detectados.
  Future<void> notificarSintomasRespiratorios({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required List<String> sintomas,
    required int avesAfectadas,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.sintomasRespiratorios,
        titulo: ErrorMessages.format('ALERT_SINTOMAS_RESP', {
          'lote': loteNombre,
        }),
        mensaje: ErrorMessages.format('ALERT_SINTOMAS_RESP_MSG', {
          'sintomas': sintomas.join(', '),
          'aves': '$avesAfectadas',
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.urgente,
        data: {
          'loteId': loteId,
          'sintomas': sintomas,
          'avesAfectadas': avesAfectadas,
        },
        accionUrl: AppRoutes.saludPorLoteId(loteId, granjaId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando síntomas: $e');
    }
  }

  /// Notifica consumo anormal de agua.
  Future<void> notificarConsumoAguaAnormal({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required double consumoActual,
    required double consumoEsperado,
    required bool esBajo,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);
      final diferencia =
          ((consumoActual - consumoEsperado) / consumoEsperado * 100).abs();

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.consumoAguaAnormal,
        titulo: ErrorMessages.format('ALERT_CONSUMO_AGUA', {
          'tipo': esBajo
              ? ErrorMessages.get('ALERT_BAJO')
              : ErrorMessages.get('ALERT_ALTO'),
          'lote': loteNombre,
        }),
        mensaje: ErrorMessages.format('ALERT_CONSUMO_AGUA_MSG', {
          'actual': consumoActual.toStringAsFixed(1),
          'esperado': consumoEsperado.toStringAsFixed(1),
          'diferencia': diferencia.toStringAsFixed(0),
          'tipo': esBajo
              ? ErrorMessages.get('ALERT_BAJO')
              : ErrorMessages.get('ALERT_ALTO'),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.alta,
        data: {
          'loteId': loteId,
          'consumoActual': consumoActual,
          'consumoEsperado': consumoEsperado,
          'esBajo': esBajo,
        },
        accionUrl: AppRoutes.loteDashboardById(granjaId, loteId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando consumo agua: $e');
    }
  }

  /// Notifica consumo anormal de alimento.
  Future<void> notificarConsumoAlimentoAnormal({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required double consumoActual,
    required double consumoEsperado,
    required bool esBajo,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);
      final diferencia =
          ((consumoActual - consumoEsperado) / consumoEsperado * 100).abs();

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.consumoAlimentoAnormal,
        titulo: ErrorMessages.format('ALERT_CONSUMO_ALIMENTO', {
          'tipo': esBajo
              ? ErrorMessages.get('ALERT_BAJO')
              : ErrorMessages.get('ALERT_ALTO'),
          'lote': loteNombre,
        }),
        mensaje: ErrorMessages.format('ALERT_CONSUMO_ALIMENTO_MSG', {
          'actual': consumoActual.toStringAsFixed(1),
          'esperado': consumoEsperado.toStringAsFixed(1),
          'diferencia': diferencia.toStringAsFixed(0),
          'tipo': esBajo
              ? ErrorMessages.get('ALERT_BAJO')
              : ErrorMessages.get('ALERT_ALTO'),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.alta,
        data: {
          'loteId': loteId,
          'consumoActual': consumoActual,
          'consumoEsperado': consumoEsperado,
          'esBajo': esBajo,
        },
        accionUrl: AppRoutes.loteDashboardById(granjaId, loteId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando consumo alimento: $e');
    }
  }

  /// Notifica temperatura anormal.
  Future<void> notificarTemperaturaAnormal({
    required String granjaId,
    required String galponId,
    required String galponNombre,
    required double temperaturaActual,
    required double temperaturaMinima,
    required double temperaturaMaxima,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);
      final esBaja = temperaturaActual < temperaturaMinima;

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.temperaturaAnormal,
        titulo: ErrorMessages.format('ALERT_TEMPERATURA', {
          'tipo': esBaja
              ? ErrorMessages.get('ALERT_BAJA')
              : ErrorMessages.get('ALERT_ALTA'),
          'galpon': galponNombre,
        }),
        mensaje: ErrorMessages.format('ALERT_TEMPERATURA_MSG', {
          'actual': temperaturaActual.toStringAsFixed(1),
          'min': temperaturaMinima.toStringAsFixed(0),
          'max': temperaturaMaxima.toStringAsFixed(0),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.urgente,
        data: {
          'galponId': galponId,
          'temperaturaActual': temperaturaActual,
          'temperaturaMinima': temperaturaMinima,
          'temperaturaMaxima': temperaturaMaxima,
        },
        accionUrl: AppRoutes.galponDetalleById(granjaId, galponId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando temperatura: $e');
    }
  }

  /// Notifica humedad anormal.
  Future<void> notificarHumedadAnormal({
    required String granjaId,
    required String galponId,
    required String galponNombre,
    required double humedadActual,
    required double humedadMinima,
    required double humedadMaxima,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);
      final esBaja = humedadActual < humedadMinima;

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.humedadAnormal,
        titulo: ErrorMessages.format('ALERT_HUMEDAD', {
          'tipo': esBaja
              ? ErrorMessages.get('ALERT_BAJA')
              : ErrorMessages.get('ALERT_ALTA'),
          'galpon': galponNombre,
        }),
        mensaje: ErrorMessages.format('ALERT_HUMEDAD_MSG', {
          'actual': humedadActual.toStringAsFixed(1),
          'min': humedadMinima.toStringAsFixed(0),
          'max': humedadMaxima.toStringAsFixed(0),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.alta,
        data: {
          'galponId': galponId,
          'humedadActual': humedadActual,
          'humedadMinima': humedadMinima,
          'humedadMaxima': humedadMaxima,
        },
        accionUrl: AppRoutes.galponDetalleById(granjaId, galponId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando humedad: $e');
    }
  }

  /// Notifica enfermedad confirmada.
  Future<void> notificarEnfermedadConfirmada({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required String enfermedad,
    required int avesAfectadas,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.enfermedadConfirmada,
        titulo: ErrorMessages.format('ALERT_ENFERMEDAD', {'lote': loteNombre}),
        mensaje: ErrorMessages.format('ALERT_ENFERMEDAD_MSG', {
          'enfermedad': enfermedad,
          'aves': '$avesAfectadas',
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.urgente,
        data: {
          'loteId': loteId,
          'enfermedad': enfermedad,
          'avesAfectadas': avesAfectadas,
        },
        accionUrl: AppRoutes.saludPorLoteId(loteId, granjaId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando enfermedad: $e');
    }
  }

  // ============================================================
  // BIOSEGURIDAD / INSPECCIONES
  // ============================================================

  /// Verifica inspecciones de bioseguridad pendientes.
  Future<void> verificarInspeccionesPendientes(String granjaId) async {
    try {
      final ahora = DateTime.now();
      final hoy = DateTime(ahora.year, ahora.month, ahora.day);

      final snapshot = await _firestore
          .collection('granjas')
          .doc(granjaId)
          .collection('inspecciones_programadas')
          .where('completada', isEqualTo: false)
          .get();

      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final fechaProgramada = (data['fechaProgramada'] as Timestamp).toDate();
        final tipoInspeccion = data['tipo'] ?? 'Inspección';

        final fechaSinHora = DateTime(
          fechaProgramada.year,
          fechaProgramada.month,
          fechaProgramada.day,
        );

        TipoNotificacion tipo;
        String titulo;
        PrioridadNotificacion prioridad;

        if (fechaSinHora.isBefore(hoy)) {
          tipo = TipoNotificacion.inspeccionVencida;
          titulo = ErrorMessages.get('ALERT_INSP_VENCIDA');
          prioridad = PrioridadNotificacion.urgente;
        } else if (fechaSinHora.isAtSameMomentAs(hoy)) {
          tipo = TipoNotificacion.inspeccionHoy;
          titulo = ErrorMessages.get('ALERT_INSP_HOY');
          prioridad = PrioridadNotificacion.alta;
        } else {
          final dias = fechaSinHora.difference(hoy).inDays;
          if (dias <= 3) {
            tipo = TipoNotificacion.inspeccionPendiente;
            titulo = ErrorMessages.format('ALERT_INSP_EN_DIAS', {
              'dias': dias.toString(),
            });
            prioridad = PrioridadNotificacion.normal;
          } else {
            continue;
          }
        }

        await _crearNotificacion(
          usuarioIds: usuariosNotificar,
          tipo: tipo,
          titulo: titulo,
          mensaje: tipoInspeccion,
          granjaId: granjaId,
          granjaName: granjaName,
          prioridad: prioridad,
          data: {
            'inspeccionId': doc.id,
            'tipoInspeccion': tipoInspeccion,
            'fechaProgramada': fechaProgramada.toIso8601String(),
          },
          accionUrl: AppRoutes.bioseguridadPorGranja(granjaId),
        );
      }
    } on Exception catch (e) {
      debugPrint('Error verificando inspecciones: $e');
    }
  }

  /// Notifica inspección completada con puntaje.
  Future<void> notificarInspeccionCompletada({
    required String granjaId,
    required String inspeccionId,
    required String tipoInspeccion,
    required double puntaje,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      TipoNotificacion tipo;
      String titulo;
      PrioridadNotificacion prioridad;

      if (puntaje < 60) {
        tipo = TipoNotificacion.bioseguridadCritica;
        titulo = ErrorMessages.get('ALERT_BIOSEG_CRITICA');
        prioridad = PrioridadNotificacion.urgente;
      } else if (puntaje < 80) {
        tipo = TipoNotificacion.bioseguridadBaja;
        titulo = ErrorMessages.get('ALERT_BIOSEG_BAJA');
        prioridad = PrioridadNotificacion.alta;
      } else {
        tipo = TipoNotificacion.inspeccionCompletada;
        titulo = ErrorMessages.get('ALERT_INSP_COMPLETADA');
        prioridad = PrioridadNotificacion.normal;
      }

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: tipo,
        titulo: titulo,
        mensaje: ErrorMessages.format('ALERT_BIOSEG_RESULTADO', {
          'tipo': tipoInspeccion,
          'puntaje': puntaje.toStringAsFixed(0),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: prioridad,
        data: {
          'inspeccionId': inspeccionId,
          'tipoInspeccion': tipoInspeccion,
          'puntaje': puntaje,
        },
        accionUrl: AppRoutes.bioseguridadPorGranja(granjaId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando inspección: $e');
    }
  }

  /// Notifica necropsia registrada.
  Future<void> notificarNecropsiaRegistrada({
    required String granjaId,
    required String loteId,
    required String loteNombre,
    required String hallazgos,
    required String causaProbable,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.necropsiaRegistrada,
        titulo: ErrorMessages.format('ALERT_NECROPSIA', {'lote': loteNombre}),
        mensaje: ErrorMessages.format('ALERT_NECROPSIA_MSG', {
          'causa': causaProbable,
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.alta,
        data: {
          'loteId': loteId,
          'hallazgos': hallazgos,
          'causaProbable': causaProbable,
        },
        accionUrl: AppRoutes.saludPorLoteId(loteId, granjaId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando necropsia: $e');
    }
  }

  // ============================================================
  // VENTAS / PEDIDOS
  // ============================================================

  /// Notifica nuevo pedido recibido.
  Future<void> notificarNuevoPedido({
    required String granjaId,
    required String pedidoId,
    required String clienteNombre,
    required int cantidadHuevos,
    required double montoTotal,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.nuevoPedido,
        titulo: ErrorMessages.get('ALERT_NUEVO_PEDIDO'),
        mensaje: ErrorMessages.format('ALERT_NUEVO_PEDIDO_MSG', {
          'cliente': clienteNombre,
          'cantidad': cantidadHuevos.toString(),
          'monto': montoTotal.toStringAsFixed(2),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.alta,
        data: {
          'pedidoId': pedidoId,
          'clienteNombre': clienteNombre,
          'cantidadHuevos': cantidadHuevos,
          'montoTotal': montoTotal,
        },
        accionUrl: AppRoutes.ventas,
      );
    } on Exception catch (e) {
      debugPrint('Error notificando pedido: $e');
    }
  }

  /// Notifica pedido confirmado.
  Future<void> notificarPedidoConfirmado({
    required String granjaId,
    required String pedidoId,
    required String clienteNombre,
    required DateTime fechaEntrega,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.pedidoConfirmado,
        titulo: ErrorMessages.get('ALERT_PEDIDO_CONFIRMADO'),
        mensaje: ErrorMessages.format('ALERT_PEDIDO_CONFIRMADO_MSG', {
          'cliente': clienteNombre,
          'fecha': _formatearFecha(fechaEntrega),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.normal,
        data: {
          'pedidoId': pedidoId,
          'clienteNombre': clienteNombre,
          'fechaEntrega': fechaEntrega.toIso8601String(),
        },
        accionUrl: AppRoutes.ventas,
      );
    } on Exception catch (e) {
      debugPrint('Error notificando confirmación: $e');
    }
  }

  /// Verifica entregas programadas.
  Future<void> verificarEntregasProgramadas(String granjaId) async {
    try {
      final ahora = DateTime.now();
      final hoy = DateTime(ahora.year, ahora.month, ahora.day);
      final manana = hoy.add(const Duration(days: 1));

      final snapshot = await _firestore
          .collection('granjas')
          .doc(granjaId)
          .collection('pedidos')
          .where('estado', isEqualTo: 'confirmado')
          .get();

      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      for (final doc in snapshot.docs) {
        final data = doc.data();
        if (data['fechaEntrega'] == null) continue;

        final fechaEntrega = (data['fechaEntrega'] as Timestamp).toDate();
        final clienteNombre = data['clienteNombre'] ?? 'Cliente';

        final fechaSinHora = DateTime(
          fechaEntrega.year,
          fechaEntrega.month,
          fechaEntrega.day,
        );

        if (fechaSinHora.isAtSameMomentAs(hoy)) {
          await _crearNotificacion(
            usuarioIds: usuariosNotificar,
            tipo: TipoNotificacion.entregaHoy,
            titulo: ErrorMessages.get('ALERT_ENTREGA_HOY'),
            mensaje: clienteNombre,
            granjaId: granjaId,
            granjaName: granjaName,
            prioridad: PrioridadNotificacion.alta,
            data: {'pedidoId': doc.id, 'clienteNombre': clienteNombre},
            accionUrl: AppRoutes.ventas,
          );
        } else if (fechaSinHora.isAtSameMomentAs(manana)) {
          await _crearNotificacion(
            usuarioIds: usuariosNotificar,
            tipo: TipoNotificacion.entregaManana,
            titulo: ErrorMessages.get('ALERT_ENTREGA_MANANA'),
            mensaje: clienteNombre,
            granjaId: granjaId,
            granjaName: granjaName,
            prioridad: PrioridadNotificacion.normal,
            data: {'pedidoId': doc.id, 'clienteNombre': clienteNombre},
            accionUrl: AppRoutes.ventas,
          );
        }
      }
    } on Exception catch (e) {
      debugPrint('Error verificando entregas: $e');
    }
  }

  /// Notifica pedido entregado.
  Future<void> notificarPedidoEntregado({
    required String granjaId,
    required String pedidoId,
    required String clienteNombre,
    required double montoTotal,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.pedidoEntregado,
        titulo: ErrorMessages.get('ALERT_PEDIDO_ENTREGADO'),
        mensaje: ErrorMessages.format('ALERT_PEDIDO_ENTREGADO_MSG', {
          'cliente': clienteNombre,
          'monto': montoTotal.toStringAsFixed(2),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.baja,
        data: {
          'pedidoId': pedidoId,
          'clienteNombre': clienteNombre,
          'montoTotal': montoTotal,
        },
        accionUrl: AppRoutes.ventas,
      );
    } on Exception catch (e) {
      debugPrint('Error notificando entrega: $e');
    }
  }

  /// Notifica pedido cancelado.
  Future<void> notificarPedidoCancelado({
    required String granjaId,
    required String pedidoId,
    required String clienteNombre,
    required String motivo,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.pedidoCancelado,
        titulo: ErrorMessages.get('ALERT_PEDIDO_CANCELADO'),
        mensaje: ErrorMessages.format('ALERT_PEDIDO_CANCELADO_MSG', {
          'cliente': clienteNombre,
          'motivo': motivo,
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.alta,
        data: {
          'pedidoId': pedidoId,
          'clienteNombre': clienteNombre,
          'motivo': motivo,
        },
        accionUrl: AppRoutes.ventas,
      );
    } on Exception catch (e) {
      debugPrint('Error notificando cancelación: $e');
    }
  }

  /// Notifica pago recibido.
  Future<void> notificarPagoRecibido({
    required String granjaId,
    required String pedidoId,
    required String clienteNombre,
    required double monto,
    required String metodoPago,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.pagoRecibido,
        titulo: ErrorMessages.get('ALERT_PAGO_RECIBIDO'),
        mensaje: ErrorMessages.format('ALERT_PAGO_MSG', {
          'cliente': clienteNombre,
          'monto': monto.toStringAsFixed(2),
          'metodo': metodoPago,
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.normal,
        data: {
          'pedidoId': pedidoId,
          'clienteNombre': clienteNombre,
          'monto': monto,
          'metodoPago': metodoPago,
        },
        accionUrl: AppRoutes.ventas,
      );
    } on Exception catch (e) {
      debugPrint('Error notificando pago: $e');
    }
  }

  /// Notifica venta registrada.
  Future<void> notificarVentaRegistrada({
    required String granjaId,
    required String ventaId,
    required String clienteNombre,
    required int cantidadHuevos,
    required double montoTotal,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.ventaRegistrada,
        titulo: ErrorMessages.get('ALERT_VENTA_REG'),
        mensaje: ErrorMessages.format('ALERT_VENTA_REG_MSG', {
          'cliente': clienteNombre,
          'cantidad': cantidadHuevos.toString(),
          'monto': montoTotal.toStringAsFixed(2),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.baja,
        data: {
          'ventaId': ventaId,
          'clienteNombre': clienteNombre,
          'cantidadHuevos': cantidadHuevos,
          'montoTotal': montoTotal,
        },
        accionUrl: AppRoutes.ventaDetalleById(ventaId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando venta: $e');
    }
  }

  // ============================================================
  // COLABORADORES
  // ============================================================

  /// Notifica una nueva invitación.
  Future<void> notificarInvitacion({
    required String usuarioDestinoId,
    required String emailInvitado,
    required String granjaId,
    required String granjaName,
    required String invitadoPor,
    required String codigoInvitacion,
  }) async {
    try {
      final usuarioSnapshot = await _firestore
          .collection('usuarios')
          .where('email', isEqualTo: emailInvitado)
          .limit(1)
          .get();

      if (usuarioSnapshot.docs.isEmpty) {
        debugPrint('Usuario no encontrado: $emailInvitado');
        return;
      }

      final usuarioId = usuarioSnapshot.docs.first.id;

      final notificacion = Notificacion(
        id: '',
        usuarioId: usuarioId,
        tipo: TipoNotificacion.invitacionRecibida,
        titulo: ErrorMessages.format('ALERT_INVITACION', {
          'granja': granjaName,
        }),
        mensaje: ErrorMessages.format('ALERT_INVITACION_MSG', {
          'invitadoPor': invitadoPor,
        }),
        fechaCreacion: DateTime.now(),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.alta,
        data: {
          'codigoInvitacion': codigoInvitacion,
          'invitadoPor': invitadoPor,
        },
        accionUrl: AppRoutes.aceptarInvitacionConCodigo(codigoInvitacion),
      );

      await _notificacionesRepo.crear(notificacion);

      await NotificationService.instance.crearNotificacionLocal(
        usuarioId: usuarioId,
        tipo: TipoNotificacion.invitacionRecibida,
        titulo: ErrorMessages.format('ALERT_INVITACION', {
          'granja': granjaName,
        }),
        mensaje: ErrorMessages.format('ALERT_INVITACION_MSG', {
          'invitadoPor': invitadoPor,
        }),
        granjaId: granjaId,
        granjaName: granjaName,
      );
    } on Exception catch (e) {
      debugPrint('Error notificando invitación: $e');
    }
  }

  /// Notifica invitación aceptada.
  Future<void> notificarInvitacionAceptada({
    required String granjaId,
    required String nombreNuevoColaborador,
    required RolGranja rolAsignado,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.invitacionAceptada,
        titulo: ErrorMessages.get('ALERT_NUEVO_COLAB'),
        mensaje: ErrorMessages.format('ALERT_NUEVO_COLAB_MSG', {
          'nombre': nombreNuevoColaborador,
          'rol': rolAsignado.displayName,
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.normal,
        data: {
          'nombreColaborador': nombreNuevoColaborador,
          'rol': rolAsignado.name,
        },
        accionUrl: AppRoutes.granjaColaboradoresById(granjaId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando aceptación: $e');
    }
  }

  /// Notifica invitación rechazada.
  Future<void> notificarInvitacionRechazada({
    required String granjaId,
    required String emailRechazado,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.invitacionRechazada,
        titulo: ErrorMessages.get('ALERT_INVITACION_RECHAZADA'),
        mensaje: ErrorMessages.format('ALERT_INVITACION_RECHAZADA_MSG', {
          'email': emailRechazado,
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.baja,
        data: {'emailRechazado': emailRechazado},
        accionUrl: AppRoutes.granjaColaboradoresById(granjaId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando rechazo: $e');
    }
  }

  /// Notifica colaborador eliminado.
  Future<void> notificarColaboradorEliminado({
    required String granjaId,
    required String usuarioEliminadoId,
    required String nombreEliminado,
  }) async {
    try {
      // Notificar al usuario eliminado
      final granjaName = await _getGranjaName(granjaId);

      final notificacion = Notificacion(
        id: '',
        usuarioId: usuarioEliminadoId,
        tipo: TipoNotificacion.colaboradorEliminado,
        titulo: ErrorMessages.get('ALERT_ACCESO_REVOCADO'),
        mensaje: ErrorMessages.format('ALERT_ACCESO_REVOCADO_MSG', {
          'granja': granjaName,
        }),
        fechaCreacion: DateTime.now(),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.alta,
        data: {'nombreGranja': granjaName},
        accionUrl: AppRoutes.granjas,
      );

      await _notificacionesRepo.crear(notificacion);

      // Notificar al owner
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
      ]);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.colaboradorEliminado,
        titulo: ErrorMessages.get('ALERT_COLAB_REMOVIDO'),
        mensaje: ErrorMessages.format('ALERT_COLAB_REMOVIDO_MSG', {
          'nombre': nombreEliminado,
          'granja': granjaName,
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.baja,
        data: {'nombreEliminado': nombreEliminado},
        accionUrl: AppRoutes.granjaColaboradoresById(granjaId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando eliminación: $e');
    }
  }

  /// Notifica cambio de rol.
  Future<void> notificarCambioRol({
    required String granjaId,
    required String usuarioId,
    required String nombreUsuario,
    required RolGranja rolAnterior,
    required RolGranja rolNuevo,
  }) async {
    try {
      final granjaName = await _getGranjaName(granjaId);

      // Notificar al usuario afectado
      final notificacion = Notificacion(
        id: '',
        usuarioId: usuarioId,
        tipo: TipoNotificacion.cambioRol,
        titulo: ErrorMessages.get('ALERT_CAMBIO_ROL'),
        mensaje: ErrorMessages.format('ALERT_CAMBIO_ROL_MSG', {
          'rolAnterior': rolAnterior.displayName,
          'rolNuevo': rolNuevo.displayName,
          'granja': granjaName,
        }),
        fechaCreacion: DateTime.now(),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.alta,
        data: {'rolAnterior': rolAnterior.name, 'rolNuevo': rolNuevo.name},
        accionUrl: AppRoutes.granjaDetalleById(granjaId),
      );

      await _notificacionesRepo.crear(notificacion);
    } on Exception catch (e) {
      debugPrint('Error notificando cambio rol: $e');
    }
  }

  // ============================================================
  // GALPONES
  // ============================================================

  /// Notifica nuevo galpón creado.
  Future<void> notificarGalponCreado({
    required String granjaId,
    required String galponId,
    required String galponNombre,
    required int capacidad,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
        RolGranja.operator,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.galponCreado,
        titulo: ErrorMessages.format('ALERT_NUEVO_GALPON', {
          'galpon': galponNombre,
        }),
        mensaje: ErrorMessages.format('ALERT_NUEVO_GALPON_MSG', {
          'capacidad': capacidad.toString(),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.normal,
        data: {
          'galponId': galponId,
          'galponNombre': galponNombre,
          'capacidad': capacidad,
        },
        accionUrl: AppRoutes.galponDetalleById(granjaId, galponId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando galpón: $e');
    }
  }

  /// Notifica galpón en mantenimiento.
  Future<void> notificarGalponMantenimiento({
    required String granjaId,
    required String galponId,
    required String galponNombre,
    required String tipoMantenimiento,
    required DateTime fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.galponMantenimiento,
        titulo: ErrorMessages.format('ALERT_MANTENIMIENTO', {
          'galpon': galponNombre,
        }),
        mensaje: tipoMantenimiento,
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.normal,
        data: {
          'galponId': galponId,
          'tipoMantenimiento': tipoMantenimiento,
          'fechaInicio': fechaInicio.toIso8601String(),
          'fechaFin': fechaFin?.toIso8601String(),
        },
        accionUrl: AppRoutes.galponDetalleById(granjaId, galponId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando mantenimiento: $e');
    }
  }

  /// Notifica capacidad máxima alcanzada.
  Future<void> notificarCapacidadMaxima({
    required String granjaId,
    required String galponId,
    required String galponNombre,
    required int avesActuales,
    required int capacidadMaxima,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.galponCapacidadMaxima,
        titulo: ErrorMessages.format('ALERT_CAPACIDAD_MAX', {
          'galpon': galponNombre,
        }),
        mensaje: ErrorMessages.format('ALERT_CAPACIDAD_MAX_MSG', {
          'actual': avesActuales.toString(),
          'max': capacidadMaxima.toString(),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.alta,
        data: {
          'galponId': galponId,
          'avesActuales': avesActuales,
          'capacidadMaxima': capacidadMaxima,
        },
        accionUrl: AppRoutes.galponDetalleById(granjaId, galponId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando capacidad: $e');
    }
  }

  /// Notifica evento de galpón (desinfección, etc.).
  Future<void> notificarEventoGalpon({
    required String granjaId,
    required String galponId,
    required String galponNombre,
    required String tipoEvento,
    required String descripcion,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.galponEvento,
        titulo: ErrorMessages.format('ALERT_EVENTO_GALPON', {
          'tipo': tipoEvento,
          'galpon': galponNombre,
        }),
        mensaje: descripcion,
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.baja,
        data: {
          'galponId': galponId,
          'tipoEvento': tipoEvento,
          'descripcion': descripcion,
        },
        accionUrl: AppRoutes.galponDetalleById(granjaId, galponId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando evento: $e');
    }
  }

  // ============================================================
  // COSTOS / FINANZAS
  // ============================================================

  /// Notifica gasto registrado.
  Future<void> notificarGastoRegistrado({
    required String granjaId,
    required String gastoId,
    required String categoria,
    required double monto,
    required String descripcion,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.gastoRegistrado,
        titulo: ErrorMessages.format('ALERT_GASTO', {'categoria': categoria}),
        mensaje: ErrorMessages.format('ALERT_GASTO_MSG', {
          'monto': monto.toStringAsFixed(2),
          'descripcion': descripcion,
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.baja,
        data: {
          'gastoId': gastoId,
          'categoria': categoria,
          'monto': monto,
          'descripcion': descripcion,
        },
        accionUrl: AppRoutes.costoDetalleById(gastoId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando gasto: $e');
    }
  }

  /// Notifica gasto inusualmente alto.
  Future<void> notificarGastoInusual({
    required String granjaId,
    required String gastoId,
    required String categoria,
    required double monto,
    required double promedioHistorico,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
      ]);
      final granjaName = await _getGranjaName(granjaId);
      final porcentajeSobre = ((monto / promedioHistorico) - 1) * 100;

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.gastoInusual,
        titulo: ErrorMessages.format('ALERT_GASTO_INUSUAL', {
          'categoria': categoria,
        }),
        mensaje: ErrorMessages.format('ALERT_GASTO_INUSUAL_MSG', {
          'monto': monto.toStringAsFixed(2),
          'porcentaje': porcentajeSobre.toStringAsFixed(0),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.alta,
        data: {
          'gastoId': gastoId,
          'categoria': categoria,
          'monto': monto,
          'promedioHistorico': promedioHistorico,
        },
        accionUrl: AppRoutes.costoDetalleById(gastoId),
      );
    } on Exception catch (e) {
      debugPrint('Error notificando gasto inusual: $e');
    }
  }

  /// Notifica presupuesto superado.
  Future<void> notificarPresupuestoSuperado({
    required String granjaId,
    required String categoria,
    required double gastoAcumulado,
    required double presupuesto,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
      ]);
      final granjaName = await _getGranjaName(granjaId);
      final exceso = gastoAcumulado - presupuesto;

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.presupuestoSuperado,
        titulo: ErrorMessages.format('ALERT_PRESUPUESTO_SUPERADO', {
          'categoria': categoria,
        }),
        mensaje: ErrorMessages.format('ALERT_PRESUPUESTO_MSG', {
          'gastoAcum': gastoAcumulado.toStringAsFixed(2),
          'presupuesto': presupuesto.toStringAsFixed(2),
          'exceso': exceso.toStringAsFixed(2),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.alta,
        data: {
          'categoria': categoria,
          'gastoAcumulado': gastoAcumulado,
          'presupuesto': presupuesto,
          'exceso': exceso,
        },
        accionUrl: AppRoutes.costos,
      );
    } on Exception catch (e) {
      debugPrint('Error notificando presupuesto: $e');
    }
  }

  /// Notifica resumen semanal.
  Future<void> notificarResumenSemanal({
    required String granjaId,
    required double ingresos,
    required double gastos,
    required double utilidad,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.resumenSemanal,
        titulo: ErrorMessages.get('ALERT_RESUMEN_SEMANAL'),
        mensaje: ErrorMessages.format('ALERT_RESUMEN_SEMANAL_MSG', {
          'ingresos': ingresos.toStringAsFixed(2),
          'gastos': gastos.toStringAsFixed(2),
          'tipo': utilidad >= 0
              ? ErrorMessages.get('ALERT_UTILIDAD')
              : ErrorMessages.get('ALERT_PERDIDA'),
          'utilidad': utilidad.abs().toStringAsFixed(2),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.baja,
        data: {'ingresos': ingresos, 'gastos': gastos, 'utilidad': utilidad},
        accionUrl: AppRoutes.reportes,
      );
    } on Exception catch (e) {
      debugPrint('Error notificando resumen: $e');
    }
  }

  // ============================================================
  // REPORTES
  // ============================================================

  /// Notifica reporte generado.
  Future<void> notificarReporteGenerado({
    required String granjaId,
    required String usuarioId,
    required String tipoReporte,
    required String urlDescarga,
  }) async {
    try {
      final granjaName = await _getGranjaName(granjaId);

      final notificacion = Notificacion(
        id: '',
        usuarioId: usuarioId,
        tipo: TipoNotificacion.reporteGenerado,
        titulo: ErrorMessages.get('ALERT_REPORTE_LISTO'),
        mensaje: ErrorMessages.format('ALERT_REPORTE_LISTO_MSG', {
          'tipo': tipoReporte,
        }),
        fechaCreacion: DateTime.now(),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.normal,
        data: {'tipoReporte': tipoReporte, 'urlDescarga': urlDescarga},
        accionUrl: urlDescarga,
      );

      await _notificacionesRepo.crear(notificacion);
    } on Exception catch (e) {
      debugPrint('Error notificando reporte: $e');
    }
  }

  /// Notifica resumen diario automático.
  Future<void> notificarResumenDiario({
    required String granjaId,
    required int produccionHuevos,
    required int mortalidadDia,
    required double consumoAlimento,
    required int alertasPendientes,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.resumenDiario,
        titulo: ErrorMessages.get('ALERT_RESUMEN_DIA'),
        mensaje: ErrorMessages.format('ALERT_RESUMEN_DIA_MSG', {
          'huevos': produccionHuevos.toString(),
          'mortalidad': mortalidadDia.toString(),
          'alimento': consumoAlimento.toStringAsFixed(1),
          'alertas': alertasPendientes.toString(),
        }),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: PrioridadNotificacion.baja,
        data: {
          'produccionHuevos': produccionHuevos,
          'mortalidadDia': mortalidadDia,
          'consumoAlimento': consumoAlimento,
          'alertasPendientes': alertasPendientes,
        },
        accionUrl: AppRoutes.home,
      );
    } on Exception catch (e) {
      debugPrint('Error notificando resumen diario: $e');
    }
  }

  /// Notifica alerta consolidada.
  Future<void> notificarAlertaConsolidada({
    required String granjaId,
    required int cantidadAlertas,
    required List<String> tiposAlertas,
  }) async {
    try {
      final usuariosNotificar = await _getUsuariosConRoles(granjaId, [
        RolGranja.owner,
        RolGranja.admin,
        RolGranja.manager,
      ]);
      final granjaName = await _getGranjaName(granjaId);

      await _crearNotificacion(
        usuarioIds: usuariosNotificar,
        tipo: TipoNotificacion.alertaConsolidada,
        titulo: ErrorMessages.format('ALERT_ALERTAS_PENDIENTES', {
          'cantidad': cantidadAlertas.toString(),
        }),
        mensaje:
            tiposAlertas.take(3).join(', ') +
            (tiposAlertas.length > 3 ? '...' : ''),
        granjaId: granjaId,
        granjaName: granjaName,
        prioridad: cantidadAlertas > 5
            ? PrioridadNotificacion.alta
            : PrioridadNotificacion.normal,
        data: {
          'cantidadAlertas': cantidadAlertas,
          'tiposAlertas': tiposAlertas,
        },
        accionUrl: AppRoutes.notificaciones,
      );
    } on Exception catch (e) {
      debugPrint('Error notificando alertas: $e');
    }
  }

  // ============================================================
  // SISTEMA
  // ============================================================

  /// Notifica sincronización completada.
  Future<void> notificarSincronizacionCompletada({
    required String usuarioId,
    required int registrosSincronizados,
  }) async {
    try {
      final notificacion = Notificacion(
        id: '',
        usuarioId: usuarioId,
        tipo: TipoNotificacion.sincronizacionCompletada,
        titulo: ErrorMessages.get('ALERT_SYNC_OK'),
        mensaje: ErrorMessages.format('ALERT_SYNC_MSG', {
          'registros': registrosSincronizados.toString(),
        }),
        fechaCreacion: DateTime.now(),
        prioridad: PrioridadNotificacion.baja,
        data: {'registrosSincronizados': registrosSincronizados},
      );

      await _notificacionesRepo.crear(notificacion);
    } on Exception catch (e) {
      debugPrint('Error notificando sync: $e');
    }
  }

  /// Notifica bienvenida a nuevo usuario.
  Future<void> notificarBienvenida({
    required String usuarioId,
    required String nombreUsuario,
  }) async {
    try {
      final notificacion = Notificacion(
        id: '',
        usuarioId: usuarioId,
        tipo: TipoNotificacion.bienvenida,
        titulo: ErrorMessages.format('ALERT_BIENVENIDO', {
          'nombre': nombreUsuario,
        }),
        mensaje: ErrorMessages.get('ALERT_BIENVENIDO_MSG'),
        fechaCreacion: DateTime.now(),
        prioridad: PrioridadNotificacion.normal,
        data: {'nombreUsuario': nombreUsuario},
        accionUrl: AppRoutes.onboarding,
      );

      await _notificacionesRepo.crear(notificacion);
    } on Exception catch (e) {
      debugPrint('Error notificando bienvenida: $e');
    }
  }

  // ============================================================
  // MÉTODOS AUXILIARES
  // ============================================================

  /// Obtiene usuarios con roles específicos en una granja.
  Future<List<String>> _getUsuariosConRoles(
    String granjaId,
    List<RolGranja> roles,
  ) async {
    final rolesValues = roles.map((r) => r.name).toList();

    final snapshot = await _firestore
        .collection('granja_usuarios')
        .where('granjaId', isEqualTo: granjaId)
        .where('rol', whereIn: rolesValues)
        .where('activo', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => doc.data()['usuarioId'] as String)
        .toList();
  }

  /// Obtiene el nombre de una granja.
  Future<String> _getGranjaName(String granjaId) async {
    final doc = await _firestore.collection('granjas').doc(granjaId).get();
    return doc.data()?['nombre'] ?? 'Granja';
  }

  /// Obtiene el nombre de un lote.
  Future<String> _getLoteNombre(String granjaId, String loteId) async {
    final doc = await _firestore.collection('lotes').doc(loteId).get();
    final data = doc.data();
    return data?['codigo'] ?? data?['nombre'] ?? 'Lote';
  }

  /// Formatea una fecha para mostrar.
  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  /// Crea notificación para múltiples usuarios.
  Future<void> _crearNotificacion({
    required List<String> usuarioIds,
    required TipoNotificacion tipo,
    required String titulo,
    required String mensaje,
    required String granjaId,
    required String granjaName,
    required PrioridadNotificacion prioridad,
    Map<String, dynamic>? data,
    String? accionUrl,
  }) async {
    if (usuarioIds.isEmpty) return;

    final notificacion = Notificacion(
      id: '',
      usuarioId: '',
      tipo: tipo,
      titulo: titulo,
      mensaje: mensaje,
      fechaCreacion: DateTime.now(),
      granjaId: granjaId,
      granjaName: granjaName,
      prioridad: prioridad,
      data: data,
      accionUrl: accionUrl,
    );

    await _notificacionesRepo.crearParaMultiplesUsuarios(
      usuarioIds: usuarioIds,
      notificacionBase: notificacion,
    );

    // Enviar push notification para prioridades altas/urgentes
    if (prioridad == PrioridadNotificacion.alta ||
        prioridad == PrioridadNotificacion.urgente) {
      await Future.wait(
        usuarioIds.map(
          (usuarioId) => NotificationService.instance.crearNotificacionLocal(
            usuarioId: usuarioId,
            tipo: tipo,
            titulo: titulo,
            mensaje: mensaje,
            granjaId: granjaId,
            granjaName: granjaName,
          ),
        ),
      );
    }
  }

  // ============================================================
  // VERIFICACIONES PROGRAMADAS (SCHEDULER)
  // ============================================================

  /// Ejecuta todas las verificaciones periódicas para una granja.
  Future<void> ejecutarVerificacionesProgramadas(String granjaId) async {
    try {
      debugPrint('🔄 Ejecutando verificaciones para granja: $granjaId');

      await Future.wait([
        verificarStockBajo(granjaId),
        verificarVencimientos(granjaId),
        verificarLotesCierreProximo(granjaId),
        verificarLotesSinRegistros(granjaId),
        verificarVacunacionesProgramadas(granjaId),
        verificarInspeccionesPendientes(granjaId),
        verificarEntregasProgramadas(granjaId),
      ]);

      debugPrint('✅ Verificaciones completadas para: $granjaId');
    } on Exception catch (e) {
      debugPrint('Error en verificaciones: $e');
    }
  }

  /// Ejecuta verificaciones para todas las granjas activas.
  Future<void> ejecutarVerificacionesGlobales() async {
    try {
      final granjasSnapshot = await _firestore
          .collection('granjas')
          .where('activa', isEqualTo: true)
          .get();

      for (final granjaDoc in granjasSnapshot.docs) {
        await ejecutarVerificacionesProgramadas(granjaDoc.id);
      }
    } on Exception catch (e) {
      debugPrint('Error en verificaciones globales: $e');
    }
  }
}
