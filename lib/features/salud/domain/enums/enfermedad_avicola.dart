/// Catálogo de enfermedades avícolas comunes.
///
/// Basado en las guías de Cobb Genetics, Aviagen y mejores prácticas
/// de la industria avícola mundial.
library;

import 'package:smartgranjaavespro/core/errors/error_messages.dart';
import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Categorías de enfermedades avícolas.
enum CategoriaEnfermedad {
  viral('Viral', 'Enfermedades causadas por virus'),
  bacteriana('Bacteriana', 'Enfermedades causadas por bacterias'),
  parasitaria('Parasitaria', 'Enfermedades causadas por parásitos'),
  fungica('Fúngica', 'Enfermedades causadas por hongos'),
  nutricional('Nutricional', 'Deficiencias nutricionales'),
  metabolica('Metabólica', 'Trastornos metabólicos'),
  ambiental('Ambiental', 'Causadas por factores ambientales');

  const CategoriaEnfermedad(this.nombre, this.descripcion);

  final String nombre;
  final String descripcion;

  String get displayName {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return nombre;
    switch (this) {
      case CategoriaEnfermedad.viral:
        return 'Viral';
      case CategoriaEnfermedad.bacteriana:
        return locale == 'pt' ? 'Bacteriana' : 'Bacterial';
      case CategoriaEnfermedad.parasitaria:
        return locale == 'pt' ? 'Parasitária' : 'Parasitic';
      case CategoriaEnfermedad.fungica:
        return locale == 'pt' ? 'Fúngica' : 'Fungal';
      case CategoriaEnfermedad.nutricional:
        return locale == 'pt' ? 'Nutricional' : 'Nutritional';
      case CategoriaEnfermedad.metabolica:
        return locale == 'pt' ? 'Metabólica' : 'Metabolic';
      case CategoriaEnfermedad.ambiental:
        return locale == 'pt' ? 'Ambiental' : 'Environmental';
    }
  }

  String get displayDescripcion {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return descripcion;
    switch (this) {
      case CategoriaEnfermedad.viral:
        return locale == 'pt' ? 'Doenças causadas por vírus' : 'Diseases caused by viruses';
      case CategoriaEnfermedad.bacteriana:
        return locale == 'pt' ? 'Doenças causadas por bactérias' : 'Diseases caused by bacteria';
      case CategoriaEnfermedad.parasitaria:
        return locale == 'pt' ? 'Doenças causadas por parasitas' : 'Diseases caused by parasites';
      case CategoriaEnfermedad.fungica:
        return locale == 'pt' ? 'Doenças causadas por fungos' : 'Diseases caused by fungi';
      case CategoriaEnfermedad.nutricional:
        return locale == 'pt' ? 'Deficiências nutricionais' : 'Nutritional deficiencies';
      case CategoriaEnfermedad.metabolica:
        return locale == 'pt' ? 'Distúrbios metabólicos' : 'Metabolic disorders';
      case CategoriaEnfermedad.ambiental:
        return locale == 'pt' ? 'Causadas por fatores ambientais' : 'Caused by environmental factors';
    }
  }

  String toJson() => name;

  static CategoriaEnfermedad fromJson(String json) {
    return CategoriaEnfermedad.values.firstWhere(
      (e) => e.name == json,
      orElse: () => CategoriaEnfermedad.viral,
    );
  }
}

/// Nivel de gravedad de la enfermedad.
enum GravedadEnfermedad {
  leve(1, 'Leve', 'Bajo impacto en producción', '#4CAF50'),
  moderada(2, 'Moderada', 'Impacto medio en producción', '#FF9800'),
  grave(3, 'Grave', 'Alto impacto, requiere acción inmediata', '#F44336'),
  critica(4, 'Crítica', 'Emergencia sanitaria', '#9C27B0');

  const GravedadEnfermedad(
    this.nivel,
    this.nombre,
    this.descripcion,
    this.colorHex,
  );

