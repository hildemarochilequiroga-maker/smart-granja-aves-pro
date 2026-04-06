/// Widget de resumen de salud del lote
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_animations.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/salud_registro.dart';

/// Widget que muestra un resumen de salud con total y estadísticas
class SaludResumenCard extends StatelessWidget {
  const SaludResumenCard({
    super.key,
    required this.registros,
    this.onVerDetalle,
  });

  final List<SaludRegistro> registros;
  final VoidCallback? onVerDetalle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 360;

    final total = registros.length;
    final abiertos = registros.where((r) => r.estaAbierto).length;
    final cerrados = registros.where((r) => r.estaCerrado).length;

    // Color basado en estado
    final cardColor = abiertos > 0 ? AppColors.warning : AppColors.error;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cardColor, cardColor.withValues(alpha: 0.85)],
        ),
        borderRadius: AppRadius.allLg,
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header simple sin icono
          Text(
            l.saludSummaryTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),

          // Estado prominente
          Text(
            abiertos > 0
                ? l.saludActiveTreatments(abiertos)
                : l.saludAllUnderControl,
            style:
                (isSmallScreen
                        ? theme.textTheme.headlineSmall
                        : theme.textTheme.headlineMedium)
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      height: 1.1,
                    ),
          ),
          AppSpacing.gapXxs,
          Text(
            l.saludHealthStatus,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),

          SizedBox(height: isSmallScreen ? 16 : 20),

          // Estadísticas en fila centradas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ResumenItem(
                label: l.saludActive,
                value: abiertos.toString(),
                isSmallScreen: isSmallScreen,
              ),
              Container(
                width: 1,
                height: 32,
                color: AppColors.white.withValues(alpha: 0.3),
              ),
              _ResumenItem(
                label: l.saludClosedCount,
                value: cerrados.toString(),
                isSmallScreen: isSmallScreen,
              ),
              Container(
                width: 1,
                height: 32,
                color: AppColors.white.withValues(alpha: 0.3),
              ),
              _ResumenItem(
                label: l.commonTotal,
                value: total.toString(),
                isSmallScreen: isSmallScreen,
              ),
            ],
          ),
        ],
      ),
    ).summaryEntrance();
  }
}

class _ResumenItem extends StatelessWidget {
  const _ResumenItem({
    required this.label,
    required this.value,
    this.isSmallScreen = false,
  });

  final String label;
  final String value;
  final bool isSmallScreen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style:
              (isSmallScreen
                      ? theme.textTheme.titleMedium
                      : theme.textTheme.titleLarge)
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
        ),
        AppSpacing.gapXxxs,
        Text(
          label,
          style:
              (isSmallScreen
                      ? theme.textTheme.labelSmall
                      : theme.textTheme.bodySmall)
                  ?.copyWith(color: AppColors.white.withValues(alpha: 0.8)),
        ),
      ],
    );
  }
}
