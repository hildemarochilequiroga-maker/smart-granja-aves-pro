/// Card de información general del lote.
///
/// Widget modular que muestra los datos generales
/// del lote (código, tipo, raza, proveedor, fechas).
library;

import 'package:flutter/material.dart';

import '../../../../../core/utils/formatters.dart';
import '../../../domain/entities/lote.dart';
import '../../../domain/enums/enums.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Card que muestra la información general del lote
class InfoGeneralCard extends StatelessWidget {
  const InfoGeneralCard({super.key, required this.lote});

  final Lote lote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = Formatters.fechaDDMMYYYY;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).batchInfoGeneral,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            InfoRow(
              icono: Icons.tag,
              titulo: S.of(context).batchCodeLabel,
              valor: lote.codigo,
            ),
            InfoRow(
              icono: lote.tipoAve.iconoData,
              titulo: S.of(context).batchBirdType,
              valor: lote.tipoAve.localizedDisplayName(S.of(context)),
            ),
            if (lote.raza != null)
              InfoRow(
                icono: Icons.psychology,
                titulo: S.of(context).loteRazaLineaLabel,
                valor: lote.raza!,
              ),
            if (lote.proveedor != null)
              InfoRow(
                icono: Icons.business,
                titulo: S.of(context).batchSupplier,
                valor: lote.proveedor!,
              ),
            InfoRow(
              icono: Icons.calendar_month,
              titulo: S.of(context).batchEntryDate,
              valor: dateFormat.format(lote.fechaIngreso),
            ),
            if (lote.fechaCierreEstimada != null)
              InfoRow(
                icono: Icons.event,
                titulo: S.of(context).loteCierreEstimado,
                valor: dateFormat.format(lote.fechaCierreEstimada!),
              ),
            if (lote.diasRestantes != null)
              InfoRow(
                icono: Icons.timelapse,
                titulo: S.of(context).loteDiasRestantes,
                valor: S.of(context).batchDaysCount(lote.diasRestantes!),
              ),
          ],
        ),
      ),
    );
  }
}

/// Fila de información con icono
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icono,
    required this.titulo,
    required this.valor,
    this.valorColor,
  });

  final IconData icono;
  final String titulo;
  final String valor;
  final Color? valorColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icono, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              titulo,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            valor,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: valorColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Extensión para obtener icono del tipo de ave
extension TipoAveIconExtension on TipoAve {
  IconData get iconoData {
    switch (this) {
      case TipoAve.polloEngorde:
        return Icons.restaurant;
      case TipoAve.gallinaPonedora:
        return Icons.egg;
      case TipoAve.reproductoraPesada:
        return Icons.favorite;
      case TipoAve.reproductoraLiviana:
        return Icons.favorite_border;
      case TipoAve.pavo:
        return Icons.pets;
      case TipoAve.codorniz:
        return Icons.flutter_dash;
      case TipoAve.pato:
        return Icons.water_drop;
      case TipoAve.otro:
        return Icons.pets;
    }
  }
}
