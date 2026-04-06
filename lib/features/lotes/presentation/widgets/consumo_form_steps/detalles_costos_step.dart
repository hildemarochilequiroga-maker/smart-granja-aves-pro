/// Step 2: Detalles y Costos
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/form_widgets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Step 2: Detalles y Costos
class DetallesCostosStep extends StatelessWidget {
  const DetallesCostosStep({
    super.key,
    required this.formKey,
    required this.loteAlimentoController,
    required this.costoPorKgController,
    required this.onCostoPorKgChanged,
    required this.autoValidate,
    this.cantidadKg,
    this.cantidadAves,
    this.consumoAcumuladoAnterior,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController loteAlimentoController;
  final TextEditingController costoPorKgController;
  final VoidCallback onCostoPorKgChanged;
  final bool autoValidate;
  final double? cantidadKg;
  final int? cantidadAves;
  final double? consumoAcumuladoAnterior;

  double get _consumoPorAve {
    if ((cantidadKg ?? 0) > 0 && (cantidadAves ?? 0) > 0) {
      final result = (cantidadKg ?? 0) / (cantidadAves ?? 1);
      if (result.isFinite) return result;
    }
    return 0;
  }

  double get _consumoTotalAcumulado =>
      (consumoAcumuladoAnterior ?? 0) + (cantidadKg ?? 0);

  double? get _costoTotal {
    final costo = double.tryParse(costoPorKgController.text.trim());
    if (costo != null && costo.isFinite && (cantidadKg ?? 0) > 0) {
      final result = costo * (cantidadKg ?? 0);
      if (result.isFinite) return result;
    }
    return null;
  }

  double? get _costoPorAve {
    if (_costoTotal != null && (cantidadAves ?? 0) > 0) {
      final result = _costoTotal! / (cantidadAves ?? 1);
      if (result.isFinite) return result;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showMetrics = (cantidadKg ?? 0) > 0 && (cantidadAves ?? 0) > 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            S.of(context).batchFormDetailsCosts,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            S.of(context).batchFormDetailsCostsSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Lote de alimento
          RegistroFormField(
            controller: loteAlimentoController,
            label: S.of(context).batchFormFoodBatch,
            hint: S.of(context).commonHintExample('LOTE-2024-001'),
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            validator: (value) => null,
          ),
          const SizedBox(height: AppSpacing.base),

          // Costo por kg
          RegistroFormField(
            controller: costoPorKgController,
            label: S.of(context).batchFormCostPerKg,
            hint: S.of(context).batchFormCostHint,
            suffixText: '\$/kg',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => onCostoPorKgChanged(),
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            validator: (value) {
              if (value != null &&
                  value.isNotEmpty &&
                  double.tryParse(value) == null) {
                return S.of(context).batchInvalidNumber;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xl),

          // Métricas calculadas
          if (showMetrics)
            _MetricasCard(
              theme: theme,
              consumoPorAve: _consumoPorAve,
              consumoTotalAcumulado: _consumoTotalAcumulado,
              costoTotal: _costoTotal,
              costoPorAve: _costoPorAve,
            )
          else
            FormInfoRow(
              text: S.of(context).batchFormCompleteAmountToSeeMetrics,
              type: InfoCardType.info,
            ),
        ],
      ),
    );
  }
}

/// Card de métricas calculadas
class _MetricasCard extends StatelessWidget {
  const _MetricasCard({
    required this.theme,
    required this.consumoPorAve,
    required this.consumoTotalAcumulado,
    this.costoTotal,
    this.costoPorAve,
  });

  final ThemeData theme;
  final double consumoPorAve;
  final double consumoTotalAcumulado;
  final double? costoTotal;
  final double? costoPorAve;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: AppRadius.allSm,
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).batchFormCalculatedMetrics,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          _MetricRow(
            label: S.of(context).batchPerBird,
            value:
                '${consumoPorAve.toStringAsFixed(3)} kg/${S.of(context).batchBirdLabel}',
            theme: theme,
          ),
          const SizedBox(height: AppSpacing.md),
          _MetricRow(
            label: S.of(context).batchTotalAccumulated,
            value: '${consumoTotalAcumulado.toStringAsFixed(2)} kg',
            theme: theme,
          ),
          if (costoTotal != null) ...[
            const SizedBox(height: AppSpacing.md),
            _MetricRow(
              label: S.of(context).batchFormCostThisRecord,
              value: '\$${costoTotal!.toStringAsFixed(2)}',
              theme: theme,
            ),
          ],
          if (costoPorAve != null) ...[
            const SizedBox(height: AppSpacing.md),
            _MetricRow(
              label: S.of(context).batchFormCostPerBird,
              value:
                  '\$${costoPorAve!.toStringAsFixed(2)}/${S.of(context).batchBirdLabel}',
              theme: theme,
            ),
          ],
        ],
      ),
    );
  }
}

/// Fila de métrica individual
class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    required this.theme,
  });

  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }
}
