/// Secciones visuales para la pantalla de detalle de lote.
/// Diseño modular inspirado en mejores prácticas de UX/UI.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/formatters.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../domain/entities/lote.dart';
import '../../../domain/enums/tipo_ave.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'lote_detail_utils.dart';

// ==================== HEADER ====================

/// Header con nombre de lote y badge de estado.
class LoteHeader extends StatelessWidget {
  const LoteHeader({super.key, required this.lote});

  final Lote lote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final estadoColor = LoteEstadoInfo.getColor(lote.estado);
    final screenWidth = MediaQuery.sizeOf(context).width;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  lote.displayName,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: estadoColor,
                  borderRadius: AppRadius.allSm,
                ),
                child: Text(
                  lote.estado.localizedDisplayName(S.of(context)),
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
        ],
      ),
    );
  }
}

// ==================== TÍTULO DE SECCIÓN ====================

/// Widget helper para títulos de secciones.
class LoteSectionTitle extends StatelessWidget {
  const LoteSectionTitle({
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

// ==================== CHIP DE ALERTAS ====================

/// Chip para mostrar si el lote requiere atención.
class LoteAlertaChip extends StatelessWidget {
  const LoteAlertaChip({super.key, required this.lote});

  final Lote lote;

  @override
  Widget build(BuildContext context) {
    if (!lote.requiereAtencion) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: AppRadius.allSm,
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.2),
              borderRadius: AppRadius.allSm,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warning,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).batchRequiresAttention,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxs),
                Text(
                  S.of(context).batchNeedsReview,
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
}

// ==================== INFORMACIÓN GENERAL ====================

/// Card de información general del lote.
class LoteInformacionGeneral extends StatelessWidget {
  const LoteInformacionGeneral({super.key, required this.lote});

  final Lote lote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tipoColor = LoteTipoAveInfo.getColor(lote.tipoAve);

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
          // Tipo de ave
          _InfoRow(
            icon: LoteTipoAveInfo.getIcon(lote.tipoAve),
            label: S.of(context).batchBirdType,
            value: lote.tipoAve.localizedDisplayName(S.of(context)),
            color: tipoColor,
          ),

          const _InfoDivider(),

          // Raza (si existe)
          if (lote.raza != null && lote.raza!.isNotEmpty) ...[
            _InfoRow(
              icon: Icons.psychology_rounded,
              label: S.of(context).batchBreedLine,
              value: lote.raza!,
              color: AppColors.purple,
            ),
            const _InfoDivider(),
          ],

          // Cantidad inicial
          _InfoRow(
            icon: Icons.egg_outlined,
            label: S.of(context).batchInitialBirds,
            value: LoteDetailFormatters.formatCantidadAves(
              lote.cantidadInicial,
              context: context,
            ),
            color: AppColors.info,
          ),

          const _InfoDivider(),

          // Aves actuales
          _InfoRow(
            icon: Icons.pets_rounded,
            label: S.of(context).batchCurrentBirds,
            value: LoteDetailFormatters.formatCantidadAves(
              lote.avesActuales,
              context: context,
            ),
            color: lote.avesActuales > 0
                ? AppColors.success
                : theme.colorScheme.outline,
          ),

          const _InfoDivider(),

          // Fecha de ingreso
          _InfoRow(
            icon: Icons.calendar_today_rounded,
            label: S.of(context).batchEntryDate,
            value: LoteDetailFormatters.formatDate(lote.fechaIngreso),
            color: AppColors.indigo,
          ),

          // Edad al ingreso (si no eran pollitos de 1 día)
          if (lote.edadIngresoDias > 0) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.egg_alt_rounded,
              label: S.of(context).batchEntryLabel,
              value: S
                  .of(context)
                  .batchAgeDaysValue(lote.edadIngresoDias.toString()),
              color: AppColors.brown,
            ),
          ],

          // Edad actual
          const _InfoDivider(),
          _InfoRow(
            icon: Icons.schedule_rounded,
            label: S.of(context).batchAge,
            value: S
                .of(context)
                .batchAgeWeeksDaysValue(
                  lote.edadActualSemanas.toString(),
                  lote.edadActualDias.toString(),
                ),
            color: AppColors.warning,
          ),

