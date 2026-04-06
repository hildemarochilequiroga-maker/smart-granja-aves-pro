/// Estados de error para la lista de lotes.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// Widget de estado de error para lotes
class LotesErrorState extends StatelessWidget {
  const LotesErrorState({super.key, required this.mensaje, this.onRetry});

  final String mensaje;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 360;
    final padding = isSmallScreen ? 24.0 : 32.0;

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIllustration(theme, isSmallScreen),
                SizedBox(height: isSmallScreen ? 16 : 24),
                _buildTitle(context, theme, isSmallScreen),
                SizedBox(height: isSmallScreen ? 8 : 12),
                _buildMessage(theme, isSmallScreen),
                if (onRetry != null) ...[
                  SizedBox(height: isSmallScreen ? 24 : 32),
                  _buildRetryButton(context, theme, isSmallScreen),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration(ThemeData theme, bool isSmallScreen) {
    final size = isSmallScreen ? 80.0 : 100.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.error_outline_rounded,
        size: size * 0.48,
        color: theme.colorScheme.error.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildTitle(
    BuildContext context,
    ThemeData theme,
    bool isSmallScreen,
  ) {
    return Text(
      S.of(context).commonErrorLoading,
      style:
          (isSmallScreen
                  ? theme.textTheme.titleLarge
                  : theme.textTheme.headlineSmall)
              ?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage(ThemeData theme, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 16),
      child: Text(
        mensaje,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.5,
          fontSize: isSmallScreen ? 13 : null,
        ),
        textAlign: TextAlign.center,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildRetryButton(
    BuildContext context,
    ThemeData theme,
    bool isSmallScreen,
  ) {
    final iconSize = isSmallScreen ? 16.0 : 18.0;

    return Semantics(
      button: true,
      label: S.of(context).batchRetryLoadSemantics,
      child: SizedBox(
        height: 48,
        child: OutlinedButton.icon(
          onPressed: () {
            HapticFeedback.mediumImpact();
            onRetry?.call();
          },
          icon: Icon(Icons.refresh_rounded, size: iconSize),
          label: Text(
            S.of(context).commonRetry,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            side: BorderSide(color: theme.colorScheme.primary),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
          ),
        ),
      ),
    );
  }
}
