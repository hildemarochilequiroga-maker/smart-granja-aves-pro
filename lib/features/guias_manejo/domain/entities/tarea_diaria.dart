/// Tarea individual dentro de la guía diaria.
library;

import '../enums/categoria_tarea.dart';

class TareaDiaria {
  const TareaDiaria({
    required this.id,
    required this.categoria,
    required this.titulo,
    required this.descripcion,
    this.valorNumerico,
    this.unidad,
    this.completada = false,
  });

  /// Identificador único de la tarea.
  final String id;

  /// Categoría de la tarea.
  final CategoriaTarea categoria;

  /// Título corto de la tarea.
  final String titulo;

  /// Descripción con valores específicos.
  final String descripcion;

  /// Valor numérico principal (ej: gramos, ml, horas).
  final double? valorNumerico;

  /// Unidad del valor (ej: g/ave, ml/ave, horas).
  final String? unidad;

  /// Si la tarea fue marcada como completada.
  final bool completada;

  TareaDiaria copyWith({bool? completada}) {
    return TareaDiaria(
      id: id,
      categoria: categoria,
      titulo: titulo,
      descripcion: descripcion,
      valorNumerico: valorNumerico,
      unidad: unidad,
      completada: completada ?? this.completada,
    );
  }
}
