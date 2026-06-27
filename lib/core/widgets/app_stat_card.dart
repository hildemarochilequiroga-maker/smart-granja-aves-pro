/// Card de estadística (KPI) reutilizable: valor destacado + subtítulo.
///
/// Es el mismo diseño usado en las pantallas de historial (grid 2x2 de KPIs),
/// extraído a `core` para reutilizarlo en costos, ventas, etc.
library;

import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Card de KPI: valor grande coloreado + subtítulo.
///
/// - [isHighlight] = true → fondo tenue del color + borde (resalta el KPI
///   principal, p.ej. el total).
/// - [isHighlight] = false → fondo de superficie con sombra sutil.
class AppStatCard extends StatelessWidget {
  const AppStatCard({
    super.key,
    required this.value,
    required this.subtitle,
    required this.color,
    this.isHighlight = false,
  });

  final String value;
  final String subtitle;
  final Color color;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isHighlight
            ? color.withValues(alpha: 0.08)
            : theme.colorScheme.surface,
        borderRadius: AppRadius.allMd,
        border: isHighlight
            ? Border.all(color: color.withValues(alpha: 0.3))
            : null,
        boxShadow: isHighlight
            ? null
            : [
                BoxShadow(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
              height: 1,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
