/// Card de KPIs del lote.
///
/// Widget modular que muestra los indicadores clave
/// de rendimiento del lote (aves, edad, mortalidad, peso).
library;

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/lote.dart';

/// Card que muestra los KPIs principales del lote
class KPIsCard extends StatelessWidget {
  const KPIsCard({super.key, required this.lote});

  final Lote lote;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).batchIndicators,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.base),
            Row(
              children: [
                Expanded(
                  child: KPIItem(
                    icono: Icons.pets,
                    titulo: S.of(context).batchBirds,
                    valor: '${lote.avesActuales}',
                    subtitulo: S
                        .of(context)
                        .batchOfAmount(lote.cantidadInicial),
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: KPIItem(
                    icono: Icons.calendar_today,
                    titulo: S.of(context).batchAge,
                    valor: '${lote.edadActualSemanas}',
                    subtitulo: S.of(context).batchWeeks,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: KPIItem(
                    icono: Icons.trending_down,
                    titulo: S.of(context).batchMortality,
                    valor: '${lote.porcentajeMortalidad.toStringAsFixed(1)}%',
                    subtitulo: S
                        .of(context)
                        .batchOfBirds(lote.mortalidadAcumulada),
                    color: lote.mortalidadDentroLimites
                        ? AppColors.warning
                        : AppColors.error,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: KPIItem(
                    icono: Icons.scale,
                    titulo: S.of(context).batchCurrentWeight,
                    valor: lote.pesoPromedioActual != null
                        ? '${lote.pesoPromedioActual!.toStringAsFixed(2)} kg'
                        : 'N/A',
                    subtitulo: S.of(context).batchAverage,
                    color: AppColors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Item individual de KPI
class KPIItem extends StatelessWidget {
  const KPIItem({
    super.key,
    required this.icono,
    required this.titulo,
    required this.valor,
    required this.subtitulo,
    required this.color,
  });

  final IconData icono;
  final String titulo;
  final String valor;
  final String subtitulo;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.allMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, size: 16, color: color),
              const SizedBox(width: AppSpacing.xxs),
              Expanded(
                child: Text(
                  titulo,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            valor,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitulo,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
