library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/enums/enums.dart';

/// Campo de formulario personalizado para las granjas
/// Diseño consistente con el feature de auth
class GranjaFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final bool required;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool enabled;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final FocusNode? focusNode;

  const GranjaFormField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.required = false,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.suffixIcon,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.initialValue,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      focusNode: focusNode,
      maxLines: maxLines,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      autofocus: autofocus,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              )
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: AppRadius.allSm,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.allSm,
          borderSide: BorderSide(color: theme.colorScheme.outline, width: 1),
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
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.allSm,
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator:
          validator ??
          (required
              ? (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return S.of(context).commonFieldRequired2(label);
                  }
                  return null;
                }
              : null),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
    );
  }
}

/// Widget para mostrar errores
class GranjaErrorWidget extends StatelessWidget {
  final String mensaje;
  final VoidCallback? onReintentar;

  const GranjaErrorWidget({
    super.key,
    required this.mensaje,
    this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 360;

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: isSmallScreen ? 48 : 64,
                    color: theme.colorScheme.error,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 16 : 20),
                Text(
                  S.of(context).commonOccurredError,
                  style:
                      (isSmallScreen
                              ? theme.textTheme.titleMedium
                              : theme.textTheme.titleLarge)
                          ?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapSm,
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 16,
                  ),
                  child: Text(
                    mensaje,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                      fontSize: isSmallScreen ? 13 : null,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 20 : 24),
                if (onReintentar != null)
                  SizedBox(
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: onReintentar,
                      icon: const Icon(Icons.refresh),
                      label: Text(S.of(context).commonRetry),
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.allSm,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget de carga
class GranjaLoadingWidget extends StatelessWidget {
  final String? mensaje;

  const GranjaLoadingWidget({super.key, this.mensaje});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (mensaje != null) ...[
            AppSpacing.gapBase,
            Text(
              mensaje!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Badge de estado para granjas - Reutilizable en todo el feature
class GranjaEstadoBadge extends StatelessWidget {
  final EstadoGranja estado;
  final bool compact;

  const GranjaEstadoBadge({
    super.key,
    required this.estado,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final info = _getStatusInfo(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 5,
      ),
      decoration: BoxDecoration(
        color: info.color,
        borderRadius: AppRadius.allSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact) ...[
            Icon(info.icon, size: 14, color: AppColors.white),
            AppSpacing.hGapXxs,
          ],
          Flexible(
            child: Text(
              info.text,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo(BuildContext context) {
    final l = S.of(context);
    return switch (estado) {
      EstadoGranja.activo => _StatusInfo(
        color: AppColors.success,
        icon: Icons.check_circle,
        text: l.farmStatusActive,
      ),
      EstadoGranja.inactivo => _StatusInfo(
        color: AppColors.grey600,
        icon: Icons.cancel,
        text: l.farmStatusInactive,
      ),
      EstadoGranja.mantenimiento => _StatusInfo(
        color: AppColors.warning,
        icon: Icons.build_circle,
        text: l.commonMaintenance,
      ),
    };
  }
}

class _StatusInfo {
  final Color color;
  final IconData icon;
  final String text;

  const _StatusInfo({
    required this.color,
    required this.icon,
    required this.text,
  });
}