  final int nivel;
  final String nombre;
  final String descripcion;
  final String colorHex;

  String get displayName {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return nombre;
    switch (this) {
      case GravedadEnfermedad.leve:
        return locale == 'pt' ? 'Leve' : 'Mild';
      case GravedadEnfermedad.moderada:
        return locale == 'pt' ? 'Moderada' : 'Moderate';
      case GravedadEnfermedad.grave:
        return locale == 'pt' ? 'Grave' : 'Severe';
      case GravedadEnfermedad.critica:
        return locale == 'pt' ? 'Crítica' : 'Critical';
    }
  }

  String get displayDescripcion {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return descripcion;
    switch (this) {
      case GravedadEnfermedad.leve:
        return locale == 'pt' ? 'Baixo impacto na produção' : 'Low production impact';
      case GravedadEnfermedad.moderada:
        return locale == 'pt' ? 'Impacto médio na produção' : 'Medium production impact';
      case GravedadEnfermedad.grave:
        return locale == 'pt' ? 'Alto impacto, requer ação imediata' : 'High impact, requires immediate action';
      case GravedadEnfermedad.critica:
        return locale == 'pt' ? 'Emergência sanitária' : 'Health emergency';
    }
  }

  String toJson() => name;

  static GravedadEnfermedad fromJson(String json) {
    return GravedadEnfermedad.values.firstWhere(
      (e) => e.name == json,
      orElse: () => GravedadEnfermedad.moderada,
    );
  }
}

/// Catálogo de enfermedades avícolas comunes.
enum EnfermedadAvicola {
  // ==================== ENFERMEDADES VIRALES ====================
  newcastle(
    'Enfermedad de Newcastle',
    CategoriaEnfermedad.viral,
    GravedadEnfermedad.critica,
    true,
    'Paramyxovirus',
    [
      'Problemas respiratorios',
      'Diarrea verdosa',
      'Tortícolis',
      'Parálisis',
      'Caída de postura',
      'Alta mortalidad',
    ],
    [
      'Vacunación preventiva',
      'Cuarentena estricta',
      'Sacrificio sanitario en casos severos',
    ],
    'Vacuna Newcastle (La Sota, B1)',
    true,
  ),

  gumboro(
    'Enfermedad de Gumboro (IBD)',
    CategoriaEnfermedad.viral,
    GravedadEnfermedad.grave,
    true,
    'Birnavirus',
    [
      'Depresión',
      'Diarrea acuosa blanquecina',
      'Plumas erizadas',
      'Inflamación de la bolsa de Fabricio',
      'Inmunosupresión',
    ],
    ['Vacunación según programa', 'Bioseguridad estricta', 'Control de estrés'],
    'Vacuna Gumboro (intermedia, intermedia plus)',
    true,
  ),

  marek(
    'Enfermedad de Marek',
    CategoriaEnfermedad.viral,
    GravedadEnfermedad.grave,
    true,
    'Herpesvirus',
    [
      'Parálisis de patas y alas',
      'Tumores en órganos',
      'Iris gris (ojo gris)',
      'Pérdida de peso',
      'Muerte súbita',
    ],
    [
      'Vacunación in-ovo o al día de edad',
      'No hay tratamiento',
      'Eliminación de aves afectadas',
    ],
    'Vacuna Marek (HVT, Rispens)',
    true,
  ),

  bronquitisInfecciosa(
    'Bronquitis Infecciosa (IB)',
    CategoriaEnfermedad.viral,
    GravedadEnfermedad.grave,
    true,
    'Coronavirus',
    [
      'Estornudos',
      'Estertores traqueales',
      'Secreción nasal',
      'Caída de postura',
      'Huevos deformes',
      'Problemas renales',
    ],
    ['Vacunación múltiple', 'Ventilación adecuada', 'Control de amoníaco'],
    'Vacuna IB (H120, Ma5, 4/91)',
    true,
  ),

