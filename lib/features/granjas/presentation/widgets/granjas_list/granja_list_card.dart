/// Card moderna para mostrar una granja en la lista
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_animations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_image.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/granja.dart';
import '../../../domain/enums/enums.dart';

/// Tarjeta moderna para mostrar una granja en la lista
class GranjaListCard extends StatelessWidget {
  const GranjaListCard({
    super.key,
    required this.granja,
    this.onDetalles,
    this.onEdit,
    this.onCambiarEstado,
    this.onEliminar,
    this.onVerCasas,
  });

  final Granja granja;
  final VoidCallback? onDetalles;
  final VoidCallback? onEdit;
  final VoidCallback? onCambiarEstado;
  final VoidCallback? onEliminar;
  final VoidCallback? onVerCasas;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final statusInfo = _getStatusInfo(context);
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 360;

    return Semantics(
      button: true,
      label: l.farmSemantics(granja.nombre, statusInfo.text),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.allMd,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.allMd,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header: Nombre + Dirección + Estado
                _buildHeader(context, theme, statusInfo, isSmallScreen),
                AppSpacing.gapBase,

                // Imagen ilustrativa
                _buildImageSection(
                  theme,
                  statusInfo,
                  size.width,
                  isSmallScreen,
                ),
                AppSpacing.gapBase,

                // Botón de acción principal
                _buildActionButton(context, theme),
              ],
            ),
          ),
        ),
      ),
    ).cardEntrance();
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    _StatusInfo statusInfo,
    bool isSmallScreen,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // Nombre de la granja
            Expanded(
              child: Text(
                granja.nombre,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AppSpacing.hGapSm,
            // Badge de estado
            _buildStatusBadge(theme, statusInfo, isSmallScreen),
          ],
        ),
        AppSpacing.gapXxs,
        // Dirección
        Text(
          _formatDireccion(context),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildMenuButton(BuildContext context, ThemeData theme) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: theme.colorScheme.onSurfaceVariant,
        size: 22,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
      color: theme.colorScheme.surface,
      elevation: 3,
      offset: const Offset(0, 40),
      tooltip: S.of(context).commonMoreOptions,
      onSelected: (value) {
        switch (value) {
          case 'detalles':
            onDetalles?.call();
            break;
          case 'edit':
            onEdit?.call();
            break;
          case 'cambiar_estado':
            onCambiarEstado?.call();
            break;
          case 'eliminar':
            onEliminar?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        // Detalles
        PopupMenuItem(
          value: 'detalles',
          height: 48,
          child: Text(
            S.of(context).commonDetails,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Editar
        PopupMenuItem(
          value: 'edit',
          height: 48,
          child: Text(
            S.of(context).commonEdit,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Cambiar estado
        PopupMenuItem(
          value: 'cambiar_estado',
          height: 48,
          child: Text(
            S.of(context).commonChangeStatus,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Separador
        const PopupMenuDivider(height: 8),
        // Eliminar
        PopupMenuItem(
          value: 'eliminar',
          height: 48,
          child: Text(
            S.of(context).commonDelete,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection(
    ThemeData theme,
    _StatusInfo statusInfo,
    double screenWidth,
    bool isSmallScreen,
  ) {
    // Altura responsive: 40% del ancho de la pantalla, min 140, max 200
    final imageHeight = (screenWidth * 0.4).clamp(160.0, 220.0);

    return Container(
      height: imageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: statusInfo.color.withValues(alpha: 0.1),
        borderRadius: AppRadius.allSm,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.allSm,
        child: granja.imagenUrl != null && granja.imagenUrl!.trim().isNotEmpty
            ? AppImage(
                url: granja.imagenUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: imageHeight,
                memCacheWidth: 600,
                placeholder: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: statusInfo.color,
                  ),
                ),
                errorWidget: _buildPlaceholder(
                  theme,
                  statusInfo,
                  isSmallScreen,
                ),
              )
            : _buildPlaceholder(theme, statusInfo, isSmallScreen),
      ),
    );
  }

  Widget _buildPlaceholder(
    ThemeData theme,
    _StatusInfo statusInfo,
    bool isSmallScreen,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Builder(
        builder: (context) {
          final dpr = MediaQuery.devicePixelRatioOf(context);
          return Image.asset(
            AppAssets.illustration1,
            fit: BoxFit.contain,
            cacheWidth: (120 * dpr).round(),
            errorBuilder: (_, __, ___) =>
                _buildFallbackIcon(context, theme, statusInfo, isSmallScreen),
          );
        },
      ),
    );
  }

  Widget _buildFallbackIcon(
    BuildContext context,
    ThemeData theme,
    _StatusInfo statusInfo,
    bool isSmallScreen,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.agriculture_rounded,
            size: isSmallScreen ? 40 : 48,
            color: statusInfo.color.withValues(alpha: 0.4),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            S.of(context).farmPoultryFarm,
            style: theme.textTheme.labelMedium?.copyWith(
              color: statusInfo.color.withValues(alpha: 0.6),
              fontSize: isSmallScreen ? 12 : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(
    ThemeData theme,
    _StatusInfo statusInfo,
    bool isSmallScreen,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 10 : 12,
        vertical: isSmallScreen ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: statusInfo.color,
        borderRadius: AppRadius.allSm,
      ),
      child: Text(
        statusInfo.text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          fontSize: isSmallScreen ? 10 : 11,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, ThemeData theme) {
    final l = S.of(context);
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: onVerCasas == null
                  ? null
                  : () {
                      HapticFeedback.selectionClick();
                      onVerCasas?.call();
                    },
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
                elevation: 0,
              ),
              child: Text(
                l.farmViewSheds,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        AppSpacing.hGapSm,
        // Menú de opciones
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.5),
              width: 1,
            ),
            borderRadius: AppRadius.allSm,
          ),
          child: _buildMenuButton(context, theme),
        ),
      ],
    );
  }

  // ==================== HELPERS ====================

  String _formatDireccion(BuildContext context) {
    final direccion = granja.direccion;
    final partes = <String>[];

    final calle = direccion.calle.trim();
    if (calle.isNotEmpty) {
      partes.add(calle);
    }

    final ciudad = direccion.ciudad?.trim() ?? '';
    if (ciudad.isNotEmpty) {
      partes.add(ciudad);
    }

    final departamento = direccion.departamento?.trim() ?? '';
    if (departamento.isNotEmpty) {
      partes.add(departamento);
    }

    if (partes.isEmpty) {
      return S.of(context).farmNoAddress;
    }

    // Limitar a máximo 50 caracteres para evitar overflow
    final direccionCompleta = partes.join(', ');
    return direccionCompleta.length > 50
        ? '${direccionCompleta.substring(0, 47)}...'
        : direccionCompleta;
  }

  _StatusInfo _getStatusInfo(BuildContext context) {
    final l = S.of(context);
    switch (granja.estado) {
      case EstadoGranja.activo:
        return _StatusInfo(
          color: AppColors.success,
          icon: Icons.check_circle,
          text: l.farmFilterActive,
        );
      case EstadoGranja.inactivo:
        return _StatusInfo(
          color: AppColors.grey600,
          icon: Icons.cancel,
          text: l.farmFilterInactive,
        );
      case EstadoGranja.mantenimiento:
        return _StatusInfo(
          color: AppColors.warning,
          icon: Icons.build_circle,
          text: l.farmFilterMaintenance,
        );
    }
  }
}

class _StatusInfo {
  final Color color;
  final IconData icon;
  final String text;

  _StatusInfo({required this.color, required this.icon, required this.text});
}
