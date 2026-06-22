/// Datos técnicos por raza de ave — basados en manuales de cada genética.
///
/// Fuentes: Cobb-Vantress (Cobb 500 Broiler Performance & Nutrition
/// Supplement), Aviagen (Ross 308 Broiler Performance Objectives),
/// Hy-Line International, Lohmann Tierzucht, ISA / Hendrix Genetics,
/// Novogen. Adaptados al mercado peruano.
library;

import '../../domain/enums/raza_ave.dart';
import '../../domain/enums/zona_climatica.dart';

// =============================================================================
// MODELO DE DATOS POR RAZA
// =============================================================================

/// Fase de alimentación (engorde).
class FaseAlimentacion {
  const FaseAlimentacion({
    required this.nombre,
    required this.diaInicio,
    required this.diaFin,
    required this.consumoDiarioG,
    required this.proteina,
    required this.energiaKcal,
    required this.costoKg,
  });

  final String nombre;
  final int diaInicio;
  final int diaFin;

  /// Consumo promedio diario en gramos.
  final double consumoDiarioG;

  /// Proteína cruda recomendada (%).
  final double proteina;

  /// Energía metabolizable (kcal/kg).
  final int energiaKcal;

  /// Costo referencial del alimento (S//kg).
  final double costoKg;

  int get duracionDias => diaFin - diaInicio + 1;
  double get consumoTotalKg => (consumoDiarioG * duracionDias) / 1000;
}

/// Fase de alimentación para ponedoras.
class FaseAlimentacionPonedora {
  const FaseAlimentacionPonedora({
    required this.nombre,
    required this.semanaInicio,
    required this.semanaFin,
    required this.consumoDiarioG,
    required this.proteina,
    required this.calcio,
    required this.costoKg,
  });

  final String nombre;
  final int semanaInicio;
  final int semanaFin;
  final double consumoDiarioG;
  final double proteina;
  final double calcio;
  final double costoKg;

  int get duracionSemanas => semanaFin - semanaInicio + 1;
  int get duracionDias => duracionSemanas * 7;
  double get consumoTotalKg => (consumoDiarioG * duracionDias) / 1000;
}

/// Datos de la curva de peso semanal (engorde).
class PesoSemanal {
  const PesoSemanal({
    required this.semana,
    required this.pesoG,
    required this.gananciaDialiaG,
  });

  final int semana;
  final int pesoG;
  final double gananciaDialiaG;
}

/// Vacuna del programa sanitario.
class VacunaPlan {
  const VacunaPlan({
    required this.dia,
    required this.nombre,
    required this.via,
    this.costoUnidad = 0.0,
  });

  /// Día de aplicación (engorde) o semana (ponedora).
  final int dia;
  final String nombre;
  final String via;

  /// Costo referencial por dosis (S/).
  final double costoUnidad;
}

/// Datos completos de una raza de engorde.
class DatosRazaEngorde {
  const DatosRazaEngorde({
    required this.raza,
    required this.pesoObjetivoG,
    required this.diasCiclo,
    required this.conversionAlimenticia,
    required this.mortalidadEsperada,
    required this.rendimientoCanal,
    required this.densidadAvesM2,
    required this.fasesAlimentacion,
    required this.curvaPeso,
    required this.vacunas,
    required this.costoPollitoBB,
  });

  final RazaEngorde raza;

  /// Peso vivo objetivo al final del ciclo (gramos).
  final int pesoObjetivoG;

  /// Duración del ciclo en días.
  final int diasCiclo;

  /// Índice de conversión alimenticia (kg alimento / kg peso).
  final double conversionAlimenticia;

  /// Mortalidad esperada (0.0 a 1.0).
  final double mortalidadEsperada;

  /// Rendimiento en canal (0.0 a 1.0).
  final double rendimientoCanal;

  /// Densidad recomendada (aves/m²) por zona climática.
  final Map<ZonaClimatica, double> densidadAvesM2;

  /// Fases de alimentación con consumos y costos.
  final List<FaseAlimentacion> fasesAlimentacion;

  /// Curva de peso semanal.
  final List<PesoSemanal> curvaPeso;

  /// Programa de vacunación.
  final List<VacunaPlan> vacunas;

  /// Costo del pollito BB (S/).
  final double costoPollitoBB;

  /// Consumo total de alimento por ave (kg).
  double get consumoTotalKg =>
      fasesAlimentacion.fold(0.0, (sum, f) => sum + f.consumoTotalKg);

  /// Costo total del alimento por ave (S/).
  double get costoAlimentoTotal => fasesAlimentacion.fold(
    0.0,
    (sum, f) => sum + (f.consumoTotalKg * f.costoKg),
  );

  /// Peso objetivo en kg.
  double get pesoObjetivoKg => pesoObjetivoG / 1000;

  /// Costo total de vacunas por ave (S/).
  double get costoVacunasTotal =>
      vacunas.fold(0.0, (sum, v) => sum + v.costoUnidad);
}

/// Datos completos de una raza de ponedora.
class DatosRazaPonedora {
  const DatosRazaPonedora({
    required this.raza,
    required this.semanaInicioProduccion,
    required this.picoProduccion,
    required this.huevosAveAlojada80Sem,
    required this.pesoHuevoG,
    required this.pesoAveProdG,
    required this.viabilidad80Sem,
    required this.semanasCiclo,
    required this.densidadAvesM2Piso,
    required this.fasesAlimentacion,
    required this.vacunas,
    required this.costoPollitaBB,
  });

  final RazaPonedora raza;

  /// Semana de inicio de producción (5% postura).
  final int semanaInicioProduccion;

  /// Pico de producción (0.0 a 1.0).
  final double picoProduccion;

  /// Huevos por ave alojada a 80 semanas.
  final int huevosAveAlojada80Sem;

  /// Peso promedio del huevo (gramos).
  final double pesoHuevoG;

  /// Peso del ave en producción (gramos).
  final int pesoAveProdG;

  /// Viabilidad a 80 semanas (0.0 a 1.0).
  final double viabilidad80Sem;

  /// Duración del ciclo en semanas.
  final int semanasCiclo;

  /// Densidad recomendada en piso (aves/m²).
  final Map<ZonaClimatica, double> densidadAvesM2Piso;

