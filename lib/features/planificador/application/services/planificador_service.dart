/// Servicio principal del planificador avícola.
///
/// Genera un [ResultadoPlan] completo a partir de los datos ingresados
/// por el usuario ([PlanInput]).
library;

import '../../domain/entities/plan_avicola.dart';
import '../../domain/enums/raza_ave.dart';
import '../../domain/enums/zona_climatica.dart';
import '../../infrastructure/data/razas_data.dart';

class PlanificadorService {
  const PlanificadorService._();

  /// Genera el plan completo a partir de la entrada del usuario.
  static ResultadoPlan generar(PlanInput input) {
    if (input.tipoProduccion == TipoProduccion.engorde) {
      return _generarEngorde(input);
    }
    return _generarPonedora(input);
  }

  // ==========================================================================
  // ENGORDE
  // ==========================================================================

  static ResultadoPlan _generarEngorde(PlanInput input) {
    final raza = input.razaEngorde ?? RazaEngorde.cobb500;
    final datos = datosRazasEngorde[raza]!;
    final aves = input.cantidadAves;
    final zona = input.zona;

    final infra = _calcularInfraestructuraEngorde(datos, aves, zona);
    final alim = _calcularAlimentacionEngorde(datos, aves, zona);
    final vac = _calcularVacunacion(datos.vacunas, aves);
    final equipList = _equipamientoEngordePorNivel(input.nivelAutomatizacion);
    final equip = _calcularEquipamiento(equipList, aves);
    final ambiental = _obtenerManejoAmbiental(zona, TipoProduccion.engorde);
    final finanzas = _calcularFinanzasEngorde(
      datos,
      aves,
      alim,
      vac,
      equip,
      input.precioVentaKg,
      zona,
    );
    final crono = _generarCronogramaEngorde(datos);

    return ResultadoPlan(
      input: input,
      infraestructura: infra,
      alimentacion: alim,
      vacunacion: vac,
      manejoAmbiental: ambiental,
      proyeccionFinanciera: finanzas,
      cronograma: crono,
      equipamiento: equip,
    );
  }

  static InfraestructuraRecomendada _calcularInfraestructuraEngorde(
    DatosRazaEngorde datos,
    int aves,
    ZonaClimatica zona,
  ) {
    final densidad = datos.densidadAvesM2[zona]!;
    final area = aves / densidad;
    // Ancho estándar 10–12m, largo calculado
    final ancho = area <= 120 ? 10.0 : 12.0;
    final largo = (area / ancho).ceilToDouble();
    final ambient = datosManejoAmbiental[zona]!;

    return InfraestructuraRecomendada(
      areaRequeridaM2: area,
      largoM: largo,
      anchoM: ancho,
      alturaCumbreraM: ambient.alturaCumbrera,
      alturaAleroM: ambient.alturaAlero,
      densidadAvesM2: densidad,
      tipoTecho: ambient.tipoTecho,
      orientacion: ambient.orientacionGalpon,
      observaciones: [
        'Piso de concreto con cama de viruta de madera (8–10 cm)',
        'Pediluvio en la entrada del galpón',
        'Cerco perimetral de bioseguridad',
        if (zona == ZonaClimatica.sierra)
          'Aislamiento térmico reforzado en paredes y techo',
        if (zona == ZonaClimatica.selva)
          'Piso elevado 20–30 cm sobre nivel del terreno',
      ],
    );
  }

