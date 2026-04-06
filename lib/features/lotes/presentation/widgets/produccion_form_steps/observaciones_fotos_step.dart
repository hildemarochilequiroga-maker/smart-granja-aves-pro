import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/form_widgets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Step 3: Observaciones y Fotos
class ObservacionesFotosProduccionStep extends StatelessWidget {
  const ObservacionesFotosProduccionStep({
    super.key,
    required this.observacionesController,
    required this.autoValidate,
    required this.fotosSeleccionadas,
    required this.onAgregarFoto,
    required this.onEliminarFoto,
    this.huevosRecolectados,
    this.huevosBuenos,
    this.cantidadAves,
    this.pesoPromedioCalculado,
  });

  final TextEditingController observacionesController;
  final bool autoValidate;
  final List<XFile> fotosSeleccionadas;
  final Function(ImageSource) onAgregarFoto;
  final Function(int) onEliminarFoto;
  final int? huevosRecolectados;
  final int? huevosBuenos;
  final int? cantidadAves;
  final double? pesoPromedioCalculado;

  double get _porcentajePostura {
    if (huevosRecolectados == null ||
        cantidadAves == null ||
        cantidadAves == 0) {
      return 0;
    }
    return (huevosRecolectados! / cantidadAves!) * 100;
  }

  double get _porcentajeAprovechamiento {
    if (huevosRecolectados == null ||
        huevosBuenos == null ||
        huevosRecolectados == 0) {
      return 0;
    }
    return (huevosBuenos! / huevosRecolectados!) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showMetrics =
        (huevosRecolectados ?? 0) > 0 && (cantidadAves ?? 0) > 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            S.of(context).batchFormObservationsAndEvidence,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            S.of(context).batchFormObservationsSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Métricas calculadas
          if (showMetrics) ...[
            _buildMetricsCard(context, theme),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Campo de observaciones
          RegistroFormField(
            controller: observacionesController,
            label: S.of(context).batchFormObservations,
            hint: S.of(context).prodObsHint,
            maxLines: 5,
            maxLength: 500,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Info card
          FormInfoRow(
            text: S.of(context).batchFormPhotoHelpText,
            type: InfoCardType.info,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Botones para agregar fotos
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: fotosSeleccionadas.length < 3
                      ? () => onAgregarFoto(ImageSource.camera)
                      : null,
                  icon: Icon(
                    Icons.camera_alt,
                    color: fotosSeleccionadas.length < 3
                        ? theme.colorScheme.primary
                        : null,
                  ),
                  label: Text(S.of(context).batchFormTakePhoto),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: fotosSeleccionadas.length < 3
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                      width: 1,
                    ),
                    foregroundColor: fotosSeleccionadas.length < 3
                        ? theme.colorScheme.primary
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.allSm,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: fotosSeleccionadas.length < 3
                      ? () => onAgregarFoto(ImageSource.gallery)
                      : null,
                  icon: Icon(
                    Icons.photo_library,
                    color: fotosSeleccionadas.length < 3
                        ? theme.colorScheme.primary
                        : null,
                  ),
                  label: Text(S.of(context).batchFormGallery),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: fotosSeleccionadas.length < 3
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                      width: 1,
                    ),
                    foregroundColor: fotosSeleccionadas.length < 3
                        ? theme.colorScheme.primary
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.allSm,
                    ),
                  ),
                ),
              ),
            ],
          ),

          if (fotosSeleccionadas.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).batchFormSelectedPhotos,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: AppRadius.allLg,
                  ),
                  child: Text(
                    '${fotosSeleccionadas.length}/3',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.base),
            _buildFotosGrid(theme),
          ] else ...[
            const SizedBox(height: AppSpacing.xl),
            _buildEmptyPhotosPlaceholder(context, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricsCard(BuildContext context, ThemeData theme) {
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
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                color: AppColors.info,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                S.of(context).batchFormProductionSummary,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildMetricRow(
            theme,
            S.of(context).batchFormLayingPercentage,
            '${_porcentajePostura.toStringAsFixed(1)}%',
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildMetricRow(
            theme,
            S.of(context).batchFormUtilization,
            '${_porcentajeAprovechamiento.toStringAsFixed(1)}%',
          ),
          if (pesoPromedioCalculado != null && pesoPromedioCalculado! > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            _buildMetricRow(
              theme,
              S.of(context).batchFormWeight,
              '${pesoPromedioCalculado!.toStringAsFixed(1)} g',
            ),
          ],
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
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPhotosPlaceholder(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: AppRadius.allSm,
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
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
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            S.of(context).batchFormMaxPhotos,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
      itemCount: fotosSeleccionadas.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: AppRadius.allSm,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 1,
                  ),
                  borderRadius: AppRadius.allSm,
                ),
                child: Image.file(
                  File(fotosSeleccionadas[index].path),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
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
