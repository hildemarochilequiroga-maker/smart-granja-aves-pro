/// Página de recuperación de contraseña profesional
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_breakpoints.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/application.dart';
import '../widgets/widgets.dart';

/// Página de recuperación de contraseña mejorada
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  late final AnimationController _animationController;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: AppAnimations.slow,
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Animation<double> _staggered(int index) {
    return AppAnimations.staggeredAnimation(
      controller: _animationController,
      index: index,
      totalItems: 4,
      overlap: 0.5,
    );
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref
          .read(authProvider.notifier)
          .enviarEmailRestablecerPassword(email: _emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthError) {
        AppSnackBar.error(context, message: next.mensaje);
      } else if (next is AuthEmailEnviado) {
        setState(() => _emailSent = true);
      }
    });

    return Scaffold(
      body: AuthBackground(
        showPattern: true,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppBreakpoints.of(context).pagePadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.gapBase,

                    // Header reutilizable
                    FadeTransition(
                      opacity: _staggered(0),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(_staggered(0)),
                        child: AuthPageHeader(
                          title: _emailSent
                              ? S.of(context).authCheckEmail
                              : S.of(context).authForgotPasswordTitle,
                          subtitle: _emailSent
                              ? S.of(context).authResetLinkSent
                              : S.of(context).authEnterEmailForReset,
                          onClose: () => context.pop(),
                        ),
                      ),
                    ),

                    AppSpacing.gapXxl,

                    // Content
                    if (_emailSent)
                      _buildSuccessContent(theme, bottomPadding)
                    else
                      _buildFormContent(theme, isLoading, bottomPadding),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(
    ThemeData theme,
    bool isLoading,
    double bottomPadding,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email
          FadeTransition(
            opacity: _staggered(2),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(_staggered(2)),
              child: AuthTextField(
                controller: _emailController,
                label: S.of(context).authEmail,
                hint: S.of(context).authEmailHint,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                enabled: !isLoading,
                validator: _validateEmail,
                onSubmitted: (_) => _handleResetPassword(),
              ),
            ),
          ),

          AppSpacing.gapXl,

          // Submit button
          FadeTransition(
            opacity: _staggered(3),
            child: AuthPrimaryButton(
              text: S.of(context).authSendInstructions,
              onPressed: isLoading ? null : _handleResetPassword,
              isLoading: isLoading,
            ),
          ),

          AppSpacing.gapXl,

          // Back to login link
          FadeTransition(
            opacity: _staggered(3),
            child: AuthTextLink(
              text: S.of(context).authRememberPassword,
              linkText: S.of(context).authSignInLink,
              onTap: isLoading ? () {} : () => context.pop(),
            ),
          ),

          SizedBox(height: bottomPadding + 24),
        ],
      ),
    );
  }

  Widget _buildSuccessContent(ThemeData theme, double bottomPadding) {
    return Column(
      children: [
        // Success illustration
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.2),
                      theme.colorScheme.primaryContainer,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.mark_email_read_rounded,
                  size: 56,
                  color: theme.colorScheme.primary,
                ),
              ),
            );
          },
        ),

        AppSpacing.gapXxl,

        // Email sent to
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.base,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.7,
            ),
            borderRadius: AppRadius.allLg,
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: AppRadius.allMd,
                ),
                child: Icon(
                  Icons.email_outlined,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
              ),
              AppSpacing.hGapBase,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).authSentTo,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    AppSpacing.gapXxxs,
                    Text(
                      _emailController.text,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        AppSpacing.gapLg,

        // Info text
        Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
            borderRadius: AppRadius.allMd,
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: theme.colorScheme.tertiary,
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: Text(
                  S.of(context).authCheckSpam,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),

        AppSpacing.gapXxl,

        // Resend button
        AuthSecondaryButton(
          text: S.of(context).authResendEmail,
          onPressed: () {
            setState(() => _emailSent = false);
          },
        ),

        AppSpacing.gapBase,

        // Back to login
        AuthPrimaryButton(
          text: S.of(context).authBackToLogin,
          onPressed: () => context.go(AppRoutes.login),
        ),

        SizedBox(height: bottomPadding + 24),
      ],
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).authEmailRequired;
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return S.of(context).authEmailInvalid;
    }
    return null;
  }
}
