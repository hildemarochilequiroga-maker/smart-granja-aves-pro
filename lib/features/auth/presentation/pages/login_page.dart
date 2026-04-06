/// Página de inicio de sesión profesional
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_breakpoints.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/application.dart';
import '../widgets/widgets.dart';

/// Página de inicio de sesión mejorada
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AnimationController _animationController;
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
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Animation<double> _staggered(int index) {
    return AppAnimations.staggeredAnimation(
      controller: _animationController,
      index: index,
      totalItems: 7,
      overlap: 0.5,
    );
  }

  Future<void> _handleEmailLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref
          .read(authProvider.notifier)
          .loginConEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isGoogleLoading = true);
    try {
      await ref.read(authProvider.notifier).loginConGoogle();
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          title: S.of(context).authWelcomeBack,
                          subtitle: S.of(context).authEnterCredentials,
                          onClose: () => context.pop(),
                        ),
                      ),
                    ),

                    AppSpacing.gapXxl,

                    // Google button (opción rápida)
                    FadeTransition(
                      opacity: _staggered(1),
                      child: GoogleAuthButton(
                        onPressed: isLoading ? null : _handleGoogleLogin,
                        isLoading: _isGoogleLoading,
                      ),
                    ),

                    AppSpacing.gapXl,

                    // Divider
                    FadeTransition(
                      opacity: _staggered(2),
                      child: AuthDividerText(
                        text: S.of(context).authOrSignInWithEmail,
                      ),
                    ),

                    AppSpacing.gapXl,

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email
                          FadeTransition(
                            opacity: _staggered(3),
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
                            opacity: _staggered(4),
                            child: AuthPasswordField(
                              controller: _passwordController,
                              textInputAction: TextInputAction.done,
                              enabled: !isLoading,
                              validator: _validatePassword,
                              onSubmitted: (_) => _handleEmailLogin(),
                            ),
                          ),

                          AppSpacing.gapLg,

                          // Login button
                          FadeTransition(
                            opacity: _staggered(5),
                            child: AuthPrimaryButton(
                              text: S.of(context).authSignIn,
                              onPressed: isLoading ? null : _handleEmailLogin,
                              isLoading: isLoading && !_isGoogleLoading,
                            ),
                          ),

                          AppSpacing.gapMd,

                          // Forgot password - Botón outline estilo Wialon
                          FadeTransition(
                            opacity: _staggered(5),
                            child: AuthOutlinedLinkButton(
                              text: S.of(context).authForgotPassword,
                              onPressed: isLoading
                                  ? null
                                  : () =>
                                        context.push(AppRoutes.forgotPassword),
                            ),
                          ),

                          AppSpacing.gapXxl,

                          // Register link
                          FadeTransition(
                            opacity: _staggered(6),
                            child: AuthTextLink(
                              text: S.of(context).authNoAccount,
                              linkText: S.of(context).authSignUp,
                              onTap: isLoading
                                  ? () {}
                                  : () => context.pushReplacement(
                                      AppRoutes.register,
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
      return S.of(context).authPasswordMinLength;
    }
    return null;
  }
}
