/// Entidades del planificador avícola.
///
/// Modelo de entrada (datos del usuario) y resultado (recomendación completa).
library;

import '../enums/raza_ave.dart';
import '../enums/zona_climatica.dart';

// =============================================================================
// ENTRADA DEL USUARIO
// =============================================================================

/// Tipo seleccionado: engorde o ponedora.
enum TipoProduccion { engorde, ponedora }

/// Nivel de automatización del galpón.
enum NivelAutomatizacion {
  manual,
  semiAutomatico,
  automatico;

  String get nombre => switch (this) {
    NivelAutomatizacion.manual => 'Manual',
    NivelAutomatizacion.semiAutomatico => 'Semi-automático',
    NivelAutomatizacion.automatico => 'Automático',
  };

  String get descripcion => switch (this) {
    NivelAutomatizacion.manual =>
      'Bebederos/comederos manuales, campanas a gas',
    NivelAutomatizacion.semiAutomatico =>
      'Bebederos automáticos, comederos tubulares, campanas a gas',
    NivelAutomatizacion.automatico =>
      'Bebederos nipple, comederos automáticos, calefacción controlada',
  };
}

/// Datos ingresados por el usuario en el formulario.
class PlanInput {
  const PlanInput({
    required this.tipoProduccion,
    required this.cantidadAves,
    required this.zona,
    this.nivelAutomatizacion = NivelAutomatizacion.semiAutomatico,
    this.razaEngorde,
    this.razaPonedora,
    this.latitud,
    this.longitud,
    this.direccionTexto,
    this.precioVentaKg,
  });

  final TipoProduccion tipoProduccion;

  /// Nivel de automatización del galpón.
  final NivelAutomatizacion nivelAutomatizacion;

  /// Raza seleccionada (engorde).
  final RazaEngorde? razaEngorde;

  /// Raza seleccionada (ponedora).
  final RazaPonedora? razaPonedora;

  /// Cantidad de aves a criar.
  final int cantidadAves;

  /// Zona climática determinada por ubicación.
  final ZonaClimatica zona;

  /// Coordenadas GPS.
  final double? latitud;
  final double? longitud;

  /// Dirección en texto (geocoding reverse).
  final String? direccionTexto;

  /// Precio de venta personalizado (S//kg). Null = usar referencial.
  final double? precioVentaKg;

  /// Nombre de la raza seleccionada.
  String get nombreRaza {
    if (tipoProduccion == TipoProduccion.engorde) {
      return razaEngorde?.nombre ?? 'Sin especificar';
    }
    return razaPonedora?.nombre ?? 'Sin especificar';
  }
}

// =============================================================================
// RESULTADO DEL PLANIFICADOR
// =============================================================================

/// Resultado completo generado por el servicio de planificación.
class ResultadoPlan {
  const ResultadoPlan({
    required this.input,
    required this.infraestructura,
    required this.alimentacion,
    required this.vacunacion,
    required this.manejoAmbiental,
    required this.proyeccionFinanciera,
    required this.cronograma,
    required this.equipamiento,
  });

  final PlanInput input;
  final InfraestructuraRecomendada infraestructura;
  final PlanAlimentacion alimentacion;
  final PlanVacunacion vacunacion;
  final RecomendacionAmbiental manejoAmbiental;
  final ProyeccionFinanciera proyeccionFinanciera;
  final List<EventoCronograma> cronograma;
  final List<ItemEquipamiento> equipamiento;
}

// =============================================================================
// INFRAESTRUCTURA
// =============================================================================

/// Recomendación de infraestructura.
class InfraestructuraRecomendada {
  const InfraestructuraRecomendada({
    required this.areaRequeridaM2,
    required this.largoM,
    required this.anchoM,
    required this.alturaCumbreraM,
    required this.alturaAleroM,
    required this.densidadAvesM2,
    required this.tipoTecho,
    required this.orientacion,
    required this.observaciones,
  });

  final double areaRequeridaM2;
  final double largoM;
  final double anchoM;
  final double alturaCumbreraM;
  final double alturaAleroM;
  final double densidadAvesM2;
  final String tipoTecho;
  final String orientacion;
  final List<String> observaciones;
}

// =============================================================================
// ALIMENTACIÓN
// =============================================================================

/// Plan de alimentación completo.
class PlanAlimentacion {
  const PlanAlimentacion({
    required this.fases,
    required this.consumoTotalPorAveKg,
    required this.consumoTotalLoteKg,
    required this.costoTotalPorAve,
    required this.costoTotalLote,
  });

  final List<FaseAlimentacionPlan> fases;
  final double consumoTotalPorAveKg;
  final double consumoTotalLoteKg;
  final double costoTotalPorAve;
  final double costoTotalLote;
}

