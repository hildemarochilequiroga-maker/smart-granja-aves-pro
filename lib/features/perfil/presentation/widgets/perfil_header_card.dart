/// Card de encabezado del perfil.
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/core/theme/app_radius.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Card que muestra la información del usuario.
class PerfilHeaderCard extends StatelessWidget {
  const PerfilHeaderCard({
    super.key,
    required this.nombreCompleto,
    required this.email,
    this.fotoUrl,
    this.onEditarPerfil,
  });

  final String nombreCompleto;
  final String email;
  final String? fotoUrl;
  final VoidCallback? onEditarPerfil;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inicial = nombreCompleto.isNotEmpty
        ? nombreCompleto.substring(0, 1).toUpperCase()
        : 'U';

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Column(
        children: [
          // Avatar centrado. Si hay foto (ej. cuenta de Google) se muestra; si no,
          // se muestra la inicial sobre un fondo sólido del color primario.
          CircleAvatar(
            radius: 48,
            backgroundColor: theme.colorScheme.primary,
            backgroundImage: fotoUrl != null && fotoUrl!.isNotEmpty
                ? CachedNetworkImageProvider(fotoUrl!)
                : null,
            onBackgroundImageError: fotoUrl != null
                ? (_, __) {} // Silenciar error, se muestra inicial
                : null,
            child: fotoUrl == null || fotoUrl!.isEmpty
                ? Text(
                    inicial,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 10),

          // Información centrada
          Text(
            nombreCompleto,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Botón editar (sólido)
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onEditarPerfil,
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(S.of(context).profileEditProfile),
            ),
          ),
        ],
      ),
    );
  }
}