  static PlanAlimentacion _calcularAlimentacionEngorde(
    DatosRazaEngorde datos,
    int aves,
    ZonaClimatica zona,
  ) {
    // Sierra: proteína baja ~2 pp por la altitud y menor metabolismo
    // Selva: proteína sube ~0.5 pp por mayor estrés calórico
    final ajusteProteina = switch (zona) {
      ZonaClimatica.sierra => -2.0,
      ZonaClimatica.selva => 0.5,
      ZonaClimatica.costa => 0.0,
    };
    // Sierra: consumo diario aumenta ~8 % para compensar gasto térmico
    final factorConsumo = switch (zona) {
      ZonaClimatica.sierra => 1.08,
      ZonaClimatica.selva => 0.97,
      ZonaClimatica.costa => 1.0,
    };

    final fases = datos.fasesAlimentacion.map((f) {
      final consumoDiario = f.consumoDiarioG * factorConsumo;
      final dias = f.diaFin - f.diaInicio + 1;
      final consumoTotalAveKg = (consumoDiario * dias) / 1000;
      final consumoLote = consumoTotalAveKg * aves;
      return FaseAlimentacionPlan(
        nombre: f.nombre,
        periodo: 'Día ${f.diaInicio} – ${f.diaFin}',
        consumoDiarioPorAveG: consumoDiario,
        consumoTotalPorAveKg: consumoTotalAveKg,
        consumoTotalLoteKg: consumoLote,
        proteina: (f.proteina + ajusteProteina).clamp(14.0, 28.0),
        costoKg: f.costoKg,
        costoTotalFase: consumoTotalAveKg * f.costoKg * aves,
      );
    }).toList();

    final consumoTotal = fases.fold(0.0, (s, f) => s + f.consumoTotalPorAveKg);
    final costoTotal = fases.fold(0.0, (s, f) => s + f.costoTotalFase);
    return PlanAlimentacion(
      fases: fases,
      consumoTotalPorAveKg: consumoTotal,
      consumoTotalLoteKg: consumoTotal * aves,
      costoTotalPorAve: costoTotal / aves,
      costoTotalLote: costoTotal,
    );
  }

  static ProyeccionFinanciera _calcularFinanzasEngorde(
    DatosRazaEngorde datos,
    int aves,
    PlanAlimentacion alim,
    PlanVacunacion vac,
    List<ItemEquipamiento> equip,
    double? precioVentaPersonalizado,
    ZonaClimatica zona,
  ) {
    // Aves que llegan al final (descontando mortalidad)
    final avesFinales = (aves * (1 - datos.mortalidadEsperada)).floor();

    // Costos
    final costoPollitos = datos.costoPollitoBB * aves;
    final costoAlimento = alim.costoTotalLote;
    final costoVacunas = vac.costoTotalLote;
    final costoEquipamiento = equip.fold(0.0, (s, e) => s + e.costoTotal);
    final costoElectricidad =
        PreciosMercadoPeru.electricidadPorAveEngorde * aves;
    final costoGas = PreciosMercadoPeru.gasPorAveEngorde * aves;
    final costoCama = PreciosMercadoPeru.camaPorAveEngorde * aves;
    final costoBioseguridad = PreciosMercadoPeru.bioseguridadPorAve * aves;
    final mesesCiclo = datos.diasCiclo / 30;
    final costoManoObra =
        (aves / 1000).ceil() *
        PreciosMercadoPeru.manoObraPor1000AvesMes *
        mesesCiclo;

    final inversionInicial = costoPollitos + costoEquipamiento;
    final costosOperativos =
        costoAlimento +
        costoVacunas +
        costoElectricidad +
        costoGas +
        costoCama +
        costoBioseguridad +
        costoManoObra;
    final costoTotal = inversionInicial + costosOperativos;

    // Ingresos
    final precioVenta =
        precioVentaPersonalizado ?? PreciosMercadoPeru.polloVivoGranjaKg;
    final pesoVentaKg = datos.pesoObjetivoKg;
    final ingreso = avesFinales * pesoVentaKg * precioVenta;

    // Ingreso por gallinaza (subproducto)
    // ~1 saco de 50kg por cada 100 aves
    final sacosGallinaza = (aves / 100).ceil();
    final ingresoGallinaza = sacosGallinaza * PreciosMercadoPeru.gallinaza50Kg;

    final ganancia = ingreso + ingresoGallinaza - costoTotal;
    final margen = ingreso > 0 ? ganancia / ingreso : 0.0;

    return ProyeccionFinanciera(
      inversionInicial: inversionInicial,
      costosOperativos: costosOperativos,
      costoTotal: costoTotal,
      ingresoProyectado: ingreso,
      gananciaProyectada: ganancia,
      margenGanancia: margen,
      precioVentaUsado: precioVenta,
      fechaReferenciaPrecios: PreciosMercadoPeru.fechaReferencia,
      ingresosAdicionales: {'Gallinaza': ingresoGallinaza},
      costosPorCategoria: {
        'Pollitos BB': costoPollitos,
        'Alimento balanceado': costoAlimento,
        'Vacunas': costoVacunas,
        'Equipamiento': costoEquipamiento,
        'Electricidad': costoElectricidad,
        'Gas / Calefacción': costoGas,
        'Cama (viruta)': costoCama,
        'Bioseguridad': costoBioseguridad,
        'Mano de obra': costoManoObra,
      },
    );
  }

