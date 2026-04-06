library;

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Página de error genérica
class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
    this.error,
    this.onRetry,
    this.onGoHome,
  });

  final String? error;
  final VoidCallback? onRetry;
  final VoidCallback? onGoHome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l = S.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 80,
                  color: colorScheme.error,
                ),
                const SizedBox(height: 24),
                Text(
                  l.commonSomethingWentWrong,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  error ?? l.errorOccurredDefault,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (onRetry != null)
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l.commonRetry),
                  ),
                if (onRetry != null && onGoHome != null)
                  const SizedBox(height: 12),
                if (onGoHome != null)
                  OutlinedButton.icon(
                    onPressed: onGoHome,
                    icon: const Icon(Icons.home_rounded),
                    label: Text(l.commonGoHome),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
