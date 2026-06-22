/// Servicio que genera las tareas diarias para un lote según su edad.
library;

import 'dart:math';

import '../../../lotes/domain/entities/lote.dart';
import '../../../lotes/domain/enums/tipo_ave.dart';
import '../../domain/entities/guia_semanal.dart';
import '../../domain/entities/tarea_diaria.dart';
import '../../domain/enums/categoria_tarea.dart';
import '../../infrastructure/data/guias_data_source.dart';
import '../../infrastructure/data/vacunacion_data.dart';

/// Resultado completo de la guía diaria para un lote.
class GuiaDiariaResult {
  const GuiaDiariaResult({
    required this.diaActual,
    required this.tareas,
    required this.guiaSemanal,
    required this.avesActuales,
    required this.diasCiclo,
  });

  /// Día de vida actual del lote.
  final int diaActual;

  /// Lista de tareas para el día.
  final List<TareaDiaria> tareas;

  /// Guía semanal interpolada para el día actual.
  final GuiaSemanal? guiaSemanal;

  /// Aves actuales en el lote.
  final int avesActuales;

  /// Días totales del ciclo.
  final int diasCiclo;
}

/// Genera las tareas diarias para un lote.
class GuiaDiariaGenerator {
  const GuiaDiariaGenerator._();

  /// Genera todas las tareas para el día actual del lote.
  static GuiaDiariaResult generar(Lote lote) {
    final diaActual = lote.edadActualDias;
    final avesActuales = lote.avesActuales;
    final diasCiclo = lote.tipoAve.diasCicloTipico;

    final guias = GuiasDataSource.obtenerGuias(lote.tipoAve);
    final semanaActual = lote.edadActualSemanas;
    final guiaSemanal = _interpolarSemana(guias, semanaActual);

    final tareas = <TareaDiaria>[];

    if (guiaSemanal != null) {
      // Alimentación
      final totalAlimentoKg = (guiaSemanal.alimentoGAve * avesActuales) / 1000;
      tareas.add(
        TareaDiaria(
          id: 'alimentacion_$diaActual',
          categoria: CategoriaTarea.alimentacion,
          titulo: guiaSemanal.tipoAlimento ?? 'Alimento',
          descripcion:
              '${guiaSemanal.alimentoGAve.toStringAsFixed(0)} g/ave — '
              '${totalAlimentoKg.toStringAsFixed(1)} kg total '
              '($avesActuales aves)',
          valorNumerico: guiaSemanal.alimentoGAve,
          unidad: 'g/ave',
        ),
      );

      // Agua
      final totalAguaL = (guiaSemanal.aguaMlAve * avesActuales) / 1000;
      tareas.add(
        TareaDiaria(
          id: 'agua_$diaActual',
          categoria: CategoriaTarea.agua,
          titulo: 'Agua',
          descripcion:
              '${guiaSemanal.aguaMlAve.toStringAsFixed(0)} ml/ave — '
              '${totalAguaL.toStringAsFixed(1)} L total',
          valorNumerico: guiaSemanal.aguaMlAve,
          unidad: 'ml/ave',
        ),
      );

      // Luz
      tareas.add(
        TareaDiaria(
          id: 'luz_$diaActual',
          categoria: CategoriaTarea.luz,
          titulo: 'Programa de luz',
          descripcion: '${guiaSemanal.luzHoras} horas de luz',
          valorNumerico: guiaSemanal.luzHoras,
          unidad: 'horas',
        ),
      );

      // Temperatura
      if (guiaSemanal.temperaturaC != null) {
        tareas.add(
          TareaDiaria(
            id: 'temperatura_$diaActual',
            categoria: CategoriaTarea.temperatura,
            titulo: 'Temperatura',
            descripcion:
                '${guiaSemanal.temperaturaC!.toStringAsFixed(0)}°C recomendados',
            valorNumerico: guiaSemanal.temperaturaC,
            unidad: '°C',
          ),
        );
      }

      // Humedad
      if (guiaSemanal.humedadPct != null) {
        tareas.add(
          TareaDiaria(
            id: 'humedad_$diaActual',
            categoria: CategoriaTarea.humedad,
            titulo: 'Humedad',
            descripcion:
                '${guiaSemanal.humedadPct!.toStringAsFixed(0)}% humedad relativa',
            valorNumerico: guiaSemanal.humedadPct,
            unidad: '%',
          ),
        );
      }
    }

    // Pesaje (cada 7 días, muestra = 1% del lote, mínimo 10 aves)
    if (diaActual > 0 && diaActual % 7 == 0) {
      final muestra = max(10, (avesActuales * 0.01).ceil());
      tareas.add(
        TareaDiaria(
          id: 'pesaje_$diaActual',
          categoria: CategoriaTarea.pesaje,
          titulo: 'Pesaje semanal',
          descripcion: 'Pesar $muestra aves (1% del lote) y registrar promedio',
          valorNumerico: muestra.toDouble(),
          unidad: 'aves',
        ),
      );
    }

    // Vacunación
    final vacunas = obtenerProgramaVacunacion(lote.tipoAve);
    for (final v in vacunas) {
      if (v.dia == diaActual) {
        tareas.add(
          TareaDiaria(
            id: 'vacuna_${v.dia}_${v.vacuna.hashCode}',
            categoria: CategoriaTarea.vacunacion,
            titulo: v.vacuna,
            descripcion: 'Vía: ${v.via} — $avesActuales aves',
          ),
        );
      }
    }

    // Tareas de manejo general según la edad y tipo de ave
    final tareasManejo = _tareasManejoPorDia(diaActual, lote);
    tareas.addAll(tareasManejo);

    // Tareas de bioseguridad diarias
    tareas.addAll(_tareasBioseguridad(diaActual, lote));

    // Tareas de equipos
    tareas.addAll(_tareasEquipos(diaActual, lote));

    // Tareas de postura (ponedoras, reproductoras, codorniz)
    if (lote.tipoAve.esPostura) {
      tareas.addAll(_tareasPostura(diaActual, lote));
    }

    // Tareas específicas por tipo de ave
    tareas.addAll(_tareasEspecificasTipoAve(diaActual, lote));

    return GuiaDiariaResult(
      diaActual: diaActual,
      tareas: tareas,
      guiaSemanal: guiaSemanal,
      avesActuales: avesActuales,
      diasCiclo: diasCiclo,
    );
  }

