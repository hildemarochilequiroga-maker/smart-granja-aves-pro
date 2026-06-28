/// Bottom sheet que se muestra cuando el usuario alcanza un límite de su plan.
///
/// Explica qué límite se tocó y ofrece ir a la pantalla de planes para mejorar.
/// Se dispara desde dos sitios:
///  - Al pulsar un botón de creación bloqueado (proactivo).
///  - Al recibir un [LimitePlanFailure] de un usecase (reactivo, defensa).
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/providers/suscripcion_providers.dart';
import '../../domain/enums/plan_suscripcion.dart';
import '../../domain/value_objects/plan_limites.dart';

class PlanLimiteSheet extends StatelessWidget {
  const PlanLimiteSheet({
    required this.recurso,
    required this.planActual,
    required this.planSugerido,
    this.limite,
    super.key,
  });

  final RecursoPlan recurso;
  final PlanSuscripcion planActual;
  final PlanSuscripcion planSugerido;
  final int? limite;

  /// Muestra el sheet a partir de una [EvaluacionLimite] (camino proactivo).
  static Future<void> mostrarDesdeEvaluacion(
    BuildContext context,
    EvaluacionLimite eval,
  ) {
    return showAppBottomSheet<void>(
      context: context,
      builder: (_) => PlanLimiteSheet(
        recurso: eval.recurso,
        planActual: eval.planActual,
        planSugerido: eval.planSugerido,
        limite: eval.maximo,
      ),
    );
  }

  /// Muestra el sheet a partir de un [LimitePlanFailure] (camino reactivo).
  static Future<void> mostrarDesdeFailure(
    BuildContext context,
    LimitePlanFailure failure,
  ) {
    final recurso = switch (failure.recurso) {
      'granja' => RecursoPlan.granja,
      'galpon' => RecursoPlan.galpon,
      'lote' => RecursoPlan.lote,
      _ => RecursoPlan.usuario,
    };
    return showAppBottomSheet<void>(
      context: context,
      builder: (_) => PlanLimiteSheet(
        recurso: recurso,
        planActual: PlanSuscripcion.fromJson(failure.planActual),
        planSugerido: PlanSuscripcion.fromJson(failure.planSugerido),
        limite: failure.limite,
      ),
    );
  }

  String _titulo(S l) => switch (recurso) {
    RecursoPlan.granja => l.planLimiteTituloGranja,
    RecursoPlan.galpon => l.planLimiteTituloGalpon,
    RecursoPlan.lote => l.planLimiteTituloLote,
    RecursoPlan.usuario => l.planLimiteTituloUsuario,
  };

  IconData get _icono => switch (recurso) {
    RecursoPlan.granja => Icons.agriculture_outlined,
    RecursoPlan.galpon => Icons.warehouse_outlined,
    RecursoPlan.lote => Icons.egg_outlined,
    RecursoPlan.usuario => Icons.group_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);
    final limiteTexto = limite == null
        ? '∞'
        : PlanLimites.formatear(limite!);

    return AppBottomSheetScaffold(
      title: _titulo(l),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 32,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  _icono,
                  size: 32,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l.planLimiteDescripcion(planActual.localizedName(l), limiteTexto),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton.primary(
              label: l.planLimiteVerPlanes,
              expanded: true,
              onPressed: () {
                Navigator.of(context).pop();
                context.push(AppRoutes.planes);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton.text(
              label: l.commonClose,
              expanded: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
