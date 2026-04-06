/// Step 2: Detalles del Tratamiento
/// Diseño consistente con los steps de granjas
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../inventario/domain/entities/entities.dart';
import '../../../../inventario/domain/enums/enums.dart';
import '../../../../inventario/presentation/widgets/widgets.dart';
import '../common/salud_form_field.dart';

/// Step de detalles del tratamiento - segundo paso del formulario
class TratamientoDetallesStep extends StatelessWidget {
  const TratamientoDetallesStep({
    super.key,
    required this.tratamientoController,
    required this.medicamentosController,
    required this.dosisController,
    required this.duracionController,
    required this.autoValidate,
    this.granjaId,
    this.itemInventarioSeleccionado,
    this.onItemInventarioChanged,
  });

  final TextEditingController tratamientoController;
  final TextEditingController medicamentosController;
  final TextEditingController dosisController;
  final TextEditingController duracionController;
  final bool autoValidate;
  final String? granjaId;
  final ItemInventario? itemInventarioSeleccionado;
  final ValueChanged<ItemInventario?>? onItemInventarioChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            l.treatStepDetailsTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.treatStepDetailsDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.gapXl,

          // Card de información importante
          _buildInfoCard(theme, l),
          AppSpacing.gapXl,

          // Tratamiento
          SaludFormField(
            controller: tratamientoController,
            label: l.treatStepTreatmentDesc,
            hint: l.treatStepTreatmentHint,
            required: true,
            maxLines: 3,
            maxLength: 300,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l.treatStepTreatmentRequired;
              }
              if (value.trim().length < 5) {
                return l.treatStepTreatmentMinLength;
              }
              return null;
            },
          ),
          AppSpacing.gapBase,

          // Selector de medicamento del inventario (opcional)
          if (granjaId != null && onItemInventarioChanged != null) ...[
            _buildInventarioSelector(context, theme, l),
            AppSpacing.gapBase,
          ],

          // Medicamentos (texto libre para medicamentos adicionales)
          SaludFormField(
            controller: medicamentosController,
            label: itemInventarioSeleccionado != null
                ? l.treatStepMedicationsAdditional
                : l.treatStepMedications,
            hint: l.treatStepMedicationsHint,
            maxLines: 2,
            maxLength: 300,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
          ),
          AppSpacing.gapBase,

          // Dosificación y Duración en fila
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dosis
              Expanded(
                child: SaludFormField(
                  controller: dosisController,
                  label: l.treatStepDosis,
                  hint: l.treatStepDosisHint,
                  maxLength: 100,
                  textInputAction: TextInputAction.next,
                ),
              ),
              AppSpacing.hGapMd,

              // Duración
              Expanded(
                child: SaludFormField(
                  controller: duracionController,
                  label: l.treatStepDuration,
                  hint: l.treatStepDurationHint,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final dias = int.tryParse(value);
                      if (dias == null || dias <= 0) {
                        return l.treatStepDurationMin;
                      }
                      if (dias > 365) {
                        return l.treatStepDurationMax;
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme, S l) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            l.treatStepDetailsImportant,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            l.treatStepDetailsImportantMsg,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventarioSelector(BuildContext context, ThemeData theme, S l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.treatStepInventoryMed,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        AppSpacing.gapSm,
        InventarioSelector(
          granjaId: granjaId!,
          tipoFiltro: TipoItem.medicamento,
          itemSeleccionado: itemInventarioSeleccionado,
          onItemSelected: onItemInventarioChanged!,
          hint: l.treatStepSelectMed,
        ),
        if (itemInventarioSeleccionado != null) ...[
          AppSpacing.gapSm,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.08),
              borderRadius: AppRadius.allSm,
              border: Border.all(
                color: AppColors.info.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory_2, color: AppColors.info, size: 18),
                AppSpacing.hGapSm,
                Expanded(
                  child: Text(
                    l.treatStepAutoDeduct,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.info,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
