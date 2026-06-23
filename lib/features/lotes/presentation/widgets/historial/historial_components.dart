/// Componentes compartidos de las páginas de historial (mortalidad, consumo,
/// peso, producción).
///
/// Unifican la estructura y el estilo de las cards/secciones que antes estaban
/// copiadas en cada página de historial.
library;

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../l10n/app_localizations.dart';

/// Card de estadística (KPI) del historial: valor destacado + subtítulo.
class HistorialStatCard extends StatelessWidget {
  const HistorialStatCard({
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

/// Skeleton de carga de la sección de estadísticas (grid 2x2).
class HistorialStatsLoading extends StatelessWidget {
  const HistorialStatsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget box() => Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
          borderRadius: AppRadius.allMd,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          Row(
            children: [box(), const SizedBox(width: AppSpacing.md), box()],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [box(), const SizedBox(width: AppSpacing.md), box()],
          ),
        ],
      ),
    );
  }
}

/// Card-botón "Ver gráficos".
class HistorialGraficosCard extends StatelessWidget {
  const HistorialGraficosCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.info,
          borderRadius: AppRadius.allMd,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 24),
            const SizedBox(width: AppSpacing.sm),
            Text(
              S.of(context).batchViewCharts,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip de filtro activo: etiqueta centrada + botón de limpiar a la derecha.
class HistorialFiltrosActivosChip extends StatelessWidget {
  const HistorialFiltrosActivosChip({
    super.key,
    required this.label,
    required this.onClear,
  });

  final String label;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurfaceVariant,
          borderRadius: AppRadius.allMd,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onClear,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Encabezado de la lista de registros: título + toggle de orden (recientes /
/// antiguos).
class HistorialRegistrosHeader extends StatelessWidget {
  const HistorialRegistrosHeader({
    super.key,
    required this.title,
    required this.ordenDesc,
    required this.onToggleOrden,
  });

  final String title;
  final bool ordenDesc;
  final VoidCallback onToggleOrden;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onToggleOrden,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: Text(
                ordenDesc
                    ? S.of(context).batchRecent
                    : S.of(context).batchOldest,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
