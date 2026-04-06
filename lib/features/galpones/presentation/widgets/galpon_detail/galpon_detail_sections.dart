/// Secciones visuales para la pantalla de detalle de galpón.
/// Diseño modular inspirado en mejores prácticas de UX/UI.
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../lotes/application/providers/lote_providers.dart';
import '../../../domain/entities/galpon.dart';
import 'galpon_detail_utils.dart';

// ==================== HEADER ====================

/// Header con nombre de galpón y badge de estado.
class GalponHeader extends StatelessWidget {
  const GalponHeader({super.key, required this.galpon});

  final Galpon galpon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final estadoColor = GalponEstadoInfo.getColor(galpon.estado);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allSm,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              galpon.nombre,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth < 360 ? 20 : 24,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: estadoColor,
              borderRadius: AppRadius.allSm,
            ),
            child: Text(
              GalponEstadoInfo.getLabel(galpon.estado),
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== TÍTULO DE SECCIÓN ====================

/// Widget helper para títulos de secciones.
class GalponSectionTitle extends StatelessWidget {
  const GalponSectionTitle({
    super.key,
    required this.title,
    this.centered = false,
    this.icon,
  });

  final String title;
  final bool centered;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Row(
      mainAxisAlignment: centered
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: screenWidth < 360 ? 20 : 22,
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth < 360 ? 18 : 20,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

// ==================== INFORMACIÓN GENERAL ====================

/// Card de información general del galpón.
class GalponInformacionGeneral extends ConsumerWidget {
  const GalponInformacionGeneral({super.key, required this.galpon});

  final Galpon galpon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tipoColor = GalponTipoInfo.getColor(galpon.tipo);

    // Obtener aves actuales del lote activo
    final loteActivoAsync = ref.watch(loteActivoGalponProvider(galpon.id));
    final avesActuales = loteActivoAsync.when(
      data: (lote) => lote?.avesActuales ?? 0,
      loading: () => galpon.avesActuales,
      error: (_, __) => galpon.avesActuales,
    );
    final ocupacion = galpon.capacidadMaxima > 0
        ? (avesActuales / galpon.capacidadMaxima) * 100
        : 0.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allSm,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Tipo de galpón
          _InfoRow(
            icon: GalponTipoInfo.getIcon(galpon.tipo),
            label: S.of(context).shedShedType,
            value: GalponTipoInfo.getLabel(galpon.tipo),
            color: tipoColor,
          ),

          const _InfoDivider(),

          // Capacidad
          _InfoRow(
            icon: Icons.groups_rounded,
            label: S.of(context).shedMaxCapacity,
            value: GalponDetailFormatters.formatCapacidad(
              galpon.capacidadMaxima,
              context: context,
            ),
            color: AppColors.success,
          ),

          const _InfoDivider(),

          // Aves actuales (del lote activo)
          _InfoRow(
            icon: Icons.pets_rounded,
            label: S.of(context).shedCurrentBirdsLabel,
            value: S
                .of(context)
                .shedCurrentBirdsValue(
                  GalponDetailFormatters.formatNumber(avesActuales),
                ),
            color: avesActuales > 0 ? AppColors.info : AppColors.inactive,
          ),

          const _InfoDivider(),

          // Ocupación (calculada del lote activo)
          _InfoRow(
            icon: Icons.pie_chart_rounded,
            label: S.of(context).shedOccupationLabel,
            value: GalponDetailFormatters.formatPorcentaje(ocupacion),
            color: _getOcupacionColor(ocupacion),
          ),

          // Área (si existe)
          if (galpon.areaM2 != null) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.square_foot_rounded,
              label: S.of(context).shedAreaLabel,
              value: GalponDetailFormatters.formatArea(
                galpon.areaM2,
                context: context,
              ),
              color: AppColors.warning,
            ),
          ],

          // Ubicación (si existe)
          if (galpon.ubicacion != null && galpon.ubicacion!.isNotEmpty) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.location_on_rounded,
              label: S.of(context).shedLocationLabel,
              value: galpon.ubicacion!,
              color: AppColors.purple,
            ),
          ],

          // Fecha de creación
          const _InfoDivider(),
          _InfoRow(
            icon: Icons.calendar_today_rounded,
            label: S.of(context).shedRegistrationDate,
            value: GalponDetailFormatters.formatDate(galpon.fechaCreacion),
            color: AppColors.inactive,
          ),
        ],
      ),
    );
  }

  Color _getOcupacionColor(double porcentaje) {
    if (porcentaje < 50) return AppColors.success;
    if (porcentaje < 80) return AppColors.warning;
    return AppColors.error;
  }
}