          // Proveedor (si existe)
          if (lote.proveedor != null && lote.proveedor!.isNotEmpty) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.business_rounded,
              label: S.of(context).batchSupplier,
              value: lote.proveedor!,
              color: AppColors.teal,
            ),
          ],

          // Costo por ave (si existe)
          if (lote.costoAveInicial != null) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.attach_money_rounded,
              label: S.of(context).batchCostPerBird,
              value: Formatters.currencyValue(lote.costoAveInicial!),
              color: AppColors.success,
            ),
          ],

          // Fecha de cierre estimada
          if (lote.fechaCierreEstimada != null) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.event_rounded,
              label: S.of(context).batchExpected,
              value: LoteDetailFormatters.formatDate(lote.fechaCierreEstimada!),
              color: AppColors.deepPurple,
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== SECCIÓN DE NOTAS ====================

/// Sección de notas del lote.
class LoteNotasSection extends StatelessWidget {
  const LoteNotasSection({super.key, required this.lote});

  final Lote lote;

  @override
  Widget build(BuildContext context) {
    if (lote.observaciones == null || lote.observaciones!.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    // Separar las notas por líneas
    final lineas = lote.observaciones!
        .split('\n')
        .map((linea) => linea.trim())
        .where((linea) => linea.isNotEmpty)
        .toList();

    // Detectar si usa bullets
    final esBulletList = lineas.any(
      (linea) =>
          linea.startsWith('-') ||
          linea.startsWith('•') ||
          linea.startsWith('*') ||
          linea.startsWith('·'),
    );

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          esBulletList
              ? _LoteBulletList(lineas: lineas)
              : _LoteParagraphs(lineas: lineas),
        ],
      ),
    );
  }
}

/// Lista con bullets para notas.
class _LoteBulletList extends StatelessWidget {
  const _LoteBulletList({required this.lineas});

  final List<String> lineas;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lineas.map((linea) {
        // Remover el caracter de bullet inicial
        final texto = linea.replaceFirst(RegExp(r'^[-•*·]\s*'), '').trim();

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  texto,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Párrafos para notas sin bullets.
class _LoteParagraphs extends StatelessWidget {
  const _LoteParagraphs({required this.lineas});

  final List<String> lineas;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lineas.map((linea) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            linea,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ==================== SECCIÓN DE ESTADÍSTICAS ====================

/// Card de estadísticas del lote (mortalidad, supervivencia, peso, consumo).
class LoteEstadisticasSection extends StatelessWidget {
  const LoteEstadisticasSection({super.key, required this.lote});

  final Lote lote;

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
          // Supervivencia
          _InfoRow(
            icon: Icons.favorite_rounded,
            label: S.of(context).batchLiveBirds,
            value: '${lote.porcentajeSupervivencia.toStringAsFixed(1)}%',
            color: _getSobrevivenciaColor(lote.porcentajeSupervivencia),
          ),

          const _InfoDivider(),

          // Mortalidad
          _InfoRow(
            icon: Icons.trending_down_rounded,
            label: S.of(context).batchTotalLosses,
            value: S
                .of(context)
                .birdCountWithPercent(
                  '${lote.mortalidadAcumulada}',
                  lote.porcentajeMortalidad.toStringAsFixed(1),
                ),
            color: _getMortalidadColor(lote.porcentajeMortalidad),
          ),

          // Descartes (si hay)
          if (lote.descartesAcumulados > 0) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.remove_circle_outline_rounded,
              label: S.of(context).batchDiscards,
              value: S
                  .of(context)
                  .batchMortalityBirds('${lote.descartesAcumulados}'),
              color: AppColors.warning,
            ),
          ],

          // Ventas (si hay)
          if (lote.ventasAcumuladas > 0) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.shopping_cart_rounded,
              label: S.of(context).batchSold,
              value: S
                  .of(context)
                  .batchMortalityBirds('${lote.ventasAcumuladas}'),
              color: AppColors.info,
            ),
          ],

          // Peso promedio (si existe)
          if (lote.pesoPromedioActual != null) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.scale_rounded,
              label: S.of(context).batchCurrentWeight,
              value: '${lote.pesoPromedioActual!.toStringAsFixed(2)} kg',
              color: AppColors.info,
            ),
          ],

          // Consumo acumulado (si existe)
          if (lote.consumoAcumuladoKg != null &&
              lote.consumoAcumuladoKg! > 0) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.restaurant_rounded,
              label: S.of(context).batchFoodConsumption,
              value: '${lote.consumoAcumuladoKg!.toStringAsFixed(1)} kg',
              color: AppColors.success,
            ),
          ],

          // ICA (si se puede calcular)
          if (lote.indiceConversionAlimenticia != null) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.analytics_rounded,
              label: S.of(context).batchCurrentIndex,
              value: lote.indiceConversionAlimenticia!.toStringAsFixed(2),
              color: (lote.icaDentroLimites ?? true)
                  ? AppColors.success
                  : AppColors.warning,
            ),
          ],

          // Huevos producidos (solo postura)
          if (lote.tipoAve.esPonedora && lote.huevosProducidos != null) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.egg_rounded,
              label: S.of(context).batchEggProduction,
              value: S.of(context).eggCountUnits('${lote.huevosProducidos}'),
              color: AppColors.amber,
            ),
          ],

          // Días restantes (si tiene cierre estimado)
          if (lote.diasRestantes != null) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.timer_rounded,
              label: S.of(context).batchAge,
              value: lote.cierreVencido
                  ? S.of(context).batchOverdue
                  : S.of(context).batchDaysCount(lote.diasRestantes!),
              color: lote.cierreVencido
                  ? AppColors.error
                  : lote.cercaDelCierre
                  ? AppColors.warning
                  : AppColors.deepPurple,
            ),
          ],
        ],
      ),
    );
  }

  Color _getSobrevivenciaColor(double porcentaje) {
    if (porcentaje >= 95) return AppColors.success;
    if (porcentaje >= 90) return AppColors.info;
    if (porcentaje >= 85) return AppColors.warning;
    return AppColors.error;
  }

  Color _getMortalidadColor(double porcentaje) {
    if (porcentaje <= 3) return AppColors.success;
    if (porcentaje <= 5) return AppColors.warning;
    return AppColors.error;
  }
}

