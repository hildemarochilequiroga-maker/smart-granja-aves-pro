/// Widget reutilizable para secciones de detalle de salud.
///
/// Card con título y contenido que sigue el diseño consistente del proyecto.
library;

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Widget de sección para páginas de detalle de salud.
///
/// Incluye:
/// - Título con icono opcional
/// - Card con borde sutil y sombra
/// - Contenido personalizable
class SaludDetailSection extends StatelessWidget {
  const SaludDetailSection({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.trailing,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
  });

  /// Título de la sección
  final String title;

  /// Contenido de la sección
  final Widget child;

  /// Icono opcional al lado del título
  final IconData? icon;

  /// Widget opcional a la derecha del título
  final Widget? trailing;

  /// Padding interno de la card
  final EdgeInsetsGeometry padding;

  /// Margen externo de la sección
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con título
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: theme.colorScheme.primary),
                  AppSpacing.hGapSm,
                ],
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),

          // Card con contenido
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: AppRadius.allMd,
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: AppRadius.allMd,
              child: Material(
                color: Colors.transparent,
                child: Padding(padding: padding, child: child),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget para mostrar una fila de información label-value.
class SaludInfoRow extends StatelessWidget {
  const SaludInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
    this.showDivider = true,
    this.isLast = false,
  });

  /// Etiqueta de la información
  final String label;

  /// Valor a mostrar
  final String value;

  /// Icono opcional
  final IconData? icon;

  /// Color personalizado para el valor
  final Color? valueColor;

  /// Mostrar divisor debajo
  final bool showDivider;

  /// Es el último elemento (no muestra divisor)
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
                AppSpacing.hGapMd,
              ],
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                flex: 3,
                child: Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: valueColor ?? theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        if (showDivider && !isLast)
          Divider(
            height: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
      ],
    );
  }
}

/// Widget para mostrar contenido de texto largo (síntomas, observaciones, etc.)
class SaludTextContent extends StatelessWidget {
  const SaludTextContent({
    super.key,
    required this.label,
    required this.content,
    this.icon,
  });

  /// Etiqueta del contenido
  final String label;

  /// Contenido de texto
  final String content;

  /// Icono opcional
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 24),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
              AppSpacing.hGapSm,
            ],
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        AppSpacing.gapSm,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            borderRadius: AppRadius.allSm,
          ),
          child: Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ),
      ],
    );
  }
}

/// Widget para mostrar un badge de estado.
class SaludStatusBadge extends StatelessWidget {
  const SaludStatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.isLarge = false,
  });

  /// Texto del badge
  final String label;

  /// Color del badge
  final Color color;

  /// Icono opcional
  final IconData? icon;

  /// Tamaño grande
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 14 : 10,
        vertical: isLarge ? 8 : 5,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(isLarge ? 8 : 6),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isLarge ? 16 : 14, color: AppColors.white),
            AppSpacing.hGapXs,
          ],
          Text(
            label,
            style:
                (isLarge
                        ? theme.textTheme.labelLarge
                        : theme.textTheme.labelSmall)
                    ?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
          ),
        ],
      ),
    );
  }
}