  /// Fases de alimentación.
  final List<FaseAlimentacionPonedora> fasesAlimentacion;

  /// Programa de vacunación.
  final List<VacunaPlan> vacunas;

  /// Costo de la pollita BB (S/).
  final double costoPollitaBB;

  /// Consumo total de alimento por ave (kg) durante todo el ciclo.
  double get consumoTotalKg =>
      fasesAlimentacion.fold(0.0, (sum, f) => sum + f.consumoTotalKg);

  /// Costo total del alimento por ave (S/).
  double get costoAlimentoTotal => fasesAlimentacion.fold(
    0.0,
    (sum, f) => sum + (f.consumoTotalKg * f.costoKg),
  );

  /// Costo total de vacunas por ave (S/).
  double get costoVacunasTotal =>
      vacunas.fold(0.0, (sum, v) => sum + v.costoUnidad);
}

// =============================================================================
// DATOS COBB 500
// =============================================================================

final datosRazasEngorde = <RazaEngorde, DatosRazaEngorde>{
  RazaEngorde.cobb500: const DatosRazaEngorde(
    raza: RazaEngorde.cobb500,
    pesoObjetivoG: 2900,
    diasCiclo: 42,
    conversionAlimenticia: 1.72,
    mortalidadEsperada: 0.035,
    rendimientoCanal: 0.74,
    costoPollitoBB: 3.20,
    densidadAvesM2: {
      ZonaClimatica.costa: 11.0,
      ZonaClimatica.sierra: 13.0,
      ZonaClimatica.selva: 9.0,
    },
    fasesAlimentacion: [
      FaseAlimentacion(
        nombre: 'Pre-inicio',
        diaInicio: 1,
        diaFin: 7,
        consumoDiarioG: 22,
        proteina: 23.0,
        energiaKcal: 3000,
        costoKg: 3.00,
      ),
      FaseAlimentacion(
        nombre: 'Inicio',
        diaInicio: 8,
        diaFin: 21,
        consumoDiarioG: 68,
        proteina: 22.0,
        energiaKcal: 3050,
        costoKg: 2.80,
      ),
      FaseAlimentacion(
        nombre: 'Crecimiento',
        diaInicio: 22,
        diaFin: 35,
        consumoDiarioG: 142,
        proteina: 20.0,
        energiaKcal: 3100,
        costoKg: 2.60,
      ),
      FaseAlimentacion(
        nombre: 'Engorde',
        diaInicio: 36,
        diaFin: 42,
        consumoDiarioG: 192,
        proteina: 18.5,
        energiaKcal: 3150,
        costoKg: 2.50,
      ),
    ],
    curvaPeso: [
      PesoSemanal(semana: 0, pesoG: 42, gananciaDialiaG: 0),
      PesoSemanal(semana: 1, pesoG: 185, gananciaDialiaG: 20.4),
      PesoSemanal(semana: 2, pesoG: 460, gananciaDialiaG: 39.3),
      PesoSemanal(semana: 3, pesoG: 880, gananciaDialiaG: 60.0),
      PesoSemanal(semana: 4, pesoG: 1390, gananciaDialiaG: 72.9),
      PesoSemanal(semana: 5, pesoG: 1980, gananciaDialiaG: 84.3),
      PesoSemanal(semana: 6, pesoG: 2900, gananciaDialiaG: 131.4),
    ],
    vacunas: [
      VacunaPlan(
        dia: 1,
        nombre: 'Marek (HVT+SB1)',
        via: 'Subcutánea en planta incubación',
        costoUnidad: 0.08,
      ),
      VacunaPlan(
        dia: 1,
        nombre: 'Bronquitis infecciosa (H120)',
        via: 'Aspersión gruesa',
        costoUnidad: 0.03,
      ),
      VacunaPlan(
        dia: 7,
        nombre: 'Newcastle + Bronquitis (BI-combinada)',
        via: 'Ocular / Agua de bebida',
        costoUnidad: 0.04,
      ),
      VacunaPlan(
        dia: 14,
        nombre: 'Gumboro (IBD)',
        via: 'Agua de bebida',
        costoUnidad: 0.05,
      ),
      VacunaPlan(
        dia: 21,
        nombre: 'Newcastle (La Sota)',
        via: 'Agua de bebida',
        costoUnidad: 0.04,
      ),
      VacunaPlan(
        dia: 28,
        nombre: 'Gumboro (refuerzo)',
        via: 'Agua de bebida',
        costoUnidad: 0.05,
      ),
    ],
  ),

  // ===========================================================================
  // DATOS ROSS 308
  // ===========================================================================
  RazaEngorde.ross308: const DatosRazaEngorde(
    raza: RazaEngorde.ross308,
    pesoObjetivoG: 2800,
    diasCiclo: 42,
    conversionAlimenticia: 1.68,
    mortalidadEsperada: 0.035,
    rendimientoCanal: 0.75,
    costoPollitoBB: 3.20,
    densidadAvesM2: {
      ZonaClimatica.costa: 11.0,
      ZonaClimatica.sierra: 13.0,
      ZonaClimatica.selva: 9.0,
    },
    fasesAlimentacion: [
      FaseAlimentacion(
        nombre: 'Pre-inicio',
        diaInicio: 1,
        diaFin: 7,
        consumoDiarioG: 21,
        proteina: 23.0,
        energiaKcal: 3000,
        costoKg: 3.00,
      ),
      FaseAlimentacion(
        nombre: 'Inicio',
        diaInicio: 8,
        diaFin: 21,
        consumoDiarioG: 65,
        proteina: 22.0,
        energiaKcal: 3050,
        costoKg: 2.80,
      ),
      FaseAlimentacion(
        nombre: 'Crecimiento',
        diaInicio: 22,
        diaFin: 35,
        consumoDiarioG: 138,
        proteina: 20.5,
        energiaKcal: 3100,
        costoKg: 2.60,
      ),
      FaseAlimentacion(
        nombre: 'Engorde',
        diaInicio: 36,
        diaFin: 42,
        consumoDiarioG: 185,
        proteina: 19.0,
        energiaKcal: 3150,
        costoKg: 2.50,
      ),
    ],
    curvaPeso: [
      PesoSemanal(semana: 0, pesoG: 42, gananciaDialiaG: 0),
      PesoSemanal(semana: 1, pesoG: 180, gananciaDialiaG: 19.7),
      PesoSemanal(semana: 2, pesoG: 440, gananciaDialiaG: 37.1),
      PesoSemanal(semana: 3, pesoG: 850, gananciaDialiaG: 58.6),
      PesoSemanal(semana: 4, pesoG: 1350, gananciaDialiaG: 71.4),
      PesoSemanal(semana: 5, pesoG: 1920, gananciaDialiaG: 81.4),
      PesoSemanal(semana: 6, pesoG: 2800, gananciaDialiaG: 125.7),
    ],
    vacunas: [
      VacunaPlan(
        dia: 1,
        nombre: 'Marek (HVT+SB1)',
        via: 'Subcutánea en planta incubación',
        costoUnidad: 0.08,
      ),
      VacunaPlan(
        dia: 1,
        nombre: 'Bronquitis infecciosa (H120)',
        via: 'Aspersión gruesa',
        costoUnidad: 0.03,
      ),
      VacunaPlan(
        dia: 7,
        nombre: 'Newcastle + Bronquitis (BI-combinada)',
        via: 'Ocular / Agua de bebida',
        costoUnidad: 0.04,
      ),
      VacunaPlan(
        dia: 14,
        nombre: 'Gumboro (IBD)',
        via: 'Agua de bebida',
        costoUnidad: 0.05,
      ),
      VacunaPlan(
        dia: 21,
        nombre: 'Newcastle (La Sota)',
        via: 'Agua de bebida',
        costoUnidad: 0.04,
      ),
      VacunaPlan(
        dia: 28,
        nombre: 'Gumboro (refuerzo)',
        via: 'Agua de bebida',
        costoUnidad: 0.05,
      ),
    ],
  ),
};

