/// Card moderna para mostrar un galpon en la lista
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/presentation/widgets/form_text_scale.dart';
import '../../../../../core/theme/app_animations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/widgets/app_action_sheet.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_status_badge.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/galpon.dart';
import '../../../domain/enums/enums.dart';

/// Tarjeta moderna para mostrar un galpon en la lista
class GalponListCard extends StatelessWidget {
  const GalponListCard({
    super.key,
    required this.galpon,
    required this.onTap,
    this.index = 0,
    this.onEditar,
    this.onCambiarEstado,
    this.onEliminar,
    this.onVerLotes,
  });

  final Galpon galpon;

  /// Posición en la lista — usada para escalonar la animación de entrada.
  final int index;

  final VoidCallback? onTap;
  final VoidCallback? onEditar;
  final VoidCallback? onCambiarEstado;
  final VoidCallback? onEliminar;
  final VoidCallback? onVerLotes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusInfo = _getStatusInfo(context);
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 360;

    return FormTextScale(
      child: Semantics(
        button: true,
        label: S
            .of(context)
            .shedSemanticsLabel(
              galpon.nombre,
              galpon.codigo,
              galpon.avesActuales,
              statusInfo.text,
            ),
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
                  // Header: Nombre + Área + Estado
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
      ).staggeredEntrance(index: index),
    );
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
            // Nombre del galpon
            Expanded(
              child: Text(
                galpon.nombre,
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
            AppStatusBadge(
              text: statusInfo.text,
              color: statusInfo.color,
              compact: isSmallScreen,
            ),
          ],
        ),
        AppSpacing.gapXxs,
        // Área y tipo
        Text(
          '${galpon.areaM2?.toStringAsFixed(0) ?? "0"} m² - ${galpon.tipo.localizedDisplayName(S.of(context))}',
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
    return IconButton(
      icon: Icon(
        Icons.more_vert,
        color: theme.colorScheme.onSurfaceVariant,
        size: 22,
      ),
      tooltip: S.of(context).shedMoreOptions,
      onPressed: () => showAppActionSheet(
        context: context,
        title: galpon.nombre,
        actions: [
          AppActionSheetItem(
            label: S.of(context).shedDetails,
            icon: Icons.info_outline,
            onTap: onTap,
          ),
          AppActionSheetItem(
            label: S.of(context).commonEdit,
            icon: Icons.edit_outlined,
            onTap: onEditar,
          ),
          AppActionSheetItem(
            label: S.of(context).shedChangeStateAction,
            icon: Icons.swap_horiz_rounded,
            onTap: onCambiarEstado,
          ),
          AppActionSheetItem(
            label: S.of(context).commonDelete,
            icon: Icons.delete_outline,
            isDestructive: true,
            onTap: onEliminar,
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(
    ThemeData theme,
    _StatusInfo statusInfo,
    double screenWidth,
    bool isSmallScreen,
  ) {
    // Altura responsive: 40% del ancho de la pantalla, min 160, max 220
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
        child: _buildPlaceholder(theme, statusInfo, isSmallScreen),
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
            AppAssets.illustration2,
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
            galpon.tipo.icon,
            size: isSmallScreen ? 40 : 48,
            color: statusInfo.color.withValues(alpha: 0.4),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            galpon.tipo.localizedDisplayName(S.of(context)),
            style: theme.textTheme.labelMedium?.copyWith(
              color: statusInfo.color.withValues(alpha: 0.6),
              fontSize: isSmallScreen ? 12 : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: AppButton.primary(
            label: galpon.loteActualId != null
                ? S.of(context).shedViewActiveBatch
                : S.of(context).shedViewBatches,
            onPressed: (onVerLotes ?? onTap) == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    (onVerLotes ?? onTap)?.call();
                  },
            expanded: true,
          ),
        ),
        AppSpacing.hGapSm,
        // Menu de opciones
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

  _StatusInfo _getStatusInfo(BuildContext context) {
    final l = S.of(context);
    switch (galpon.estado) {
      case EstadoGalpon.activo:
        return _StatusInfo(
          color: AppColors.success,
          icon: Icons.check_circle,
          text: l.shedActive,
        );
      case EstadoGalpon.inactivo:
        return _StatusInfo(
          color: AppColors.inactive,
          icon: Icons.cancel,
          text: l.shedInactive,
        );
      case EstadoGalpon.mantenimiento:
        return _StatusInfo(
          color: AppColors.warning,
          icon: Icons.build_circle,
          text: l.commonMaintenance,
        );
      case EstadoGalpon.desinfeccion:
        return _StatusInfo(
          color: AppColors.info,
          icon: Icons.cleaning_services,
          text: l.shedDisinfection,
        );
      case EstadoGalpon.cuarentena:
        return _StatusInfo(
          color: AppColors.error,
          icon: Icons.warning,
          text: l.shedQuarantine,
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
