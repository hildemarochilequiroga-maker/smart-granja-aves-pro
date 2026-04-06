/// Step 3: Condiciones Ambientales
/// Temperatura, humedad y ventilación con umbrales mínimos y máximos
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'package:flutter/services.dart';

import '../galpon_form_field.dart';

/// Step de condiciones ambientales (todos opcionales)
class EnvironmentalStep extends StatelessWidget {
  const EnvironmentalStep({
    super.key,
    required this.temperaturaMinController,
    required this.temperaturaMaxController,
    required this.humedadMinController,
    required this.humedadMaxController,
    required this.ventilacionMinController,
    required this.ventilacionMaxController,
  });

  final TextEditingController temperaturaMinController;
  final TextEditingController temperaturaMaxController;
  final TextEditingController humedadMinController;
  final TextEditingController humedadMaxController;
  final TextEditingController ventilacionMinController;
  final TextEditingController ventilacionMaxController;

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
            S.of(context).shedEnvironmentalConditions,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).shedConfigureThresholds,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapXl,

          // Sección Temperatura
          _buildSectionTitle(S.of(context).shedTemperature, Icons.thermostat),
          AppSpacing.gapMd,
          Row(
            children: [
              Expanded(
                child: GalponFormField(
                  controller: temperaturaMinController,
                  label: S.of(context).shedMinLabel,
                  hint: S.of(context).commonHintExample('18'),
                  suffixText: '°C',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,1}'),
                    ),
                  ],
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final temp = double.tryParse(value.trim());
                      if (temp == null || temp < 0 || temp > 50) {
                        return S.of(context).shedInvalidTempRange;
                      }
                    }
                    return null;
                  },
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: GalponFormField(
                  controller: temperaturaMaxController,
                  label: S.of(context).shedMaxLabel,
                  hint: S.of(context).commonHintExample('28'),
                  suffixText: '°C',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,1}'),
                    ),
                  ],
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final temp = double.tryParse(value.trim());
                      if (temp == null || temp < 0 || temp > 50) {
                        return S.of(context).shedInvalidTempRange;
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          AppSpacing.gapLg,

          // Sección Humedad
          _buildSectionTitle(
            S.of(context).shedRelativeHumidity,
            Icons.water_drop,
          ),
          AppSpacing.gapMd,
          Row(
            children: [
              Expanded(
                child: GalponFormField(
                  controller: humedadMinController,
                  label: S.of(context).shedMinLabel,
                  hint: S.of(context).commonHintExample('50'),
                  suffixText: '%',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,1}'),
                    ),
                  ],
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final humidity = double.tryParse(value.trim());
                      if (humidity == null || humidity < 0 || humidity > 100) {
                        return S.of(context).shedInvalidHumidityRange;
                      }
                    }
                    return null;
                  },
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: GalponFormField(
                  controller: humedadMaxController,
                  label: S.of(context).shedMaxLabel,
                  hint: S.of(context).commonHintExample('70'),
                  suffixText: '%',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,1}'),
                    ),
                  ],
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final humidity = double.tryParse(value.trim());
                      if (humidity == null || humidity < 0 || humidity > 100) {
                        return S.of(context).shedInvalidHumidityRange;
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          AppSpacing.gapLg,

          // Sección Ventilación
          _buildSectionTitle(S.of(context).shedVentilation, Icons.air),
          AppSpacing.gapMd,
          Row(
            children: [
              Expanded(
                child: GalponFormField(
                  controller: ventilacionMinController,
                  label: S.of(context).shedMinLabel,
                  hint: S.of(context).commonHintExample('100'),
                  suffixText: 'm³/h',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,1}'),
                    ),
                  ],
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final vent = double.tryParse(value.trim());
                      if (vent == null || vent < 0) {
                        return S.of(context).shedInvalidValue;
                      }
                    }
                    return null;
                  },
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: GalponFormField(
                  controller: ventilacionMaxController,
                  label: S.of(context).shedMaxLabel,
                  hint: S.of(context).commonHintExample('300'),
                  suffixText: 'm³/h',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,1}'),
                    ),
                  ],
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final vent = double.tryParse(value.trim());
                      if (vent == null || vent < 0) {
                        return S.of(context).shedInvalidValue;
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          AppSpacing.gapLg,

          // Card con consejos
          _buildTipsCard(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }

  Widget _buildTipsCard() {
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
                S.of(context).shedTip,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.gapXxs,
              Text(
                S.of(context).shedEnvironmentalAlertHelp,
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
}
