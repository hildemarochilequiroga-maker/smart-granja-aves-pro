import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../granjas/domain/entities/granja.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../../lotes/application/providers/lote_providers.dart';
import '../../../lotes/domain/enums/estado_lote.dart';

/// Step 0: Seleccion de Granja y Lote para Ventas
class SeleccionGranjaLoteVentaStep extends ConsumerWidget {
  const SeleccionGranjaLoteVentaStep({
    super.key,
    required this.selectedGranjaId,
    required this.selectedLoteId,
    required this.onGranjaChanged,
    required this.onLoteChanged,
    this.autoValidate = false,
  });

  final String? selectedGranjaId;
  final String? selectedLoteId;
  final void Function(String?) onGranjaChanged;
  final void Function(String?) onLoteChanged;
  final bool autoValidate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final granjasAsync = ref.watch(granjasStreamProvider);
    final theme = Theme.of(context);
    final l = S.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.ventaStepSelectLocation,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(l.ventaStepSelectLocationDesc, style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.store,
                size: 64,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          granjasAsync.when(
            data: (granjas) {
              if (granjas.isEmpty) {
                return _buildEmptyState(
                  context,
                  l.ventaStepNoFarms,
                  l.selectFarmCreateFirst,
                  Icons.home_work_outlined,
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGranjaSelector(context, granjas),
                  const SizedBox(height: AppSpacing.lg),
                  if (selectedGranjaId != null)
                    _buildLoteSelector(context, ref),
                ],
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xxl),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => _buildEmptyState(
              context,
              S.of(context).ventaFarmLoadError,
              error.toString(),
              Icons.error_outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGranjaSelector(BuildContext context, List<Granja> granjas) {
    final l = S.of(context);
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.ventaStepFarmRequired,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.allMd,
            border: Border.all(
              color: autoValidate && selectedGranjaId == null
                  ? AppColors.error
                  : colorScheme.outlineVariant,
              width: 1.5,
            ),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: selectedGranjaId,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.md,
              ),
              prefixIcon: const Icon(Icons.home_work, color: AppColors.primary),
              border: InputBorder.none,
              hintText: S.of(context).ventaSelectFarmHint,
            ),
            items: granjas.map((granja) {
              return DropdownMenuItem<String>(
                value: granja.id,
                child: Text(
                  granja.nombre,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) {
              onGranjaChanged(value);
              if (value != selectedGranjaId) {
                onLoteChanged(null);
              }
            },
          ),
        ),
        if (autoValidate && selectedGranjaId == null)
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              top: AppSpacing.sm,
            ),
            child: Text(
              l.ventaStepSelectFarmFirst,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoteSelector(BuildContext context, WidgetRef ref) {
    final l = S.of(context);
    final theme = Theme.of(context);
    final lotesAsync = ref.watch(lotesStreamProvider(selectedGranjaId!));

    return lotesAsync.when(
      data: (lotes) {
        final lotesActivos = lotes
            .where((l) => l.estado == EstadoLote.activo)
            .toList();

        if (lotesActivos.isEmpty) {
          return _buildEmptyState(
            context,
            l.ventaStepNoActiveBatches,
            l.selectFarmNoActiveLots,
            Icons.inventory_2_outlined,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.ventaStepBatchRequired,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              decoration: BoxDecoration(
                borderRadius: AppRadius.allMd,
                border: Border.all(
                  color: autoValidate && selectedLoteId == null
                      ? AppColors.error
                      : theme.colorScheme.outlineVariant,
                  width: 1.5,
                ),
              ),
              child: DropdownButtonFormField<String>(
                initialValue: selectedLoteId,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.base,
                    vertical: AppSpacing.md,
                  ),
                  prefixIcon: const Icon(
                    Icons.inventory_2,
                    color: AppColors.primary,
                  ),
                  border: InputBorder.none,
                  hintText: S.of(context).ventaSelectBatchHint,
                ),
                items: lotesActivos.map((lote) {
                  final loteNombre = lote.nombre ?? S.of(context).commonBatch;
                  return DropdownMenuItem<String>(
                    value: lote.id,
                    child: Text(
                      loteNombre,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: onLoteChanged,
              ),
            ),
            if (autoValidate && selectedLoteId == null)
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.md,
                  top: AppSpacing.sm,
                ),
                child: Text(
                  l.ventaStepSelectBatch,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.base),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => _buildEmptyState(
        context,
        S.of(context).ventaBatchLoadError,
        error.toString(),
        Icons.error_outline,
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    //     final l = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.allMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: colorScheme.outline),
          const SizedBox(height: AppSpacing.base),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
