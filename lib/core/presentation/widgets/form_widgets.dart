/// Widgets reutilizables para formularios de registro
///
/// Contiene campos de texto, dropdowns, y cards informativas
/// con estilos consistentes para formularios multi-step
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

// ============================================================================
// ENUMS
// ============================================================================

/// Tipo de card informativa
enum InfoCardType {
  info,
  warning,
  error,
  success;

  Color get color => switch (this) {
    InfoCardType.info => AppColors.info,
    InfoCardType.warning => AppColors.warning,
    InfoCardType.error => AppColors.error,
    InfoCardType.success => AppColors.success,
  };

  Color get backgroundColor => switch (this) {
    InfoCardType.info => AppColors.infoLight.withValues(alpha: 0.15),
    InfoCardType.warning => AppColors.warningLight.withValues(alpha: 0.15),
    InfoCardType.error => AppColors.errorLight.withValues(alpha: 0.15),
    InfoCardType.success => AppColors.successLight.withValues(alpha: 0.15),
  };

  IconData get icon => switch (this) {
    InfoCardType.info => Icons.info_outline,
    InfoCardType.warning => Icons.warning_amber_rounded,
    InfoCardType.error => Icons.error_outline,
    InfoCardType.success => Icons.check_circle_outline,
  };

  /// Color del icono de estado sobre el fondo oscuro de [FormInfoCard].
  /// Tonos brillantes para contraste sobre el panel oscuro del diseño.
  Color get accentOnDark => switch (this) {
    InfoCardType.info => const Color(0xFF3B9EDE),
    InfoCardType.warning => const Color(0xFFE6B33E),
    InfoCardType.error => const Color(0xFFE05656),
    InfoCardType.success => const Color(0xFF3BB273),
  };

  /// Icono circular relleno usado en [FormInfoCard] (estilo del diseño).
  IconData get filledIcon => switch (this) {
    InfoCardType.info => Icons.info,
    InfoCardType.warning => Icons.warning_amber_rounded,
    InfoCardType.error => Icons.error,
    InfoCardType.success => Icons.check_circle,
  };
}

// ============================================================================
// REGISTRO FORM FIELD
// ============================================================================

/// Campo de texto estilizado para formularios de registro
class RegistroFormField extends StatelessWidget {
  const RegistroFormField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.suffixText,
    this.prefixIcon,
    this.required = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.validator,
    this.autovalidateMode,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.initialValue,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String label;
  final String? hint;
  final String? suffixText;
  final IconData? prefixIcon;
  final bool required;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label superior (estilo consistente con crear_granja / AppFormField)
        Text(
          required ? '$label *' : label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _buildField(theme),
      ],
    );
  }

  Widget _buildField(ThemeData theme) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: autovalidateMode,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      focusNode: focusNode,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        suffixText: suffixText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        // Diseño idéntico al campo selector (causa/método/tipo):
        // mismo radio, borde y padding.
        border: OutlineInputBorder(
          borderRadius: AppRadius.allSm,
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.4),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.allSm,
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.allSm,
          borderSide: const BorderSide(color: AppColors.info, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.allSm,
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.allSm,
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
        ),
        filled: true,
        fillColor: enabled
            ? theme.colorScheme.surface
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

// ============================================================================
// REGISTRO DROPDOWN FIELD
// ============================================================================

/// Dropdown estilizado para formularios de registro
class RegistroDropdownField<T> extends StatelessWidget {
  const RegistroDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.required = false,
    this.validator,
    this.autovalidateMode,
    this.selectedItemBuilder,
    this.enabled = true,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final bool required;
  final FormFieldValidator<T>? validator;
  final AutovalidateMode? autovalidateMode;
  final DropdownButtonBuilder? selectedItemBuilder;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label superior (estilo consistente con crear_granja / AppFormField)
        Text(
          required ? '$label *' : label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _buildDropdown(theme, context),
      ],
    );
  }

  Widget _buildDropdown(ThemeData theme, BuildContext context) {
    return DropdownButtonFormField<T>(
      // ignore: deprecated_member_use
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      autovalidateMode: autovalidateMode,
      selectedItemBuilder: selectedItemBuilder,
      isExpanded: true,
      itemHeight: null,
      menuMaxHeight: MediaQuery.sizeOf(context).height * 0.5,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: enabled
            ? theme.colorScheme.surface
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      dropdownColor: theme.colorScheme.surface,
    );
  }
}

// ============================================================================
// FORM INFO ROW
// ============================================================================

/// Fila informativa inline para formularios (más compacta que FormInfoCard)
class FormInfoRow extends StatelessWidget {
  const FormInfoRow({super.key, required this.text, required this.type});

  final String text;
  final InfoCardType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: type.backgroundColor,
        borderRadius: AppRadius.allMd,
        border: Border.all(color: type.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(type.icon, size: 18, color: type.color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: type.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// FORM INFO CARD
// ============================================================================

/// Card informativa estandarizada del proyecto.
///
/// Panel oscuro con icono de estado a la izquierda (success/info/warning/
/// error), título y subtítulo, y una "X" opcional para descartar. El diseño
/// es fijo (mismo aspecto en claro y oscuro) para mantener consistencia en
/// todas las cards informativas/de atención del proyecto.
class FormInfoCard extends StatelessWidget {
  const FormInfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.type,
    this.onDismiss,
  });

  final String title;
  final String description;
  final InfoCardType type;

  /// Si se provee, muestra la "X" para descartar la card.
  final VoidCallback? onDismiss;

  /// Fondo oscuro del panel (estilo del diseño de referencia).
  static const Color _panelColor = Color(0xFF1C1C1E);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = type.accentOnDark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
      decoration: BoxDecoration(
        color: _panelColor,
        borderRadius: AppRadius.allLg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono de estado (círculo outline con icono relleno).
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: accent, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Icon(type.filledIcon, size: 15, color: accent),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.gapXs,
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.6),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          // "X" opcional para descartar.
          if (onDismiss != null) ...[
            AppSpacing.hGapSm,
            GestureDetector(
              onTap: onDismiss,
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.close,
                size: 18,
                color: AppColors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