// =============================================================================
// DATOS PONEDORAS
// =============================================================================

final datosRazasPonedora = <RazaPonedora, DatosRazaPonedora>{
  RazaPonedora.hyLineBrown: const DatosRazaPonedora(
    raza: RazaPonedora.hyLineBrown,
    semanaInicioProduccion: 18,
    picoProduccion: 0.96,
    huevosAveAlojada80Sem: 355,
    pesoHuevoG: 62.5,
    pesoAveProdG: 1950,
    viabilidad80Sem: 0.94,
    semanasCiclo: 80,
    costoPollitaBB: 5.50,
    densidadAvesM2Piso: {
      ZonaClimatica.costa: 6.0,
      ZonaClimatica.sierra: 7.0,
      ZonaClimatica.selva: 5.0,
    },
    fasesAlimentacion: [
      FaseAlimentacionPonedora(
        nombre: 'Cría (0–6 sem)',
        semanaInicio: 1,
        semanaFin: 6,
        consumoDiarioG: 28,
        proteina: 20.0,
        calcio: 1.0,
        costoKg: 2.90,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Recría (7–12 sem)',
        semanaInicio: 7,
        semanaFin: 12,
        consumoDiarioG: 52,
        proteina: 18.0,
        calcio: 1.0,
        costoKg: 2.60,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Desarrollo (13–17 sem)',
        semanaInicio: 13,
        semanaFin: 17,
        consumoDiarioG: 72,
        proteina: 16.0,
        calcio: 1.2,
        costoKg: 2.40,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Pre-postura (18–20 sem)',
        semanaInicio: 18,
        semanaFin: 20,
        consumoDiarioG: 90,
        proteina: 17.5,
        calcio: 2.5,
        costoKg: 2.50,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Postura I – Pico (21–45 sem)',
        semanaInicio: 21,
        semanaFin: 45,
        consumoDiarioG: 112,
        proteina: 17.0,
        calcio: 4.2,
        costoKg: 2.40,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Postura II – Meseta (46–65 sem)',
        semanaInicio: 46,
        semanaFin: 65,
        consumoDiarioG: 110,
        proteina: 16.0,
        calcio: 4.4,
        costoKg: 2.35,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Postura III – Final (66–80 sem)',
        semanaInicio: 66,
        semanaFin: 80,
        consumoDiarioG: 108,
        proteina: 15.5,
        calcio: 4.6,
        costoKg: 2.30,
      ),
    ],
    vacunas: _vacunasPonedoraBase,
  ),

  RazaPonedora.lohmannBrown: const DatosRazaPonedora(
    raza: RazaPonedora.lohmannBrown,
    semanaInicioProduccion: 18,
    picoProduccion: 0.95,
    huevosAveAlojada80Sem: 345,
    pesoHuevoG: 63.5,
    pesoAveProdG: 2000,
    viabilidad80Sem: 0.94,
    semanasCiclo: 80,
    costoPollitaBB: 5.50,
    densidadAvesM2Piso: {
      ZonaClimatica.costa: 6.0,
      ZonaClimatica.sierra: 7.0,
      ZonaClimatica.selva: 5.0,
    },
    fasesAlimentacion: [
      FaseAlimentacionPonedora(
        nombre: 'Cría (0–6 sem)',
        semanaInicio: 1,
        semanaFin: 6,
        consumoDiarioG: 30,
        proteina: 20.5,
        calcio: 1.0,
        costoKg: 2.90,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Recría (7–12 sem)',
        semanaInicio: 7,
        semanaFin: 12,
        consumoDiarioG: 55,
        proteina: 18.0,
        calcio: 1.0,
        costoKg: 2.60,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Desarrollo (13–17 sem)',
        semanaInicio: 13,
        semanaFin: 17,
        consumoDiarioG: 75,
        proteina: 16.0,
        calcio: 1.2,
        costoKg: 2.40,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Pre-postura (18–20 sem)',
        semanaInicio: 18,
        semanaFin: 20,
        consumoDiarioG: 92,
        proteina: 17.5,
        calcio: 2.5,
        costoKg: 2.50,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Postura I – Pico (21–45 sem)',
        semanaInicio: 21,
        semanaFin: 45,
        consumoDiarioG: 115,
        proteina: 17.0,
        calcio: 4.2,
        costoKg: 2.40,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Postura II – Meseta (46–65 sem)',
        semanaInicio: 46,
        semanaFin: 65,
        consumoDiarioG: 112,
        proteina: 16.0,
        calcio: 4.4,
        costoKg: 2.35,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Postura III – Final (66–80 sem)',
        semanaInicio: 66,
        semanaFin: 80,
        consumoDiarioG: 110,
        proteina: 15.5,
        calcio: 4.6,
        costoKg: 2.30,
      ),
    ],
    vacunas: _vacunasPonedoraBase,
  ),

  RazaPonedora.hyLineW36: const DatosRazaPonedora(
    raza: RazaPonedora.hyLineW36,
    semanaInicioProduccion: 18,
    picoProduccion: 0.96,
    huevosAveAlojada80Sem: 360,
    pesoHuevoG: 60.0,
    pesoAveProdG: 1580,
    viabilidad80Sem: 0.93,
    semanasCiclo: 80,
    costoPollitaBB: 5.80,
    densidadAvesM2Piso: {
      ZonaClimatica.costa: 7.0,
      ZonaClimatica.sierra: 8.0,
      ZonaClimatica.selva: 5.5,
    },
    fasesAlimentacion: [
      FaseAlimentacionPonedora(
        nombre: 'Cría (0–6 sem)',
        semanaInicio: 1,
        semanaFin: 6,
        consumoDiarioG: 25,
        proteina: 20.0,
        calcio: 1.0,
        costoKg: 2.90,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Recría (7–12 sem)',
        semanaInicio: 7,
        semanaFin: 12,
        consumoDiarioG: 45,
        proteina: 17.5,
        calcio: 1.0,
        costoKg: 2.60,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Desarrollo (13–17 sem)',
        semanaInicio: 13,
        semanaFin: 17,
        consumoDiarioG: 65,
        proteina: 15.5,
        calcio: 1.2,
        costoKg: 2.40,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Pre-postura (18–20 sem)',
        semanaInicio: 18,
        semanaFin: 20,
        consumoDiarioG: 82,
        proteina: 17.0,
        calcio: 2.5,
        costoKg: 2.50,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Postura I – Pico (21–45 sem)',
        semanaInicio: 21,
        semanaFin: 45,
        consumoDiarioG: 100,
        proteina: 17.0,
        calcio: 4.2,
        costoKg: 2.40,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Postura II – Meseta (46–65 sem)',
        semanaInicio: 46,
        semanaFin: 65,
        consumoDiarioG: 98,
        proteina: 16.0,
        calcio: 4.4,
        costoKg: 2.35,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Postura III – Final (66–80 sem)',
        semanaInicio: 66,
        semanaFin: 80,
        consumoDiarioG: 95,
        proteina: 15.5,
        calcio: 4.6,
        costoKg: 2.30,
      ),
    ],
    vacunas: _vacunasPonedoraBase,
  ),

  RazaPonedora.isaBrown: const DatosRazaPonedora(
    raza: RazaPonedora.isaBrown,
    semanaInicioProduccion: 18,
    picoProduccion: 0.95,
    huevosAveAlojada80Sem: 348,
    pesoHuevoG: 63.0,
    pesoAveProdG: 1950,
    viabilidad80Sem: 0.94,
    semanasCiclo: 80,
    costoPollitaBB: 5.50,
    densidadAvesM2Piso: {
      ZonaClimatica.costa: 6.0,
      ZonaClimatica.sierra: 7.0,
      ZonaClimatica.selva: 5.0,
    },
    fasesAlimentacion: [
      FaseAlimentacionPonedora(
        nombre: 'Cría (0–6 sem)',
        semanaInicio: 1,
        semanaFin: 6,
        consumoDiarioG: 28,
        proteina: 20.0,
        calcio: 1.0,
        costoKg: 2.90,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Recría (7–12 sem)',
        semanaInicio: 7,
        semanaFin: 12,
        consumoDiarioG: 53,
        proteina: 18.0,
        calcio: 1.0,
        costoKg: 2.60,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Desarrollo (13–17 sem)',
        semanaInicio: 13,
        semanaFin: 17,
        consumoDiarioG: 73,
        proteina: 16.0,
        calcio: 1.2,
        costoKg: 2.40,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Pre-postura (18–20 sem)',
        semanaInicio: 18,
        semanaFin: 20,
        consumoDiarioG: 90,
        proteina: 17.5,
        calcio: 2.5,
        costoKg: 2.50,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Postura I – Pico (21–45 sem)',
        semanaInicio: 21,
        semanaFin: 45,
        consumoDiarioG: 112,
        proteina: 17.0,
        calcio: 4.2,
        costoKg: 2.40,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Postura II – Meseta (46–65 sem)',
        semanaInicio: 46,
        semanaFin: 65,
        consumoDiarioG: 110,
        proteina: 16.0,
        calcio: 4.4,
        costoKg: 2.35,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Postura III – Final (66–80 sem)',
        semanaInicio: 66,
        semanaFin: 80,
        consumoDiarioG: 108,
        proteina: 15.5,
        calcio: 4.6,
        costoKg: 2.30,
      ),
    ],
    vacunas: _vacunasPonedoraBase,
  ),

  RazaPonedora.novogenBrown: const DatosRazaPonedora(
    raza: RazaPonedora.novogenBrown,
    semanaInicioProduccion: 19,
    picoProduccion: 0.95,
    huevosAveAlojada80Sem: 340,
    pesoHuevoG: 63.0,
    pesoAveProdG: 1980,
    viabilidad80Sem: 0.93,
    semanasCiclo: 80,
    costoPollitaBB: 5.50,
    densidadAvesM2Piso: {
      ZonaClimatica.costa: 6.0,
      ZonaClimatica.sierra: 7.0,
      ZonaClimatica.selva: 5.0,
    },
    fasesAlimentacion: [
      FaseAlimentacionPonedora(
        nombre: 'Cría (0–6 sem)',
        semanaInicio: 1,
        semanaFin: 6,
        consumoDiarioG: 29,
        proteina: 20.0,
        calcio: 1.0,
        costoKg: 2.90,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Recría (7–12 sem)',
        semanaInicio: 7,
        semanaFin: 12,
        consumoDiarioG: 54,
        proteina: 18.0,
        calcio: 1.0,
        costoKg: 2.60,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Desarrollo (13–17 sem)',
        semanaInicio: 13,
        semanaFin: 17,
        consumoDiarioG: 74,
        proteina: 16.0,
        calcio: 1.2,
        costoKg: 2.40,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Pre-postura (18–20 sem)',
        semanaInicio: 18,
        semanaFin: 20,
        consumoDiarioG: 92,
        proteina: 17.5,
        calcio: 2.5,
        costoKg: 2.50,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Postura I – Pico (21–45 sem)',
        semanaInicio: 21,
        semanaFin: 45,
        consumoDiarioG: 113,
        proteina: 17.0,
        calcio: 4.2,
        costoKg: 2.40,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Postura II – Meseta (46–65 sem)',
        semanaInicio: 46,
        semanaFin: 65,
        consumoDiarioG: 111,
        proteina: 16.0,
        calcio: 4.4,
        costoKg: 2.35,
      ),
      FaseAlimentacionPonedora(
        nombre: 'Postura III – Final (66–80 sem)',
        semanaInicio: 66,
        semanaFin: 80,
        consumoDiarioG: 109,
        proteina: 15.5,
        calcio: 4.6,
        costoKg: 2.30,
      ),
    ],
    vacunas: _vacunasPonedoraBase,
  ),
};

