/// Providers de suscripción y entitlements (capa de aplicación).
///
/// Pirámide de derivación:
///   suscripcionProvider  (stream del doc, fail-safe a gratis)
///     └─ planEfectivoProvider     (PlanSuscripcion vigente)
///         └─ planLimitesProvider  (PlanLimites de ese plan)
///             └─ puedeCrearXProvider.family (bool + razón para la UI)
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/providers/auth_provider.dart';
import '../../../galpones/application/providers/galpon_providers.dart';
import '../../../granjas/application/providers/colaboradores_providers.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../../lotes/application/providers/lote_providers.dart';
import '../../domain/entities/suscripcion.dart';
import '../../domain/enums/plan_suscripcion.dart';
import '../../domain/repositories/suscripcion_repository.dart';
import '../../domain/value_objects/plan_limites.dart';
import '../../infrastructure/billing/billing_service.dart';
import '../../infrastructure/datasources/suscripcion_datasource.dart';
import '../../infrastructure/repositories/suscripcion_repository_impl.dart';

// =============================================================================
// INFRAESTRUCTURA
// =============================================================================

final suscripcionDatasourceProvider = Provider<SuscripcionDatasource>((ref) {
  return SuscripcionDatasource(FirebaseFirestore.instance);
});

final suscripcionRepositoryProvider = Provider<SuscripcionRepository>((ref) {
  return SuscripcionRepositoryImpl(ref.watch(suscripcionDatasourceProvider));
});

/// Servicio de Google Play Billing. Se mantiene vivo durante la sesión y se
/// libera al destruirse el provider.
final billingServiceProvider = Provider<BillingService>((ref) {
  final service = BillingService();
  ref.onDispose(service.dispose);
  return service;
});

// =============================================================================
// SUSCRIPCIÓN DEL USUARIO ACTUAL
// =============================================================================

/// Stream de la suscripción del usuario autenticado. Emite gratis si no hay
/// usuario o no hay documento. NO autoDispose: el plan se consulta en toda la
/// app, conviene mantenerlo vivo mientras dure la sesión.
final suscripcionProvider = StreamProvider<Suscripcion>((ref) {
  final usuario = ref.watch(currentUserProvider);
  if (usuario == null || usuario.id.isEmpty) {
    return Stream.value(Suscripcion.gratis(''));
  }
  return ref.watch(suscripcionRepositoryProvider).observar(usuario.id);
});

/// Plan EFECTIVO vigente del usuario actual. Mientras carga o ante error,
/// asume gratis (fail-safe: nunca concede de más por un estado transitorio).
final planEfectivoProvider = Provider<PlanSuscripcion>((ref) {
  final susAsync = ref.watch(suscripcionProvider);
  return susAsync.maybeWhen(
    data: (s) => s.planEfectivo,
    orElse: () => PlanSuscripcion.gratis,
  );
});

/// Límites/capacidades vigentes del usuario actual.
final planLimitesProvider = Provider<PlanLimites>((ref) {
  return PlanLimites.para(ref.watch(planEfectivoProvider));
});

/// `true` si el usuario tiene acceso a reportes completos.
final reportesCompletosProvider = Provider<bool>((ref) {
  return ref.watch(planLimitesProvider).reportesCompletos;
});

// =============================================================================
// EVALUACIÓN DE LÍMITES (para candados + paywall en la UI)
// =============================================================================

/// Recurso que un límite puede bloquear. Permite que la UI sepa qué paywall
/// mostrar y qué mensaje usar.
enum RecursoPlan { granja, galpon, lote, usuario }

/// Resultado de evaluar si se puede crear un recurso bajo el plan actual.
class EvaluacionLimite {
  const EvaluacionLimite({
    required this.permitido,
    required this.recurso,
    required this.planActual,
    required this.cargando,
    this.actual,
    this.maximo,
  });

  /// `true` si se puede crear; `false` si se alcanzó el límite.
  final bool permitido;
  final RecursoPlan recurso;
  final PlanSuscripcion planActual;

  /// `true` mientras los conteos aún cargan (la UI no debe bloquear todavía).
  final bool cargando;

  /// Conteo actual y tope (para textos "2 de 2"). `null` si aún carga.
  final int? actual;

  /// Tope del plan. [PlanLimites.ilimitado] si sin tope.
  final int? maximo;

