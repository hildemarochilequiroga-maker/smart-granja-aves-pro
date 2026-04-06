/// Paso 1: Información básica del lote.
///
/// Widget modular para el primer paso del formulario de creación/edición de lotes.
/// Captura información fundamental: código, tipo de ave, fecha y cantidad.
library;

// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/enums/enums.dart';
import '../../../../galpones/application/providers/providers.dart';
import '../../../application/providers/providers.dart';
import '../lote_form_field.dart';

/// Paso 1: Información básica del lote
class LoteBasicInfoStep extends ConsumerStatefulWidget {
  final TextEditingController codigoController;
  final TextEditingController cantidadInicialController;
  final TextEditingController edadIngresoController;
  final TipoAve? selectedTipoAve;
  final DateTime? fechaIngreso;
  final ValueChanged<TipoAve?> onTipoAveChanged;
  final ValueChanged<DateTime?> onFechaIngresoChanged;
  final bool autoValidate;
  final bool isEditing;
  final String? galponId;
  final String granjaId;
  final String? loteId;

  const LoteBasicInfoStep({
    super.key,
    required this.codigoController,
    required this.cantidadInicialController,
    required this.edadIngresoController,
    required this.selectedTipoAve,
    required this.fechaIngreso,
    required this.onTipoAveChanged,
    required this.onFechaIngresoChanged,
    required this.autoValidate,
    required this.granjaId,
    this.isEditing = false,
    this.galponId,
    this.loteId,
  });

  @override
  ConsumerState<LoteBasicInfoStep> createState() => _LoteBasicInfoStepState();
}

