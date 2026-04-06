/// Widget de resumen de vacunaciones del lote
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/vacunacion.dart';

/// Widget que muestra el resumen de vacunaciones (total, aplicadas, pendientes, vencidas)
class VacunacionResumenCard extends StatelessWidget {
  const VacunacionResumenCard({
    super.key,
    required this.vacunaciones,
    this.onVerDetalle,
  });

  final List<Vacunacion> vacunaciones;
  final VoidCallback? onVerDetalle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final colorScheme = theme.colorScheme;

    // Calcular estadísticas
    final total = vacunaciones.length;
    final aplicadas = vacunaciones.where((v) => v.fueAplicada).length;
    final pendientes = vacunaciones
        .where((v) => v.estaPendiente && !v.estaVencida)
        .length;
    final vencidas = vacunaciones.where((v) => v.estaVencida).length;
    final proximas = vacunaciones.where((v) => v.esProxima).length;

    // Color del gradiente basado en estado
    Color gradientColor;
    if (vencidas > 0) {
      gradientColor = AppColors.error;
    } else if (proximas > 0) {
      gradientColor = AppColors.warning;
    } else {
      gradientColor = theme.colorScheme.primary;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [gradientColor, gradientColor.withValues(alpha: 0.85)],
        ),
        borderRadius: AppRadius.allLg,
        boxShadow: [
          BoxShadow(
            color: gradientColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.allLg,
          onTap: onVerDetalle,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título y badge
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.vacSummaryTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxxs),
                          Text(
                            _getStatusMessage(
                              l,
                              vencidas,
                              proximas,
                              pendientes,
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (vencidas > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: AppRadius.allMd,
                        ),
                        child: Text(
                          l.vacSummaryExpiredBadge(vencidas),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else if (proximas > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: AppRadius.allMd,
                        ),
                        child: Text(
                          l.vacSummaryUpcomingBadge(proximas),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.warningDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Estadísticas
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        theme,
                        l.commonTotal,
                        total.toString(),
                      ),
                    ),
                    _buildDivider(colorScheme),
                    Expanded(
                      child: _buildStatItem(
                        theme,
                        l.vacSummaryApplied,
                        aplicadas.toString(),
                      ),
                    ),
                    _buildDivider(colorScheme),
                    Expanded(
                      child: _buildStatItem(
                        theme,
                        l.vacFilterPending,
                        pendientes.toString(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getStatusMessage(S l, int vencidas, int proximas, int pendientes) {
    if (vencidas > 0) {
      return l.vacSummaryExpiredWarning;
    } else if (proximas > 0) {
      return l.vacSummaryUpcomingWarning;
    } else if (pendientes > 0) {
      return l.vacSummaryUpToDate;
    } else {
      return l.vacSummaryAllApplied;
    }
  }

  Widget _buildStatItem(ThemeData theme, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.xxxs),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Container(
      width: 1,
      height: 50,
      color: AppColors.white.withValues(alpha: 0.3),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
    );
  }
}
