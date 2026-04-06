/// Secciones visuales para la pantalla de detalle de granja.
/// Diseño modular inspirado en mejores prácticas de UX/UI.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../galpones/application/providers/galpon_providers.dart';
import '../../../../galpones/domain/entities/galpon.dart';
import '../../../domain/entities/granja.dart';
import 'granja_detail_utils.dart';

// ==================== HEADER ====================

/// Header con nombre de granja y badge de estado.
class GranjaHeader extends StatelessWidget {
  const GranjaHeader({super.key, required this.granja});

  final Granja granja;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final estadoColor = GranjaEstadoInfo.getColor(granja.estado);

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
              granja.nombre,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth < 360 ? 20 : 24,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppSpacing.hGapMd,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: estadoColor,
              borderRadius: AppRadius.allSm,
            ),
            child: Text(
              GranjaEstadoInfo.getLabel(granja.estado, context: context),
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
class GranjaSectionTitle extends StatelessWidget {
  const GranjaSectionTitle({
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
          AppSpacing.hGapSm,
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

/// Card de información general.
class GranjaInformacionGeneral extends StatelessWidget {
  const GranjaInformacionGeneral({super.key, required this.granja});

  final Granja granja;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

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
          // Ubicación
          _InfoRow(
            icon: Icons.location_on_rounded,
            label: l.commonLocation,
            value: GranjaDetailFormatters.formatDireccion(granja.direccion),
            color: AppColors.error,
          ),

          const _InfoDivider(),

          // Propietario
          _InfoRow(
            icon: Icons.person_rounded,
            label: l.farmOwner,
            value: granja.propietarioNombre,
            color: AppColors.info,
          ),

          // Capacidad
          if (granja.capacidadTotalAves != null) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.groups_rounded,
              label: l.farmCapacity,
              value:
                  '${Formatters.numeroMiles.format(granja.capacidadTotalAves!)} ${l.farmBirds}',
              color: AppColors.success,
            ),
          ],

          // Área
          if (granja.areaTotalM2 != null) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.straighten_rounded,
              label: l.farmArea,
              value:
                  '${Formatters.numeroMiles.format(granja.areaTotalM2!.toInt())} m²',
              color: AppColors.warning,
            ),
          ],

          // Teléfono
          if (granja.telefono != null && granja.telefono!.isNotEmpty) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.phone_rounded,
              label: l.commonPhone,
              value: granja.telefono!,
              color: theme.colorScheme.primary,
            ),
          ],

          // Correo
          if (granja.correo != null && granja.correo!.isNotEmpty) ...[
            const _InfoDivider(),
            _InfoRow(
              icon: Icons.email_rounded,
              label: l.farmEmail,
              value: granja.correo!,
              color: AppColors.info,
            ),
          ],

          const _InfoDivider(),

          // Fecha de creación
          _InfoRow(
            icon: Icons.calendar_today_rounded,
            label: l.farmCreatedDate,
            value: GranjaDetailFormatters.formatDate(granja.fechaCreacion),
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

// ==================== ESTADÍSTICAS DE PRODUCCIÓN ====================

/// Card de estadísticas de producción.
class GranjaEstadisticasProduccion extends StatelessWidget {
  const GranjaEstadisticasProduccion({
    super.key,
    required this.granja,
    required this.casasActivas,
    required this.totalCasas,
    required this.lotesActivos,
    required this.totalLotes,
    required this.totalAves,
  });

  final Granja granja;
  final int casasActivas;
  final int totalCasas;
  final int lotesActivos;
  final int totalLotes;
  final int totalAves;

  @override
  Widget build(BuildContext context) {
    if (totalCasas == 0 && totalLotes == 0) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 600 ? 16.0 : 24.0;
    final capacidadTotal = granja.capacidadTotalAves ?? 0;
    final l = S.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allSm,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(screenWidth < 360 ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total de aves vs capacidad
          _ProgressIndicator(
            label: l.farmTotalOccupation,
            value: totalAves.toDouble(),
            maxValue: capacidadTotal > 0
                ? capacidadTotal.toDouble()
                : totalAves.toDouble(),
            unit: capacidadTotal > 0
                ? l.farmOfCapacityBirds(capacidadTotal.toStringAsFixed(0))
                : l.farmBirds,
            color: capacidadTotal > 0
                ? (totalAves / capacidadTotal < 0.7
                      ? AppColors.success
                      : totalAves / capacidadTotal < 0.9
                      ? AppColors.warning
                      : AppColors.error)
                : AppColors.info,
          ),

          if (totalCasas > 0) ...[
            AppSpacing.gapLg,
            _ProgressIndicator(
              label: l.farmActiveSheds,
              value: casasActivas.toDouble(),
              maxValue: totalCasas.toDouble(),
              unit: l.farmOfTotal(totalCasas.toString()),
              color: casasActivas == totalCasas
                  ? AppColors.success
                  : casasActivas > totalCasas * 0.7
                  ? AppColors.warning
                  : AppColors.error,
            ),
          ],

          if (totalLotes > 0) ...[
            AppSpacing.gapLg,
            _ProgressIndicator(
              label: l.farmBatchesInProduction,
              value: lotesActivos.toDouble(),
              maxValue: totalLotes.toDouble(),
              unit: l.farmOfTotal(totalLotes.toString()),
              color: lotesActivos > 0 ? AppColors.info : AppColors.grey600,
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== SECCIÓN DE NOTAS ====================

/// Sección de notas.
class GranjaNotasSection extends StatelessWidget {
  const GranjaNotasSection({super.key, required this.granja});

  final Granja granja;

  @override
  Widget build(BuildContext context) {
    if (granja.notas == null || granja.notas!.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    // Separar las notas por líneas
    final lineas = granja.notas!
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
              ? _BulletList(lineas: lineas)
              : _Paragraphs(lineas: lineas),
        ],
      ),
    );
  }
}

// ==================== SECCIÓN VACÍA ====================

/// Widget para mostrar cuando no hay items.
class GranjaEmptySection extends StatelessWidget {
  const GranjaEmptySection({
    super.key,
    required this.icon,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

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
          AppSpacing.gapMd,
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapBase,
          SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
              ),
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== ITEM CARD GENÉRICO ====================

/// Card de item genérico (casa, lote, etc.)
class GranjaItemCard extends StatelessWidget {
  const GranjaItemCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.allSm,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              iconColor.withValues(alpha: 0.05),
              iconColor.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: iconColor.withValues(alpha: 0.2),
            width: 1.5,
          ),
          borderRadius: AppRadius.allSm,
        ),
        child: Row(
          children: [
            // Icono
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: AppRadius.allSm,
              ),
              child: Icon(icon, color: AppColors.white, size: 22),
            ),
            AppSpacing.hGapMd,

            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AppSpacing.hGapSm,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: AppRadius.allSm,
                        ),
                        child: Text(
                          badge,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapXs,
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            AppSpacing.hGapXs,

            // Chevron
            Icon(
              Icons.chevron_right_rounded,
              color: iconColor.withValues(alpha: 0.6),
              size: 24,
            ),
          ],
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
              AppSpacing.gapXxs,
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

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
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
              '${value.toStringAsFixed(value < 100 && value % 1 != 0 ? 1 : 0)} $unit',
              style: theme.textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        AppSpacing.gapSm,
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.lineas});

  final List<String> lineas;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lineas.asMap().entries.map((entry) {
        final index = entry.key;
        String texto = entry.value;

        // Remover el símbolo de bullet si existe
        if (texto.startsWith('-') ||
            texto.startsWith('•') ||
            texto.startsWith('*') ||
            texto.startsWith('·')) {
          texto = texto.substring(1).trim();
        }

        return Padding(
          padding: EdgeInsets.only(bottom: index < lineas.length - 1 ? 12 : 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, right: 12),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  texto,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: theme.colorScheme.onSurface,
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

class _Paragraphs extends StatelessWidget {
  const _Paragraphs({required this.lineas});

  final List<String> lineas;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lineas.asMap().entries.map((entry) {
        final index = entry.key;
        return Padding(
          padding: EdgeInsets.only(bottom: index < lineas.length - 1 ? 16 : 0),
          child: Text(
            entry.value,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurface,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ==================== LOADING Y ERROR ====================

/// Widget de cargando para secciones.
class GranjaSectionLoading extends StatelessWidget {
  const GranjaSectionLoading({super.key});

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

/// Widget de error para secciones.
class GranjaSectionError extends StatelessWidget {
  const GranjaSectionError({super.key, required this.error});

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
          S.of(context).commonErrorWithDetail(error.toString()),
          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}

// ==================== SECCIÓN DE GALPONES ====================

/// Sección que muestra resumen de galpones de la granja con datos reales.
class GranjaGalponesSection extends ConsumerWidget {
  const GranjaGalponesSection({
    super.key,
    required this.granja,
    required this.onVerTodos,
    required this.onCrearGalpon,
    this.onVerGalpon,
  });

  final Granja granja;
  final VoidCallback onVerTodos;
  final VoidCallback onCrearGalpon;
  final void Function(String galponId)? onVerGalpon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final galponesAsync = ref.watch(galponesStreamProvider(granja.id));

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
      child: galponesAsync.when(
        data: (galpones) => galpones.isEmpty
            ? _buildEmptyState(context, theme)
            : _buildGalponesContent(context, theme, galpones),
        loading: () => _buildLoadingState(),
        error: (error, _) => _buildErrorState(context, theme, error.toString()),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(strokeWidth: 2.5),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          S.of(context).commonErrorWithDetail(error.toString()),
          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.error),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Icon(
            Icons.home_work_outlined,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          AppSpacing.gapMd,
          Text(
            S.of(context).farmNoShedsRegistered,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapBase,
          SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: onCrearGalpon,
              icon: const Icon(Icons.add),
              label: Text(S.of(context).farmCreateFirstShed),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalponesContent(
    BuildContext context,
    ThemeData theme,
    List<Galpon> galpones,
  ) {
    return Column(
      children: [
        // Lista de galpones (máximo 3)
        ...galpones
            .take(3)
            .map((galpon) => _buildGalponMiniCard(context, theme, galpon)),

        if (galpones.length > 3) ...[
          AppSpacing.gapMd,
          Center(
            child: Text(
              S.of(context).farmMoreSheds(galpones.length - 3),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],

        AppSpacing.gapLg,

        // Botones de acción
        _buildActionButtons(context, theme),
      ],
    );
  }

  Widget _buildGalponMiniCard(
    BuildContext context,
    ThemeData theme,
    Galpon galpon,
  ) {
    final ocupacion = galpon.capacidadMaxima > 0
        ? (galpon.avesActuales / galpon.capacidadMaxima)
        : 0.0;

    return GestureDetector(
      onTap: onVerGalpon != null ? () => onVerGalpon!(galpon.id) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.allSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila principal: icono, info, estado y chevron
            Row(
              children: [
                // Icono del tipo de galpón
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: galpon.tipo.color.withValues(alpha: 0.12),
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Icon(
                    galpon.tipo.icon,
                    color: galpon.tipo.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),

                // Nombre y tipo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        galpon.nombre,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        galpon.tipo.localizedDisplayName(S.of(context)),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge de estado
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: galpon.estado.color.withValues(alpha: 0.12),
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Text(
                    galpon.estado.localizedDisplayName(S.of(context)),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: galpon.estado.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AppSpacing.hGapSm,

                // Chevron
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.5,
                  ),
                  size: 20,
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Fila de ocupación
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).shedOccupation,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            S
                                .of(context)
                                .shedBirdsCount(
                                  galpon.avesActuales.toString(),
                                  galpon.capacidadMaxima.toString(),
                                ),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.gapSm,
                      ClipRRect(
                        borderRadius: AppRadius.allXs,
                        child: LinearProgressIndicator(
                          value: ocupacion.clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getOcupacionColor(ocupacion),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getOcupacionColor(double ocupacion) {
    if (ocupacion >= 0.9) return AppColors.error;
    if (ocupacion >= 0.7) return AppColors.warning;
    return AppColors.success;
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: onVerTodos,
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                side: BorderSide(color: theme.colorScheme.primary, width: 1),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
              ),
              child: Text(S.of(context).commonViewAll),
            ),
          ),
        ),
        AppSpacing.hGapSm,
        Expanded(
          child: SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: onCrearGalpon,
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
                elevation: 0,
              ),
              child: Text(S.of(context).shedNewShed),
            ),
          ),
        ),
      ],
    );
  }
}
