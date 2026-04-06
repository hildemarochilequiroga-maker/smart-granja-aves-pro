/// Card moderna para mostrar una venta en la lista
/// Diseño basado en historial de mortalidad
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_animations.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../domain/entities/venta_producto.dart';
import '../../../domain/enums/tipo_producto_venta.dart';
import '../../../domain/enums/estado_venta.dart';

/// Tarjeta moderna para mostrar una venta en la lista
class VentaListCard extends StatelessWidget {
  const VentaListCard({
    super.key,
    required this.venta,
    required this.onTap,
    this.onEdit,
    this.onEliminar,
    this.onCambiarEstado,
  });

  final VentaProducto venta;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onEliminar;
  final VoidCallback? onCambiarEstado;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final colorScheme = theme.colorScheme;
    final estadoColor = _getEstadoColor(venta.estado);
    final tipoColor = _getTipoColor(venta.tipoProducto, colorScheme);
    final fechaFormat = Formatters.fechaCompletaEs.format(venta.fechaVenta);
    final fechaCapitalizada =
        fechaFormat[0].toUpperCase() + fechaFormat.substring(1);

    return Semantics(
      button: true,
      label: l.semanticsSale(
        venta.tipoProducto.displayName,
        fechaCapitalizada,
        venta.estado.displayName,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppRadius.allMd,
          border: Border.all(color: estadoColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: colorScheme.onSurface.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.allMd,
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              onTap();
            },
            borderRadius: AppRadius.allMd,
            splashColor: estadoColor.withValues(alpha: 0.1),
            highlightColor: estadoColor.withValues(alpha: 0.05),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Primera fila: Fecha/Hora + Badge de total
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fechaCapitalizada,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                Formatters.hora12Es.format(venta.fechaVenta),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.hGapSm,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: AppRadius.allSm,
                          ),
                          child: Text(
                            Formatters.currencyValue(venta.totalFinal),
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Comprador
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: l.ventaCardBuyer,
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          TextSpan(
                            text: venta.cliente.nombre,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    AppSpacing.gapXs,

                    // Tipo de producto con cantidad
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: l.ventaCardProduct,
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          TextSpan(
                            text:
                                '${venta.tipoProducto.displayName} • ${_getCantidadResumen(l)}',
                            style: TextStyle(
                              color: tipoColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).cardEntrance();
  }

  String _getCantidadResumen(S l) {
    switch (venta.tipoProducto) {
      case TipoProductoVenta.avesVivas:
      case TipoProductoVenta.avesDescarte:
      case TipoProductoVenta.avesFaenadas:
        return '${venta.cantidadAves ?? 0} ${l.ventaCardBirds}';
      case TipoProductoVenta.huevos:
        return '${venta.totalHuevos} ${l.ventaCardEggs}';
      case TipoProductoVenta.pollinaza:
        final unidad = venta.unidadPollinaza?.displayName ?? l.unitsFallback;
        return '${venta.cantidadPollinaza?.toStringAsFixed(1) ?? 0} $unidad';
    }
  }

  Color _getTipoColor(TipoProductoVenta tipo, ColorScheme colorScheme) {
    switch (tipo) {
      case TipoProductoVenta.avesVivas:
        return AppColors.warning;
      case TipoProductoVenta.avesFaenadas:
        return AppColors.brown;
      case TipoProductoVenta.avesDescarte:
        return colorScheme.outline;
      case TipoProductoVenta.huevos:
        return AppColors.warning;
      case TipoProductoVenta.pollinaza:
        return AppColors.success;
    }
  }

  Color _getEstadoColor(EstadoVenta estado) {
    switch (estado) {
      case EstadoVenta.pendiente:
        return AppColors.warning;
      case EstadoVenta.confirmada:
        return AppColors.info;
      case EstadoVenta.enPreparacion:
        return AppColors.purple;
      case EstadoVenta.listaParaDespacho:
        return AppColors.cyan;
      case EstadoVenta.enTransito:
        return AppColors.deepOrange;
      case EstadoVenta.entregada:
        return AppColors.success;
      case EstadoVenta.facturada:
        return AppColors.lightGreen;
      case EstadoVenta.cancelada:
        return AppColors.error;
      case EstadoVenta.devuelta:
        return AppColors.pink;
    }
  }
}