  static List<EventoCronograma> _generarCronogramaEngorde(
    DatosRazaEngorde datos,
  ) {
    final eventos = <EventoCronograma>[];

    // Eventos de alimentación por fase
    for (final fase in datos.fasesAlimentacion) {
      eventos.add(
        EventoCronograma(
          dia: fase.diaInicio,
          titulo: 'Cambio a ${fase.nombre}',
          descripcion:
              '${fase.consumoDiarioG.toStringAsFixed(0)} g/ave/día — '
              'Proteína ${fase.proteina}%',
          categoria: CategoriaCronograma.alimentacion,
        ),
      );
    }

    // Eventos de vacunación
    for (final vac in datos.vacunas) {
      eventos.add(
        EventoCronograma(
          dia: vac.dia,
          titulo: vac.nombre,
          descripcion: 'Vía: ${vac.via}',
          categoria: CategoriaCronograma.vacunacion,
        ),
      );
    }

    // Eventos de manejo clave
    eventos.addAll([
      const EventoCronograma(
        dia: 1,
        titulo: 'Recepción de pollitos',
        descripcion:
            'Verificar temperatura 32–34°C, agua con vitaminas + electrolitos, '
            'iluminación 24h las primeras 48h',
        categoria: CategoriaCronograma.manejo,
      ),
      const EventoCronograma(
        dia: 7,
        titulo: 'Primer pesaje de control',
        descripcion:
            'Pesar muestra del 5% del lote, comparar con tabla de la raza',
        categoria: CategoriaCronograma.manejo,
      ),
      const EventoCronograma(
        dia: 14,
        titulo: 'Ajuste de densidad y cortinas',
        descripcion: 'Ampliar espacio si es necesario, regular ventilación',
        categoria: CategoriaCronograma.manejo,
      ),
      const EventoCronograma(
        dia: 21,
        titulo: 'Control de cama',
        descripcion: 'Voltear cama, verificar humedad (<30%), agregar viruta',
        categoria: CategoriaCronograma.manejo,
      ),
      const EventoCronograma(
        dia: 35,
        titulo: 'Pesaje pre-sacrificio',
        descripcion: 'Pesar muestra del 5%, evaluar uniformidad del lote',
        categoria: CategoriaCronograma.manejo,
      ),
      EventoCronograma(
        dia: datos.diasCiclo,
        titulo: 'Venta / Sacrificio',
        descripcion:
            'Peso objetivo: ${datos.pesoObjetivoKg.toStringAsFixed(1)} kg — '
            'Retirar alimento 8–12h antes, mantener agua',
        categoria: CategoriaCronograma.venta,
      ),
    ]);

    eventos.sort((a, b) => a.dia.compareTo(b.dia));
    return eventos;
  }

  // ==========================================================================
  // PONEDORA
  // ==========================================================================

  static ResultadoPlan _generarPonedora(PlanInput input) {
    final raza = input.razaPonedora ?? RazaPonedora.hyLineBrown;
    final datos = datosRazasPonedora[raza]!;
    final aves = input.cantidadAves;
    final zona = input.zona;

    final infra = _calcularInfraestructuraPonedora(datos, aves, zona);
    final alim = _calcularAlimentacionPonedora(datos, aves, zona);
    final vac = _calcularVacunacion(datos.vacunas, aves);
    final equipList = _equipamientoPonedoraPorNivel(input.nivelAutomatizacion);
    final equip = _calcularEquipamiento(equipList, aves);
    final ambiental = _obtenerManejoAmbiental(zona, TipoProduccion.ponedora);
    final finanzas = _calcularFinanzasPonedora(
      datos,
      aves,
      alim,
      vac,
      equip,
      input.precioVentaKg,
    );
    final crono = _generarCronogramaPonedora(datos);

    return ResultadoPlan(
      input: input,
      infraestructura: infra,
      alimentacion: alim,
      vacunacion: vac,
      manejoAmbiental: ambiental,
      proyeccionFinanciera: finanzas,
      cronograma: crono,
      equipamiento: equip,
    );
  }