/// Detalle de una fase del plan de alimentación.
class FaseAlimentacionPlan {
  const FaseAlimentacionPlan({
    required this.nombre,
    required this.periodo,
    required this.consumoDiarioPorAveG,
    required this.consumoTotalPorAveKg,
    required this.consumoTotalLoteKg,
    required this.proteina,
    required this.costoKg,
    required this.costoTotalFase,
  });

  final String nombre;
  final String periodo;
  final double consumoDiarioPorAveG;
  final double consumoTotalPorAveKg;
  final double consumoTotalLoteKg;
  final double proteina;
  final double costoKg;
  final double costoTotalFase;
}

// =============================================================================
// VACUNACIÓN
// =============================================================================

/// Plan de vacunación.
class PlanVacunacion {
  const PlanVacunacion({
    required this.vacunas,
    required this.costoTotalPorAve,
    required this.costoTotalLote,
  });

  final List<VacunaPlanDetalle> vacunas;
  final double costoTotalPorAve;
  final double costoTotalLote;
}

class VacunaPlanDetalle {
  const VacunaPlanDetalle({
    required this.dia,
    required this.nombre,
    required this.via,
    required this.dosisTotales,
    required this.costoTotal,
  });

  final int dia;
  final String nombre;
  final String via;
  final int dosisTotales;
  final double costoTotal;
}

// =============================================================================
// MANEJO AMBIENTAL
// =============================================================================

class RecomendacionAmbiental {
  const RecomendacionAmbiental({
    required this.zona,
    required this.temperaturaOptima,
    required this.humedadRelativa,
    required this.tipoVentilacion,
    required this.tipoCortinas,
    required this.notasEspeciales,
  });

  final ZonaClimatica zona;
  final String temperaturaOptima;
  final String humedadRelativa;
  final String tipoVentilacion;
  final String tipoCortinas;
  final List<String> notasEspeciales;
}

// =============================================================================
// PROYECCIÓN FINANCIERA
// =============================================================================

/// Proyección financiera completa.
class ProyeccionFinanciera {
  const ProyeccionFinanciera({
    required this.inversionInicial,
    required this.costosOperativos,
    required this.costoTotal,
    required this.ingresoProyectado,
    required this.gananciaProyectada,
    required this.margenGanancia,
    required this.costosPorCategoria,
    required this.precioVentaUsado,
    required this.fechaReferenciaPrecios,
    this.ingresosAdicionales = const {},
  });

  /// Inversión inicial (pollitos, equipos, infraestructura).
  final double inversionInicial;

  /// Costos operativos del ciclo (alimento, vacunas, servicios).
  final double costosOperativos;

  /// Costo total (inversión + operativos).
  final double costoTotal;

  /// Ingreso proyectado por venta.
  final double ingresoProyectado;

  /// Ganancia neta proyectada.
  final double gananciaProyectada;

  /// Margen de ganancia (0.0 a 1.0).
  final double margenGanancia;

  /// Desglose de costos por categoría.
  final Map<String, double> costosPorCategoria;

  /// Precio de venta utilizado (S//kg).
  final double precioVentaUsado;

  /// Fecha de referencia de los precios.
  final String fechaReferenciaPrecios;

  /// Ingresos adicionales (gallinaza, descarte, etc).
  final Map<String, double> ingresosAdicionales;

  /// Ingreso total incluyendo adicionales.
  double get ingresoTotal =>
      ingresoProyectado + ingresosAdicionales.values.fold(0.0, (a, b) => a + b);

  /// Ganancia total incluyendo ingresos adicionales.
  double get gananciaTotal => ingresoTotal - costoTotal;

  /// Retorno sobre inversión.
  double get roi => costoTotal > 0 ? gananciaTotal / costoTotal : 0;
}

// =============================================================================
// CRONOGRAMA
// =============================================================================

/// Evento del cronograma productivo.
class EventoCronograma {
  const EventoCronograma({
    required this.dia,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
  });

  /// Día del ciclo (o semana para ponedoras).
  final int dia;
  final String titulo;
  final String descripcion;
  final CategoriaCronograma categoria;
}

enum CategoriaCronograma {
  alimentacion,
  vacunacion,
  manejo,
  produccion,
  venta;

  String get nombre {
    return switch (this) {
      CategoriaCronograma.alimentacion => 'Alimentación',
      CategoriaCronograma.vacunacion => 'Vacunación',
      CategoriaCronograma.manejo => 'Manejo',
      CategoriaCronograma.produccion => 'Producción',
      CategoriaCronograma.venta => 'Venta',
    };
  }
}

// =============================================================================
// EQUIPAMIENTO
// =============================================================================

class ItemEquipamiento {
  const ItemEquipamiento({
    required this.nombre,
    required this.cantidad,
    required this.costoUnitario,
    required this.costoTotal,
  });

  final String nombre;
  final int cantidad;
  final double costoUnitario;
  final double costoTotal;
}
