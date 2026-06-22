library;

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Estado de error
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.message,
    this.title,
    this.icon = Icons.error_outline_rounded,
    this.onRetry,
    this.retryLabel,
  });

  final String message;
  final String? title;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l = S.of(context);
    final effectiveTitle = title ?? l.commonSomethingWentWrong;
    final effectiveRetryLabel = retryLabel ?? l.commonRetry;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: colorScheme.error),
            const SizedBox(height: 24),
            Text(
              effectiveTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(effectiveRetryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
