/// Card de acciones rápidas del lote.
///
/// Widget modular que muestra las acciones disponibles
/// para registrar datos del lote.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_breakpoints.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/lote.dart';
import '../../../domain/enums/enums.dart';

/// Card con acciones rápidas de registro
class AccionesRapidasCard extends StatelessWidget {
  const AccionesRapidasCard({super.key, required this.lote});

  final Lote lote;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).batchQuickActions,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            AppSpacing.gapBase,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AccionChip(
                  icono: Icons.scale,
                  label: S.of(context).batchRegisterWeight,
                  onTap: () => context.push(
                    AppRoutes.loteRegistrarPesoById(lote.granjaId, lote.id),
                    extra: lote,
                  ),
                ),
                AccionChip(
                  icono: Icons.restaurant,
                  label: S.of(context).batchRegisterConsumption,
                  onTap: () => context.push(
                    AppRoutes.loteRegistrarConsumoById(lote.granjaId, lote.id),
                    extra: lote,
                  ),
                ),
                AccionChip(
                  icono: Icons.warning_amber,
                  label: S.of(context).batchRegisterMortality,
                  onTap: () => context.push(
                    AppRoutes.loteRegistrarMortalidadById(
                      lote.granjaId,
                      lote.id,
                    ),
                    extra: lote,
                  ),
                ),
                if (lote.tipoAve == TipoAve.gallinaPonedora)
                  AccionChip(
                    icono: Icons.egg,
                    label: S.of(context).batchRegisterProduction,
                    onTap: () => context.push(
                      AppRoutes.loteRegistrarProduccionById(
                        lote.granjaId,
                        lote.id,
                      ),
                      extra: lote,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip individual de acción
class AccionChip extends StatelessWidget {
  const AccionChip({
    super.key,
    required this.icono,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icono;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ActionChip(
      avatar: Icon(icono, size: 18, color: color),
      label: Text(
        label,
        style: color != null
            ? theme.textTheme.bodyMedium?.copyWith(color: color)
            : null,
      ),
      onPressed: onTap,
      side: color != null
          ? BorderSide(color: color!.withValues(alpha: 0.5))
          : null,
    );
  }
}

/// Grid de acciones más grande para pantallas amplias
class AccionesRapidasGrid extends StatelessWidget {
  const AccionesRapidasGrid({super.key, required this.lote});

  final Lote lote;

  @override
  Widget build(BuildContext context) {
    final acciones = [
      _AccionData(
        icono: Icons.scale,
        label: S.of(context).batchTabWeight,
        descripcion: S.of(context).batchRegisterWeight,
        color: AppColors.purple,
        ruta: AppRoutes.loteRegistrarPesoById(lote.granjaId, lote.id),
      ),
      _AccionData(
        icono: Icons.restaurant,
        label: S.of(context).batchTabConsumption,
        descripcion: S.of(context).batchRegisterConsumption,
        color: AppColors.success,
        ruta: AppRoutes.loteRegistrarConsumoById(lote.granjaId, lote.id),
      ),
      _AccionData(
        icono: Icons.warning_amber,
        label: S.of(context).batchTabMortality,
        descripcion: S.of(context).batchRegisterMortality,
        color: AppColors.error,
        ruta: AppRoutes.loteRegistrarMortalidadById(lote.granjaId, lote.id),
      ),
      if (lote.tipoAve == TipoAve.gallinaPonedora)
        _AccionData(
          icono: Icons.egg,
          label: S.of(context).batchTabProduction,
          descripcion: S.of(context).batchRegisterProduction,
          color: AppColors.warning,
          ruta: AppRoutes.loteRegistrarProduccionById(lote.granjaId, lote.id),
        ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).batchQuickActions,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            AppSpacing.gapBase,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppBreakpoints.of(context).gridColumns,
                childAspectRatio: 1.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: acciones.length,
              itemBuilder: (context, index) {
                final accion = acciones[index];
                return _AccionTile(accion: accion);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AccionData {
  const _AccionData({
    required this.icono,
    required this.label,
    required this.descripcion,
    required this.color,
    required this.ruta,
  });

  final IconData icono;
  final String label;
  final String descripcion;
  final Color color;
  final String ruta;
}

class _AccionTile extends StatelessWidget {
  const _AccionTile({required this.accion});

  final _AccionData accion;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(accion.ruta),
      borderRadius: AppRadius.allMd,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: accion.color.withValues(alpha: 0.1),
          borderRadius: AppRadius.allMd,
          border: Border.all(color: accion.color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(accion.icono, color: accion.color, size: 28),
            AppSpacing.gapSm,
            Text(
              accion.label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: accion.color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              accion.descripcion,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
