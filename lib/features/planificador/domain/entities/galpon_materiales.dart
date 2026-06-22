/// Entidades para cálculo de materiales de construcción del galpón.
library;

import 'dart:math';

import 'plan_avicola.dart';

// =============================================================================
// ENUMS DE CONFIGURACIÓN
// =============================================================================

/// Tipo de estructura del galpón.
enum TipoEstructura {
  madera('Madera'),
  metal('Metal');

  const TipoEstructura(this.nombre);
  final String nombre;
}

/// Tipo de cubierta / calamina.
enum TipoCubierta {
  calamina080('Calamina 0.80 × 3.60 m', 0.80, 3.60, 0.72),
  calamina110('Calamina 1.10 × 3.60 m', 1.10, 3.60, 1.00);

  const TipoCubierta(
    this.nombre,
    this.anchoNominal,
    this.largo,
    this.anchoUtil,
  );

  final String nombre;

  /// Ancho nominal de la lámina (m).
  final double anchoNominal;

  /// Largo de la lámina (m).
  final double largo;

  /// Ancho útil descontando traslape lateral (m).
  final double anchoUtil;
}

// =============================================================================
// CONFIGURACIÓN DEL USUARIO
// =============================================================================

/// Parámetros configurables para el cálculo de materiales.
class ConfigMateriales {
  const ConfigMateriales({
    this.tipoEstructura = TipoEstructura.madera,
    this.tipoCubierta = TipoCubierta.calamina080,
    this.separacionPuntalesM = 3.0,
  });

  final TipoEstructura tipoEstructura;
  final TipoCubierta tipoCubierta;

  /// Distancia entre columnas/puntales (metros).
  final double separacionPuntalesM;

  ConfigMateriales copyWith({
    TipoEstructura? tipoEstructura,
    TipoCubierta? tipoCubierta,
    double? separacionPuntalesM,
  }) => ConfigMateriales(
    tipoEstructura: tipoEstructura ?? this.tipoEstructura,
    tipoCubierta: tipoCubierta ?? this.tipoCubierta,
    separacionPuntalesM: separacionPuntalesM ?? this.separacionPuntalesM,
  );
}

// =============================================================================
// RESULTADO: LISTA DE MATERIALES
// =============================================================================

/// Categoría del material.
enum CategoriaMaterial {
  estructura('Estructura'),
  cubierta('Cubierta / Techo'),
  cerramientos('Cerramientos'),
  ferreteria('Ferretería');

  const CategoriaMaterial(this.nombre);
  final String nombre;
}

/// Un ítem individual de material con cantidad calculada.
class ItemMaterial {
  const ItemMaterial({
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.cantidad,
    required this.unidad,
  });

  final String nombre;
  final String descripcion;
  final CategoriaMaterial categoria;
  final double cantidad;
  final String unidad;
}

/// Resultado completo del cálculo de materiales.
class GalponMateriales {
  const GalponMateriales({
    required this.config,
    required this.items,
    required this.pendienteTechoPct,
    required this.longitudPendiente,
    required this.areaRoof,
    required this.perimetro,
  });

  final ConfigMateriales config;
  final List<ItemMaterial> items;

  /// Pendiente del techo en porcentaje.
  final double pendienteTechoPct;

  /// Longitud de cada faldón (hipotenusa) en metros.
  final double longitudPendiente;

  /// Área total de techo (ambos faldones) en m².
  final double areaRoof;

  /// Perímetro del galpón en metros.
  final double perimetro;

  List<ItemMaterial> porCategoria(CategoriaMaterial cat) =>
      items.where((e) => e.categoria == cat).toList();

  // ═══════════════════════════════════════════════════════════════════════════
  // FACTORY: CÁLCULO COMPLETO
  // ═══════════════════════════════════════════════════════════════════════════

