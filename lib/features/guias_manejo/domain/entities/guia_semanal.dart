/// Datos de guía técnica para una semana de vida del ave.
class GuiaSemanal {
  const GuiaSemanal({
    required this.semana,
    required this.luzHoras,
    required this.alimentoGAve,
    required this.pesoObjetivoG,
    required this.aguaMlAve,
    this.tipoAlimento,
    this.temperaturaC,
    this.humedadPct,
  });

  /// Semana de edad (0 = primera semana).
  final int semana;

  /// Horas de luz recomendadas por día.
  final double luzHoras;

  /// Gramos de alimento por ave por día.
  final double alimentoGAve;

  /// Peso corporal objetivo en gramos al final de la semana.
  final double pesoObjetivoG;

  /// Mililitros de agua por ave por día.
  final double aguaMlAve;

  /// Tipo de alimento recomendado para esta etapa.
  final String? tipoAlimento;

  /// Temperatura ambiental recomendada en °C.
  final double? temperaturaC;

  /// Humedad relativa recomendada en %.
  final double? humedadPct;
}
