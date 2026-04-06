/// Step 3: Información de Contacto
/// Email, teléfono, WhatsApp y RUC
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/value_objects/location_data.dart';
import '../granja_form_field.dart';

/// Step de información de contacto
class ContactInfoStep extends StatelessWidget {
  const ContactInfoStep({
    super.key,
    required this.emailController,
    required this.telefonoController,
    required this.whatsappController,
    required this.rucController,
    this.autoValidate = false,
    this.pais = 'Perú',
  });

  final TextEditingController emailController;
  final TextEditingController telefonoController;
  final TextEditingController whatsappController;
  final TextEditingController rucController;
  final bool autoValidate;
  final String pais;

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
            l.farmContactInfo,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.farmContactInfoDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.gapXl,

          // Email
          GranjaFormField(
            controller: emailController,
            label: l.farmEmailLabel,
            hint: l.farmEmailHint,
            required: true,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l.farmEnterEmail;
              }
              final emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              );
              if (!emailRegex.hasMatch(value)) {
                return l.farmEnterValidEmail;
              }
              return null;
            },
          ),
          AppSpacing.gapBase,

          // Teléfono
          GranjaFormField(
            controller: telefonoController,
            label: l.farmPhoneLabel,
            hint: _phoneHint,
            prefixText: '${LocationData.getPhonePrefix(pais)} ',
            required: true,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(
                LocationData.getPhoneLength(pais),
              ),
            ],
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) => _validatePhone(value, isRequired: true, l: l),
          ),
          AppSpacing.gapBase,

          // WhatsApp
          GranjaFormField(
            controller: whatsappController,
            label: l.farmWhatsappOptional,
            hint: _phoneHint,
            prefixText: '${LocationData.getPhonePrefix(pais)} ',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(
                LocationData.getPhoneLength(pais),
              ),
            ],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) =>
                _validatePhone(value, isRequired: false, l: l),
          ),
          AppSpacing.gapBase,

          // RUC / RIF
          GranjaFormField(
            controller: rucController,
            label: l.farmFiscalDocOptional(
              LocationData.getFiscalDocLabel(pais),
            ),
            hint: _fiscalHint,
            keyboardType: (pais == 'Venezuela' || pais == 'Colombia')
                ? TextInputType.text
                : TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: switch (pais) {
              'Venezuela' => [LengthLimitingTextInputFormatter(12)],
              'Ecuador' => [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(13),
              ],
              'Colombia' => [LengthLimitingTextInputFormatter(11)],
              _ => [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => _validateFiscalDoc(value, l),
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
            S.of(context).farmContactDataTitle,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            S.of(context).farmContactDataHelp,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Helpers ====================

  String get _phoneHint {
    switch (pais) {
      case 'Venezuela':
        return '4121234567';
      case 'Ecuador':
        return '912345678';
      case 'Colombia':
        return '3001234567';
      default:
        return '987654321';
    }
  }

  String get _fiscalHint {
    switch (pais) {
      case 'Venezuela':
        return 'J-12345678-9';
      case 'Ecuador':
        return '1712345678001';
      case 'Colombia':
        return '900123456-7';
      default:
        return '20123456789';
    }
  }

  String? _validatePhone(
    String? value, {
    required bool isRequired,
    required S l,
  }) {
    if (value == null || value.isEmpty) {
      return isRequired ? l.farmEnterPhone : null;
    }
    final expectedLength = LocationData.getPhoneLength(pais);
    if (value.length != expectedLength) {
      return l.farmPhoneLength(expectedLength.toString());
    }
    if (!LocationData.isValidPhoneStart(pais, value)) {
      return LocationData.getPhoneStartError(pais);
    }
    return null;
  }

  String? _validateFiscalDoc(String? value, S l) {
    if (value == null || value.isEmpty) return null;
    switch (pais) {
      case 'Venezuela':
        final rifRegex = RegExp(r'^[JVGEPjvgep]-?\d{8}-?\d$');
        if (!rifRegex.hasMatch(value)) {
          return l.farmInvalidRifFormat;
        }
      case 'Ecuador':
        if (value.length != 13) {
          return l.farmRucMustHaveDigits(13);
        }
      case 'Colombia':
        final nitRegex = RegExp(r'^\d{9}-?\d$');
        if (!nitRegex.hasMatch(value)) {
          return l.farmInvalidNitFormat;
        }
      default: // Perú
        if (value.length != 11) {
          return l.farmRucMustHaveDigits(11);
        }
        if (!value.startsWith('10') &&
            !value.startsWith('20') &&
            !value.startsWith('15') &&
            !value.startsWith('17')) {
          return l.farmRucMustStartWith;
        }
    }
    return null;
  }
}
