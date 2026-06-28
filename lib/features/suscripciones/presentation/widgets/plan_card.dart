/// Card de un plan en la pantalla de planes.
///
/// Muestra nombre, tagline, precio, lista de features y un CTA contextual
/// (plan actual / elegir / mejorar). El estilo resalta el plan recomendado.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';

class PlanCardData {
  const PlanCardData({
    required this.nombre,
    required this.tagline,
    required this.precio,
    required this.precioSufijo,
    required this.equivalente,
    required this.features,
    required this.ctaLabel,
    required this.esActual,
    required this.destacado,
    required this.onCta,
  });

  final String nombre;
  final String tagline;

  /// Precio principal (ej. "US\$ 14.90" o "US\$ 0").
  final String precio;

  /// Sufijo del precio (ej. "/mes" o "/plan gratis").
  final String precioSufijo;

  /// Equivalente en moneda local (ej. "Equivalente en soles: S/ 49.90").
  final String equivalente;

  /// Líneas de características.
  final List<String> features;

  final String ctaLabel;

  /// `true` si es el plan vigente del usuario (CTA deshabilitado).
  final bool esActual;

  /// `true` para resaltar la card (plan recomendado).
  final bool destacado;

  /// Acción del CTA. `null` ⇒ deshabilitado (p. ej. plan actual).
  final VoidCallback? onCta;
}

class PlanCard extends StatelessWidget {
  const PlanCard({required this.data, super.key});

  final PlanCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final borde = data.destacado
        ? AppColors.primary
        : colorScheme.outlineVariant;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadius.allLg,
        border: Border.all(
          color: borde,
          width: data.destacado ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                data.nombre,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              if (data.esActual) ...[
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: AppRadius.allFull,
                  ),
                  child: Text(
                    data.ctaLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            data.tagline,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                data.precio,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                data.precioSufijo,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (data.equivalente.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              data.equivalente,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          ...data.features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 18,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      f,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (data.destacado)
            AppButton.primary(
              label: data.ctaLabel,
              expanded: true,
              onPressed: data.onCta,
            )
          else
            AppButton.secondary(
              label: data.ctaLabel,
              expanded: true,
              onPressed: data.onCta,
            ),
        ],
      ),
    );
  }
}
