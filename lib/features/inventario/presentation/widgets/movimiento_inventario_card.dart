/// Widget de tarjeta para mostrar un movimiento de inventario.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/entities.dart';

/// Widget de tarjeta para mostrar un movimiento de inventario en listas.
class MovimientoInventarioCard extends StatelessWidget {
  const MovimientoInventarioCard({
    super.key,
    required this.movimiento,
    this.onTap,
    this.compact = false,
    this.showItemName = false,
    this.itemName,
  });

  final MovimientoInventario movimiento;
  final VoidCallback? onTap;
  final bool compact;
  final bool showItemName;
  final String? itemName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final isEntrada = movimiento.tipo.esEntrada;
    final color = isEntrada ? AppColors.success : AppColors.error;

    if (compact) {
      return _buildCompactCard(theme, color, isEntrada);
    }

    return Semantics(
      button: onTap != null,
      label: l.semanticsInventoryMovement(
        movimiento.tipo.displayName,
        isEntrada ? l.semanticsDirectionEntry : l.semanticsDirectionExit,
        movimiento.cantidad.toString(),
        l.semanticsUnits,
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
          child: InkWell(
            onTap: onTap == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    onTap?.call();
                  },
            borderRadius: AppRadius.allMd,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header: Tipo de movimiento + Cantidad
                  _buildHeader(theme, color, isEntrada),
                  AppSpacing.gapBase,

                  // Info del stock
                  _buildStockInfo(theme, color, l),

                  // Motivo si existe
                  if (movimiento.motivo != null &&
                      movimiento.motivo!.isNotEmpty) ...[
                    AppSpacing.gapMd,
                    _buildMotivoSection(theme),
                  ],
                ],
              ),
            ),
          ),
        ),
      ).cardEntrance(),
    );
  }

  Widget _buildCompactCard(ThemeData theme, Color color, bool isEntrada) {
    final dateFormat = Formatters.fechaDDMMHHmm;
    final signo = isEntrada ? '+' : '-';

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
                // Indicador de entrada/salida
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                AppSpacing.hGapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movimiento.tipo.displayName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        dateFormat.format(movimiento.fecha),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Text(
                    '$signo${movimiento.cantidad}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, Color color, bool isEntrada) {
    final dateFormat = Formatters.fechaCompleta24hEs;
    final signo = isEntrada ? '+' : '-';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showItemName && itemName != null) ...[
                Text(
                  itemName!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
              ],
              Text(
                movimiento.tipo.displayName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: showItemName ? FontWeight.w500 : FontWeight.bold,
                  color: showItemName
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateFormat.format(movimiento.fecha),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        // Badge de cantidad
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadius.allSm,
          ),
          child: Text(
            '$signo${movimiento.cantidad}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStockInfo(ThemeData theme, Color color, S l) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppRadius.allSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            theme,
            '${movimiento.stockAnterior}',
            l.invStockBefore,
          ),
          Icon(
            Icons.arrow_forward,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          _buildStatItem(
            theme,
            '${movimiento.stockNuevo}',
            l.invStockAfter,
            highlight: true,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    String value,
    String label, {
    bool highlight = false,
    Color? color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: highlight ? color : theme.colorScheme.onSurface,
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

  Widget _buildMotivoSection(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: AppRadius.allSm,
      ),
      child: Text(
        movimiento.motivo!,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