// =============================================================================
// PROGRAMA DE VACUNACIÓN BASE PONEDORAS (Perú - SENASA)
// =============================================================================

const _vacunasPonedoraBase = [
  VacunaPlan(
    dia: 1,
    nombre: 'Marek (HVT+SB1)',
    via: 'Subcutánea en planta incubación',
    costoUnidad: 0.10,
  ),
  VacunaPlan(
    dia: 7,
    nombre: 'Newcastle + Bronquitis (B1-H120)',
    via: 'Ocular',
    costoUnidad: 0.04,
  ),
  VacunaPlan(
    dia: 14,
    nombre: 'Gumboro (IBD intermedia)',
    via: 'Agua de bebida',
    costoUnidad: 0.05,
  ),
  VacunaPlan(
    dia: 21,
    nombre: 'Newcastle (La Sota)',
    via: 'Agua de bebida',
    costoUnidad: 0.04,
  ),
  VacunaPlan(
    dia: 28,
    nombre: 'Gumboro (refuerzo)',
    via: 'Agua de bebida',
    costoUnidad: 0.05,
  ),
  VacunaPlan(
    dia: 35,
    nombre: 'Viruela aviar + Encefalomielitis',
    via: 'Punción alar',
    costoUnidad: 0.08,
  ),
  VacunaPlan(
    dia: 49,
    nombre: 'Newcastle + Bronquitis (refuerzo)',
    via: 'Agua de bebida',
    costoUnidad: 0.04,
  ),
  VacunaPlan(
    dia: 63,
    nombre: 'Coriza infecciosa (1ra dosis)',
    via: 'Intramuscular',
    costoUnidad: 0.12,
  ),
  VacunaPlan(
    dia: 77,
    nombre: 'Mycoplasma (MS/MG)',
    via: 'Ocular',
    costoUnidad: 0.10,
  ),
  VacunaPlan(
    dia: 84,
    nombre: 'Coriza infecciosa (refuerzo)',
    via: 'Intramuscular',
    costoUnidad: 0.12,
  ),
  VacunaPlan(
    dia: 98,
    nombre: 'Newcastle + Bronquitis + EDS (triple)',
    via: 'Intramuscular (oleosa)',
    costoUnidad: 0.25,
  ),
  VacunaPlan(
    dia: 112,
    nombre: 'Salmonella (SE)',
    via: 'Intramuscular',
    costoUnidad: 0.15,
  ),
];

