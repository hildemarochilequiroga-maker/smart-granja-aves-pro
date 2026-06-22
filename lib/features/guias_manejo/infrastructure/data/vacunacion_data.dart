/// Programas de vacunación estándar por tipo de ave.
library;

import '../../../lotes/domain/enums/tipo_ave.dart';

/// Un evento de vacunación programado.
class VacunacionProgramada {
  const VacunacionProgramada({
    required this.dia,
    required this.vacuna,
    required this.via,
  });

  /// Día de vida en que se aplica.
  final int dia;

  /// Nombre de la vacuna.
  final String vacuna;

  /// Vía de administración.
  final String via;
}

/// Retorna el programa de vacunación estándar para el tipo de ave.
List<VacunacionProgramada> obtenerProgramaVacunacion(TipoAve tipoAve) {
  return switch (tipoAve) {
    TipoAve.polloEngorde => _vacunasPolloEngorde,
    TipoAve.gallinaPonedora => _vacunasGallinaPonedora,
    TipoAve.reproductoraPesada => _vacunasReproductoraPesada,
    TipoAve.reproductoraLiviana => _vacunasReproductoraLiviana,
    TipoAve.pavo => _vacunasPavo,
    TipoAve.codorniz => _vacunasCodorniz,
    TipoAve.pato => _vacunasPato,
    TipoAve.otro => _vacunasOtro,
  };
}

