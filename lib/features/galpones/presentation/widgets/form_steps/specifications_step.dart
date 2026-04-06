/// Step 2: Especificaciones e Instalaciones
/// Capacidad de aves, área total, bebederos, comederos y nidales
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'package:flutter/services.dart';

import '../galpon_form_field.dart';

/// Step de especificaciones e instalaciones
class SpecificationsStep extends StatelessWidget {
  const SpecificationsStep({
    super.key,
    required this.capacidadAvesController,
    required this.areaM2Controller,
    required this.numeroBeberosController,
    required this.numeroComerosController,
    required this.numeroNidalesController,
    this.autoValidate = false,
  });

  final TextEditingController capacidadAvesController;
  final TextEditingController areaM2Controller;
  final TextEditingController numeroBeberosController;
  final TextEditingController numeroComerosController;
  final TextEditingController numeroNidalesController;
  final bool autoValidate;

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
            S.of(context).shedSpecifications,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).shedSpecsDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapXl,

          // Capacidad Máxima de Aves
          GalponFormField(
            controller: capacidadAvesController,
            label: S.of(context).shedMaxBirdCapacity,
            hint: S.of(context).commonHintExample('10000'),
            suffixText: S.of(context).shedBirds,
            required: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).shedCapacityIsRequired;
              }
              final number = int.tryParse(value);
              if (number == null) {
                return S.of(context).shedMustBeValidNumber;
              }
              if (number <= 0) {
                return S.of(context).shedMustBePositiveNumber;
              }
              if (number > 1000000) {
                return S.of(context).shedNumberTooLarge;
              }
              return null;
            },
          ),
          AppSpacing.gapMd,

          // Área Total
          GalponFormField(
            controller: areaM2Controller,
            label: S.of(context).shedTotalArea,
            hint: S.of(context).commonHintExample('500'),
            suffixText: 'm²',
            required: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).shedAreaRequired;
              }
              final number = double.tryParse(value);
              if (number == null) {
                return S.of(context).shedMustBeValidNumber;
              }
              if (number <= 0) {
                return S.of(context).shedMustBePositiveNumber;
              }
              if (number > 10000000) {
                return S.of(context).shedNumberTooLarge;
              }
              return null;
            },
          ),
          AppSpacing.gapMd,

          // Número de Bebederos
          GalponFormField(
            controller: numeroBeberosController,
            label: S.of(context).shedDrinkersOptional,
            hint: S.of(context).commonHintExample('50'),
            suffixText: S.of(context).shedUnitsLabel,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              final number = int.tryParse(value);
              if (number == null) {
                return S.of(context).shedMustBeValidNumber;
              }
              if (number < 0) {
                return S.of(context).shedMustBePositiveNumber;
              }
              if (number > 10000) {
                return S.of(context).shedNumberSeemsHigh;
              }
              return null;
            },
          ),
          AppSpacing.gapMd,

          // Número de Comederos
          GalponFormField(
            controller: numeroComerosController,
            label: S.of(context).shedFeedersOptional,
            hint: S.of(context).commonHintExample('50'),
            suffixText: S.of(context).shedUnitsLabel,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              final number = int.tryParse(value);
              if (number == null) {
                return S.of(context).shedMustBeValidNumber;
              }
              if (number < 0) {
                return S.of(context).shedMustBePositiveNumber;
              }
              if (number > 10000) {
                return S.of(context).shedNumberSeemsHigh;
              }
              return null;
            },
          ),
          AppSpacing.gapMd,

          // Número de Nidales
          GalponFormField(
            controller: numeroNidalesController,
            label: S.of(context).shedNestsOptional,
            hint: S.of(context).commonHintExample('100'),
            suffixText: S.of(context).shedUnitsLabel,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              final number = int.tryParse(value);
              if (number == null) {
                return S.of(context).shedMustBeValidNumber;
              }
              if (number < 0) {
                return S.of(context).shedMustBePositiveNumber;
              }
              if (number > 10000) {
                return S.of(context).shedNumberSeemsHigh;
              }
              return null;
            },
          ),
          AppSpacing.gapBase,

          // Card informativa
          _buildInfoCard(),
          AppSpacing.gapBase,

          // Tabla de densidades recomendadas
          _buildDensityTable(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
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
                S.of(context).shedUsefulInfo,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.gapXxs,
              Text(
                S.of(context).shedDensityPlanningHelp,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDensityTable() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
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
                S.of(context).shedRecommendedDensities,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.gapMd,
              Table(
                border: TableBorder.all(
                  color: AppColors.info.withValues(alpha: 0.3),
                  borderRadius: AppRadius.allSm,
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                    ),
                    children: [
                      _buildTableCell(
                        theme,
                        S.of(context).shedDensityTypeCol,
                        isHeader: true,
                      ),
                      _buildTableCell(
                        theme,
                        S.of(context).shedDensityCol,
                        isHeader: true,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell(theme, S.of(context).shedFattening),
                      _buildTableCell(theme, S.of(context).shedDensityFattening),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell(theme, S.of(context).shedLaying),
                      _buildTableCell(theme, S.of(context).shedDensityLaying),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell(theme, S.of(context).shedBreeder),
                      _buildTableCell(theme, S.of(context).shedDensityBreeder),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTableCell(
    ThemeData theme,
    String text, {
    bool isHeader = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: isHeader ? FontWeight.w600 : FontWeight.w500,
            color: isHeader ? AppColors.info : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
