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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.allXl,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar centrado
          CircleAvatar(
            radius: 40,
            backgroundColor: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
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
          const SizedBox(height: 12),

          // Información centrada
          Text(
            nombreCompleto,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
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
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Botón editar
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onEditarPerfil,
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.onPrimary,
                side: BorderSide(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
              ),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: Text(S.of(context).profileEditProfile),
            ),
          ),
        ],
      ),
    );
  }
}
