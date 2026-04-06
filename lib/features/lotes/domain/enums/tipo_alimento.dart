/// Tipos de alimento para aves según etapa de producción.
library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

enum TipoAlimento {
  /// Alimento pre-iniciador (0-7 días) - Alto contenido proteico.
  preIniciador,

  /// Alimento iniciador (8-21 días) - Desarrollo inicial.
  iniciador,

  /// Alimento de crecimiento (22-35 días) - Fase de desarrollo.
  crecimiento,

  /// Alimento finalizador (36+ días) - Engorde final.
  finalizador,

  /// Alimento de postura - Para gallinas ponedoras.
  postura,

  /// Alimento de levante - Pollitas de reemplazo.
  levante,

  /// Alimento medicado - Con aditivos terapéuticos.
  medicado,

  /// Concentrado - Suplemento proteico.
  concentrado,

  /// Otro tipo de alimento.
  otro;

  /// Descripción legible del tipo de alimento (localizada).
  String localizedDisplayName(S l) {
    switch (this) {
      case TipoAlimento.preIniciador:
        return l.enumTipoAlimentoPreIniciador;
      case TipoAlimento.iniciador:
        return l.enumTipoAlimentoIniciador;
      case TipoAlimento.crecimiento:
        return l.enumTipoAlimentoCrecimiento;
      case TipoAlimento.finalizador:
        return l.enumTipoAlimentoFinalizador;
      case TipoAlimento.postura:
        return l.enumTipoAlimentoPostura;
      case TipoAlimento.levante:
        return l.enumTipoAlimentoLevante;
      case TipoAlimento.medicado:
        return l.enumTipoAlimentoMedicado;
      case TipoAlimento.concentrado:
        return l.enumTipoAlimentoConcentrado;
      case TipoAlimento.otro:
        return l.enumTipoAlimentoOtro;
    }
  }

  /// Nombre para contextos sin BuildContext (providers, toString, debug).
  String get displayName {
    const names = {
      'es': {
        TipoAlimento.preIniciador: 'Pre-iniciador',
        TipoAlimento.iniciador: 'Iniciador',
        TipoAlimento.crecimiento: 'Crecimiento',
        TipoAlimento.finalizador: 'Finalizador',
        TipoAlimento.postura: 'Postura',
        TipoAlimento.levante: 'Levante',
        TipoAlimento.medicado: 'Medicado',
        TipoAlimento.concentrado: 'Concentrado',
        TipoAlimento.otro: 'Otro',
      },
      'en': {
        TipoAlimento.preIniciador: 'Pre-starter',
        TipoAlimento.iniciador: 'Starter',
        TipoAlimento.crecimiento: 'Grower',
        TipoAlimento.finalizador: 'Finisher',
        TipoAlimento.postura: 'Layer',
        TipoAlimento.levante: 'Rearing',
        TipoAlimento.medicado: 'Medicated',
        TipoAlimento.concentrado: 'Concentrate',
        TipoAlimento.otro: 'Other',
      },
    };
    return names[Formatters.currentLocale]?[this] ?? names['es']![this]!;
  }

  /// Descripción con rango de edad (localizada).
  String localizedDescripcion(S l) {
    switch (this) {
      case TipoAlimento.preIniciador:
        return l.enumTipoAlimentoDescPreIniciador;
      case TipoAlimento.iniciador:
        return l.enumTipoAlimentoDescIniciador;
      case TipoAlimento.crecimiento:
        return l.enumTipoAlimentoDescCrecimiento;
      case TipoAlimento.finalizador:
        return l.enumTipoAlimentoDescFinalizador;
      case TipoAlimento.postura:
        return l.enumTipoAlimentoDescPostura;
      case TipoAlimento.levante:
        return l.enumTipoAlimentoDescLevante;
      case TipoAlimento.medicado:
        return l.enumTipoAlimentoDescMedicado;
      case TipoAlimento.concentrado:
        return l.enumTipoAlimentoDescConcentrado;
      case TipoAlimento.otro:
        return l.enumTipoAlimentoDescOtro;
    }
  }

  /// Icono representativo.
  String get icono {
    switch (this) {
      case TipoAlimento.preIniciador:
        return '🍼';
      case TipoAlimento.iniciador:
        return '🌱';
      case TipoAlimento.crecimiento:
        return '🌿';
      case TipoAlimento.finalizador:
        return '🌾';
      case TipoAlimento.postura:
        return '🥚';
      case TipoAlimento.levante:
        return '🐥';
      case TipoAlimento.medicado:
        return '💊';
      case TipoAlimento.concentrado:
        return '⚡';
      case TipoAlimento.otro:
        return '📦';
    }
  }

  /// Rango de edad recomendado en días (null si no aplica).
  ({int? minDias, int? maxDias})? get rangoEdad {
    switch (this) {
      case TipoAlimento.preIniciador:
        return (minDias: 0, maxDias: 7);
      case TipoAlimento.iniciador:
        return (minDias: 8, maxDias: 21);
      case TipoAlimento.crecimiento:
        return (minDias: 22, maxDias: 35);
      case TipoAlimento.finalizador:
        return (minDias: 36, maxDias: null);
      default:
        return null;
    }
  }

  /// Descripción del rango de edad para mostrar en UI (localizada).
  String localizedRangoEdadDescripcion(S l) {
    switch (this) {
      case TipoAlimento.preIniciador:
        return l.enumTipoAlimentoRangoPreIniciador;
      case TipoAlimento.iniciador:
        return l.enumTipoAlimentoRangoIniciador;
      case TipoAlimento.crecimiento:
        return l.enumTipoAlimentoRangoCrecimiento;
      case TipoAlimento.finalizador:
        return l.enumTipoAlimentoRangoFinalizador;
      case TipoAlimento.postura:
        return l.enumTipoAlimentoRangoPostura;
      case TipoAlimento.levante:
        return l.enumTipoAlimentoRangoLevante;
      case TipoAlimento.medicado:
        return l.enumTipoAlimentoRangoMedicado;
      case TipoAlimento.concentrado:
        return l.enumTipoAlimentoRangoConcentrado;
      case TipoAlimento.otro:
        return l.enumTipoAlimentoRangoOtro;
    }
  }

  /// Verifica si el tipo de alimento es apropiado para la edad.
  bool esApropiado(int edadDias) {
    final rango = rangoEdad;
    if (rango == null) return true;

    final min = rango.minDias ?? 0;
    final max = rango.maxDias;

    if (max == null) return edadDias >= min;

    return edadDias >= min && edadDias <= max;
  }

  /// Convierte a JSON.
  String toJson() => name;

  /// Crea desde JSON.
  static TipoAlimento fromJson(String json) {
    return TipoAlimento.values.firstWhere(
      (e) => e.name == json,
      orElse: () => TipoAlimento.otro,
    );
  }
}
