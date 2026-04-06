/// Step 3: Evidencia Fotográfica
/// Diseño consistente con crear_granja y crear_galpon
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/form_widgets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Step 3: Evidencia Fotográfica
class EvidenciaFotograficaStep extends StatelessWidget {
  const EvidenciaFotograficaStep({
    super.key,
    required this.fotosSeleccionadas,
    required this.onPickImage,
    required this.onRemovePhoto,
  });

  final List<XFile> fotosSeleccionadas;
  final Future<void> Function(ImageSource) onPickImage;
  final void Function(int) onRemovePhoto;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            S.of(context).batchFormPhotoEvidence,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).batchFormPhotoOptional,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapXl,

          // Info card
          FormInfoRow(
            text: S.of(context).batchFormPhotoHelpText,
            type: InfoCardType.info,
          ),
          AppSpacing.gapXl,

          // Botones para agregar fotos
          Row(
            children: [
              Expanded(
                child: _buildPhotoButton(
                  context: context,
                  theme: theme,
                  icon: Icons.camera_alt,
                  label: S.of(context).batchFormTakePhoto,
                  onPressed: fotosSeleccionadas.length < 5
                      ? () => onPickImage(ImageSource.camera)
                      : null,
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: _buildPhotoButton(
                  context: context,
                  theme: theme,
                  icon: Icons.photo_library,
                  label: S.of(context).batchFormGallery,
                  onPressed: fotosSeleccionadas.length < 5
                      ? () => onPickImage(ImageSource.gallery)
                      : null,
                ),
              ),
            ],
          ),

          if (fotosSeleccionadas.isNotEmpty) ...[
            AppSpacing.gapXl,
            Row(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppRadius.allLg,
                  ),
                  child: Text(
                    '${fotosSeleccionadas.length}/5',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapBase,

            // Grid de fotos seleccionadas
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: fotosSeleccionadas.length,
              itemBuilder: (context, index) {
                return _buildPhotoItem(context, theme, index);
              },
            ),
          ] else ...[
            AppSpacing.gapXl,
            _buildEmptyState(context, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildPhotoButton({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    final isEnabled = onPressed != null;
    final color = isEnabled ? AppColors.info : theme.colorScheme.outline;

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: color, width: 1),
        foregroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
      ),
    );
  }

  Widget _buildPhotoItem(BuildContext context, ThemeData theme, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: AppRadius.allSm,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
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
            onTap: () => onRemovePhoto(index),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.close, color: AppColors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: AppRadius.allSm,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.photo_camera_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          AppSpacing.gapBase,
          Text(
            S.of(context).photoNoPhotosAdded,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).photoMax5Hint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
