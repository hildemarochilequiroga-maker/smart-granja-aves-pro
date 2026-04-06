import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../application/providers/actividades_recientes_provider.dart';
import '../../../../granjas/application/providers/granja_providers.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Widget que muestra la línea de tiempo de actividades recientes.
///
/// Incluye TODAS las actividades de la granja:
/// - Producción de huevos
/// - Mortalidad
/// - Consumo de alimento
/// - Pesajes
/// - Movimientos de inventario
/// - Ventas
/// - Costos/Gastos
/// - Registros de salud
/// - Vacunaciones
/// - Creación de lotes
/// - Eventos de galpones
class HomeActivities extends ConsumerWidget {
  const HomeActivities({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final granjaSeleccionada = ref.watch(granjaSeleccionadaProvider);

    if (granjaSeleccionada == null) {
      return const SizedBox.shrink();
    }

    final granjaId = granjaSeleccionada.id;
    final actividadesAsync = ref.watch(
      actividadesRecientesSimpleProvider(granjaId),
    );

    return actividadesAsync.when(
      loading: () => _buildLoadingState(context),
      error: (error, stack) => _buildErrorState(context, error),
      data: (actividades) {
        if (actividades.isEmpty) {
          return _buildEmptyState(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  S.of(context).homeRecentActivity,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  S.of(context).homeLast7Days,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...actividades.asMap().entries.map((entry) {
              final index = entry.key;
              final actividad = entry.value;
              final isLast = index == actividades.length - 1;
              return _buildActivityItem(context, actividad, isLast);
            }),
          ],
        );
      },
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    ActividadReciente actividad,
    bool isLast,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline con icono
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: actividad.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: actividad.color.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Icon(actividad.icono, size: 18, color: actividad.color),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      actividad.color.withValues(alpha: 0.4),
                      Theme.of(context).colorScheme.outlineVariant,
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        // Contenido
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        actividad.titulo,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _buildBadge(actividad),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  actividad.subtitulo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  [
                    _formatFecha(context, actividad.fecha),
                    if (actividad.loteCodigo != null) actividad.loteCodigo!,
                  ].join(' • '),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(ActividadReciente actividad) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: actividad.color.withValues(alpha: 0.1),
        borderRadius: AppRadius.allXs,
        border: Border.all(
          color: actividad.color.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Text(
        actividad.etiqueta,
        style: TextStyle(
          fontSize: 9,
          color: actividad.color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  String _formatFecha(BuildContext context, DateTime fecha) {
    final now = DateTime.now();
    final diff = now.difference(fecha);

    if (diff.inMinutes < 1) {
      return S.of(context).homeRightNow;
    } else if (diff.inMinutes < 60) {
      return S.of(context).homeAgoMinutes(diff.inMinutes);
    } else if (diff.inHours < 24) {
      final horas = diff.inHours;
      return horas == 1
          ? S.of(context).homeAgoHoursOne(horas)
          : S.of(context).homeAgoHoursOther(horas);
    } else if (diff.inDays == 1) {
      return S.of(context).homeYesterdayAt(Formatters.hora24.format(fecha));
    } else if (diff.inDays < 7) {
      return S.of(context).homeAgoDays(diff.inDays);
    } else {
      return Formatters.fechaDDMMYYYYHHmm.format(fecha);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).homeRecentActivity,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.base),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: AppRadius.allMd,
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.history,
                  size: 36,
                  color: colorScheme.outline,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                S.of(context).homeNoRecentActivity,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                S.of(context).homeNoRecentActivityDesc,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).homeRecentActivity,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.base),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.errorContainer,
            borderRadius: AppRadius.allMd,
            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 32, color: AppColors.error),
              const SizedBox(height: AppSpacing.sm),
              Text(
                S.of(context).homeErrorLoadingActivities,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                S.of(context).homeTryReloadPage,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.error.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).homeRecentActivity,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.md),
        for (int i = 0; i < 4; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 14,
                        decoration: BoxDecoration(
                          color: colorScheme.outlineVariant,
                          borderRadius: AppRadius.allXs,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Container(
                        width: 100,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colorScheme.outlineVariant,
                          borderRadius: AppRadius.allXs,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Container(
                        width: 60,
                        height: 8,
                        decoration: BoxDecoration(
                          color: colorScheme.outlineVariant,
                          borderRadius: AppRadius.allXs,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
