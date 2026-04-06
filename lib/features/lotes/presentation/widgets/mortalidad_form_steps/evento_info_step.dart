/// Step 1: Información del Evento de Mortalidad
/// Diseño consistente con crear_granja y crear_galpon
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/form_widgets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../salud/domain/enums/causa_mortalidad.dart';

/// Step 1: Información del Evento
class EventoInfoStep extends StatelessWidget {
  const EventoInfoStep({
    super.key,
    required this.cantidadController,
    required this.causaSeleccionada,
    required this.fechaEvento,
    required this.cantidadActual,
    required this.autoValidate,
    required this.onCausaChanged,
    required this.onFechaChanged,
    required this.fechaIngreso,
  });

  final TextEditingController cantidadController;
  final CausaMortalidad? causaSeleccionada;
  final DateTime fechaEvento;
  final int cantidadActual;
  final bool autoValidate;
  final void Function(CausaMortalidad?) onCausaChanged;
  final void Function(DateTime) onFechaChanged;
  final DateTime fechaIngreso;

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
            S.of(context).batchFormMortalityEventInfo,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).batchFormMortalityEventSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapXl,

          // Cantidad de aves muertas
          RegistroFormField(
            controller: cantidadController,
            label: S.of(context).batchFormDeathCount,
            hint: S.of(context).batchFormDeathCountHint,
            required: true,
            keyboardType: TextInputType.number,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).batchRequiredField;
              }
              final cantidad = int.tryParse(value);
              if (cantidad == null || cantidad <= 0) {
                return S.of(context).batchMustBeGreaterThanZero;
              }
              if (cantidad > cantidadActual) {
                return S.of(context).batchExceedsCurrentBirds(cantidadActual);
              }
              return null;
            },
          ),
          AppSpacing.gapBase,

          // Card informativa con datos del lote
          FormInfoCard(
            title: S.of(context).batchAttention,
            description: S.of(context).batchRemainingBirds(cantidadActual),
            type: InfoCardType.info,
          ),
          AppSpacing.gapBase,

          // Causa de la mortalidad
          RegistroDropdownField<CausaMortalidad>(
            label: S.of(context).batchFormCause,
            value: causaSeleccionada,
            hint: S.of(context).batchFormCauseHint,
            required: true,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            selectedItemBuilder: (context) {
              return CausaMortalidad.values.map((causa) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getCausaColor(causa),
                          shape: BoxShape.circle,
                        ),
                      ),
                      AppSpacing.hGapSm,
                      Text(causa.localizedName(S.of(context))),
                    ],
                  ),
                );
              }).toList();
            },
            items: CausaMortalidad.values.map((causa) {
              return DropdownMenuItem(
                value: causa,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getCausaColor(causa),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              causa.localizedName(S.of(context)),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              causa.localizedDescripcion(S.of(context)),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            onChanged: onCausaChanged,
          ),
          AppSpacing.gapBase,

          // Fecha del evento
          _buildFechaField(context, theme),
        ],
      ),
    );
  }

  Widget _buildFechaField(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).batchFormDate,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        AppSpacing.gapSm,
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: fechaEvento,
              firstDate: fechaIngreso,
              lastDate: DateTime.now(),
              locale: const Locale('es', 'ES'),
            );
            if (picked != null) {
              onFechaChanged(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: AppRadius.allSm,
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(fechaEvento),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
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

  Color _getCausaColor(CausaMortalidad causa) {
    switch (causa) {
      case CausaMortalidad.enfermedad:
        return AppColors.error;
      case CausaMortalidad.accidente:
        return AppColors.warning;
      case CausaMortalidad.estres:
        return AppColors.amber;
      case CausaMortalidad.desnutricion:
        return AppColors.brown;
      case CausaMortalidad.metabolica:
        return AppColors.purple;
      case CausaMortalidad.depredacion:
        return AppColors.deepOrange;
      case CausaMortalidad.sacrificio:
        return AppColors.outline;
      case CausaMortalidad.vejez:
        return AppColors.outline;
      case CausaMortalidad.desconocida:
        return AppColors.grey400;
    }
  }
}
