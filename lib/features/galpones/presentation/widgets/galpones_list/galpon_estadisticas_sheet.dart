/// Bottom sheet con estadísticas de los galpones de una granja.
///
/// Muestra:
/// - Total de galpones
/// - Galpones por estado
/// - Capacidad total
/// - Aves totales
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/galpon.dart';

/// Bottom sheet con estadísticas de galpones
class GalponEstadisticasSheet extends StatelessWidget {
  const GalponEstadisticasSheet({
    super.key,
    required this.galpones,
    this.granjaId,
  });

  final List<Galpon> galpones;
  final String? granjaId;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        final theme = Theme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppRadius.topXl,
          ),
          child: Column(
            children: [
              _buildHandle(),
              _buildHeader(context),
              const Divider(height: 1),
              Expanded(child: _buildContent(context, scrollController)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.grey300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: AppRadius.allMd,
            ),
            child: const Icon(
              Icons.analytics_outlined,
              color: AppColors.primary,
            ),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).shedStatsTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  S.of(context).shedShedsRegistered(galpones.length),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ScrollController controller) {
    final theme = Theme.of(context);
    final stats = _calcularEstadisticas();

    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(16),
      children: [
        // Resumen general
        _buildResumenGeneral(context, stats),
        AppSpacing.gapBase,

        // Estado de galpones
        Text(
          S.of(context).shedByStatus,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.gapMd,
        _buildEstadisticasGrid(context, stats),
        AppSpacing.gapBase,

        // Nota informativa
        _buildNotaInformativa(context),
      ],
    );
  }

  Widget _buildResumenGeneral(BuildContext context, _GalponStats stats) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.allLg,
      ),
      child: Row(
        children: [
          Expanded(
            child: _ResumenItem(
              label: S.of(context).galponStatCapacity,
              value: '${stats.capacidadTotal}',
              icon: Icons.groups_outlined,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: colorScheme.onPrimary.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _ResumenItem(
              label: S.of(context).galponStatTotalBirds,
              value: '${stats.avesTotales}',
              icon: Icons.pets_outlined,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: colorScheme.onPrimary.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _ResumenItem(
              label: S.of(context).shedOccupancy,
              value: '${stats.ocupacionPromedio.toStringAsFixed(0)}%',
              icon: Icons.pie_chart_outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadisticasGrid(BuildContext context, _GalponStats stats) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _EstadisticaCard(
          icon: Icons.check_circle_outline,
          title: S.of(context).shedActive,
          value: '${stats.activos}',
          color: AppColors.success,
        ),
        _EstadisticaCard(
          icon: Icons.pause_circle_outline,
          title: S.of(context).shedInactive,
          value: '${stats.inactivos}',
          color: AppColors.grey600,
        ),
        _EstadisticaCard(
          icon: Icons.build_outlined,
          title: S.of(context).commonMaintenance,
          value: '${stats.enMantenimiento}',
          color: AppColors.warning,
        ),
        _EstadisticaCard(
          icon: Icons.medical_services_outlined,
          title: S.of(context).shedQuarantine,
          value: '${stats.enCuarentena}',
          color: AppColors.error,
        ),
        _EstadisticaCard(
          icon: Icons.cleaning_services_outlined,
          title: S.of(context).shedDisinfection,
          value: '${stats.enDesinfeccion}',
          color: AppColors.info,
        ),
      ],
    );
  }

  Widget _buildNotaInformativa(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: AppRadius.allMd,
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.info, size: 20),
          AppSpacing.hGapMd,
          Expanded(
            child: Text(
              S.of(context).shedStatsRealtime,
              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.info),
            ),
          ),
        ],
      ),
    );
  }

  _GalponStats _calcularEstadisticas() {
    int activos = 0;
    int inactivos = 0;
    int enMantenimiento = 0;
    int enCuarentena = 0;
    int enDesinfeccion = 0;
    int capacidadTotal = 0;
    int avesTotales = 0;

    for (final galpon in galpones) {
      capacidadTotal += galpon.capacidadMaxima;
      avesTotales += galpon.avesActuales;

      switch (galpon.estado.name) {
        case 'activo':
          activos++;
          break;
        case 'inactivo':
          inactivos++;
          break;
        case 'mantenimiento':
          enMantenimiento++;
          break;
        case 'cuarentena':
          enCuarentena++;
          break;
        case 'desinfeccion':
          enDesinfeccion++;
          break;
      }
    }

    final ocupacionPromedio = capacidadTotal > 0
        ? (avesTotales / capacidadTotal) * 100
        : 0.0;

    return _GalponStats(
      activos: activos,
      inactivos: inactivos,
      enMantenimiento: enMantenimiento,
      enCuarentena: enCuarentena,
      enDesinfeccion: enDesinfeccion,
      capacidadTotal: capacidadTotal,
      avesTotales: avesTotales,
      ocupacionPromedio: ocupacionPromedio,
    );
  }
}

class _GalponStats {
  final int activos;
  final int inactivos;
  final int enMantenimiento;
  final int enCuarentena;
  final int enDesinfeccion;
  final int capacidadTotal;
  final int avesTotales;
  final double ocupacionPromedio;

  const _GalponStats({
    required this.activos,
    required this.inactivos,
    required this.enMantenimiento,
    required this.enCuarentena,
    required this.enDesinfeccion,
    required this.capacidadTotal,
    required this.avesTotales,
    required this.ocupacionPromedio,
  });
}

class _ResumenItem extends StatelessWidget {
  const _ResumenItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.onPrimary, size: 24),
        AppSpacing.gapSm,
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _EstadisticaCard extends StatelessWidget {
  const _EstadisticaCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: (MediaQuery.sizeOf(context).width - 56) / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.allMd,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: AppRadius.allSm,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
