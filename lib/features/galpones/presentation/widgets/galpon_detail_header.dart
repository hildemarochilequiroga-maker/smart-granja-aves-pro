/// Header del detalle de galp�n.
///
/// Muestra estad�sticas principales y estado del galp�n
/// en un formato visual atractivo.
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

import '../../domain/entities/galpon.dart';

/// Header con estad�sticas del galp�n.
class GalponDetailHeader extends StatelessWidget {
  const GalponDetailHeader({super.key, required this.galpon});

  final Galpon galpon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ocupacion = galpon.porcentajeOcupacion;
    final ocupacionColor = ocupacion > 90
        ? AppColors.error
        : ocupacion > 70
        ? AppColors.warning
        : AppColors.success;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allSm,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Estad�sticas principales
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  theme: theme,
                  icon: Icons.groups,
                  label: S.of(context).shedCapacity,
                  value: '${galpon.capacidadMaxima}',
                  color: AppColors.info,
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: _buildStatCard(
                  theme: theme,
                  icon: Icons.pets,
                  label: S.of(context).shedCurrentBirds,
                  value: '${galpon.avesActuales}',
                  color: galpon.avesActuales > 0
                      ? AppColors.success
                      : theme.colorScheme.outline,
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: _buildStatCard(
                  theme: theme,
                  icon: Icons.pie_chart,
                  label: S.of(context).shedOccupationLabel,
                  value: '${ocupacion.toStringAsFixed(0)}%',
                  color: ocupacionColor,
                ),
              ),
            ],
          ),

          AppSpacing.gapBase,

          // Barra de progreso de ocupaci�n
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).shedOccupancyLevel,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    S
                        .of(context)
                        .shedBirdsOfCapacity(
                          galpon.avesActuales,
                          galpon.capacidadMaxima,
                        ),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapSm,
              ClipRRect(
                borderRadius: AppRadius.allSm,
                child: LinearProgressIndicator(
                  value: ocupacion / 100,
                  minHeight: 10,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(ocupacionColor),
                ),
              ),
            ],
          ),

          // Informaci�n adicional si hay lote asignado
          if (galpon.loteActualId != null) ...[
            AppSpacing.gapBase,
            const Divider(),
            AppSpacing.gapSm,
            Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: 20,
                  color: AppColors.success,
                ),
                AppSpacing.hGapSm,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).shedAssignedBatch,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      Text(
                        galpon.loteActualId!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.success,
                      ),
                      AppSpacing.hGapXxs,
                      Text(
                        S.of(context).commonAssigned,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],

          // �ltima desinfecci�n
          if (galpon.ultimaDesinfeccion != null) ...[
            AppSpacing.gapMd,
            Row(
              children: [
                const Icon(
                  Icons.cleaning_services,
                  size: 20,
                  color: AppColors.info,
                ),
                AppSpacing.hGapSm,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).shedLastDisinfection,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      Text(
                        _formatDate(galpon.ultimaDesinfeccion!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildDaysSinceChip(context, theme, galpon.ultimaDesinfeccion!),
              ],
            ),
          ],

          // Pr�ximo mantenimiento
          if (galpon.proximoMantenimiento != null) ...[
            AppSpacing.gapMd,
            Row(
              children: [
                const Icon(Icons.build, size: 20, color: AppColors.warning),
                AppSpacing.hGapSm,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).shedNextMaintenance,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      Text(
                        _formatDate(galpon.proximoMantenimiento!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildDaysUntilChip(
                  context,
                  theme,
                  galpon.proximoMantenimiento!,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.allSm,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          AppSpacing.gapSm,
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysSinceChip(
    BuildContext context,
    ThemeData theme,
    DateTime fecha,
  ) {
    final dias = DateTime.now().difference(fecha).inDays;
    final color = dias > 30
        ? AppColors.error
        : dias > 14
        ? AppColors.warning
        : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.allSm,
      ),
      child: Text(
        S.of(context).shedDaysAgoLabel(dias),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDaysUntilChip(
    BuildContext context,
    ThemeData theme,
    DateTime fecha,
  ) {
    final dias = fecha.difference(DateTime.now()).inDays;
    final color = dias < 0
        ? AppColors.error
        : dias < 7
        ? AppColors.warning
        : AppColors.info;

    final texto = dias < 0
        ? S.of(context).shedOverdueDaysAgo(-dias)
        : dias == 0
        ? S.of(context).shedToday
        : S.of(context).shedInDays(dias);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.allSm,
      ),
      child: Text(
        texto,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  String _formatDate(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }
}
