import '../../domain/entities/guia_semanal.dart';

/// Datos basados en manuales Cobb 500 Breeder y Ross 308 PS.
/// Ciclo: 0-60 semanas (levante 0-22, produccion 23-60).
const datosReproductoraPesada = <GuiaSemanal>[
  // === LEVANTE (0-22 semanas) ===
  GuiaSemanal(semana: 0, luzHoras: 22, alimentoGAve: 18, pesoObjetivoG: 150, aguaMlAve: 36, tipoAlimento: 'Pre-iniciador', temperaturaC: 33, humedadPct: 65),
  GuiaSemanal(semana: 1, luzHoras: 20, alimentoGAve: 25, pesoObjetivoG: 250, aguaMlAve: 50, tipoAlimento: 'Iniciador', temperaturaC: 30, humedadPct: 65),
  GuiaSemanal(semana: 2, luzHoras: 18, alimentoGAve: 35, pesoObjetivoG: 400, aguaMlAve: 70, tipoAlimento: 'Iniciador', temperaturaC: 27, humedadPct: 60),
  GuiaSemanal(semana: 3, luzHoras: 14, alimentoGAve: 45, pesoObjetivoG: 560, aguaMlAve: 90, tipoAlimento: 'Crecimiento', temperaturaC: 25, humedadPct: 60),
  GuiaSemanal(semana: 4, luzHoras: 10, alimentoGAve: 55, pesoObjetivoG: 740, aguaMlAve: 110, tipoAlimento: 'Crecimiento', temperaturaC: 23, humedadPct: 60),
  GuiaSemanal(semana: 5, luzHoras: 8, alimentoGAve: 60, pesoObjetivoG: 880, aguaMlAve: 120, tipoAlimento: 'Crecimiento', temperaturaC: 21, humedadPct: 60),
  GuiaSemanal(semana: 6, luzHoras: 8, alimentoGAve: 65, pesoObjetivoG: 1020, aguaMlAve: 130, tipoAlimento: 'Crecimiento', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 7, luzHoras: 8, alimentoGAve: 68, pesoObjetivoG: 1160, aguaMlAve: 136, tipoAlimento: 'Crecimiento', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 8, luzHoras: 8, alimentoGAve: 72, pesoObjetivoG: 1300, aguaMlAve: 144, tipoAlimento: 'Crecimiento', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 9, luzHoras: 8, alimentoGAve: 76, pesoObjetivoG: 1440, aguaMlAve: 152, tipoAlimento: 'Crecimiento', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 10, luzHoras: 8, alimentoGAve: 80, pesoObjetivoG: 1570, aguaMlAve: 160, tipoAlimento: 'Crecimiento', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 12, luzHoras: 8, alimentoGAve: 88, pesoObjetivoG: 1820, aguaMlAve: 176, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 14, luzHoras: 8, alimentoGAve: 96, pesoObjetivoG: 2060, aguaMlAve: 192, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 16, luzHoras: 8, alimentoGAve: 104, pesoObjetivoG: 2300, aguaMlAve: 208, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 18, luzHoras: 10, alimentoGAve: 112, pesoObjetivoG: 2550, aguaMlAve: 224, tipoAlimento: 'Levante', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 20, luzHoras: 12, alimentoGAve: 120, pesoObjetivoG: 2800, aguaMlAve: 240, tipoAlimento: 'Pre-postura', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 22, luzHoras: 13, alimentoGAve: 135, pesoObjetivoG: 3050, aguaMlAve: 270, tipoAlimento: 'Pre-postura', temperaturaC: 21, humedadPct: 55),
  // === PRODUCCION (23-60 semanas) ===
  GuiaSemanal(semana: 24, luzHoras: 14, alimentoGAve: 155, pesoObjetivoG: 3300, aguaMlAve: 310, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 26, luzHoras: 15, alimentoGAve: 160, pesoObjetivoG: 3450, aguaMlAve: 320, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 28, luzHoras: 15, alimentoGAve: 162, pesoObjetivoG: 3550, aguaMlAve: 324, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 30, luzHoras: 16, alimentoGAve: 163, pesoObjetivoG: 3650, aguaMlAve: 326, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 35, luzHoras: 16, alimentoGAve: 160, pesoObjetivoG: 3800, aguaMlAve: 320, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 40, luzHoras: 16, alimentoGAve: 158, pesoObjetivoG: 3950, aguaMlAve: 316, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 45, luzHoras: 16, alimentoGAve: 155, pesoObjetivoG: 4100, aguaMlAve: 310, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 50, luzHoras: 16, alimentoGAve: 152, pesoObjetivoG: 4200, aguaMlAve: 304, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 55, luzHoras: 16, alimentoGAve: 150, pesoObjetivoG: 4350, aguaMlAve: 300, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
  GuiaSemanal(semana: 60, luzHoras: 16, alimentoGAve: 148, pesoObjetivoG: 4500, aguaMlAve: 296, tipoAlimento: 'Reproductora', temperaturaC: 21, humedadPct: 55),
];
