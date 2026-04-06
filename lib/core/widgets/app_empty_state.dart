/// Widget de estado vacío unificado para toda la aplicación
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_animations.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

/// Estado vacío parametrizable que reemplaza todas las copias
/// duplicadas en los módulos (ventas, salud, lotes, granjas, etc.).
///
/// Soporta dos estados:
/// - **Sin datos:** ícono de ilustración + título + descripción + botón de crear
/// - **Sin resultados (filtros):** ícono de búsqueda + título + descripción + botón de limpiar
///
/// Incluye animación de entrada y diseño responsivo.
///
/// ```dart
/// AppEmptyState(
///   icon: Icons.storefront_outlined,
///   title: 'Sin ventas registradas',
///   description: 'Registra tu primera venta...',
///   actionLabel: 'Registrar primera venta',
///   actionIcon: Icons.add_rounded,
///   onAction: () => context.push('/ventas/nueva'),
/// )
/// ```
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    this.icon,
    this.title,
    this.description,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.hasFilters = false,
    this.filterTitle,
    this.filterDescription,
    this.filterIcon,
    this.onClearFilters,
    this.clearFiltersLabel,
    this.iconColor,
    this.animate = true,
    this.compact = false,
    this.action,
  });

  // ── Sin datos ──────────────────────────────────────────────────────────

  /// Ícono principal de la ilustración (ej: `Icons.storefront_outlined`)
  final IconData? icon;

  /// Color del ícono (por defecto usa `colorScheme.primary`)
  final Color? iconColor;

  /// Título principal (ej: "Sin ventas registradas")
  final String? title;

  /// Descripción secundaria
  final String? description;

  /// Texto del botón de acción (ej: "Registrar primera venta")
  final String? actionLabel;

  /// Ícono del botón de acción
  final IconData? actionIcon;

  /// Callback del botón de acción
  final VoidCallback? onAction;

  /// Widget de acción completamente personalizado (anula actionLabel/Icon)
  final Widget? action;

  // ── Con filtros activos ────────────────────────────────────────────────

  /// Si es true, muestra el estado "sin resultados" en vez de "sin datos"
  final bool hasFilters;

  /// Título cuando hay filtros (por defecto: "No se encontraron resultados")
  final String? filterTitle;

  /// Descripción cuando hay filtros
  final String? filterDescription;

  /// Ícono cuando hay filtros (por defecto: `Icons.search_off_rounded`)
  final IconData? filterIcon;

  /// Callback para limpiar filtros
  final VoidCallback? onClearFilters;

  /// Texto del botón de limpiar filtros (por defecto: "Limpiar filtros")
  final String? clearFiltersLabel;

  // ── Personalización ────────────────────────────────────────────────────

  /// Si es true, anima la entrada con fade+slide (por defecto: true)
  final bool animate;

  /// Si es true, usa tamaño compacto (para sub-secciones, tabs)
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isSmall = size.width < 360;
    final l = S.of(context);

    final effectiveIcon = hasFilters
        ? (filterIcon ?? Icons.search_off_rounded)
        : icon;
    final effectiveIconColor = hasFilters
        ? theme.colorScheme.onSurfaceVariant
        : (iconColor ?? theme.colorScheme.primary);
    final effectiveTitle = hasFilters
        ? (filterTitle ?? l.commonNoResults)
        : title;
    final effectiveDescription = hasFilters
        ? (filterDescription ?? l.commonNoResultsHint)
        : description;

    final double iconSize;
    final double padding;

    if (compact) {
      iconSize = isSmall ? 48 : 64;
      padding = AppSpacing.base;
    } else {
      iconSize = isSmall ? 80 : 100;
      padding = isSmall ? AppSpacing.xl : AppSpacing.xxl;
    }

    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ícono con animación de escala sutil
        if (effectiveIcon != null) ...[
          _AnimatedIcon(
            icon: effectiveIcon,
            size: iconSize,
            color: effectiveIconColor,
            animate: animate,
          ),
          SizedBox(height: isSmall ? AppSpacing.md : AppSpacing.base),
        ],

        // Título
        if (effectiveTitle != null) ...[
          Text(
            effectiveTitle,
            style:
                (isSmall || compact
                        ? theme.textTheme.titleLarge
                        : theme.textTheme.headlineSmall)
                    ?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isSmall ? AppSpacing.sm : AppSpacing.md),
        ],

        // Descripción
        if (effectiveDescription != null)
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isSmall ? 260 : 320),
            child: Text(
              effectiveDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        // Botón de acción
        if (_hasAction) ...[
          SizedBox(height: isSmall ? AppSpacing.xl : AppSpacing.xxl),
          _buildActionButton(theme, isSmall, l),
        ],
      ],
    );

    // Animar entrada con fade + slide
    if (animate) {
      content = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: AppAnimations.medium,
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: content,
      );
    }

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(padding: EdgeInsets.all(padding), child: content),
      ),
    );
  }

  bool get _hasAction {
    if (hasFilters && onClearFilters != null) return true;
    if (action != null) return true;
    return actionLabel != null && onAction != null;
  }

  Widget _buildActionButton(ThemeData theme, bool isSmall, S l) {
    // Filtros activos → botón de limpiar
    if (hasFilters && onClearFilters != null) {
      return FilledButton.icon(
        onPressed: () {
          HapticFeedback.selectionClick();
          onClearFilters!();
        },
        icon: const Icon(Icons.filter_list_off_rounded, size: 18),
        label: Text(
          clearFiltersLabel ?? (isSmall ? l.commonClear : l.commonClearFilters),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.secondaryContainer,
          foregroundColor: theme.colorScheme.onSecondaryContainer,
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? AppSpacing.base : AppSpacing.xl,
            vertical: isSmall ? 10 : AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
        ),
      );
    }

    // Widget personalizado
    if (action != null) return action!;

    // Botón de acción estándar
    final hasIcon = actionIcon != null;
    return hasIcon
        ? FilledButton.icon(
            onPressed: () {
              HapticFeedback.selectionClick();
              onAction!();
            },
            icon: Icon(actionIcon, size: 18),
            label: Text(actionLabel!),
            style: _actionButtonStyle(theme, isSmall),
          )
        : FilledButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              onAction!();
            },
            style: _actionButtonStyle(theme, isSmall),
            child: Text(actionLabel!),
          );
  }

  ButtonStyle _actionButtonStyle(ThemeData theme, bool isSmall) {
    return FilledButton.styleFrom(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? AppSpacing.base : AppSpacing.xl,
        vertical: isSmall ? 10 : AppSpacing.md,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
    );
  }
}

/// Ícono con animación de escala sutil (breathing effect)
class _AnimatedIcon extends StatelessWidget {
  const _AnimatedIcon({
    required this.icon,
    required this.size,
    required this.color,
    required this.animate,
  });

  final IconData icon;
  final double size;
  final Color color;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon, size: size, color: color);

    if (!animate) return iconWidget;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: iconWidget,
    );
  }
}
