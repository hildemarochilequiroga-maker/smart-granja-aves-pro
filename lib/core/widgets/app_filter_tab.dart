/// Tab de filtro unificado para barras de búsqueda
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../errors/error_messages.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Tab de filtro reutilizable que reemplaza las 4 copias de `_FilterTab`
/// distribuidas en lotes, granjas, galpones y salud.
///
/// Se muestra como texto con indicador de subrayado animado.
///
/// ```dart
/// AppFilterTab(
///   label: 'Activo',
///   isSelected: estado == EstadoLote.activo,
///   color: AppColors.success,
///   onTap: () => onEstadoChanged(EstadoLote.activo),
/// )
/// ```
class AppFilterTab extends StatelessWidget {
  const AppFilterTab({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  /// Texto de la pestaña
  final String label;

  /// Si la pestaña está seleccionada
  final bool isSelected;

  /// Callback al pulsar
  final VoidCallback onTap;

  /// Color del indicador y texto activo (por defecto: primary)
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = color ?? theme.colorScheme.primary;

    return Semantics(
      button: true,
      selected: isSelected,
      label: ErrorMessages.format('A11Y_FILTER_BY', {'label': label}),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          borderRadius: AppRadius.allSm,
          splashColor: activeColor.withValues(alpha: 0.1),
          highlightColor: activeColor.withValues(alpha: 0.05),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxs,
              vertical: AppSpacing.xxxs,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xxs,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? activeColor
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 2,
                  width: isSelected ? 40 : 0,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fila horizontal de filtros con scroll, para usar dentro de [AppSearchBar].
///
/// ```dart
/// AppFilterTabRow(
///   tabs: [
///     AppFilterTab(label: 'Todos', isSelected: filter == null, onTap: () => ...),
///     AppFilterTab(label: 'Activo', isSelected: ..., color: AppColors.success, onTap: () => ...),
///   ],
/// )
/// ```
class AppFilterTabRow extends StatelessWidget {
  const AppFilterTabRow({super.key, required this.tabs, this.height = 48});

  /// Lista de AppFilterTab widgets
  final List<Widget> tabs;

  /// Altura de la fila (por defecto: 48)
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
        child: Row(children: _buildTabsWithSpacing()),
      ),
    );
  }

  List<Widget> _buildTabsWithSpacing() {
    if (tabs.isEmpty) return tabs;
    final result = <Widget>[];
    for (var i = 0; i < tabs.length; i++) {
      result.add(tabs[i]);
      if (i < tabs.length - 1) {
        result.add(const SizedBox(width: AppSpacing.md));
      }
    }
    return result;
  }
}
