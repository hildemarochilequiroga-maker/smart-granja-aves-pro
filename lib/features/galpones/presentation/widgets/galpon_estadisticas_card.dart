/// Card de estadísticas de galpones.
///
/// Muestra estadísticas generales de los galpones
/// en la granja, como totales, por estado, ocupación, etc.
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

import '../../domain/enums/estado_galpon.dart';

/// Card de estadísticas de galpones.
class GalponEstadisticasCard extends StatelessWidget {
  const GalponEstadisticasCard({super.key, required this.estadisticas});

  final Map<String, dynamic> estadisticas;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l = S.of(context);
    final totalGalpones = estadisticas['totalGalpones'] as int? ?? 0;
    final porEstado = estadisticas['porEstado'] as Map<String, int>? ?? {};
    final capacidadTotal = estadisticas['capacidadTotal'] as int? ?? 0;
    final avesTotales = estadisticas['avesTotales'] as int? ?? 0;
    final ocupacionPromedio =
        estadisticas['ocupacionPromedio'] as double? ?? 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
        ),
        borderRadius: AppRadius.allLg,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Row(
            children: [
              Icon(Icons.analytics, color: cs.onPrimary),
              AppSpacing.hGapSm,
              Text(
                l.shedGeneralStats,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: cs.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          AppSpacing.gapBase,

          // Estadísticas principales
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  theme: theme,
                  icon: Icons.home_work,
                  label: l.shedSheds,
                  value: totalGalpones.toString(),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  theme: theme,
                  icon: Icons.groups,
                  label: l.shedCapacity,
                  value: _formatNumber(capacidadTotal),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  theme: theme,
                  icon: Icons.pets,
                  label: l.shedBirds,
                  value: _formatNumber(avesTotales),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  theme: theme,
                  icon: Icons.pie_chart,
                  label: l.shedOccupationLabel,
                  value: '${ocupacionPromedio.toStringAsFixed(0)}%',
                ),
              ),
            ],
          ),

          if (porEstado.isNotEmpty) ...[
            AppSpacing.gapBase,
            Divider(color: cs.onPrimary.withValues(alpha: 0.24)),
            AppSpacing.gapMd,

            // Por estado
            Text(
              l.shedByStatus,
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onPrimary.withValues(alpha: 0.7),
              ),
            ),
            AppSpacing.gapSm,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: porEstado.entries.map((entry) {
                final estado = EstadoGalpon.values.firstWhere(
                  (e) => e.name == entry.key,
                  orElse: () => EstadoGalpon.activo,
                );
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: cs.onPrimary.withValues(alpha: 0.2),
                    borderRadius: AppRadius.allXl,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(estado.icon, size: 14, color: cs.onPrimary),
                      AppSpacing.hGapXxs,
                      Text(
                        '${estado.localizedDisplayName(S.of(context))}: ${entry.value}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
          size: 20,
        ),
        AppSpacing.gapXxs,
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

/// Card compacta de estadísticas para AppBar.
class GalponEstadisticasCompact extends StatelessWidget {
  const GalponEstadisticasCompact({
    super.key,
    required this.totalGalpones,
    required this.disponibles,
  });

  final int totalGalpones;
  final int disponibles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cs.onPrimary.withValues(alpha: 0.2),
        borderRadius: AppRadius.allXl,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.home_work, size: 16, color: cs.onPrimary),
          AppSpacing.hGapXs,
          Text(
            S.of(context).galponTotalCount('$totalGalpones'),
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (disponibles > 0) ...[
            AppSpacing.hGapSm,
            Container(
              width: 1,
              height: 12,
              color: cs.onPrimary.withValues(alpha: 0.38),
            ),
            AppSpacing.hGapSm,
            Text(
              '$disponibles disp.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onPrimary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
