/// Pantalla de planes (paywall). Muestra Gratis / Pro / Plus, resalta el plan
/// vigente y permite comprar Pro o Plus vía Google Play Billing.
///
/// Robustez: el plan real se refleja desde [suscripcionProvider] (servidor);
/// esta pantalla solo inicia la compra y muestra feedback. Si Billing no está
/// disponible, los CTA de pago se deshabilitan con un aviso.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/providers/suscripcion_providers.dart';
import '../../domain/enums/plan_suscripcion.dart';
import '../../domain/value_objects/plan_limites.dart';
import '../../infrastructure/billing/billing_service.dart';
import '../widgets/plan_card.dart';

class PlanesPage extends ConsumerStatefulWidget {
  const PlanesPage({super.key});

  @override
  ConsumerState<PlanesPage> createState() => _PlanesPageState();
}

class _PlanesPageState extends ConsumerState<PlanesPage> {
  bool _billingDisponible = false;
  bool _procesando = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initBilling());
  }

  Future<void> _initBilling() async {
    final ok = await ref.read(billingServiceProvider).inicializar();
    if (mounted) setState(() => _billingDisponible = ok);
  }

  Future<void> _comprar(PlanSuscripcion plan) async {
    if (_procesando) return;
    final l = S.of(context);

    if (!_billingDisponible) {
      AppSnackBar.warning(context, message: l.planNoDisponible);
      return;
    }

    setState(() => _procesando = true);
    AppSnackBar.info(context, message: l.planCompraProcesando);

    final resultado = await ref.read(billingServiceProvider).comprar(plan);
    if (!mounted) return;
    setState(() => _procesando = false);

    switch (resultado) {
      case ResultadoCompra.exito:
        AppSnackBar.success(
          context,
          message: l.planCompraExito(plan.localizedName(l)),
        );
      case ResultadoCompra.cancelada:
        AppSnackBar.info(context, message: l.planCompraCancelada);
      case ResultadoCompra.error:
        AppSnackBar.error(context, message: l.planCompraError);
      case ResultadoCompra.noDisponible:
        AppSnackBar.warning(context, message: l.planNoDisponible);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);
    final planActual = ref.watch(planEfectivoProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.planTituloPantalla)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              l.planSubtituloPantalla,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildCard(l, PlanSuscripcion.gratis, planActual),
            const SizedBox(height: AppSpacing.md),
            _buildCard(l, PlanSuscripcion.pro, planActual),
            const SizedBox(height: AppSpacing.md),
            _buildCard(l, PlanSuscripcion.plus, planActual),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: TextButton(
                onPressed: _procesando
                    ? null
                    : () => ref.read(billingServiceProvider).restaurarCompras(),
                child: Text(l.planRestaurarCompras),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PlanCard _buildCard(S l, PlanSuscripcion plan, PlanSuscripcion actual) {
    final limites = PlanLimites.para(plan);
    final esActual = plan == actual;
    final billing = ref.read(billingServiceProvider);

    // Features según el plan.
    final ilim = l.planFeatureIlimitado;
    String cant(int max) =>
        max == PlanLimites.ilimitado ? ilim : '$max';

    final features = <String>[
      l.planFeatureGranjas(cant(limites.maxGranjas)),
      l.planFeatureGalpones(cant(limites.maxGalpones)),
      l.planFeatureLotes(cant(limites.maxLotesActivos)),
      l.planFeatureUsuarios(cant(limites.maxUsuarios)),
      limites.reportesCompletos
          ? l.planFeatureReportesCompletos
          : l.planFeatureReportesBasicos,
      if (limites.apoyoPrioritario) l.planFeatureApoyoPrioritario,
    ];

    // Precio: para planes de pago, usar el precio real de Play si está; si no,
    // un fallback en USD acorde al copy del producto.
    final (precio, sufijo, equivalente) = switch (plan) {
      PlanSuscripcion.gratis => ('US\$ 0', l.planGratisPrecio, l.planEquivalenteSoles('S/ 0')),
      PlanSuscripcion.pro => (
          billing.precioDe(plan) ?? 'US\$ 14.90',
          l.planPorMes,
          l.planEquivalenteSoles('S/ 49.90'),
        ),
      PlanSuscripcion.plus => (
          billing.precioDe(plan) ?? 'US\$ 34.90',
          l.planPorMes,
          l.planEquivalenteSoles('S/ 99.90'),
        ),
    };

    // CTA contextual.
    final String ctaLabel;
    final VoidCallback? onCta;
    if (esActual) {
      ctaLabel = l.planCtaPlanActual;
      onCta = null;
    } else {
      ctaLabel = switch (plan) {
        PlanSuscripcion.gratis => l.planCtaEmpezarGratis,
        PlanSuscripcion.pro => l.planCtaElegirPro,
        PlanSuscripcion.plus => l.planCtaElegirPlus,
      };
      onCta = plan == PlanSuscripcion.gratis
          ? () => Navigator.of(context).maybePop()
          : (_procesando ? null : () => _comprar(plan));
    }

    return PlanCard(
      data: PlanCardData(
        nombre: plan.localizedName(l),
        tagline: plan.localizedTagline(l),
        precio: precio,
        precioSufijo: sufijo,
        equivalente: equivalente,
        features: features,
        ctaLabel: ctaLabel,
        esActual: esActual,
        destacado: plan == PlanSuscripcion.pro,
        onCta: onCta,
      ),
    );
  }
}