// =============================================================================
// DATOS DE MANEJO AMBIENTAL POR ZONA CLIMÁTICA
// =============================================================================

/// Recomendaciones de manejo ambiental por zona climática.
class DatosManejoAmbiental {
  const DatosManejoAmbiental({
    required this.zona,
    required this.tempOptimaBroilerInicio,
    required this.tempOptimaBroilerFinal,
    required this.tempOptimaPonedora,
    required this.humedadRelativa,
    required this.tipoVentilacion,
    required this.orientacionGalpon,
    required this.alturaCumbrera,
    required this.alturaAlero,
    required this.tipoTecho,
    required this.tipoCortinas,
    required this.notasEspeciales,
  });

  final ZonaClimatica zona;
  final String tempOptimaBroilerInicio;
  final String tempOptimaBroilerFinal;
  final String tempOptimaPonedora;
  final String humedadRelativa;
  final String tipoVentilacion;
  final String orientacionGalpon;
  final double alturaCumbrera;
  final double alturaAlero;
  final String tipoTecho;
  final String tipoCortinas;
  final List<String> notasEspeciales;
}

final datosManejoAmbiental = <ZonaClimatica, DatosManejoAmbiental>{
  ZonaClimatica.costa: const DatosManejoAmbiental(
    zona: ZonaClimatica.costa,
    tempOptimaBroilerInicio: '32–34°C',
    tempOptimaBroilerFinal: '20–22°C',
    tempOptimaPonedora: '18–24°C',
    humedadRelativa: '60–70%',
    tipoVentilacion:
        'Natural con cortinas laterales; ventiladores de refuerzo en verano',
    orientacionGalpon: 'Eje largo Este-Oeste (para minimizar sol directo)',
    alturaCumbrera: 4.0,
    alturaAlero: 2.8,
    tipoTecho:
        'Calamina galvanizada con cielo raso aislante (poliuretano o poliestireno)',
    tipoCortinas: 'Polipropileno o lona (manejo manual o automático)',
    notasEspeciales: [
      'Garúa invernal puede elevar humedad — asegurar drenaje perimetral',
      'Verano (dic-mar): considerar nebulización si T° > 30°C',
      'Brisa marina puede aportar humedad excesiva — cortinas regulables',
    ],
  ),
  ZonaClimatica.sierra: const DatosManejoAmbiental(
    zona: ZonaClimatica.sierra,
    tempOptimaBroilerInicio: '33–35°C',
    tempOptimaBroilerFinal: '20–22°C',
    tempOptimaPonedora: '16–22°C',
    humedadRelativa: '40–60%',
    tipoVentilacion:
        'Natural con cortinas gruesas; calefacción obligatoria primeras 3 semanas',
    orientacionGalpon: 'Eje largo Este-Oeste (protección de vientos fríos)',
    alturaCumbrera: 3.8,
    alturaAlero: 2.5,
    tipoTecho:
        'Calamina con cielo raso doble aislamiento (poliestireno expandido mín. 2")',
    tipoCortinas: 'Lona gruesa doble capa (retención de calor nocturno)',
    notasEspeciales: [
      'Heladas nocturnas (may-ago): calefacción con campanas a gas o infrarrojos',
      'Radiación UV intensa — proteger bebederos y alimento de exposición directa',
      'Baja presión de oxígeno sobre 3000 msnm — reducir densidad 15–20%',
      'Variación térmica diurna amplia (hasta 20°C) — cortinas automatizadas recomendadas',
    ],
  ),
  ZonaClimatica.selva: const DatosManejoAmbiental(
    zona: ZonaClimatica.selva,
    tempOptimaBroilerInicio: '32–33°C',
    tempOptimaBroilerFinal: '20–22°C',
    tempOptimaPonedora: '20–26°C',
    humedadRelativa: '70–85%',
    tipoVentilacion:
        'Forzada con extractores y entradas de aire controladas (túnel o transversal)',
    orientacionGalpon: 'Eje largo perpendicular al viento dominante',
    alturaCumbrera: 4.5,
    alturaAlero: 3.0,
    tipoTecho:
        'Calamina con sobre-techo ventilado (efecto chimenea) y cielo raso aislante',
    tipoCortinas: 'Malla anti-insectos + cortinas de polipropileno',
    notasEspeciales: [
      'Humedad constante alta — ventilación forzada crítica para evitar cama húmeda',
      'Alta presión de insectos: malla en todas las aberturas, trampas, bioseguridad reforzada',
      'Lluvias intensas: cunetas y drenaje perimetral profundo, piso elevado',
      'Estrés calórico frecuente: bebederos tipo nipple con agua fresca, nebulización con extractores',
      'Mayor incidencia de enfermedades respiratorias: reforzar programa sanitario',
    ],
  ),
};