  static InfraestructuraRecomendada _calcularInfraestructuraPonedora(
    DatosRazaPonedora datos,
    int aves,
    ZonaClimatica zona,
  ) {
    final densidad = datos.densidadAvesM2Piso[zona]!;
    final area = aves / densidad;
    final ancho = area <= 120 ? 10.0 : 12.0;
    final largo = (area / ancho).ceilToDouble();
    final ambient = datosManejoAmbiental[zona]!;

    return InfraestructuraRecomendada(
      areaRequeridaM2: area,
      largoM: largo,
      anchoM: ancho,
      alturaCumbreraM: ambient.alturaCumbrera,
      alturaAleroM: ambient.alturaAlero,
      densidadAvesM2: densidad,
      tipoTecho: ambient.tipoTecho,
      orientacion: ambient.orientacionGalpon,
      observaciones: [
        'Piso de concreto con cama de cascarilla de arroz (10–12 cm)',
        'Nidos accesibles y bien iluminados (1 nido / 4–5 aves)',
        'Programa de luz: 16h luz / 8h oscuridad en producción',
        'Pediluvio en la entrada del galpón',
        if (zona == ZonaClimatica.sierra)
          'Aislamiento térmico reforzado; calefacción en levante',
        if (zona == ZonaClimatica.selva)
          'Piso elevado 25–30 cm; ventilación forzada obligatoria',
      ],
    );
  }

  static PlanAlimentacion _calcularAlimentacionPonedora(
    DatosRazaPonedora datos,
    int aves,
    ZonaClimatica zona,
  ) {
    final ajusteProteina = switch (zona) {
      ZonaClimatica.sierra => -1.5,
      ZonaClimatica.selva => 0.5,
      ZonaClimatica.costa => 0.0,
    };
    final factorConsumo = switch (zona) {
      ZonaClimatica.sierra => 1.06,
      ZonaClimatica.selva => 0.97,
      ZonaClimatica.costa => 1.0,
    };

    final fases = datos.fasesAlimentacion.map((f) {
      final consumoDiario = f.consumoDiarioG * factorConsumo;
      final dias = (f.semanaFin - f.semanaInicio + 1) * 7;
      final consumoTotalAveKg = (consumoDiario * dias) / 1000;
      final consumoLote = consumoTotalAveKg * aves;
      return FaseAlimentacionPlan(
        nombre: f.nombre,
        periodo: 'Semana ${f.semanaInicio} – ${f.semanaFin}',
        consumoDiarioPorAveG: consumoDiario,
        consumoTotalPorAveKg: consumoTotalAveKg,
        consumoTotalLoteKg: consumoLote,
        proteina: (f.proteina + ajusteProteina).clamp(14.0, 28.0),
        costoKg: f.costoKg,
        costoTotalFase: consumoTotalAveKg * f.costoKg * aves,
      );
    }).toList();

    final consumoTotal = fases.fold(0.0, (s, f) => s + f.consumoTotalPorAveKg);
    final costoTotal = fases.fold(0.0, (s, f) => s + f.costoTotalFase);
    return PlanAlimentacion(
      fases: fases,
      consumoTotalPorAveKg: consumoTotal,
      consumoTotalLoteKg: consumoTotal * aves,
      costoTotalPorAve: costoTotal / aves,
      costoTotalLote: costoTotal,
    );
  }

