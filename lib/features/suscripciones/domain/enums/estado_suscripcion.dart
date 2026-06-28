/// Estado del ciclo de vida de una suscripción.
library;

enum EstadoSuscripcion {
  /// Suscripción pagada y vigente.
  activa,

  /// Pago vencido pero dentro del periodo de gracia de Google Play
  /// (el usuario conserva acceso temporalmente).
  enGracia,

  /// Vencida sin renovar ⇒ se degrada a plan gratis.
  expirada,

  /// Cancelada por el usuario (puede seguir vigente hasta [vigenteHasta]).
  cancelada,

  /// Suspendida por Google (p. ej. problema de pago, hold).
  suspendida;

  /// `true` si el estado otorga acceso a las capacidades del plan de pago.
  /// Solo [activa], [enGracia] y [cancelada] (esta última hasta que expire)
  /// mantienen el acceso; el resto degrada a gratis.
  bool get otorgaAcceso =>
      this == EstadoSuscripcion.activa ||
      this == EstadoSuscripcion.enGracia ||
      this == EstadoSuscripcion.cancelada;

  String toJson() => name;

  /// Parseo seguro: desconocido/nulo ⇒ [expirada] (degrada a gratis).
  static EstadoSuscripcion fromJson(String? json) {
    if (json == null) return EstadoSuscripcion.expirada;
    return EstadoSuscripcion.values.firstWhere(
      (e) => e.name == json,
      orElse: () => EstadoSuscripcion.expirada,
    );
  }
}
