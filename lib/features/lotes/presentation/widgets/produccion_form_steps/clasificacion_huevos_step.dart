import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/form_widgets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Step 2: Clasificación de Huevos
class ClasificacionHuevosStep extends StatelessWidget {
  const ClasificacionHuevosStep({
    super.key,
    required this.huevosRotosController,
    required this.huevosSuciosController,
    required this.huevosPequenosController,
    required this.huevosMedianosController,
    required this.huevosGrandesController,
    required this.huevosExtraGrandesController,
    required this.pesoPromedioController,
    required this.autoValidate,
    required this.huevosBuenos,
    required this.onClasificacionChanged,
  });

  final TextEditingController huevosRotosController;
  final TextEditingController huevosSuciosController;
  final TextEditingController huevosPequenosController;
  final TextEditingController huevosMedianosController;
  final TextEditingController huevosGrandesController;
  final TextEditingController huevosExtraGrandesController;
  final TextEditingController pesoPromedioController;
  final bool autoValidate;
  final int huevosBuenos;
  final VoidCallback onClasificacionChanged;

  int get _totalClasificados {
    final pequenos = int.tryParse(huevosPequenosController.text) ?? 0;
    final medianos = int.tryParse(huevosMedianosController.text) ?? 0;
    final grandes = int.tryParse(huevosGrandesController.text) ?? 0;
    final extraGrandes = int.tryParse(huevosExtraGrandesController.text) ?? 0;
    return pequenos + medianos + grandes + extraGrandes;
  }

