/// Dropdown de formulario unificado de la aplicación (estilo "Wialon").
///
/// Label encima del campo, bordes sutiles redondeados y validación de
/// requerido localizada. Es el equivalente desplegable de [AppFormField].
///
/// ```dart
/// AppDropdownField<TipoAve>(
///   label: 'Tipo de ave',
///   value: _tipo,
///   items: TipoAve.values
///       .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
///       .toList(),
///   onChanged: (v) => setState(() => _tipo = v),
///   required: true,
/// )
/// ```
library;

import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../../l10n/app_localizations.dart';

/// Dropdown con label superior, estilo consistente y validación de requerido.
class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.helperText,
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
  final String? helperText;
  final bool required;
  final FormFieldValidator<T>? validator;
  final AutovalidateMode? autovalidateMode;
  final DropdownButtonBuilder? selectedItemBuilder;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelColor = theme.colorScheme.onSurface.withValues(alpha: 0.8);
    final labelText = required ? '$label *' : label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          labelText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: labelColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          // ignore: deprecated_member_use
          value: value,
          items: items,
          onChanged: enabled ? onChanged : null,
          validator: validator ?? (required ? _validarRequerido(context) : null),
          autovalidateMode:
              autovalidateMode ?? AutovalidateMode.onUserInteraction,
          selectedItemBuilder: selectedItemBuilder,
          isExpanded: true,
          menuMaxHeight: MediaQuery.sizeOf(context).height * 0.5,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurface,
          ),
          dropdownColor: theme.colorScheme.surface,
          decoration: InputDecoration(
            hintText: hint ?? S.of(context).commonSelect(label),
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.normal,
            ),
            filled: true,
            fillColor: enabled
                ? theme.colorScheme.surface
                : theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
            border: _border(theme.colorScheme.outline.withValues(alpha: 0.4)),
            enabledBorder: _border(
              theme.colorScheme.outline.withValues(alpha: 0.4),
            ),
            focusedBorder: _border(theme.colorScheme.primary, width: 1.5),
            errorBorder: _border(theme.colorScheme.error),
            focusedErrorBorder: _border(theme.colorScheme.error, width: 1.5),
            disabledBorder: _border(
              theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            helperText: helperText,
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: AppRadius.allSm,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  FormFieldValidator<T> _validarRequerido(BuildContext context) {
    return (value) =>
        value == null ? S.of(context).commonFieldRequired : null;
  }
}