  /// Genera tareas para un día específico (no necesariamente hoy).
  static GuiaDiariaResult generarParaDia(Lote lote, int dia) {
    final loteSimulado = lote.copyWith(
      fechaIngreso: DateTime.now().subtract(
        Duration(days: dia - lote.edadIngresoDias),
      ),
    );
    return generar(loteSimulado);
  }

  // ===========================================================================
  // MANEJO GENERAL
  // ===========================================================================

  static List<TareaDiaria> _tareasManejoPorDia(int dia, Lote lote) {
    final tareas = <TareaDiaria>[];
    final avesActuales = lote.avesActuales;

    // --- Día 0: Recepción ---
    if (dia == 0) {
      tareas.add(
        const TareaDiaria(
          id: 'manejo_recepcion',
          categoria: CategoriaTarea.manejoGeneral,
          titulo: 'Recepción de aves',
          descripcion:
              'Verificar temperatura del galpón, agua con '
              'vitaminas+electrolitos disponible, conteo individual',
        ),
      );
    }

    // --- Días 0-3: Revisión intensiva de pollitos ---
    if (dia <= 3) {
      tareas.add(
        TareaDiaria(
          id: 'manejo_revision_$dia',
          categoria: CategoriaTarea.manejoGeneral,
          titulo: 'Revisión intensiva de crías',
          descripcion:
              'Verificar llenado de buche (>95%), estado de hidratación, '
              'comportamiento y distribución uniforme en el galpón',
        ),
      );
    }

    // --- Mortalidad diaria (todos los días) ---
    tareas.add(
      TareaDiaria(
        id: 'manejo_mortalidad_$dia',
        categoria: CategoriaTarea.manejoGeneral,
        titulo: 'Registro de mortalidad',
        descripcion:
            'Retirar aves muertas, registrar cantidad y posible causa. '
            'Meta: <${(lote.tipoAve.mortalidadEsperada / (lote.tipoAve.diasCicloTipico)).toStringAsFixed(2)}%/día',
      ),
    );

    // --- Revisión de cama (semanal) ---
    if (dia > 0 && dia % 7 == 0) {
      tareas.add(
        TareaDiaria(
          id: 'manejo_cama_$dia',
          categoria: CategoriaTarea.manejoGeneral,
          titulo: 'Revisión de cama',
          descripcion:
              'Verificar humedad de cama (<25%), voltear o agregar '
              'material seco según necesidad. Remover zonas apelmazadas',
        ),
      );
    }

    // --- Expansión de espacio (día 5-7 según tipo) ---
    if (dia == 5 &&
        (lote.tipoAve == TipoAve.polloEngorde ||
            lote.tipoAve == TipoAve.pavo)) {
      tareas.add(
        const TareaDiaria(
          id: 'manejo_expansion',
          categoria: CategoriaTarea.manejoGeneral,
          titulo: 'Retirar guardera/cerco de crianza',
          descripcion:
              'Ampliar el espacio disponible retirando el cerco de '
              'crianza. Verificar acceso libre a comederos y bebederos',
        ),
      );
    }

    // --- Despique (según tipo de ave) ---
    // Ponedoras: 7-10 días
    if (dia == 8 &&
        (lote.tipoAve == TipoAve.gallinaPonedora ||
            lote.tipoAve == TipoAve.reproductoraLiviana)) {
      tareas.add(
        TareaDiaria(
          id: 'manejo_despique_1',
          categoria: CategoriaTarea.manejoGeneral,
          titulo: 'Primer despique',
          descripcion:
              'Recorte de pico (1/3 del pico superior) con cuchilla '
              'caliente. Administrar vitamina K 2 días antes. '
              '$avesActuales aves',
        ),
      );
    }
    // Reproductora pesada: día 7
    if (dia == 7 && lote.tipoAve == TipoAve.reproductoraPesada) {
      tareas.add(
        TareaDiaria(
          id: 'manejo_despique_repro',
          categoria: CategoriaTarea.manejoGeneral,
          titulo: 'Despique de reproductoras',
          descripcion:
              'Recorte de pico (1/3 superior) con cuchilla caliente. '
              'Vitamina K preventiva 2 días antes. $avesActuales aves',
        ),
      );
    }
    // Segundo despique ponedoras: semana 8-10 (día 56-70)
    if (dia == 63 &&
        (lote.tipoAve == TipoAve.gallinaPonedora ||
            lote.tipoAve == TipoAve.reproductoraLiviana)) {
      tareas.add(
        const TareaDiaria(
          id: 'manejo_despique_2',
          categoria: CategoriaTarea.manejoGeneral,
          titulo: 'Segundo despique (repaso)',
          descripcion:
              'Repaso del recorte de pico en aves que lo necesiten. '
              'Administrar vitamina K 2 días antes',
        ),
      );
    }

    // --- Selección / descarte por uniformidad (semanas 4, 8, 12) ---
    if (lote.tipoAve.esPostura && (dia == 28 || dia == 56 || dia == 84)) {
      tareas.add(
        TareaDiaria(
          id: 'manejo_seleccion_$dia',
          categoria: CategoriaTarea.manejoGeneral,
          titulo: 'Selección por uniformidad',
          descripcion:
              'Pesar muestra de aves y separar las que estén fuera del '
              'rango ±10% del peso promedio objetivo. '
              'Recalibrar alimentación por grupos',
        ),
      );
    }

    // --- Retiro de alimento pre-sacrificio (pollos/pavos/patos) ---
    if (!lote.tipoAve.esPostura) {
      final diasSacrificio = lote.tipoAve.diasCicloTipico;
      if (dia == diasSacrificio - 1) {
        tareas.add(
          const TareaDiaria(
            id: 'manejo_retiro_alimento',
            categoria: CategoriaTarea.manejoGeneral,
            titulo: 'Retiro de alimento (pre-sacrificio)',
            descripcion:
                'Retirar alimento 8-12 horas antes del sacrificio. '
                'Mantener agua disponible. Reducir luz para calmar aves',
          ),
        );
      }
      // Día del sacrificio
      if (dia == diasSacrificio) {
        tareas.add(
          TareaDiaria(
            id: 'manejo_sacrificio',
            categoria: CategoriaTarea.manejoGeneral,
            titulo: 'Día de sacrificio/venta',
            descripcion:
                'Coordinar carga de aves. Registrar peso final y '
                'cantidad. Total: $avesActuales aves',
          ),
        );
      }
    }

    return tareas;
  }