// ==================== SECCIÓN DE KPIS ====================

/// Card de KPIs principales del lote.
class LoteKPIsSection extends StatelessWidget {
  const LoteKPIsSection({super.key, required this.lote});

  final Lote lote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 600 ? 16.0 : 24.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 20,
      ),
      child: Column(
        children: [
          // Card de resumen con estadísticas
          _buildResumenCard(context),
          const SizedBox(height: AppSpacing.lg),

          // Barra de sobrevivencia
          _LoteProgressIndicator(
            label: S.of(context).batchLiveBirds,
            value: lote.avesActuales.toDouble(),
            maxValue: lote.cantidadInicial.toDouble(),
            unit: S.of(context).batchOfAmount(lote.cantidadInicial),
            color: _getSobrevivenciaColor(lote.porcentajeSupervivencia),
          ),

          const SizedBox(height: AppSpacing.base),

          // Barra de mortalidad
          _buildMortalidadBar(context),
        ],
      ),
    );
  }

  Widget _buildResumenCard(BuildContext context) {
    final sobrevivencia = lote.porcentajeSupervivencia;
    final mortalidad = lote.porcentajeMortalidad;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.info.withValues(alpha: 0.1),
            AppColors.info.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.allLg,
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            icon: Icons.favorite_rounded,
            value: '${sobrevivencia.toStringAsFixed(1)}%',
            label: S.of(context).batchLiveBirds,
            color: _getSobrevivenciaColor(sobrevivencia),
          ),
          _buildStatDivider(context),
          _buildStatItem(
            context,
            icon: Icons.trending_down_rounded,
            value: '${mortalidad.toStringAsFixed(1)}%',
            label: S.of(context).batchMortality,
            color: _getMortalidadColor(mortalidad),
          ),
          if (lote.pesoPromedioActual != null) ...[
            _buildStatDivider(context),
            _buildStatItem(
              context,
              icon: Icons.scale_rounded,
              value: '${lote.pesoPromedioActual!.toStringAsFixed(2)} kg',
              label: S.of(context).batchCurrentWeight,
              color: AppColors.info,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 50,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.3),
    );
  }

  Widget _buildMortalidadBar(BuildContext context) {
    final theme = Theme.of(context);
    final mortalidad = lote.porcentajeMortalidad;
    final color = _getMortalidadColor(mortalidad);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.allMd,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: color, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  S.of(context).batchTotalLosses,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                S.of(context).batchOfBirds(lote.mortalidadAcumulada),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            lote.mortalidadDentroLimites
                ? S.of(context).batchWithinLimits
                : S.of(context).batchHighMortalityAlert,
            style: theme.textTheme.labelMedium?.copyWith(
              color: lote.mortalidadDentroLimites
                  ? AppColors.success
                  : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSobrevivenciaColor(double porcentaje) {
    if (porcentaje >= 95) return AppColors.success;
    if (porcentaje >= 90) return AppColors.info;
    if (porcentaje >= 85) return AppColors.warning;
    return AppColors.error;
  }

  Color _getMortalidadColor(double porcentaje) {
    if (porcentaje <= 3) return AppColors.success;
    if (porcentaje <= 5) return AppColors.warning;
    return AppColors.error;
  }
}

/// Widget privado para indicador de progreso del lote.
class _LoteProgressIndicator extends StatelessWidget {
  const _LoteProgressIndicator({
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
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${LoteDetailFormatters.formatNumber(value.toInt())} $unit',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 10,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ==================== ACCIONES RÁPIDAS ====================

/// Grid de acciones rápidas del lote.
class LoteAccionesRapidasGrid extends StatelessWidget {
  const LoteAccionesRapidasGrid({
    super.key,
    required this.lote,
    required this.granjaId,
  });

  final Lote lote;
  final String granjaId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 600 ? 16.0 : 24.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 20,
      ),
      child: GridView.count(
        crossAxisCount: screenWidth < 600 ? 2 : 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: screenWidth < 360 ? 1.3 : 1.5,
        children: _buildAcciones(context),
      ),
    );
  }

  List<Widget> _buildAcciones(BuildContext context) {
    final acciones = <Widget>[];

    // Siempre mostrar historial
    acciones.add(
      _AccionCard(
        icon: Icons.history_rounded,
        label: S.of(context).batchTabHistory,
        color: AppColors.purple,
        onTap: () => context.push(
          '/granjas/$granjaId/lotes/${lote.id}/historial-produccion',
          extra: lote,
        ),
      ),
    );

    // Solo si está activo
    if (lote.estado.permiteRegistros) {
      acciones.addAll([
        _AccionCard(
          icon: Icons.scale_rounded,
          label: S.of(context).batchTabWeight,
          color: AppColors.info,
          onTap: () => context.push(
            '/granjas/$granjaId/lotes/${lote.id}/registrar-peso',
            extra: lote,
          ),
        ),
        _AccionCard(
          icon: Icons.restaurant_rounded,
          label: S.of(context).batchTabConsumption,
          color: AppColors.success,
          onTap: () => context.push(
            '/granjas/$granjaId/lotes/${lote.id}/registrar-consumo',
            extra: lote,
          ),
        ),
        _AccionCard(
          icon: Icons.warning_amber_rounded,
          label: S.of(context).batchTabMortality,
          color: AppColors.warning,
          onTap: () => context.push(
            '/granjas/$granjaId/lotes/${lote.id}/registrar-mortalidad',
            extra: lote,
          ),
        ),
        if (lote.tipoAve == TipoAve.gallinaPonedora)
          _AccionCard(
            icon: Icons.egg_rounded,
            label: S.of(context).batchTabProduction,
            color: AppColors.amber,
            onTap: () => context.push(
              '/granjas/$granjaId/lotes/${lote.id}/registrar-produccion',
              extra: lote,
            ),
          ),
        _AccionCard(
          icon: Icons.medication_rounded,
          label: S.of(context).batchTabVaccination,
          color: AppColors.error,
          onTap: () => context.push(
            AppRoutes.programarVacunacionConLote(lote.id, granjaId),
          ),
        ),
      ]);
    }

    return acciones;
  }
}

class _AccionCard extends StatelessWidget {
  const _AccionCard({
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.allMd,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.15),
                color.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: AppRadius.allMd,
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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
            borderRadius: BorderRadius.circular(10),
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
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
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
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        height: 1,
        thickness: 1,
        color: colorScheme.outlineVariant.withValues(alpha: 0.2),
      ),
    );
  }
}
