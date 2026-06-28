/// Origen de la suscripción: cómo obtuvo el usuario su plan actual.
library;

enum OrigenSuscripcion {
  /// Plan gratis por defecto (sin compra).
  gratis,

  /// Comprada vía Google Play Billing (validada en servidor).
  playBilling,

  /// Asignada manualmente (admin, early access, grandfathering).
  manual;

  String toJson() => name;

  /// Parseo seguro: desconocido/nulo ⇒ [gratis].
  static OrigenSuscripcion fromJson(String? json) {
    if (json == null) return OrigenSuscripcion.gratis;
    return OrigenSuscripcion.values.firstWhere(
      (e) => e.name == json,
      orElse: () => OrigenSuscripcion.gratis,
    );
  }
}
