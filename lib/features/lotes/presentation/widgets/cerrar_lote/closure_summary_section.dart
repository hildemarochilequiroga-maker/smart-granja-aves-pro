/// Resumen de cierre de lote.
///
/// Widget que muestra el resumen completo antes de
/// confirmar el cierre del lote.
library;

// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/formatters.dart';

/// Widget de resumen antes de confirmar cierre
class ClosureSummarySection extends StatelessWidget {
  const ClosureSummarySection({
    super.key,
    required this.loteNombre,
    required this.fechaInicio,
    required this.fechaCierre,
    required this.avesIniciales,
    required this.avesFinales,
    required this.mortalidadTotal,
    required this.pesoFinal,
    required this.precioPorKg,
    required this.ingresoTotal,
    required this.gastoTotal,
    required this.rentabilidad,
    required this.observaciones,
    required this.onConfirm,
    required this.isLoading,
  });

  final String loteNombre;
  final DateTime fechaInicio;
  final DateTime fechaCierre;
  final int avesIniciales;
  final int avesFinales;
  final int mortalidadTotal;
  final double pesoFinal;
  final double precioPorKg;
  final double ingresoTotal;
  final double gastoTotal;
  final double rentabilidad;
  final String observaciones;
  final VoidCallback onConfirm;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = Formatters.fechaDDMMYYYY;
    final diasCiclo = fechaCierre.difference(fechaInicio).inDays;
    final porcentajeMortalidad = avesIniciales > 0
        ? (mortalidadTotal / avesIniciales * 100)
        : 0.0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.info, AppColors.info.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.allLg,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: colorScheme.onPrimary,
                  size: 48,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  S.of(context).batchCloseSummary,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  loteNombre,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Información del Ciclo
          _buildSectionCard(
            theme: theme,
            title: S.of(context).batchCloseCycleInfo,
            icon: Icons.calendar_month,
            children: [
              _buildInfoRow(
                theme,
                S.of(context).batchCloseStartDate,
                dateFormat.format(fechaInicio),
              ),
              _buildInfoRow(
                theme,
                S.of(context).batchCloseEndDate,
                dateFormat.format(fechaCierre),
              ),
              _buildInfoRow(
                theme,
                S.of(context).batchCloseDuration,
                '$diasCiclo ${S.of(context).batchCloseDays}',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),

          // Población
          _buildSectionCard(
            theme: theme,
            title: S.of(context).batchClosePopulation,
            icon: Icons.pest_control_rodent,
            children: [
              _buildInfoRow(
                theme,
                S.of(context).batchCloseInitialBirds,
                avesIniciales.toString(),
              ),
              _buildInfoRow(
                theme,
                S.of(context).batchCloseFinalBirds,
                avesFinales.toString(),
              ),
              _buildInfoRow(
                theme,
                S.of(context).batchCloseMortality,
                '$mortalidadTotal (${porcentajeMortalidad.toStringAsFixed(1)}%)',
                valueColor: porcentajeMortalidad > 5
                    ? AppColors.error
                    : AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),

          // Venta
          _buildSectionCard(
            theme: theme,
            title: S.of(context).batchCloseSaleInfo,
            icon: Icons.sell,
            children: [
              _buildInfoRow(
                theme,
                S.of(context).batchCloseFinalWeight,
                '${pesoFinal.toStringAsFixed(2)} kg',
              ),
              _buildInfoRow(
                theme,
                S.of(context).batchClosePricePerKg,
                '\$${precioPorKg.toStringAsFixed(2)}',
              ),
              _buildInfoRow(
                theme,
                S.of(context).batchCloseTotalIncome,
                '\$${ingresoTotal.toStringAsFixed(2)}',
                valueColor: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),

          // Finanzas
          _buildSectionCard(
            theme: theme,
            title: S.of(context).batchCloseFinancialBalance,
            icon: Icons.account_balance_wallet,
            children: [
              _buildInfoRow(
                theme,
                S.of(context).batchCloseTotalIncome,
                '\$${ingresoTotal.toStringAsFixed(2)}',
              ),
              _buildInfoRow(
                theme,
                S.of(context).batchCloseTotalExpenses,
                '\$${gastoTotal.toStringAsFixed(2)}',
              ),
              const Divider(height: 16),
              _buildInfoRow(
                theme,
                S.of(context).batchCloseProfitability,
                '\$${rentabilidad.toStringAsFixed(2)}',
                valueColor: rentabilidad >= 0
                    ? AppColors.success
                    : AppColors.error,
                isBold: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),

          // Observaciones (si hay)
          if (observaciones.isNotEmpty) ...[
            _buildSectionCard(
              theme: theme,
              title: S.of(context).batchFormObservations,
              icon: Icons.notes,
              children: [
                Text(
                  observaciones,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Botón de confirmación
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isLoading ? null : onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
                elevation: 2,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: colorScheme.onPrimary,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_outline, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          S.of(context).batchCloseConfirm,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.base),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadius.allMd,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.info),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: valueColor ?? colorScheme.onSurface,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
