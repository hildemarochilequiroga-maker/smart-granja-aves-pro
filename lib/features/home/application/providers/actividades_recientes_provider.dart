/// Provider para actividades recientes del Home.
///
/// Combina todas las fuentes de datos de la app para mostrar
/// una línea de tiempo unificada de actividad reciente.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_messages.dart';

import '../../../../core/theme/app_colors.dart';

import '../../../galpones/domain/enums/tipo_evento_galpon.dart';
import '../../../inventario/domain/enums/enums.dart';

// =============================================================================
// TIPOS DE ACTIVIDAD
// =============================================================================

/// Tipos de actividad soportados.
enum TipoActividad {
  // Existentes
  inventario,
  venta,
  costo,
  salud,
  lote,
  // Registros de lotes
  produccion,
  mortalidad,
  consumo,
  peso,
  // Salud
  vacunacion,
  necropsia,
  inspeccion,
  // Galpones
  galponEvento,
}

// =============================================================================
// MODELO UNIFICADO
// =============================================================================

/// Modelo unificado de actividad reciente.
class ActividadReciente {
  const ActividadReciente({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.subtitulo,
    required this.fecha,
    required this.icono,
    required this.color,
    this.data,
    this.loteId,
    this.loteCodigo,
  });

  final String id;
  final TipoActividad tipo;
  final String titulo;
  final String subtitulo;
  final DateTime fecha;
  final IconData icono;
  final Color color;
  final dynamic data;
  final String? loteId;
  final String? loteCodigo;

  ActividadReciente copyWith({
    String? id,
    TipoActividad? tipo,
    String? titulo,
    String? subtitulo,
    DateTime? fecha,
    IconData? icono,
    Color? color,
    dynamic data,
    String? loteId,
    String? loteCodigo,
  }) {
    return ActividadReciente(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      subtitulo: subtitulo ?? this.subtitulo,
      fecha: fecha ?? this.fecha,
      icono: icono ?? this.icono,
      color: color ?? this.color,
      data: data ?? this.data,
      loteId: loteId ?? this.loteId,
      loteCodigo: loteCodigo ?? this.loteCodigo,
    );
  }

  /// Etiqueta corta para el badge.
  String get etiqueta => switch (tipo) {
    TipoActividad.inventario => 'INV',
    TipoActividad.venta => 'VTA',
    TipoActividad.costo => 'GTO',
    TipoActividad.salud => 'SAL',
    TipoActividad.lote => 'LTE',
    TipoActividad.produccion => 'PRD',
    TipoActividad.mortalidad => 'MRT',
    TipoActividad.consumo => 'CNS',
    TipoActividad.peso => 'PSO',
    TipoActividad.vacunacion => 'VAC',
    TipoActividad.necropsia => 'NEC',
    TipoActividad.inspeccion => 'BIO',
    TipoActividad.galponEvento => 'GLP',
  };
}

// =============================================================================
// PROVIDER DE ACTIVIDADES RECIENTES
// =============================================================================

/// Provider simplificado que combina streams usando un enfoque más eficiente.
/// Usa async* generator para emitir inmediatamente y luego refrescar periódicamente.
/// autoDispose: se cancela al salir del Home, evitando memory leak del Stream.periodic.
final actividadesRecientesSimpleProvider = StreamProvider.autoDispose
    .family<List<ActividadReciente>, String>((ref, granjaId) {
      return _actividadesRecientesStream(granjaId);
    });

