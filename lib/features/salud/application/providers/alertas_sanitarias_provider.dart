/// Providers para alertas sanitarias.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/core/errors/error_messages.dart';
import '../../domain/entities/entities.dart';
import '../../infrastructure/datasources/alerta_sanitaria_datasource.dart';

// Datasource provider
final alertaSanitariaDatasourceProvider = Provider<AlertaSanitariaDatasource>((
  ref,
) {
  return AlertaSanitariaDatasource(firestore: FirebaseFirestore.instance);
});

/// Estado de alertas sanitarias.
class AlertasSanitariasState {
  final List<AlertaSanitaria> alertas;
  final List<AlertaSanitaria> alertasActivas;
  final bool isLoading;
  final String? error;
  final UmbralesAlerta umbrales;

  const AlertasSanitariasState({
    this.alertas = const [],
    this.alertasActivas = const [],
    this.isLoading = false,
    this.error,
    this.umbrales = const UmbralesAlerta(),
  });

  factory AlertasSanitariasState.initial() {
    return const AlertasSanitariasState();
  }

  AlertasSanitariasState copyWith({
    List<AlertaSanitaria>? alertas,
    List<AlertaSanitaria>? alertasActivas,
    bool? isLoading,
    String? error,
    UmbralesAlerta? umbrales,
  }) {
    return AlertasSanitariasState(
      alertas: alertas ?? this.alertas,
      alertasActivas: alertasActivas ?? this.alertasActivas,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      umbrales: umbrales ?? this.umbrales,
    );
  }

  /// Cuenta de alertas por nivel.
  Map<NivelAlerta, int> get conteosPorNivel {
    final Map<NivelAlerta, int> conteos = {};
    for (final alerta in alertasActivas) {
      conteos[alerta.nivel] = (conteos[alerta.nivel] ?? 0) + 1;
    }
    return conteos;
  }

  /// Alertas críticas activas.
  List<AlertaSanitaria> get alertasCriticasActivas {
    return alertasActivas.where((a) => a.esCritica).toList();
  }

  /// Tiene alertas críticas sin resolver.
  bool get tieneAlertasCriticas => alertasCriticasActivas.isNotEmpty;
}

/// Notifier para gestión de alertas sanitarias.
class AlertasSanitariasNotifier extends StateNotifier<AlertasSanitariasState> {
  final AlertaSanitariaDatasource _datasource;
  String? _granjaId;

  AlertasSanitariasNotifier(this._datasource)
    : super(AlertasSanitariasState.initial());