  // ===========================================================================
  // BIOSEGURIDAD
  // ===========================================================================

  static List<TareaDiaria> _tareasBioseguridad(int dia, Lote lote) {
    final tareas = <TareaDiaria>[];

    // Pediluvio / control de acceso (diario)
    tareas.add(
      TareaDiaria(
        id: 'bio_pediluvio_$dia',
        categoria: CategoriaTarea.bioseguridad,
        titulo: 'Pediluvio y control de acceso',
        descripcion:
            'Verificar desinfectante en pediluvio (cambiar cada 2-3 días). '
            'Restringir acceso de personas no autorizadas',
      ),
    );

    // Limpieza de bebederos (diario)
    tareas.add(
      TareaDiaria(
        id: 'bio_limpieza_bebederos_$dia',
        categoria: CategoriaTarea.bioseguridad,
        titulo: 'Limpieza de bebederos',
        descripcion:
            'Lavar y desinfectar bebederos. Verificar flujo de agua '
            'y ausencia de fugas o contaminación',
      ),
    );

    // Limpieza de comederos (diario)
    tareas.add(
      TareaDiaria(
        id: 'bio_limpieza_comederos_$dia',
        categoria: CategoriaTarea.bioseguridad,
        titulo: 'Revisión de comederos',
        descripcion:
            'Verificar que no haya alimento húmedo o enmohecido. '
            'Limpiar restos acumulados',
      ),
    );

    // Desinfección profunda (cada 2 semanas)
    if (dia > 0 && dia % 14 == 0) {
      tareas.add(
        TareaDiaria(
          id: 'bio_desinfeccion_$dia',
          categoria: CategoriaTarea.bioseguridad,
          titulo: 'Desinfección del galpón',
          descripcion:
              'Aplicar desinfectante en paredes, pisos y equipos. '
              'Verificar programa de control de roedores e insectos',
        ),
      );
    }

    return tareas;
  }

