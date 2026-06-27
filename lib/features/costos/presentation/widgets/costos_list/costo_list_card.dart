/// Card moderna para mostrar un costo en la lista
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
import '../../../domain/entities/costo_gasto.dart';
import '../../../domain/enums/tipo_gasto.dart';
import '../costo_tipo_visuals.dart';

/// Tarjeta moderna para mostrar un costo en la lista
class CostoListCard extends StatelessWidget {
  const CostoListCard({
    super.key,
    required this.costo,
    required this.onTap,
    this.index = 0,
    this.onEdit,
    this.onAprobar,
    this.onRechazar,
    this.onEliminar,
  });

  final CostoGasto costo;
  final VoidCallback onTap;

  /// Posición en la lista, usada para la animación de entrada escalonada.
  final int index;
  final VoidCallback? onEdit;
  final VoidCallback? onAprobar;
  final VoidCallback? onRechazar;
  final VoidCallback? onEliminar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final tipoColor = costo.tipo.color;
    final fechaFormat = Formatters.fechaCompletaEs.format(costo.fecha);
    final fechaCapitalizada =
        fechaFormat[0].toUpperCase() + fechaFormat.substring(1);

    return Semantics(
      button: true,
      label: l.semanticsCost(
        costo.concepto,
        costo.tipo.displayName,
        fechaCapitalizada,
      ),
      child: HistorialRegistroCardShell(
        accentColor: tipoColor,
        borderWidth: 2,
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primera fila: Fecha/Hora + Badge de monto
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
                      AppSpacing.gapXxxs,
                      Text(
                        Formatters.hora12Es.format(costo.fecha),
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
                    color: tipoColor,
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Text(
                    Formatters.currencyValue(costo.monto),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Tipo de gasto
            RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: l.costoCardType,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  TextSpan(
                    text: _getTipoLabel(context, costo.tipo),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: tipoColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            AppSpacing.gapXs,

            // Concepto
            RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: l.costoCardConcept,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  TextSpan(
                    text: costo.concepto,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Proveedor (si existe)
            if (costo.proveedor != null && costo.proveedor!.isNotEmpty) ...[
              AppSpacing.gapXs,
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: theme.textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: l.costoCardSupplier,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextSpan(
                      text: costo.proveedor!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ).staggeredEntrance(index: index);
  }

  String _getTipoLabel(BuildContext context, TipoGasto tipo) {
    final l = S.of(context);
    switch (tipo) {
      case TipoGasto.compraAves:
        return l.costoTypeCompraAves;
      case TipoGasto.alimento:
        return l.costoTypeAlimento;
      case TipoGasto.manoDeObra:
        return l.costoTypeManoDeObra;
      case TipoGasto.energia:
        return l.costoTypeEnergia;
      case TipoGasto.medicamento:
        return l.costoTypeMedicamento;
      case TipoGasto.cama:
        return l.costoTypeCama;
      case TipoGasto.mantenimiento:
        return l.costoTypeMantenimiento;
      case TipoGasto.agua:
        return l.costoTypeAgua;
      case TipoGasto.transporte:
        return l.costoTypeTransporte;
      case TipoGasto.administrativo:
        return l.costoTypeAdministrativo;
      case TipoGasto.depreciacion:
        return l.costoTypeDepreciacion;
      case TipoGasto.financiero:
        return l.costoTypeFinanciero;
      case TipoGasto.otros:
        return l.costoTypeOtros;
    }
  }
}