  /// Carga alertas de una granja.
  Future<void> cargarAlertas(String granjaId) async {
    _granjaId = granjaId;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final alertas = await _datasource.obtenerAlertas(granjaId);
      final alertasActivas = await _datasource.obtenerAlertasActivas(granjaId);
      state = state.copyWith(
        alertas: alertas,
        alertasActivas: alertasActivas,
        isLoading: false,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorMessages.format('ERR_LOADING_ALERTS', {'e': '$e'}),
      );
    }
  }

  /// Genera una alerta manual.
  Future<void> generarAlerta({
    required String granjaId,
    required TipoAlertaSanitaria tipo,
    required NivelAlerta nivel,
    required String titulo,
    required String descripcion,
    String? galponId,
    String? loteId,
    String? recomendaciones,
  }) async {
    final alerta = AlertaSanitaria(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      granjaId: granjaId,
      galponId: galponId,
      loteId: loteId,
      tipo: tipo,
      nivel: nivel,
      titulo: titulo,
      descripcion: descripcion,
      fechaGeneracion: DateTime.now(),
      indicadores: const [],
      estado: EstadoAlerta.activa,
      recomendaciones: recomendaciones,
      generadoAutomaticamente: false,
      fechaCreacion: DateTime.now(),
    );

    state = state.copyWith(
      alertas: [...state.alertas, alerta],
      alertasActivas: [...state.alertasActivas, alerta],
    );

    // Persistir en Firestore
    try {
      await _datasource.crearAlerta(alerta);
    } catch (_) {
      // Alerta ya se muestra en UI, error de persistencia es secundario
    }
  }

  /// Genera alertas automáticas basadas en indicadores.
  Future<void> verificarIndicadores({
    required String granjaId,
    required String loteId,
    required double mortalidadDiaria,
    required double consumoAgua,
    required double consumoAlimento,
    double? temperatura,
    double? humedad,
  }) async {
    final List<AlertaSanitaria> nuevasAlertas = [];
    final umbrales = state.umbrales;

    // Verificar mortalidad
    if (mortalidadDiaria > umbrales.mortalidadDiariaMaxima) {
      nuevasAlertas.add(
        AlertaSanitaria(
          id: 'mort_${DateTime.now().millisecondsSinceEpoch}',
          granjaId: granjaId,
          loteId: loteId,
          tipo: TipoAlertaSanitaria.mortalidadElevada,
          nivel: mortalidadDiaria > umbrales.mortalidadDiariaMaxima * 2
              ? NivelAlerta.critico
              : NivelAlerta.alerta,
          titulo: ErrorMessages.get('ALERT_HIGH_MORTALITY_TITLE'),
          descripcion:
              ErrorMessages.format('ALERT_HIGH_MORTALITY_DESC', {
                'rate': '$mortalidadDiaria',
                'threshold': '${umbrales.mortalidadDiariaMaxima}',
              }),
          fechaGeneracion: DateTime.now(),
          indicadores: [
            IndicadorAlerta(
              nombre: ErrorMessages.get('ALERT_MORTALITY_INDICATOR'),
              valorActual: mortalidadDiaria,
              valorEsperado: umbrales.mortalidadDiariaMaxima * 0.5,
              umbral: umbrales.mortalidadDiariaMaxima,
              unidad: '%',
              tipoDesviacion: TipoDesviacion.superior,
            ),
          ],
          estado: EstadoAlerta.activa,
          recomendaciones:
              ErrorMessages.get('ALERT_MORTALITY_REC'),
          generadoAutomaticamente: true,
          fechaCreacion: DateTime.now(),
        ),
      );
    }

    // Verificar temperatura
    if (temperatura != null &&
        (temperatura < umbrales.temperaturaMinima ||
            temperatura > umbrales.temperaturaMaxima)) {
      nuevasAlertas.add(
        AlertaSanitaria(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
          granjaId: granjaId,
          loteId: loteId,
          tipo: TipoAlertaSanitaria.temperaturaAnormal,
          nivel: NivelAlerta.alerta,
          titulo: ErrorMessages.get('ALERT_ABNORMAL_TEMP_TITLE'),
          descripcion:
              ErrorMessages.format('ALERT_ABNORMAL_TEMP_DESC', {
                'temp': '$temperatura',
                'min': '${umbrales.temperaturaMinima}',
                'max': '${umbrales.temperaturaMaxima}',
              }),
          fechaGeneracion: DateTime.now(),
          indicadores: [
            IndicadorAlerta(
              nombre: ErrorMessages.get('ALERT_TEMP_INDICATOR'),
              valorActual: temperatura,
              valorEsperado:
                  (umbrales.temperaturaMinima + umbrales.temperaturaMaxima) / 2,
              umbral: temperatura < umbrales.temperaturaMinima
                  ? umbrales.temperaturaMinima
                  : umbrales.temperaturaMaxima,
              unidad: '°C',
              tipoDesviacion: temperatura < umbrales.temperaturaMinima
                  ? TipoDesviacion.inferior
                  : TipoDesviacion.superior,
            ),
          ],
          estado: EstadoAlerta.activa,
          recomendaciones:
              ErrorMessages.get('ALERT_TEMP_REC'),
          generadoAutomaticamente: true,
          fechaCreacion: DateTime.now(),
        ),
      );
    }

    if (nuevasAlertas.isNotEmpty) {
      state = state.copyWith(
        alertas: [...state.alertas, ...nuevasAlertas],
        alertasActivas: [...state.alertasActivas, ...nuevasAlertas],
      );

      // Persistir alertas automáticas en Firestore
      for (final alerta in nuevasAlertas) {
        try {
          await _datasource.crearAlerta(alerta);
        } catch (_) {
          // Error de persistencia no debe bloquear la UI
        }
      }
    }
  }

  /// Resuelve una alerta.
  Future<void> resolverAlerta({
    required String alertaId,
    required String resolvedPor,
    required String comentario,
  }) async {
    final alertas = state.alertas.map((a) {
      if (a.id == alertaId) {
        return a.copyWith(
          estado: EstadoAlerta.resuelta,
          fechaResolucion: DateTime.now(),
          resolvedPor: resolvedPor,
          comentarioResolucion: comentario,
        );
      }
      return a;
    }).toList();

    state = state.copyWith(
      alertas: alertas,
      alertasActivas: alertas.where((a) => a.estaActiva).toList(),
    );

    // Persistir en Firestore
    if (_granjaId != null) {
      await _datasource.resolverAlerta(
        granjaId: _granjaId!,
        alertaId: alertaId,
        resolvedPor: resolvedPor,
        comentario: comentario,
        nuevoEstado: EstadoAlerta.resuelta,
      );
    }
  }

  /// Descarta una alerta como falsa alarma.
  Future<void> descartarAlerta({
    required String alertaId,
    required String resolvedPor,
    required String motivo,
  }) async {
    final alertas = state.alertas.map((a) {
      if (a.id == alertaId) {
        return a.copyWith(
          estado: EstadoAlerta.descartada,
          fechaResolucion: DateTime.now(),
          resolvedPor: resolvedPor,
          comentarioResolucion: motivo,
        );
      }
      return a;
    }).toList();

    state = state.copyWith(
      alertas: alertas,
      alertasActivas: alertas.where((a) => a.estaActiva).toList(),
    );

    // Persistir en Firestore
    if (_granjaId != null) {
      await _datasource.resolverAlerta(
        granjaId: _granjaId!,
        alertaId: alertaId,
        resolvedPor: resolvedPor,
        comentario: motivo,
        nuevoEstado: EstadoAlerta.descartada,
      );
    }
  }

  /// Actualiza los umbrales de alerta.
  void actualizarUmbrales(UmbralesAlerta nuevosUmbrales) {
    state = state.copyWith(umbrales: nuevosUmbrales);
  }

  /// Limpia el error.
  void limpiarError() {
    state = state.copyWith(error: null);
  }
}

/// Provider del notifier de alertas sanitarias.
final alertasSanitariasProvider =
    StateNotifierProvider.autoDispose<
      AlertasSanitariasNotifier,
      AlertasSanitariasState
    >((ref) {
      final datasource = ref.watch(alertaSanitariaDatasourceProvider);
      return AlertasSanitariasNotifier(datasource);
    });

/// Provider de alertas activas.
final alertasActivasProvider = Provider<List<AlertaSanitaria>>((ref) {
  final state = ref.watch(alertasSanitariasProvider);
  return state.alertasActivas;
});

/// Provider de alertas críticas.
final alertasCriticasProvider = Provider<List<AlertaSanitaria>>((ref) {
  final state = ref.watch(alertasSanitariasProvider);
  return state.alertasCriticasActivas;
});

/// Provider de conteo de alertas por nivel.
final conteoAlertasPorNivelProvider = Provider<Map<NivelAlerta, int>>((ref) {
  final state = ref.watch(alertasSanitariasProvider);
  return state.conteosPorNivel;
});
