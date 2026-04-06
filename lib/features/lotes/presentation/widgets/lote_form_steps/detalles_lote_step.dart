/// Paso 2: Detalles del lote.
///
/// Widget modular para el segundo paso del formulario de creación/edición de lotes.
/// Captura información adicional: cantidad, edad y observaciones.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../galpones/application/providers/providers.dart';
import '../../../application/providers/providers.dart';
import '../lote_form_field.dart';

/// Paso 2: Detalles del lote
class LoteDetallesStep extends ConsumerWidget {
  final TextEditingController cantidadInicialController;
  final TextEditingController edadIngresoController;
  final TextEditingController observacionesController;
  final bool autoValidate;
  final bool isEditing;
  final String? galponId;
  final String granjaId;

  const LoteDetallesStep({
    super.key,
    required this.cantidadInicialController,
    required this.edadIngresoController,
    required this.observacionesController,
    required this.autoValidate,
    required this.granjaId,
    this.isEditing = false,
    this.galponId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del paso
          Text(
            S.of(context).batchFormStepDetails,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).batchFormDetailsSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.gapXl,

          // Cantidad inicial
          _buildCantidadInicialField(context, theme, ref),
          AppSpacing.gapBase,

          // Widget informativo de capacidad disponible
          if (galponId != null) _buildCapacidadInfo(context, theme, ref),
          if (galponId != null) AppSpacing.gapBase,

          // Edad de ingreso (opcional)
          _buildEdadIngresoField(context, theme),
          AppSpacing.gapXl,

          // Observaciones
          _buildObservacionesField(context, theme),
          AppSpacing.gapXl,

          // Nota informativa
          _buildNotaInformativa(context, theme),
        ],
      ),
    );
  }

  Widget _buildCantidadInicialField(BuildContext context, ThemeData theme, WidgetRef ref) {
    return LoteFormField(
      controller: cantidadInicialController,
      label: '${S.of(context).batchFormInitialCount} *',
      hint: S.of(context).batchFormCountHint,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context).batchInitialCountRequired;
        }
        final cantidad = int.tryParse(value);
        if (cantidad == null || cantidad <= 0) {
          return S.of(context).batchMustBeGreaterThanZero;
        }
        return null;
      },
      autovalidateMode: autoValidate
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
    );
  }

  Widget _buildCapacidadInfo(BuildContext context, ThemeData theme, WidgetRef ref) {
    final galponAsync = ref.watch(galponByIdProvider(galponId!));

    return galponAsync.when(
      data: (galpon) {
        if (galpon == null) return const SizedBox.shrink();

        final lotesActivosAsync = ref.watch(
          loteActivoGalponProvider(galponId!),
        );

        return lotesActivosAsync.when(
          data: (loteActual) {
            final avesEnGalpon = loteActual?.avesActuales ?? 0;
            final cantidadNueva =
                int.tryParse(cantidadInicialController.text) ?? 0;
            final totalProyectado = avesEnGalpon + cantidadNueva;
            final capacidadMaxima = galpon.capacidadMaxima;
            final disponible = capacidadMaxima - avesEnGalpon;

            final excede = totalProyectado > capacidadMaxima;

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: excede
                    ? theme.colorScheme.error.withValues(alpha: 0.1)
                    : AppColors.info.withValues(alpha: 0.08),
                borderRadius: AppRadius.allSm,
                border: Border.all(
                  color: excede
                      ? theme.colorScheme.error.withValues(alpha: 0.3)
                      : AppColors.info.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).batchFormShedCapacity,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: excede ? theme.colorScheme.error : AppColors.info,
                    ),
                  ),
                  AppSpacing.gapSm,
                  _buildCapacidadRow(
                    context, theme,
                    S.of(context).batchFormMaxCapacity,
                    '$capacidadMaxima ${S.of(context).batchBirdsLabel}',
                  ),
                  if (avesEnGalpon > 0)
                    _buildCapacidadRow(
                      context, theme,
                      S.of(context).batchFormCurrentBirds,
                      '$avesEnGalpon ${S.of(context).batchBirdsLabel}',
                    ),
                  _buildCapacidadRow(
                    context, theme,
                    S.of(context).batchFormAvailable,
                    '$disponible ${S.of(context).batchBirdsLabel}',
                    highlight: true,
                  ),
                  if (excede)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '⚠️ ${S.of(context).batchFormExceedsCapacity}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildCapacidadRow(
    BuildContext context, ThemeData theme,
    String label,
    String value, {
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
              color: highlight ? AppColors.info : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEdadIngresoField(BuildContext context, ThemeData theme) {
    return LoteFormField(
      controller: edadIngresoController,
      label: S.of(context).batchFormAgeAtEntry,
      hint: S.of(context).batchFormAgeHint,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final edad = int.tryParse(value);
          if (edad == null || edad < 0) {
            return S.of(context).batchInvalidNumber;
          }
        }
        return null;
      },
      autovalidateMode: autoValidate
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
    );
  }

  Widget _buildObservacionesField(BuildContext context, ThemeData theme) {
    final labelColor = theme.colorScheme.onSurface.withValues(alpha: 0.8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          S.of(context).batchFormObservations,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: labelColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        AppSpacing.gapSm,
        TextFormField(
          controller: observacionesController,
          maxLines: 4,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: S.of(context).batchFormObservationsHint,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.normal,
            ),
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
            counterStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotaInformativa(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: AppRadius.allSm,
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).batchAttention,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            S.of(context).batchFormAgeInfoNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
