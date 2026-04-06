/// Tipos de items en el inventario de la granja.
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Clasificación principal de items en inventario.
enum TipoItem {
  /// Alimentos y concentrados para aves.
  alimento('Alimento', 'Concentrados, granos y suplementos', 'FF9800'),

  /// Medicamentos y productos veterinarios.
  medicamento('Medicamento', 'Fármacos y productos sanitarios', 'F44336'),

  /// Vacunas para prevención.
  vacuna('Vacuna', 'Vacunas y biológicos', '4CAF50'),

  /// Equipos y herramientas.
  equipo('Equipo', 'Herramientas y maquinaria', '2196F3'),

  /// Insumos generales.
  insumo('Insumo', 'Material de cama, empaques, etc.', '9C27B0'),

  /// Productos de limpieza y desinfección.
  limpieza('Limpieza', 'Desinfectantes y productos de aseo', '00BCD4'),

  /// Otros items.
  otro('Otro', 'Items varios', '9E9E9E');

  const TipoItem(this.nombre, this.descripcion, this.colorHex);

  /// Nombre legible del tipo.
  final String nombre;

  /// Descripción del tipo.
  final String descripcion;

  /// Color en hexadecimal (sin #).
  final String colorHex;

  /// Icono representativo del tipo.
  IconData get icono {
    switch (this) {
      case TipoItem.alimento:
        return Icons.restaurant;
      case TipoItem.medicamento:
        return Icons.medical_services;
      case TipoItem.vacuna:
        return Icons.vaccines;
      case TipoItem.equipo:
        return Icons.construction;
      case TipoItem.insumo:
        return Icons.inventory_2;
      case TipoItem.limpieza:
        return Icons.cleaning_services;
      case TipoItem.otro:
        return Icons.category;
    }
  }

  /// Verifica si es un insumo directo para producción.
  bool get esInsumoProduccion =>
      this == TipoItem.alimento ||
      this == TipoItem.medicamento ||
      this == TipoItem.vacuna;

  /// Verifica si tiene fecha de vencimiento típicamente.
  bool get tieneVencimiento =>
      this == TipoItem.alimento ||
      this == TipoItem.medicamento ||
      this == TipoItem.vacuna;

  /// Nombre del tipo localizado.
  String get displayName {
    final locale = Formatters.currentLocale;
    return switch (this) {
      TipoItem.alimento => switch (locale) { 'es' => 'Alimento', 'pt' => 'Ração', _ => 'Feed' },
      TipoItem.medicamento => switch (locale) { 'es' => 'Medicamento', 'pt' => 'Medicamento', _ => 'Medicine' },
      TipoItem.vacuna => switch (locale) { 'es' => 'Vacuna', 'pt' => 'Vacina', _ => 'Vaccine' },
      TipoItem.equipo => switch (locale) { 'es' => 'Equipo', 'pt' => 'Equipamento', _ => 'Equipment' },
      TipoItem.insumo => switch (locale) { 'es' => 'Insumo', 'pt' => 'Insumo', _ => 'Supply' },
      TipoItem.limpieza => switch (locale) { 'es' => 'Limpieza', 'pt' => 'Limpeza', _ => 'Cleaning' },
      TipoItem.otro => switch (locale) { 'es' => 'Otro', 'pt' => 'Outro', _ => 'Other' },
    };
  }

  /// Descripción del tipo localizada.
  String get displayDescripcion {
    final locale = Formatters.currentLocale;
    return switch (this) {
      TipoItem.alimento =>
        switch (locale) { 'es' => 'Concentrados, granos y suplementos', 'pt' => 'Concentrados, grãos e suplementos', _ => 'Concentrates, grains and supplements' },
      TipoItem.medicamento =>
        switch (locale) { 'es' => 'Fármacos y productos sanitarios', 'pt' => 'Fármacos e produtos sanitários', _ => 'Pharmaceuticals and health products' },
      TipoItem.vacuna =>
        switch (locale) { 'es' => 'Vacunas y biológicos', 'pt' => 'Vacinas e biológicos', _ => 'Vaccines and biologicals' },
      TipoItem.equipo =>
        switch (locale) { 'es' => 'Herramientas y maquinaria', 'pt' => 'Ferramentas e maquinário', _ => 'Tools and machinery' },
      TipoItem.insumo =>
        switch (locale) { 'es' => 'Material de cama, empaques, etc.', 'pt' => 'Material de cama, embalagens, etc.', _ => 'Bedding material, packaging, etc.' },
      TipoItem.limpieza =>
        switch (locale) { 'es' => 'Desinfectantes y productos de aseo', 'pt' => 'Desinfetantes e produtos de limpeza', _ => 'Disinfectants and cleaning products' },
      TipoItem.otro => switch (locale) { 'es' => 'Items varios', 'pt' => 'Itens diversos', _ => 'Miscellaneous items' },
    };
  }

  /// Serialización a JSON.
  String toJson() => name;

  /// Deserialización desde JSON.
  static TipoItem fromJson(String json) {
    return TipoItem.values.firstWhere(
      (e) => e.name == json,
      orElse: () => TipoItem.otro,
    );
  }
}
