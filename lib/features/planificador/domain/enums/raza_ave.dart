/// Razas de aves para el planificador avícola.
///
/// Datos técnicos basados en manuales oficiales de cada genética
/// y adaptados al mercado peruano.
library;

/// Razas de pollo de engorde disponibles en Perú.
enum RazaEngorde {
  cobb500('Cobb 500'),
  ross308('Ross 308');

  const RazaEngorde(this.nombre);

  final String nombre;
}

/// Razas de gallina ponedora disponibles en Perú.
enum RazaPonedora {
  hyLineBrown('Hy-Line Brown'),
  lohmannBrown('Lohmann Brown'),
  hyLineW36('Hy-Line W-36'),
  isaBrown('ISA Brown'),
  novogenBrown('Novogen Brown');

  const RazaPonedora(this.nombre);

  final String nombre;
}