// =============================================================================
// PRECIOS DE MERCADO PERÚ (Referenciales)
// =============================================================================

/// Precios referenciales del mercado avícola peruano.
///
/// Fuentes ref.: MIDAGRI/SISAP Mercado Mayorista Lima, APA Asociación
/// Peruana de Avicultura. Valores promedio 2024–2025 actualizados a
/// abril 2026.
class PreciosMercadoPeru {
  const PreciosMercadoPeru._();

  /// Fecha de referencia de los precios.
  static const fechaReferencia = 'Abril 2026';

  // ---- Pollo Engorde ----
  /// Precio pollo vivo en granja (S//kg).
  static const double polloVivoGranjaKg = 6.50;

  /// Precio pollo beneficiado mayorista (S//kg).
  static const double polloBeneficiadoKg = 9.00;

  // ---- Huevo ----
  /// Precio huevo en granja (S//kg).
  static const double huevoGranjaKg = 6.00;

  /// Precio huevo por unidad referencial (S/).
  static const double huevoUnidad = 0.40;

  // ---- Costos operativos ----
  /// Costo de electricidad por ave/ciclo engorde (S/).
  static const double electricidadPorAveEngorde = 0.15;

  /// Costo de electricidad por ave/ciclo ponedora (S/).
  static const double electricidadPorAvePonedora = 2.50;

  /// Costo de gas/calefacción por ave/ciclo engorde (S/).
  static const double gasPorAveEngorde = 0.25;

  /// Costo de cama (viruta) por ave/ciclo engorde (S/).
  static const double camaPorAveEngorde = 0.20;

  /// Costo de mano de obra por 1000 aves/mes (S/).
  static const double manoObraPor1000AvesMes = 450.0;

  /// Costo de desinfección y bioseguridad por ave/ciclo (S/).
  static const double bioseguridadPorAve = 0.10;

  /// Precio de venta de gallina de descarte (S//kg).
  static const double gallinaDescarteKg = 3.50;

  /// Precio saco de gallinaza 50 kg (S/).
  static const double gallinaza50Kg = 15.0;
}

// =============================================================================
// EQUIPAMIENTO REQUERIDO
// =============================================================================

/// Equipamiento necesario por cantidad de aves.
class EquipamientoRecomendado {
  const EquipamientoRecomendado({
    required this.nombre,
    required this.avesPorUnidad,
    required this.costoUnitario,
    this.categoria = '',
  });

  final String nombre;

  /// Cuántas aves cubre una unidad.
  final int avesPorUnidad;

  /// Costo unitario referencial (S/).
  final double costoUnitario;

  /// Categoría funcional para agrupación.
  final String categoria;

  /// Calcula unidades necesarias para N aves.
  int unidadesNecesarias(int aves) => (aves / avesPorUnidad).ceil();

  /// Costo total para N aves.
  double costoTotal(int aves) => unidadesNecesarias(aves) * costoUnitario;
}

// ─── EQUIPAMIENTO ENGORDE ────────────────────────────────────────────────────

