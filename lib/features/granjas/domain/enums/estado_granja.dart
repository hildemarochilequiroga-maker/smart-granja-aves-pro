library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/core/errors/error_messages.dart';
import 'package:smartgranjaavespro/core/utils/formatters.dart';
import 'package:smartgranjaavespro/core/theme/app_colors.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Estado operativo de una granja
///
/// Define si la granja está operativa, en mantenimiento o inactiva.
enum EstadoGranja {
  /// Granja operativa y funcional
  ///
  /// - Puede tener lotes activos
  /// - Todas las operaciones permitidas
  activo('Activo', 'Granja en operación', AppColors.active),

  /// Granja temporalmente inactiva
  ///
  /// - Sin lotes activos
  /// - No se pueden crear nuevos lotes
  /// - Datos históricos disponibles
  inactivo('Inactivo', 'Granja sin operaciones', AppColors.inactive),

  /// Granja en mantenimiento o remodelación
  ///
  /// - Operaciones limitadas
  /// - Puede tener lotes en proceso de cierre
  /// - No se aceptan nuevos lotes
  mantenimiento('Mantenimiento', 'Granja en reparación', AppColors.warning);

  const EstadoGranja(this.displayName, this.descripcion, this.color);

  /// Nombre para mostrar en la UI
  final String displayName;

  /// Descripción detallada del estado
  final String descripcion;

  /// Color asociado al estado
  final Color color;

  /// Nombre localizado del estado
  String get localizedName {
    final locale = Formatters.currentLocale;
    return switch (this) {
      EstadoGranja.activo => switch (locale) { 'es' => 'Activo', 'pt' => 'Ativo', _ => 'Active' },
      EstadoGranja.inactivo => switch (locale) { 'es' => 'Inactivo', 'pt' => 'Inativo', _ => 'Inactive' },
      EstadoGranja.mantenimiento => switch (locale) { 'es' => 'Mantenimiento', 'pt' => 'Manutenção', _ => 'Maintenance' },
    };
  }

  /// Descripción localizada del estado
  String get localizedDescripcion {
    final locale = Formatters.currentLocale;
    return switch (this) {
      EstadoGranja.activo => switch (locale) { 'es' => 'Granja en operación', 'pt' => 'Granja em operação', _ => 'Farm in operation' },
      EstadoGranja.inactivo =>
        switch (locale) { 'es' => 'Granja sin operaciones', 'pt' => 'Granja sem operações', _ => 'Farm without operations' },
      EstadoGranja.mantenimiento =>
        switch (locale) { 'es' => 'Granja en reparación', 'pt' => 'Granja em reparo', _ => 'Farm under repair' },
    };
  }

  /// Nombre localizado del estado usando ARB keys
  String localizedDisplayName(S l) {
    return switch (this) {
      EstadoGranja.activo => l.farmStatusActive,
      EstadoGranja.inactivo => l.farmStatusInactive,
      EstadoGranja.mantenimiento => l.farmStatusMaintenance,
    };
  }

  /// Descripción localizada del estado usando ARB keys
  String localizedDescription(S l) {
    return switch (this) {
      EstadoGranja.activo => l.farmStatusActiveDesc,
      EstadoGranja.inactivo => l.farmStatusInactiveDesc,
      EstadoGranja.mantenimiento => l.farmStatusMaintenanceDesc,
    };
  }

  /// Convierte a JSON (nombre del enum)
  String toJson() => name;

  /// Crea desde JSON
  static EstadoGranja fromJson(String json) {
    return EstadoGranja.values.firstWhere(
      (e) => e.name == json,
      orElse: () => throw ArgumentError(ErrorMessages.format('ENUM_INVALID_ESTADO_GRANJA', {'value': json})),
    );
  }

  /// Intenta crear desde JSON, retorna null si falla
  static EstadoGranja? tryFromJson(String? json) {
    if (json == null) return null;
    try {
      return fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Verifica si la granja está operativa
  bool get estaOperativa => this == EstadoGranja.activo;

  /// Verifica si permite crear nuevos lotes
  bool get permiteNuevosLotes => this == EstadoGranja.activo;

  /// Verifica si permite operaciones de lectura
  bool get permiteConsultas => true;

  /// Verifica si permite operaciones de escritura
  bool get permiteModificaciones {
    return this == EstadoGranja.activo || this == EstadoGranja.mantenimiento;
  }

  /// Obtiene el nombre del icono asociado
  IconData get icono {
    switch (this) {
      case EstadoGranja.activo:
        return Icons.check_circle;
      case EstadoGranja.inactivo:
        return Icons.cancel;
      case EstadoGranja.mantenimiento:
        return Icons.build;
    }
  }
}