  double get _pesoPromedioCalculado {
    final pequenos = int.tryParse(huevosPequenosController.text) ?? 0;
    final medianos = int.tryParse(huevosMedianosController.text) ?? 0;
    final grandes = int.tryParse(huevosGrandesController.text) ?? 0;
    final extraGrandes = int.tryParse(huevosExtraGrandesController.text) ?? 0;
    final total = _totalClasificados;

    if (total == 0) return 0;

    // Pesos promedio por categoría según rangos
    const pesoPequeno = 48.0; // (43+53)/2
    const pesoMediano = 58.0; // (53+63)/2
    const pesoGrande = 68.0; // (63+73)/2
    const pesoExtraGrande = 78.0; // >73g, asumimos 78g

    final pesoTotal =
        (pequenos * pesoPequeno) +
        (medianos * pesoMediano) +
        (grandes * pesoGrande) +
        (extraGrandes * pesoExtraGrande);

    return pesoTotal / total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            S.of(context).batchFormEggClassification,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            S.of(context).batchFormEggClassificationSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Sección: Huevos Defectuosos
          Text(
            S.of(context).batchFormDefectiveEggs,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          Row(
            children: [
              Expanded(
                child: RegistroFormField(
                  controller: huevosRotosController,
                  label: S.of(context).batchFormBroken,
                  hint: '0',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final val = int.tryParse(value);
                      if (val == null || val < 0) {
                        return S.of(context).batchFormInvalidValue;
                      }
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: RegistroFormField(
                  controller: huevosSuciosController,
                  label: S.of(context).batchFormDirty,
                  hint: '0',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final val = int.tryParse(value);
                      if (val == null || val < 0) {
                        return S.of(context).batchFormInvalidValue;
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          Divider(color: theme.colorScheme.outlineVariant),
          const SizedBox(height: AppSpacing.xl),

          // Sección: Clasificación por Tamaño
          Text(
            S.of(context).batchFormSizeClassification,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${S.of(context).batchFormTotalToClassify}: $huevosBuenos',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          // Pequeños
          RegistroFormField(
            controller: huevosPequenosController,
            label: S.of(context).batchFormSmallEggs,
            hint: '0',
            keyboardType: TextInputType.number,
            onChanged: (_) => onClasificacionChanged(),
          ),
          const SizedBox(height: AppSpacing.base),

          // Medianos
          RegistroFormField(
            controller: huevosMedianosController,
            label: S.of(context).batchFormMediumEggs,
            hint: '0',
            keyboardType: TextInputType.number,
            onChanged: (_) => onClasificacionChanged(),
          ),
          const SizedBox(height: AppSpacing.base),

          // Grandes
          RegistroFormField(
            controller: huevosGrandesController,
            label: S.of(context).batchFormLargeEggs,
            hint: '0',
            keyboardType: TextInputType.number,
            onChanged: (_) => onClasificacionChanged(),
          ),
          const SizedBox(height: AppSpacing.base),

          // Extra Grandes
          RegistroFormField(
            controller: huevosExtraGrandesController,
            label: S.of(context).batchFormExtraLargeEggs,
            hint: '0',
            keyboardType: TextInputType.number,
            onChanged: (_) => onClasificacionChanged(),
          ),

          // Mostrar resumen de clasificación si hay huevos clasificados
          if (_totalClasificados > 0) ...[
            const SizedBox(height: AppSpacing.xl),
            _buildResumenClasificacion(context, theme),
          ],

          const SizedBox(height: AppSpacing.xl),
          Divider(color: theme.colorScheme.outlineVariant),
          const SizedBox(height: AppSpacing.xl),

          // Peso promedio calculado automáticamente
          _buildPesoPromedioCard(context, theme),
        ],
      ),
    );
  }

  Widget _buildResumenClasificacion(BuildContext context, ThemeData theme) {
    final pequenos = int.tryParse(huevosPequenosController.text) ?? 0;
    final medianos = int.tryParse(huevosMedianosController.text) ?? 0;
    final grandes = int.tryParse(huevosGrandesController.text) ?? 0;
    final extraGrandes = int.tryParse(huevosExtraGrandesController.text) ?? 0;
    final total = _totalClasificados;
    final faltante = huevosBuenos - total;

    final color = faltante == 0 ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.allSm,
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                faltante == 0 ? Icons.check_circle : Icons.info_outline,
                color: color,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                S.of(context).batchFormClassificationSummary,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildMetricRow(
            theme,
            S.of(context).batchFormTotalClassified,
            '$total / $huevosBuenos',
            pequenos,
            medianos,
            grandes,
            extraGrandes,
          ),
          if (faltante != 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              faltante > 0
                  ? '${S.of(context).batchFormMissingEggs}: $faltante'
                  : '${S.of(context).batchFormExcessEggs}: ${-faltante}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricRow(
    ThemeData theme,
    String label,
    String value,
    int pequenos,
    int medianos,
    int grandes,
    int extraGrandes,
  ) {
    final total = _totalClasificados;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
              ),
            ),
          ],
        ),
        if (total > 0) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              if (pequenos > 0)
                Expanded(
                  flex: pequenos,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.7),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              if (medianos > 0)
                Expanded(
                  flex: medianos,
                  child: Container(
                    height: 8,
                    color: AppColors.success.withValues(alpha: 0.7),
                  ),
                ),
              if (grandes > 0)
                Expanded(
                  flex: grandes,
                  child: Container(
                    height: 8,
                    color: AppColors.warning.withValues(alpha: 0.7),
                  ),
                ),
              if (extraGrandes > 0)
                Expanded(
                  flex: extraGrandes,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.7),
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              if (pequenos > 0)
                _buildLegendItem(theme, 'S: $pequenos', AppColors.info),
              if (medianos > 0)
                _buildLegendItem(theme, 'M: $medianos', AppColors.success),
              if (grandes > 0)
                _buildLegendItem(theme, 'L: $grandes', AppColors.warning),
              if (extraGrandes > 0)
                _buildLegendItem(theme, 'XL: $extraGrandes', AppColors.primary),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildLegendItem(ThemeData theme, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPesoPromedioCard(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
          Row(
            children: [
              const Icon(Icons.scale_outlined, color: AppColors.info, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Text(
                S.of(context).batchFormCalculatedAvgWeight,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (_totalClasificados > 0) ...[
            Text(
              '${_pesoPromedioCalculado.toStringAsFixed(1)} gramos',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              '${S.of(context).batchFormAutoCalculatedWeight}: $_totalClasificados',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ] else ...[
            Text(
              S.of(context).batchFormClassifyForWeight,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