class _LoteBasicInfoStepState extends ConsumerState<LoteBasicInfoStep> {
  @override
  void initState() {
    super.initState();
    // Auto-generar código solo si está vacío Y no estamos editando
    if (widget.codigoController.text.isEmpty && !widget.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _generateCodigoLote();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _generateCodigoLote() {
    final now = DateTime.now();
    final codigo = 'L-${DateFormat('yyyyMMdd-HHmmss').format(now)}';
    widget.codigoController.text = codigo;
  }

  Future<void> _selectFechaIngreso() async {
    final now = DateTime.now();
    final initialDate = widget.fechaIngreso ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? now : initialDate,
      firstDate: DateTime(2020),
      lastDate: now,
      helpText: S.of(context).batchSelectDate,
      cancelText: S.of(context).commonCancel,
      confirmText: S.of(context).commonConfirm,
    );

    if (picked != null && picked != widget.fechaIngreso) {
      widget.onFechaIngresoChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del paso
          Text(
            S.of(context).batchFormStepBasicInfo,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).batchFormBasicInfoSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.gapXl,

          // Código del lote (auto-generado)
          _buildCodigoField(theme),
          AppSpacing.gapBase,

          // Tipo de ave
          _buildTipoAveDropdown(theme),
          AppSpacing.gapBase,

          // Validación de compatibilidad de tipo de ave
          if (widget.galponId != null && widget.selectedTipoAve != null)
            _buildCompatibilidadTipoAve(theme),

          // Fecha de ingreso
          _buildFechaIngresoField(theme),
          AppSpacing.gapXl,

          // Nota informativa
          _buildNotaInformativa(theme),
        ],
      ),
    );
  }

  Widget _buildCodigoField(ThemeData theme) {
    return LoteFormField(
      controller: widget.codigoController,
      label: S.of(context).batchFormCode,
      hint: S.of(context).batchFormCodeHint,
      enabled: false,
    );
  }

  Widget _buildTipoAveDropdown(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = theme.colorScheme.onSurface.withValues(alpha: 0.8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${S.of(context).batchFormBirdType} *',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: labelColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        AppSpacing.gapSm,
        DropdownButtonFormField<TipoAve>(
          initialValue: widget.selectedTipoAve,
          autovalidateMode: widget.autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          decoration: InputDecoration(
            hintText: S.of(context).batchFormSelectType,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.normal,
            ),
            filled: true,
            fillColor: widget.isEditing
                ? (isDark
                          ? theme.colorScheme.surface
                          : theme.colorScheme.surface)
                      .withValues(alpha: 0.5)
                : (isDark
                      ? theme.colorScheme.surface
                      : theme.colorScheme.surface),
            border: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
              height: 1.2,
            ),
          ),
          isExpanded: true,
          selectedItemBuilder: (BuildContext context) {
            return TipoAve.values.map((tipo) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  tipo.localizedDisplayName(S.of(context)),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },
          items: TipoAve.values.map((tipo) {
            return DropdownMenuItem(
              value: tipo,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tipo.localizedDisplayName(S.of(context)),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _getTipoDescripcion(tipo),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: widget.isEditing ? null : widget.onTipoAveChanged,
          validator: (value) {
            if (value == null) {
              return S.of(context).batchSelectBirdType;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCompatibilidadTipoAve(ThemeData theme) {
    return Consumer(
      builder: (context, ref, child) {
        final galponAsync = ref.watch(galponByIdProvider(widget.galponId!));

        return galponAsync.when(
          data: (galpon) {
            if (galpon == null) return const SizedBox.shrink();

            final lotesActivosAsync = ref.watch(
              loteActivoGalponProvider(widget.galponId!),
            );

            return lotesActivosAsync.when(
              data: (loteActual) {
                // Si hay un lote activo en el galpón, mostrar advertencia
                if (loteActual != null && !widget.isEditing) {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: AppRadius.allSm,
                          border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          S
                              .of(context)
                              .loteShedActiveWarning(loteActual.codigo),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.warning,
                            height: 1.5,
                          ),
                        ),
                      ),
                      AppSpacing.gapBase,
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildFechaIngresoField(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = theme.colorScheme.onSurface.withValues(alpha: 0.8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${S.of(context).batchFormEntryDate} *',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: labelColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        AppSpacing.gapSm,
        InkWell(
          onTap: widget.isEditing ? null : _selectFechaIngreso,
          borderRadius: AppRadius.allSm,
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: widget.isEditing
                  ? (isDark
                            ? theme.colorScheme.surface
                            : theme.colorScheme.surface)
                        .withValues(alpha: 0.5)
                  : (isDark
                        ? theme.colorScheme.surface
                        : theme.colorScheme.surface),
              border: OutlineInputBorder(
                borderRadius: AppRadius.allSm,
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.allSm,
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.fechaIngreso != null
                        ? DateFormat('dd/MM/yyyy').format(widget.fechaIngreso!)
                        : S.of(context).batchSelectDate,
                    style: widget.fechaIngreso != null
                        ? theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                          )
                        : theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.4,
                            ),
                          ),
                  ),
                ),
                if (!widget.isEditing)
                  Icon(
                    Icons.calendar_today_outlined,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotaInformativa(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: AppRadius.allSm,
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).batchAttention,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            S.of(context).batchFormBasicInfoNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTipoIcon(TipoAve tipo) {
    switch (tipo) {
      case TipoAve.polloEngorde:
        return Icons.restaurant_outlined;
      case TipoAve.gallinaPonedora:
        return Icons.egg_alt_outlined;
      case TipoAve.reproductoraPesada:
        return Icons.workspace_premium_outlined;
      case TipoAve.reproductoraLiviana:
        return Icons.stars_outlined;
      case TipoAve.pavo:
        return Icons.celebration_outlined;
      case TipoAve.codorniz:
        return Icons.flutter_dash_outlined;
      case TipoAve.pato:
        return Icons.water_outlined;
      case TipoAve.otro:
        return Icons.pets_outlined;
    }
  }

  Color _getTipoColor(TipoAve tipo) {
    switch (tipo) {
      case TipoAve.polloEngorde:
        return AppColors.warning;
      case TipoAve.gallinaPonedora:
        return AppColors.success;
      case TipoAve.reproductoraPesada:
        return AppColors.purple;
      case TipoAve.reproductoraLiviana:
        return AppColors.info;
      case TipoAve.pavo:
        return AppColors.error;
      case TipoAve.codorniz:
        return AppColors.teal;
      case TipoAve.pato:
        return AppColors.info;
      case TipoAve.otro:
        return AppColors.grey600;
    }
  }

  String _getTipoDescripcion(TipoAve tipo) {
    switch (tipo) {
      case TipoAve.gallinaPonedora:
        return S.of(context).birdDescFormGallinaPonedora;
      case TipoAve.polloEngorde:
        return S.of(context).birdDescFormPolloEngorde;
      case TipoAve.reproductoraPesada:
        return S.of(context).birdDescFormRepPesada;
      case TipoAve.reproductoraLiviana:
        return S.of(context).birdDescFormRepLiviana;
      case TipoAve.pavo:
        return S.of(context).birdDescFormPavo;
      case TipoAve.codorniz:
        return S.of(context).birdDescFormCodorniz;
      case TipoAve.pato:
        return S.of(context).birdDescFormPato;
      case TipoAve.otro:
        return S.of(context).birdDescFormOtro;
    }
  }
}
