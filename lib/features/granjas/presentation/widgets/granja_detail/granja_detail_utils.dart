/// Utilidades y helpers para la pantalla de detalle de granja.
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/utils/formatters.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/enums/enums.dart';
import '../../../domain/value_objects/value_objects.dart';

/// Utilidades de formateo para la pantalla de detalle.
class GranjaDetailFormatters {
  const GranjaDetailFormatters._();

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

  /// Formatea dirección completa.
  static String formatDireccion(Direccion direccion) {
    return direccion.direccionCompleta;
  }

  /// Formatea área en metros cuadrados.
  static String formatArea(double? area, {BuildContext? context}) {
    if (area == null) {
      if (context != null) return S.of(context).commonNotSpecified;
      return switch (Formatters.currentLocale) { 'es' => 'No especificada', 'pt' => 'Não especificada', _ => 'Not specified' };
    }
    return '${Formatters.numeroMiles.format(area)} m²';
  }

  /// Formatea capacidad de aves.
  static String formatCapacidad(int? capacidad, {BuildContext? context}) {
    if (capacidad == null) {
      if (context != null) return S.of(context).commonNotSpecified;
      return switch (Formatters.currentLocale) { 'es' => 'No especificada', 'pt' => 'Não especificada', _ => 'Not specified' };
    }
    final count = formatNumber(capacidad);
    if (context != null) return '$count ${S.of(context).commonBirds}';
    return '$count ${switch (Formatters.currentLocale) { 'es' => 'aves', 'pt' => 'aves', _ => 'birds' }}';
  }

  /// Formatea teléfono peruano.
  static String formatTelefono(String telefono) {
    if (telefono.length == 9) {
      return '${telefono.substring(0, 3)} ${telefono.substring(3, 6)} ${telefono.substring(6)}';
    }
    return telefono;
  }

  /// Calcula los días activos desde una fecha.
  static int calcularDiasActivo(DateTime fechaIngreso) {
    return DateTime.now().difference(fechaIngreso).inDays;
  }

  /// Obtiene etiqueta del tipo de ave.
  static String getTipoAveLabel(dynamic tipoAve, {BuildContext? context}) {
    final tipo = tipoAve.toString().toLowerCase();
    if (context != null) {
      final l = S.of(context);
      if (tipo.contains('pollo') || tipo.contains('engorde')) {
        return l.farmBroiler;
      }
      if (tipo.contains('gallina') || tipo.contains('ponedora')) {
        return l.farmLayer;
      }
      if (tipo.contains('reproductor')) return l.farmBreeder;
      return l.farmBird;
    }
    final locale = Formatters.currentLocale;
    if (tipo.contains('pollo') || tipo.contains('engorde')) {
      return switch (locale) { 'es' => 'Engorde', 'pt' => 'Corte', _ => 'Broiler' };
    }
    if (tipo.contains('gallina') || tipo.contains('ponedora')) {
      return switch (locale) { 'es' => 'Ponedora', 'pt' => 'Poedeira', _ => 'Layer' };
    }
    if (tipo.contains('reproductor')) {
      return switch (locale) { 'es' => 'Reproductor', 'pt' => 'Reprodutor', _ => 'Breeder' };
    }
    return switch (locale) { 'es' => 'Ave', 'pt' => 'Ave', _ => 'Bird' };
  }

  /// Obtiene color según tipo de ave.
  static Color getTipoAveColor(dynamic tipoAve) {
    final tipo = tipoAve.toString().toLowerCase();
    if (tipo.contains('pollo') || tipo.contains('engorde')) {
      return AppColors.warning;
    }
    if (tipo.contains('gallina') || tipo.contains('ponedora')) {
      return AppColors.pink;
    }
    if (tipo.contains('reproductor')) return AppColors.purple;
    return AppColors.indigo;
  }
}

/// Obtiene información visual según el estado de la granja.
class GranjaEstadoInfo {
  const GranjaEstadoInfo._();

  static Color getColor(EstadoGranja estado) {
    switch (estado) {
      case EstadoGranja.activo:
        return AppColors.success;
      case EstadoGranja.inactivo:
        return AppColors.grey600;
      case EstadoGranja.mantenimiento:
        return AppColors.warning;
    }
  }

  static IconData getIcon(EstadoGranja estado) {
    switch (estado) {
      case EstadoGranja.activo:
        return Icons.check_circle;
      case EstadoGranja.inactivo:
        return Icons.pause_circle;
      case EstadoGranja.mantenimiento:
        return Icons.build_circle;
    }
  }

  static String getLabel(EstadoGranja estado, {BuildContext? context}) {
    if (context != null) {
      final l = S.of(context);
      switch (estado) {
        case EstadoGranja.activo:
          return l.farmStatusActive;
        case EstadoGranja.inactivo:
          return l.farmStatusInactive;
        case EstadoGranja.mantenimiento:
          return l.farmStatusMaintenance;
      }
    }
    final locale = Formatters.currentLocale;
    switch (estado) {
      case EstadoGranja.activo:
        return switch (locale) { 'es' => 'Activa', 'pt' => 'Ativa', _ => 'Active' };
      case EstadoGranja.inactivo:
        return switch (locale) { 'es' => 'Inactiva', 'pt' => 'Inativa', _ => 'Inactive' };
      case EstadoGranja.mantenimiento:
        return switch (locale) { 'es' => 'Mantenimiento', 'pt' => 'Manutenção', _ => 'Maintenance' };
    }
  }

  static String getDescription(EstadoGranja estado, {BuildContext? context}) {
    if (context != null) {
      final l = S.of(context);
      switch (estado) {
        case EstadoGranja.activo:
          return l.farmStatusActiveDesc;
        case EstadoGranja.inactivo:
          return l.farmStatusInactiveDesc;
        case EstadoGranja.mantenimiento:
          return l.farmStatusMaintenanceDesc;
      }
    }
    final locale = Formatters.currentLocale;
    switch (estado) {
      case EstadoGranja.activo:
        return switch (locale) { 'es' => 'Operando normalmente', 'pt' => 'Operando normalmente', _ => 'Operating normally' };
      case EstadoGranja.inactivo:
        return switch (locale) { 'es' => 'Operaciones suspendidas', 'pt' => 'Operações suspensas', _ => 'Operations suspended' };
      case EstadoGranja.mantenimiento:
        return switch (locale) { 'es' => 'En proceso de mantenimiento', 'pt' => 'Em processo de manutenção', _ => 'Under maintenance' };
    }
  }
}

/// Widgets comunes reutilizables para el detalle.
class GranjaDetailCommonWidgets {
  const GranjaDetailCommonWidgets._();

  /// Widget para fila de información con icono.
  static Widget infoRow({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    final color = iconColor ?? theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.allSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
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
  static Widget sectionTitle(ThemeData theme, String title, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: theme.colorScheme.primary),
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
    required ThemeData theme,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.allSm,
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
    required ThemeData theme,
    required IconData icon,
    required String value,
    required String label,
    Color? color,
  }) {
    final cardColor = color ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.08),
        borderRadius: AppRadius.allSm,
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
}

/// Extension para capitalizar strings.
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
