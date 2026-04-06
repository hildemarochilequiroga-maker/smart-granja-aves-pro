library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/domain.dart';

/// Widget que muestra los umbrales ambientales de una granja
class GranjaUmbralesCard extends StatelessWidget {
  final UmbralesAmbientales umbrales;

  const GranjaUmbralesCard({super.key, required this.umbrales});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.thermostat, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  l.farmEnvironmentalThresholds,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),

            // Temperatura
            _UmbralRow(
              icono: Icons.thermostat,
              color: AppColors.error,
              etiqueta: l.farmTemperature,
              rangoMin: umbrales.temperaturaMinima,
              rangoMax: umbrales.temperaturaMaxima,
              unidad: '°C',
            ),
            const SizedBox(height: AppSpacing.md),

            // Humedad
            _UmbralRow(
              icono: Icons.water_drop,
              color: AppColors.info,
              etiqueta: l.farmHumidity,
              rangoMin: umbrales.humedadMinima,
              rangoMax: umbrales.humedadMaxima,
              unidad: '%',
            ),
            const SizedBox(height: AppSpacing.md),

            // CO2
            _UmbralRow(
              icono: Icons.cloud,
              color: AppColors.grey600,
              etiqueta: l.farmCo2Max,
              rangoMax: umbrales.co2Maximo,
              unidad: 'ppm',
            ),
            const SizedBox(height: AppSpacing.md),

            // Amoníaco
            _UmbralRow(
              icono: Icons.warning_amber,
              color: AppColors.warning,
              etiqueta: l.farmAmmoniaMax,
              rangoMax: umbrales.amonicoMaximo,
              unidad: 'ppm',
            ),
          ],
        ),
      ),
    );
  }
}

class _UmbralRow extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String etiqueta;
  final double? rangoMin;
  final double? rangoMax;
  final String unidad;

  const _UmbralRow({
    required this.icono,
    required this.color,
    required this.etiqueta,
    this.rangoMin,
    this.rangoMax,
    required this.unidad,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String valorTexto;
    if (rangoMin != null && rangoMax != null) {
      valorTexto =
          '${rangoMin!.toStringAsFixed(1)} - ${rangoMax!.toStringAsFixed(1)} $unidad';
    } else if (rangoMax != null) {
      valorTexto = '< ${rangoMax!.toStringAsFixed(1)} $unidad';
    } else if (rangoMin != null) {
      valorTexto = '> ${rangoMin!.toStringAsFixed(1)} $unidad';
    } else {
      valorTexto = S.of(context).commonNotDefined;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: AppRadius.allSm,
          ),
          child: Icon(icono, color: color, size: 20),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(etiqueta, style: theme.textTheme.bodyMedium)),
        Text(
          valorTexto,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
