/// Estado operativo de un galpón avícola.
///
/// Define la disponibilidad y condición actual de una instalación.
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/core/errors/error_messages.dart';
import 'package:smartgranjaavespro/core/utils/formatters.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

enum EstadoGalpon {
  /// Galpón activo y disponible para operaciones.
  activo('Activo', 'Galpón operativo', '#2E7D32'),

  /// Galpón en mantenimiento o limpieza.
  mantenimiento('Mantenimiento', 'Galpón en reparación', '#F57C00'),

  /// Galpón inactivo o fuera de servicio.
  inactivo('Inactivo', 'Galpón sin uso', '#9E9E9E'),

  /// Galpón en proceso de limpieza y desinfección.
  desinfeccion('Desinfección', 'Galpón en proceso sanitario', '#0288D1'),

  /// Galpón en cuarentena por bioseguridad.
  cuarentena('Cuarentena', 'Galpón aislado por sanidad', '#BA1A1A');

  const EstadoGalpon(this.displayName, this.descripcion, this.colorHex);

  final String displayName;
  final String descripcion;
  final String colorHex;

  /// Convierte el colorHex a un Color de Flutter.
  Color get color {
    final hex = colorHex.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  /// Ícono representativo del estado.
  IconData get icon {
    switch (this) {
      case EstadoGalpon.activo:
        return Icons.check_circle;
      case EstadoGalpon.mantenimiento:
        return Icons.build;
      case EstadoGalpon.inactivo:
        return Icons.pause_circle;
      case EstadoGalpon.desinfeccion:
        return Icons.cleaning_services;
      case EstadoGalpon.cuarentena:
        return Icons.warning;
    }
  }

  /// Nombre localizado del estado
  String get localizedName {
    final locale = Formatters.currentLocale;
    return switch (this) {
      EstadoGalpon.activo => switch (locale) { 'es' => 'Activo', 'pt' => 'Ativo', _ => 'Active' },
      EstadoGalpon.mantenimiento => switch (locale) { 'es' => 'Mantenimiento', 'pt' => 'Manutenção', _ => 'Maintenance' },
      EstadoGalpon.inactivo => switch (locale) { 'es' => 'Inactivo', 'pt' => 'Inativo', _ => 'Inactive' },
      EstadoGalpon.desinfeccion => switch (locale) { 'es' => 'Desinfección', 'pt' => 'Desinfecção', _ => 'Disinfection' },
      EstadoGalpon.cuarentena => switch (locale) { 'es' => 'Cuarentena', 'pt' => 'Quarentena', _ => 'Quarantine' },
    };
  }

  /// Descripción localizada del estado (fallback sin context)
  String get localizedDescripcionFallback {
    final locale = Formatters.currentLocale;
    return switch (this) {
      EstadoGalpon.activo => switch (locale) { 'es' => 'Galpón operativo', 'pt' => 'Galpão operacional', _ => 'Operational house' },
      EstadoGalpon.mantenimiento =>
        switch (locale) { 'es' => 'Galpón en reparación', 'pt' => 'Galpão em reparo', _ => 'House under repair' },
      EstadoGalpon.inactivo => switch (locale) { 'es' => 'Galpón sin uso', 'pt' => 'Galpão sem uso', _ => 'Unused house' },
      EstadoGalpon.desinfeccion =>
        switch (locale) { 'es' => 'Galpón en proceso sanitario', 'pt' => 'Galpão em processo sanitário', _ => 'House in sanitary process' },
      EstadoGalpon.cuarentena =>
        switch (locale) { 'es' => 'Galpón aislado por sanidad', 'pt' => 'Galpão isolado por sanidade', _ => 'House isolated for health' },
    };
  }

  /// Nombre localizado para UI con AppLocalizations.
  String localizedDisplayName(S l) {
    return switch (this) {
      EstadoGalpon.activo => l.enumEstadoGalponActivo,
      EstadoGalpon.mantenimiento => l.enumEstadoGalponMantenimiento,
      EstadoGalpon.inactivo => l.enumEstadoGalponInactivo,
      EstadoGalpon.desinfeccion => l.enumEstadoGalponDesinfeccion,
      EstadoGalpon.cuarentena => l.enumEstadoGalponCuarentena,
    };
  }

  /// Descripción localizada para UI con AppLocalizations.
  String localizedDescripcion(S l) {
    return switch (this) {
      EstadoGalpon.activo => l.enumEstadoGalponDescActivo,
      EstadoGalpon.mantenimiento => l.enumEstadoGalponDescMantenimiento,
      EstadoGalpon.inactivo => l.enumEstadoGalponDescInactivo,
      EstadoGalpon.desinfeccion => l.enumEstadoGalponDescDesinfeccion,
      EstadoGalpon.cuarentena => l.enumEstadoGalponDescCuarentena,
    };
  }

  String toJson() => name;

  static EstadoGalpon fromJson(String json) {
    return EstadoGalpon.values.firstWhere(
      (e) => e.name == json,
      orElse: () => throw ArgumentError(ErrorMessages.format('ENUM_INVALID_ESTADO_GALPON', {'value': json})),
    );
  }

  static EstadoGalpon? tryFromJson(String? json) {
    if (json == null) return null;
    try {
      return fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Verifica si el galpón está disponible para nuevos lotes.
  bool get disponibleParaNuevosLotes => this == EstadoGalpon.activo;

  /// Verifica si el galpón puede contener lotes.
  bool get puedeContenerLotes {
    return this == EstadoGalpon.activo ||
        this == EstadoGalpon.mantenimiento ||
        this == EstadoGalpon.cuarentena;
  }

  /// Verifica si requiere estar vacío.
  bool get debeEstarVacio {
    return this == EstadoGalpon.desinfeccion || this == EstadoGalpon.inactivo;
  }

  /// Verifica si requiere atención inmediata.
  bool get requiereAtencion {
    return this == EstadoGalpon.cuarentena ||
        this == EstadoGalpon.mantenimiento;
  }

  /// Días típicos requeridos en este estado.
  int? get diasTipicosEnEstado {
    switch (this) {
      case EstadoGalpon.desinfeccion:
        return 10;
      case EstadoGalpon.mantenimiento:
        return 5;
      case EstadoGalpon.cuarentena:
        return 21;
      case EstadoGalpon.activo:
      case EstadoGalpon.inactivo:
        return null;
    }
  }

  /// Estados a los que puede transicionar.
  List<EstadoGalpon> get transicionesPermitidas {
    switch (this) {
      case EstadoGalpon.activo:
        return [
          EstadoGalpon.mantenimiento,
          EstadoGalpon.desinfeccion,
          EstadoGalpon.cuarentena,
          EstadoGalpon.inactivo,
        ];
      case EstadoGalpon.mantenimiento:
        return [
          EstadoGalpon.activo,
          EstadoGalpon.inactivo,
          EstadoGalpon.cuarentena,
        ];
      case EstadoGalpon.desinfeccion:
        return [EstadoGalpon.activo, EstadoGalpon.mantenimiento];
      case EstadoGalpon.cuarentena:
        return [EstadoGalpon.desinfeccion, EstadoGalpon.mantenimiento];
      case EstadoGalpon.inactivo:
        return [EstadoGalpon.mantenimiento, EstadoGalpon.desinfeccion];
    }
  }

  /// Verifica si puede transicionar a un estado específico.
  bool puedeTransicionarA(EstadoGalpon nuevoEstado) {
    return transicionesPermitidas.contains(nuevoEstado);
  }

  /// Nombre del ícono asociado.
  String get iconName {
    switch (this) {
      case EstadoGalpon.activo:
        return 'home';
      case EstadoGalpon.mantenimiento:
        return 'build';
      case EstadoGalpon.inactivo:
        return 'home_work';
      case EstadoGalpon.desinfeccion:
        return 'clean_hands';
      case EstadoGalpon.cuarentena:
        return 'dangerous';
    }
  }

  /// Nivel de urgencia (0-10, mayor = más urgente).
  int get nivelUrgencia {
    switch (this) {
      case EstadoGalpon.cuarentena:
        return 10;
      case EstadoGalpon.mantenimiento:
        return 7;
      case EstadoGalpon.desinfeccion:
        return 5;
      case EstadoGalpon.activo:
      case EstadoGalpon.inactivo:
        return 0;
    }
  }
}