// ==================== SECCIÓN DE OCUPACIÓN ====================

/// Card de estadísticas de ocupación del galpón.
class GalponOcupacionSection extends StatelessWidget {
  const GalponOcupacionSection({super.key, required this.galpon});

  final Galpon galpon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allSm,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Card de resumen con estadísticas
          _buildResumenCard(context, theme),
          const SizedBox(height: AppSpacing.lg),

          // Barra de ocupación
          _GalponProgressIndicator(
            label: S.of(context).shedOccupationTitle,
            value: galpon.avesActuales.toDouble(),
            maxValue: galpon.capacidadMaxima.toDouble(),
            unit: S
                .of(context)
                .shedOfBirdsUnit(
                  GalponDetailFormatters.formatNumber(galpon.capacidadMaxima),
                ),
            color: _getOcupacionColor(galpon.porcentajeOcupacion),
          ),

          // Área por ave (si tiene área)
          if (galpon.areaM2 != null && galpon.avesActuales > 0) ...[
            const SizedBox(height: AppSpacing.base),
            _buildAreaPorAve(context, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildResumenCard(BuildContext context, ThemeData theme) {
    final ocupacion = galpon.porcentajeOcupacion;
    final disponibles = galpon.capacidadMaxima - galpon.avesActuales;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.allSm,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            theme: theme,
            icon: Icons.pets_rounded,
            value: GalponDetailFormatters.formatNumber(galpon.avesActuales),
            label: S.of(context).shedBirds,
            color: theme.colorScheme.primary,
          ),
          _buildStatDivider(theme),
          _buildStatItem(
            theme: theme,
            icon: Icons.pie_chart_rounded,
            value: '${ocupacion.toStringAsFixed(0)}%',
            label: S.of(context).shedOccupationLabel,
            color: _getOcupacionColor(ocupacion),
          ),
          _buildStatDivider(theme),
          _buildStatItem(
            theme: theme,
            icon: Icons.add_circle_outline_rounded,
            value: GalponDetailFormatters.formatNumber(disponibles),
            label: S.of(context).commonAvailable,
            color: disponibles > 0
                ? AppColors.success
                : theme.colorScheme.outline,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required ThemeData theme,
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider(ThemeData theme) {
    return Container(
      width: 1,
      height: 50,
      color: theme.colorScheme.outline.withValues(alpha: 0.3),
    );
  }

  Widget _buildAreaPorAve(BuildContext context, ThemeData theme) {
    final areaPorAve = galpon.areaM2! / galpon.avesActuales;
    final isOptimo = areaPorAve >= 0.08; // ~8 aves por m² es recomendado
    final statusColor = isOptimo ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: AppRadius.allSm,
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: AppRadius.allSm,
            ),
            child: Icon(
              Icons.square_foot_rounded,
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).shedDensityLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  S
                      .of(context)
                      .shedMSquarePerBird(areaPorAve.toStringAsFixed(3)),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: AppRadius.allSm,
            ),
            child: Text(
              isOptimo ? S.of(context).shedOptimal : S.of(context).shedAdjust,
              style: theme.textTheme.labelSmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getOcupacionColor(double porcentaje) {
    if (porcentaje < 50) return AppColors.info; // Info blue
    if (porcentaje < 80) return AppColors.success; // Success green
    if (porcentaje < 95) return AppColors.warning; // Warning amber
    return AppColors.error; // Error red
  }
}

/// Widget privado para indicador de progreso del galpón.
class _GalponProgressIndicator extends StatelessWidget {
  const _GalponProgressIndicator({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.unit,
    required this.color,
  });

  final String label;
  final double value;
  final double maxValue;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = maxValue > 0
        ? (value / maxValue * 100).clamp(0, 100)
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: theme.textTheme.titleSmall)),
            Text(
              '${GalponDetailFormatters.formatNumber(value.toInt())} $unit',
              style: theme.textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: AppRadius.allMd,
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 10,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          S.of(context).shedOfCapacity(percentage.toStringAsFixed(1)),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ==================== SECCIÓN DE INFRAESTRUCTURA ====================

/// Card de infraestructura del galpón.
class GalponInfraestructuraSection extends StatelessWidget {
  const GalponInfraestructuraSection({super.key, required this.galpon});

  final Galpon galpon;

  @override
  Widget build(BuildContext context) {
    final tieneInfraestructura =
        galpon.numeroCorrales != null ||
        galpon.sistemaBebederos != null ||
        galpon.sistemaComederos != null ||
        galpon.sistemaVentilacion != null ||
        galpon.sistemaCalefaccion != null ||
        galpon.sistemaIluminacion != null;

    if (!tieneInfraestructura) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allSm,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (galpon.numeroCorrales != null)
            _InfoRow(
              icon: Icons.grid_view_rounded,
              label: S.of(context).shedCorralsDivisions,
              value: S.of(context).shedDivisionsCount(galpon.numeroCorrales!),
              color: AppColors.indigo,
            ),

          if (galpon.sistemaBebederos != null) ...[
            if (galpon.numeroCorrales != null) const _InfoDivider(),
            _InfoRow(
              icon: Icons.water_drop_rounded,
              label: S.of(context).shedWateringSystem,
              value: galpon.sistemaBebederos!,
              color: AppColors.cyan,
            ),
          ],

          if (galpon.sistemaComederos != null) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.restaurant_rounded,
              label: S.of(context).shedFeederSystem,
              value: galpon.sistemaComederos!,
              color: AppColors.brown,
            ),
          ],

          if (galpon.sistemaVentilacion != null) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.air_rounded,
              label: S.of(context).shedVentilationSystem,
              value: galpon.sistemaVentilacion!,
              color: AppColors.teal,
            ),
          ],