/// Stream generator que emite inmediatamente y luego refresca cada 5 segundos.
Stream<List<ActividadReciente>> _actividadesRecientesStream(
  String granjaId,
) async* {
  final firestore = FirebaseFirestore.instance;

  // Función para obtener actividades
  Future<List<ActividadReciente>> fetchActividades() async {
    final actividades = <ActividadReciente>[];
    // Calcular fecha límite dentro del fetch para que siempre sea actual
    final hace7Dias = DateTime.now().subtract(const Duration(days: 7));
    final hace7DiasTimestamp = Timestamp.fromDate(hace7Dias);

    try {
      // Helper para ejecutar queries individuales sin que una falla mate a las demás
      Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> safeQuery(
        Future<QuerySnapshot<Map<String, dynamic>>> query,
        String label,
      ) async {
        try {
          final result = await query;
          return result.docs;
        } on Exception catch (e) {
          debugPrint('⚠️ Error en query $label: $e');
          return <QueryDocumentSnapshot<Map<String, dynamic>>>[];
        }
      }

      // Ejecutar todas las consultas en paralelo (cada una resiliente)
      final results = await Future.wait([
        // 0: Producción
        safeQuery(
          firestore
              .collectionGroup('produccion')
              .where('granjaId', isEqualTo: granjaId)
              .where('fecha', isGreaterThanOrEqualTo: hace7DiasTimestamp)
              .orderBy('fecha', descending: true)
              .limit(10)
              .get(),
          'produccion',
        ),
        // 1: Mortalidad
        safeQuery(
          firestore
              .collectionGroup('mortalidad')
              .where('granjaId', isEqualTo: granjaId)
              .where('fecha', isGreaterThanOrEqualTo: hace7DiasTimestamp)
              .orderBy('fecha', descending: true)
              .limit(10)
              .get(),
          'mortalidad',
        ),
        // 2: Consumo
        safeQuery(
          firestore
              .collectionGroup('consumos')
              .where('granjaId', isEqualTo: granjaId)
              .where('fecha', isGreaterThanOrEqualTo: hace7DiasTimestamp)
              .orderBy('fecha', descending: true)
              .limit(10)
              .get(),
          'consumos',
        ),
        // 3: Pesos
        safeQuery(
          firestore
              .collectionGroup('pesos')
              .where('granjaId', isEqualTo: granjaId)
              .where('fecha', isGreaterThanOrEqualTo: hace7DiasTimestamp)
              .orderBy('fecha', descending: true)
              .limit(10)
              .get(),
          'pesos',
        ),
        // 4: Inventario
        safeQuery(
          firestore
              .collection('inventario_movimientos')
              .where('granjaId', isEqualTo: granjaId)
              .where('fecha', isGreaterThan: hace7DiasTimestamp)
              .orderBy('fecha', descending: true)
              .limit(10)
              .get(),
          'inventario',
        ),
        // 5: Costos
        safeQuery(
          firestore
              .collection('costos_gastos')
              .where('granjaId', isEqualTo: granjaId)
              .where('fecha', isGreaterThan: hace7DiasTimestamp)
              .orderBy('fecha', descending: true)
              .limit(10)
              .get(),
          'costos',
        ),
        // 6: Ventas
        safeQuery(
          firestore
              .collection('ventas_productos')
              .where('granjaId', isEqualTo: granjaId)
              .where('fechaVenta', isGreaterThan: hace7DiasTimestamp)
              .orderBy('fechaVenta', descending: true)
              .limit(10)
              .get(),
          'ventas',
        ),
        // 7: Salud
        safeQuery(
          firestore
              .collection('salud_registros')
              .where('granjaId', isEqualTo: granjaId)
              .where('fecha', isGreaterThan: hace7DiasTimestamp)
              .orderBy('fecha', descending: true)
              .limit(10)
              .get(),
          'salud',
        ),
        // 8: Vacunaciones
        safeQuery(
          firestore
              .collection('vacunaciones')
              .where('granjaId', isEqualTo: granjaId)
              .where('aplicada', isEqualTo: true)
              .where(
                'fechaAplicacion',
                isGreaterThanOrEqualTo: hace7DiasTimestamp,
              )
              .orderBy('fechaAplicacion', descending: true)
              .limit(10)
              .get(),
          'vacunaciones_aplicadas',
        ),
        // 9: Vacunaciones programadas recientemente
        safeQuery(
          firestore
              .collection('vacunaciones')
              .where('granjaId', isEqualTo: granjaId)
              .where('aplicada', isEqualTo: false)
              .where(
                'fechaCreacion',
                isGreaterThanOrEqualTo: hace7DiasTimestamp,
              )
              .orderBy('fechaCreacion', descending: true)
              .limit(10)
              .get(),
          'vacunaciones_programadas',
        ),
        // 10: Lotes
        safeQuery(
          firestore
              .collection('lotes')
              .where('granjaId', isEqualTo: granjaId)
              .where('fechaIngreso', isGreaterThanOrEqualTo: hace7DiasTimestamp)
              .orderBy('fechaIngreso', descending: true)
              .limit(5)
              .get(),
          'lotes',
        ),
        // 11: Eventos galpones
        safeQuery(
          firestore
              .collection('galpon_eventos')
              .where('granjaId', isEqualTo: granjaId)
              .where('fecha', isGreaterThanOrEqualTo: hace7DiasTimestamp)
              .orderBy('fecha', descending: true)
              .limit(10)
              .get(),
          'galpon_eventos',
        ),
        // 12: Necropsias
        safeQuery(
          firestore
              .collectionGroup('necropsias')
              .where('granjaId', isEqualTo: granjaId)
              .where('fecha', isGreaterThanOrEqualTo: hace7DiasTimestamp)
              .orderBy('fecha', descending: true)
              .limit(10)
              .get(),
          'necropsias',
        ),
        // 13: Inspecciones de bioseguridad
        safeQuery(
          firestore
              .collectionGroup('inspecciones_bioseguridad')
              .where('granjaId', isEqualTo: granjaId)
              .where(
                'fecha',
                isGreaterThanOrEqualTo: hace7Dias.toUtc().toIso8601String(),
              )
              .orderBy('fecha', descending: true)
              .limit(10)
              .get(),
          'inspecciones',
        ),
      ]);

      // Procesar cada resultado
      // 0: Producción
      for (final doc in results[0]) {
        final data = doc.data();
        final fecha =
            _readDateTime(data['fecha']) ?? _readDateTime(data['createdAt']);
        if (fecha == null) {
          continue;
        }
        actividades.add(
          ActividadReciente(
            id: 'prod_${doc.id}',
            tipo: TipoActividad.produccion,
            titulo: ErrorMessages.get('ACT_PRODUCCION_REGISTRADA'),
            subtitulo: ErrorMessages.format('ACT_SUB_HUEVOS', {
              'count': '${data['huevosRecolectados'] ?? 0}',
            }),
            fecha: fecha,
            icono: Icons.egg_alt,
            color: AppColors.warning,
            data: data,
            loteId: data['loteId'] as String?,
          ),
        );
      }

      // 1: Mortalidad
      for (final doc in results[1]) {
        final data = doc.data();
        final fecha =
            _readDateTime(data['fecha']) ?? _readDateTime(data['createdAt']);
        if (fecha == null) {
          continue;
        }
        actividades.add(
          ActividadReciente(
            id: 'mort_${doc.id}',
            tipo: TipoActividad.mortalidad,
            titulo: ErrorMessages.get('ACT_MORTALIDAD_REGISTRADA'),
            subtitulo: ErrorMessages.format('ACT_SUB_AVES', {
              'count': '${data['cantidad'] ?? 0}',
            }),
            fecha: fecha,
            icono: Icons.warning_amber,
            color: AppColors.error,
            data: data,
            loteId: data['loteId'] as String?,
          ),
        );
      }

      // 2: Consumo
      for (final doc in results[2]) {
        final data = doc.data();
        final fecha =
            _readDateTime(data['fecha']) ?? _readDateTime(data['createdAt']);
        if (fecha == null) {
          continue;
        }
        final kg = (data['cantidadKg'] as num?)?.toDouble() ?? 0;
        actividades.add(
          ActividadReciente(
            id: 'cons_${doc.id}',
            tipo: TipoActividad.consumo,
            titulo: ErrorMessages.get('ACT_CONSUMO_REGISTRADO'),
            subtitulo: '${kg.toStringAsFixed(1)} kg',
            fecha: fecha,
            icono: Icons.restaurant,
            color: AppColors.success,
            data: data,
            loteId: data['loteId'] as String?,
          ),
        );
      }

      // 3: Pesos
      for (final doc in results[3]) {
        final data = doc.data();
        final fecha =
            _readDateTime(data['fecha']) ?? _readDateTime(data['createdAt']);
        if (fecha == null) {
          continue;
        }
        final peso = (data['pesoPromedio'] as num?)?.toDouble() ?? 0;
        actividades.add(
          ActividadReciente(
            id: 'peso_${doc.id}',
            tipo: TipoActividad.peso,
            titulo: ErrorMessages.get('ACT_PESAJE_REGISTRADO'),
            subtitulo: ErrorMessages.format('ACT_SUB_PROMEDIO', {
              'peso': peso.toStringAsFixed(0),
            }),
            fecha: fecha,
            icono: Icons.scale,
            color: AppColors.purple,
            data: data,
            loteId: data['loteId'] as String?,
          ),
        );
      }

      // 4: Inventario
      for (final doc in results[4]) {
        final data = doc.data();
        final fecha =
            _readDateTime(data['fecha']) ??
            _readDateTime(data['fechaRegistro']);
        if (fecha == null) {
          continue;
        }
        final tipo = TipoMovimiento.values.firstWhere(
          (t) => t.toJson() == data['tipo'],
          orElse: () => TipoMovimiento.usoGeneral,
        );
        final cantidad = (data['cantidad'] as num?)?.toDouble() ?? 0;
        actividades.add(
          ActividadReciente(
            id: 'inv_${doc.id}',
            tipo: TipoActividad.inventario,
            titulo: _getTituloMovimiento(tipo),
            subtitulo:
                ErrorMessages.format('ACT_SUB_INVENTARIO', {'signo': tipo.esEntrada ? '+' : '-', 'cantidad': cantidad.toStringAsFixed(1)}),
            fecha: fecha,
            icono: _getIconMovimiento(tipo),
            color: tipo.esEntrada ? AppColors.success : AppColors.warning,
            data: data,
            loteId: data['loteId'] as String?,
          ),
        );
      }

      // 5: Costos
      for (final doc in results[5]) {
        final data = doc.data();
        final fecha =
            _readDateTime(data['fecha']) ??
            _readDateTime(data['fechaRegistro']);
        if (fecha == null) {
          continue;
        }
        final monto = (data['monto'] as num?)?.toDouble() ?? 0;
        actividades.add(
          ActividadReciente(
            id: 'costo_${doc.id}',
            tipo: TipoActividad.costo,
            titulo: ErrorMessages.get('ACT_GASTO_REGISTRADO'),
            subtitulo: '\$${monto.toStringAsFixed(2)}',
            fecha: fecha,
            icono: Icons.attach_money,
            color: AppColors.error,
            data: data,
            loteId: data['loteId'] as String?,
          ),
        );
      }

      // 6: Ventas
      for (final doc in results[6]) {
        final data = doc.data();
        final fecha = _readDateTime(data['fechaVenta']);
        if (fecha == null) {
          continue;
        }
        final tipoProducto = data['tipoProducto'] as String? ?? 'producto';
        final tipoLabel = switch (tipoProducto) {
          'avesVivas' => ErrorMessages.get('ACT_VENTA_AVES_VIVAS'),
          'avesFaenadas' => ErrorMessages.get('ACT_VENTA_AVES_FAENADAS'),
          'avesDescarte' => ErrorMessages.get('ACT_VENTA_AVES_DESCARTE'),
          'huevos' => ErrorMessages.get('ACT_VENTA_HUEVOS'),
          'pollinaza' => ErrorMessages.get('ACT_VENTA_POLLINAZA'),
          _ => tipoProducto,
        };
        actividades.add(
          ActividadReciente(
            id: 'venta_${doc.id}',
            tipo: TipoActividad.venta,
            titulo: ErrorMessages.get('ACT_VENTA_REGISTRADA'),
            subtitulo: tipoLabel,
            fecha: fecha,
            icono: Icons.point_of_sale,
            color: AppColors.info,
            data: data,
            loteId: data['loteId'] as String?,
          ),
        );
      }

      // 7: Salud
      for (final doc in results[7]) {
        final data = doc.data();
        final fecha =
            _readDateTime(data['fecha']) ??
            _readDateTime(data['fechaCreacion']);
        if (fecha == null) {
          continue;
        }
        final diagnostico = data['diagnostico'] as String? ?? ErrorMessages.get('ACT_FALLBACK_REGISTRO');
        actividades.add(
          ActividadReciente(
            id: 'salud_${doc.id}',
            tipo: TipoActividad.salud,
            titulo: ErrorMessages.get('ACT_REGISTRO_SALUD'),
            subtitulo: diagnostico,
            fecha: fecha,
            icono: Icons.medical_services,
            color: AppColors.teal,
            data: data,
            loteId: data['loteId'] as String?,
          ),
        );
      }

      // 8: Vacunaciones aplicadas
      for (final doc in results[8]) {
        final data = doc.data();
        final fecha =
            _readDateTime(data['fechaAplicacion']) ??
            _readDateTime(data['fechaProgramada']);
        if (fecha == null) {
          continue;
        }
        final nombreVacuna = data['nombreVacuna'] as String? ?? ErrorMessages.get('ACT_FALLBACK_VACUNA');
        actividades.add(
          ActividadReciente(
            id: 'vac_${doc.id}',
            tipo: TipoActividad.vacunacion,
            titulo: ErrorMessages.get('ACT_VACUNACION_APLICADA'),
            subtitulo: nombreVacuna,
            fecha: fecha,
            icono: Icons.vaccines,
            color: AppColors.success,
            data: data,
            loteId: data['loteId'] as String?,
          ),
        );
      }

      // 9: Vacunaciones programadas recientemente
      for (final doc in results[9]) {
        final data = doc.data();
        final fecha =
            _readDateTime(data['fechaCreacion']) ??
            _readDateTime(data['fechaProgramada']);
        if (fecha == null) {
          continue;
        }
        final nombreVacuna = data['nombreVacuna'] as String? ?? ErrorMessages.get('ACT_FALLBACK_VACUNA');
        actividades.add(
          ActividadReciente(
            id: 'vac_prog_${doc.id}',
            tipo: TipoActividad.vacunacion,
            titulo: ErrorMessages.get('ACT_VACUNACION_PROGRAMADA'),
            subtitulo: nombreVacuna,
            fecha: fecha,
            icono: Icons.event_available,
            color: AppColors.deepPurple,
            data: data,
            loteId: data['loteId'] as String?,
          ),
        );
      }

      // 10: Lotes
      for (final doc in results[10]) {
        final data = doc.data();
        final fecha =
            _readDateTime(data['fechaIngreso']) ??
            _readDateTime(data['fechaCreacion']);
        if (fecha == null) {
          continue;
        }
        final codigo = data['codigo'] as String? ?? 'Lote';
        final cantidad = data['cantidadInicial'] ?? 0;
        actividades.add(
          ActividadReciente(
            id: 'lote_${doc.id}',
            tipo: TipoActividad.lote,
            titulo: ErrorMessages.get('ACT_NUEVO_LOTE'),
            subtitulo: ErrorMessages.format('ACT_SUB_LOTE_DETALLE', {
              'codigo': codigo,
              'cantidad': '$cantidad',
            }),
            fecha: fecha,
            icono: Icons.egg_alt_outlined,
            color: AppColors.deepOrange,
            data: data,
            loteId: doc.id,
            loteCodigo: codigo,
          ),
        );
      }

      // 11: Eventos galpones
      for (final doc in results[11]) {
        final data = doc.data();
        final fecha = _readDateTime(data['fecha']);
        if (fecha == null) {
          continue;
        }
        final tipoStr = data['tipo'] as String? ?? 'otro';
        final tipo = TipoEventoGalpon.values.firstWhere(
          (t) => t.name == tipoStr,
          orElse: () => TipoEventoGalpon.otro,
        );
        actividades.add(
          ActividadReciente(
            id: 'gev_${doc.id}',
            tipo: TipoActividad.galponEvento,
            titulo: _getTituloEvento(tipo),
            subtitulo: data['descripcion'] as String? ?? ErrorMessages.get('ACT_FALLBACK_EVENTO'),
            fecha: fecha,
            icono: _getIconEvento(tipo),
            color: _getColorEvento(tipo),
            data: data,
            loteId: data['loteId'] as String?,
          ),
        );
      }

      // 12: Necropsias
      for (final doc in results[12]) {
        final data = doc.data();
        final fecha =
            _readDateTime(data['fecha']) ??
            _readDateTime(data['fechaCreacion']);
        if (fecha == null) {
          continue;
        }
        final numAves = data['numeroAvesExaminadas'] ?? 0;
        final diagnostico =
            data['diagnosticoPresuntivo'] as String? ??
            data['diagnosticoConfirmado'] as String? ??
            ErrorMessages.get('ACT_FALLBACK_EN_EVALUACION');
        actividades.add(
          ActividadReciente(
            id: 'nec_${doc.id}',
            tipo: TipoActividad.necropsia,
            titulo: ErrorMessages.get('ACT_NECROPSIA_REALIZADA'),
            subtitulo: ErrorMessages.format('ACT_SUB_NECROPSIA', {
              'numAves': '$numAves',
              'diagnostico': diagnostico,
            }),
            fecha: fecha,
            icono: Icons.biotech,
            color: AppColors.brown,
            data: data,
            loteId: data['loteId'] as String?,
          ),
        );
      }

      // 13: Inspecciones de bioseguridad
      for (final doc in results[13]) {
        final data = doc.data();
        // El puntaje es derivado; se recalcula desde los items persistidos.
        final items = (data['items'] as List<dynamic>?) ?? [];
        final cumple = items
            .where((i) => (i as Map<String, dynamic>)['estado'] == 'cumple')
            .length;
        final parcial = items
            .where((i) => (i as Map<String, dynamic>)['estado'] == 'parcial')
            .length;
        final evaluables = items
            .where(
              (i) =>
                  (i as Map<String, dynamic>)['estado'] != 'noAplica' &&
                  i['estado'] != 'pendiente',
            )
            .length;
        final puntaje = evaluables > 0
            ? (((cumple + (parcial * 0.5)) / evaluables) * 100).round()
            : 100;
        final inspector = data['inspectorNombre'] as String? ?? ErrorMessages.get('ACT_FALLBACK_INSPECTOR');
        final fechaInsp =
            _readDateTime(data['fecha']) ??
            _readDateTime(data['fechaInspeccion']) ??
            _readDateTime(data['fechaCreacion']);
        if (fechaInsp == null) {
          continue;
        }
        actividades.add(
          ActividadReciente(
            id: 'insp_${doc.id}',
            tipo: TipoActividad.inspeccion,
            titulo: ErrorMessages.get('ACT_INSPECCION_BIOSEGURIDAD'),
            subtitulo: ErrorMessages.format('ACT_SUB_PUNTAJE', {
              'puntaje': '$puntaje',
              'inspector': inspector,
            }),
            fecha: fechaInsp,
            icono: Icons.checklist_rtl,
            color: puntaje >= 80
                ? AppColors.success
                : puntaje >= 60
                ? AppColors.warning
                : AppColors.error,
            data: data,
          ),
        );
      }
    } catch (e, stack) {
      // Log error para debugging pero no interrumpir el stream
      debugPrint('Error cargando actividades recientes: $e');
      debugPrint('Stack: $stack');
    }

    final codigosLote = await _cargarCodigosLote(
      firestore,
      actividades.map((actividad) => actividad.loteId),
    );

    final actividadesEnriquecidas = actividades.map((actividad) {
      final loteId = actividad.loteId;
      final loteCodigo =
          actividad.loteCodigo ?? (loteId != null ? codigosLote[loteId] : null);

      if (loteCodigo == null || loteCodigo == actividad.loteCodigo) {
        return actividad;
      }

      return actividad.copyWith(loteCodigo: loteCodigo);
    }).toList();

    // Ordenar y limitar
    actividadesEnriquecidas.sort((a, b) => b.fecha.compareTo(a.fecha));
    return actividadesEnriquecidas.take(15).toList();
  }

  // Emitir inmediatamente la primera vez
  yield await fetchActividades();

  // Luego refrescar cada 60 segundos (14 queries por ciclo — 5s era demasiado agresivo)
  await for (final _ in Stream.periodic(const Duration(seconds: 60))) {
    yield await fetchActividades();
  }
}

