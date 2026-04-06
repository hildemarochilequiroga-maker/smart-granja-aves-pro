/// Step 1: Informaci�n B�sica del Galp�n
/// C�digo, nombre, tipo, estado y descripci�n
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../granjas/application/providers/granja_providers.dart';
import '../../../application/providers/galpon_providers.dart';
import '../../../domain/enums/estado_galpon.dart';
import '../../../domain/enums/tipo_galpon.dart';
import '../galpon_form_field.dart';

/// Step de informaci�n b�sica del galp�n
class BasicInfoStep extends ConsumerStatefulWidget {
  const BasicInfoStep({
    super.key,
    required this.codigoController,
    required this.nombreController,
    required this.descripcionController,
    required this.tipoGalpon,
    required this.estadoGalpon,
    required this.onTipoGalponChanged,
    required this.onEstadoGalponChanged,
    required this.granjaId,
    this.autoValidate = false,
    this.isEditing = false,
  });

  final TextEditingController codigoController;
  final TextEditingController nombreController;
  final TextEditingController descripcionController;
  final TipoGalpon? tipoGalpon;
  final EstadoGalpon estadoGalpon;
  final ValueChanged<TipoGalpon?> onTipoGalponChanged;
  final ValueChanged<EstadoGalpon?> onEstadoGalponChanged;
  final String granjaId;
  final bool autoValidate;
  final bool isEditing;

  @override
  ConsumerState<BasicInfoStep> createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends ConsumerState<BasicInfoStep> {
  bool _codigoValid = false;
  bool _nombreValid = false;

  @override
  void initState() {
    super.initState();
    widget.codigoController.addListener(_validateCodigo);
    widget.nombreController.addListener(_validateNombre);
    // Validar valores iniciales
    _validateCodigo();
    _validateNombre();

    // Auto-generar c�digo solo si est� vac�o Y no estamos editando
    if (widget.codigoController.text.isEmpty && !widget.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _generateNextCodigo();
      });
    }
  }

  @override
  void dispose() {
    widget.codigoController.removeListener(_validateCodigo);
    widget.nombreController.removeListener(_validateNombre);
    super.dispose();
  }

  void _validateCodigo() {
    final value = widget.codigoController.text;
    final isValid = value.trim().length >= 3;
    if (_codigoValid != isValid) {
      setState(() => _codigoValid = isValid);
    }
  }

  void _validateNombre() {
    final value = widget.nombreController.text;
    final isValid = value.trim().length >= 3;
    if (_nombreValid != isValid) {
      setState(() => _nombreValid = isValid);
    }
  }

  Future<void> _generateNextCodigo() async {
    final granjaAsync = ref.read(granjaByIdProvider(widget.granjaId));
    final galponesAsync = ref.read(galponesStreamProvider(widget.granjaId));

    await granjaAsync.when(
      data: (granja) async {
        if (granja == null) return;

        galponesAsync.whenData((galpones) {
          if (widget.codigoController.text.isEmpty) {
            final granjaCode = granja.nombre
                .toUpperCase()
                .replaceAll(RegExp(r'[^A-Z]'), '')
                .substring(
                  0,
                  granja.nombre.length >= 3 ? 3 : granja.nombre.length,
                )
                .padRight(3, 'X');

            final nextNumber = galpones.length + 1;
            final numeroSecuencial = nextNumber.toString().padLeft(3, '0');

            widget.codigoController.text = 'GAL-$granjaCode-$numeroSecuencial';
          }
        });
      },
      loading: () {},
      error: (_, __) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            S.of(context).shedBasicInfo,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).shedBasicInfoDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapXl,

          // Nombre del Galp�n
          GalponFormField(
            controller: widget.nombreController,
            label: '${S.of(context).shedShedNameLabel} *',
            hint: S.of(context).shedNameHint,
            suffixIcon: _nombreValid
                ? const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 20,
                  )
                : null,
            maxLength: 100,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            autovalidateMode: widget.autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return S.of(context).shedNameIsRequired;
              }
              if (value.trim().length < 3) {
                return S.of(context).shedMinChars;
              }
              if (value.trim().length > 100) {
                return S.of(context).shedNameTooLong;
              }
              return null;
            },
          ),
          AppSpacing.gapMd,

          // Tipo de Galp�n
          _buildTipoGalponDropdown(),
          AppSpacing.gapMd,

          // Estado del Galp�n
          _buildEstadoGalponDropdown(),
          AppSpacing.gapMd,

          // Descripci�n (opcional)
          GalponFormField(
            controller: widget.descripcionController,
            label: S.of(context).shedDescriptionOptional,
            hint: S.of(context).shedDescriptionHint,
            maxLines: 4,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
          ),
          AppSpacing.gapBase,

          // Card informativa
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildTipoGalponDropdown() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final labelColor = theme.colorScheme.onSurface.withValues(alpha: 0.8);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label encima del campo (estilo Wialon)
            Text(
              '${S.of(context).shedTypeLabel} *',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            AppSpacing.gapSm,
            DropdownButtonFormField<TipoGalpon>(
              initialValue: widget.tipoGalpon,
              autovalidateMode: widget.autoValidate
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              decoration: InputDecoration(
                hintText: S.of(context).shedSelectTypeHint,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontWeight: FontWeight.normal,
                ),
                errorMaxLines: 2,
                filled: true,
                fillColor: theme.colorScheme.surface,
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
                  borderSide: BorderSide(
                    color: theme.colorScheme.error,
                    width: 1,
                  ),
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
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurface,
              ),
              isExpanded: true,
              selectedItemBuilder: (BuildContext context) {
                return TipoGalpon.values.map((tipo) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      tipo.localizedDisplayName(S.of(context)),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList();
              },
              items: TipoGalpon.values.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tipo.localizedDisplayName(S.of(context)),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        tipo.localizedDescripcion(S.of(context)),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: widget.onTipoGalponChanged,
              validator: (value) {
                if (value == null) {
                  return S.of(context).shedSelectShedType;
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEstadoGalponDropdown() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final labelColor = theme.colorScheme.onSurface.withValues(alpha: 0.8);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label encima del campo (estilo Wialon)
            Text(
              S.of(context).commonState,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            AppSpacing.gapSm,
            DropdownButtonFormField<EstadoGalpon>(
              initialValue: widget.estadoGalpon,
              decoration: InputDecoration(
                hintText: S.of(context).shedSelectStateHint,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontWeight: FontWeight.normal,
                ),
                errorMaxLines: 2,
                filled: true,
                fillColor: theme.colorScheme.surface,
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
                  borderSide: BorderSide(
                    color: theme.colorScheme.error,
                    width: 1,
                  ),
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
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurface,
              ),
              isExpanded: true,
              selectedItemBuilder: (BuildContext context) {
                return EstadoGalpon.values.map((estado) {
                  return Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: estado.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      AppSpacing.hGapMd,
                      Text(
                        estado.displayName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  );
                }).toList();
              },
              items: EstadoGalpon.values.map((estado) {
                return DropdownMenuItem(
                  value: estado,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: estado.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      AppSpacing.hGapMd,
                      Expanded(
                        child: Text(
                          estado.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: widget.onEstadoGalponChanged,
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoCard() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          padding: const EdgeInsets.all(16),
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
                S.of(context).shedImportantInfo,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.gapXxs,
              Text(
                S.of(context).shedCodeAutoGenerated,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