  // ===========================================================================
  // EQUIPOS
  // ===========================================================================

  static List<TareaDiaria> _tareasEquipos(int dia, Lote lote) {
    final tareas = <TareaDiaria>[];

    // Ajuste de comederos/bebederos: semana 1, 2, 3, 4
    if (dia == 7 || dia == 14 || dia == 21 || dia == 28) {
      tareas.add(
        TareaDiaria(
          id: 'equipos_ajuste_$dia',
          categoria: CategoriaTarea.equipos,
          titulo: 'Ajustar altura de equipos',
          descripcion:
              'Subir comederos y bebederos al nivel del lomo de las aves. '
              'Semana ${dia ~/ 7}: verificar espacio por ave',
        ),
      );
    }

    // Cambio de tipo de bebedero (día 5-7 según tipo)
    if (dia == 6 &&
        (lote.tipoAve == TipoAve.polloEngorde ||
            lote.tipoAve == TipoAve.pavo ||
            lote.tipoAve == TipoAve.pato)) {
      tareas.add(
        const TareaDiaria(
          id: 'equipos_cambio_bebedero',
          categoria: CategoriaTarea.equipos,
          titulo: 'Transición de bebederos',
          descripcion:
              'Cambiar de bebederos de inicio (mini) a bebederos '
              'automáticos/niple. Mantener ambos 1-2 días',
        ),
      );
    }

    // Verificación de ventilación (diario primeros 14 días, luego semanal)
    if (dia <= 14 || (dia > 14 && dia % 7 == 0)) {
      tareas.add(
        TareaDiaria(
          id: 'equipos_ventilacion_$dia',
          categoria: CategoriaTarea.equipos,
          titulo: 'Control de ventilación',
          descripcion: dia <= 14
              ? 'Verificar cortinas/extractores. Evitar corrientes '
                    'directas sobre las crías. Min. ventilación activa'
              : 'Ajustar ventilación según temperatura y edad. '
                    'Verificar funcionamiento de extractores/cortinas',
        ),
      );
    }

    return tareas;
  }

  // ===========================================================================
  // POSTURA (ponedoras, reproductoras, codorniz)
  // ===========================================================================

  static List<TareaDiaria> _tareasPostura(int dia, Lote lote) {
    final tareas = <TareaDiaria>[];
    final tipo = lote.tipoAve;
    final avesActuales = lote.avesActuales;

    // Edad de inicio de postura estimada
    final diaInicioPostura = switch (tipo) {
      TipoAve.gallinaPonedora => 126, // ~18 semanas
      TipoAve.reproductoraPesada => 154, // ~22 semanas
      TipoAve.reproductoraLiviana => 133, // ~19 semanas
      TipoAve.codorniz => 42, // ~6 semanas
      _ => 140,
    };

    // Preparación de nidos (2 semanas antes de postura esperada)
    if (dia == diaInicioPostura - 14) {
      tareas.add(
        const TareaDiaria(
          id: 'postura_preparar_nidos',
          categoria: CategoriaTarea.postura,
          titulo: 'Instalar/preparar nidos',
          descripcion:
              'Colocar nidos limpios con viruta/paja. '
              '1 nido cada 4-5 aves. Ubicar en zona tranquila y oscura',
        ),
      );
    }

    // Estimulación lumínica pre-postura (4 semanas antes)
    if (dia == diaInicioPostura - 28) {
      tareas.add(
        const TareaDiaria(
          id: 'postura_estimulacion_luz',
          categoria: CategoriaTarea.postura,
          titulo: 'Iniciar estimulación lumínica',
          descripcion:
              'Aumentar gradualmente horas de luz (+1h/semana) hasta '
              'alcanzar 16h. Estimula desarrollo del aparato reproductor',
        ),
      );
    }

    // Recolección de huevos (diario, desde inicio postura)
    if (dia >= diaInicioPostura) {
      final posturaEsperada = tipo.posturaEsperada;
      final huevosEstimados = (avesActuales * posturaEsperada / 100).round();

      tareas.add(
        TareaDiaria(
          id: 'postura_recoleccion_$dia',
          categoria: CategoriaTarea.postura,
          titulo: 'Recolección de huevos',
          descripcion:
              'Recoger huevos mínimo 3 veces/día. '
              'Estimado: ~$huevosEstimados huevos '
              '(${posturaEsperada.toStringAsFixed(0)}% postura)',
          valorNumerico: huevosEstimados.toDouble(),
          unidad: 'huevos',
        ),
      );

      // Revisión de nidos
      tareas.add(
        TareaDiaria(
          id: 'postura_nidos_$dia',
          categoria: CategoriaTarea.postura,
          titulo: 'Revisión de nidos',
          descripcion:
              'Verificar limpieza de nidos, retirar huevos rotos. '
              'Reemplazar material sucio o húmedo',
        ),
      );

      // Clasificación de huevos (semanal)
      if (dia % 7 == 0) {
        tareas.add(
          TareaDiaria(
            id: 'postura_clasificacion_$dia',
            categoria: CategoriaTarea.postura,
            titulo: 'Clasificación de huevos',
            descripcion:
                'Clasificar por tamaño y calidad de cáscara. '
                'Registrar huevos rotos, sucios y deformes',
          ),
        );
      }
    }

    // Control de peso pre-postura (semanal, desde 4 sem antes)
    if (dia >= diaInicioPostura - 28 &&
        dia < diaInicioPostura &&
        dia % 7 == 0) {
      tareas.add(
        TareaDiaria(
          id: 'postura_peso_pre_$dia',
          categoria: CategoriaTarea.postura,
          titulo: 'Peso pre-postura',
          descripcion:
              'Pesar muestra de aves para verificar uniformidad y '
              'peso objetivo antes del inicio de producción',
        ),
      );
    }

    return tareas;
  }

