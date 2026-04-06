/// Widgets de formulario comunes para galpones
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/enums/enums.dart';

/// Widget de carga
class GalponLoadingWidget extends StatelessWidget {
  final String? mensaje;

  const GalponLoadingWidget({super.key, this.mensaje});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (mensaje != null) ...[
            AppSpacing.gapBase,
            Text(
              mensaje!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget para mostrar errores
class GalponErrorWidget extends StatelessWidget {
  final String mensaje;
  final VoidCallback? onReintentar;

  const GalponErrorWidget({
    super.key,
    required this.mensaje,
    this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            AppSpacing.gapBase,
            Text(
              S.of(context).shedOccurredError,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              mensaje,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapXl,
            if (onReintentar != null)
              OutlinedButton.icon(
                onPressed: onReintentar,
                icon: const Icon(Icons.refresh),
                label: Text(S.of(context).commonRetry),
              ),
          ],
        ),
      ),
    );
  }
}

/// Badge de estado para galpones
class GalponEstadoBadge extends StatelessWidget {
  final EstadoGalpon estado;
  final bool compact;

  const GalponEstadoBadge({
    super.key,
    required this.estado,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 5,
      ),
      decoration: BoxDecoration(
        color: estado.color,
        borderRadius: AppRadius.allSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact) ...[
            Icon(estado.icon, size: 14, color: AppColors.white),
            AppSpacing.hGapXxs,
          ],
          Text(
            estado.localizedDisplayName(S.of(context)),
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
