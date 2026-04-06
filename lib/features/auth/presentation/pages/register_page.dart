/// Página de registro profesional
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

/// Página de registro mejorada
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final AnimationController _animationController;
  bool _acceptTerms = false;
  bool _isGoogleLoading = false;

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
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Animation<double> _staggered(int index) {
    return AppAnimations.staggeredAnimation(
      controller: _animationController,
      index: index,
      totalItems: 10,
      overlap: 0.5,
    );
  }

  Future<void> _handleRegister() async {
    if (!_acceptTerms) {
      _showTermsRequiredMessage();
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      await ref
          .read(authProvider.notifier)
          .registrar(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            nombre: _nombreController.text.trim().isNotEmpty
                ? _nombreController.text.trim()
                : null,
            apellido: _apellidoController.text.trim().isNotEmpty
                ? _apellidoController.text.trim()
                : null,
          );
    }
  }

  Future<void> _handleGoogleLogin() async {
    if (!_acceptTerms) {
      _showTermsRequiredMessage();
      return;
    }

    setState(() => _isGoogleLoading = true);
    try {
      await ref.read(authProvider.notifier).loginConGoogle();
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  void _showTermsRequiredMessage() {
    AppSnackBar.warning(context, message: S.of(context).authMustAcceptTerms);
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
      } else if (next is AuthAccountLinkRequired) {
        // Mostrar diálogo de vinculación de cuentas
        setState(() => _isGoogleLoading = false);
        AccountLinkingDialog.show(
          context,
          email: next.email,
          existingProvider: next.existingProvider,
          pendingCredential: next.pendingCredential,
          newProvider: next.newProvider,
        );
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
                          title: S.of(context).authCreateAccount,
                          subtitle: S.of(context).authJoinToManage,
                          onClose: () => context.pop(),
                        ),
                      ),
                    ),

                    AppSpacing.gapXxl,

                    // Google button (opción rápida)
                    FadeTransition(
                      opacity: _staggered(1),
                      child: GoogleAuthButton(
                        text: S.of(context).authSignUpWithGoogle,
                        onPressed: isLoading ? null : _handleGoogleLogin,
                        isLoading: _isGoogleLoading,
                      ),
                    ),

                    AppSpacing.gapXl,

                    // Divider
                    FadeTransition(
                      opacity: _staggered(2),
                      child: AuthDividerText(
                        text: S.of(context).authOrSignUpWithEmail,
                      ),
                    ),

                    AppSpacing.gapXl,

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Nombre y Apellido en fila
                          FadeTransition(
                            opacity: _staggered(3),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AuthTextField(
                                    controller: _nombreController,
                                    label: S.of(context).authFirstName,
                                    hint: S.of(context).authFirstNameHint,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                    enabled: !isLoading,
                                  ),
                                ),
                                AppSpacing.hGapMd,
                                Expanded(
                                  child: AuthTextField(
                                    controller: _apellidoController,
                                    label: S.of(context).authLastName,
                                    hint: S.of(context).authLastNameHint,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                    enabled: !isLoading,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          AppSpacing.gapBase,

                          // Email
                          FadeTransition(
                            opacity: _staggered(4),
                            child: AuthTextField(
                              controller: _emailController,
                              label: S.of(context).authEmail,
                              hint: S.of(context).authEmailHint,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              enabled: !isLoading,
                              validator: _validateEmail,
                            ),
                          ),

                          AppSpacing.gapBase,

                          // Password
                          FadeTransition(
                            opacity: _staggered(5),
                            child: AuthPasswordField(
                              controller: _passwordController,
                              label: S.of(context).authPassword,
                              textInputAction: TextInputAction.next,
                              enabled: !isLoading,
                              validator: _validatePassword,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),

                          // Password strength
                          if (_passwordController.text.isNotEmpty)
                            FadeTransition(
                              opacity: _staggered(5),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: AppSpacing.sm,
                                ),
                                child: PasswordStrengthIndicator(
                                  password: _passwordController.text,
                                ),
                              ),
                            ),

                          AppSpacing.gapBase,

                          // Confirm password
                          FadeTransition(
                            opacity: _staggered(6),
                            child: AuthPasswordField(
                              controller: _confirmPasswordController,
                              label: S.of(context).authConfirmPassword,
                              textInputAction: TextInputAction.done,
                              enabled: !isLoading,
                              validator: _validateConfirmPassword,
                              onSubmitted: (_) => _handleRegister(),
                            ),
                          ),

                          AppSpacing.gapXl,

                          // Terms checkbox
                          FadeTransition(
                            opacity: _staggered(7),
                            child: _buildTermsCheckbox(theme, isLoading),
                          ),

                          AppSpacing.gapXl,

                          // Register button
                          FadeTransition(
                            opacity: _staggered(8),
                            child: AuthPrimaryButton(
                              text: S.of(context).authCreateAccount,
                              onPressed: isLoading ? null : _handleRegister,
                              isLoading: isLoading && !_isGoogleLoading,
                            ),
                          ),

                          AppSpacing.gapXxl,

                          // Login link
                          FadeTransition(
                            opacity: _staggered(9),
                            child: AuthTextLink(
                              text: S.of(context).authAlreadyHaveAccountLink,
                              linkText: S.of(context).authSignInLink,
                              onTap: isLoading
                                  ? () {}
                                  : () => context.pushReplacement(
                                      AppRoutes.login,
                                    ),
                            ),
                          ),

                          SizedBox(height: bottomPadding + 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox(ThemeData theme, bool isLoading) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: _acceptTerms,
            onChanged: isLoading
                ? null
                : (value) => setState(() => _acceptTerms = value ?? false),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.allXs),
          ),
        ),
        AppSpacing.hGapMd,
        Expanded(
          child: GestureDetector(
            onTap: isLoading
                ? null
                : () => setState(() => _acceptTerms = !_acceptTerms),
            child: Text.rich(
              TextSpan(
                text: S.of(context).authAcceptTermsPrefix,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                children: [
                  TextSpan(
                    text: S.of(context).authTermsAndConditions,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: S.of(context).authAndThe),
                  TextSpan(
                    text: S.of(context).authPrivacyPolicy,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).authPasswordRequired;
    }
    if (value.length < 8) {
      return S.of(context).authMinChars;
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return S.of(context).authPasswordMustContainUpper;
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return S.of(context).authPasswordMustContainLower;
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return S.of(context).authPasswordMustContainNumber;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).authPasswordConfirmRequired;
    }
    if (value != _passwordController.text) {
      return S.of(context).authPasswordsDoNotMatch;
    }
    return null;
  }
}