          if (galpon.sistemaCalefaccion != null) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.local_fire_department_rounded,
              label: S.of(context).shedHeatingSystem,
              value: galpon.sistemaCalefaccion!,
              color: AppColors.deepOrange,
            ),
          ],

          if (galpon.sistemaIluminacion != null) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.lightbulb_rounded,
              label: S.of(context).shedLightingSystem,
              value: galpon.sistemaIluminacion!,
              color: AppColors.amber,
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== SECCIÓN DE SENSORES ====================

/// Card de sensores y equipamiento del galpón.
class GalponSensoresSection extends StatelessWidget {
  const GalponSensoresSection({super.key, required this.galpon});

  final Galpon galpon;

  @override
  Widget build(BuildContext context) {
    final sensores = _getSensoresDisponibles(context);

    if (sensores.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allSm,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: sensores.map((sensor) {
          return GalponDetailCommonWidgets.sensorChip(
            context: context,
            icon: sensor['icon'] as IconData,
            label: sensor['nombre'] as String,
            activo: sensor['activo'] as bool,
          );
        }).toList(),
      ),
    );
  }

  List<Map<String, dynamic>> _getSensoresDisponibles(BuildContext context) {
    final sensores = <Map<String, dynamic>>[];

    if (galpon.tieneBalanza) {
      sensores.add({
        'nombre': S.of(context).shedScale,
        'icon': Icons.scale_rounded,
        'activo': true,
      });
    }
    if (galpon.sensorTemperatura) {
      sensores.add({
        'nombre': S.of(context).shedTemperatureSensor,
        'icon': Icons.thermostat_rounded,
        'activo': true,
      });
    }
    if (galpon.sensorHumedad) {
      sensores.add({
        'nombre': S.of(context).shedHumiditySensor,
        'icon': Icons.water_rounded,
        'activo': true,
      });
    }
    if (galpon.sensorCO2) {
      sensores.add({
        'nombre': S.of(context).shedCO2Sensor,
        'icon': Icons.cloud_rounded,
        'activo': true,
      });
    }
    if (galpon.sensorAmoniaco) {
      sensores.add({
        'nombre': S.of(context).shedAmmoniaSensor,
        'icon': Icons.science_rounded,
        'activo': true,
      });
    }

    return sensores;
  }
}

// ==================== SECCIÓN DE DESCRIPCIÓN ====================

/// Sección de descripción/notas del galpón.
class GalponDescripcionSection extends StatelessWidget {
  const GalponDescripcionSection({super.key, required this.galpon});

  final Galpon galpon;

