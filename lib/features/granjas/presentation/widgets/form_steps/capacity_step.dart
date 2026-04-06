/// Step 4: Capacidad e Instalaciones
/// Capacidad de aves, área total y número de galpones
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../granja_form_field.dart';

/// Step de capacidad e instalaciones (todos opcionales)
class CapacityStep extends StatelessWidget {
  const CapacityStep({
    super.key,
    required this.capacidadTotalController,
    required this.areaTotalController,
    required this.numeroCasasController,
    this.autoValidate = false,
  });

  final TextEditingController capacidadTotalController;
  final TextEditingController areaTotalController;
  final TextEditingController numeroCasasController;
  final bool autoValidate;

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
            l.farmCapacityInstallations,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.farmTechnicalDataOptional,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.gapXl,

          // Capacidad Máxima de Aves
          GranjaFormField(
            controller: capacidadTotalController,
            label: l.farmMaxBirdCapacity,
            hint: l.farmCapacityHint,
            suffixText: l.farmBirds,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              final number = int.tryParse(value);
              if (number == null || number <= 0) {
                return l.commonEnterValidNumber;
              }
              if (number > 1000000) {
                return l.farmMaxBirdsLimit;
              }
              return null;
            },
          ),
          AppSpacing.gapBase,

          // Área Total
          GranjaFormField(
            controller: areaTotalController,
            label: l.farmTotalArea,
            hint: l.farmAreaHint,
            suffixText: 'm²',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              final number = double.tryParse(value);
              if (number == null || number <= 0) {
                return l.commonEnterValidNumber;
              }
              return null;
            },
          ),
          AppSpacing.gapBase,

          // Número de Galpones
          GranjaFormField(
            controller: numeroCasasController,
            label: l.farmNumberOfSheds,
            hint: l.farmShedsHint,
            suffixText: l.farmShedsUnit,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              final number = int.tryParse(value);
              if (number == null || number <= 0) {
                return l.commonEnterValidNumber;
              }
              if (number > 100) {
                return l.farmMaxShedsLimit;
              }
              return null;
            },
          ),
          AppSpacing.gapXl,

          // Card informativa
          _buildInfoCard(context),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final theme = Theme.of(context);
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
            S.of(context).farmUsefulInfo,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            S.of(context).farmTechnicalDataHelp,
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
