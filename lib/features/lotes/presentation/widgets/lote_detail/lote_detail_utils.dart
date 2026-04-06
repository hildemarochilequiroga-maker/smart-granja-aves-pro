/// Utilidades y helpers para la pantalla de detalle de lote.
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/errors/error_messages.dart';

import '../../../../../core/utils/formatters.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/enums/enums.dart';

/// Utilidades de formateo para la pantalla de detalle de lote.
class LoteDetailFormatters {
  const LoteDetailFormatters._();

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
  static String formatRelativeDate(DateTime date) {
    return Formatters.dateRelative(date);
  }

  /// Formatea peso en kilogramos.
  static String formatPeso(double? peso, {BuildContext? context}) {
    if (peso == null) {
      if (context != null) return S.of(context).batchNotRecorded;
      return ErrorMessages.get('NOT_RECORDED');
    }
    return '${Formatters.numeroMiles.format(peso)} kg';
  }

  /// Formatea cantidad de aves (número completo).
  static String formatCantidadAves(int cantidad, {BuildContext? context}) {
    final count = Formatters.numeroMiles.format(cantidad);
    if (context != null) return '$count ${S.of(context).commonBirds}';
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

  /// Calcula semanas desde una fecha.
  static int calcularSemanas(DateTime fecha) {
    return (calcularDias(fecha) / 7).floor();
  }
}

/// Obtiene información visual según el estado del lote.
class LoteEstadoInfo {
  const LoteEstadoInfo._();

  /// Obtiene el color del estado (igual que lote_list_card).
  static Color getColor(EstadoLote estado) {
    switch (estado) {
      case EstadoLote.activo:
        return AppColors.success;
      case EstadoLote.cerrado:
        return AppColors.grey600;
      case EstadoLote.cuarentena:
        return AppColors.warning;
      case EstadoLote.vendido:
        return AppColors.info;
      case EstadoLote.enTransferencia:
        return AppColors.purple;
      case EstadoLote.suspendido:
        return AppColors.error;
    }
  }

  /// Obtiene el icono del estado.
  static IconData getIcon(EstadoLote estado) {
    switch (estado) {
      case EstadoLote.activo:
        return Icons.check_circle;
      case EstadoLote.cerrado:
        return Icons.lock;
      case EstadoLote.cuarentena:
        return Icons.warning;
      case EstadoLote.vendido:
        return Icons.monetization_on;
      case EstadoLote.enTransferencia:
        return Icons.swap_horiz;
      case EstadoLote.suspendido:
        return Icons.pause_circle;
    }
  }

  static String getLabel(EstadoLote estado) {
    return estado.displayName;
  }

  static String getDescription(EstadoLote estado) {
    return estado.descripcion;
  }
}

/// Obtiene información visual según el tipo de ave.
class LoteTipoAveInfo {
  const LoteTipoAveInfo._();

  /// Obtiene el color del tipo de ave.
  static Color getColor(TipoAve tipo) {
    switch (tipo) {
      case TipoAve.polloEngorde:
        return AppColors.info;
      case TipoAve.gallinaPonedora:
        return AppColors.info;
      case TipoAve.reproductoraPesada:
        return AppColors.info;
      case TipoAve.reproductoraLiviana:
        return AppColors.pink;
      case TipoAve.pavo:
        return AppColors.purple;
      case TipoAve.codorniz:
        return AppColors.brown;
      case TipoAve.pato:
        return AppColors.cyan;
      case TipoAve.otro:
        return AppColors.outlineVariant;
    }
  }

  /// Obtiene el icono del tipo de ave.
  static IconData getIcon(TipoAve tipo) {
    switch (tipo) {
      case TipoAve.polloEngorde:
        return Icons.fastfood;
      case TipoAve.gallinaPonedora:
        return Icons.egg;
      case TipoAve.reproductoraPesada:
        return Icons.favorite;
      case TipoAve.reproductoraLiviana:
        return Icons.favorite_border;
      case TipoAve.pavo:
        return Icons.pets;
      case TipoAve.codorniz:
        return Icons.flutter_dash;
      case TipoAve.pato:
        return Icons.water_drop;
      case TipoAve.otro:
        return Icons.more_horiz;
    }
  }