/// Equipamiento para galpón MANUAL (engorde).
const equipamientoEngordeManual = [
  // Comederos manuales tipo bandeja / tolva 12 kg
  EquipamientoRecomendado(
    nombre: 'Comedero tipo tolva manual (12 kg)',
    avesPorUnidad: 25,
    costoUnitario: 28.0,
    categoria: 'comedero',
  ),
  // Bebederos tipo campana / tongo (tradicional)
  EquipamientoRecomendado(
    nombre: 'Bebedero tipo campana manual',
    avesPorUnidad: 80,
    costoUnitario: 35.0,
    categoria: 'bebedero',
  ),
  EquipamientoRecomendado(
    nombre: 'Campana criadora a gas (1500 aves)',
    avesPorUnidad: 1500,
    costoUnitario: 350.0,
    categoria: 'campana',
  ),
  EquipamientoRecomendado(
    nombre: 'Balón de gas 10 kg (crianza 14 días)',
    avesPorUnidad: 500,
    costoUnitario: 45.0,
    categoria: 'balonGas',
  ),
  EquipamientoRecomendado(
    nombre: 'Foco incandescente 100W',
    avesPorUnidad: 200,
    costoUnitario: 5.0,
    categoria: 'foco',
  ),
  EquipamientoRecomendado(
    nombre: 'Saco de cascarilla/viruta (25 kg)',
    avesPorUnidad: 10,
    costoUnitario: 8.0,
    categoria: 'cama',
  ),
  EquipamientoRecomendado(
    nombre: 'Termómetro ambiental digital',
    avesPorUnidad: 2000,
    costoUnitario: 25.0,
    categoria: 'termometro',
  ),
  EquipamientoRecomendado(
    nombre: 'Ventilador industrial 24"',
    avesPorUnidad: 1000,
    costoUnitario: 280.0,
    categoria: 'ventilador',
  ),
  EquipamientoRecomendado(
    nombre: 'Caja de transporte pollo (100 aves)',
    avesPorUnidad: 100,
    costoUnitario: 65.0,
    categoria: 'cajaTransporte',
  ),
];

/// Equipamiento para galpón SEMI-AUTOMÁTICO (engorde).
const equipamientoEngordeSemiAuto = [
  EquipamientoRecomendado(
    nombre: 'Comedero tipo tubular (12 kg)',
    avesPorUnidad: 35,
    costoUnitario: 45.0,
    categoria: 'comedero',
  ),
  EquipamientoRecomendado(
    nombre: 'Bebedero automático tipo campana',
    avesPorUnidad: 100,
    costoUnitario: 55.0,
    categoria: 'bebedero',
  ),
  EquipamientoRecomendado(
    nombre: 'Campana criadora a gas (1500 aves)',
    avesPorUnidad: 1500,
    costoUnitario: 350.0,
    categoria: 'campana',
  ),
  EquipamientoRecomendado(
    nombre: 'Balón de gas 10 kg (crianza 14 días)',
    avesPorUnidad: 500,
    costoUnitario: 45.0,
    categoria: 'balonGas',
  ),
  EquipamientoRecomendado(
    nombre: 'Foco ahorrador LED 15W',
    avesPorUnidad: 200,
    costoUnitario: 12.0,
    categoria: 'foco',
  ),
  EquipamientoRecomendado(
    nombre: 'Saco de cascarilla/viruta (25 kg)',
    avesPorUnidad: 10,
    costoUnitario: 8.0,
    categoria: 'cama',
  ),
  EquipamientoRecomendado(
    nombre: 'Termómetro ambiental digital',
    avesPorUnidad: 2000,
    costoUnitario: 25.0,
    categoria: 'termometro',
  ),
  EquipamientoRecomendado(
    nombre: 'Ventilador industrial 24"',
    avesPorUnidad: 1000,
    costoUnitario: 280.0,
    categoria: 'ventilador',
  ),
  EquipamientoRecomendado(
    nombre: 'Caja de transporte pollo (100 aves)',
    avesPorUnidad: 100,
    costoUnitario: 65.0,
    categoria: 'cajaTransporte',
  ),
];

/// Equipamiento para galpón AUTOMÁTICO (engorde).
const equipamientoEngordeAuto = [
  EquipamientoRecomendado(
    nombre: 'Comedero automático tipo plato',
    avesPorUnidad: 50,
    costoUnitario: 85.0,
    categoria: 'comedero',
  ),
  EquipamientoRecomendado(
    nombre: 'Bebedero tipo nipple (línea 3m)',
    avesPorUnidad: 30,
    costoUnitario: 85.0,
    categoria: 'bebedero',
  ),
  EquipamientoRecomendado(
    nombre: 'Campana criadora a gas (1500 aves)',
    avesPorUnidad: 1500,
    costoUnitario: 350.0,
    categoria: 'campana',
  ),
  EquipamientoRecomendado(
    nombre: 'Balón de gas 10 kg (crianza 14 días)',
    avesPorUnidad: 500,
    costoUnitario: 45.0,
    categoria: 'balonGas',
  ),
  EquipamientoRecomendado(
    nombre: 'Foco LED industrial 20W',
    avesPorUnidad: 300,
    costoUnitario: 18.0,
    categoria: 'foco',
  ),
  EquipamientoRecomendado(
    nombre: 'Saco de cascarilla/viruta (25 kg)',
    avesPorUnidad: 10,
    costoUnitario: 8.0,
    categoria: 'cama',
  ),
  EquipamientoRecomendado(
    nombre: 'Termómetro ambiental digital',
    avesPorUnidad: 2000,
    costoUnitario: 25.0,
    categoria: 'termometro',
  ),
  EquipamientoRecomendado(
    nombre: 'Ventilador industrial 24"',
    avesPorUnidad: 1000,
    costoUnitario: 280.0,
    categoria: 'ventilador',
  ),
  EquipamientoRecomendado(
    nombre: 'Caja de transporte pollo (100 aves)',
    avesPorUnidad: 100,
    costoUnitario: 65.0,
    categoria: 'cajaTransporte',
  ),
];

/// Mapa rápido nivel → lista equipamiento engorde.
const equipamientoEngordePorNivel = {
  'manual': equipamientoEngordeManual,
  'semiAutomatico': equipamientoEngordeSemiAuto,
  'automatico': equipamientoEngordeAuto,
};

/// Compat: lista por defecto (semi-auto).
const equipamientoEngorde = equipamientoEngordeSemiAuto;

// ─── EQUIPAMIENTO PONEDORA ───────────────────────────────────────────────────

