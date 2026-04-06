/// Step 2: Monto y Fecha del Gasto
/// Captura del monto en soles y fecha del gasto
/// Incluye selector de inventario para alimento/medicamento
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/utils/formatters.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../inventario/domain/entities/entities.dart';
import '../../../../inventario/domain/enums/enums.dart';
import '../../../../inventario/presentation/widgets/widgets.dart';
import '../../../domain/enums/tipo_gasto.dart';
import '../costo_form_field.dart';

/// Step de monto y fecha del gasto
class MontoStep extends ConsumerStatefulWidget {
  const MontoStep({
    super.key,
    required this.conceptoController,
    required this.montoController,
    required this.fecha,
    required this.onFechaChanged,
    this.autoValidate = false,
    this.tipoGasto,
    this.granjaId,
    this.itemInventarioSeleccionado,
    this.onItemInventarioChanged,
  });

  final TextEditingController conceptoController;
  final TextEditingController montoController;
  final DateTime fecha;
  final ValueChanged<DateTime> onFechaChanged;
  final bool autoValidate;
  final TipoGasto? tipoGasto;
  final String? granjaId;
  final ItemInventario? itemInventarioSeleccionado;
  final ValueChanged<ItemInventario?>? onItemInventarioChanged;

  @override
  ConsumerState<MontoStep> createState() => _MontoStepState();
}

class _MontoStepState extends ConsumerState<MontoStep> {
  S get l => S.of(context);

  Future<void> _selectDate(BuildContext context) async {
    unawaited(HapticFeedback.selectionClick());
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
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
    if (picked != null && picked != widget.fecha) {
      widget.onFechaChanged(picked);
    }
  }

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
            l.costoAmountTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.costoAmountHint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.gapXl,

          // Campo concepto
          CostoFormField(
            controller: widget.conceptoController,
            label: l.costoConceptLabel,
            hint: l.costoConceptHint,
            required: true,
            maxLines: 2,
            maxLength: 200,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            autovalidateMode: widget.autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l.costoConceptRequired;
              }
              if (value.trim().length < 5) {
                return l.costoConceptMinLength;
              }
              return null;
            },
          ),
          AppSpacing.gapBase,

          // Selector de inventario (solo para alimento/medicamento)
          if (_mostrarSelectorInventario) ...[
            _buildInventarioSelector(theme),
            AppSpacing.gapBase,
          ],

          // Campo de monto
          CostoFormField(
            controller: widget.montoController,
            label: l.costoAmountLabel,
            hint: l.commonHintExample('0.00'),
            required: true,
            prefixText: Formatters.currencyPrefix,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            textInputAction: TextInputAction.done,
            autovalidateMode: widget.autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l.costoAmountRequired;
              }
              final monto = double.tryParse(value.replaceAll(',', '.'));
              if (monto == null || monto <= 0) {
                return l.costoAmountInvalid;
              }
              return null;
            },
          ),
          AppSpacing.gapXl,

          // Fecha del gasto
          Text(
            l.costoDateLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          AppSpacing.gapSm,
          InkWell(
            onTap: () => _selectDate(context),
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
                      DateFormat('dd/MM/yyyy').format(widget.fecha),
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
      ),
    );
  }

  /// Determina si mostrar el selector de inventario
  bool get _mostrarSelectorInventario {
    if (widget.granjaId == null || widget.onItemInventarioChanged == null) {
      return false;
    }
    return widget.tipoGasto == TipoGasto.alimento ||
        widget.tipoGasto == TipoGasto.medicamento;
  }

  /// Obtiene el tipo de item según el tipo de gasto
  TipoItem? get _tipoItemFiltro {
    if (widget.tipoGasto == TipoGasto.alimento) return TipoItem.alimento;
    if (widget.tipoGasto == TipoGasto.medicamento) return TipoItem.medicamento;
    return null;
  }

  /// Construye el selector de inventario
  Widget _buildInventarioSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info card
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
              const Icon(
                Icons.lightbulb_outline,
                color: AppColors.info,
                size: 20,
              ),
              AppSpacing.hGapSm,
              Expanded(
                child: Text(
                  l.costoInventoryLinkInfo,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapMd,

        // Selector
        InventarioSelector(
          granjaId: widget.granjaId!,
          tipoFiltro: _tipoItemFiltro,
          itemSeleccionado: widget.itemInventarioSeleccionado,
          onItemSelected: widget.onItemInventarioChanged!,
          label: widget.tipoGasto == TipoGasto.alimento
              ? l.costoLinkFood
              : l.costoLinkMedicine,
          hint: l.costoInventorySearchHint,
        ),

        // Mostrar info del item seleccionado
        if (widget.itemInventarioSeleccionado != null) ...[
          AppSpacing.gapSm,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.08),
              borderRadius: AppRadius.allSm,
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 18,
                ),
                AppSpacing.hGapSm,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.costoLinkedProduct,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        l.costoStockUpdateNote,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
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