// =============================================================================
// HELPERS
// =============================================================================

String _getTituloMovimiento(TipoMovimiento tipo) {
  return switch (tipo) {
    TipoMovimiento.compra => ErrorMessages.get('ACT_MOV_COMPRA'),
    TipoMovimiento.donacion => ErrorMessages.get('ACT_MOV_DONACION'),
    TipoMovimiento.consumoLote => ErrorMessages.get('ACT_MOV_CONSUMO_LOTE'),
    TipoMovimiento.tratamiento => ErrorMessages.get('ACT_MOV_TRATAMIENTO'),
    TipoMovimiento.vacunacion => ErrorMessages.get('ACT_MOV_VACUNACION'),
    TipoMovimiento.ajustePositivo => ErrorMessages.get('ACT_MOV_AJUSTE_POS'),
    TipoMovimiento.ajusteNegativo => ErrorMessages.get('ACT_MOV_AJUSTE_NEG'),
    TipoMovimiento.devolucion => ErrorMessages.get('ACT_MOV_DEVOLUCION'),
    TipoMovimiento.merma => ErrorMessages.get('ACT_MOV_MERMA'),
    TipoMovimiento.transferencia => ErrorMessages.get('ACT_MOV_TRANSFERENCIA'),
    TipoMovimiento.usoGeneral => ErrorMessages.get('ACT_MOV_USO_GENERAL'),
    TipoMovimiento.venta => ErrorMessages.get('ACT_MOV_VENTA'),
  };
}

