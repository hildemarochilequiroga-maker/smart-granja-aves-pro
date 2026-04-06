import 'dart:math';

import '../../domain/entities/guia_semanal.dart';
import '../../../lotes/domain/entities/lote.dart';
import '../../infrastructure/data/guias_data_source.dart';

/// Resultado calculado de la guía para un lote específico.
class GuiaLoteResult {
  const GuiaLoteResult({
    required this.guias,
    required this.semanaActual,
    required this.avesActuales,
    required this.fuenteManual,
    this.guiaSemanaActual,
  });

  /// Todas las guías semanales del tipo de ave.
  final List<GuiaSemanal> guias;

  /// Semana de edad actual del lote.
  final int semanaActual;

  /// Número de aves actuales en el lote.
  final int avesActuales;

  /// Nombre del manual de referencia.
  final String fuenteManual;

  /// Guía interpolada para la semana actual (null si fuera de rango).
  final GuiaSemanal? guiaSemanaActual;
}

/// Servicio que calcula las guías de manejo para un lote.
class GuiasCalculator {
  const GuiasCalculator._();

  /// Calcula el resultado completo de guías para el lote dado.
  static GuiaLoteResult calcular(Lote lote) {
    final guias = GuiasDataSource.obtenerGuias(lote.tipoAve);
    final semanaActual = lote.edadActualSemanas;
    final avesActuales = lote.avesActuales;
    final fuente = GuiasDataSource.fuenteManual(lote.tipoAve);

    return GuiaLoteResult(
      guias: guias,
      semanaActual: semanaActual,
      avesActuales: avesActuales,
      fuenteManual: fuente,
      guiaSemanaActual: interpolarSemana(guias, semanaActual),
    );
  }

  /// Interpola los valores de la guía para una semana que puede no estar
  /// exactamente en la tabla (ej. semana 27 cuando la tabla tiene 26 y 28).
  static GuiaSemanal? interpolarSemana(List<GuiaSemanal> guias, int semana) {
    if (guias.isEmpty) return null;
    if (semana < guias.first.semana) return guias.first;
    if (semana > guias.last.semana) return guias.last;

    // Buscar coincidencia exacta
    for (final g in guias) {
      if (g.semana == semana) return g;
    }

    // Interpolar entre las dos semanas más cercanas
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

    return GuiaSemanal(
      semana: semana,
      luzHoras: _roundTo(lerp(anterior.luzHoras, siguiente.luzHoras), 1),
      alimentoGAve: _roundTo(
        lerp(anterior.alimentoGAve, siguiente.alimentoGAve),
        0,
      ),
      pesoObjetivoG: _roundTo(
        lerp(anterior.pesoObjetivoG, siguiente.pesoObjetivoG),
        0,
      ),
      aguaMlAve: _roundTo(lerp(anterior.aguaMlAve, siguiente.aguaMlAve), 0),
      tipoAlimento: anterior.tipoAlimento,
      temperaturaC:
          anterior.temperaturaC != null && siguiente.temperaturaC != null
          ? _roundTo(lerp(anterior.temperaturaC!, siguiente.temperaturaC!), 1)
          : anterior.temperaturaC,
      humedadPct: anterior.humedadPct != null && siguiente.humedadPct != null
          ? _roundTo(lerp(anterior.humedadPct!, siguiente.humedadPct!), 0)
          : anterior.humedadPct,
    );
  }

  /// Total de alimento diario para el lote en kg.
  static double totalAlimentoKgDia(GuiaSemanal guia, int numAves) {
    return (guia.alimentoGAve * numAves) / 1000;
  }

  /// Total de agua diaria para el lote en litros.
  static double totalAguaLitrosDia(GuiaSemanal guia, int numAves) {
    return (guia.aguaMlAve * numAves) / 1000;
  }

  static double _roundTo(double value, int decimals) {
    final mod = pow(10.0, decimals);
    return (value * mod).roundToDouble() / mod;
  }
}
