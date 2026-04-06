/// Períodos de tiempo para filtrar reportes.
library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Enum que define los períodos de tiempo disponibles para reportes.
enum PeriodoReporte {
  /// Últimos 7 días.
  semana('Última semana', 7),

  /// Últimos 30 días.
  mes('Último mes', 30),

  /// Últimos 3 meses.
  trimestre('Último trimestre', 90),

  /// Últimos 6 meses.
  semestre('Último semestre', 180),

  /// Último año.
  anual('Último año', 365),

  /// Período personalizado.
  personalizado('Personalizado', 0);

  const PeriodoReporte(this.nombre, this.dias);

  /// Nombre para mostrar.
  final String nombre;

  /// Cantidad de días del período.
  final int dias;

  /// Nombre localizado del período
  String get displayName {
    final locale = Formatters.currentLocale;
    return switch (this) {
      PeriodoReporte.semana => switch (locale) { 'es' => 'Última semana', 'pt' => 'Última semana', _ => 'Last week' },
      PeriodoReporte.mes => switch (locale) { 'es' => 'Último mes', 'pt' => 'Último mês', _ => 'Last month' },
      PeriodoReporte.trimestre => switch (locale) { 'es' => 'Último trimestre', 'pt' => 'Último trimestre', _ => 'Last quarter' },
      PeriodoReporte.semestre => switch (locale) { 'es' => 'Último semestre', 'pt' => 'Último semestre', _ => 'Last semester' },
      PeriodoReporte.anual => switch (locale) { 'es' => 'Último año', 'pt' => 'Último ano', _ => 'Last year' },
      PeriodoReporte.personalizado => switch (locale) { 'es' => 'Personalizado', 'pt' => 'Personalizado', _ => 'Custom' },
    };
  }

  /// Calcula la fecha de inicio basada en el período.
  DateTime get fechaInicio {
    if (this == PeriodoReporte.personalizado) {
      return DateTime.now().subtract(const Duration(days: 30));
    }
    return DateTime.now().subtract(Duration(days: dias));
  }

  /// La fecha fin es siempre hoy.
  DateTime get fechaFin => DateTime.now();
}
