/// Componentes compartidos de las páginas de historial (mortalidad, consumo,
/// peso, producción).
///
/// Unifican la estructura y el estilo de las cards/secciones que antes estaban
/// copiadas en cada página de historial.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_section_header.dart';
import '../../../../../core/widgets/app_stat_card.dart';
import '../../../../../l10n/app_localizations.dart';

/// Card de estadística (KPI) del historial: valor destacado + subtítulo.
///
/// Alias delgado sobre [AppStatCard] (en `core`), conservado para no romper
/// los usos existentes en las páginas de historial.
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
    return AppStatCard(
      value: value,
      subtitle: subtitle,
      color: color,
      isHighlight: isHighlight,
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
            children: [
              box(),
              const SizedBox(width: AppSpacing.md),
              box(),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              box(),
              const SizedBox(width: AppSpacing.md),
              box(),
            ],
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

/// Sección de KPIs del historial: grid 2x2 de [HistorialStatCard] seguido del
/// botón "Ver gráficos".
///
/// Unifica la estructura (padding, filas y separaciones) que estaba duplicada en
/// cada página de historial. Solo se pasan las 4 [cards] y el callback del botón.
class HistorialStatsGrid extends StatelessWidget {
  const HistorialStatsGrid({
    super.key,
    required this.cards,
    required this.onVerGraficos,
  }) : assert(cards.length == 4, 'Se esperan exactamente 4 KPIs (grid 2x2)');

  /// Las 4 cards de KPI, en orden de lectura (fila superior, luego inferior).
  final List<HistorialStatCard> cards;

  /// Acción del botón "Ver gráficos".
  final VoidCallback onVerGraficos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grid de estadísticas 2x2
          Row(
            children: [
              Expanded(child: cards[0]),
              AppSpacing.hGapMd,
              Expanded(child: cards[1]),
            ],
          ),
          AppSpacing.gapMd,
          Row(
            children: [
              Expanded(child: cards[2]),
              AppSpacing.hGapMd,
              Expanded(child: cards[3]),
            ],
          ),
          AppSpacing.gapMd,
          // Botón "Ver gráficos" debajo de los KPIs
          HistorialGraficosCard(onTap: onVerGraficos),
        ],
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

/// Opción de período/filtro en el bottom sheet de filtros del historial.
class HistorialPeriodOption extends StatelessWidget {
  const HistorialPeriodOption({
    super.key,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.info.withValues(alpha: 0.1)
              : theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
          borderRadius: AppRadius.allMd,
          border: Border.all(
            color: isSelected
                ? AppColors.info.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? AppColors.info
                    : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Estado vacío del historial (animado), con título y subtítulo según haya o
/// no datos.
class HistorialEmptyState extends StatelessWidget {
  const HistorialEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(scale: 0.9 + (0.1 * value), child: child),
        );
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Estado de error del historial con botón de reintentar.
class HistorialErrorState extends StatelessWidget {
  const HistorialErrorState({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.base),
            Text(
              S.of(context).batchErrorLoadingRecords,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              error,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton.primary(
              label: S.of(context).commonRetry,
              icon: Icons.refresh,
              onPressed: onRetry,
              backgroundColor: AppColors.info,
              foregroundColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet de filtros estándar de las páginas de historial.
///
/// Unifica el contenedor (handle, header "Filtrar registros", divider, contenido
/// scrolleable y botón "Aplicar/Cerrar") que antes estaba copiado en cada página.
/// Cada página solo aporta sus secciones de filtro vía [sectionsBuilder], que
/// recibe el [StateSetter] del modal para refrescarlo al cambiar una selección.
class HistorialFiltrosBottomSheet {
  const HistorialFiltrosBottomSheet._();

  /// Muestra el bottom sheet de filtros.
  ///
  /// - [hasActiveFilters]: se evalúa en cada rebuild para decidir la etiqueta
  ///   del botón (Aplicar filtros vs. Cerrar).
  /// - [sectionsBuilder]: construye las secciones de filtro; recibe el
  ///   [setModalState] para refrescar el sheet tras un cambio de selección.
  static Future<void> show({
    required BuildContext context,
    required bool Function() hasActiveFilters,
    required List<Widget> Function(StateSetter setModalState) sectionsBuilder,
  }) {
    HapticFeedback.selectionClick();
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return AppBottomSheetScaffold(
            title: S.of(context).batchFilterRecords,
            scrollable: true,
            child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Contenido scrolleable
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: sectionsBuilder(setModalState),
                        ),
                      ),
                    ),

                    // Botón aplicar / cerrar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                      child: AppButton.primary(
                        label: hasActiveFilters()
                            ? S.of(context).commonApplyFilters
                            : S.of(context).commonClose,
                        onPressed: () => Navigator.pop(context),
                        expanded: true,
                        backgroundColor: hasActiveFilters()
                            ? AppColors.warning
                            : AppColors.error,
                        foregroundColor: AppColors.white,
                      ),
                    ),
                  ],
                ),
          );
        },
      ),
    );
  }
}

/// Sección "Período" (Todo / 7 días / 30 días) del bottom sheet de filtros.
///
/// [selected] es el valor actual (`'todos'`, `'7d'`, `'30d'`) y [onSelect] se
/// invoca con el nuevo valor al tocar una opción.
class HistorialPeriodoFilterSection extends StatelessWidget {
  const HistorialPeriodoFilterSection({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(title: s.batchTimePeriod, padding: EdgeInsets.zero),
        AppSpacing.gapMd,
        Row(
          children: [
            Expanded(
              child: HistorialPeriodOption(
                label: s.batchAllTime,
                subtitle: s.batchNoTimeLimit,
                isSelected: selected == 'todos',
                onTap: () => onSelect('todos'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: HistorialPeriodOption(
                label: s.batchDays7,
                subtitle: s.batchLastWeek,
                isSelected: selected == '7d',
                onTap: () => onSelect('7d'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: HistorialPeriodOption(
                label: s.batchDays30,
                subtitle: s.batchLastMonth,
                isSelected: selected == '30d',
                onTap: () => onSelect('30d'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Opción de filtro categórico del bottom sheet (causa de mortalidad, tipo de
/// alimento, método de pesaje, rango de postura…): punto de color + etiqueta y
/// [subtitle] opcional. La selección se resalta con [AppColors.info], igual en
/// los 4 historiales.
class HistorialFiltroOption extends StatelessWidget {
  const HistorialFiltroOption({
    super.key,
    required this.label,
    this.subtitle,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String? subtitle;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.info.withValues(alpha: 0.12)
              : theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
          borderRadius: AppRadius.allMd,
          border: Border.all(
            color: isSelected
                ? AppColors.info.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.info
                          : theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shell (contenedor) de una card de registro del historial: borde de color
/// de acento, sombra suave y InkWell. El contenido específico de cada tipo se
/// pasa como [child].
class HistorialRegistroCardShell extends StatelessWidget {
  const HistorialRegistroCardShell({
    super.key,
    required this.accentColor,
    required this.onTap,
    required this.child,
    this.borderWidth = 1.5,
  });

  final Color accentColor;
  final VoidCallback onTap;
  final Widget child;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allMd,
        border: Border.all(color: accentColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.allMd,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.allMd,
          splashColor: accentColor.withValues(alpha: 0.1),
          highlightColor: accentColor.withValues(alpha: 0.05),
          child: Padding(padding: const EdgeInsets.all(14), child: child),
        ),
      ),
    );
  }
}
