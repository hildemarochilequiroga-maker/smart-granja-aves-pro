library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/application.dart';

/// Widget que muestra las estadísticas resumidas de las granjas
class GranjaEstadisticasCard extends StatelessWidget {
  final GranjaStatsState stats;

  const GranjaEstadisticasCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    return Card(
      margin: const EdgeInsets.all(AppSpacing.base),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  l.commonSummary2,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.base),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icono: Icons.agriculture,
                    valor: '${stats.totalGranjas}',
                    etiqueta: l.commonTotal,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icono: Icons.check_circle,
                    valor: '${stats.granjasActivas}',
                    etiqueta: l.farmActiveFarmsLabel,
                    color: AppColors.success,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icono: Icons.pause_circle,
                    valor: '${stats.granjasInactivas}',
                    etiqueta: l.farmInactiveFarmsLabel,
                    color: theme.colorScheme.outline,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icono: Icons.build_circle,
                    valor: '${stats.granjasEnMantenimiento}',
                    etiqueta: l.commonMaintShort,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            if (stats.capacidadTotalAves > 0 || stats.areaTotalM2 > 0) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (stats.capacidadTotalAves > 0)
                    _InfoChip(
                      icono: Icons.pets,
                      texto:
                          '${_formatearNumero(stats.capacidadTotalAves)} ${l.farmBirds}',
                    ),
                  if (stats.areaTotalM2 > 0)
                    _InfoChip(
                      icono: Icons.square_foot,
                      texto:
                          '${_formatearNumero(stats.areaTotalM2.round())} m²',
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatearNumero(int numero) {
    if (numero >= 1000000) {
      return '${(numero / 1000000).toStringAsFixed(1)}M';
    } else if (numero >= 1000) {
      return '${(numero / 1000).toStringAsFixed(1)}K';
    }
    return numero.toString();
  }
}

class _StatItem extends StatelessWidget {
  final IconData icono;
  final String valor;
  final String etiqueta;
  final Color color;

  const _StatItem({
    required this.icono,
    required this.valor,
    required this.etiqueta,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icono, color: color, size: 28),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          valor,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          etiqueta,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _InfoChip({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Chip(
      avatar: Icon(icono, size: 18),
      label: Text(texto),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
    );
  }
}