  // ===========================================================================
  // TAREAS ESPECÍFICAS POR TIPO DE AVE
  // ===========================================================================

  static List<TareaDiaria> _tareasEspecificasTipoAve(int dia, Lote lote) {
    return switch (lote.tipoAve) {
      TipoAve.polloEngorde => _tareasPolloEngorde(dia, lote),
      TipoAve.gallinaPonedora => _tareasGallinaPonedora(dia, lote),
      TipoAve.reproductoraPesada => _tareasReproductoraPesada(dia, lote),
      TipoAve.reproductoraLiviana => _tareasReproductoraLiviana(dia, lote),
      TipoAve.pavo => _tareasPavo(dia, lote),
      TipoAve.codorniz => _tareasCodorniz(dia, lote),
      TipoAve.pato => _tareasPato(dia, lote),
      TipoAve.otro => [],
    };
  }

  // --- POLLO DE ENGORDE ---
  static List<TareaDiaria> _tareasPolloEngorde(int dia, Lote lote) {
    final tareas = <TareaDiaria>[];

    // Cambio de alimento: Sem 0→1 Pre-inicio→Inicio, 2→3 Inicio→Crecim, 4→5 Crecim→Final
    if (dia == 7) {
      tareas.add(
        const TareaDiaria(
          id: 'engorde_cambio_alim_1',
          categoria: CategoriaTarea.alimentacion,
          titulo: 'Cambio: Pre-iniciador → Iniciador',
          descripcion:
              'Transición gradual de alimento (mezclar 50/50 por 1-2 días). '
              'Verificar tamaño del pellet adecuado',
        ),
      );
    }
    if (dia == 21) {
      tareas.add(
        const TareaDiaria(
          id: 'engorde_cambio_alim_2',
          categoria: CategoriaTarea.alimentacion,
          titulo: 'Cambio: Iniciador → Crecimiento',
          descripcion:
              'Transición gradual de alimento. Mayor contenido energético, '
              'menor proteína. Verificar consumo post-cambio',
        ),
      );
    }
    if (dia == 35) {
      tareas.add(
        const TareaDiaria(
          id: 'engorde_cambio_alim_3',
          categoria: CategoriaTarea.alimentacion,
          titulo: 'Cambio: Crecimiento → Finalizador',
          descripcion:
              'Última transición de alimento. Sin coccidiostato. '
              'Verificar periodo de retiro de medicamentos',
        ),
      );
    }

    // Conversión alimenticia (semanal desde sem 3)
    if (dia >= 21 && dia % 7 == 0) {
      tareas.add(
        TareaDiaria(
          id: 'engorde_conversion_$dia',
          categoria: CategoriaTarea.pesaje,
          titulo: 'Calcular conversión alimenticia',
          descripcion:
              'CA = Alimento consumido (kg) / Peso ganado (kg). '
              'Objetivo sem ${dia ~/ 7}: <${(1.2 + (dia ~/ 7) * 0.1).toStringAsFixed(1)}',
        ),
      );
    }

    // Control de pododermatitis (semanal desde sem 3)
    if (dia >= 21 && dia % 7 == 0) {
      tareas.add(
        TareaDiaria(
          id: 'engorde_podo_$dia',
          categoria: CategoriaTarea.manejoGeneral,
          titulo: 'Inspección de patas',
          descripcion:
              'Revisar muestra de aves para pododermatitis. '
              'Si >10% afectadas, mejorar cama y ventilación',
        ),
      );
    }

    return tareas;
  }

