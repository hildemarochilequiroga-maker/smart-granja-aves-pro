library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import 'password_strength_indicator.dart';

/// Constantes de validación locales para el formulario de auth
abstract final class _FormValidation {
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const int passwordMinLength = 8;
}

/// Formulario de inicio de sesión con email
class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onSubmit,
    this.initialEmail,
    this.isLoading = false,
    this.onForgotPassword,
  });

  /// Callback al enviar el formulario
  final void Function(String email, String password) onSubmit;

  /// Email inicial
  final String? initialEmail;

  /// Estado de carga
  final bool isLoading;

  /// Callback para "Olvidé mi contraseña"
  final VoidCallback? onForgotPassword;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberEmail = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialEmail != null) {
      _emailController.text = widget.initialEmail!;
      _rememberEmail = true;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(_emailController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: l.authEmail,
              hintText: l.authEmailHint,
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(borderRadius: AppRadius.allSm),
            ),
            validator: _validateEmail,
          ),

          const SizedBox(height: AppSpacing.md),

          // Contraseña
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: l.authPassword,
              hintText: '••••••••',
              prefixIcon: const Icon(Icons.lock_outlined),
              border: OutlineInputBorder(borderRadius: AppRadius.allSm),
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
            ),
            validator: _validatePassword,
            onFieldSubmitted: (_) => _submit(),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Recordar email y Olvidé mi contraseña
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _rememberEmail,
                      onChanged: widget.isLoading
                          ? null
                          : (value) {
                              setState(() => _rememberEmail = value ?? false);
                            },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(l.authRememberEmail, style: theme.textTheme.bodySmall),
                ],
              ),
              if (widget.onForgotPassword != null)
                TextButton(
                  onPressed: widget.isLoading ? null : widget.onForgotPassword,
                  child: Text(
                    l.authForgotPasswordTitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // Botón de inicio de sesión
          FilledButton(
            onPressed: widget.isLoading ? null : _submit,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: widget.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                : Text(l.authSignIn),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    final l = S.of(context);
    if (value == null || value.isEmpty) {
      return l.authEmailRequired;
    }
    if (!RegExp(_FormValidation.emailPattern).hasMatch(value)) {
      return l.authEmailInvalid;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final l = S.of(context);
    if (value == null || value.isEmpty) {
      return l.authPasswordRequired;
    }
    if (value.length < _FormValidation.passwordMinLength) {
      return l.authPasswordMinLengthN(
        _FormValidation.passwordMinLength.toString(),
      );
    }
    return null;
  }
}

/// Formulario de registro
class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  /// Callback al enviar el formulario
  final void Function({
    required String email,
    required String password,
    String? nombre,
    String? apellido,
  })
  onSubmit;

  /// Estado de carga
  final bool isLoading;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_acceptTerms) {
      AppSnackBar.warning(context, message: S.of(context).authMustAcceptTerms);
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(
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

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Nombre
          TextFormField(
            controller: _nombreController,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: l.authFirstName,
              hintText: l.authFirstNameHint,
              prefixIcon: const Icon(Icons.person_outlined),
              border: OutlineInputBorder(borderRadius: AppRadius.allSm),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Apellido
          TextFormField(
            controller: _apellidoController,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: l.authLastName,
              hintText: l.authLastNameHint,
              prefixIcon: const Icon(Icons.badge_outlined),
              border: OutlineInputBorder(borderRadius: AppRadius.allSm),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: l.authEmail,
              hintText: l.authEmailHint,
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(borderRadius: AppRadius.allSm),
            ),
            validator: _validateEmail,
          ),

          const SizedBox(height: AppSpacing.md),

          // Contraseña
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: l.authPassword,
              hintText: '••••••••',
              prefixIcon: const Icon(Icons.lock_outlined),
              border: OutlineInputBorder(borderRadius: AppRadius.allSm),
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
            ),
            validator: _validatePassword,
            onChanged: (_) => setState(() {}),
          ),

          // Indicador de fortaleza
          if (_passwordController.text.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            PasswordStrengthIndicator(password: _passwordController.text),
          ],

          const SizedBox(height: AppSpacing.md),

          // Confirmar contraseña
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: l.authConfirmPassword,
              hintText: '••••••••',
              prefixIcon: const Icon(Icons.lock_outlined),
              border: OutlineInputBorder(borderRadius: AppRadius.allSm),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  );
                },
              ),
            ),
            validator: _validateConfirmPassword,
            onFieldSubmitted: (_) => _submit(),
          ),

          const SizedBox(height: AppSpacing.md),

          // Términos y condiciones
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: _acceptTerms,
                  onChanged: widget.isLoading
                      ? null
                      : (value) {
                          setState(() => _acceptTerms = value ?? false);
                        },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: l.authAcceptTermsPrefix,
                    style: theme.textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: l.authTermsAndConditions,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: l.authAndThe),
                      TextSpan(
                        text: l.authPrivacyPolicy,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Botón de registro
          FilledButton(
            onPressed: widget.isLoading ? null : _submit,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: widget.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                : Text(l.authCreateAccount),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    final l = S.of(context);
    if (value == null || value.isEmpty) {
      return l.authEmailRequired;
    }
    if (!RegExp(_FormValidation.emailPattern).hasMatch(value)) {
      return l.authEmailInvalid;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final l = S.of(context);
    if (value == null || value.isEmpty) {
      return l.authPasswordRequired;
    }
    if (value.length < _FormValidation.passwordMinLength) {
      return l.authPasswordMinLengthValidator(
        _FormValidation.passwordMinLength,
      );
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return l.authPasswordMustContainUpper;
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return l.authPasswordMustContainLower;
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return l.authPasswordMustContainNumber;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final l = S.of(context);
    if (value == null || value.isEmpty) {
      return l.authPasswordConfirmRequired;
    }
    if (value != _passwordController.text) {
      return l.authPasswordsDoNotMatch;
    }
    return null;
  }
}

/// Formulario para recuperar contraseña
class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  /// Callback al enviar el formulario
  final void Function(String email) onSubmit;

  /// Estado de carga
  final bool isLoading;

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: l.authEmail,
              hintText: l.authEmailHint,
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(borderRadius: AppRadius.allSm),
            ),
            validator: _validateEmail,
            onFieldSubmitted: (_) => _submit(),
          ),

          const SizedBox(height: AppSpacing.lg),

          FilledButton(
            onPressed: widget.isLoading ? null : _submit,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: widget.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                : Text(l.authSendInstructions),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    final l = S.of(context);
    if (value == null || value.isEmpty) {
      return l.authEmailRequired;
    }
    if (!RegExp(_FormValidation.emailPattern).hasMatch(value)) {
      return l.authEmailInvalid;
    }
    return null;
  }
}