  static ProyeccionFinanciera _calcularFinanzasPonedora(
    DatosRazaPonedora datos,
    int aves,
    PlanAlimentacion alim,
    PlanVacunacion vac,
    List<ItemEquipamiento> equip,
    double? precioVentaPersonalizado,
  ) {
    // Aves que sobreviven al ciclo
    final avesFinales = (aves * datos.viabilidad80Sem).floor();

    // Costos
    final costoPollitas = datos.costoPollitaBB * aves;
    final costoAlimento = alim.costoTotalLote;
    final costoVacunas = vac.costoTotalLote;
    final costoEquipamiento = equip.fold(0.0, (s, e) => s + e.costoTotal);
    final costoElectricidad =
        PreciosMercadoPeru.electricidadPorAvePonedora * aves;
    // Gas solo en crianza (primeras 6 sem) — similar al engorde
    final costoGas = PreciosMercadoPeru.gasPorAveEngorde * aves;
    // Cama renovada ~3 veces en ciclo de 80 semanas
    final costoCama = PreciosMercadoPeru.camaPorAveEngorde * aves * 3;
    final costoBioseguridad = PreciosMercadoPeru.bioseguridadPorAve * aves * 3;
    final mesesCiclo = (datos.semanasCiclo * 7) / 30;
    final costoManoObra =
        (aves / 1000).ceil() *
        PreciosMercadoPeru.manoObraPor1000AvesMes *
        mesesCiclo;

    final inversionInicial = costoPollitas + costoEquipamiento;
    final costosOperativos =
        costoAlimento +
        costoVacunas +
        costoElectricidad +
        costoGas +
        costoCama +
        costoBioseguridad +
        costoManoObra;
    final costoTotal = inversionInicial + costosOperativos;

    // Ingresos por huevo
    final precioHuevoKg =
        precioVentaPersonalizado ?? PreciosMercadoPeru.huevoGranjaKg;
    final huevosTotales = datos.huevosAveAlojada80Sem * aves;
    final kgHuevos = (huevosTotales * datos.pesoHuevoG) / 1000;
    final ingresoHuevos = kgHuevos * precioHuevoKg;

    // Ingresos por descarte (gallina al final del ciclo)
    final ingresoDescarte =
        avesFinales *
        (datos.pesoAveProdG / 1000) *
        PreciosMercadoPeru.gallinaDescarteKg;

    // Gallinaza
    final sacosGallinaza = (aves * mesesCiclo / 80).ceil();
    final ingresoGallinaza = sacosGallinaza * PreciosMercadoPeru.gallinaza50Kg;

    final ingresoTotal = ingresoHuevos + ingresoDescarte + ingresoGallinaza;
    final ganancia = ingresoTotal - costoTotal;
    final margen = ingresoTotal > 0 ? ganancia / ingresoTotal : 0.0;

    return ProyeccionFinanciera(
      inversionInicial: inversionInicial,
      costosOperativos: costosOperativos,
      costoTotal: costoTotal,
      ingresoProyectado: ingresoHuevos,
      gananciaProyectada: ganancia,
      margenGanancia: margen,
      precioVentaUsado: precioHuevoKg,
      fechaReferenciaPrecios: PreciosMercadoPeru.fechaReferencia,
      ingresosAdicionales: {
        'Venta gallina descarte': ingresoDescarte,
        'Gallinaza': ingresoGallinaza,
      },
      costosPorCategoria: {
        'Pollitas BB': costoPollitas,
        'Alimento balanceado': costoAlimento,
        'Vacunas': costoVacunas,
        'Equipamiento': costoEquipamiento,
        'Electricidad': costoElectricidad,
        'Gas / Calefacción (crianza)': costoGas,
        'Cama (viruta)': costoCama,
        'Bioseguridad': costoBioseguridad,
        'Mano de obra': costoManoObra,
      },
    );
  }

  static List<EventoCronograma> _generarCronogramaPonedora(
    DatosRazaPonedora datos,
  ) {
    final eventos = <EventoCronograma>[];

    // Fases de alimentación
    for (final fase in datos.fasesAlimentacion) {
      eventos.add(
        EventoCronograma(
          dia: fase.semanaInicio,
          titulo: 'Cambio a ${fase.nombre}',
          descripcion:
              '${fase.consumoDiarioG.toStringAsFixed(0)} g/ave/día — '
              'Proteína ${fase.proteina}% — Calcio ${fase.calcio}%',
          categoria: CategoriaCronograma.alimentacion,
        ),
      );
    }

    // Vacunas (día = día de vida)
    for (final vac in datos.vacunas) {
      final semana = (vac.dia / 7).ceil();
      eventos.add(
        EventoCronograma(
          dia: semana,
          titulo: vac.nombre,
          descripcion: 'Día ${vac.dia} — Vía: ${vac.via}',
          categoria: CategoriaCronograma.vacunacion,
        ),
      );
    }

    // Eventos clave
    eventos.addAll([
      const EventoCronograma(
        dia: 1,
        titulo: 'Recepción de pollitas',
        descripcion:
            'Temperatura 33–35°C, agua con vitaminas + electrolitos, '
            'iluminación 24h las primeras 48h, densidad de cría',
        categoria: CategoriaCronograma.manejo,
      ),
      EventoCronograma(
        dia: datos.semanaInicioProduccion,
        titulo: 'Inicio estimado de postura',
        descripcion:
            'Semana ${datos.semanaInicioProduccion}: inicio programa de luz '
            '(16h luz/8h oscuridad), cambio a alimento de postura',
        categoria: CategoriaCronograma.produccion,
      ),
      const EventoCronograma(
        dia: 26,
        titulo: 'Pico de producción esperado',
        descripcion: 'Semana 26–30: máxima producción de huevos',
        categoria: CategoriaCronograma.produccion,
      ),
      EventoCronograma(
        dia: datos.semanasCiclo,
        titulo: 'Fin de ciclo / Descarte',
        descripcion:
            'Semana ${datos.semanasCiclo}: fin del ciclo productivo, '
            'venta de gallinas de descarte',
        categoria: CategoriaCronograma.venta,
      ),
    ]);

    eventos.sort((a, b) => a.dia.compareTo(b.dia));
    return eventos;
  }

