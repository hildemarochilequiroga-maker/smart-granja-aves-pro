/// Estado de error para ventas
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';

/// Widget para mostrar estado de error en la lista de ventas
class VentasErrorState extends StatelessWidget {
  const VentasErrorState({super.key, required this.mensaje, this.onRetry});

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
                _buildDescription(theme, isSmallScreen),
                SizedBox(height: isSmallScreen ? 24 : 32),
                if (onRetry != null) _buildRetryButton(context, isSmallScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration(ThemeData theme, bool isSmallScreen) {
    final size = isSmallScreen ? 80.0 : 100.0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.error_outline_rounded,
          size: size * 0.6,
          color: AppColors.error,
        ),
      ),
    );
  }

  Widget _buildTitle(
    BuildContext context,
    ThemeData theme,
    bool isSmallScreen,
  ) {
    final l = S.of(context);
    return Text(
      l.ventaLoadError,
      style:
          (isSmallScreen
                  ? theme.textTheme.titleLarge
                  : theme.textTheme.headlineSmall)
              ?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription(ThemeData theme, bool isSmallScreen) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isSmallScreen ? 260 : 300),
      child: Text(
        mensaje,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context, bool isSmallScreen) {
    return FilledButton.icon(
      onPressed: onRetry,
      icon: const Icon(Icons.refresh_rounded),
      label: Text(S.of(context).commonRetry),
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 24,
          vertical: isSmallScreen ? 10 : 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      ),
    );
  }
}
