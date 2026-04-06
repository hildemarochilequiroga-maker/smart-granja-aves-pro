/// Step 1: Información del Pesaje
/// Diseño consistente con crear_granja y crear_galpon
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/form_widgets.dart';
import '../../../domain/enums/metodo_pesaje.dart';
import 'package:smartgranjaavespro/core/theme/app_radius.dart';

/// Step 1: Información del Pesaje
class InformacionPesajeStep extends StatelessWidget {
  const InformacionPesajeStep({
    super.key,
    required this.formKey,
    required this.pesoPromedioController,
    required this.cantidadAvesController,
    required this.fechaSeleccionada,
    required this.metodoSeleccionado,
    required this.onSeleccionarFecha,
    required this.onMetodoChanged,
    required this.onPesoChanged,
    required this.autoValidate,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController pesoPromedioController;
  final TextEditingController cantidadAvesController;
  final DateTime fechaSeleccionada;
  final MetodoPesaje metodoSeleccionado;
  final VoidCallback onSeleccionarFecha;
  final ValueChanged<MetodoPesaje?> onMetodoChanged;
  final VoidCallback onPesoChanged;
  final bool autoValidate;

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
            S.of(context).batchFormWeightInfo,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).batchFormWeightSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Peso promedio
          RegistroFormField(
            controller: pesoPromedioController,
            label: S.of(context).batchFormWeight,
            hint: S.of(context).batchFormWeightHint,
            suffixText: 'g',
            required: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => onPesoChanged(),
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).batchRequiredField;
              }
              final peso = double.tryParse(value);
              if (peso == null || peso <= 0) {
                return S.of(context).batchMustBeGreaterThanZero;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Cantidad de aves pesadas
          RegistroFormField(
            controller: cantidadAvesController,
            label: S.of(context).batchFormSampleSize,
            hint: S.of(context).batchFormSampleSizeHint,
            suffixText: S.of(context).commonBirdsUnit,
            required: true,
            keyboardType: TextInputType.number,
            onChanged: (_) => onPesoChanged(),
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
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Método de pesaje
          RegistroDropdownField<MetodoPesaje>(
            label: S.of(context).batchFormWeightMethod,
            value: metodoSeleccionado,
            hint: S.of(context).batchFormMethodHint,
            required: true,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            selectedItemBuilder: (context) {
              return MetodoPesaje.values.map((metodo) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: metodo.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(metodo.localizedDescripcion(S.of(context))),
                    ],
                  ),
                );
              }).toList();
            },
            items: MetodoPesaje.values.map((metodo) {
              return DropdownMenuItem(
                value: metodo,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: metodo.color,
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
                              metodo.localizedDescripcion(S.of(context)),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              metodo.localizedDescripcionDetallada(S.of(context)),
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
            onChanged: onMetodoChanged,
          ),
          const SizedBox(height: 16),

          // Fecha del pesaje
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
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onSeleccionarFecha,
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
                  DateFormat('dd/MM/yyyy').format(fechaSeleccionada),
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
}
