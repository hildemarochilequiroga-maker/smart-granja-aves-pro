/// Campo de formulario del módulo de galpones.
///
/// Delega en [AppFormField] (estilo unificado). Se conserva el nombre por
/// compatibilidad con los call sites del feature.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartgranjaavespro/core/presentation/widgets/app_form_field.dart';

/// Campo de formulario personalizado para galpones.
class GalponFormField extends StatelessWidget {
  const GalponFormField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.helperText,
    this.prefixIcon,
    this.prefixText,
    this.suffixIcon,
    this.suffixText,
    this.required = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.initialValue,
    this.focusNode,
    this.autovalidateMode,
  });

  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? helperText;
  final IconData? prefixIcon;
  final String? prefixText;
  final Widget? suffixIcon;
  final String? suffixText;
  final bool required;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool obscureText;
  final bool enabled;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return AppFormField(
      controller: controller,
      label: label,
      hint: hint,
      helperText: helperText,
      prefixIcon: prefixIcon,
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      suffixText: suffixText,
      required: required,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      obscureText: obscureText,
      enabled: enabled,
      autofocus: autofocus,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      initialValue: initialValue,
      focusNode: focusNode,
      autovalidateMode: autovalidateMode,
    );
  }
}
