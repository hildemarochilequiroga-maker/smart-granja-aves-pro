/// Step 1: Selección de Galpón para Inspección
/// La granja ya viene predeterminada desde la navegación.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../galpones/application/providers/galpon_providers.dart';
import '../../../../galpones/domain/entities/galpon.dart';
import '../../../../granjas/domain/entities/granja.dart';

/// Step de selección de galpón (la granja ya es conocida).
class GranjaGalponStep extends ConsumerWidget {
  const GranjaGalponStep({
    super.key,
    required this.granjas,
    required this.granjaSeleccionada,
    required this.galponSeleccionado,
    required this.onGranjaChanged,
    required this.onGalponChanged,
    required this.inspectorNombre,
    required this.fechaInspeccion,
    required this.autoValidate,
  });

  final List<Granja> granjas;
  final Granja? granjaSeleccionada;
  final Galpon? galponSeleccionado;
  final void Function(Granja?) onGranjaChanged;
  final void Function(Galpon?) onGalponChanged;
  final String inspectorNombre;
  final DateTime fechaInspeccion;
  final bool autoValidate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = S.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final List<Galpon> galpones = granjaSeleccionada != null
        ? ref
                  .watch(galponesStreamProvider(granjaSeleccionada!.id))
                  .valueOrNull ??
              []
        : [];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Encabezado ───
          Text(
            l.bioInspectionStepLocation,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.gapXs,
          Text(
            l.bioStepSelectLocationHint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 28),

          // ─── Info compacta: Granja · Inspector · Fecha ───
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLowest,
              borderRadius: AppRadius.allMd,
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              children: [
                _infoRow(
                  theme,
                  l.commonFarm,
                  granjaSeleccionada?.nombre ?? '—',
                ),
                Divider(
                  height: 20,
                  color: cs.outlineVariant.withValues(alpha: 0.3),
                ),
                _infoRow(theme, l.bioStepInspector, inspectorNombre),
                Divider(
                  height: 20,
                  color: cs.outlineVariant.withValues(alpha: 0.3),
                ),
                _infoRow(theme, l.bioStepDate, _formatDate(fechaInspeccion, l)),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ─── Selector de galpón ───
          Text(
            l.bioStepGalpon,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            l.bioStepGalponHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),

          if (granjaSeleccionada == null)
            _emptyMessage(theme, l.commonLoading)
          else if (galpones.isEmpty)
            _emptyMessage(theme, l.bioStepNoGalpones)
          else
            _buildGalponChips(context, theme, galpones),
        ],
      ),
    );
  }

  // ─── Helpers ────────────────────────────────────────────

  Widget _infoRow(ThemeData theme, String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGalponChips(BuildContext context, ThemeData theme, List<Galpon> galpones) {
    final l = S.of(context);
    final cs = theme.colorScheme;
    final isGeneral = galponSeleccionado == null;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Opción "General"
        ChoiceChip(
          label: Text(l.bioStepWholeGranja),
          selected: isGeneral,
          onSelected: (_) => onGalponChanged(null),
          selectedColor: cs.primaryContainer,
          labelStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: isGeneral ? FontWeight.w700 : FontWeight.w500,
            color: isGeneral ? cs.onPrimaryContainer : cs.onSurfaceVariant,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.allMd,
            side: BorderSide(
              color: isGeneral
                  ? cs.primary.withValues(alpha: 0.4)
                  : cs.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          showCheckmark: false,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
        // Galpones individuales
        ...galpones.map((g) {
          final sel = galponSeleccionado?.id == g.id;
          return ChoiceChip(
            label: Text(g.nombre),
            selected: sel,
            onSelected: (_) => onGalponChanged(sel ? null : g),
            selectedColor: cs.primaryContainer,
            labelStyle: theme.textTheme.labelLarge?.copyWith(
              fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
              color: sel ? cs.onPrimaryContainer : cs.onSurfaceVariant,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.allMd,
              side: BorderSide(
                color: sel
                    ? cs.primary.withValues(alpha: 0.4)
                    : cs.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          );
        }),
      ],
    );
  }

  Widget _emptyMessage(ThemeData theme, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: AppRadius.allMd,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  String _formatDate(DateTime date, S l) {
    final months = [
      l.monthJanAbbr,
      l.monthFebAbbr,
      l.monthMarAbbr,
      l.monthAprAbbr,
      l.monthMayAbbr,
      l.monthJunAbbr,
      l.monthJulAbbr,
      l.monthAugAbbr,
      l.monthSepAbbr,
      l.monthOctAbbr,
      l.monthNovAbbr,
      l.monthDecAbbr,
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
