/// Categorías de tareas en la guía diaria.
enum CategoriaTarea {
  alimentacion,
  agua,
  luz,
  temperatura,
  humedad,
  pesaje,
  vacunacion,
  postura,
  bioseguridad,
  equipos,
  manejoGeneral;

  String get icono => switch (this) {
    CategoriaTarea.alimentacion => '🌾',
    CategoriaTarea.agua => '💧',
    CategoriaTarea.luz => '💡',
    CategoriaTarea.temperatura => '🌡️',
    CategoriaTarea.humedad => '💨',
    CategoriaTarea.pesaje => '⚖️',
    CategoriaTarea.vacunacion => '💉',
    CategoriaTarea.postura => '🥚',
    CategoriaTarea.bioseguridad => '🛡️',
    CategoriaTarea.equipos => '🔧',
    CategoriaTarea.manejoGeneral => '📋',
  };
}
