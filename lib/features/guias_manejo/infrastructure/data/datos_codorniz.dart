import '../../domain/entities/guia_semanal.dart';

/// Datos basados en referencias Coturnix japonica (codorniz japonesa).
/// Ciclo: 0-36 semanas (levante 0-5, postura 6-36).
const datosCodorniz = <GuiaSemanal>[
  // === LEVANTE ===
  GuiaSemanal(semana: 0, luzHoras: 23, alimentoGAve: 5, pesoObjetivoG: 8, aguaMlAve: 10, tipoAlimento: 'Pre-iniciador', temperaturaC: 35, humedadPct: 65),
  GuiaSemanal(semana: 1, luzHoras: 22, alimentoGAve: 8, pesoObjetivoG: 20, aguaMlAve: 16, tipoAlimento: 'Iniciador', temperaturaC: 33, humedadPct: 65),
  GuiaSemanal(semana: 2, luzHoras: 20, alimentoGAve: 12, pesoObjetivoG: 40, aguaMlAve: 24, tipoAlimento: 'Iniciador', temperaturaC: 30, humedadPct: 60),
  GuiaSemanal(semana: 3, luzHoras: 18, alimentoGAve: 16, pesoObjetivoG: 65, aguaMlAve: 32, tipoAlimento: 'Crecimiento', temperaturaC: 28, humedadPct: 60),
  GuiaSemanal(semana: 4, luzHoras: 16, alimentoGAve: 20, pesoObjetivoG: 95, aguaMlAve: 40, tipoAlimento: 'Crecimiento', temperaturaC: 26, humedadPct: 60),
  GuiaSemanal(semana: 5, luzHoras: 14, alimentoGAve: 23, pesoObjetivoG: 120, aguaMlAve: 46, tipoAlimento: 'Crecimiento', temperaturaC: 24, humedadPct: 60),
  // === POSTURA ===
  GuiaSemanal(semana: 6, luzHoras: 14, alimentoGAve: 25, pesoObjetivoG: 140, aguaMlAve: 50, tipoAlimento: 'Postura', temperaturaC: 24, humedadPct: 60),
  GuiaSemanal(semana: 7, luzHoras: 14, alimentoGAve: 27, pesoObjetivoG: 155, aguaMlAve: 54, tipoAlimento: 'Postura', temperaturaC: 24, humedadPct: 60),
  GuiaSemanal(semana: 8, luzHoras: 14, alimentoGAve: 28, pesoObjetivoG: 165, aguaMlAve: 56, tipoAlimento: 'Postura', temperaturaC: 24, humedadPct: 60),
  GuiaSemanal(semana: 10, luzHoras: 14, alimentoGAve: 28, pesoObjetivoG: 175, aguaMlAve: 56, tipoAlimento: 'Postura', temperaturaC: 24, humedadPct: 60),
  GuiaSemanal(semana: 12, luzHoras: 14, alimentoGAve: 28, pesoObjetivoG: 180, aguaMlAve: 56, tipoAlimento: 'Postura', temperaturaC: 24, humedadPct: 60),
  GuiaSemanal(semana: 16, luzHoras: 14, alimentoGAve: 28, pesoObjetivoG: 185, aguaMlAve: 56, tipoAlimento: 'Postura', temperaturaC: 24, humedadPct: 60),
  GuiaSemanal(semana: 20, luzHoras: 14, alimentoGAve: 27, pesoObjetivoG: 185, aguaMlAve: 54, tipoAlimento: 'Postura', temperaturaC: 24, humedadPct: 60),
  GuiaSemanal(semana: 24, luzHoras: 14, alimentoGAve: 27, pesoObjetivoG: 190, aguaMlAve: 54, tipoAlimento: 'Postura', temperaturaC: 24, humedadPct: 60),
  GuiaSemanal(semana: 28, luzHoras: 14, alimentoGAve: 26, pesoObjetivoG: 190, aguaMlAve: 52, tipoAlimento: 'Postura', temperaturaC: 24, humedadPct: 60),
  GuiaSemanal(semana: 32, luzHoras: 14, alimentoGAve: 26, pesoObjetivoG: 190, aguaMlAve: 52, tipoAlimento: 'Postura', temperaturaC: 24, humedadPct: 60),
  GuiaSemanal(semana: 36, luzHoras: 14, alimentoGAve: 25, pesoObjetivoG: 190, aguaMlAve: 50, tipoAlimento: 'Postura', temperaturaC: 24, humedadPct: 60),
];