const _vacunasPolloEngorde = <VacunacionProgramada>[
  VacunacionProgramada(
    dia: 1,
    vacuna: 'Marek (HVT)',
    via: 'Subcutánea (incubadora)',
  ),
  VacunacionProgramada(
    dia: 7,
    vacuna: 'Newcastle B1 + Bronquitis H120',
    via: 'Ocular / Aspersión',
  ),
  VacunacionProgramada(
    dia: 14,
    vacuna: 'Gumboro (IBD) intermedia',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(
    dia: 21,
    vacuna: 'Newcastle La Sota',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(
    dia: 28,
    vacuna: 'Gumboro (IBD) refuerzo',
    via: 'Agua de bebida',
  ),
];

const _vacunasGallinaPonedora = <VacunacionProgramada>[
  VacunacionProgramada(
    dia: 1,
    vacuna: 'Marek (HVT + SB1)',
    via: 'Subcutánea (incubadora)',
  ),
  VacunacionProgramada(
    dia: 7,
    vacuna: 'Newcastle B1 + Bronquitis H120',
    via: 'Ocular',
  ),
  VacunacionProgramada(
    dia: 14,
    vacuna: 'Gumboro (IBD) intermedia',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(
    dia: 21,
    vacuna: 'Newcastle La Sota',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(
    dia: 28,
    vacuna: 'Gumboro (IBD) refuerzo',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(
    dia: 35,
    vacuna: 'Viruela aviar + Encefalomielitis',
    via: 'Punción alar',
  ),
  VacunacionProgramada(
    dia: 49,
    vacuna: 'Newcastle La Sota refuerzo',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(
    dia: 56,
    vacuna: 'Bronquitis H52',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(dia: 70, vacuna: 'Coriza infecciosa', via: 'Subcutánea'),
  VacunacionProgramada(
    dia: 84,
    vacuna: 'Newcastle + Bronquitis (oleosa)',
    via: 'Intramuscular',
  ),
  VacunacionProgramada(
    dia: 98,
    vacuna: 'Coriza infecciosa refuerzo',
    via: 'Subcutánea',
  ),
  VacunacionProgramada(
    dia: 112,
    vacuna: 'Newcastle + EDS + Bronquitis (triple oleosa)',
    via: 'Intramuscular',
  ),
];

const _vacunasReproductoraPesada = <VacunacionProgramada>[
  VacunacionProgramada(
    dia: 1,
    vacuna: 'Marek (HVT + SB1 + Rispens)',
    via: 'Subcutánea (incubadora)',
  ),
  VacunacionProgramada(
    dia: 7,
    vacuna: 'Newcastle B1 + Bronquitis H120',
    via: 'Ocular',
  ),
  VacunacionProgramada(
    dia: 14,
    vacuna: 'Gumboro (IBD) intermedia',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(
    dia: 21,
    vacuna: 'Newcastle La Sota',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(
    dia: 28,
    vacuna: 'Gumboro (IBD) refuerzo',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(
    dia: 35,
    vacuna: 'Viruela + Encefalomielitis',
    via: 'Punción alar',
  ),
  VacunacionProgramada(
    dia: 56,
    vacuna: 'Newcastle La Sota + Bronquitis H52',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(dia: 70, vacuna: 'Coriza infecciosa', via: 'Subcutánea'),
  VacunacionProgramada(dia: 84, vacuna: 'Reovirus', via: 'Subcutánea'),
  VacunacionProgramada(
    dia: 98,
    vacuna: 'Coriza infecciosa refuerzo',
    via: 'Subcutánea',
  ),
  VacunacionProgramada(
    dia: 112,
    vacuna: 'Newcastle + EDS + Bronquitis (triple oleosa)',
    via: 'Intramuscular',
  ),
  VacunacionProgramada(dia: 119, vacuna: 'Salmonella', via: 'Intramuscular'),
];

const _vacunasReproductoraLiviana = <VacunacionProgramada>[
  VacunacionProgramada(
    dia: 1,
    vacuna: 'Marek (HVT + SB1)',
    via: 'Subcutánea (incubadora)',
  ),
  VacunacionProgramada(
    dia: 7,
    vacuna: 'Newcastle B1 + Bronquitis H120',
    via: 'Ocular',
  ),
  VacunacionProgramada(
    dia: 14,
    vacuna: 'Gumboro (IBD) intermedia',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(
    dia: 21,
    vacuna: 'Newcastle La Sota',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(
    dia: 28,
    vacuna: 'Gumboro (IBD) refuerzo',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(
    dia: 35,
    vacuna: 'Viruela + Encefalomielitis',
    via: 'Punción alar',
  ),
  VacunacionProgramada(
    dia: 56,
    vacuna: 'Newcastle La Sota + Bronquitis H52',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(
    dia: 84,
    vacuna: 'Newcastle + Bronquitis (oleosa)',
    via: 'Intramuscular',
  ),
  VacunacionProgramada(
    dia: 112,
    vacuna: 'Newcastle + EDS + Bronquitis (triple oleosa)',
    via: 'Intramuscular',
  ),
];

const _vacunasPavo = <VacunacionProgramada>[
  VacunacionProgramada(
    dia: 1,
    vacuna: 'Newcastle (cepa lentogénica)',
    via: 'Aspersión',
  ),
  VacunacionProgramada(
    dia: 14,
    vacuna: 'Newcastle refuerzo',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(
    dia: 28,
    vacuna: 'Newcastle La Sota',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(
    dia: 42,
    vacuna: 'Cólera aviar (Pasteurella)',
    via: 'Subcutánea',
  ),
  VacunacionProgramada(
    dia: 56,
    vacuna: 'Newcastle refuerzo + Cólera refuerzo',
    via: 'Agua / Subcutánea',
  ),
];

const _vacunasCodorniz = <VacunacionProgramada>[
  VacunacionProgramada(
    dia: 7,
    vacuna: 'Newcastle B1',
    via: 'Ocular / Agua de bebida',
  ),
  VacunacionProgramada(
    dia: 21,
    vacuna: 'Newcastle La Sota',
    via: 'Agua de bebida',
  ),
  VacunacionProgramada(dia: 35, vacuna: 'Viruela aviar', via: 'Punción alar'),
  VacunacionProgramada(
    dia: 49,
    vacuna: 'Newcastle refuerzo',
    via: 'Agua de bebida',
  ),
];

const _vacunasPato = <VacunacionProgramada>[
  VacunacionProgramada(
    dia: 1,
    vacuna: 'Hepatitis viral del pato',
    via: 'Subcutánea',
  ),
  VacunacionProgramada(
    dia: 7,
    vacuna: 'Peste del pato (enteritis viral)',
    via: 'Subcutánea',
  ),
  VacunacionProgramada(
    dia: 21,
    vacuna: 'Hepatitis viral refuerzo',
    via: 'Subcutánea',
  ),
  VacunacionProgramada(dia: 35, vacuna: 'Cólera aviar', via: 'Subcutánea'),
];

const _vacunasOtro = <VacunacionProgramada>[
  VacunacionProgramada(dia: 7, vacuna: 'Newcastle B1', via: 'Ocular'),
  VacunacionProgramada(
    dia: 21,
    vacuna: 'Newcastle La Sota',
    via: 'Agua de bebida',
  ),
];
