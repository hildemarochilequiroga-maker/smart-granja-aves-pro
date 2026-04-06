import '../../domain/entities/guia_semanal.dart';

/// Datos genericos basados en pollo de engorde estandar.
/// Util como referencia para aves sin guia especifica.
const datosOtro = <GuiaSemanal>[
  GuiaSemanal(semana: 0, luzHoras: 23, alimentoGAve: 15, pesoObjetivoG: 42, aguaMlAve: 30, tipoAlimento: 'Pre-iniciador', temperaturaC: 33, humedadPct: 65),
  GuiaSemanal(semana: 1, luzHoras: 22, alimentoGAve: 30, pesoObjetivoG: 160, aguaMlAve: 60, tipoAlimento: 'Iniciador', temperaturaC: 30, humedadPct: 65),
  GuiaSemanal(semana: 2, luzHoras: 20, alimentoGAve: 55, pesoObjetivoG: 400, aguaMlAve: 110, tipoAlimento: 'Iniciador', temperaturaC: 27, humedadPct: 60),
  GuiaSemanal(semana: 3, luzHoras: 18, alimentoGAve: 85, pesoObjetivoG: 730, aguaMlAve: 170, tipoAlimento: 'Crecimiento', temperaturaC: 24, humedadPct: 60),
  GuiaSemanal(semana: 4, luzHoras: 16, alimentoGAve: 120, pesoObjetivoG: 1150, aguaMlAve: 240, tipoAlimento: 'Crecimiento', temperaturaC: 22, humedadPct: 55),
  GuiaSemanal(semana: 5, luzHoras: 14, alimentoGAve: 155, pesoObjetivoG: 1650, aguaMlAve: 310, tipoAlimento: 'Engorde', temperaturaC: 20, humedadPct: 55),
  GuiaSemanal(semana: 6, luzHoras: 14, alimentoGAve: 175, pesoObjetivoG: 2200, aguaMlAve: 350, tipoAlimento: 'Engorde', temperaturaC: 20, humedadPct: 55),
];
