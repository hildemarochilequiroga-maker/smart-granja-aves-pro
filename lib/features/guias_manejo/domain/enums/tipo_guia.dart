/// Tipo de guía técnica disponible.
enum TipoGuia {
  luz,
  alimentacion,
  peso,
  agua;

  /// Ícono representativo.
  String get icono => switch (this) {
    TipoGuia.luz => '💡',
    TipoGuia.alimentacion => '🌾',
    TipoGuia.peso => '⚖️',
    TipoGuia.agua => '💧',
  };
}