  influenzaAviar(
    'Influenza Aviar (HPAI/LPAI)',
    CategoriaEnfermedad.viral,
    GravedadEnfermedad.critica,
    true,
    'Orthomyxovirus',
    [
      'Muerte súbita',
      'Edema facial',
      'Cianosis en cresta y barbillas',
      'Hemorragias en patas',
      'Caída drástica de postura',
      'Síntomas nerviosos',
    ],
    [
      'Notificación obligatoria',
      'Sacrificio sanitario',
      'Cuarentena de zona',
      'Bioseguridad máxima',
    ],
    'Vacuna AI (según regulación local)',
    true,
  ),

  laringotraqueitis(
    'Laringotraqueitis Infecciosa (ILT)',
    CategoriaEnfermedad.viral,
    GravedadEnfermedad.grave,
    true,
    'Herpesvirus',
    [
      'Disnea severa',
      'Estiramiento de cuello para respirar',
      'Sangre en la tráquea',
      'Tos con sangre',
      'Alta mortalidad por asfixia',
    ],
    [
      'Vacunación preventiva',
      'Aislamiento de aves afectadas',
      'Desinfección rigurosa',
    ],
    'Vacuna ILT (CEO, TCO)',
    true,
  ),

  viruelaAviar(
    'Viruela Aviar',
    CategoriaEnfermedad.viral,
    GravedadEnfermedad.moderada,
    true,
    'Poxvirus',
    [
      'Nódulos en cresta y barbillas',
      'Lesiones en boca (forma diftérica)',
      'Costras en piel',
      'Dificultad para comer',
    ],
    [
      'Vacunación preventiva',
      'Control de mosquitos',
      'Tratamiento de lesiones con antisépticos',
    ],
    'Vacuna Viruela Aviar',
    true,
  ),

  anemiInfecciosa(
    'Anemia Infecciosa Aviar (CAV)',
    CategoriaEnfermedad.viral,
    GravedadEnfermedad.moderada,
    true,
    'Circovirus',
    [
      'Palidez',
      'Anemia',
      'Hemorragias musculares',
      'Inmunosupresión',
      'Dermatitis gangrenosa',
    ],
    [
      'Vacunación de reproductoras',
      'Bioseguridad',
      'Control de inmunosupresores',
    ],
    'Vacuna CAV',
    true,
  ),

  // ==================== ENFERMEDADES BACTERIANAS ====================
  colibacilosis(
    'Colibacilosis (E. coli)',
    CategoriaEnfermedad.bacteriana,
    GravedadEnfermedad.grave,
    false,
    'Escherichia coli',
    [
      'Septicemia',
      'Perihepatitis',
      'Pericarditis',
      'Aerosaculitis',
      'Onfalitis en pollitos',
      'Celulitis',
    ],
    [
      'Antibióticos según antibiograma',
      'Mejora de bioseguridad',
      'Control de calidad del agua',
      'Reducción de estrés',
    ],
    null,
    false,
  ),

  salmonelosis(
    'Salmonelosis',
    CategoriaEnfermedad.bacteriana,
    GravedadEnfermedad.grave,
    true,
    'Salmonella spp.',
    [
      'Diarrea',
      'Onfalitis',
      'Septicemia en pollitos',
      'Portadores asintomáticos',
      'Caída de postura',
    ],
    [
      'Programa de control obligatorio',
      'Vacunación',
      'Bioseguridad estricta',
      'Monitoreo serológico',
    ],
    'Vacuna Salmonella (viva/inactivada)',
    true,
  ),

  mycoplasmosis(
    'Micoplasmosis (MG/MS)',
    CategoriaEnfermedad.bacteriana,
    GravedadEnfermedad.moderada,
    true,
    'Mycoplasma gallisepticum/synoviae',
    [
      'Estornudos',
      'Secreción nasal',
      'Estertores',
      'Inflamación de senos nasales',
      'Sinovitis (MS)',
      'Caída de producción',
    ],
    [
      'Antibióticos (tilosina, enrofloxacina)',
      'Vacunación preventiva',
      'Lotes libres de mycoplasma',
    ],
    'Vacuna MG/MS',
    true,
  ),