  // --- GALLINA PONEDORA ---
  static List<TareaDiaria> _tareasGallinaPonedora(int dia, Lote lote) {
    final tareas = <TareaDiaria>[];

    // Cambios de alimento
    if (dia == 42) {
      tareas.add(
        const TareaDiaria(
          id: 'pon_cambio_alim_crec',
          categoria: CategoriaTarea.alimentacion,
          titulo: 'Cambio: Iniciador → Crecimiento',
          descripcion:
              'Transición gradual (3 días). Reducir proteína, '
              'ajustar energía para crecimiento controlado',
        ),
      );
    }
    if (dia == 112) {
      tareas.add(
        const TareaDiaria(
          id: 'pon_cambio_alim_prepost',
          categoria: CategoriaTarea.alimentacion,
          titulo: 'Cambio: Crecimiento → Pre-postura',
          descripcion:
              'Alimento con mayor calcio (2%). Preparar aparato '
              'reproductor. Transición gradual 3-5 días',
        ),
      );
    }
    if (dia == 126) {
      tareas.add(
        const TareaDiaria(
          id: 'pon_cambio_alim_postura',
          categoria: CategoriaTarea.alimentacion,
          titulo: 'Cambio: Pre-postura → Postura',
          descripcion:
              'Alimento de postura con 3.5-4% calcio. '
              'Monitorear consumo diario para producción óptima',
        ),
      );
    }

    // Monitoreo de pico de producción (sem 25-30)
    if (dia >= 175 && dia <= 210 && dia % 7 == 0) {
      tareas.add(
        TareaDiaria(
          id: 'pon_pico_$dia',
          categoria: CategoriaTarea.postura,
          titulo: 'Monitoreo de pico productivo',
          descripcion:
              'Verificar que la producción alcance >90%. '
              'Revisar: iluminación constante 16h, consumo de alimento, '
              'calidad de agua',
        ),
      );
    }

    return tareas;
  }

  // --- REPRODUCTORA PESADA ---
  static List<TareaDiaria> _tareasReproductoraPesada(int dia, Lote lote) {
    final tareas = <TareaDiaria>[];

    // Alimentación restringida (desde sem 3)
    if (dia >= 21 && dia % 7 == 0 && dia < 154) {
      tareas.add(
        TareaDiaria(
          id: 'repro_p_alim_ctrl_$dia',
          categoria: CategoriaTarea.alimentacion,
          titulo: 'Control de peso (alimentación restringida)',
          descripcion:
              'Pesar muestra y ajustar ración según curva objetivo. '
              'Alimentación controlada: evitar sobrepeso reproductivo',
        ),
      );
    }

    // Introducción de machos (día ~147, semana 21)
    if (dia == 147) {
      tareas.add(
        const TareaDiaria(
          id: 'repro_p_machos',
          categoria: CategoriaTarea.manejoGeneral,
          titulo: 'Introducción de machos',
          descripcion:
              'Introducir machos al lote (ratio 1:8 a 1:10). '
              'Verificar peso y condición de machos. '
              'Observar comportamiento de apareamiento',
        ),
      );
    }

    // Pesaje separado machos/hembras (semanal desde sem 21)
    if (dia >= 147 && dia % 7 == 0) {
      tareas.add(
        TareaDiaria(
          id: 'repro_p_peso_sep_$dia',
          categoria: CategoriaTarea.pesaje,
          titulo: 'Pesaje separado machos y hembras',
          descripcion:
              'Pesar machos y hembras por separado. '
              'Ajustar alimentación individual si es necesario',
        ),
      );
    }

    // Control de fertilidad (semanal desde sem 24)
    if (dia >= 168 && dia % 7 == 0) {
      tareas.add(
        TareaDiaria(
          id: 'repro_p_fertilidad_$dia',
          categoria: CategoriaTarea.postura,
          titulo: 'Control de fertilidad',
          descripcion:
              'Revisar tasa de eclosión. Verificar condición de machos. '
              'Marcar huevos para análisis de embriodiagnóstico',
        ),
      );
    }

    return tareas;
  }

