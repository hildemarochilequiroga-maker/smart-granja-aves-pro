/// Tipos de eventos que pueden ocurrir en un galpón avícola.
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/core/utils/formatters.dart';
import '../../../../core/theme/app_colors.dart';

enum TipoEventoGalpon {
  /// Registro de desinfección.
  desinfeccion('Desinfección', Icons.cleaning_services_rounded, AppColors.cyan),

  /// Programación o realización de mantenimiento.
  mantenimiento('Mantenimiento', Icons.build_rounded, AppColors.warning),

  /// Cambio de estado.
  cambioEstado('Cambio de Estado', Icons.swap_horiz_rounded, AppColors.purple),

  /// Creación del galpón.
  creacion('Creación', Icons.add_home_rounded, AppColors.success),

  /// Asignación de un lote.
  asignacionLote('Lote Asignado', Icons.input_rounded, AppColors.info),

  /// Liberación de un lote.
  liberacionLote('Lote Liberado', Icons.output_rounded, AppColors.teal),

  /// Otro tipo de evento.
  otro('Otro', Icons.info_outline_rounded, AppColors.outline);

  final String label;
  final IconData icon;
  final Color color;

  const TipoEventoGalpon(this.label, this.icon, this.color);

  /// Etiqueta localizada del tipo de evento
  String get localizedLabel {
    final locale = Formatters.currentLocale;
    return switch (this) {
      TipoEventoGalpon.desinfeccion => switch (locale) { 'es' => 'Desinfección', 'pt' => 'Desinfecção', _ => 'Disinfection' },
      TipoEventoGalpon.mantenimiento => switch (locale) { 'es' => 'Mantenimiento', 'pt' => 'Manutenção', _ => 'Maintenance' },
      TipoEventoGalpon.cambioEstado =>
        switch (locale) { 'es' => 'Cambio de Estado', 'pt' => 'Mudança de Estado', _ => 'Status Change' },
      TipoEventoGalpon.creacion => switch (locale) { 'es' => 'Creación', 'pt' => 'Criação', _ => 'Creation' },
      TipoEventoGalpon.asignacionLote =>
        switch (locale) { 'es' => 'Lote Asignado', 'pt' => 'Lote Atribuído', _ => 'Batch Assigned' },
      TipoEventoGalpon.liberacionLote =>
        switch (locale) { 'es' => 'Lote Liberado', 'pt' => 'Lote Liberado', _ => 'Batch Released' },
      TipoEventoGalpon.otro => switch (locale) { 'es' => 'Otro', 'pt' => 'Outro', _ => 'Other' },
    };
  }

  String toJson() => name;

  static TipoEventoGalpon fromJson(String json) {
    return TipoEventoGalpon.values.firstWhere(
      (e) => e.name == json,
      orElse: () => TipoEventoGalpon.otro,
    );
  }

  static TipoEventoGalpon? tryFromJson(String? json) {
    if (json == null) return null;
    return fromJson(json);
  }
}