  @override
  Widget build(BuildContext context) {
    if (galpon.descripcion == null || galpon.descripcion!.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allSm,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Text(
        galpon.descripcion!,
        style: theme.textTheme.bodyMedium?.copyWith(
          height: 1.5,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

// ==================== SECCIÓN DE ACCIONES RÁPIDAS ====================

/// Sección de acciones rápidas del galpón.
class GalponAccionesRapidasSection extends StatelessWidget {
  const GalponAccionesRapidasSection({
    super.key,
    required this.galpon,
    required this.onCambiarEstado,
    required this.onAsignarLote,
    required this.onLiberar,
    required this.onDesinfeccion,
    required this.onMantenimiento,
  });

  final Galpon galpon;
  final VoidCallback onCambiarEstado;
  final VoidCallback onAsignarLote;
  final VoidCallback onLiberar;
  final VoidCallback onDesinfeccion;
  final VoidCallback onMantenimiento;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allSm,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _ActionChip(
            icon: Icons.swap_horiz_rounded,
            label: S.of(context).shedChangeStateAction,
            color: AppColors.primary,
            onTap: onCambiarEstado,
          ),
          if (galpon.estaDisponible)
            _ActionChip(
              icon: Icons.add_circle_outline_rounded,
              label: S.of(context).shedAssignBatch,
              color: AppColors.success,
              onTap: onAsignarLote,
            ),
          if (galpon.loteActualId != null)
            _ActionChip(
              icon: Icons.remove_circle_outline_rounded,
              label: S.of(context).shedReleaseLabel,
              color: AppColors.warning,
              onTap: onLiberar,
            ),
          _ActionChip(
            icon: Icons.cleaning_services_rounded,
            label: S.of(context).shedDisinfection,
            color: AppColors.info,
            onTap: onDesinfeccion,
          ),
          _ActionChip(
            icon: Icons.build_rounded,
            label: S.of(context).commonMaintenance,
            color: AppColors.grey600,
            onTap: onMantenimiento,
          ),
        ],
      ),
    );
  }
}

// ==================== SECCIÓN VACÍA ====================

/// Widget para mostrar cuando no hay galpones o está vacío.
class GalponEmptySection extends StatelessWidget {
  const GalponEmptySection({
    super.key,
    required this.icon,
    required this.message,
    this.buttonLabel,
    this.onPressed,
  });

  final IconData icon;
  final String message;
  final String? buttonLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allSm,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (buttonLabel != null && onPressed != null) ...[
            const SizedBox(height: AppSpacing.base),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.add),
                label: Text(buttonLabel!),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== WIDGETS PRIVADOS ====================

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: AppRadius.allSm,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: content,
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 54, top: 14, bottom: 14),
      child: Divider(
        height: 1,
        thickness: 1,
        color: theme.colorScheme.outline.withValues(alpha: 0.2),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.allSm,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: AppRadius.allSm,
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== LOADING Y ERROR ====================

/// Widget de cargando para secciones de galpón.
class GalponSectionLoading extends StatelessWidget {
  const GalponSectionLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allSm,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
    );
  }
}

/// Widget de error para secciones de galpón.
class GalponSectionError extends StatelessWidget {
  const GalponSectionError({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allSm,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          S.of(context).commonErrorWithMessage(error),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      ),
    );
  }
}

// ==================== INFO CHIP DE DESINFECCIÓN ====================

/// Chip informativo que muestra días desde la última desinfección.
class GalponDesinfeccionChip extends StatelessWidget {
  const GalponDesinfeccionChip({super.key, required this.galpon});

  final Galpon galpon;

