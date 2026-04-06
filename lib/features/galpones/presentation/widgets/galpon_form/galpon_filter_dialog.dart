library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../domain/enums/estado_galpon.dart';
import '../../../domain/enums/tipo_galpon.dart';

/// Dialog para filtrar galpones por estado, tipo y capacidad
class GalponFilterDialog extends StatefulWidget {
  const GalponFilterDialog({
    super.key,
    this.initialEstado,
    this.initialTipo,
    this.initialCapacidad,
  });

  final EstadoGalpon? initialEstado;
  final TipoGalpon? initialTipo;
  final int? initialCapacidad;

  @override
  State<GalponFilterDialog> createState() => _GalponFilterDialogState();
}

class _GalponFilterDialogState extends State<GalponFilterDialog> {
  EstadoGalpon? estado;
  TipoGalpon? tipo;
  int? capacidad;

  @override
  void initState() {
    super.initState();
    estado = widget.initialEstado;
    tipo = widget.initialTipo;
    capacidad = widget.initialCapacidad;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      title: Text(
        S.of(context).shedFilterSheds,
        style: AppTextStyles.titleLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEstadoDropdown(),
            const SizedBox(height: AppSpacing.base),
            _buildTipoDropdown(),
            const SizedBox(height: AppSpacing.base),
            _buildCapacidadInput(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.onSurfaceVariant,
          ),
          child: Text(S.of(context).commonCancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(
              context,
            ).pop({'estado': estado, 'tipo': tipo, 'capacidad': capacidad});
          },
          style: FilledButton.styleFrom(
            foregroundColor: AppColors.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
          ),
          child: Text(S.of(context).commonApply),
        ),
      ],
    );
  }

  Widget _buildEstadoDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).commonState,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.onSurface.withValues(alpha: 0.05),
            borderRadius: AppRadius.allSm,
          ),
          child: DropdownButtonFormField<EstadoGalpon>(
            initialValue: estado,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: AppRadius.allSm,
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            hint: Text(
              S.of(context).shedSelectStatus,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
            items: EstadoGalpon.values.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: e.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(e.localizedDisplayName(S.of(context))),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() => estado = value),
          ),
        ),
      ],
    );
  }

  Widget _buildTipoDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).shedDensityTypeCol,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.onSurface.withValues(alpha: 0.05),
            borderRadius: AppRadius.allSm,
          ),
          child: DropdownButtonFormField<TipoGalpon>(
            initialValue: tipo,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: AppRadius.allSm,
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            hint: Text(
              S.of(context).shedSelectTypeFilter,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
            items: TipoGalpon.values.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e.localizedDisplayName(S.of(context))),
              );
            }).toList(),
            onChanged: (value) => setState(() => tipo = value),
          ),
        ),
      ],
    );
  }

  Widget _buildCapacidadInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).shedMinCapacity,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          decoration: InputDecoration(
            hintText: S.of(context).shedCapacityHintExample,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: AppColors.onSurface.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: capacidad?.toString() ?? ''),
          onChanged: (value) => setState(() => capacidad = int.tryParse(value)),
        ),
      ],
    );
  }
}
