/// Paso 2: Ubicación del lote.
///
/// Widget modular para seleccionar el galpón donde se alojará el lote
/// y agregar observaciones opcionales.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/presentation/widgets/registro_pickers.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../galpones/application/providers/providers.dart';
import '../../../application/providers/providers.dart';

/// Paso 2: Ubicación y observaciones del lote
class LoteUbicacionStep extends ConsumerStatefulWidget {
  final String granjaId;
  final TextEditingController observacionesController;
  final String? selectedGalponId;
  final String? preselectedGalponId;
  final ValueChanged<String?> onGalponChanged;
  final bool autoValidate;
  final bool isEditing;

  const LoteUbicacionStep({
    super.key,
    required this.granjaId,
    required this.observacionesController,
    required this.selectedGalponId,
    required this.onGalponChanged,
    required this.autoValidate,
    this.preselectedGalponId,
    this.isEditing = false,
  });

  @override
  ConsumerState<LoteUbicacionStep> createState() => _LoteUbicacionStepState();
}

class _LoteUbicacionStepState extends ConsumerState<LoteUbicacionStep> {
  @override
  void initState() {
    super.initState();

    // Si hay galpón preseleccionado y selectedGalponId es null, forzar selección
    if (widget.preselectedGalponId != null && widget.selectedGalponId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onGalponChanged(widget.preselectedGalponId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final galponesAsync = ref.watch(galponesStreamProvider(widget.granjaId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del paso
          Text(
            S.of(context).batchFormShed,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            widget.preselectedGalponId != null
                ? S.of(context).batchFormShedLocationInfo
                : S.of(context).batchFormSelectShed,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapBase,

          // Selector de galpón o información de galpón (si viene preseleccionado)
          _buildGalponSelector(galponesAsync),

          AppSpacing.gapLg,

          // Observaciones (opcional)
          _buildObservacionesField(),
        ],
      ),
    );
  }

  Widget _buildGalponSelector(AsyncValue galponesAsync) {
    return galponesAsync.when(
      data: (galpones) {
        // Filtrar solo galpones activos
        final galponesActivos = galpones
            .where(
              (galpon) => galpon.estado.toString().split('.').last == 'activo',
            )
            .toList();

        if (galponesActivos.isEmpty) {
          return _buildNoGalponesWarning();
        }

        // Si viene preseleccionado Y NO es edición, mostrar SOLO Card informativa
        if (widget.preselectedGalponId != null && !widget.isEditing) {
          final galpon = galponesActivos.firstWhere(
            (g) => g.id == widget.preselectedGalponId,
            orElse: () => galponesActivos.first,
          );

          return _buildGalponInfoCard(galpon);
        }

        // Si NO viene preseleccionado, mostrar dropdown para selección manual
        return _buildGalponDropdown(galponesActivos);
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => _buildErrorWidget(error),
    );
  }

  Widget _buildNoGalponesWarning() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: AppRadius.allMd,
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warning,
            size: 48,
          ),
          AppSpacing.gapMd,
          Text(
            S.of(context).batchTransferNoSheds,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).batchFormCreateShedFirst,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalponInfoCard(dynamic galpon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loteActualAsync = ref.watch(
      loteActivoGalponProvider(widget.preselectedGalponId!),
    );

    return loteActualAsync.when(
      data: (loteActual) {
        final tieneAvesActuales = loteActual != null;
        final avesActuales = tieneAvesActuales ? loteActual.avesDisponibles : 0;
        final capacidadDisponible = galpon.capacidadMaxima - avesActuales;
        final porcentajeOcupacion =
            ((avesActuales / galpon.capacidadMaxima) * 100).toStringAsFixed(1);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: AppRadius.allMd,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.allSm,
                    ),
                    child: Icon(
                      Icons.home_work_rounded,
                      color: colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                  AppSpacing.hGapMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).commonGalponAvicola,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        AppSpacing.gapXxxs,
                        Text(
                          galpon.nombre,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppSpacing.gapBase,
              Divider(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                height: 1,
              ),
              AppSpacing.gapBase,
              _buildInfoRow(S.of(context).commonCode, galpon.codigo),
              _buildInfoRow(
                S.of(context).commonType,
                galpon.tipo.localizedDisplayName(S.of(context)),
              ),
              _buildInfoRow(
                S.of(context).commonState,
                galpon.estado.localizedDisplayName(S.of(context)),
              ),
              _buildInfoRow(
                S.of(context).commonMaxCapacity,
                S
                    .of(context)
                    .ubicacionBirdsCount(galpon.capacidadMaxima.toString()),
              ),
              if (galpon.areaM2 != null)
                _buildInfoRow(S.of(context).commonArea, '${galpon.areaM2} m²'),
              AppSpacing.gapBase,
              Divider(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                height: 1,
              ),
              AppSpacing.gapBase,
              Text(
                S.of(context).ubicacionCurrentOccupation,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.gapMd,
              _buildInfoRow(
                S.of(context).ubicacionCurrentBirds,
                S.of(context).ubicacionBirdsCount(avesActuales.toString()),
              ),
              _buildInfoRow(
                S.of(context).ubicacionAvailableCapacity,
                S
                    .of(context)
                    .ubicacionBirdsCount(capacidadDisponible.toString()),
              ),
              _buildInfoRow(
                S.of(context).ubicacionOccupation,
                '$porcentajeOcupacion%',
              ),
              if (tieneAvesActuales) ...[
                AppSpacing.gapSm,
                _buildInfoRow(
                  S.of(context).ubicacionBirdTypeInShed,
                  loteActual.tipoAve.localizedDisplayName(S.of(context)),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: AppRadius.allMd,
          border: Border.all(color: colorScheme.outlineVariant, width: 1),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildGalponDropdown(List<dynamic> galponesActivos) {
    final selectedGalponId =
        galponesActivos.any((galpon) => galpon.id == widget.selectedGalponId)
        ? widget.selectedGalponId
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RegistroSelectorField<String>(
          label: S.of(context).batchFormShed,
          required: true,
          value: selectedGalponId,
          hint: S.of(context).batchSelectShed,
          options: galponesActivos.map((g) => g.id as String).toList(),
          labelOf: (id) =>
              galponesActivos.firstWhere((g) => g.id == id).nombre as String,
          subtitleOf: (id) {
            final g = galponesActivos.firstWhere((gg) => gg.id == id);
            return S
                .of(context)
                .ubicacionShedDropdown(g.codigo, g.capacidadMaxima.toString());
          },
          onSelected: (id) => widget.onGalponChanged(id),
        ),
      ],
    );
  }

  Widget _buildObservacionesField() {
    final colorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: widget.observacionesController,
      decoration: InputDecoration(
        labelText:
            '${S.of(context).batchFormObservations} (${S.of(context).batchFormOptional})',
        hintText: S.of(context).batchFormObservationsHint,
        helperText: S.of(context).batchFormNotesHint,
        helperMaxLines: 2,
        errorMaxLines: 2,
        border: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.md,
        ),
      ),
      maxLines: 3,
      textInputAction: TextInputAction.done,
    );
  }

  Widget _buildErrorWidget(Object error) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: AppRadius.allMd,
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
          AppSpacing.gapMd,
          Text(
            S.of(context).commonErrorLoadingShed,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