  @override
  Widget build(BuildContext context) {
    if (galpon.ultimaDesinfeccion == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final diasDesdeDesinfeccion = galpon.diasDesdeUltimaDesinfeccion ?? 0;

    // Color según los días (verde < 15, amarillo 15-30, rojo > 30)
    final Color chipColor;
    if (diasDesdeDesinfeccion < 15) {
      chipColor = AppColors.success;
    } else if (diasDesdeDesinfeccion < 30) {
      chipColor = AppColors.warning;
    } else {
      chipColor = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: AppRadius.allSm,
        border: Border.all(color: chipColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cleaning_services_rounded, size: 16, color: chipColor),
          const SizedBox(width: AppSpacing.xs),
          Text(
            S.of(context).shedDisinfectedDaysAgo(diasDesdeDesinfeccion),
            style: theme.textTheme.labelMedium?.copyWith(
              color: chipColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== CHIP DE MANTENIMIENTO PROGRAMADO ====================

/// Chip informativo que muestra próximo mantenimiento.
class GalponMantenimientoChip extends StatelessWidget {
  const GalponMantenimientoChip({super.key, required this.galpon});

  final Galpon galpon;

  @override
  Widget build(BuildContext context) {
    if (galpon.proximoMantenimiento == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final diasHastaMantenimiento = galpon.diasHastaProximoMantenimiento ?? 0;

    // Color según los días
    final Color chipColor;
    final String texto;
    if (diasHastaMantenimiento < 0) {
      chipColor = AppColors.error;
      texto = S.of(context).shedMaintenanceOverdue(-diasHastaMantenimiento);
    } else if (diasHastaMantenimiento == 0) {
      chipColor = AppColors.warning;
      texto = S.of(context).shedMaintenanceToday;
    } else if (diasHastaMantenimiento <= 7) {
      chipColor = AppColors.warning;
      texto = S.of(context).shedMaintenanceInDays(diasHastaMantenimiento);
    } else {
      chipColor = AppColors.info;
      texto = S.of(context).shedMaintenanceInDays(diasHastaMantenimiento);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: AppRadius.allSm,
        border: Border.all(color: chipColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.build_circle_outlined, size: 16, color: chipColor),
          const SizedBox(width: AppSpacing.xs),
          Text(
            texto,
            style: theme.textTheme.labelMedium?.copyWith(
              color: chipColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== ACCIONES RÁPIDAS EN GRID ====================

/// Sección de acciones rápidas en formato Grid (como casa_detail).
class GalponAccionesRapidasGrid extends StatelessWidget {
  const GalponAccionesRapidasGrid({
    super.key,
    required this.galpon,
    required this.onVerLotes,
    required this.onDesinfeccion,
    required this.onMantenimiento,
    required this.onHistorial,
  });

  final Galpon galpon;
  final VoidCallback onVerLotes;
  final VoidCallback onDesinfeccion;
  final VoidCallback onMantenimiento;
  final VoidCallback onHistorial;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 600 ? 16.0 : 24.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.3,
        padding: EdgeInsets.zero,
        children: [
          _QuickActionCard(
            icon: Icons.egg_outlined,
            label: S.of(context).shedViewBatches,
            color: AppColors.primary,
            onTap: onVerLotes,
          ),
          _QuickActionCard(
            icon: Icons.cleaning_services_rounded,
            label: S.of(context).shedRegisterDisinfection,
            color: AppColors.cyan,
            onTap: onDesinfeccion,
          ),
          _QuickActionCard(
            icon: Icons.build_circle_outlined,
            label: S.of(context).shedScheduleMaintenanceGrid,
            color: AppColors.warning,
            onTap: onMantenimiento,
          ),
          _QuickActionCard(
            icon: Icons.history_rounded,
            label: S.of(context).shedViewHistory,
            color: AppColors.info,
            onTap: onHistorial,
          ),
        ],
      ),
    );
  }
}

/// Widget de card de acción rápida para el Grid.
class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: AppRadius.allSm,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.allSm,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.allSm,
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: AppRadius.allSm,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== SECCIÓN DE LOTE ACTUAL ====================

/// Sección que muestra información del lote actual del galpón.
class GalponLoteActualSection extends StatelessWidget {
  const GalponLoteActualSection({
    super.key,
    required this.galpon,
    required this.onVerLote,
    required this.onAsignarLote,
  });

  final Galpon galpon;
  final VoidCallback onVerLote;
  final VoidCallback onAsignarLote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allSm,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: galpon.loteActualId != null
          ? _buildLoteActivo(context, theme)
          : _buildSinLote(context, theme),
    );
  }

  Widget _buildLoteActivo(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        // Card del lote actual
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: AppRadius.allSm,
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: AppRadius.allSm,
                    ),
                    child: Icon(
                      Icons.egg_rounded,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).shedActiveBatch,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          galpon.loteActualId ?? 'N/A',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onVerLote,
                    icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                      foregroundColor: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.base),
              // Estadísticas rápidas del lote
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLoteStat(
                    theme: theme,
                    icon: Icons.pets_rounded,
                    value: GalponDetailFormatters.formatNumber(
                      galpon.avesActuales,
                    ),
                    label: S.of(context).shedBirds,
                  ),
                  _buildLoteStat(
                    theme: theme,
                    icon: Icons.pie_chart_rounded,
                    value: '${galpon.porcentajeOcupacion.toStringAsFixed(0)}%',
                    label: S.of(context).shedOccupationLabel,
                  ),
                  if (galpon.areaM2 != null && galpon.avesActuales > 0)
                    _buildLoteStat(
                      theme: theme,
                      icon: Icons.square_foot_rounded,
                      value: (galpon.avesActuales / galpon.areaM2!)
                          .toStringAsFixed(1),
                      label: S.of(context).galponBirdDensity,
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        // Botón para ver lote
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: onVerLote,
            icon: const Icon(Icons.visibility_rounded),
            label: Text(S.of(context).shedViewBatchDetail),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.primary),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoteStat({
    required ThemeData theme,
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary.withValues(alpha: 0.7),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSinLote(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        Icon(
          Icons.egg_outlined,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          S.of(context).shedNoAssignedBatch,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          S.of(context).shedAvailableForNewBatch,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.base),
        if (galpon.estaDisponible)
          SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: onAsignarLote,
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: Text(S.of(context).shedAssignBatchLabel),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: AppRadius.allSm,
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: AppColors.warning,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  S
                      .of(context)
                      .shedNotAvailableForBatch(
                        galpon.estado.localizedDisplayName(S.of(context)),
                      ),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