  // --- REPRODUCTORA LIVIANA ---
  static List<TareaDiaria> _tareasReproductoraLiviana(int dia, Lote lote) {
    final tareas = <TareaDiaria>[];

    // Introducción de machos
    if (dia == 133) {
      tareas.add(
        const TareaDiaria(
          id: 'repro_l_machos',
          categoria: CategoriaTarea.manejoGeneral,
          titulo: 'Introducción de machos',
          descripcion:
              'Introducir machos al lote (ratio 1:10 a 1:12). '
              'Verificar peso y condición. Observar apareamiento',
        ),
      );
    }

    // Control de uniformidad (cada 2 semanas en cría)
    if (dia < 133 && dia % 14 == 0 && dia > 0) {
      tareas.add(
        TareaDiaria(
          id: 'repro_l_uniformidad_$dia',
          categoria: CategoriaTarea.pesaje,
          titulo: 'Control de uniformidad',
          descripcion:
              'Pesar 10% del lote. Objetivo: CV <10%. '
              'Separar aves fuera de rango para alimentación diferenciada',
        ),
      );
    }

    return tareas;
  }

  // --- PAVO ---
  static List<TareaDiaria> _tareasPavo(int dia, Lote lote) {
    final tareas = <TareaDiaria>[];

    // Desnoqueado / snood removal (día 14 machos)
    if (dia == 14) {
      tareas.add(
        const TareaDiaria(
          id: 'pavo_desnoqueado',
          categoria: CategoriaTarea.manejoGeneral,
          titulo: 'Desnoqueado (machos)',
          descripcion:
              'Remoción del snood en machos para prevenir lesiones '
              'por picoteo. Aplicar antiséptico',
        ),
      );
    }

    // Corte de uñas (día 21)
    if (dia == 21) {
      tareas.add(
        const TareaDiaria(
          id: 'pavo_corte_unas',
          categoria: CategoriaTarea.manejoGeneral,
          titulo: 'Corte de uñas',
          descripcion:
              'Cortar uñas traseras para prevenir arañazos y lesiones. '
              'Especialmente importante en machos',
        ),
      );
    }

    // Cambio de alimento
    if (dia == 28) {
      tareas.add(
        const TareaDiaria(
          id: 'pavo_cambio_alim_1',
          categoria: CategoriaTarea.alimentacion,
          titulo: 'Cambio: Iniciador → Crecimiento 1',
          descripcion:
              'Transición gradual de alimento. Los pavos requieren '
              'mayor proteína (26%→22%) que los pollos',
        ),
      );
    }
    if (dia == 56) {
      tareas.add(
        const TareaDiaria(
          id: 'pavo_cambio_alim_2',
          categoria: CategoriaTarea.alimentacion,
          titulo: 'Cambio: Crecimiento 1 → Finalizador',
          descripcion:
              'Menor proteína (22%→18%), mayor energía. '
              'Verificar consumo de agua (pavos beben más)',
        ),
      );
    }

    // Monitoreo de patas (semanal desde sem 4)
    if (dia >= 28 && dia % 7 == 0) {
      tareas.add(
        TareaDiaria(
          id: 'pavo_patas_$dia',
          categoria: CategoriaTarea.manejoGeneral,
          titulo: 'Inspección de patas y articulaciones',
          descripcion:
              'Los pavos son propensos a problemas locomotores. '
              'Revisar pododermatitis, cojeras y torsión de patas',
        ),
      );
    }

    return tareas;
  }

  // --- CODORNIZ ---
  static List<TareaDiaria> _tareasCodorniz(int dia, Lote lote) {
    final tareas = <TareaDiaria>[];

    // Separación por sexo (día 21-25)
    if (dia == 22) {
      tareas.add(
        const TareaDiaria(
          id: 'codorniz_sexado',
          categoria: CategoriaTarea.manejoGeneral,
          titulo: 'Sexado y separación',
          descripcion:
              'Separar machos y hembras por plumaje pectoral. '
              'Machos: pecho naranja/rojizo. '
              'Hembras: pecho claro con manchas',
        ),
      );
    }

    // Cambio a alimento de postura (día 35)
    if (dia == 35) {
      tareas.add(
        const TareaDiaria(
          id: 'codorniz_alim_postura',
          categoria: CategoriaTarea.alimentacion,
          titulo: 'Cambio: Crecimiento → Postura',
          descripcion:
              'Alimento con 20% proteína y 3% calcio. '
              'Las codornices requieren alta densidad nutricional',
        ),
      );
    }

    // Control de iluminación estricto (diario desde sem 5)
    if (dia >= 35) {
      tareas.add(
        TareaDiaria(
          id: 'codorniz_luz_$dia',
          categoria: CategoriaTarea.luz,
          titulo: 'Control estricto de iluminación',
          descripcion:
              'Mantener exactamente 16-17h de luz constante. '
              'Variaciones afectan directamente la producción. '
              'Verificar timer y focos de repuesto',
        ),
      );
    }

    // Densidad (control semanal)
    if (dia % 14 == 0 && dia > 0) {
      tareas.add(
        TareaDiaria(
          id: 'codorniz_densidad_$dia',
          categoria: CategoriaTarea.equipos,
          titulo: 'Verificar densidad de jaulas',
          descripcion:
              'Máximo 40-50 aves/m² en piso, 250 cm²/ave en jaula. '
              'Revisar que no haya hacinamiento ni picoteo',
        ),
      );
    }

    return tareas;
  }

