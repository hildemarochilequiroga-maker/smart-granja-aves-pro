/// Campo de formulario personalizado para las granjas
/// Diseño consistente con el feature de auth - Estilo Wialon
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:smartgranjaavespro/core/theme/app_radius.dart';

/// Campo de formulario personalizado para las granjas
/// Estilo Wialon - Label encima, bordes sutiles
class GranjaFormField extends StatefulWidget {
  const GranjaFormField({
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
  State<GranjaFormField> createState() => _GranjaFormFieldState();
}

class _GranjaFormFieldState extends State<GranjaFormField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Colores estilo Wialon
    final labelColor = theme.colorScheme.onSurface.withValues(alpha: 0.8);
    final labelText = widget.required ? '${widget.label} *' : widget.label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label encima del campo
        Text(
          labelText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: labelColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        // Campo de texto con altura fija para campos de una línea
        _buildTextField(theme, isDark),
        // Helper text debajo (opcional)
        if (widget.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.helperText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextField(ThemeData theme, bool isDark) {
    final textField = TextFormField(
      controller: widget.controller,
      initialValue: widget.controller == null ? widget.initialValue : null,
      focusNode: _focusNode,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      autovalidateMode:
          widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
      style: theme.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w400,
        color: theme.colorScheme.onSurface,
      ),
      cursorColor: theme.colorScheme.primary,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: widget.prefixText != null
            ? Padding(
                padding: const EdgeInsets.only(left: 16, right: 0),
                child: Text(
                  widget.prefixText!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              )
            : widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              )
            : null,
        prefixIconConstraints: widget.prefixText != null
            ? const BoxConstraints(minWidth: 0, minHeight: 0)
            : null,
        suffixIcon: widget.suffixIcon,
        suffixText: widget.suffixText,
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
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.allSm,
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.allSm,
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.allSm,
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.allSm,
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: widget.maxLines > 1 ? 12 : 12,
        ),
        counterText: '',
        errorStyle: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
          height: 1.2,
        ),
      ),
      validator:
          widget.validator ?? (widget.required ? _validarRequerido : null),
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
    );

    return textField;
  }

  String? _validarRequerido(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return S.of(context).commonFieldIsRequired;
    }
    return null;
  }
}
