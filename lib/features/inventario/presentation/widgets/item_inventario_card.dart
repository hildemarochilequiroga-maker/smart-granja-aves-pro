/// Widget de tarjeta para mostrar un item de inventario.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_image.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';

/// Widget de tarjeta para mostrar un item de inventario en listas.
class ItemInventarioCard extends StatelessWidget {
  const ItemInventarioCard({
    super.key,
    required this.item,
    this.onTap,
    this.onEditar,
    this.onEliminar,
    this.compact = false,
  });

  final ItemInventario item;
  final VoidCallback? onTap;
  final VoidCallback? onEditar;
  final VoidCallback? onEliminar;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final statusInfo = _getStatusInfo(l);
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 360;

    if (compact) {
      return _buildCompactCard(theme, statusInfo);
    }

    return Semantics(
      button: true,
      label: l.semanticsInventoryItem(
        item.nombre,
        item.tipo.displayName,
        item.stockActual.toString(),
        item.unidad.simbolo,
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
                // Header: Nombre + Tipo + Estado
                _buildHeader(theme, statusInfo, isSmallScreen),
                AppSpacing.gapBase,

                // Sección de imagen/info
                _buildImageSection(theme, statusInfo, size.width, l),
                AppSpacing.gapBase,

                // Alerta de vencimiento si aplica
                if (item.proximoVencer || item.vencido) ...[
                  _buildVencimientoAlert(theme, l),
                  AppSpacing.gapBase,
                ],

                // Botón de acción principal
                _buildActionButton(theme, l),
              ],
            ),
          ),
        ),
      ).cardEntrance(),
    );
  }

  Widget _buildCompactCard(ThemeData theme, _StatusInfo statusInfo) {
    final tipoColor = Color(int.parse('0xFF${item.tipo.colorHex}'));
    final hasImage = item.imagenUrl != null && item.imagenUrl!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allMd,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.allMd,
        child: InkWell(
          onTap: onTap == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onTap?.call();
                },
          borderRadius: AppRadius.allMd,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Imagen o icono
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: hasImage ? null : tipoColor,
                    borderRadius: AppRadius.allMd,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: hasImage
                      ? AppImage(
                          url: item.imagenUrl!,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          memCacheWidth: 88,
                          memCacheHeight: 88,
                          errorWidget: Container(
                            color: tipoColor,
                            child: Icon(
                              _getIconForTipo(item.tipo),
                              color: theme.colorScheme.surface,
                              size: 22,
                            ),
                          ),
                        )
                      : Icon(
                          _getIconForTipo(item.tipo),
                          color: theme.colorScheme.surface,
                          size: 22,
                        ),
                ),
                AppSpacing.hGapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nombre,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${item.stockActual} ${item.unidad.simbolo}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(theme, statusInfo, true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
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
            // Nombre del item
            Expanded(
              child: Text(
                item.nombre,
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
        // Tipo y código
        Text(
          _formatSubtitle(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildImageSection(
    ThemeData theme,
    _StatusInfo statusInfo,
    double screenWidth,
    S l,
  ) {
    // Altura responsive: 35% del ancho, min 140, max 180
    final imageHeight = (screenWidth * 0.35).clamp(140.0, 180.0);
    final tipoColor = Color(int.parse('0xFF${item.tipo.colorHex}'));
    final hasImage = item.imagenUrl != null && item.imagenUrl!.isNotEmpty;

    return Column(
      children: [
        // Imagen/Icono del tipo
        Container(
          height: imageHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: tipoColor.withValues(alpha: 0.1),
            borderRadius: AppRadius.allMd,
            border: hasImage
                ? Border.all(color: tipoColor.withValues(alpha: 0.2), width: 1)
                : null,
          ),
          child: hasImage
              ? ClipRRect(
                  borderRadius: AppRadius.allMd,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AppImage(
                        url: item.imagenUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: imageHeight,
                        memCacheWidth: 400,
                        placeholder: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: tipoColor,
                          ),
                        ),
                        errorWidget: _buildFallbackIcon(
                          theme,
                          tipoColor,
                          imageHeight,
                        ),
                      ),
                      // Gradiente sutil en la parte inferior
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                theme.colorScheme.onSurface.withValues(
                                  alpha: 0.3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Badge del tipo
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: tipoColor,
                            borderRadius: AppRadius.allSm,
                          ),
                          child: Text(
                            item.tipo.displayName,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.surface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : _buildFallbackIcon(theme, tipoColor, imageHeight),
        ),
        AppSpacing.gapMd,
        // Estadísticas debajo - sin iconos, texto limpio
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              theme,
              '${item.stockActual} ${item.unidad.simbolo}',
              l.invCardStock,
            ),
            Container(
              width: 1,
              height: 32,
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            _buildStatItem(
              theme,
              '${item.stockMinimo} ${item.unidad.simbolo}',
              l.invCardMinimum,
            ),
            if (item.precioUnitario != null) ...[
              Container(
                width: 1,
                height: 32,
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              _buildStatItem(
                theme,
                _formatCurrency(item.valorTotal ?? 0),
                l.invCardValue,
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildFallbackIcon(
    ThemeData theme,
    Color tipoColor,
    double imageHeight,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getIconForTipo(item.tipo),
            size: imageHeight * 0.35,
            color: tipoColor,
          ),
          AppSpacing.gapSm,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: tipoColor.withValues(alpha: 0.15),
              borderRadius: AppRadius.allSm,
            ),
            child: Text(
              item.tipo.displayName,
              style: theme.textTheme.labelSmall?.copyWith(
                color: tipoColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
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
          color: theme.colorScheme.surface,
          fontWeight: FontWeight.w600,
          fontSize: isSmallScreen ? 10 : 11,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildVencimientoAlert(ThemeData theme, S l) {
    final isVencido = item.vencido;
    final color = isVencido ? AppColors.error : AppColors.warning;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.allSm,
      ),
      child: Text(
        isVencido
            ? l.invCardProductExpired
            : l.invExpiresInDays(item.diasParaVencer.toString()),
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButton(ThemeData theme, S l) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
                elevation: 0,
              ),
              child: Text(
                l.invViewDetails,
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
        Semantics(
          button: true,
          label: l.invMoreOptionsItem,
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
            child: _buildMenuButton(theme, l),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton(ThemeData theme, S l) {
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
      tooltip: l.commonMoreOptions,
      onSelected: (value) {
        switch (value) {
          case 'detalles':
            onTap?.call();
            break;
          case 'editar':
            onEditar?.call();
            break;
          case 'eliminar':
            onEliminar?.call();
            break;
        }
      },
      itemBuilder: (context) {
        final l = S.of(context);
        return [
          PopupMenuItem(
            value: 'detalles',
            height: 48,
            child: Text(
              l.invCardDetails,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          PopupMenuItem(
            value: 'editar',
            height: 48,
            child: Text(
              l.commonEdit,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const PopupMenuDivider(height: 8),
          PopupMenuItem(
            value: 'eliminar',
            height: 48,
            child: Text(
              l.commonDelete,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ];
      },
    );
  }

  // ==================== HELPERS ====================

  String _formatSubtitle() {
    final partes = <String>[item.tipo.displayName];
    if (item.codigo != null && item.codigo!.isNotEmpty) {
      partes.add(item.codigo!);
    }
    return partes.join(' • ');
  }

  String _formatCurrency(double value) {
    return Formatters.currency(value);
  }

  _StatusInfo _getStatusInfo(S l) {
    if (item.agotado) {
      return _StatusInfo(color: AppColors.error, text: l.invCardDepleted);
    } else if (item.stockBajo) {
      return _StatusInfo(color: AppColors.warning, text: l.invCardLowStock);
    } else {
      return _StatusInfo(color: AppColors.success, text: l.invCardAvailable);
    }
  }

  IconData _getIconForTipo(TipoItem tipo) {
    return switch (tipo) {
      TipoItem.alimento => Icons.restaurant,
      TipoItem.medicamento => Icons.medication,
      TipoItem.vacuna => Icons.vaccines,
      TipoItem.equipo => Icons.build,
      TipoItem.insumo => Icons.category,
      TipoItem.limpieza => Icons.cleaning_services,
      TipoItem.otro => Icons.inventory_2,
    };
  }
}

class _StatusInfo {
  final Color color;
  final String text;

  _StatusInfo({required this.color, required this.text});
}
