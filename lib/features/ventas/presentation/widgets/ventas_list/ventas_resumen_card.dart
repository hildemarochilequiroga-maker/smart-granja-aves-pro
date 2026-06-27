/// Card de resumen de ventas
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_animations.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/app_stat_card.dart';
import '../../../domain/entities/venta_producto.dart';

/// Widget que muestra un resumen de ventas como grid 2x2 de KPIs,
/// con el mismo diseño de las pantallas de historial.
class VentasResumenCard extends StatelessWidget {
  const VentasResumenCard({super.key, required this.ventas});

  final List<VentaProducto> ventas;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    final totalVentas = ventas.fold<double>(0, (sum, v) => sum + v.totalFinal);
    final ventasActivas = ventas.where((v) => v.estado.esActiva).length;
    final ventasCompletadas = ventas.where((v) => v.estado.esCompletada).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppStatCard(
                  value: Formatters.currencyValue(totalVentas),
                  subtitle: l.ventaSummaryTotal,
                  color: AppColors.success,
                  isHighlight: true,
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: AppStatCard(
                  value: ventas.length.toString(),
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
                  value: ventasActivas.toString(),
                  subtitle: l.ventaSummaryActive,
                  color: AppColors.warning,
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: AppStatCard(
                  value: ventasCompletadas.toString(),
                  subtitle: l.ventaSummaryCompleted,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    ).summaryEntrance();
  }
}
