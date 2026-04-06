/// Card de resumen de ventas
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_animations.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../domain/entities/venta_producto.dart';

/// Widget que muestra un resumen de ventas con total y estadísticas
class VentasResumenCard extends StatelessWidget {
  const VentasResumenCard({super.key, required this.ventas});

  final List<VentaProducto> ventas;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 360;

    final totalVentas = ventas.fold<double>(0, (sum, v) => sum + v.totalFinal);
    final ventasActivas = ventas.where((v) => v.estado.esActiva).length;
    final ventasCompletadas = ventas.where((v) => v.estado.esCompletada).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      padding: EdgeInsets.all(isSmallScreen ? AppSpacing.base : AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.success,
            AppColors.success.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: AppRadius.allLg,
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header simple sin icono
          Text(
            l.ventaSummaryTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isSmallScreen ? AppSpacing.sm : AppSpacing.md),

          // Monto total prominente
          Text(
            Formatters.currencyValue(totalVentas),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontSize: isSmallScreen ? 28 : 34,
              color: AppColors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            l.ventaSummaryTotal,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),

          SizedBox(height: isSmallScreen ? AppSpacing.base : AppSpacing.lg),

          // Estadísticas en fila centradas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ResumenItem(
                label: l.ventaSummaryActive,
                value: ventasActivas.toString(),
                isSmallScreen: isSmallScreen,
              ),
              Container(
                width: 1,
                height: 32,
                color: AppColors.white.withValues(alpha: 0.3),
              ),
              _ResumenItem(
                label: l.ventaSummaryCompleted,
                value: ventasCompletadas.toString(),
                isSmallScreen: isSmallScreen,
              ),
              Container(
                width: 1,
                height: 32,
                color: AppColors.white.withValues(alpha: 0.3),
              ),
              _ResumenItem(
                label: l.commonTotal,
                value: ventas.length.toString(),
                isSmallScreen: isSmallScreen,
              ),
            ],
          ),
        ],
      ),
    ).summaryEntrance();
  }
}

class _ResumenItem extends StatelessWidget {
  const _ResumenItem({
    required this.label,
    required this.value,
    this.isSmallScreen = false,
  });

  final String label;
  final String value;
  final bool isSmallScreen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: isSmallScreen ? 18 : 22,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style:
              (isSmallScreen
                      ? theme.textTheme.labelSmall
                      : theme.textTheme.bodySmall)
                  ?.copyWith(color: AppColors.white.withValues(alpha: 0.8)),
        ),
      ],
    );
  }
}