  coleraAviar(
    'Cólera Aviar',
    CategoriaEnfermedad.bacteriana,
    GravedadEnfermedad.grave,
    true,
    'Pasteurella multocida',
    [
      'Muerte súbita',
      'Fiebre alta',
      'Diarrea verdosa',
      'Cianosis en cresta',
      'Artritis',
      'Tortícolis',
    ],
    [
      'Antibióticos (sulfas, tetraciclinas)',
      'Vacunación en zonas endémicas',
      'Eliminación de aves crónicas',
    ],
    'Vacuna Cólera Aviar (bacterina)',
    true,
  ),

  coriza(
    'Coriza Infecciosa',
    CategoriaEnfermedad.bacteriana,
    GravedadEnfermedad.moderada,
    true,
    'Avibacterium paragallinarum',
    [
      'Inflamación facial',
      'Secreción nasal fétida',
      'Conjuntivitis',
      'Estornudos',
      'Mal olor característico',
    ],
    [
      'Antibióticos (sulfas, eritromicina)',
      'Vacunación preventiva',
      'Eliminación de portadores',
    ],
    'Vacuna Coriza Infecciosa',
    true,
  ),

  clostridiosisNecrotica(
    'Enteritis Necrótica',
    CategoriaEnfermedad.bacteriana,
    GravedadEnfermedad.grave,
    false,
    'Clostridium perfringens',
    [
      'Muerte súbita',
      'Diarrea oscura',
      'Plumas erizadas',
      'Depresión',
      'Lesiones necróticas en intestino',
    ],
    [
      'Antibióticos (bacitracina, lincomicina)',
      'Control de coccidiosis',
      'Manejo de cama',
      'Aditivos alternativos',
    ],
    null,
    false,
  ),

  // ==================== ENFERMEDADES PARASITARIAS ====================
  coccidiosis(
    'Coccidiosis',
    CategoriaEnfermedad.parasitaria,
    GravedadEnfermedad.grave,
    false,
    'Eimeria spp.',
    [
      'Diarrea sanguinolenta',
      'Plumas erizadas',
      'Depresión',
      'Pérdida de peso',
      'Deshidratación',
      'Alta mortalidad',
    ],
    [
      'Anticoccidiales en alimento',
      'Vacunas vivas',
      'Manejo de cama seca',
      'Rotación de principios activos',
    ],
    'Vacuna Coccidiosis',
    true,
  ),

  ascaridiasis(
    'Ascaridiasis (Lombrices)',
    CategoriaEnfermedad.parasitaria,
    GravedadEnfermedad.leve,
    false,
    'Ascaridia galli',
    [
      'Pérdida de peso',
      'Palidez',
      'Diarrea',
      'Obstrucción intestinal (casos severos)',
    ],
    ['Desparasitación periódica', 'Rotación de potreros', 'Manejo higiénico'],
    null,
    false,
  ),

  // ==================== ENFERMEDADES FÚNGICAS ====================
  aspergilosis(
    'Aspergilosis',
    CategoriaEnfermedad.fungica,
    GravedadEnfermedad.grave,
    false,
    'Aspergillus fumigatus',
    [
      'Dificultad respiratoria',
      'Disnea',
      'Nódulos en pulmones',
      'Alta mortalidad en pollitos',
    ],
    [
      'Eliminar fuentes de hongo',
      'Desinfección de incubadoras',
      'No hay tratamiento efectivo',
    ],
    null,
    false,
  ),

  // ==================== TRASTORNOS METABÓLICOS ====================
  ascitis(
    'Síndrome Ascítico',
    CategoriaEnfermedad.metabolica,
    GravedadEnfermedad.moderada,
    false,
    null,
    [
      'Abdomen distendido',
      'Líquido abdominal',
      'Cianosis',
      'Dificultad respiratoria',
      'Muerte súbita',
    ],
    [
      'Restricción alimenticia temprana',
      'Control de velocidad de crecimiento',
      'Ventilación adecuada',
      'Altitud (factor de riesgo)',
    ],
    null,
    false,
  ),

