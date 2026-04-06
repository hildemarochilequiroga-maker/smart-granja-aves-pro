/// Modelo para información de paso en formularios multi-step
library;

import 'package:flutter/material.dart';

/// Representa la información de un paso en un formulario multi-step
class FormStepInfo {
  const FormStepInfo({
    required this.label,
    this.description = '',
    this.icon = Icons.circle_outlined,
  });

  /// Etiqueta corta del paso
  final String label;

  /// Descripción detallada del paso
  final String description;

  /// Icono representativo del paso
  final IconData icon;
}
