/// Step 1: Información de la Vacuna
/// Nombre, lote y fecha programada - Estilo Wialon
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../granjas/presentation/widgets/granja_form_field.dart';
import '../../../../inventario/domain/entities/item_inventario.dart';
import '../../../../inventario/domain/enums/tipo_item.dart';
import '../../../../inventario/presentation/widgets/inventario_selector.dart';
import '../../../../lotes/domain/entities/lote.dart';

/// Step de información de la vacuna
class VacunaInfoStep extends StatelessWidget {
  const VacunaInfoStep({
    super.key,
    required this.nombreVacunaController,
    required this.loteVacunaController,
    required this.fechaProgramada,
    required this.autoValidate,
    required this.onFechaChanged,
    this.granjaId,
    this.itemInventarioSeleccionado,
    this.onItemInventarioChanged,
    this.lotes,
    this.loteSeleccionado,
    this.onLoteChanged,
    this.mostrarSelectorLote = false,
  });

  final TextEditingController nombreVacunaController;
  final TextEditingController loteVacunaController;
  final DateTime fechaProgramada;
  final bool autoValidate;
  final void Function(DateTime) onFechaChanged;
  final String? granjaId;
  final ItemInventario? itemInventarioSeleccionado;
  final void Function(ItemInventario?)? onItemInventarioChanged;
  final List<Lote>? lotes;
  final Lote? loteSeleccionado;
  final void Function(Lote?)? onLoteChanged;
  final bool mostrarSelectorLote;

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
            l.vacStepVaccineInfoTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.vacStepVaccineInfoDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.gapXl,

          // Selector de lote (cuando se navega sin lote específico)
          if (mostrarSelectorLote &&
              lotes != null &&
              onLoteChanged != null) ...[
            _buildLoteSelector(theme, l),
            AppSpacing.gapBase,
          ],

          // Selector de vacuna desde inventario
          if (granjaId != null &&
              granjaId!.isNotEmpty &&
              onItemInventarioChanged != null) ...[
            _buildInventarioSelector(theme, l),
            AppSpacing.gapBase,
          ],

          // Nombre de la vacuna
          GranjaFormField(
            controller: nombreVacunaController,
            label: l.vacStepVaccineName,
            hint: l.vacStepVaccineNameHint,
            required: true,
            maxLength: 100,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l.vacStepVaccineNameRequired;
              }
              if (value.trim().length < 3) {
                return l.vacStepVaccineNameMinLength;
              }
              return null;
            },
          ),
          AppSpacing.gapBase,

          // Lote de la vacuna
          GranjaFormField(
            controller: loteVacunaController,
            label: l.vacStepVaccineBatch,
            hint: l.vacStepVaccineBatchHint,
            maxLength: 50,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.next,
          ),
          AppSpacing.gapBase,

          // Fecha programada
          _buildFechaProgramadaField(context, theme, l),
          AppSpacing.gapXl,

          // Info card
          _buildInfoCard(theme, l),
        ],
      ),
    );
  }

  Widget _buildLoteSelector(ThemeData theme, S l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.vacStepBatchRequired,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        AppSpacing.gapSm,
        DropdownButtonFormField<Lote>(
          initialValue: loteSeleccionado,
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.surface,
            hintText: l.vacStepSelectBatch,
            border: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: lotes!.map((lote) {
            return DropdownMenuItem<Lote>(
              value: lote,
              child: Text(
                lote.nombre ?? lote.codigo,
                style: theme.textTheme.bodyLarge,
              ),
            );
          }).toList(),
          onChanged: onLoteChanged,
          validator: (value) {
            if (value == null) {
              return l.vacStepSelectBatch;
            }
            return null;
          },
          autovalidateMode: autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

  Widget _buildInventarioSelector(ThemeData theme, S l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.vacStepSelectFromInventory,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        AppSpacing.gapSm,
        InventarioSelector(
          granjaId: granjaId!,
          itemSeleccionado: itemInventarioSeleccionado,
          onItemSelected: (item) {
            onItemInventarioChanged!(item);
            if (item != null) {
              nombreVacunaController.text = item.nombre;
            }
          },
          tipoFiltro: TipoItem.vacuna,
          label: l.vacStepSelectVaccineInventory,
          hint: l.vacStepOptionalSelectVaccine,
        ),
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
          child: Text(
            l.vacStepInventoryNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFechaProgramadaField(
    BuildContext context,
    ThemeData theme,
    S l,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l.vacStepScheduledDate,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        AppSpacing.gapSm,
        InkWell(
          onTap: () => _seleccionarFecha(context),
          borderRadius: AppRadius.allSm,
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: AppRadius.allSm,
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.allSm,
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(fechaProgramada),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(ThemeData theme, S l) {
    return Container(
      padding: const EdgeInsets.all(12),
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
            l.vacStepTipTitle,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            l.vacStepTipMessage,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: fechaProgramada,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (fecha != null) {
      onFechaChanged(fecha);
    }
  }
}