  // --- PATO ---
  static List<TareaDiaria> _tareasPato(int dia, Lote lote) {
    final tareas = <TareaDiaria>[];

    // Acceso a agua para baño (desde día 14)
    if (dia >= 14) {
      tareas.add(
        TareaDiaria(
          id: 'pato_agua_bano_$dia',
          categoria: CategoriaTarea.agua,
          titulo: 'Agua para baño/natación',
          descripcion:
              'Proveer acceso a agua para baño. Los patos necesitan '
              'mojar su plumaje para mantener la salud. '
              'Cambiar agua diariamente',
        ),
      );
    }

    // Cambio de alimento
    if (dia == 14) {
      tareas.add(
        const TareaDiaria(
          id: 'pato_cambio_alim_1',
          categoria: CategoriaTarea.alimentacion,
          titulo: 'Cambio: Iniciador → Crecimiento',
          descripcion:
              'Transición de alimento (20%→16% proteína). '
              'Los patos no deben recibir alimento medicado con '
              'ionóforos (tóxico)',
        ),
      );
    }
    if (dia == 35) {
      tareas.add(
        const TareaDiaria(
          id: 'pato_cambio_alim_2',
          categoria: CategoriaTarea.alimentacion,
          titulo: 'Cambio: Crecimiento → Finalizador',
          descripcion:
              'Reducir proteína (16%→14%). Aumentar energía. '
              'Precaución: NO usar alimento medicado para pollos',
        ),
      );
    }

    // Control de plumaje (semanal desde sem 2)
    if (dia >= 14 && dia % 7 == 0) {
      tareas.add(
        TareaDiaria(
          id: 'pato_plumaje_$dia',
          categoria: CategoriaTarea.manejoGeneral,
          titulo: 'Inspección de plumaje',
          descripcion:
              'Verificar desarrollo del plumaje y limpieza. '
              'Buscar signos de arrancamiento o parasitismo',
        ),
      );
    }

    // Niacina (primeras 4 semanas)
    if (dia == 0) {
      tareas.add(
        const TareaDiaria(
          id: 'pato_niacina',
          categoria: CategoriaTarea.alimentacion,
          titulo: 'Suplemento de niacina',
          descripcion:
              'Los patos requieren 2x más niacina que los pollos. '
              'Verificar que el alimento contenga 55-70 mg/kg o '
              'suplementar en agua',
        ),
      );
    }

    return tareas;
  }

  /// Copia de la interpolación del GuiasCalculator para uso interno.
  static GuiaSemanal? _interpolarSemana(List<GuiaSemanal> guias, int semana) {
    if (guias.isEmpty) return null;
    if (semana < guias.first.semana) return guias.first;
    if (semana > guias.last.semana) return guias.last;

    for (final g in guias) {
      if (g.semana == semana) return g;
    }

    GuiaSemanal? anterior;
    GuiaSemanal? siguiente;
    for (int i = 0; i < guias.length - 1; i++) {
      if (guias[i].semana < semana && guias[i + 1].semana > semana) {
        anterior = guias[i];
        siguiente = guias[i + 1];
        break;
      }
    }

    if (anterior == null || siguiente == null) return guias.last;

    final rango = siguiente.semana - anterior.semana;
    final progreso = (semana - anterior.semana) / rango;

    double lerp(double a, double b) => a + (b - a) * progreso;
    double roundTo(double value, int decimals) {
      final m = pow(10.0, decimals);
      return (value * m).roundToDouble() / m;
    }

    return GuiaSemanal(
      semana: semana,
      luzHoras: roundTo(lerp(anterior.luzHoras, siguiente.luzHoras), 1),
      alimentoGAve: roundTo(
        lerp(anterior.alimentoGAve, siguiente.alimentoGAve),
        0,
      ),
      pesoObjetivoG: roundTo(
        lerp(anterior.pesoObjetivoG, siguiente.pesoObjetivoG),
        0,
      ),
      aguaMlAve: roundTo(lerp(anterior.aguaMlAve, siguiente.aguaMlAve), 0),
      tipoAlimento: anterior.tipoAlimento,
      temperaturaC:
          anterior.temperaturaC != null && siguiente.temperaturaC != null
          ? roundTo(lerp(anterior.temperaturaC!, siguiente.temperaturaC!), 1)
          : anterior.temperaturaC,
      humedadPct: anterior.humedadPct != null && siguiente.humedadPct != null
          ? roundTo(lerp(anterior.humedadPct!, siguiente.humedadPct!), 0)
          : anterior.humedadPct,
    );
  }
}
