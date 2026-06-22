import 'dart:ui';

import '../../domain/entities/plan_avicola.dart';

/// Datos de distribución del galpón para renderizado gráfico.
///
/// Contiene las dimensiones, cantidades de equipos y orientación necesarios
/// para dibujar las vistas isométrica y de planta.
class GalponLayout {
  const GalponLayout({
    required this.largoM,
    required this.anchoM,
    required this.alturaCumbreraM,
    required this.alturaAleroM,
    required this.orientacion,
    required this.tipo,
    required this.numComederos,
    required this.numBebederos,
    required this.numNidales,
    required this.numCampanas,
    required this.numVentiladores,
    required this.tieneIluminacion,
    required this.tipoCortinas,
    this.numFocos = 0,
    this.numBalonesGas = 0,
    this.numSacosCama = 0,
    this.numCajasTransporte = 0,
    this.tipoComedero = 'tubular',
    this.tipoBebedero = 'campana',
    this.nivelAutomatizacion = 'semiAutomatico',
    this.watiosFoco = 15,
  });

  final double largoM;
  final double anchoM;
  final double alturaCumbreraM;
  final double alturaAleroM;

  /// Ej: "Este-Oeste", "Norte-Sur".
  final String orientacion;
  final TipoProduccion tipo;

  // ── Cantidades de equipos ─────────────────────────────────────────────────
  final int numComederos;
  final int numBebederos;
  final int numNidales;
  final int numCampanas;
  final int numVentiladores;
  final bool tieneIluminacion;
  final String tipoCortinas;

  // ── Nuevos equipos ────────────────────────────────────────────────────────
  final int numFocos;
  final int numBalonesGas;
  final int numSacosCama;
  final int numCajasTransporte;
  final String tipoComedero;
  final String tipoBebedero;
  final String nivelAutomatizacion;
  final int watiosFoco;

  /// True si los bebederos son tipo nipple (automáticos).
  bool get bebederoEsNipple => tipoBebedero.toLowerCase().contains('nipple');

  // ── Distribución calculada ────────────────────────────────────────────────

  /// Margen desde las paredes (m).
  double get margen => 1.0;

  /// Ancho utilizable (m).
  double get anchoUtil => anchoM - 2 * margen;

  /// Largo utilizable (m).
  double get largoUtil => largoM - 2 * margen;

  /// Número de filas de comederos (a lo ancho).
  int get filasComederos => (anchoUtil / 4.0).floor().clamp(2, 4);

  /// Número de filas de bebederos (intercaladas).
  int get filasBebederos => filasComederos + 1;

  /// Comederos por fila.
  int get comederosPorFila =>
      filasComederos > 0 ? (numComederos / filasComederos).ceil() : 0;

  /// Separación horizontal entre comederos (m).
  double get separacionComederos =>
      comederosPorFila > 1 ? largoUtil / (comederosPorFila + 1) : largoUtil / 2;

  /// Posiciones Y de las filas de comederos (en m desde pared superior).
  List<double> get posYComederos {
    final totalLineas = filasComederos + filasBebederos;
    final step = anchoUtil / (totalLineas + 1);
    return List.generate(
      filasComederos,
      (i) => margen + step * (2 * i + 2), // pos 2, 4, 6...
    );
  }

  /// Posiciones Y de las filas de bebederos (en m desde pared superior).
  List<double> get posYBebederos {
    final totalLineas = filasComederos + filasBebederos;
    final step = anchoUtil / (totalLineas + 1);
    return List.generate(
      filasBebederos,
      (i) => margen + step * (2 * i + 1), // pos 1, 3, 5, 7...
    );
  }

  /// Centros de campanas de calefacción.
  List<Offset> get posicionesCampanas {
    if (numCampanas <= 0) return [];
    if (numCampanas == 1) return [Offset(largoM / 2, anchoM / 2)];
    final step = largoUtil / (numCampanas + 1);
    return List.generate(
      numCampanas,
      (i) => Offset(margen + step * (i + 1), anchoM / 2),
    );
  }

  /// Posiciones de ventiladores (en paredes cortas / testeros).
  List<Offset> get posicionesVentiladores {
    if (numVentiladores <= 0) return [];
    if (numVentiladores == 1) return [Offset(largoM, anchoM / 2)];
    // Primero en la pared derecha, luego izquierda si hay más
    final res = <Offset>[];
    final perPared = (numVentiladores / 2).ceil();
    final step = anchoUtil / (perPared + 1);
    for (var i = 0; i < perPared && res.length < numVentiladores; i++) {
      res.add(Offset(largoM, margen + step * (i + 1))); // pared derecha
    }
    for (var i = 0; i < perPared && res.length < numVentiladores; i++) {
      res.add(Offset(0, margen + step * (i + 1))); // pared izquierda
    }
    return res;
  }

