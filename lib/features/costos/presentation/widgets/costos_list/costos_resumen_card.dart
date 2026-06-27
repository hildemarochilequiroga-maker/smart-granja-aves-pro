/// Widget de resumen de costos
library;

import 'package:flutter/material.dart';

import '../../../../../core/utils/formatters.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_animations.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_stat_card.dart';

import '../../../domain/entities/costo_gasto.dart';

/// Widget que muestra un resumen de costos como grid 2x2 de KPIs,
/// con el mismo diseño de las pantallas de historial.
class CostosResumenCard extends StatelessWidget {
  const CostosResumenCard({super.key, required this.costos, this.onVerDetalle});

  final List<CostoGasto> costos;
  final VoidCallback? onVerDetalle;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    final totalCostos = costos.fold<double>(0, (sum, c) => sum + c.monto);
    final costosPendientes = costos.where((c) => c.estaPendiente).length;
    final costosAprobados = costos.where((c) => c.aprobado).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppStatCard(
                  value: Formatters.currencyValue(totalCostos),
                  subtitle: l.costoSummaryTotal,
                  color: AppColors.primary,
                  isHighlight: true,
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: AppStatCard(
                  value: costos.length.toString(),
                  subtitle: l.commonTotal,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          AppSpacing.gapMd,
          Row(
            children: [
              Expanded(
                child: AppStatCard(
                  value: costosAprobados.toString(),
                  subtitle: l.costoSummaryApproved,
                  color: AppColors.success,
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: AppStatCard(
                  value: costosPendientes.toString(),
                  subtitle: l.costoSummaryPending,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    ).summaryEntrance();
  }
}
