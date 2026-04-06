/// Widget de diálogo para vincular cuentas
///
/// Se muestra cuando un usuario intenta iniciar sesión con un proveedor
/// (ej: Google) pero ya tiene una cuenta con email/password.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/providers/auth_provider.dart';
import '../../application/state/auth_state.dart';

/// Diálogo para vincular cuentas de diferentes proveedores
class AccountLinkingDialog extends ConsumerStatefulWidget {
  const AccountLinkingDialog({
    super.key,
    required this.email,
    required this.existingProvider,
    required this.pendingCredential,
    required this.newProvider,
  });

  final String email;
  final String existingProvider;
  final dynamic pendingCredential;
  final String newProvider;

  /// Muestra el diálogo de vinculación
  static Future<bool?> show(
    BuildContext context, {
    required String email,
    required String existingProvider,
    required dynamic pendingCredential,
    required String newProvider,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AccountLinkingDialog(
        email: email,
        existingProvider: existingProvider,
        pendingCredential: pendingCredential,
        newProvider: newProvider,
      ),
    );
  }

  @override
  ConsumerState<AccountLinkingDialog> createState() =>
      _AccountLinkingDialogState();
}

class _AccountLinkingDialogState extends ConsumerState<AccountLinkingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  String _getProviderDisplayName(String provider) {
    switch (provider) {
      case 'password':
        return S.of(context).authEmailPasswordProvider;
      case 'google.com':
      case 'google':
        return 'Google';
      case 'apple.com':
      case 'apple':
        return 'Apple';
      default:
        return provider;
    }
  }

  IconData _getProviderIcon(String provider) {
    switch (provider) {
      case 'password':
        return Icons.email_outlined;
      case 'google.com':
      case 'google':
        return Icons.g_mobiledata;
      case 'apple.com':
      case 'apple':
        return Icons.apple;
      default:
        return Icons.account_circle_outlined;
    }
  }

  Color _getProviderColor(String provider, ColorScheme colorScheme) {
    switch (provider) {
      case 'google.com':
      case 'google':
        return AppColors.error;
      case 'apple.com':
      case 'apple':
        return colorScheme.onSurface;
      default:
        return AppColors.primary;
    }
  }

  Future<void> _handleLink() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    await ref
        .read(authProvider.notifier)
        .loginParaVincular(
          email: widget.email,
          password: _passwordController.text,
          pendingCredential: widget.pendingCredential,
          newProvider: widget.newProvider,
        );

    // El resultado se manejará en el listener de abajo
  }

  void _handleCancel() {
    ref.read(authProvider.notifier).cancelarVinculacion();
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Escuchar cambios de estado
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthLinkingSuccess) {
        Navigator.of(context).pop(true);
        AppSnackBar.success(
          context,
          message: S
              .of(context)
              .authLinkSuccess(_getProviderDisplayName(next.linkedProvider)),
        );
      } else if (next is AuthAuthenticated) {
        // Si llegó a authenticated sin linking success, es que ya se vinculó
        Navigator.of(context).pop(true);
      } else if (next is AuthError) {
        setState(() => _isLoading = false);
        AppSnackBar.error(context, message: next.mensaje);
      }
    });

    final isLinking = authState is AuthLinkingInProgress;
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icono de vinculación
              Container(
                padding: const EdgeInsets.all(AppSpacing.base),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.link,
                  size: 48,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Título
              Text(
                S.of(context).authLinkAccounts,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),

              // Descripción
              Text(
                S
                    .of(context)
                    .authLinkAccountMessage(
                      _getProviderDisplayName(widget.existingProvider),
                      _getProviderDisplayName(widget.newProvider),
                    ),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Email
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.base,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.onSurface.withValues(alpha: 0.05),
                  borderRadius: AppRadius.allMd,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.email_outlined, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        widget.email,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.base),

              // Indicador visual de vinculación
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ProviderChip(
                    icon: _getProviderIcon(widget.existingProvider),
                    label: _getProviderDisplayName(widget.existingProvider),
                    color: _getProviderColor(
                      widget.existingProvider,
                      colorScheme,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: Icon(Icons.add, size: 20),
                  ),
                  _ProviderChip(
                    icon: _getProviderIcon(widget.newProvider),
                    label: _getProviderDisplayName(widget.newProvider),
                    color: _getProviderColor(widget.newProvider, colorScheme),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Formulario de contraseña
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  enabled: !_isLoading && !isLinking,
                  decoration: InputDecoration(
                    labelText: S.of(context).authCurrentPassword,
                    hintText: S.of(context).authEnterPassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    border: OutlineInputBorder(borderRadius: AppRadius.allMd),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).authEnterPassword;
                    }
                    if (value.length < 6) {
                      return S.of(context).authPasswordMinLengthSix;
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _handleLink(),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading || isLinking ? null : _handleCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.allMd,
                        ),
                      ),
                      child: Text(S.of(context).commonCancel),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isLoading || isLinking ? null : _handleLink,
                      style: FilledButton.styleFrom(
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.allMd,
                        ),
                      ),
                      child: _isLoading || isLinking
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : Text(S.of(context).authLinkButton),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chip para mostrar un proveedor
class _ProviderChip extends StatelessWidget {
  const _ProviderChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.allXl,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
