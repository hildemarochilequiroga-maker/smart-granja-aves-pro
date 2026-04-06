library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/entities.dart';

/// Botón de autenticación social
class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({
    super.key,
    required this.metodo,
    required this.onPressed,
    this.isLoading = false,
    this.texto,
  });

  /// Método de autenticación
  final AuthMethod metodo;

  /// Callback al presionar
  final VoidCallback? onPressed;

  /// Estado de carga
  final bool isLoading;

  /// Texto personalizado
  final String? texto;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: _getBackgroundColor(colorScheme),
          foregroundColor: _getForegroundColor(colorScheme),
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _getForegroundColor(colorScheme),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIcon(),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    texto ?? _getDefaultText(context),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: _getForegroundColor(colorScheme),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (metodo) {
      case AuthMethod.google:
        return Image.asset(
          'assets/images/icons/google.png',
          width: 24,
          height: 24,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.g_mobiledata, size: 24),
        );
      case AuthMethod.apple:
        return const Icon(Icons.apple, size: 24);
      case AuthMethod.facebook:
        return const Icon(Icons.facebook, size: 24);
      default:
        return const Icon(Icons.login, size: 24);
    }
  }

  String _getDefaultText(BuildContext context) {
    final l = S.of(context);
    switch (metodo) {
      case AuthMethod.google:
        return l.authContinueWithGoogle;
      case AuthMethod.apple:
        return l.authContinueWithApple;
      case AuthMethod.facebook:
        return l.authContinueWithFacebook;
      default:
        return l.authContinue;
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (metodo) {
      case AuthMethod.google:
        return colorScheme.surface;
      case AuthMethod.apple:
        return colorScheme.onSurface;
      case AuthMethod.facebook:
        return AppColors.info;
      default:
        return colorScheme.surface;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    switch (metodo) {
      case AuthMethod.google:
        return colorScheme.onSurface;
      case AuthMethod.apple:
        return AppColors.white;
      case AuthMethod.facebook:
        return AppColors.white;
      default:
        return colorScheme.onSurface;
    }
  }
}

/// Grupo de botones de autenticación social
class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({
    super.key,
    required this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
    this.isLoading = false,
    this.loadingMethod,
    this.showApple = true,
    this.showFacebook = false,
  });

  /// Callback para Google
  final VoidCallback? onGooglePressed;

  /// Callback para Apple
  final VoidCallback? onApplePressed;

  /// Callback para Facebook
  final VoidCallback? onFacebookPressed;

  /// Estado de carga general
  final bool isLoading;

  /// Método que está cargando
  final AuthMethod? loadingMethod;

  /// Mostrar botón de Apple
  final bool showApple;

  /// Mostrar botón de Facebook
  final bool showFacebook;

  @override
  Widget build(BuildContext context) {
    final showAppleButton = showApple && Platform.isIOS;

    return Column(
      children: [
        SocialAuthButton(
          metodo: AuthMethod.google,
          onPressed: isLoading ? null : onGooglePressed,
          isLoading: isLoading && loadingMethod == AuthMethod.google,
        ),
        if (showAppleButton) ...[
          const SizedBox(height: AppSpacing.md),
          SocialAuthButton(
            metodo: AuthMethod.apple,
            onPressed: isLoading ? null : onApplePressed,
            isLoading: isLoading && loadingMethod == AuthMethod.apple,
          ),
        ],
        if (showFacebook) ...[
          const SizedBox(height: AppSpacing.md),
          SocialAuthButton(
            metodo: AuthMethod.facebook,
            onPressed: isLoading ? null : onFacebookPressed,
            isLoading: isLoading && loadingMethod == AuthMethod.facebook,
          ),
        ],
      ],
    );
  }
}