  muerteSubita(
    'Síndrome de Muerte Súbita (SDS)',
    CategoriaEnfermedad.metabolica,
    GravedadEnfermedad.moderada,
    false,
    null,
    [
      'Muerte súbita de aves aparentemente sanas',
      'Aves en posición dorsal',
      'Más común en machos de rápido crecimiento',
    ],
    ['Restricción alimenticia', 'Control de crecimiento', 'Programas de luz'],
    null,
    false,
  ),

  // ==================== DEFICIENCIAS NUTRICIONALES ====================
  deficienciaVitaminaE(
    'Encefalomalacia (Def. Vit E)',
    CategoriaEnfermedad.nutricional,
    GravedadEnfermedad.moderada,
    false,
    null,
    ['Ataxia', 'Tortícolis', 'Convulsiones', 'Parálisis'],
    ['Suplementación de Vitamina E', 'Antioxidantes en alimento'],
    null,
    false,
  ),

  raquitismo(
    'Raquitismo (Def. Vit D/Ca/P)',
    CategoriaEnfermedad.nutricional,
    GravedadEnfermedad.moderada,
    false,
    null,
    ['Huesos blandos', 'Patas dobladas', 'Pico blando', 'Cáscaras débiles'],
    [
      'Corrección de niveles de Calcio, Fósforo y Vitamina D3',
      'Exposición a luz solar',
    ],
    null,
    false,
  );

  const EnfermedadAvicola(
    this.nombre,
    this.categoria,
    this.gravedad,
    this.esContagiosa,
    this.agenteEtiologico,
    this.sintomas,
    this.tratamientos,
    this.vacunaRecomendada,
    this.tieneVacuna,
  );

  /// Nombre común de la enfermedad.
  final String nombre;

  /// Categoría de la enfermedad.
  final CategoriaEnfermedad categoria;

  /// Nivel de gravedad.
  final GravedadEnfermedad gravedad;

  /// Si es contagiosa entre aves.
  final bool esContagiosa;

  /// Agente etiológico (virus, bacteria, etc.).
  final String? agenteEtiologico;

  /// Lista de síntomas comunes.
  final List<String> sintomas;

  /// Tratamientos recomendados.
  final List<String> tratamientos;

  /// Vacuna recomendada (si existe).
  final String? vacunaRecomendada;

  /// Si existe vacuna disponible.
  final bool tieneVacuna;

