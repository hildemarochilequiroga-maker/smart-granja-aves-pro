import '../../domain/entities/guia_semanal.dart';

/// Datos basados en manuales Cherry Valley / Pekin duck.
/// Ciclo: 0-8 semanas de engorde.
const datosPato = <GuiaSemanal>[
  GuiaSemanal(semana: 0, luzHoras: 23, alimentoGAve: 20, pesoObjetivoG: 80, aguaMlAve: 40, tipoAlimento: 'Pre-iniciador', temperaturaC: 30, humedadPct: 70),
  GuiaSemanal(semana: 1, luzHoras: 22, alimentoGAve: 45, pesoObjetivoG: 250, aguaMlAve: 90, tipoAlimento: 'Iniciador', temperaturaC: 28, humedadPct: 65),
  GuiaSemanal(semana: 2, luzHoras: 20, alimentoGAve: 80, pesoObjetivoG: 550, aguaMlAve: 160, tipoAlimento: 'Iniciador', temperaturaC: 26, humedadPct: 65),
  GuiaSemanal(semana: 3, luzHoras: 18, alimentoGAve: 120, pesoObjetivoG: 950, aguaMlAve: 240, tipoAlimento: 'Crecimiento', temperaturaC: 24, humedadPct: 60),
  GuiaSemanal(semana: 4, luzHoras: 16, alimentoGAve: 155, pesoObjetivoG: 1400, aguaMlAve: 310, tipoAlimento: 'Crecimiento', temperaturaC: 22, humedadPct: 60),
  GuiaSemanal(semana: 5, luzHoras: 14, alimentoGAve: 185, pesoObjetivoG: 1900, aguaMlAve: 370, tipoAlimento: 'Engorde', temperaturaC: 20, humedadPct: 60),
  GuiaSemanal(semana: 6, luzHoras: 14, alimentoGAve: 210, pesoObjetivoG: 2400, aguaMlAve: 420, tipoAlimento: 'Engorde', temperaturaC: 19, humedadPct: 60),
  GuiaSemanal(semana: 7, luzHoras: 14, alimentoGAve: 230, pesoObjetivoG: 2900, aguaMlAve: 460, tipoAlimento: 'Engorde', temperaturaC: 18, humedadPct: 60),
  GuiaSemanal(semana: 8, luzHoras: 14, alimentoGAve: 240, pesoObjetivoG: 3300, aguaMlAve: 480, tipoAlimento: 'Engorde', temperaturaC: 18, humedadPct: 60),
];
