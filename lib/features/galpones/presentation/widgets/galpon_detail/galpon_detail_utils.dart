/// Utilidades y helpers para la pantalla de detalle de galpón.
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/errors/error_messages.dart';

import '../../../../../core/utils/formatters.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/enums/enums.dart';

/// Utilidades de formateo para la pantalla de detalle de galpón.
class GalponDetailFormatters {
  const GalponDetailFormatters._();

  /// Formatea números grandes con separadores (K, M).
  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return Formatters.numeroMiles.format(number);
  }

  /// Formatea fecha en formato legible.
  static String formatDate(DateTime date) {
    return Formatters.fechaDeMes.format(date);
  }

  /// Formatea fecha corta.
  static String formatDateShort(DateTime date) {
    return Formatters.fechaDDMMYYYY.format(date);
  }

  /// Formatea fecha relativa (hace X días).
  static String formatRelativeDate(DateTime date, {BuildContext? context}) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (context != null) {
      final l = S.of(context);
      if (difference.inDays == 0) {
        return l.commonToday;
      } else if (difference.inDays == 1) {
        return l.commonYesterday;
      } else if (difference.inDays < 7) {
        return l.shedDaysAgoLabel(difference.inDays);
      } else if (difference.inDays < 30) {
        final semanas = (difference.inDays / 7).floor();
        return l.shedWeeksAgo(semanas, semanas == 1 ? l.shedWeek : l.shedWeeks);
      } else if (difference.inDays < 365) {
        final meses = (difference.inDays / 30).floor();
        return l.shedWeeksAgo(meses, meses == 1 ? l.shedMonth : l.shedMonths);
      } else {
        final anos = (difference.inDays / 365).floor();
        return l.shedWeeksAgo(anos, anos == 1 ? l.shedYear : l.shedYears);
      }
    }

    if (difference.inDays == 0) {
      return ErrorMessages.get('DATE_TODAY');
    } else if (difference.inDays == 1) {
      return ErrorMessages.get('DATE_YESTERDAY');
    } else if (difference.inDays < 7) {
      return ErrorMessages.format('DATE_DAYS_AGO', {
        'count': difference.inDays.toString(),
      });
    } else if (difference.inDays < 30) {
      final semanas = (difference.inDays / 7).floor();
      final unit = semanas == 1
          ? ErrorMessages.get('UNIT_WEEK')
          : ErrorMessages.get('UNIT_WEEKS');
      return ErrorMessages.format('DATE_WEEKS_AGO', {
        'count': semanas.toString(),
        'unit': unit,
      });
    } else if (difference.inDays < 365) {
      final meses = (difference.inDays / 30).floor();
      final unit = meses == 1
          ? ErrorMessages.get('UNIT_MONTH')
          : ErrorMessages.get('UNIT_MONTHS');
      return ErrorMessages.format('DATE_MONTHS_AGO', {
        'count': meses.toString(),
        'unit': unit,
      });
    } else {
      final anos = (difference.inDays / 365).floor();
      final unit = anos == 1
          ? ErrorMessages.get('UNIT_YEAR')
          : ErrorMessages.get('UNIT_YEARS');
      return ErrorMessages.format('DATE_YEARS_AGO', {
        'count': anos.toString(),
        'unit': unit,
      });
    }
  }

  /// Formatea área en metros cuadrados.
  static String formatArea(double? area, {BuildContext? context}) {
    if (area == null) {
      return context != null
          ? S.of(context).shedNotSpecified
          : ErrorMessages.get('NOT_SPECIFIED');
    }
    return '${Formatters.numeroMiles.format(area)} m²';
  }

  /// Formatea capacidad de aves (número completo).
  static String formatCapacidad(int capacidad, {BuildContext? context}) {
    final count = Formatters.numeroMiles.format(capacidad);
    if (context != null) return S.of(context).shedCurrentBirdsValue(count);
    return '$count ${ErrorMessages.get('COMMON_BIRDS')}';
  }

  /// Formatea porcentaje.
  static String formatPorcentaje(double porcentaje) {
    return '${porcentaje.toStringAsFixed(1)}%';
  }

  /// Calcula los días desde una fecha.
  static int calcularDias(DateTime fecha) {
    return DateTime.now().difference(fecha).inDays;
  }
}

/// Obtiene información visual según el estado del galpón.
class GalponEstadoInfo {
  const GalponEstadoInfo._();

  static Color getColor(EstadoGalpon estado) {
    return estado.color;
  }

  static IconData getIcon(EstadoGalpon estado) {
    return estado.icon;
  }

  static String getLabel(EstadoGalpon estado, {BuildContext? context}) {
    if (context != null) return estado.localizedDisplayName(S.of(context));
    return estado.displayName;
  }

  static String getDescription(EstadoGalpon estado, {BuildContext? context}) {
    if (context != null) return estado.localizedDescripcion(S.of(context));
    return estado.descripcion;
  }
}

/// Obtiene información visual según el tipo de galpón.
class GalponTipoInfo {
  const GalponTipoInfo._();

  static Color getColor(TipoGalpon tipo) {
    return tipo.color;
  }

  static IconData getIcon(TipoGalpon tipo) {
    return tipo.icon;
  }

  static String getLabel(TipoGalpon tipo, {BuildContext? context}) {
    if (context != null) return tipo.localizedDisplayName(S.of(context));
    return tipo.displayName;
  }

  static String getDescription(TipoGalpon tipo, {BuildContext? context}) {
    if (context != null) return tipo.localizedDescripcion(S.of(context));
    return tipo.descripcion;
  }
}

/// Widgets comunes reutilizables para el detalle de galpón.
class GalponDetailCommonWidgets {
  const GalponDetailCommonWidgets._();

  /// Widget para fila de información con icono.
  static Widget infoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
    Color? valueColor,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final color = iconColor ?? AppColors.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.allSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
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
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.gapXxxs,
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: valueColor ?? theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  /// Título de sección.
  static Widget sectionTitle(
    BuildContext context,
    String title, {
    IconData? icon,
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: color ?? AppColors.primary),
            AppSpacing.hGapSm,
          ],
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  /// Chip informativo.
  static Widget infoChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.allXl,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          AppSpacing.hGapXs,
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Card de estadística.
  static Widget statCard({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final cardColor = color ?? AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.08),
        borderRadius: AppRadius.allMd,
        border: Border.all(color: cardColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: cardColor, size: 24),
          AppSpacing.gapMd,
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: cardColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Sensor chip activo/inactivo.
  static Widget sensorChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool activo,
  }) {
    final theme = Theme.of(context);
    final color = activo ? AppColors.success : AppColors.disabled;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.allXl,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          AppSpacing.hGapXs,
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: activo ? color : AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }
}