  String get displayName {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return nombre;
    switch (this) {
      case EnfermedadAvicola.newcastle:
        return locale == 'pt' ? 'Doença de Newcastle' : 'Newcastle Disease';
      case EnfermedadAvicola.gumboro:
        return locale == 'pt' ? 'Doença de Gumboro (DIB)' : 'Gumboro Disease (IBD)';
      case EnfermedadAvicola.marek:
        return locale == 'pt' ? 'Doença de Marek' : "Marek's Disease";
      case EnfermedadAvicola.bronquitisInfecciosa:
        return locale == 'pt' ? 'Bronquite Infecciosa (BI)' : 'Infectious Bronchitis (IB)';
      case EnfermedadAvicola.influenzaAviar:
        return locale == 'pt' ? 'Influenza Aviária (IAAP/IABP)' : 'Avian Influenza (HPAI/LPAI)';
      case EnfermedadAvicola.laringotraqueitis:
        return locale == 'pt' ? 'Laringotraqueíte Infecciosa (LTI)' : 'Infectious Laryngotracheitis (ILT)';
      case EnfermedadAvicola.viruelaAviar:
        return locale == 'pt' ? 'Varíola Aviária' : 'Fowl Pox';
      case EnfermedadAvicola.anemiInfecciosa:
        return locale == 'pt' ? 'Anemia Infecciosa das Galinhas (CAV)' : 'Chicken Infectious Anemia (CAV)';
      case EnfermedadAvicola.colibacilosis:
        return locale == 'pt' ? 'Colibacilose (E. coli)' : 'Colibacillosis (E. coli)';
      case EnfermedadAvicola.salmonelosis:
        return locale == 'pt' ? 'Salmonelose' : 'Salmonellosis';
      case EnfermedadAvicola.mycoplasmosis:
        return locale == 'pt' ? 'Micoplasmose (MG/MS)' : 'Mycoplasmosis (MG/MS)';
      case EnfermedadAvicola.coleraAviar:
        return locale == 'pt' ? 'Cólera Aviária' : 'Fowl Cholera';
      case EnfermedadAvicola.coriza:
        return locale == 'pt' ? 'Coriza Infecciosa' : 'Infectious Coryza';
      case EnfermedadAvicola.clostridiosisNecrotica:
        return locale == 'pt' ? 'Enterite por Clostridium' : 'Clostridium Enteritis';
      case EnfermedadAvicola.coccidiosis:
        return locale == 'pt' ? 'Coccidiose' : 'Coccidiosis';
      case EnfermedadAvicola.ascaridiasis:
        return locale == 'pt' ? 'Ascaridíase' : 'Ascaridiasis';
      case EnfermedadAvicola.aspergilosis:
        return locale == 'pt' ? 'Aspergilose' : 'Aspergillosis';
      case EnfermedadAvicola.ascitis:
        return locale == 'pt' ? 'Ascite (Síndrome Ascítica)' : 'Ascites (Ascitic Syndrome)';
      case EnfermedadAvicola.muerteSubita:
        return locale == 'pt' ? 'Síndrome de Morte Súbita' : 'Sudden Death Syndrome';
      case EnfermedadAvicola.deficienciaVitaminaE:
        return locale == 'pt' ? 'Deficiência de Vitamina E/Se' : 'Vitamin E/Se Deficiency';
      case EnfermedadAvicola.raquitismo:
        return locale == 'pt' ? 'Raquitismo (Def. Vit D/Ca/P)' : 'Rickets (Vit D/Ca/P Deficiency)';
    }
  }

  // ==================== ALIAS PARA COMPATIBILIDAD ====================

  /// Alias: Nombre común de la enfermedad.
  String get nombreComun => nombre;

  /// Nombre científico (usa el agente etiológico si existe).
  String get nombreCientifico => agenteEtiologico ?? nombre;

  /// Alias: Agente causal de la enfermedad.
  String get agenteCausal =>
      agenteEtiologico ?? ErrorMessages.get('ENF_NO_ESPECIFICADO');

  /// Localized symptoms list.
  List<String> get displaySintomas {
    final key = 'ENF_${name.toUpperCase()}_SINT';
    return ErrorMessages.get(key).split('|');
  }

  /// Localized treatments list.
  List<String> get displayTratamientos {
    final key = 'ENF_${name.toUpperCase()}_TRAT';
    return ErrorMessages.get(key).split('|');
  }

  /// Alias: Lista de síntomas principales.
  List<String> get sintomasPrincipales => displaySintomas;

  /// Alias: Severidad de la enfermedad (igual a gravedad).
  GravedadEnfermedad get severidad => gravedad;

  /// Alias: Lesiones post-mortem (derivadas de síntomas).
  List<String> get lesionesPostmortem => sintomas
      .where(
        (s) =>
            s.toLowerCase().contains('lesion') ||
            s.toLowerCase().contains('hemorrag') ||
            s.toLowerCase().contains('necro'),
      )
      .toList();

