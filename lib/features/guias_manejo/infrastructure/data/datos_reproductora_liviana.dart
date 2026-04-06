import '../../domain/entities/guia_semanal.dart';

/// Datos basados en manuales Lohmann LSL-Classic para reproductora liviana.
/// Ciclo: 0-72 semanas (levante 0-17, pre-postura 18-19, produccion 20-72).
const datosReproductoraLiviana = <GuiaSemanal>[
  // === LEVANTE ===
  GuiaSemanal(semana: 0, luzHoras: 22, alimentoGAve: 12, pesoObjetivoG: 65, aguaMlAve: 24, tipoAlimento: 'Pre-iniciador', temperaturaC: 33, humedadPct: 65),
  GuiaSemanal(semana: 1, luzHoras: 20, alimentoGAve: 17, pesoObjetivoG: 100, aguaMlAve: 34, tipoAlimento: 'Iniciador', temperaturaC: 30, humedadPct: 65),
  GuiaSemanal(semana: 2, luzHoras: 18, alimentoGAve: 20, pesoObjetivoG: 150, aguaMlAve: 40, tipoAlimento: 'Iniciador', temperaturaC: 27, humedadPct: 60),
  GuiaSemanal(semana: 3, luzHoras: 16, alimentoGAve: 24, pesoObjetivoG: 210, aguaMlAve: 48, tipoAlimento: 'Iniciador', temperaturaC: 25, humedadPct: 60),
  GuiaSemanal(semana: 4, luzHoras: 14, alimentoGAve: 29, pesoObjetivoG: 280, aguaMlAve: 58, tipoAlimento: 'Levante', temperaturaC: 23, humedadPct: 60),
  GuiaSemanal(semana: 5, luzHoras: 12, alimentoGAve: 34, pesoObjetivoG: 350, aguaMlAve: 68, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 60),
  GuiaSemanal(semana: 6, luzHoras: 10, alimentoGAve: 39, pesoObjetivoG: 420, aguaMlAve: 78, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 7, luzHoras: 10, alimentoGAve: 44, pesoObjetivoG: 500, aguaMlAve: 88, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 8, luzHoras: 10, alimentoGAve: 49, pesoObjetivoG: 580, aguaMlAve: 98, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 9, luzHoras: 10, alimentoGAve: 53, pesoObjetivoG: 660, aguaMlAve: 106, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 10, luzHoras: 10, alimentoGAve: 57, pesoObjetivoG: 750, aguaMlAve: 114, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 11, luzHoras: 10, alimentoGAve: 60, pesoObjetivoG: 830, aguaMlAve: 120, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 12, luzHoras: 10, alimentoGAve: 63, pesoObjetivoG: 910, aguaMlAve: 126, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 13, luzHoras: 10, alimentoGAve: 66, pesoObjetivoG: 990, aguaMlAve: 132, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 14, luzHoras: 10, alimentoGAve: 69, pesoObjetivoG: 1065, aguaMlAve: 138, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 15, luzHoras: 11, alimentoGAve: 72, pesoObjetivoG: 1140, aguaMlAve: 144, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 16, luzHoras: 12, alimentoGAve: 75, pesoObjetivoG: 1215, aguaMlAve: 150, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 17, luzHoras: 13, alimentoGAve: 78, pesoObjetivoG: 1280, aguaMlAve: 156, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 55),
  // === PRE-POSTURA ===
  GuiaSemanal(semana: 18, luzHoras: 13.5, alimentoGAve: 85, pesoObjetivoG: 1350, aguaMlAve: 170, tipoAlimento: 'Pre-postura', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 19, luzHoras: 14, alimentoGAve: 92, pesoObjetivoG: 1420, aguaMlAve: 184, tipoAlimento: 'Pre-postura', temperaturaC: 21, humedadPct: 55),
  // === PRODUCCION ===
  GuiaSemanal(semana: 20, luzHoras: 14.5, alimentoGAve: 100, pesoObjetivoG: 1500, aguaMlAve: 200, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 22, luzHoras: 15, alimentoGAve: 108, pesoObjetivoG: 1600, aguaMlAve: 216, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 24, luzHoras: 15.5, alimentoGAve: 112, pesoObjetivoG: 1700, aguaMlAve: 224, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 26, luzHoras: 16, alimentoGAve: 114, pesoObjetivoG: 1780, aguaMlAve: 228, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 28, luzHoras: 16, alimentoGAve: 115, pesoObjetivoG: 1850, aguaMlAve: 230, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 30, luzHoras: 16, alimentoGAve: 115, pesoObjetivoG: 1900, aguaMlAve: 230, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 35, luzHoras: 16, alimentoGAve: 114, pesoObjetivoG: 1960, aguaMlAve: 228, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 40, luzHoras: 16, alimentoGAve: 113, pesoObjetivoG: 2000, aguaMlAve: 226, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 50, luzHoras: 16, alimentoGAve: 111, pesoObjetivoG: 2050, aguaMlAve: 222, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 60, luzHoras: 16, alimentoGAve: 109, pesoObjetivoG: 2090, aguaMlAve: 218, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 72, luzHoras: 16, alimentoGAve: 107, pesoObjetivoG: 2120, aguaMlAve: 214, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
];