  factory GalponMateriales.calcular(
    InfraestructuraRecomendada infra, {
    ConfigMateriales config = const ConfigMateriales(),
  }) {
    final l = infra.largoM;
    final w = infra.anchoM;
    final hA = infra.alturaAleroM;
    final hC = infra.alturaCumbreraM;
    final sep = config.separacionPuntalesM;

    // ── Geometría del techo ───────────────────────────────────────────────
    final halfW = w / 2;
    final rise = hC - hA;
    final slope = sqrt(halfW * halfW + rise * rise);
    final pendientePct = (rise / halfW) * 100;
    final roofArea = 2 * slope * l;
    final perim = 2 * (l + w);

    // ── Puntales / Columnas ───────────────────────────────────────────────
    final colsPerSide = (l / sep).floor() + 1;
    final totalCols = colsPerSide * 2;
    // Columnas intermedias en hastiales (2 por hastial, excluyendo esquinas).
    const colsGable = 2; // un intermedio + pico
    const totalColsGable = colsGable * 2;

    // ── Tijerales / Cerchas ──────────────────────────────────────────────
    final numTijerales = colsPerSide;

    // ── Vigas soleras (sobre columnas, a lo largo) ──────────────────────
    final soleras = 2 * l + 2 * w; // perímetro

    // ── Correas / Largueros ─────────────────────────────────────────────
    const separacionCorreas = 0.60;
    final correasPorFaldon = (slope / separacionCorreas).ceil() + 1;
    final totalCorreas = correasPorFaldon * 2;

    // ── Calaminas ───────────────────────────────────────────────────────
    final cub = config.tipoCubierta;
    final laminasPorFilaLargo = (l / cub.anchoUtil).ceil();
    const traslapeLongitudinal = 0.15;
    final filasPorFaldon = (slope / (cub.largo - traslapeLongitudinal)).ceil();
    final laminasPorFaldon = laminasPorFilaLargo * filasPorFaldon;
    final totalLaminas = laminasPorFaldon * 2;

    // ── Cumbrera / Caballete ────────────────────────────────────────────
    const largoCaballete = 0.83; // pieza estándar
    final pzasCaballete = (l / largoCaballete).ceil();

    // ── Templadores diagonales ──────────────────────────────────────────
    final diagLen = sqrt(sep * sep + hA * hA);
    // 2 en cada esquina (ida+vuelta en X) = 8
    const totalTempladores = 8;

    // ── Arriostres horizontales ─────────────────────────────────────────
    // Primero y último vano + cada 5 vanos
    final numVanosArriostre = 2 + max(0, ((colsPerSide - 2) / 5).floor());
    final totalArriostres = numVanosArriostre * 2; // ambos faldones

    // ── Sobrecimiento / Zapatas ─────────────────────────────────────────
    final totalZapatas = totalCols + totalColsGable;

    // ── Cerramientos: Malla + Cortina ──────────────────────────────────
    // Paredes laterales (largo × alto) + hastiales (ancho × alto promedio)
    final areaLaterales = 2 * l * hA;
    // Hastiales: trapecios con pico
    final areaHastiales = 2 * (w * hA + w * rise / 2);
    final areaTotalParedes = areaLaterales + areaHastiales;
    // Descontar puerta (1.2×2.0)
    final areaMalla = areaTotalParedes - 2.4;
    // Cortinas solo en paredes laterales (largo)
    final areaCortinas = areaLaterales;

    // ── Ferretería ──────────────────────────────────────────────────────
    const clavosCalaminaPorLamina = 12;
    final totalClavosCalamina = totalLaminas * clavosCalaminaPorLamina;
    // Pernos: 2 por columna-viga, 4 por tijeral
    final pernosCols = totalCols * 2 + totalColsGable * 2;
    final pernosTij = numTijerales * 4;
    final totalPernos = pernosCols + pernosTij;
    // Alambre #16 para amarres de correas (2 amarres por cruce)
    final amarresCorreas = totalCorreas * colsPerSide * 2;
    final alambreKg = (amarresCorreas * 0.30) / 1000 * 7.85; // ~30cm × densidad
    // Tornillos autoroscantes para correas-calaminas
    final tornillos = totalLaminas * 8;

    final esMadera = config.tipoEstructura == TipoEstructura.madera;

    // ═══════════════════════════════════════════════════════════════════════
    // LISTA DE MATERIALES
    // ═══════════════════════════════════════════════════════════════════════

    final items = <ItemMaterial>[
      // ── ESTRUCTURA ──────────────────────────────────────────────────────
      ItemMaterial(
        nombre: esMadera
            ? 'Postes rollizos 5" × ${hA.toStringAsFixed(1)} m'
            : 'Tubo cuadrado LAC 3"×3" × ${hA.toStringAsFixed(1)} m',
        descripcion:
            'Columnas laterales cada ${sep.toStringAsFixed(1)} m ($colsPerSide/lado)',
        categoria: CategoriaMaterial.estructura,
        cantidad: totalCols.toDouble(),
        unidad: 'pzas',
      ),
      ItemMaterial(
        nombre: esMadera
            ? 'Postes rollizos 4" × ${hC.toStringAsFixed(1)} m'
            : 'Tubo cuadrado LAC 2"×2" × ${hC.toStringAsFixed(1)} m',
        descripcion: 'Columnas intermedias hastiales ($totalColsGable total)',
        categoria: CategoriaMaterial.estructura,
        cantidad: totalColsGable.toDouble(),
        unidad: 'pzas',
      ),
      ItemMaterial(
        nombre: esMadera
            ? 'Tijeral de madera (luz ${w.toStringAsFixed(1)} m)'
            : 'Cercha metálica (luz ${w.toStringAsFixed(1)} m)',
        descripcion: 'Armadura del techo — flecha ${rise.toStringAsFixed(2)} m',
        categoria: CategoriaMaterial.estructura,
        cantidad: numTijerales.toDouble(),
        unidad: 'pzas',
      ),
      ItemMaterial(
        nombre: esMadera
            ? 'Viga solera 3"×4" (madera aserrada)'
            : 'Perfil C 4"×2" LAC e=2mm',
        descripcion: 'Amarre superior perimetral',
        categoria: CategoriaMaterial.estructura,
        cantidad: soleras,
        unidad: 'm lineales',
      ),
      ItemMaterial(
        nombre: esMadera
            ? 'Correa/larguero 2"×2" (madera)'
            : 'Perfil C 2"×1" LAC e=1.5mm',
        descripcion:
            'Soporte de cubierta cada ${separacionCorreas.toStringAsFixed(2)} m ($correasPorFaldon/faldón)',
        categoria: CategoriaMaterial.estructura,
        cantidad: totalCorreas.toDouble() * l,
        unidad: 'm lineales',
      ),
      ItemMaterial(
        nombre: esMadera
            ? 'Tirante diagonal 2"×3" (madera)'
            : 'Ángulo estructural 1½"×1½" LAC',
        descripcion: 'Templadores c/ ${diagLen.toStringAsFixed(2)} m',
        categoria: CategoriaMaterial.estructura,
        cantidad: totalTempladores.toDouble(),
        unidad: 'pzas',
      ),
      ItemMaterial(
        nombre: esMadera ? 'Arriostre horizontal 2"×2"' : 'Perfil L 1"×1" LAC',
        descripcion: 'Rigidez entre tijerales ($numVanosArriostre vanos)',
        categoria: CategoriaMaterial.estructura,
        cantidad: totalArriostres.toDouble(),
        unidad: 'tramos',
      ),
      ItemMaterial(
        nombre: 'Zapata de concreto 0.40×0.40×0.60 m',
        descripcion: 'Cimentación para cada columna',
        categoria: CategoriaMaterial.estructura,
        cantidad: totalZapatas.toDouble(),
        unidad: 'pzas',
      ),

      // ── CUBIERTA ───────────────────────────────────────────────────────
      ItemMaterial(
        nombre: cub.nombre,
        descripcion:
            '$laminasPorFilaLargo láminas/fila × $filasPorFaldon filas/faldón × 2 faldones',
        categoria: CategoriaMaterial.cubierta,
        cantidad: totalLaminas.toDouble(),
        unidad: 'láminas',
      ),
      ItemMaterial(
        nombre: 'Caballete / cumbrera estándar (0.83 m)',
        descripcion: 'Remate superior del techo',
        categoria: CategoriaMaterial.cubierta,
        cantidad: pzasCaballete.toDouble(),
        unidad: 'pzas',
      ),

      // ── CERRAMIENTOS ──────────────────────────────────────────────────
      ItemMaterial(
        nombre: 'Malla mosquitero galvanizada',
        descripcion: 'Cierre perimetral completo',
        categoria: CategoriaMaterial.cerramientos,
        cantidad: areaMalla,
        unidad: 'm²',
      ),
      ItemMaterial(
        nombre: 'Cortina de polipropileno',
        descripcion: 'Paredes laterales (ambos lados)',
        categoria: CategoriaMaterial.cerramientos,
        cantidad: areaCortinas,
        unidad: 'm²',
      ),

      // ── FERRETERÍA ────────────────────────────────────────────────────
      ItemMaterial(
        nombre: esMadera
            ? 'Clavos para calamina 2½" c/arandela'
            : 'Tornillos autoroscantes #14 × 1½"',
        descripcion: '~$clavosCalaminaPorLamina por lámina',
        categoria: CategoriaMaterial.ferreteria,
        cantidad: esMadera
            ? totalClavosCalamina.toDouble()
            : tornillos.toDouble(),
        unidad: 'pzas',
      ),
      ItemMaterial(
        nombre: 'Pernos galvanizados ½" × 6" c/tuerca',
        descripcion: 'Anclaje columnas-vigas + tijerales',
        categoria: CategoriaMaterial.ferreteria,
        cantidad: totalPernos.toDouble(),
        unidad: 'pzas',
      ),
      if (esMadera)
        ItemMaterial(
          nombre: 'Alambre galvanizado #16',
          descripcion: 'Amarres de correas a tijerales',
          categoria: CategoriaMaterial.ferreteria,
          cantidad: alambreKg,
          unidad: 'kg',
        ),
      if (!esMadera)
        ItemMaterial(
          nombre: 'Tornillos autoroscantes #10 × ¾"',
          descripcion: 'Fijación correas-cerchas',
          categoria: CategoriaMaterial.ferreteria,
          cantidad: (totalCorreas * colsPerSide * 2).toDouble(),
          unidad: 'pzas',
        ),
      ItemMaterial(
        nombre: 'Grapas galvanizadas para malla',
        descripcion: 'Fijación de malla mosquitero',
        categoria: CategoriaMaterial.ferreteria,
        cantidad: (perim / 0.15).ceilToDouble(), // cada 15 cm
        unidad: 'pzas',
      ),
    ];

    return GalponMateriales(
      config: config,
      items: items,
      pendienteTechoPct: pendientePct,
      longitudPendiente: slope,
      areaRoof: roofArea,
      perimetro: perim,
    );
  }
}
