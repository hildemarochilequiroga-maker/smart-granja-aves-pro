/// Entidad que representa un reporte generado.
library;

import 'package:equatable/equatable.dart';
import '../enums/enums.dart';

/// Entidad que representa un reporte generado o a generar.
class Reporte extends Equatable {
  const Reporte({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.granjaId,
    required this.fechaInicio,
    required this.fechaFin,
    required this.fechaGeneracion,
    this.loteId,
    this.granjaNombre,
    this.loteNombre,
    this.archivoUrl,
    this.tamanoBytes,
    this.generadoPor,
    this.observaciones,
  });

  /// Identificador único del reporte.
  final String id;

  /// Tipo de reporte.
  final TipoReporte tipo;

  /// Título del reporte.
  final String titulo;

  /// ID de la granja asociada.
  final String granjaId;

  /// Nombre de la granja (para mostrar).
  final String? granjaNombre;

  /// ID del lote asociado (opcional).
  final String? loteId;

  /// Nombre del lote (para mostrar).
  final String? loteNombre;

  /// Fecha de inicio del período del reporte.
  final DateTime fechaInicio;

  /// Fecha fin del período del reporte.
  final DateTime fechaFin;

  /// Fecha en que se generó el reporte.
  final DateTime fechaGeneracion;

  /// URL del archivo generado (si existe).
  final String? archivoUrl;

  /// Tamaño del archivo en bytes.
  final int? tamanoBytes;

  /// Usuario que generó el reporte.
  final String? generadoPor;

  /// Observaciones adicionales.
  final String? observaciones;

  /// Nombre del período formateado.
  String get periodoFormateado {
    final inicio =
        '${fechaInicio.day}/${fechaInicio.month}/${fechaInicio.year}';
    final fin = '${fechaFin.day}/${fechaFin.month}/${fechaFin.year}';
    return '$inicio - $fin';
  }

  /// Tamaño formateado para mostrar.
  String get tamanoFormateado {
    if (tamanoBytes == null) return '';
    if (tamanoBytes! < 1024) return '$tamanoBytes B';
    if (tamanoBytes! < 1024 * 1024) {
      return '${(tamanoBytes! / 1024).toStringAsFixed(1)} KB';
    }
    return '${(tamanoBytes! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  List<Object?> get props => [
    id,
    tipo,
    titulo,
    granjaId,
    granjaNombre,
    loteId,
    loteNombre,
    fechaInicio,
    fechaFin,
    fechaGeneracion,
    archivoUrl,
    tamanoBytes,
    generadoPor,
    observaciones,
  ];

  /// Copia el reporte con nuevos valores.
  Reporte copyWith({
    String? id,
    TipoReporte? tipo,
    String? titulo,
    String? granjaId,
    String? granjaNombre,
    String? loteId,
    String? loteNombre,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    DateTime? fechaGeneracion,
    String? archivoUrl,
    int? tamanoBytes,
    String? generadoPor,
    String? observaciones,
  }) {
    return Reporte(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      granjaId: granjaId ?? this.granjaId,
      granjaNombre: granjaNombre ?? this.granjaNombre,
      loteId: loteId ?? this.loteId,
      loteNombre: loteNombre ?? this.loteNombre,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      fechaGeneracion: fechaGeneracion ?? this.fechaGeneracion,
      archivoUrl: archivoUrl ?? this.archivoUrl,
      tamanoBytes: tamanoBytes ?? this.tamanoBytes,
      generadoPor: generadoPor ?? this.generadoPor,
      observaciones: observaciones ?? this.observaciones,
    );
  }
}