  /// Posiciones de nidales a lo largo de la pared inferior.
  List<Offset> get posicionesNidales {
    if (numNidales <= 0) return [];
    final step = largoUtil / (numNidales + 1);
    return List.generate(
      numNidales,
      (i) => Offset(margen + step * (i + 1), anchoM - margen * 0.3),
    );
  }

  // ── Orientación ───────────────────────────────────────────────────────────

  /// Dirección del eje largo (N, S, E, O).
  String get ejeHorizontal {
    final lower = orientacion.toLowerCase();
    if (lower.contains('este') || lower.contains('west')) return 'E-O';
    if (lower.contains('norte') || lower.contains('south')) return 'N-S';
    return 'E-O';
  }

  /// True si el eje largo corre Este-Oeste.
  bool get esEsteOeste => ejeHorizontal == 'E-O';

  // ── Factory ───────────────────────────────────────────────────────────────

  /// Construye el layout a partir de un [ResultadoPlan].
  factory GalponLayout.fromPlan(ResultadoPlan plan) {
    final infra = plan.infraestructura;

    var comederos = 0;
    var bebederos = 0;
    var nidales = 0;
    var campanas = 0;
    var ventiladores = 0;
    var iluminacion = false;
    var focos = 0;
    var balonesGas = 0;
    var sacosCama = 0;
    var cajasTransporte = 0;
    var tipoComedero = 'tubular';
    var tipoBebedero = 'campana';
    var watiosFoco = 15;

    for (final item in plan.equipamiento) {
      final n = item.nombre.toLowerCase();
      if (n.contains('comedero')) {
        comederos = item.cantidad;
        if (n.contains('tolva') || n.contains('manual')) {
          tipoComedero = 'tolva manual';
        } else if (n.contains('automático') || n.contains('automatico')) {
          tipoComedero = 'automático';
        } else if (n.contains('canal')) {
          tipoComedero = 'canal';
        } else {
          tipoComedero = 'tubular';
        }
      } else if (n.contains('bebedero')) {
        bebederos = item.cantidad;
        if (n.contains('nipple')) {
          tipoBebedero = 'nipple';
        } else if (n.contains('automático') || n.contains('automatico')) {
          tipoBebedero = 'campana automático';
        } else {
          tipoBebedero = 'campana manual';
        }
      } else if (n.contains('nido') || n.contains('nidal')) {
        nidales = item.cantidad;
      } else if (n.contains('campana') || n.contains('criadora')) {
        campanas = item.cantidad;
      } else if (n.contains('ventilador')) {
        ventiladores = item.cantidad;
      } else if (n.contains('iluminación') || n.contains('iluminacion')) {
        iluminacion = true;
      } else if (n.contains('foco')) {
        focos = item.cantidad;
        if (n.contains('100w')) {
          watiosFoco = 100;
        } else if (n.contains('20w')) {
          watiosFoco = 20;
        } else {
          watiosFoco = 15;
        }
      } else if (n.contains('balón') || n.contains('balon')) {
        balonesGas = item.cantidad;
      } else if (n.contains('cascarilla') ||
          n.contains('viruta') ||
          n.contains('cama')) {
        sacosCama = item.cantidad;
      } else if (n.contains('caja')) {
        cajasTransporte = item.cantidad;
      }
    }

    final nivel = plan.input.nivelAutomatizacion;
    final nivelStr = switch (nivel) {
      NivelAutomatizacion.manual => 'manual',
      NivelAutomatizacion.semiAutomatico => 'semiAutomatico',
      NivelAutomatizacion.automatico => 'automatico',
    };

    return GalponLayout(
      largoM: infra.largoM,
      anchoM: infra.anchoM,
      alturaCumbreraM: infra.alturaCumbreraM,
      alturaAleroM: infra.alturaAleroM,
      orientacion: infra.orientacion,
      tipo: plan.input.tipoProduccion,
      numComederos: comederos,
      numBebederos: bebederos,
      numNidales: nidales,
      numCampanas: campanas,
      numVentiladores: ventiladores,
      tieneIluminacion: iluminacion,
      tipoCortinas: plan.manejoAmbiental.tipoCortinas,
      numFocos: focos,
      numBalonesGas: balonesGas,
      numSacosCama: sacosCama,
      numCajasTransporte: cajasTransporte,
      tipoComedero: tipoComedero,
      tipoBebedero: tipoBebedero,
      nivelAutomatizacion: nivelStr,
      watiosFoco: watiosFoco,
    );
  }
}
