/// Entidad que representa la suscripción de un usuario propietario.
///
/// Es el agregado que combina el plan contratado con su estado de ciclo de
/// vida. La regla de oro de seguridad es: **el plan EFECTIVO solo concede
/// capacidades de pago si el estado otorga acceso Y no está vencido.** En
/// cualquier duda o dato corrupto, degrada a [PlanSuscripcion.gratis].
library;

import 'package:equatable/equatable.dart';

import '../enums/estado_suscripcion.dart';
import '../enums/origen_suscripcion.dart';
import '../enums/plan_suscripcion.dart';
import '../value_objects/plan_limites.dart';

class Suscripcion extends Equatable {
  const Suscripcion({
    required this.usuarioId,
    required this.plan,
    required this.estado,
    required this.origen,
    this.vigenteHasta,
    this.playProductId,
    this.playPurchaseToken,
    this.actualizadoEn,
  });

  /// UID del usuario propietario al que pertenece esta suscripción.
  final String usuarioId;

  /// Plan CONTRATADO (lo que el usuario compró). Para saber qué puede usar
  /// realmente, usar siempre [planEfectivo], no este campo.
  final PlanSuscripcion plan;

  /// Estado del ciclo de vida.
  final EstadoSuscripcion estado;

  /// Cómo obtuvo el plan.
  final OrigenSuscripcion origen;

  /// Fecha hasta la cual la suscripción es válida (de Google Play).
  /// `null` para gratis o asignaciones manuales sin vencimiento.
  final DateTime? vigenteHasta;

  /// Producto de Play asociado (para validación servidor).
  final String? playProductId;

  /// Token de compra de Play (para validación servidor). Sensible.
  final String? playPurchaseToken;

  /// Última actualización del documento (escrita por el servidor).
  final DateTime? actualizadoEn;

  /// Suscripción gratis por defecto para un usuario (sin doc en Firestore).
  factory Suscripcion.gratis(String usuarioId) => Suscripcion(
    usuarioId: usuarioId,
    plan: PlanSuscripcion.gratis,
    estado: EstadoSuscripcion.activa,
    origen: OrigenSuscripcion.gratis,
  );

  /// ¿La suscripción está vencida por fecha? Una asignación manual sin
  /// [vigenteHasta] nunca vence; con fecha, vence al pasarla.
  bool get estaVencidaPorFecha {
    final hasta = vigenteHasta;
    if (hasta == null) return false;
    return DateTime.now().isAfter(hasta);
  }

  /// Plan EFECTIVO: el que realmente concede capacidades AHORA.
  ///
  /// Reglas (fail-safe — ante cualquier duda, gratis):
  /// 1. El gratis siempre es gratis.
  /// 2. Si el estado NO otorga acceso ⇒ gratis.
  /// 3. Si está vencida por fecha ⇒ gratis.
  /// 4. En cualquier otro caso ⇒ el plan contratado.
  PlanSuscripcion get planEfectivo {
    if (plan == PlanSuscripcion.gratis) return PlanSuscripcion.gratis;
    if (!estado.otorgaAcceso) return PlanSuscripcion.gratis;
    if (estaVencidaPorFecha) return PlanSuscripcion.gratis;
    return plan;
  }

  /// Límites/capacidades vigentes derivados del [planEfectivo].
  PlanLimites get limites => PlanLimites.para(planEfectivo);

  /// `true` si el usuario está realmente en un plan de pago vigente.
  bool get tienePlanDePagoActivo => planEfectivo.esDePago;

  Suscripcion copyWith({
    String? usuarioId,
    PlanSuscripcion? plan,
    EstadoSuscripcion? estado,
    OrigenSuscripcion? origen,
    DateTime? vigenteHasta,
    String? playProductId,
    String? playPurchaseToken,
    DateTime? actualizadoEn,
  }) {
    return Suscripcion(
      usuarioId: usuarioId ?? this.usuarioId,
      plan: plan ?? this.plan,
      estado: estado ?? this.estado,
      origen: origen ?? this.origen,
      vigenteHasta: vigenteHasta ?? this.vigenteHasta,
      playProductId: playProductId ?? this.playProductId,
      playPurchaseToken: playPurchaseToken ?? this.playPurchaseToken,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  @override
  List<Object?> get props => [
    usuarioId,
    plan,
    estado,
    origen,
    vigenteHasta,
    playProductId,
    playPurchaseToken,
    actualizadoEn,
  ];
}