IconData _getIconMovimiento(TipoMovimiento tipo) {
  return switch (tipo) {
    TipoMovimiento.compra => Icons.add_circle_outline,
    TipoMovimiento.donacion => Icons.card_giftcard,
    TipoMovimiento.consumoLote => Icons.restaurant,
    TipoMovimiento.tratamiento => Icons.medical_services,
    TipoMovimiento.vacunacion => Icons.vaccines,
    TipoMovimiento.ajustePositivo => Icons.trending_up,
    TipoMovimiento.ajusteNegativo => Icons.trending_down,
    TipoMovimiento.devolucion => Icons.undo,
    TipoMovimiento.merma => Icons.warning,
    TipoMovimiento.transferencia => Icons.swap_horiz,
    TipoMovimiento.usoGeneral => Icons.remove_circle_outline,
    TipoMovimiento.venta => Icons.point_of_sale,
  };
}

String _getTituloEvento(TipoEventoGalpon tipo) {
  return switch (tipo) {
    TipoEventoGalpon.desinfeccion => ErrorMessages.get('ACT_EVT_DESINFECCION'),
    TipoEventoGalpon.mantenimiento => ErrorMessages.get(
      'ACT_EVT_MANTENIMIENTO',
    ),
    TipoEventoGalpon.cambioEstado => ErrorMessages.get('ACT_EVT_CAMBIO_ESTADO'),
    TipoEventoGalpon.creacion => ErrorMessages.get('ACT_EVT_GALPON_CREADO'),
    TipoEventoGalpon.asignacionLote => ErrorMessages.get(
      'ACT_EVT_LOTE_ASIGNADO',
    ),
    TipoEventoGalpon.liberacionLote => ErrorMessages.get(
      'ACT_EVT_LOTE_LIBERADO',
    ),
    TipoEventoGalpon.otro => ErrorMessages.get('ACT_EVT_EVENTO'),
  };
}

