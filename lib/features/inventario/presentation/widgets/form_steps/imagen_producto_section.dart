/// Sección de imagen del producto para el formulario de inventario.
/// Diseño consistente con EvidenciaFotograficaStep de mortalidad.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_image.dart';

/// Widget para seleccionar imagen del producto.
class ImagenProductoSection extends StatelessWidget {
  const ImagenProductoSection({
    super.key,
    required this.imagenSeleccionada,
    required this.imagenUrlExistente,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  final XFile? imagenSeleccionada;
  final String? imagenUrlExistente;
  final Future<void> Function(ImageSource) onPickImage;
  final VoidCallback onRemoveImage;

  bool get _tieneImagen =>
      imagenSeleccionada != null ||
      (imagenUrlExistente != null && imagenUrlExistente!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de sección
        Text(
          l.invProductImage,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.gapBase,

        // Botones de acción - igual que evidencia
        Row(
          children: [
            Expanded(
              child: _buildPhotoButton(
                context: context,
                theme: theme,
                icon: Icons.camera_alt,
                label: l.invTakePhoto,
                onPressed: !_tieneImagen
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
                label: l.invGallery,
                onPressed: !_tieneImagen
                    ? () => onPickImage(ImageSource.gallery)
                    : null,
              ),
            ),
          ],
        ),

        if (_tieneImagen) ...[
          AppSpacing.gapBase,
          _buildImagenSeleccionada(context, theme),
        ] else ...[
          AppSpacing.gapBase,
          _buildEmptyState(context, theme),
        ],
      ],
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

  Widget _buildImagenSeleccionada(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).inventoryImageSelected,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: AppRadius.allLg,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, color: theme.colorScheme.surface, size: 14),
                  AppSpacing.hGapXxs,
                  Text(
                    S.of(context).invImageReady,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.surface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        AppSpacing.gapMd,
        // Imagen - estilo grid como evidencia pero una sola imagen
        Stack(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: AppRadius.allSm,
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: AppRadius.allSm,
                child: _buildImageWidget(theme),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onRemoveImage,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.error,
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
                    color: theme.colorScheme.surface,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageWidget(ThemeData theme) {
    if (imagenSeleccionada != null) {
      return Image.file(
        File(imagenSeleccionada!.path),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (imagenUrlExistente != null && imagenUrlExistente!.isNotEmpty) {
      return AppImage(
        url: imagenUrlExistente!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        placeholder: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
        errorWidget: Container(
          color: theme.colorScheme.outlineVariant,
          child: Center(
            child: Icon(
              Icons.broken_image,
              size: 48,
              color: theme.colorScheme.outline,
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
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
            Icons.add_photo_alternate_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          AppSpacing.gapBase,
          Text(
            S.of(context).inventoryNoImage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).invCanAddPhoto,
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
