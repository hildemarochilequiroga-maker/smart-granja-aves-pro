/// Card de estado del lote.
///
/// Widget modular que muestra el estado actual del lote
/// con indicadores visuales y alertas.
library;

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/lote.dart';
import '../../../domain/enums/enums.dart';

/// Card que muestra el estado actual del lote
class EstadoCard extends StatelessWidget {
  const EstadoCard({super.key, required this.lote});

  final Lote lote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: lote.estado.color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: lote.estado.color.withValues(alpha: 0.2),
                borderRadius: AppRadius.allMd,
              ),
              child: Icon(
                lote.estado.iconoData,
                color: lote.estado.color,
                size: 28,
              ),
            ),
            AppSpacing.hGapBase,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).batchBatchStatus,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.gapXxs,
                  Text(
                    lote.estado.localizedDisplayName(S.of(context)),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: lote.estado.color,
                    ),
                  ),
                ],
              ),
            ),
            if (lote.requiereAtencion)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: AppRadius.allXl,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.warning_amber,
                      size: 16,
                      color: AppColors.white,
                    ),
                    AppSpacing.hGapXxs,
                    Text(
                      S.of(context).batchAttention,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Extensión para obtener icono del estado
extension EstadoLoteIconExtension on EstadoLote {
  IconData get iconoData {
    switch (this) {
      case EstadoLote.activo:
        return Icons.check_circle;
      case EstadoLote.cerrado:
        return Icons.lock;
      case EstadoLote.cuarentena:
        return Icons.warning;
      case EstadoLote.vendido:
        return Icons.monetization_on;
      case EstadoLote.enTransferencia:
        return Icons.swap_horiz;
      case EstadoLote.suspendido:
        return Icons.pause_circle;
    }
  }

  Color get color {
    switch (this) {
      case EstadoLote.activo:
        return AppColors.success;
      case EstadoLote.cerrado:
        return AppColors.outline;
      case EstadoLote.cuarentena:
        return AppColors.warning;
      case EstadoLote.vendido:
        return AppColors.info;
      case EstadoLote.enTransferencia:
        return AppColors.purple;
      case EstadoLote.suspendido:
        return AppColors.error;
    }
  }
}
