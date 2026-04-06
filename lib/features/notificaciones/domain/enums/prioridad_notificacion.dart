/// Prioridades de notificación.
library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Enum que define las prioridades de notificación.
enum PrioridadNotificacion {
  /// Prioridad baja - informativo.
  baja('baja', 'Baja', 0),

  /// Prioridad normal - estándar.
  normal('normal', 'Normal', 1),

  /// Prioridad alta - importante.
  alta('alta', 'Alta', 2),

  /// Prioridad urgente - crítico.
  urgente('urgente', 'Urgente', 3);

  const PrioridadNotificacion(this.value, this.label, this.orden);

  /// Valor para almacenamiento.
  final String value;

  /// Etiqueta para mostrar.
  final String label;

  /// Orden de prioridad (mayor = más urgente).
  final int orden;

  /// Crea desde string.
  static PrioridadNotificacion fromString(String value) {
    return PrioridadNotificacion.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PrioridadNotificacion.normal,
    );
  }

  /// Etiqueta localizada de la prioridad
  String get displayLabel {
    final locale = Formatters.currentLocale;
    return switch (this) {
      PrioridadNotificacion.baja => switch (locale) { 'es' => 'Baja', 'pt' => 'Baixa', _ => 'Low' },
      PrioridadNotificacion.normal => switch (locale) { 'es' => 'Normal', 'pt' => 'Normal', _ => 'Normal' },
      PrioridadNotificacion.alta => switch (locale) { 'es' => 'Alta', 'pt' => 'Alta', _ => 'High' },
      PrioridadNotificacion.urgente => switch (locale) { 'es' => 'Urgente', 'pt' => 'Urgente', _ => 'Urgent' },
    };
  }
}
