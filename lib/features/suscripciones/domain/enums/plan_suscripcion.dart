/// Plan de suscripción del propietario de una granja.
///
/// Determina los límites de recursos (granjas, galpones, lotes, usuarios)
/// y el acceso a funciones avanzadas (reportes completos, apoyo prioritario).
/// El plan se ata SIEMPRE al propietario de la granja; los colaboradores
/// operan dentro de los límites del dueño.
library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

enum PlanSuscripcion {
  /// Plan gratuito de entrada (1 granja / 1 galpón / 1 lote / 1 usuario).
  gratis,

  /// Plan Pro de pago (hasta 2 / 8 / 8 / 4) con reportes completos.
  pro,

  /// Plan Plus de pago (ilimitado) con reportes completos y apoyo prioritario.
  plus;

  /// Jerarquía del plan (mayor = más capacidades). Útil para comparar
  /// "este plan es suficiente para X" y para sugerir el siguiente plan.
  int get nivel => switch (this) {
    PlanSuscripcion.gratis => 0,
    PlanSuscripcion.pro => 1,
    PlanSuscripcion.plus => 2,
  };

  /// `true` si es un plan de pago (Pro o Plus).
  bool get esDePago => this != PlanSuscripcion.gratis;

  /// Nombre comercial del plan (no se traduce: es marca).
  String get displayName => switch (this) {
    PlanSuscripcion.gratis => 'Gratis',
    PlanSuscripcion.pro => 'Pro',
    PlanSuscripcion.plus => 'Plus',
  };

  /// Identificador del producto en Google Play (base plan mensual).
  /// `null` para el plan gratis (no se compra).
  String? get playProductId => switch (this) {
    PlanSuscripcion.gratis => null,
    PlanSuscripcion.pro => 'pro_mensual',
    PlanSuscripcion.plus => 'plus_mensual',
  };

  /// Nombre localizado para UI con AppLocalizations.
  String localizedName(S l) => switch (this) {
    PlanSuscripcion.gratis => l.planGratisNombre,
    PlanSuscripcion.pro => l.planProNombre,
    PlanSuscripcion.plus => l.planPlusNombre,
  };

  /// Descripción localizada (tagline) para UI con AppLocalizations.
  String localizedTagline(S l) => switch (this) {
    PlanSuscripcion.gratis => l.planGratisTagline,
    PlanSuscripcion.pro => l.planProTagline,
    PlanSuscripcion.plus => l.planPlusTagline,
  };

  /// Descripción de fallback sin context (usa el locale actual).
  String get taglineFallback {
    final locale = Formatters.currentLocale;
    return switch (this) {
      PlanSuscripcion.gratis => switch (locale) {
        'es' => 'Empieza sin pagar y comprueba si la app te ayuda.',
        'pt' => 'Comece sem pagar e veja se o app te ajuda.',
        _ => 'Start free and see if the app helps you.',
      },
      PlanSuscripcion.pro => switch (locale) {
        'es' => 'Para productores que necesitan más precisión.',
        'pt' => 'Para produtores que precisam de mais precisão.',
        _ => 'For producers who need more precision.',
      },
      PlanSuscripcion.plus => switch (locale) {
        'es' => 'Para operaciones con varios galpones y más equipo.',
        'pt' => 'Para operações com vários galpões e mais equipe.',
        _ => 'For operations with several houses and more team.',
      },
    };
  }

  String toJson() => name;

  /// Parsea desde JSON de forma segura: cualquier valor desconocido o nulo
  /// degrada a [PlanSuscripcion.gratis] (nunca lanza, nunca otorga de más).
  static PlanSuscripcion fromJson(String? json) {
    if (json == null) return PlanSuscripcion.gratis;
    return PlanSuscripcion.values.firstWhere(
      (e) => e.name == json,
      orElse: () => PlanSuscripcion.gratis,
    );
  }

  /// Resuelve el plan a partir de un `playProductId` de Google Play.
  /// Desconocido ⇒ gratis (seguro por defecto).
  static PlanSuscripcion desdeProductId(String? productId) {
    if (productId == null) return PlanSuscripcion.gratis;
    return PlanSuscripcion.values.firstWhere(
      (e) => e.playProductId == productId,
      orElse: () => PlanSuscripcion.gratis,
    );
  }
}