  /// Métodos de diagnóstico recomendados.
  String get diagnostico {
    switch (categoria) {
      case CategoriaEnfermedad.viral:
        return ErrorMessages.get('ENF_DIAG_VIRAL');
      case CategoriaEnfermedad.bacteriana:
        return ErrorMessages.get('ENF_DIAG_BACTERIANA');
      case CategoriaEnfermedad.parasitaria:
        return ErrorMessages.get('ENF_DIAG_PARASITARIA');
      case CategoriaEnfermedad.fungica:
        return ErrorMessages.get('ENF_DIAG_FUNGICA');
      case CategoriaEnfermedad.nutricional:
        return ErrorMessages.get('ENF_DIAG_NUTRICIONAL');
      case CategoriaEnfermedad.metabolica:
        return ErrorMessages.get('ENF_DIAG_METABOLICA');
      case CategoriaEnfermedad.ambiental:
        return ErrorMessages.get('ENF_DIAG_AMBIENTAL');
    }
  }

  /// Alias: Tratamiento recomendado (primero de la lista).
  String get tratamiento => displayTratamientos.isNotEmpty
      ? displayTratamientos.first
      : ErrorMessages.get('ENF_CONSULTAR_VETERINARIO');

  /// Alias: Medidas de prevención (combinación de tratamientos preventivos).
  List<String> get prevencion => tratamientos
      .where(
        (t) =>
            t.toLowerCase().contains('vacu') ||
            t.toLowerCase().contains('bioseg') ||
            t.toLowerCase().contains('preven') ||
            t.toLowerCase().contains('higiene'),
      )
      .toList();

  /// Alias: Si es de notificación obligatoria.
  bool get esNotificacionObligatoria => requiereNotificacion;

  /// Alias: Si es prevenible por vacunación.
  bool get esPreveniblePorVacuna => tieneVacuna;

  /// Modo de transmisión.
  String get transmision {
    if (!esContagiosa) return ErrorMessages.get('ENF_NO_CONTAGIOSA');
    switch (categoria) {
      case CategoriaEnfermedad.viral:
        return ErrorMessages.get('ENF_TRANS_VIRAL');
      case CategoriaEnfermedad.bacteriana:
        return ErrorMessages.get('ENF_TRANS_BACTERIANA');
      case CategoriaEnfermedad.parasitaria:
        return ErrorMessages.get('ENF_TRANS_PARASITARIA');
      case CategoriaEnfermedad.fungica:
        return ErrorMessages.get('ENF_TRANS_FUNGICA');
      default:
        return ErrorMessages.get('ENF_TRANS_DEFAULT');
    }
  }

  /// Vacuna recomendada como alias.
  String? get vacuna => vacunaRecomendada;

  /// Requiere notificación a autoridades.
  bool get requiereNotificacion =>
      this == EnfermedadAvicola.influenzaAviar ||
      this == EnfermedadAvicola.newcastle;

  /// Requiere cuarentena inmediata.
  bool get requiereCuarentena =>
      esContagiosa && gravedad.nivel >= GravedadEnfermedad.grave.nivel;

  String toJson() => name;

  static EnfermedadAvicola fromJson(String json) {
    return EnfermedadAvicola.values.firstWhere(
      (e) => e.name == json,
      orElse: () => EnfermedadAvicola.colibacilosis,
    );
  }

  static EnfermedadAvicola? tryFromJson(String? json) {
    if (json == null) return null;
    try {
      return fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Obtiene enfermedades por categoría.
  static List<EnfermedadAvicola> porCategoria(CategoriaEnfermedad categoria) {
    return EnfermedadAvicola.values
        .where((e) => e.categoria == categoria)
        .toList();
  }

  /// Obtiene enfermedades con vacuna disponible.
  static List<EnfermedadAvicola> conVacuna() {
    return EnfermedadAvicola.values.where((e) => e.tieneVacuna).toList();
  }

  /// Obtiene enfermedades de alta gravedad.
  static List<EnfermedadAvicola> criticas() {
    return EnfermedadAvicola.values
        .where((e) => e.gravedad.nivel >= GravedadEnfermedad.grave.nivel)
        .toList();
  }
}
