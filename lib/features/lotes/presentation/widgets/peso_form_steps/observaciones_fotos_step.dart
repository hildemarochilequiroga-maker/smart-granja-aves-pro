/// Step 3: Resumen y Fotos
/// Diseño consistente con resumen_observaciones_step de consumo
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Step 3: Resumen y Fotos
class ObservacionesFotosStep extends StatelessWidget {
  const ObservacionesFotosStep({
    super.key,
    required this.formKey,
    required this.imagenes,
    required this.onPickImage,
    required this.onEliminarFoto,
    required this.autoValidate,
    this.pesoPromedio,
    this.cantidadAves,
    this.pesoMinimo,
    this.pesoMaximo,
    required this.edadDias,
  });

  final GlobalKey<FormState> formKey;
  final List<File> imagenes;
  final Future<void> Function(ImageSource) onPickImage;
  final ValueChanged<int> onEliminarFoto;
  final bool autoValidate;
  final double? pesoPromedio;
  final int? cantidadAves;
  final double? pesoMinimo;
  final double? pesoMaximo;
  final int edadDias;

  double get _pesoTotal {
    final result = (pesoPromedio ?? 0) * (cantidadAves ?? 0) / 1000;
    return result.isFinite ? result : 0;
  }

  double get _rango {
    final result = (pesoMaximo ?? 0) - (pesoMinimo ?? 0);
    return result.isFinite ? result : 0;
  }

  double get _coeficienteVariacion {
    if ((pesoPromedio ?? 0) > 0) {
      final result = (_rango / (pesoPromedio ?? 0)) * 100;
      return result.isFinite ? result : 0;
    }
    return 0;
  }

  double get _gdp {
    if (edadDias > 0 && (pesoPromedio ?? 0) > 0) {
      final result = (pesoPromedio ?? 0) / edadDias;
      return result.isFinite ? result : 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showMetrics =
        (pesoPromedio ?? 0) > 0 &&
        (cantidadAves ?? 0) > 0 &&
        (pesoMinimo ?? 0) > 0 &&
        (pesoMaximo ?? 0) > 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            S.of(context).batchFormWeightSummary,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            S.of(context).batchFormWeightSummarySubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Card de métricas calculadas
          if (showMetrics) ...[
            _buildMetricsCard(context, theme),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Botones para agregar fotos
          _buildFotoButtons(context, theme),

          if (imagenes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xl),
            _buildFotosHeader(context, theme),
            const SizedBox(height: AppSpacing.base),
            _buildFotosGrid(theme),
          ] else ...[
            const SizedBox(height: AppSpacing.xl),
            _buildEmptyFotosPlaceholder(context, theme),
          ],

          const SizedBox(height: AppSpacing.xl),

          // Card informativa
          _buildInfoCard(context, theme),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, ThemeData theme) {
    return Container(
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
          const SizedBox(height: AppSpacing.xxs),
          Text(
            S.of(context).batchFormMetricsAutoCalculated,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFotoButtons(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: imagenes.length < 3
                ? () => onPickImage(ImageSource.camera)
                : null,
            icon: Icon(
              Icons.camera_alt,
              color: imagenes.length < 3 ? AppColors.info : null,
            ),
            label: Text(S.of(context).batchFormTakePhoto),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: imagenes.length < 3
                    ? AppColors.info
                    : theme.colorScheme.outline.withValues(alpha: 0.4),
                width: 1,
              ),
              foregroundColor: imagenes.length < 3 ? AppColors.info : null,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: imagenes.length < 3
                ? () => onPickImage(ImageSource.gallery)
                : null,
            icon: Icon(
              Icons.photo_library,
              color: imagenes.length < 3 ? AppColors.info : null,
            ),
            label: Text(S.of(context).batchFormGallery),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: imagenes.length < 3
                    ? AppColors.info
                    : theme.colorScheme.outline.withValues(alpha: 0.4),
                width: 1,
              ),
              foregroundColor: imagenes.length < 3 ? AppColors.info : null,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFotosHeader(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.of(context).batchFormSelectedPhotos,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: AppRadius.allLg,
          ),
          child: Text(
            '${imagenes.length}/3',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyFotosPlaceholder(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: AppRadius.allSm,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.photo_camera_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            S.of(context).batchFormNoPhotos,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            S.of(context).batchFormMaxPhotos,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsCard(BuildContext context, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.allMd,
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Datos del registro
          _buildMetricRow(
            theme,
            S.of(context).weightAvgWeight,
            '${(pesoPromedio ?? 0).toStringAsFixed(0)} g',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildMetricRow(
            theme,
            S.of(context).weightBirdsWeighed,
            '${cantidadAves ?? 0}',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildMetricRow(
            theme,
            S.of(context).weightRange,
            '${(pesoMinimo ?? 0).toStringAsFixed(0)} - ${(pesoMaximo ?? 0).toStringAsFixed(0)} g',
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),

          // Métricas calculadas
          _buildMetricRow(
            theme,
            S.of(context).weightTotal,
            '${_pesoTotal.toStringAsFixed(2)} kg',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildMetricRow(
            theme,
            S.of(context).weightDailyGain,
            '${_gdp.toStringAsFixed(2)} ${S.of(context).weightGramsPerDay}',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildMetricRow(
            theme,
            S.of(context).weightCoefficientVariation,
            '${_coeficienteVariacion.toStringAsFixed(1)}%',
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(ThemeData theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildFotosGrid(ThemeData theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: imagenes.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: AppRadius.allSm,
              child: Image.file(
                imagenes[index],
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => onEliminarFoto(index),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.2,
                        ),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close,
                    color: theme.colorScheme.onError,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
