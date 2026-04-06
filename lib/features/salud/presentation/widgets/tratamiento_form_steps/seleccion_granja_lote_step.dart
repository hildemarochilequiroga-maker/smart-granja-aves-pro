/// Step 0: Selección de Lote para el tratamiento
/// Diseño consistente con los steps de granjas
///
/// Este step solo aparece cuando no se proporciona el loteId desde la navegación.
/// Si se accede desde el Home con una granja seleccionada, solo se pide el lote.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../granjas/domain/entities/granja.dart';
import '../../../../granjas/application/providers/granja_providers.dart';
import '../../../../lotes/application/providers/lote_providers.dart';
import '../../../../lotes/domain/enums/estado_lote.dart';

/// Step de selección de ubicación (granja y lote)
class SeleccionGranjaLoteStep extends ConsumerWidget {
  const SeleccionGranjaLoteStep({
    super.key,
    required this.selectedGranjaId,
    required this.selectedLoteId,
    required this.onGranjaChanged,
    required this.onLoteChanged,
    this.autoValidate = false,
    this.soloLote = false,
  });

  final String? selectedGranjaId;
  final String? selectedLoteId;
  final void Function(String?) onGranjaChanged;
  final void Function(String?) onLoteChanged;
  final bool autoValidate;

  /// Si es true, solo muestra el selector de lote (granja ya viene seleccionada)
  final bool soloLote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = S.of(context);

    // Si solo pedimos lote y ya tenemos granja, mostrar directo los lotes
    if (soloLote && selectedGranjaId != null) {
      return _buildSoloLoteContent(context, ref, theme, l);
    }

    // Si necesitamos seleccionar granja también
    final granjasAsync = ref.watch(granjasStreamProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            soloLote
                ? l.treatStepSelectBatchTitle
                : l.treatStepSelectLocationTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            soloLote
                ? l.treatStepSelectBatchDesc
                : l.treatStepSelectLocationDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.gapXl,

          granjasAsync.when(
            data: (granjas) {
              if (granjas.isEmpty) {
                return _buildEmptyState(
                  context,
                  theme,
                  l.treatStepNoFarms,
                  l.treatStepNoFarmsDesc,
                  Icons.home_work_outlined,
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!soloLote) ...[
                    _buildGranjaSelector(context, theme, granjas, l),
                    AppSpacing.gapLg,
                  ],
                  if (selectedGranjaId != null)
                    _buildLoteSelector(context, ref, theme, l),
                ],
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => _buildEmptyState(
              context,
              theme,
              l.treatStepFarmsError,
              error.toString(),
              Icons.error_outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoloLoteContent(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    S l,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            l.treatStepSelectBatchTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.treatStepSelectBatchSubDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.gapXl,

          _buildLoteSelector(context, ref, theme, l),
        ],
      ),
    );
  }

  Widget _buildGranjaSelector(
    BuildContext context,
    ThemeData theme,
    List<Granja> granjas,
    S l,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.treatStepFarmRequired,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        AppSpacing.gapSm,
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppRadius.allSm,
            border: Border.all(
              color: autoValidate && selectedGranjaId == null
                  ? AppColors.error
                  : theme.colorScheme.outline.withValues(alpha: 0.4),
              width: autoValidate && selectedGranjaId == null ? 1.5 : 1,
            ),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: selectedGranjaId,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              prefixIcon: Icon(
                Icons.home_work,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              border: InputBorder.none,
              hintText: l.treatStepSelectFarm,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            items: granjas.map((granja) {
              return DropdownMenuItem<String>(
                value: granja.id,
                child: Text(
                  granja.nombre,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
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
            padding: const EdgeInsets.only(left: 12, top: 6),
            child: Text(
              l.treatStepFarmValidation,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoteSelector(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    S l,
  ) {
    final lotesAsync = ref.watch(lotesStreamProvider(selectedGranjaId!));

    return lotesAsync.when(
      data: (lotes) {
        final lotesActivos = lotes
            .where((l) => l.estado == EstadoLote.activo)
            .toList();

        if (lotesActivos.isEmpty) {
          return _buildEmptyState(
            context,
            theme,
            l.treatStepNoActiveBatches,
            l.treatStepNoActiveBatchesDesc,
            Icons.inventory_2_outlined,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.treatStepBatchRequired,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            AppSpacing.gapSm,
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: AppRadius.allSm,
                border: Border.all(
                  color: autoValidate && selectedLoteId == null
                      ? AppColors.error
                      : theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: autoValidate && selectedLoteId == null ? 1.5 : 1,
                ),
              ),
              child: DropdownButtonFormField<String>(
                initialValue: selectedLoteId,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.inventory_2,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  hintText: l.treatStepSelectBatch,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                items: lotesActivos.map((lote) {
                  return DropdownMenuItem<String>(
                    value: lote.id,
                    child: Text(
                        S.of(context).batchDropdownItemName(lote.nombre ?? l.batchBatch, '${lote.cantidadActual}'),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: onLoteChanged,
              ),
            ),
            if (autoValidate && selectedLoteId == null)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 6),
                child: Text(
                  l.treatStepBatchValidation,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => _buildEmptyState(
        context,
        theme,
        l.treatStepBatchesError,
        error.toString(),
        Icons.error_outline,
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppRadius.allMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          AppSpacing.gapBase,
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapSm,
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
