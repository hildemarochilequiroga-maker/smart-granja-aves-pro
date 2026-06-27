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
import '../../../../lotes/presentation/widgets/historial/historial_components.dart';
import '../../../domain/entities/venta_producto.dart';
import '../../../domain/enums/tipo_producto_venta.dart';
import '../venta_visuals.dart';

/// Tarjeta moderna para mostrar una venta en la lista
class VentaListCard extends StatelessWidget {
  const VentaListCard({
    super.key,
    required this.venta,
    required this.onTap,
    this.index = 0,
    this.onEdit,
    this.onEliminar,
    this.onCambiarEstado,
  });

  final VentaProducto venta;
  final VoidCallback onTap;

  /// Posición en la lista, usada para la animación de entrada escalonada.
  final int index;
  final VoidCallback? onEdit;
  final VoidCallback? onEliminar;
  final VoidCallback? onCambiarEstado;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final estadoColor = venta.estado.color;
    final tipoColor = venta.tipoProducto.color;
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
      child: HistorialRegistroCardShell(
        accentColor: estadoColor,
        borderWidth: 2,
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
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
                    color: estadoColor,
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

            const SizedBox(height: AppSpacing.md),

            // Comprador
            RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: l.ventaCardBuyer,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
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
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
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
    ).staggeredEntrance(index: index);
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

}