/// Equipamiento para galpón MANUAL (ponedora).
const equipamientoPonedoraManual = [
  EquipamientoRecomendado(
    nombre: 'Comedero tipo tolva manual (12 kg)',
    avesPorUnidad: 25,
    costoUnitario: 28.0,
    categoria: 'comedero',
  ),
  EquipamientoRecomendado(
    nombre: 'Bebedero tipo campana manual',
    avesPorUnidad: 60,
    costoUnitario: 35.0,
    categoria: 'bebedero',
  ),
  EquipamientoRecomendado(
    nombre: 'Nido comunal (10 huecos)',
    avesPorUnidad: 40,
    costoUnitario: 180.0,
    categoria: 'nidal',
  ),
  EquipamientoRecomendado(
    nombre: 'Campana criadora a gas (1500 aves)',
    avesPorUnidad: 1500,
    costoUnitario: 350.0,
    categoria: 'campana',
  ),
  EquipamientoRecomendado(
    nombre: 'Balón de gas 10 kg (crianza 14 días)',
    avesPorUnidad: 500,
    costoUnitario: 45.0,
    categoria: 'balonGas',
  ),
  EquipamientoRecomendado(
    nombre: 'Foco incandescente 100W',
    avesPorUnidad: 150,
    costoUnitario: 5.0,
    categoria: 'foco',
  ),
  EquipamientoRecomendado(
    nombre: 'Saco de cascarilla/viruta (25 kg)',
    avesPorUnidad: 8,
    costoUnitario: 8.0,
    categoria: 'cama',
  ),
  EquipamientoRecomendado(
    nombre: 'Termómetro ambiental digital',
    avesPorUnidad: 2000,
    costoUnitario: 25.0,
    categoria: 'termometro',
  ),
  EquipamientoRecomendado(
    nombre: 'Ventilador industrial 24"',
    avesPorUnidad: 1000,
    costoUnitario: 280.0,
    categoria: 'ventilador',
  ),
];

/// Equipamiento para galpón SEMI-AUTOMÁTICO (ponedora).
const equipamientoPonedoraSemiAuto = [
  EquipamientoRecomendado(
    nombre: 'Comedero tipo canal (3m)',
    avesPorUnidad: 30,
    costoUnitario: 55.0,
    categoria: 'comedero',
  ),
  EquipamientoRecomendado(
    nombre: 'Bebedero automático tipo campana',
    avesPorUnidad: 80,
    costoUnitario: 55.0,
    categoria: 'bebedero',
  ),
  EquipamientoRecomendado(
    nombre: 'Nido comunal (10 huecos)',
    avesPorUnidad: 40,
    costoUnitario: 180.0,
    categoria: 'nidal',
  ),
  EquipamientoRecomendado(
    nombre: 'Campana criadora a gas (1500 aves)',
    avesPorUnidad: 1500,
    costoUnitario: 350.0,
    categoria: 'campana',
  ),
  EquipamientoRecomendado(
    nombre: 'Balón de gas 10 kg (crianza 14 días)',
    avesPorUnidad: 500,
    costoUnitario: 45.0,
    categoria: 'balonGas',
  ),
  EquipamientoRecomendado(
    nombre: 'Foco ahorrador LED 15W',
    avesPorUnidad: 150,
    costoUnitario: 12.0,
    categoria: 'foco',
  ),
  EquipamientoRecomendado(
    nombre: 'Saco de cascarilla/viruta (25 kg)',
    avesPorUnidad: 8,
    costoUnitario: 8.0,
    categoria: 'cama',
  ),
  EquipamientoRecomendado(
    nombre: 'Termómetro ambiental digital',
    avesPorUnidad: 2000,
    costoUnitario: 25.0,
    categoria: 'termometro',
  ),
  EquipamientoRecomendado(
    nombre: 'Ventilador industrial 24"',
    avesPorUnidad: 1000,
    costoUnitario: 280.0,
    categoria: 'ventilador',
  ),
  EquipamientoRecomendado(
    nombre: 'Sistema de iluminación LED (10m)',
    avesPorUnidad: 500,
    costoUnitario: 120.0,
    categoria: 'iluminacion',
  ),
];

/// Equipamiento para galpón AUTOMÁTICO (ponedora).
const equipamientoPonedoraAuto = [
  EquipamientoRecomendado(
    nombre: 'Comedero automático tipo canal (3m)',
    avesPorUnidad: 40,
    costoUnitario: 95.0,
    categoria: 'comedero',
  ),
  EquipamientoRecomendado(
    nombre: 'Bebedero tipo nipple (línea 3m)',
    avesPorUnidad: 25,
    costoUnitario: 85.0,
    categoria: 'bebedero',
  ),
  EquipamientoRecomendado(
    nombre: 'Nido comunal (10 huecos)',
    avesPorUnidad: 40,
    costoUnitario: 180.0,
    categoria: 'nidal',
  ),
  EquipamientoRecomendado(
    nombre: 'Campana criadora a gas (1500 aves)',
    avesPorUnidad: 1500,
    costoUnitario: 350.0,
    categoria: 'campana',
  ),
  EquipamientoRecomendado(
    nombre: 'Balón de gas 10 kg (crianza 14 días)',
    avesPorUnidad: 500,
    costoUnitario: 45.0,
    categoria: 'balonGas',
  ),
  EquipamientoRecomendado(
    nombre: 'Foco LED industrial 20W',
    avesPorUnidad: 200,
    costoUnitario: 18.0,
    categoria: 'foco',
  ),
  EquipamientoRecomendado(
    nombre: 'Saco de cascarilla/viruta (25 kg)',
    avesPorUnidad: 8,
    costoUnitario: 8.0,
    categoria: 'cama',
  ),
  EquipamientoRecomendado(
    nombre: 'Termómetro ambiental digital',
    avesPorUnidad: 2000,
    costoUnitario: 25.0,
    categoria: 'termometro',
  ),
  EquipamientoRecomendado(
    nombre: 'Ventilador industrial 24"',
    avesPorUnidad: 1000,
    costoUnitario: 280.0,
    categoria: 'ventilador',
  ),
  EquipamientoRecomendado(
    nombre: 'Sistema de iluminación LED (10m)',
    avesPorUnidad: 500,
    costoUnitario: 120.0,
    categoria: 'iluminacion',
  ),
];

/// Mapa rápido nivel → lista equipamiento ponedora.
const equipamientoPonedoraPorNivel = {
  'manual': equipamientoPonedoraManual,
  'semiAutomatico': equipamientoPonedoraSemiAuto,
  'automatico': equipamientoPonedoraAuto,
};

/// Compat: lista por defecto (semi-auto).
const equipamientoPonedora = equipamientoPonedoraSemiAuto;
