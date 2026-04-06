/// Step 3: Resumen, observaciones y confirmación de la inspección
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/inspeccion_bioseguridad.dart';
import '../../../domain/enums/enums.dart';

/// Step de resumen y observaciones finales.
class ObservacionesFirmaStep extends StatelessWidget {
  const ObservacionesFirmaStep({
    super.key,
    required this.inspeccion,
    required this.observacionesController,
    required this.accionesCorrectivasController,
    required this.autoValidate,
  });

  final InspeccionBioseguridad inspeccion;
  final TextEditingController observacionesController;
  final TextEditingController accionesCorrectivasController;
  final bool autoValidate;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Encabezado ───
          Text(
            l.bioSummaryTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.gapXs,
          Text(
            l.bioSummarySubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapXl,

          // ─── Score + Nivel de riesgo ───
          _buildScoreSection(theme, l),
          AppSpacing.gapBase,

          // ─── Contadores ───
          _buildCounters(theme, l),
          AppSpacing.gapLg,

          // ─── Alertas ───
          if (inspeccion.tieneIncumplimientosCriticos) ...[
            _buildAlertaCriticos(theme, l),
            AppSpacing.gapBase,
          ],
          if (inspeccion.itemsPendientes > 0) ...[
            _buildPendientesCard(theme, l),
            AppSpacing.gapBase,
          ],

          // ─── Observaciones ───
          AppSpacing.gapSm,
          _buildTextField(
            context,
            theme,
            label: l.bioSummaryGeneralObs,
            controller: observacionesController,
            hint: l.bioSummaryGeneralObsHint,
          ),
          AppSpacing.gapLg,

          // ─── Acciones correctivas ───
          _buildTextField(
            context,
            theme,
            label: l.bioSummaryCorrectiveActions,
            controller: accionesCorrectivasController,
            hint: l.bioSummaryCorrectiveHint,
            showBadge:
                inspeccion.itemsNoCumplen > 0 || inspeccion.itemsParciales > 0,
          ),
          AppSpacing.gapXl,

          // ─── Nota informativa ───
          Text(
            l.bioSummaryNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Score + riesgo ─────────────────────────────────────

  Widget _buildScoreSection(ThemeData theme, S l) {
    final porcentaje = inspeccion.porcentajeCumplimiento;
    final nivel = inspeccion.nivelRiesgo;
    final color = _getRiesgoColor(nivel);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: AppRadius.allMd,
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          // Porcentaje
          Text(
            '${porcentaje.toStringAsFixed(0)}%',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          AppSpacing.hGapBase,
          // Separador
          Container(width: 1, height: 44, color: color.withValues(alpha: 0.2)),
          AppSpacing.hGapBase,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getCalificacionTexto(porcentaje, l),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.bioSummaryRisk(
                    nivel.displayName,
                    inspeccion.itemsEvaluables,
                    inspeccion.totalItems,
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Contadores ─────────────────────────────────────────

  Widget _buildCounters(ThemeData theme, S l) {
    return Row(
      children: [
        _counterChip(
          theme,
          inspeccion.itemsCumplen,
          l.bioSummaryCumple,
          AppColors.success,
        ),
        AppSpacing.hGapSm,
        _counterChip(
          theme,
          inspeccion.itemsParciales,
          l.bioSummaryParcial,
          AppColors.warning,
        ),
        AppSpacing.hGapSm,
        _counterChip(
          theme,
          inspeccion.itemsNoCumplen,
          l.bioSummaryNoCumple,
          AppColors.error,
        ),
      ],
    );
  }

  Widget _counterChip(ThemeData theme, int count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: AppRadius.allMd,
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Alertas ────────────────────────────────────────────

  Widget _buildAlertaCriticos(ThemeData theme, S l) {
    final itemsCriticosNoCumplen = inspeccion.items
        .where((i) => i.esCritico && i.estado == EstadoBioseguridad.noCumple)
        .toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        borderRadius: AppRadius.allMd,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.bioSummaryCriticalItems,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.error,
            ),
          ),
          AppSpacing.gapSm,
          ...itemsCriticosNoCumplen.map(
            (item) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.codigo}  ',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.error,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.descripcion,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendientesCard(ThemeData theme, S l) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.06),
        borderRadius: AppRadius.allMd,
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.bioSummaryPendingItems(inspeccion.itemsPendientes),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.bioSummaryPendingNote,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Campos de texto ────────────────────────────────────

  Widget _buildTextField(
    BuildContext context,
    ThemeData theme, {
    required String label,
    required TextEditingController controller,
    required String hint,
    bool showBadge = false,
  }) {
    final l = S.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (showBadge) ...[
              AppSpacing.hGapSm,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: AppRadius.allXs,
                ),
                child: Text(
                  l.bioSummaryRecommended,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        AppSpacing.gapSm,
        TextFormField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: cs.surface,
            border: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
      ],
    );
  }

  // ─── Helpers ────────────────────────────────────────────

  Color _getRiesgoColor(NivelRiesgoBioseguridad nivel) {
    switch (nivel) {
      case NivelRiesgoBioseguridad.bajo:
        return AppColors.success;
      case NivelRiesgoBioseguridad.medio:
        return AppColors.warning;
      case NivelRiesgoBioseguridad.alto:
        return AppColors.error;
      case NivelRiesgoBioseguridad.critico:
        return AppColors.purple;
    }
  }

  String _getCalificacionTexto(double porcentaje, S l) {
    if (porcentaje >= 90) return l.bioRatingExcellent;
    if (porcentaje >= 80) return l.bioRatingVeryGood;
    if (porcentaje >= 70) return l.bioRatingGood;
    if (porcentaje >= 60) return l.bioRatingAcceptable;
    if (porcentaje >= 50) return l.bioRatingRegular;
    return l.bioRatingPoor;
  }
}
