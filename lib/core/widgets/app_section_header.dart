/// Encabezado de sección unificado para listas y formularios
library;

import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Encabezado de sección reutilizable con título y acción opcional.
///
/// Reemplaza las 11+ copias de `_buildSectionHeader` y
/// `_buildFilterSectionHeader` distribuidas por el proyecto.
///
/// ```dart
/// AppSectionHeader(
///   title: 'Filtrar por estado',
/// )
///
/// AppSectionHeader(
///   title: 'Últimas ventas',
///   actionLabel: 'Ver todas',
///   onAction: () => context.push('/ventas'),
/// )
/// ```
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.actionIcon,
    this.padding,
    this.style,
  });

  /// Título de la sección
  final String title;

  /// Texto del botón de acción (ej: "Ver todas")
  final String? actionLabel;

  /// Callback del botón de acción
  final VoidCallback? onAction;

  /// Ícono opcional para el botón de acción
  final IconData? actionIcon;

  /// Padding personalizado (por defecto: solo bottom 8)
  final EdgeInsetsGeometry? padding;

  /// Estilo de texto personalizado (por defecto: titleSmall w600)
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveStyle =
        style ??
        theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurfaceVariant,
        );

    final content = onAction != null || actionLabel != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: effectiveStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (actionLabel != null)
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        actionLabel!,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (actionIcon != null) ...[
                        const SizedBox(width: AppSpacing.xxs),
                        Icon(actionIcon, size: 16),
                      ],
                    ],
                  ),
                ),
            ],
          )
        : Text(
            title,
            style: effectiveStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );

    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: AppSpacing.sm),
      child: content,
    );
  }
}
