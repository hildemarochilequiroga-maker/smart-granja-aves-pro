/// Límites y capacidades (entitlements) de un plan de suscripción.
///
/// Es la ÚNICA fuente de verdad de "qué puede hacer cada plan". Cambiar
/// un límite o una capacidad se hace SOLO aquí, en [PlanLimites.para].
library;

import 'package:equatable/equatable.dart';

import '../enums/plan_suscripcion.dart';

class PlanLimites extends Equatable {
  const PlanLimites({
    required this.maxGranjas,
    required this.maxGalpones,
    required this.maxLotesActivos,
    required this.maxUsuarios,
    required this.reportesCompletos,
    required this.apoyoPrioritario,
  });

  /// Máximo de granjas por propietario. [ilimitado] = sin tope.
  final int maxGranjas;

  /// Máximo de galpones por granja. [ilimitado] = sin tope.
  final int maxGalpones;

  /// Máximo de lotes ACTIVOS por granja (cerrar/vender libera cupo).
  /// [ilimitado] = sin tope.
  final int maxLotesActivos;

  /// Máximo de usuarios por granja (propietario + colaboradores activos).
  /// [ilimitado] = sin tope.
  final int maxUsuarios;

  /// Acceso a reportes completos (vs. solo básicos).
  final bool reportesCompletos;

  /// Acceso a apoyo/soporte prioritario.
  final bool apoyoPrioritario;

  /// Centinela para "sin límite". Se modela como -1 para evitar dispersar
  /// `null` por el código y para que las comparaciones sean explícitas.
  static const int ilimitado = -1;

  /// Tabla maestra de límites por plan. Punto único de configuración.
  ///
  /// Gratis: 1 / 1 / 1 / 1, reportes básicos.
  /// Pro:    2 / 8 / 8 / 4, reportes completos.
  /// Plus:   ∞ / ∞ / ∞ / ∞, reportes completos + apoyo prioritario.
  static PlanLimites para(PlanSuscripcion plan) => switch (plan) {
    PlanSuscripcion.gratis => const PlanLimites(
      maxGranjas: 1,
      maxGalpones: 1,
      maxLotesActivos: 1,
      maxUsuarios: 1,
      reportesCompletos: false,
      apoyoPrioritario: false,
    ),
    PlanSuscripcion.pro => const PlanLimites(
      maxGranjas: 2,
      maxGalpones: 8,
      maxLotesActivos: 8,
      maxUsuarios: 4,
      reportesCompletos: true,
      apoyoPrioritario: false,
    ),
    PlanSuscripcion.plus => const PlanLimites(
      maxGranjas: ilimitado,
      maxGalpones: ilimitado,
      maxLotesActivos: ilimitado,
      maxUsuarios: ilimitado,
      reportesCompletos: true,
      apoyoPrioritario: true,
    ),
  };

  /// `true` si con [actual] recursos todavía se puede crear uno más bajo
  /// el tope [max]. [ilimitado] siempre permite. Defensivo ante negativos.
  static bool _permite(int actual, int max) {
    if (max == ilimitado) return true;
    if (actual < 0) return false; // dato corrupto ⇒ no otorgar de más
    return actual < max;
  }

  /// ¿Se puede crear otra granja teniendo [granjasActuales]?
  bool puedeCrearGranja(int granjasActuales) =>
      _permite(granjasActuales, maxGranjas);

  /// ¿Se puede crear otro galpón en una granja con [galponesActuales]?
  bool puedeCrearGalpon(int galponesActuales) =>
      _permite(galponesActuales, maxGalpones);

  /// ¿Se puede activar otro lote en una granja con [lotesActivosActuales]?
  bool puedeCrearLoteActivo(int lotesActivosActuales) =>
      _permite(lotesActivosActuales, maxLotesActivos);

  /// ¿Se puede sumar otro usuario en una granja con [usuariosActuales]?
  bool puedeAgregarUsuario(int usuariosActuales) =>
      _permite(usuariosActuales, maxUsuarios);

  /// Cupos restantes (para mostrar "te queda 1"). `null` = ilimitado.
  int? restantes(int actual, int max) {
    if (max == ilimitado) return null;
    final r = max - actual;
    return r < 0 ? 0 : r;
  }

  /// Representación legible de un tope para UI ("∞" si ilimitado).
  static String formatear(int max) => max == ilimitado ? '∞' : '$max';

  /// Plan mínimo de pago que supera el plan [actual]: desde gratis ⇒ pro,
  /// desde pro ⇒ plus. Plus ya es el tope, sugiere plus (no hay más allá).
  static PlanSuscripcion sugeridoTras(PlanSuscripcion actual) =>
      switch (actual) {
        PlanSuscripcion.gratis => PlanSuscripcion.pro,
        PlanSuscripcion.pro => PlanSuscripcion.plus,
        PlanSuscripcion.plus => PlanSuscripcion.plus,
      };

  @override
  List<Object?> get props => [
    maxGranjas,
    maxGalpones,
    maxLotesActivos,
    maxUsuarios,
    reportesCompletos,
    apoyoPrioritario,
  ];
}
