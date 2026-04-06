/// Step 2: Stock del Item de Inventario
/// Stock actual, mínimo, máximo y unidad de medida
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/form_widgets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../granjas/presentation/widgets/granja_form_field.dart';
import '../../../domain/enums/enums.dart';

/// Step de stock del item
class InventarioStockStep extends StatelessWidget {
  const InventarioStockStep({
    super.key,
    required this.tipoItem,
    required this.stockActualController,
    required this.stockMinimoController,
    required this.stockMaximoController,
    required this.unidadSeleccionada,
    required this.onUnidadChanged,
    this.autoValidate = false,
  });

  final TipoItem tipoItem;
  final TextEditingController stockActualController;
  final TextEditingController stockMinimoController;
  final TextEditingController stockMaximoController;
  final UnidadMedida unidadSeleccionada;
  final void Function(UnidadMedida) onUnidadChanged;
  final bool autoValidate;

  /// Obtiene las unidades relevantes según el tipo de item
  List<UnidadMedida> _getUnidadesRelevantes() {
    switch (tipoItem) {
      case TipoItem.alimento:
        // Para alimentos: peso (kg, g, lb) y empaques (saco, bulto)
        return UnidadMedida.values
            .where(
              (u) =>
                  u.categoria == 'Peso' ||
                  u == UnidadMedida.saco ||
                  u == UnidadMedida.bulto,
            )
            .toList();
      case TipoItem.medicamento:
        return UnidadMedida.values
            .where(
              (u) =>
                  u.categoria == 'Aplicación' ||
                  u.categoria == 'Volumen' ||
                  u.categoria == 'Empaque',
            )
            .toList();
      case TipoItem.vacuna:
        return UnidadMedida.values
            .where(
              (u) => u.categoria == 'Aplicación' || u.categoria == 'Volumen',
            )
            .toList();
      case TipoItem.equipo:
        return UnidadMedida.values
            .where((u) => u.categoria == 'Cantidad')
            .toList();
      case TipoItem.insumo:
        return UnidadMedida.values
            .where(
              (u) =>
                  u.categoria == 'Cantidad' ||
                  u.categoria == 'Empaque' ||
                  u.categoria == 'Peso',
            )
            .toList();
      case TipoItem.limpieza:
        return UnidadMedida.values
            .where(
              (u) =>
                  u.categoria == 'Volumen' ||
                  u.categoria == 'Cantidad' ||
                  u.categoria == 'Empaque',
            )
            .toList();
      case TipoItem.otro:
        return UnidadMedida.values;
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
            l.invStepStockTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.invConfigureQuantities,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapXl,

          // Info card
          FormInfoRow(
            text: l.invUnitsFilteredAutomatically,
            type: InfoCardType.info,
          ),
          AppSpacing.gapXl,

          // Selector de unidad de medida
          _buildUnidadSelector(context, theme),

          AppSpacing.gapXl,

          // Stock Actual
          GranjaFormField(
            controller: stockActualController,
            label: l.invCurrentStock,
            hint: '0',
            required: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l.invEnterCurrentStock;
              }
              if (double.tryParse(value) == null) {
                return l.invEnterValidNumber;
              }
              return null;
            },
            suffixText: unidadSeleccionada.simbolo,
          ),
          AppSpacing.gapBase,

          // Stock Mínimo y Máximo en fila
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GranjaFormField(
                  controller: stockMinimoController,
                  label: l.invMinimumStock,
                  hint: '0',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  suffixText: unidadSeleccionada.simbolo,
                ),
              ),
              AppSpacing.hGapBase,
              Expanded(
                child: GranjaFormField(
                  controller: stockMaximoController,
                  label: l.invMaximumStock,
                  hint: l.invOptional,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  suffixText: unidadSeleccionada.simbolo,
                ),
              ),
            ],
          ),
          AppSpacing.gapXl,

          // Card informativa sobre alertas
          _buildAlertasCard(context),
        ],
      ),
    );
  }

  Widget _buildUnidadSelector(BuildContext context, ThemeData theme) {
    final l = S.of(context);
    final unidades = _getUnidadesRelevantes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.invUnitOfMeasure,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.gapBase,

        // Grid de unidades - 3 columnas como el grid de fotos
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.3,
          ),
          itemCount: unidades.length,
          itemBuilder: (context, index) {
            return _buildUnidadItem(context, theme, unidades[index]);
          },
        ),
      ],
    );
  }

  Widget _buildUnidadItem(
    BuildContext context,
    ThemeData theme,
    UnidadMedida unidad,
  ) {
    final isSelected = unidad == unidadSeleccionada;
    const color = AppColors.info;

    return GestureDetector(
      onTap: () => onUnidadChanged(unidad),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : theme.colorScheme.surface,
          borderRadius: AppRadius.allMd,
          border: Border.all(
            color: isSelected
                ? color
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Símbolo arriba
            Text(
              unidad.simbolo,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isSelected ? AppColors.white : color,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapXxxs,
            // Nombre abajo
            Text(
              unidad.displayName,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? AppColors.white.withValues(alpha: 0.9)
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertasCard(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: AppRadius.allMd,
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.invStockAlerts,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            l.invStockAlertDescription,
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