IconData _getIconEvento(TipoEventoGalpon tipo) {
  return switch (tipo) {
    TipoEventoGalpon.desinfeccion => Icons.cleaning_services,
    TipoEventoGalpon.mantenimiento => Icons.build,
    TipoEventoGalpon.cambioEstado => Icons.swap_horizontal_circle,
    TipoEventoGalpon.creacion => Icons.add_home,
    TipoEventoGalpon.asignacionLote => Icons.login,
    TipoEventoGalpon.liberacionLote => Icons.logout,
    TipoEventoGalpon.otro => Icons.event,
  };
}

Color _getColorEvento(TipoEventoGalpon tipo) {
  return switch (tipo) {
    TipoEventoGalpon.desinfeccion => AppColors.cyan,
    TipoEventoGalpon.mantenimiento => AppColors.amber,
    TipoEventoGalpon.cambioEstado => AppColors.indigo,
    TipoEventoGalpon.creacion => AppColors.success,
    TipoEventoGalpon.asignacionLote => AppColors.info,
    TipoEventoGalpon.liberacionLote => AppColors.warning,
    TipoEventoGalpon.otro => AppColors.grey500,
  };
}

DateTime? _readDateTime(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}

Future<Map<String, String>> _cargarCodigosLote(
  FirebaseFirestore firestore,
  Iterable<String?> loteIds,
) async {
  final ids = loteIds.whereType<String>().where((id) => id.isNotEmpty).toSet();
  if (ids.isEmpty) {
    return const {};
  }

  final entradas = await Future.wait(
    ids.map((id) async {
      try {
        final snapshot = await firestore.collection('lotes').doc(id).get();
        final data = snapshot.data();
        final codigo = data?['codigo'] as String?;

        if (codigo == null || codigo.trim().isEmpty) {
          return null;
        }

        return MapEntry(id, codigo);
      } on Exception catch (e) {
        debugPrint('⚠️ Error cargando código de lote $id: $e');
        return null;
      }
    }),
  );

  return {
    for (final entrada in entradas)
      if (entrada != null) entrada.key: entrada.value,
  };
}