  // ==========================================================================
  // UTILIDADES COMPARTIDAS
  // ==========================================================================

  static PlanVacunacion _calcularVacunacion(
    List<VacunaPlan> vacunas,
    int aves,
  ) {
    // 10% extra de dosis (para desperdicio/refuerzo)
    final dosisConMargen = (aves * 1.1).ceil();
    final detalles = vacunas.map((v) {
      return VacunaPlanDetalle(
        dia: v.dia,
        nombre: v.nombre,
        via: v.via,
        dosisTotales: dosisConMargen,
        costoTotal: v.costoUnidad * dosisConMargen,
      );
    }).toList();

    final costoTotal = detalles.fold(0.0, (s, d) => s + d.costoTotal);
    return PlanVacunacion(
      vacunas: detalles,
      costoTotalPorAve: costoTotal / aves,
      costoTotalLote: costoTotal,
    );
  }

  static List<ItemEquipamiento> _calcularEquipamiento(
    List<EquipamientoRecomendado> equipos,
    int aves,
  ) {
    return equipos.map((e) {
      final cantidad = e.unidadesNecesarias(aves);
      return ItemEquipamiento(
        nombre: e.nombre,
        cantidad: cantidad,
        costoUnitario: e.costoUnitario,
        costoTotal: e.costoTotal(aves),
      );
    }).toList();
  }

  /// Selecciona lista de equipamiento de engorde según nivel de automatización.
  static List<EquipamientoRecomendado> _equipamientoEngordePorNivel(
    NivelAutomatizacion nivel,
  ) {
    return switch (nivel) {
      NivelAutomatizacion.manual => equipamientoEngordeManual,
      NivelAutomatizacion.semiAutomatico => equipamientoEngordeSemiAuto,
      NivelAutomatizacion.automatico => equipamientoEngordeAuto,
    };
  }

  /// Selecciona lista de equipamiento de ponedora según nivel de automatización.
  static List<EquipamientoRecomendado> _equipamientoPonedoraPorNivel(
    NivelAutomatizacion nivel,
  ) {
    return switch (nivel) {
      NivelAutomatizacion.manual => equipamientoPonedoraManual,
      NivelAutomatizacion.semiAutomatico => equipamientoPonedoraSemiAuto,
      NivelAutomatizacion.automatico => equipamientoPonedoraAuto,
    };
  }

  static RecomendacionAmbiental _obtenerManejoAmbiental(
    ZonaClimatica zona,
    TipoProduccion tipo,
  ) {
    final datos = datosManejoAmbiental[zona]!;
    final temp = tipo == TipoProduccion.engorde
        ? '${datos.tempOptimaBroilerInicio} (inicio) → ${datos.tempOptimaBroilerFinal} (final)'
        : datos.tempOptimaPonedora;

    return RecomendacionAmbiental(
      zona: zona,
      temperaturaOptima: temp,
      humedadRelativa: datos.humedadRelativa,
      tipoVentilacion: datos.tipoVentilacion,
      tipoCortinas: datos.tipoCortinas,
      notasEspeciales: datos.notasEspeciales,
    );
  }

  /// Determina la zona climática por latitud/longitud en Perú.
  static ZonaClimatica determinarZona(double lat, double lng) {
    // Heurística para Perú:
    // Selva: este de los Andes, longitud > -76° aproximadamente y lat < -4°
    // Sierra: >2500 msnm — aproximamos con coordenadas
    // Costa: franja occidental
    //
    // Simplificación basada en longitud:
    // Costa: lng < -79.5 (franja oeste estrecha) o ciudades costeras conocidas
    // Selva: lng > -76 y lat entre -3 y -14
    // Sierra: el resto

    if (lng > -76.0 && lat > -14.0 && lat < -3.0) {
      return ZonaClimatica.selva;
    }
    if (lng < -79.0) {
      return ZonaClimatica.costa;
    }
    // Verificar regiones costeras que están entre -79 y -76
    // Lima, Ica, Arequipa costa, etc.
    if (lat > -18.5 && lat < -3.5 && lng < -76.0 && lng > -80.5) {
      // Franja intermedia: usar latitud para distinguir
      if (lng < -77.5) return ZonaClimatica.costa;
    }
    return ZonaClimatica.sierra;
  }
}
