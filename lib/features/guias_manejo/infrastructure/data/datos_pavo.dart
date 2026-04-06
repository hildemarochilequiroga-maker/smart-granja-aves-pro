import '../../domain/entities/guia_semanal.dart';

/// Datos basados en manuales Nicholas / Hybrid Turkeys para pavo de engorde.
/// Ciclo: 0-12 semanas (hembras) / 0-16 semanas (machos). Usamos mixto.
const datosPavo = <GuiaSemanal>[
  GuiaSemanal(semana: 0, luzHoras: 23, alimentoGAve: 25, pesoObjetivoG: 175, aguaMlAve: 50, tipoAlimento: 'Pre-iniciador', temperaturaC: 35, humedadPct: 65),
  GuiaSemanal(semana: 1, luzHoras: 22, alimentoGAve: 45, pesoObjetivoG: 360, aguaMlAve: 90, tipoAlimento: 'Iniciador', temperaturaC: 33, humedadPct: 65),
  GuiaSemanal(semana: 2, luzHoras: 20, alimentoGAve: 70, pesoObjetivoG: 600, aguaMlAve: 140, tipoAlimento: 'Iniciador', temperaturaC: 30, humedadPct: 60),
  GuiaSemanal(semana: 3, luzHoras: 18, alimentoGAve: 100, pesoObjetivoG: 900, aguaMlAve: 200, tipoAlimento: 'Crecimiento', temperaturaC: 28, humedadPct: 60),
  GuiaSemanal(semana: 4, luzHoras: 16, alimentoGAve: 130, pesoObjetivoG: 1250, aguaMlAve: 260, tipoAlimento: 'Crecimiento', temperaturaC: 26, humedadPct: 60),
  GuiaSemanal(semana: 5, luzHoras: 14, alimentoGAve: 162, pesoObjetivoG: 1700, aguaMlAve: 324, tipoAlimento: 'Crecimiento', temperaturaC: 24, humedadPct: 55),
  GuiaSemanal(semana: 6, luzHoras: 14, alimentoGAve: 195, pesoObjetivoG: 2200, aguaMlAve: 390, tipoAlimento: 'Crecimiento', temperaturaC: 23, humedadPct: 55),
  GuiaSemanal(semana: 7, luzHoras: 14, alimentoGAve: 225, pesoObjetivoG: 2800, aguaMlAve: 450, tipoAlimento: 'Engorde', temperaturaC: 22, humedadPct: 55),
  GuiaSemanal(semana: 8, luzHoras: 14, alimentoGAve: 260, pesoObjetivoG: 3500, aguaMlAve: 520, tipoAlimento: 'Engorde', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 9, luzHoras: 14, alimentoGAve: 290, pesoObjetivoG: 4200, aguaMlAve: 580, tipoAlimento: 'Engorde', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 10, luzHoras: 14, alimentoGAve: 320, pesoObjetivoG: 5000, aguaMlAve: 640, tipoAlimento: 'Engorde', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 11, luzHoras: 14, alimentoGAve: 340, pesoObjetivoG: 5800, aguaMlAve: 680, tipoAlimento: 'Engorde', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 12, luzHoras: 14, alimentoGAve: 360, pesoObjetivoG: 6600, aguaMlAve: 720, tipoAlimento: 'Engorde', temperaturaC: 21, humedadPct: 55),
];
