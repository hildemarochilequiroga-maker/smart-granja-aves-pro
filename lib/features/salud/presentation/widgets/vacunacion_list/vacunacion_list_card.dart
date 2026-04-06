/// Card moderna para mostrar una vacunación en la lista
/// Diseño basado en historial de mortalidad
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_animations.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../domain/entities/vacunacion.dart';

/// Tarjeta moderna para mostrar una vacunación en la lista
class VacunacionListCard extends StatelessWidget {
  const VacunacionListCard({
    super.key,
    required this.vacunacion,
    required this.onTap,
    this.onAplicar,
    this.onEliminar,
  });

  final Vacunacion vacunacion;
  final VoidCallback onTap;
  final VoidCallback? onAplicar;
  final VoidCallback? onEliminar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final colorScheme = theme.colorScheme;
    final statusInfo = _getStatusInfo(l);
    final fechaFormat = Formatters.fechaCompletaEs.format(
      vacunacion.fechaProgramada,
    );
    final fechaCapitalizada =
        fechaFormat[0].toUpperCase() + fechaFormat.substring(1);

    return Semantics(
      button: true,
      label: l.semanticsVaccination(
        vacunacion.nombreVacuna,
        fechaCapitalizada,
        statusInfo.label,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppRadius.allMd,
          border: Border.all(color: statusInfo.color, width: 2),
          boxShadow: [
            BoxShadow(
              color: colorScheme.onSurface.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.allMd,
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              onTap();
            },
            borderRadius: AppRadius.allMd,
            splashColor: statusInfo.color.withValues(alpha: 0.1),
            highlightColor: statusInfo.color.withValues(alpha: 0.05),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Primera fila: Fecha + Badge de estado
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fechaCapitalizada,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                Formatters.hora12Es.format(
                                  vacunacion.fechaProgramada,
                                ),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              if (vacunacion.fechaAplicacion != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  l.vacCardAppliedDate(
                                    Formatters.fechaDDMMYYYY.format(
                                      vacunacion.fechaAplicacion!,
                                    ),
                                  ),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusInfo.color,
                            borderRadius: AppRadius.allSm,
                          ),
                          child: Text(
                            statusInfo.label,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Nombre de vacuna
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: l.vacCardVaccinePrefix,
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          TextSpan(
                            text: vacunacion.nombreVacuna,
                            style: TextStyle(
                              color: statusInfo.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Dosis (si existe)
                    if (vacunacion.dosis != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: l.vacCardDosisPrefix,
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextSpan(
                              text: vacunacion.dosis!,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Vía (si existe)
                    if (vacunacion.via != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: l.vacCardRoutePrefix,
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextSpan(
                              text: vacunacion.via!,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Días restantes o vencidos (si aplica)
                    if (!vacunacion.fueAplicada &&
                        vacunacion.diasHastaProgramada != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: vacunacion.estaVencida
                                  ? l.vacCardExpiredAgo
                                  : l.vacCardDaysLeft,
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextSpan(
                              text: vacunacion.estaVencida
                                  ? l.vacCardDays(
                                      vacunacion.diasHastaProgramada!.abs(),
                                    )
                                  : l.vacCardDays(
                                      vacunacion.diasHastaProgramada!,
                                    ),
                              style: TextStyle(
                                color: vacunacion.estaVencida
                                    ? AppColors.error
                                    : vacunacion.esProxima
                                    ? AppColors.warning
                                    : theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).cardEntrance();
  }

  ({Color color, String label}) _getStatusInfo(S l) {
    if (vacunacion.fueAplicada) {
      return (color: AppColors.success, label: l.vacCardStatusApplied);
    } else if (vacunacion.estaVencida) {
      return (color: AppColors.error, label: l.vacCardStatusExpired);
    } else if (vacunacion.esProxima) {
      return (color: AppColors.warning, label: l.vacCardStatusUpcoming);
    } else {
      return (color: AppColors.info, label: l.vacCardStatusPending);
    }
  }
}
