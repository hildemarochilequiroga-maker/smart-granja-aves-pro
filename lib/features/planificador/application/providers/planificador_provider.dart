/// Proveedores Riverpod del Planificador Avícola.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/plan_avicola.dart';
import '../../domain/enums/raza_ave.dart';
import '../../domain/enums/zona_climatica.dart';
import '../services/planificador_service.dart';

// =============================================================================
// FORM STATE
// =============================================================================

/// Estado del formulario del planificador.
class PlanificadorFormState {
  const PlanificadorFormState({
    this.tipoProduccion = TipoProduccion.engorde,
    this.razaEngorde = RazaEngorde.cobb500,
    this.razaPonedora = RazaPonedora.hyLineBrown,
    this.cantidadAves = 500,
    this.zona = ZonaClimatica.costa,
    this.nivelAutomatizacion = NivelAutomatizacion.semiAutomatico,
    this.latitud,
    this.longitud,
    this.direccionTexto,
    this.precioVentaKg,
  });

  final TipoProduccion tipoProduccion;
  final RazaEngorde razaEngorde;
  final RazaPonedora razaPonedora;
  final int cantidadAves;
  final ZonaClimatica zona;
  final NivelAutomatizacion nivelAutomatizacion;
  final double? latitud;
  final double? longitud;
  final String? direccionTexto;
  final double? precioVentaKg;

  PlanificadorFormState copyWith({
    TipoProduccion? tipoProduccion,
    RazaEngorde? razaEngorde,
    RazaPonedora? razaPonedora,
    int? cantidadAves,
    ZonaClimatica? zona,
    NivelAutomatizacion? nivelAutomatizacion,
    double? latitud,
    double? longitud,
    String? direccionTexto,
    double? precioVentaKg,
    bool clearPrecio = false,
    bool clearUbicacion = false,
  }) {
    return PlanificadorFormState(
      tipoProduccion: tipoProduccion ?? this.tipoProduccion,
      razaEngorde: razaEngorde ?? this.razaEngorde,
      razaPonedora: razaPonedora ?? this.razaPonedora,
      cantidadAves: cantidadAves ?? this.cantidadAves,
      zona: zona ?? this.zona,
      nivelAutomatizacion: nivelAutomatizacion ?? this.nivelAutomatizacion,
      latitud: clearUbicacion ? null : (latitud ?? this.latitud),
      longitud: clearUbicacion ? null : (longitud ?? this.longitud),
      direccionTexto: clearUbicacion
          ? null
          : (direccionTexto ?? this.direccionTexto),
      precioVentaKg: clearPrecio ? null : (precioVentaKg ?? this.precioVentaKg),
    );
  }

  /// Construye el [PlanInput] para el servicio.
  PlanInput toPlanInput() {
    return PlanInput(
      tipoProduccion: tipoProduccion,
      cantidadAves: cantidadAves,
      zona: zona,
      nivelAutomatizacion: nivelAutomatizacion,
      razaEngorde: tipoProduccion == TipoProduccion.engorde
          ? razaEngorde
          : null,
      razaPonedora: tipoProduccion == TipoProduccion.ponedora
          ? razaPonedora
          : null,
      latitud: latitud,
      longitud: longitud,
      direccionTexto: direccionTexto,
      precioVentaKg: precioVentaKg,
    );
  }
}

// =============================================================================
// NOTIFIER
// =============================================================================

class PlanificadorNotifier extends StateNotifier<PlanificadorFormState> {
  PlanificadorNotifier() : super(const PlanificadorFormState());

  void setTipo(TipoProduccion tipo) =>
      state = state.copyWith(tipoProduccion: tipo);

  void setRazaEngorde(RazaEngorde raza) =>
      state = state.copyWith(razaEngorde: raza);

  void setRazaPonedora(RazaPonedora raza) =>
      state = state.copyWith(razaPonedora: raza);

  void setCantidad(int cantidad) =>
      state = state.copyWith(cantidadAves: cantidad);

  void setZona(ZonaClimatica zona) => state = state.copyWith(zona: zona);

  void setNivelAutomatizacion(NivelAutomatizacion nivel) =>
      state = state.copyWith(nivelAutomatizacion: nivel);

  void setUbicacion(double lat, double lng, String? direccion) {
    final zona = PlanificadorService.determinarZona(lat, lng);
    state = state.copyWith(
      latitud: lat,
      longitud: lng,
      direccionTexto: direccion,
      zona: zona,
    );
  }

  void setPrecioVenta(double? precio) => state = state.copyWith(
    precioVentaKg: precio,
    clearPrecio: precio == null,
  );

  void reset() => state = const PlanificadorFormState();
}

// =============================================================================
// PROVIDERS
// =============================================================================

/// Provider del formulario del planificador.
final planificadorFormProvider =
    StateNotifierProvider.autoDispose<
      PlanificadorNotifier,
      PlanificadorFormState
    >((ref) => PlanificadorNotifier());

/// Provider del resultado calculado.
final planResultadoProvider = Provider.autoDispose<ResultadoPlan>((ref) {
  final form = ref.watch(planificadorFormProvider);
  return PlanificadorService.generar(form.toPlanInput());
});