  /// Plan mínimo sugerido para superar el límite (el siguiente de pago).
  PlanSuscripcion get planSugerido =>
      planActual == PlanSuscripcion.gratis
          ? PlanSuscripcion.pro
          : PlanSuscripcion.plus;
}

/// ¿Puede el usuario crear OTRA granja? Evalúa contra el plan vigente.
final puedeCrearGranjaProvider = Provider<EvaluacionLimite>((ref) {
  final limites = ref.watch(planLimitesProvider);
  final plan = ref.watch(planEfectivoProvider);
  final conteoAsync = ref.watch(conteoGranjasProvider);

  return conteoAsync.when(
    data: (n) => EvaluacionLimite(
      permitido: limites.puedeCrearGranja(n),
      recurso: RecursoPlan.granja,
      planActual: plan,
      cargando: false,
      actual: n,
      maximo: limites.maxGranjas,
    ),
    loading: () => EvaluacionLimite(
      permitido: false,
      recurso: RecursoPlan.granja,
      planActual: plan,
      cargando: true,
    ),
    error: (_, __) => EvaluacionLimite(
      permitido: false,
      recurso: RecursoPlan.granja,
      planActual: plan,
      cargando: false,
    ),
  );
});

/// ¿Puede crear OTRO galpón en [granjaId]?
final puedeCrearGalponProvider =
    Provider.family<EvaluacionLimite, String>((ref, granjaId) {
  final limites = ref.watch(planLimitesProvider);
  final plan = ref.watch(planEfectivoProvider);
  final conteoAsync = ref.watch(conteoGalponesProvider(granjaId));

  return conteoAsync.when(
    data: (n) => EvaluacionLimite(
      permitido: limites.puedeCrearGalpon(n),
      recurso: RecursoPlan.galpon,
      planActual: plan,
      cargando: false,
      actual: n,
      maximo: limites.maxGalpones,
    ),
    loading: () => EvaluacionLimite(
      permitido: false,
      recurso: RecursoPlan.galpon,
      planActual: plan,
      cargando: true,
    ),
    error: (_, __) => EvaluacionLimite(
      permitido: false,
      recurso: RecursoPlan.galpon,
      planActual: plan,
      cargando: false,
    ),
  );
});

/// ¿Puede activar OTRO lote en [granjaId]? (cuenta solo lotes activos)
final puedeCrearLoteProvider =
    Provider.family<EvaluacionLimite, String>((ref, granjaId) {
  final limites = ref.watch(planLimitesProvider);
  final plan = ref.watch(planEfectivoProvider);
  final conteoAsync = ref.watch(conteoLotesActivosProvider(granjaId));

  return conteoAsync.when(
    data: (n) => EvaluacionLimite(
      permitido: limites.puedeCrearLoteActivo(n),
      recurso: RecursoPlan.lote,
      planActual: plan,
      cargando: false,
      actual: n,
      maximo: limites.maxLotesActivos,
    ),
    loading: () => EvaluacionLimite(
      permitido: false,
      recurso: RecursoPlan.lote,
      planActual: plan,
      cargando: true,
    ),
    error: (_, __) => EvaluacionLimite(
      permitido: false,
      recurso: RecursoPlan.lote,
      planActual: plan,
      cargando: false,
    ),
  );
});

/// ¿Puede agregar OTRO usuario (colaborador) en [granjaId]?
final puedeAgregarUsuarioProvider =
    Provider.family<EvaluacionLimite, String>((ref, granjaId) {
  final limites = ref.watch(planLimitesProvider);
  final plan = ref.watch(planEfectivoProvider);
  final usuariosAsync = ref.watch(usuariosGranjaProvider(granjaId));

  return usuariosAsync.when(
    data: (usuarios) => EvaluacionLimite(
      permitido: limites.puedeAgregarUsuario(usuarios.length),
      recurso: RecursoPlan.usuario,
      planActual: plan,
      cargando: false,
      actual: usuarios.length,
      maximo: limites.maxUsuarios,
    ),
    loading: () => EvaluacionLimite(
      permitido: false,
      recurso: RecursoPlan.usuario,
      planActual: plan,
      cargando: true,
    ),
    error: (_, __) => EvaluacionLimite(
      permitido: false,
      recurso: RecursoPlan.usuario,
      planActual: plan,
      cargando: false,
    ),
  );
});
