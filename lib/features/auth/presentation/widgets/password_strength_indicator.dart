library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

/// Indicador de fortaleza de contraseña
class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.showText = true,
  });

  /// Contraseña a evaluar
  final String password;

  /// Mostrar texto descriptivo
  final bool showText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strength = _calculateStrength(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: AppRadius.allXs,
                child: LinearProgressIndicator(
                  value: strength.value,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(strength.color),
                  minHeight: 6,
                ),
              ),
            ),
            if (showText) ...[
              AppSpacing.hGapMd,
              Text(
                strength.localizedLabel(context),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: strength.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        if (password.isNotEmpty && strength != PasswordStrength.strong) ...[
          AppSpacing.gapSm,
          _buildRequirements(context),
        ],
      ],
    );
  }

  Widget _buildRequirements(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final requirements = [
      _PasswordRequirement(label: l.authMinChars, isMet: password.length >= 8),
      _PasswordRequirement(
        label: l.authOneUppercase,
        isMet: password.contains(RegExp(r'[A-Z]')),
      ),
      _PasswordRequirement(
        label: l.authOneLowercase,
        isMet: password.contains(RegExp(r'[a-z]')),
      ),
      _PasswordRequirement(
        label: l.authOneNumber,
        isMet: password.contains(RegExp(r'[0-9]')),
      ),
      _PasswordRequirement(
        label: l.authOneSpecialChar,
        isMet: password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')),
      ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: requirements.map((req) {
        final isMet = req.isMet;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isMet ? Icons.check_circle : Icons.circle_outlined,
              size: 14,
              color: isMet ? AppColors.success : theme.colorScheme.outline,
            ),
            AppSpacing.hGapXxs,
            Text(
              req.label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isMet
                    ? AppColors.success
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  PasswordStrength _calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.none;

    int score = 0;

    // Longitud
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Mayúsculas
    if (password.contains(RegExp(r'[A-Z]'))) score++;

    // Minúsculas
    if (password.contains(RegExp(r'[a-z]'))) score++;

    // Números
    if (password.contains(RegExp(r'[0-9]'))) score++;

    // Caracteres especiales
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }
}

/// Fortaleza de la contraseña
enum PasswordStrength {
  none(0.0, Colors.transparent),
  weak(0.33, AppColors.error),
  medium(0.66, AppColors.warning),
  strong(1.0, AppColors.success);

  const PasswordStrength(this.value, this.color);

  final double value;
  final Color color;

  String localizedLabel(BuildContext context) {
    final l = S.of(context);
    return switch (this) {
      PasswordStrength.none => '',
      PasswordStrength.weak => l.authPasswordWeak,
      PasswordStrength.medium => l.authPasswordMedium,
      PasswordStrength.strong => l.authPasswordStrong,
    };
  }
}

class _PasswordRequirement {
  const _PasswordRequirement({required this.label, required this.isMet});

  final String label;
  final bool isMet;
}
