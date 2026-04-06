library;

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Widget de imagen con cache.
///
/// Soporta URLs de red y rutas locales con prefijo `pending:` para
/// imágenes que aún no se han subido a Firebase Storage.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  /// Ancho máximo en caché en memoria (en píxeles lógicos).
  /// Reduce uso de RAM al decodificar imágenes grandes.
  final int? memCacheWidth;

  /// Alto máximo en caché en memoria (en píxeles lógicos).
  final int? memCacheHeight;

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (url.startsWith('pending:')) {
      // Imagen local pendiente de subida
      final localPath = url.substring('pending:'.length);
      final file = File(localPath);

      image = Stack(
        fit: StackFit.passthrough,
        children: [
          Image.file(
            file,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stack) =>
                errorWidget ??
                const Center(child: Icon(Icons.broken_image_outlined)),
          ),
          // Indicador de subida pendiente
          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.cloud_upload_outlined,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 200),
        placeholder: (context, url) =>
            placeholder ??
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorWidget: (context, url, error) =>
            errorWidget ??
            const Center(child: Icon(Icons.broken_image_outlined)),
      );
    }

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }
}

/// Avatar circular
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
  });

  final String? imageUrl;
  final String? name;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: AppImage(
          url: imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorWidget: _buildInitials(context),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getInitials(),
          style: theme.textTheme.titleMedium?.copyWith(
            color: textColor ?? colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInitials(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getInitials(),
          style: theme.textTheme.titleMedium?.copyWith(
            color: textColor ?? colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getInitials() {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}

/// Placeholder de imagen
class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({
    super.key,
    this.width,
    this.height,
    this.icon = Icons.image_outlined,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final IconData icon;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget container = Container(
      width: width,
      height: height,
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(icon, color: colorScheme.onSurfaceVariant, size: 40),
      ),
    );

    if (borderRadius != null) {
      container = ClipRRect(borderRadius: borderRadius!, child: container);
    }

    return container;
  }
}
