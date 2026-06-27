/// Reconciliador de integraciones de inventario pendientes.
///
/// Reintenta las integraciones que fallaron por un problema transitorio y
/// quedaron encoladas en `integraciones_pendientes`, de modo que el inventario
/// termine sincronizado con el dato primario (costo, consumo, venta, etc.)
/// sin intervención del usuario. Se dispara de forma oportunista al abrir
/// el inventario o con pull-to-refresh.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/value_objects/resultado_integracion.dart';
import '../../infrastructure/datasources/integracion_pendiente_datasource.dart';
import 'inventario_integracion_service.dart';

/// Provider del reconciliador.
final inventarioReconciliadorProvider = Provider<InventarioReconciliador>((
  ref,
) {
  return InventarioReconciliador(
    IntegracionPendienteDatasource(FirebaseFirestore.instance),
    ref.read(inventarioIntegracionServiceProvider),
  );
});

/// Resultado de una pasada de reconciliación.
class ResultadoReconciliacion {
  const ResultadoReconciliacion({
    required this.procesadas,
    required this.resueltas,
    required this.aunPendientes,
  });

  /// Total de pendientes que se intentaron en esta pasada.
  final int procesadas;

  /// Cuántas quedaron resueltas (y eliminadas de la cola).
  final int resueltas;

  /// Cuántas siguen pendientes tras esta pasada.
  final int aunPendientes;

  bool get huboTrabajo => procesadas > 0;
}

/// Reintenta integraciones de inventario encoladas.
class InventarioReconciliador {
  InventarioReconciliador(this._pendientes, this._servicio);

  final IntegracionPendienteDatasource _pendientes;
  final InventarioIntegracionService _servicio;

  /// Evita pasadas concurrentes (p. ej. abrir inventario y refrescar a la vez).
  bool _enCurso = false;

  /// Procesa las pendientes reintentables de una granja.
  ///
  /// Para cada pendiente:
  /// - éxito / omitido / fallo de negocio → se elimina de la cola (es terminal:
  ///   reintentar no cambiaría el desenlace).
  /// - pendiente de reintento (sigue fallando por red) → se incrementa su
  ///   contador; si agota [maxIntentos] dejará de tomarse en próximas pasadas.
  Future<ResultadoReconciliacion> reconciliarGranja(String granjaId) async {
    if (_enCurso) {
      return const ResultadoReconciliacion(
        procesadas: 0,
        resueltas: 0,
        aunPendientes: 0,
      );
    }
    _enCurso = true;
    try {
      final pendientes = await _pendientes.obtenerReintentables(granjaId);
      var resueltas = 0;
      var siguenPendientes = 0;

      for (final pendiente in pendientes) {
        try {
          final resultado = await _servicio.reejecutar(pendiente);
          switch (resultado.estado) {
            case EstadoIntegracion.exitoso:
            case EstadoIntegracion.omitido:
            case EstadoIntegracion.fallidoNegocio:
              await _pendientes.eliminar(pendiente.id);
              resueltas++;
            case EstadoIntegracion.pendienteReintento:
              await _pendientes.registrarIntentoFallido(
                pendiente.id,
                resultado.razon ?? 'reintento fallido',
              );
              siguenPendientes++;
          }
        } on Exception catch (e) {
          // Falló incluso el manejo: contar como aún pendiente.
          await _pendientes.registrarIntentoFallido(pendiente.id, e.toString());
          siguenPendientes++;
        }
      }

      return ResultadoReconciliacion(
        procesadas: pendientes.length,
        resueltas: resueltas,
        aunPendientes: siguenPendientes,
      );
    } on Exception catch (e) {
      debugPrint('Error reconciliando inventario: $e');
      return const ResultadoReconciliacion(
        procesadas: 0,
        resueltas: 0,
        aunPendientes: 0,
      );
    } finally {
      _enCurso = false;
    }
  }
}
