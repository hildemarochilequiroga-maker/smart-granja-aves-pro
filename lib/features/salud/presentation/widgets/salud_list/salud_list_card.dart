/// Card moderna para mostrar un registro de salud en la lista
/// Diseño basado en VentaListCard
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_animations.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../domain/entities/salud_registro.dart';

/// Tarjeta moderna para mostrar un registro de salud en la lista
class SaludListCard extends StatelessWidget {
  const SaludListCard({
    super.key,
    required this.registro,
    required this.onTap,
    this.onCerrar,
    this.onEliminar,
  });

  final SaludRegistro registro;
  final VoidCallback onTap;
  final VoidCallback? onCerrar;
  final VoidCallback? onEliminar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final estadoColor = _getEstadoColor();
    final fechaFormat = Formatters.fechaCompletaEs.format(registro.fecha);
    final fechaCapitalizada =
        fechaFormat[0].toUpperCase() + fechaFormat.substring(1);

    return Semantics(
      button: true,
      label: l.semanticsHealthRecord(
        registro.diagnostico,
        fechaCapitalizada,
        registro.estaAbierto ? l.semanticsStatusOpen : l.semanticsStatusClosed,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.allMd,
          border: Border.all(color: estadoColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
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
            splashColor: estadoColor.withValues(alpha: 0.1),
            highlightColor: estadoColor.withValues(alpha: 0.05),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Primera fila: Fecha/Hora + Badge de estado
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
                              AppSpacing.gapXxxs,
                              Text(
                                Formatters.hora12Es.format(registro.fecha),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.hGapSm,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: estadoColor,
                            borderRadius: AppRadius.allSm,
                          ),
                          child: Text(
                            registro.estaAbierto
                                ? l.saludCardActive
                                : l.saludCardClosed,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Diagnóstico
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: l.saludCardDiagnosisPrefix,
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          TextSpan(
                            text: registro.diagnostico,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    AppSpacing.gapXs,

                    // Tratamiento
                    if (registro.tratamiento != null)
                      RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: l.saludCardTreatmentPrefix,
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextSpan(
                              text: _getTratamientoResumen(l),
                              style: const TextStyle(
                                color: AppColors.info,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).cardEntrance();
  }

  String _getTratamientoResumen(S l) {
    final tratamiento = registro.tratamiento ?? '';
    final dias = registro.diasTratamiento;
    if (dias != null && dias > 0) {
      return '$tratamiento \u2022 ${l.saludCardDays(dias)}';
    }
    return tratamiento;
  }

  Color _getEstadoColor() {
    if (registro.estaAbierto) {
      return AppColors.warning;
    } else {
      return AppColors.success;
    }
  }
}
