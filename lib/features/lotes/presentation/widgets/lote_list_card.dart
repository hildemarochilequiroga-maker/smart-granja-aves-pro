/// Card moderna para mostrar un lote en la lista
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/lote.dart';
import '../../domain/enums/estado_lote.dart';
import '../../domain/enums/tipo_ave.dart';

/// Tarjeta moderna para mostrar un lote en la lista
class LoteListCard extends StatelessWidget {
  const LoteListCard({
    super.key,
    required this.lote,
    this.onDetalles,
    this.onEditar,
    this.onRegistrarMortalidad,
    this.onCambiarEstado,
    this.onEliminar,
    this.onVerDashboard,
  });

  final Lote lote;
  final VoidCallback? onDetalles;
  final VoidCallback? onEditar;
  final VoidCallback? onRegistrarMortalidad;
  final VoidCallback? onCambiarEstado;
  final VoidCallback? onEliminar;
  final VoidCallback? onVerDashboard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusInfo = _getStatusInfo(context);
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 360;

    return Semantics(
      button: true,
      label: S
          .of(context)
          .batchSemanticsLabel(
            lote.codigo,
            lote.tipoAve.localizedDisplayName(S.of(context)),
            lote.avesActuales,
            statusInfo.text,
          ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppRadius.allMd,
          boxShadow: [
            BoxShadow(
              color: colorScheme.onSurface.withValues(alpha: 0.06),
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
                // Header: Codigo + Nombre + Estado
                _buildHeader(context, theme, statusInfo, isSmallScreen),
                const SizedBox(height: AppSpacing.base),

                // Seccion de imagen/info
                _buildImageSection(
                  context,
                  theme,
                  statusInfo,
                  size.width,
                  isSmallScreen,
                ),
                const SizedBox(height: AppSpacing.base),

                // Boton de accion principal
                _buildActionButton(context, theme),
              ],
            ),
          ),
        ),
      ).cardEntrance(),
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
            // Codigo del lote
            Expanded(
              child: Text(
                lote.codigo,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // Badge de estado
            _buildStatusBadge(theme, statusInfo, isSmallScreen),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        // Nombre y tipo de ave
        Text(
          _formatSubtitle(context),
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
    final isCerrado = lote.estado == EstadoLote.cerrado;

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
      tooltip: S.of(context).batchMoreOptions,
      onSelected: (value) {
        switch (value) {
          case 'detalles':
            onDetalles?.call();
            break;
          case 'editar':
            onEditar?.call();
            break;
          case 'estado':
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
            S.of(context).batchDetails,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Editar
        PopupMenuItem(
          value: 'editar',
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
        if (!isCerrado)
          PopupMenuItem(
            value: 'estado',
            height: 48,
            child: Text(
              S.of(context).batchChangeStatus,
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
    BuildContext context,
    ThemeData theme,
    _StatusInfo statusInfo,
    double screenWidth,
    bool isSmallScreen,
  ) {
    // Altura responsive: 40% del ancho de la pantalla, min 160, max 220 (igual que granjas)
    final imageHeight = (screenWidth * 0.4).clamp(160.0, 220.0);

    return Column(
      children: [
        // Imagen
        Container(
          height: imageHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: statusInfo.color.withValues(alpha: 0.1),
            borderRadius: AppRadius.allSm,
          ),
          child: ClipRRect(
            borderRadius: AppRadius.allSm,
            child: Builder(
              builder: (context) {
                final dpr = MediaQuery.devicePixelRatioOf(context);
                return Image.asset(
                  _getImageByTipoAve(),
                  fit: BoxFit.contain,
                  cacheWidth: (imageHeight * dpr).round(),
                  errorBuilder: (_, __, ___) => _buildPlaceholder(theme),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Estadisticas debajo de la imagen - sin iconos, texto negro
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              theme,
              lote.tipoAve.localizedNombreCorto(S.of(context)),
              S.of(context).batchType,
            ),
            Container(
              width: 1,
              height: 32,
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            _buildStatItem(
              theme,
              '${lote.avesActuales}',
              S.of(context).batchBirds,
            ),
            Container(
              width: 1,
              height: 32,
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            _buildStatItem(
              theme,
              '${lote.edadActualDias}d',
              S.of(context).batchAge,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.pets_rounded,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  // Imagen segun tipo de ave - CORREGIDO
  String _getImageByTipoAve() {
    return switch (lote.tipoAve) {
      TipoAve.polloEngorde => 'assets/images/illustrations/3.png',
      TipoAve.gallinaPonedora => 'assets/images/illustrations/4.png',
      TipoAve.otro => 'assets/images/illustrations/6.png',
      _ => 'assets/images/illustrations/3.png', // Default para otros tipos
    };
  }

  Widget _buildStatItem(ThemeData theme, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
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
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: onVerDashboard == null
                  ? null
                  : () {
                      HapticFeedback.selectionClick();
                      onVerDashboard?.call();
                    },
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
                elevation: 0,
              ),
              child: Text(
                S.of(context).batchViewRecords,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        // Menu de opciones
        Semantics(
          button: true,
          label: S.of(context).batchMoreOptionsLote,
          child: Container(
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
        ),
      ],
    );
  }

  // ==================== HELPERS ====================

  String _formatSubtitle(BuildContext context) {
    final partes = <String>[];

    if (lote.nombre != null && lote.nombre!.isNotEmpty) {
      partes.add(lote.nombre!);
    }

    partes.add(lote.tipoAve.localizedNombreCorto(S.of(context)));

    return partes.join(' - ');
  }

  _StatusInfo _getStatusInfo(BuildContext context) {
    final l = S.of(context);
    return switch (lote.estado) {
      EstadoLote.activo => _StatusInfo(
        color: AppColors.success,
        icon: Icons.check_circle,
        text: l.batchStatusActive,
      ),
      EstadoLote.cerrado => _StatusInfo(
        color: AppColors.grey600,
        icon: Icons.cancel,
        text: l.batchStatusClosed,
      ),
      EstadoLote.cuarentena => _StatusInfo(
        color: AppColors.warning,
        icon: Icons.warning,
        text: l.batchStatusQuarantine,
      ),
      EstadoLote.vendido => _StatusInfo(
        color: AppColors.info,
        icon: Icons.sell,
        text: l.batchStatusSold,
      ),
      EstadoLote.enTransferencia => _StatusInfo(
        color: AppColors.purple,
        icon: Icons.swap_horiz,
        text: l.batchStatusTransfer,
      ),
      EstadoLote.suspendido => _StatusInfo(
        color: AppColors.error,
        icon: Icons.pause_circle,
        text: l.batchStatusSuspended,
      ),
    };
  }
}

class _StatusInfo {
  final Color color;
  final IconData icon;
  final String text;

  _StatusInfo({required this.color, required this.icon, required this.text});
}
