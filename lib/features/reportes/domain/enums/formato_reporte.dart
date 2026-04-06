/// Formatos de exportación disponibles para reportes.
library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Enum que define los formatos de exportación disponibles.
enum FormatoReporte {
  /// Documento PDF.
  pdf('PDF', 'application/pdf', '.pdf'),

  /// Vista previa en pantalla.
  vista('Vista previa', '', '');

  const FormatoReporte(this.nombre, this.mimeType, this.extension);

  /// Nombre para mostrar.
  final String nombre;

  /// Tipo MIME del formato.
  final String mimeType;

  /// Extensión del archivo.
  final String extension;

  /// Nombre localizado del formato
  String get displayName {
    final locale = Formatters.currentLocale;
    return switch (this) {
      FormatoReporte.pdf => switch (locale) { 'es' => 'PDF', 'pt' => 'PDF', _ => 'PDF' },
      FormatoReporte.vista => switch (locale) { 'es' => 'Vista previa', 'pt' => 'Pré-visualização', _ => 'Preview' },
    };
  }
}
