/// Step 2: Resumen y Observaciones
/// Muestra métricas calculadas y permite agregar observaciones
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/form_widgets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/enums/tipo_alimento.dart';
import 'package:smartgranjaavespro/core/theme/app_radius.dart';

/// Step 2: Resumen y Observaciones
class ResumenObservacionesStep extends StatelessWidget {
  const ResumenObservacionesStep({
    super.key,
    required this.formKey,
    required this.observacionesController,
    required this.autoValidate,
    required this.cantidadKg,
    required this.tipoAlimento,
    required this.fecha,
    required this.avesActuales,
    required this.costoPorKg,
    this.consumoAcumuladoKg,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController observacionesController;
  final bool autoValidate;
  final double cantidadKg;
  final TipoAlimento tipoAlimento;
  final DateTime fecha;
  final int avesActuales;
  final double? costoPorKg;
  final double? consumoAcumuladoKg;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calcular métricas
    final consumoPorAve = avesActuales > 0
        ? (cantidadKg * 1000) / avesActuales
        : 0.0;
    final costoTotal = costoPorKg != null ? cantidadKg * costoPorKg! : null;
    final costoPorAve = costoTotal != null && avesActuales > 0
        ? costoTotal / avesActuales
        : null;
    final consumoTotalAcumulado = (consumoAcumuladoKg ?? 0) + cantidadKg;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            S.of(context).consumoSummaryTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).consumoSummarySubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Card de métricas
          _MetricasCard(
            cantidadKg: cantidadKg,
            tipoAlimento: tipoAlimento,
            fecha: fecha,
            consumoPorAve: consumoPorAve,
            consumoTotalAcumulado: consumoTotalAcumulado,
            costoTotal: costoTotal,
            costoPorAve: costoPorAve,
          ),
          const SizedBox(height: 24),

          // Observaciones
          RegistroFormField(
            controller: observacionesController,
            label: S.of(context).consumoObservationsLabel,
            hint: S.of(context).consumoObsHint,
            maxLines: 4,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            validator: (value) => null,
          ),
          const SizedBox(height: 16),

          // Card informativa
          _buildInfoCard(context, theme),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: AppRadius.allSm,
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).commonImportantInfo,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            S.of(context).commonCostsAutoCalculated,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card con métricas del consumo
class _MetricasCard extends StatelessWidget {
  const _MetricasCard({
    required this.cantidadKg,
    required this.tipoAlimento,
    required this.fecha,
    required this.consumoPorAve,
    required this.consumoTotalAcumulado,
    this.costoTotal,
    this.costoPorAve,
  });

  final double cantidadKg;
  final TipoAlimento tipoAlimento;
  final DateTime fecha;
  final double consumoPorAve;
  final double consumoTotalAcumulado;
  final double? costoTotal;
  final double? costoPorAve;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.allMd,
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Datos del registro
          _MetricaRow(
            label: S.of(context).consumoQuantityLabel,
            value: '${cantidadKg.toStringAsFixed(2)} kg',
          ),
          const SizedBox(height: 12),
          _MetricaRow(
            label: S.of(context).consumoTypeLabel,
            value: tipoAlimento.localizedDisplayName(S.of(context)),
          ),
          const SizedBox(height: 12),
          _MetricaRow(
            label: S.of(context).consumoDateLabel,
            value: DateFormat('dd/MM/yyyy').format(fecha),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),

          // Métricas calculadas
          _MetricaRow(
            label: S.of(context).consumoPerBirdLabel,
            value: '${consumoPorAve.toStringAsFixed(1)} g',
          ),
          const SizedBox(height: 12),
          _MetricaRow(
            label: S.of(context).consumoAccumulatedLabel,
            value: '${consumoTotalAcumulado.toStringAsFixed(1)} kg',
          ),
          if (costoTotal != null) ...[
            const SizedBox(height: 12),
            _MetricaRow(
              label: S.of(context).consumoTotalCostLabel,
              value: '\$${costoTotal!.toStringAsFixed(2)}',
            ),
          ],
          if (costoPorAve != null) ...[
            const SizedBox(height: 12),
            _MetricaRow(
              label: S.of(context).consumoCostPerBirdLabel,
              value: '\$${costoPorAve!.toStringAsFixed(3)}',
            ),
          ],
        ],
      ),
    );
  }
}

/// Fila de métrica sin icono
class _MetricaRow extends StatelessWidget {
  const _MetricaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