  static String getLabel(TipoAve tipo) {
    return tipo.displayName;
  }

  static String getDescription(TipoAve tipo, {BuildContext? context}) {
    if (context != null) {
      final l = S.of(context);
      switch (tipo) {
        case TipoAve.polloEngorde:
          return l.batchTypePoultryDesc;
        case TipoAve.gallinaPonedora:
          return l.batchTypeLayersDesc;
        case TipoAve.reproductoraPesada:
          return l.batchTypeHeavyBreedersDesc;
        case TipoAve.reproductoraLiviana:
          return l.batchTypeLightBreedersDesc;
        case TipoAve.pavo:
          return l.batchTypeTurkeysDesc;
        case TipoAve.codorniz:
          return l.batchTypeQuailDesc;
        case TipoAve.pato:
          return l.batchTypeDucksDesc;
        case TipoAve.otro:
          return l.batchTypeOtherDesc;
      }
    }
    switch (tipo) {
      case TipoAve.polloEngorde:
        return ErrorMessages.get('BIRD_TYPE_BROILER_DESC');
      case TipoAve.gallinaPonedora:
        return ErrorMessages.get('BIRD_TYPE_LAYER_DESC');
      case TipoAve.reproductoraPesada:
        return ErrorMessages.get('BIRD_TYPE_HEAVY_BREEDER_DESC');
      case TipoAve.reproductoraLiviana:
        return ErrorMessages.get('BIRD_TYPE_LIGHT_BREEDER_DESC');
      case TipoAve.pavo:
        return ErrorMessages.get('BIRD_TYPE_TURKEY_DESC');
      case TipoAve.codorniz:
        return ErrorMessages.get('BIRD_TYPE_QUAIL_DESC');
      case TipoAve.pato:
        return ErrorMessages.get('BIRD_TYPE_DUCK_DESC');
      case TipoAve.otro:
        return ErrorMessages.get('BIRD_TYPE_OTHER_DESC');
    }
  }
}

/// Widgets comunes reutilizables para el detalle de lote.
class LoteDetailCommonWidgets {
  const LoteDetailCommonWidgets._();

  /// Widget para fila de información con icono.
  static Widget infoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
    Color? valueColor,
    VoidCallback? onTap,
  }) {
    final color = iconColor ?? AppColors.info;

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
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                    ).copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  AppSpacing.gapXxxs,
                  Text(
                    value,
                    style: const TextStyle(fontSize: 14).copyWith(
                      fontWeight: FontWeight.w500,
                      color: valueColor ?? AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.chevron_right,
                color: AppColors.onSurfaceVariant,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  /// Título de sección.
  static Widget sectionTitle(String title, {IconData? icon, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: color ?? AppColors.info),
            AppSpacing.hGapSm,
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ).copyWith(fontWeight: FontWeight.bold, color: AppColors.onSurface),
          ),
        ],
      ),
    );
  }

  /// Chip informativo.
  static Widget infoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
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
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ).copyWith(fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  /// Card de estadística.
  static Widget statCard({
    required IconData icon,
    required String value,
    required String label,
    Color? color,
  }) {
    final cardColor = color ?? AppColors.info;

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
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ).copyWith(color: cardColor, fontWeight: FontWeight.bold),
          ),
          AppSpacing.gapXxs,
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
            ).copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  /// Alerta chip (requiere atención).
  static Widget alertChip({
    required IconData icon,
    required String label,
    bool isWarning = false,
  }) {
    final color = isWarning ? AppColors.warning : AppColors.error;
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
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ).copyWith(fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
