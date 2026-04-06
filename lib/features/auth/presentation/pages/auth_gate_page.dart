/// Pantalla de puerta de autenticación
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_animations.dart';
import '../../application/application.dart';
import '../widgets/widgets.dart';
import 'package:smartgranjaavespro/core/theme/app_radius.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../core/widgets/app_snackbar.dart';

/// Pantalla de opciones de autenticación
class AuthGatePage extends ConsumerStatefulWidget {
  const AuthGatePage({super.key});

  @override
  ConsumerState<AuthGatePage> createState() => _AuthGatePageState();
}

class _AuthGatePageState extends ConsumerState<AuthGatePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
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

    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.slow,
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _createStaggeredAnimation(int index) {
    return AppAnimations.staggeredAnimation(
      controller: _controller,
      index: index,
      totalItems: 2,
      overlap: 0.4,
    );
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);

    try {
      await ref.read(authProvider.notifier).loginConGoogle();
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading || _isGoogleLoading;

    // Escuchar cambios de estado para mostrar errores
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
      // La navegación a home se maneja automáticamente por el router
    });

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Logo + Nombre centrado verticalmente
                FadeTransition(
                  opacity: _createStaggeredAnimation(0),
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.9,
                      end: 1.0,
                    ).animate(_createStaggeredAnimation(0)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLogo(theme),
                        const SizedBox(height: 16),
                        Text(
                          'Smart Granja Aves',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'PRO',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Formulario y botones
                FadeTransition(
                  opacity: _createStaggeredAnimation(1),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(_createStaggeredAnimation(1)),
                    child: Column(
                      children: [
                        // Subtítulo descriptivo
                        Text(
                          S.of(context).authGateManageSmartly,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Botón principal - Crear cuenta (CTA primario)
                        AuthPrimaryButton(
                          text: S.of(context).authCreateAccount,
                          onPressed: isLoading
                              ? null
                              : () => context.push(AppRoutes.register),
                        ),

                        const SizedBox(height: 12),

                        // Botón secundario - Iniciar sesión
                        AuthSecondaryButton(
                          text: S.of(context).authAlreadyHaveAccount,
                          onPressed: isLoading
                              ? null
                              : () => context.push(AppRoutes.login),
                        ),

                        const SizedBox(height: 20),

                        // Divisor
                        AuthDividerText(text: S.of(context).authOrContinueWith),

                        const SizedBox(height: 20),

                        // Botón Google - Opción rápida
                        GoogleAuthButton(
                          onPressed: isLoading ? null : _handleGoogleSignIn,
                          isLoading: _isGoogleLoading,
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(ThemeData theme) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: AppRadius.allXl,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.allXl,
        child: Image.asset(
          AppAssets.logoIcon,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.agriculture,
            size: 40,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
