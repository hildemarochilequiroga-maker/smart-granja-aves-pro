/// Widget de resumen de costos
library;

import 'package:flutter/material.dart';

import '../../../../../core/utils/formatters.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_animations.dart';
import '../../../../../core/theme/app_spacing.dart';

import '../../../domain/entities/costo_gasto.dart';

/// Widget que muestra un resumen de costos con total y estadísticas
class CostosResumenCard extends StatelessWidget {
  const CostosResumenCard({super.key, required this.costos, this.onVerDetalle});

  final List<CostoGasto> costos;
  final VoidCallback? onVerDetalle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 360;
    final l = S.of(context);

    final totalCostos = costos.fold<double>(0, (sum, c) => sum + c.monto);
    final costosPendientes = costos.where((c) => c.estaPendiente).length;
    final costosAprobados = costos.where((c) => c.aprobado).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: AppRadius.allLg,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
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
            l.costoSummaryTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimary.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isSmallScreen ? AppSpacing.sm : AppSpacing.md),

          // Monto total prominente
          Text(
            Formatters.currencyValue(totalCostos),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontSize: isSmallScreen ? 28 : 34,
              color: colorScheme.onPrimary,
              height: 1.1,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            l.costoSummaryTotal,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
          ),

          SizedBox(height: isSmallScreen ? AppSpacing.base : AppSpacing.lg),

          // Estadísticas en fila centradas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ResumenItem(
                label: l.costoSummaryApproved,
                value: costosAprobados.toString(),
                isSmallScreen: isSmallScreen,
              ),
              Container(
                width: 1,
                height: 32,
                color: colorScheme.onPrimary.withValues(alpha: 0.3),
              ),
              _ResumenItem(
                label: l.costoSummaryPending,
                value: costosPendientes.toString(),
                isSmallScreen: isSmallScreen,
              ),
              Container(
                width: 1,
                height: 32,
                color: colorScheme.onPrimary.withValues(alpha: 0.3),
              ),
              _ResumenItem(
                label: l.commonTotal,
                value: costos.length.toString(),
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
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: isSmallScreen ? 18 : 22,
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
        AppSpacing.gapXxxs,
        Text(
          label,
          style:
              (isSmallScreen
                      ? theme.textTheme.labelSmall
                      : theme.textTheme.bodySmall)
                  ?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
        ),
      ],
    );
  }
}
