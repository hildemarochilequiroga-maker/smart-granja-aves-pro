/// Clasificación de antimicrobianos según OMS/OIE.
library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Categoría de importancia de antimicrobianos según OMS.
enum CategoriaAntimicrobiano {
  criticamente('Críticamente Importante', 'HP-CIA', '#F44336', true),
  altamente('Altamente Importante', 'HIA', '#FF9800', true),
  importante('Importante', 'IA', '#FFC107', false),
  noClasificado('No Clasificado', 'NC', '#9E9E9E', false);

  const CategoriaAntimicrobiano(
    this.nombre,
    this.codigo,
    this.colorHex,
    this.requiereJustificacion,
  );

  final String nombre;
  final String codigo;
  final String colorHex;
  final bool requiereJustificacion;

  String get displayName {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return nombre;
    switch (this) {
      case CategoriaAntimicrobiano.criticamente:
        return locale == 'pt' ? 'Criticamente Importante' : 'Critically Important';
      case CategoriaAntimicrobiano.altamente:
        return locale == 'pt' ? 'Altamente Importante' : 'Highly Important';
      case CategoriaAntimicrobiano.importante:
        return locale == 'pt' ? 'Importante' : 'Important';
      case CategoriaAntimicrobiano.noClasificado:
        return locale == 'pt' ? 'Não Classificado' : 'Unclassified';
    }
  }

  String toJson() => name;

  static CategoriaAntimicrobiano fromJson(String json) {
    return CategoriaAntimicrobiano.values.firstWhere(
      (e) => e.name == json,
      orElse: () => CategoriaAntimicrobiano.noClasificado,
    );
  }
}

/// Familias de antimicrobianos comunes en avicultura.
enum FamiliaAntimicrobiano {
  // HP-CIA (Críticamente importantes)
  fluoroquinolonas('Fluoroquinolonas', CategoriaAntimicrobiano.criticamente),
  cefalosporinas3y4(
    'Cefalosporinas 3a/4a gen',
    CategoriaAntimicrobiano.criticamente,
  ),
  macrolidos('Macrólidos', CategoriaAntimicrobiano.criticamente),
  polimixinas('Polimixinas (Colistina)', CategoriaAntimicrobiano.criticamente),

  // HIA (Altamente importantes)
  aminoglucosidos('Aminoglucósidos', CategoriaAntimicrobiano.altamente),
  penicilinas('Penicilinas', CategoriaAntimicrobiano.altamente),
  tetraciclinas('Tetraciclinas', CategoriaAntimicrobiano.altamente),
  sulfonamidas('Sulfonamidas', CategoriaAntimicrobiano.altamente),

  // IA (Importantes)
  lincosamidas('Lincosamidas', CategoriaAntimicrobiano.importante),
  pleuromutilinas('Pleuromutilinas', CategoriaAntimicrobiano.importante),
  bacitracina('Bacitracina', CategoriaAntimicrobiano.importante),
  ionoforos('Ionóforos', CategoriaAntimicrobiano.importante);

  const FamiliaAntimicrobiano(this.nombre, this.categoria);

  final String nombre;
  final CategoriaAntimicrobiano categoria;

  String get displayName {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return nombre;
    switch (this) {
      case FamiliaAntimicrobiano.fluoroquinolonas:
        return locale == 'pt' ? 'Fluoroquinolonas' : 'Fluoroquinolones';
      case FamiliaAntimicrobiano.cefalosporinas3y4:
        return locale == 'pt' ? 'Cefalosporinas 3ª/4ª geração' : '3rd/4th Gen Cephalosporins';
      case FamiliaAntimicrobiano.macrolidos:
        return locale == 'pt' ? 'Macrolídeos' : 'Macrolides';
      case FamiliaAntimicrobiano.polimixinas:
        return locale == 'pt' ? 'Polimixinas (Colistina)' : 'Polymyxins (Colistin)';
      case FamiliaAntimicrobiano.aminoglucosidos:
        return locale == 'pt' ? 'Aminoglicosídeos' : 'Aminoglycosides';
      case FamiliaAntimicrobiano.penicilinas:
        return locale == 'pt' ? 'Penicilinas' : 'Penicillins';
      case FamiliaAntimicrobiano.tetraciclinas:
        return locale == 'pt' ? 'Tetraciclinas' : 'Tetracyclines';
      case FamiliaAntimicrobiano.sulfonamidas:
        return locale == 'pt' ? 'Sulfonamidas' : 'Sulfonamides';
      case FamiliaAntimicrobiano.lincosamidas:
        return locale == 'pt' ? 'Lincosamidas' : 'Lincosamides';
      case FamiliaAntimicrobiano.pleuromutilinas:
        return locale == 'pt' ? 'Pleuromutilinas' : 'Pleuromutilins';
      case FamiliaAntimicrobiano.bacitracina:
        return locale == 'pt' ? 'Bacitracina' : 'Bacitracin';
      case FamiliaAntimicrobiano.ionoforos:
        return locale == 'pt' ? 'Ionóforos' : 'Ionophores';
    }
  }

  String toJson() => name;

  static FamiliaAntimicrobiano fromJson(String json) {
    return FamiliaAntimicrobiano.values.firstWhere(
      (e) => e.name == json,
      orElse: () => FamiliaAntimicrobiano.tetraciclinas,
    );
  }
}

/// Motivos de uso de antimicrobianos.
enum MotivoUsoAntimicrobiano {
  tratamiento('Tratamiento', 'Tratamiento de enfermedad diagnosticada'),
  metafilaxis('Metafilaxis', 'Tratamiento preventivo de grupo en riesgo'),
  profilaxis('Profilaxis', 'Prevención en animales sanos'),
  promotorCrecimiento(
    'Promotor de Crecimiento',
    'Uso prohibido en muchos países',
  );

  const MotivoUsoAntimicrobiano(this.nombre, this.descripcion);

  final String nombre;
  final String descripcion;

  String get displayName {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return nombre;
    switch (this) {
      case MotivoUsoAntimicrobiano.tratamiento:
        return locale == 'pt' ? 'Tratamento' : 'Treatment';
      case MotivoUsoAntimicrobiano.metafilaxis:
        return locale == 'pt' ? 'Metafilaxia' : 'Metaphylaxis';
      case MotivoUsoAntimicrobiano.profilaxis:
        return locale == 'pt' ? 'Profilaxia' : 'Prophylaxis';
      case MotivoUsoAntimicrobiano.promotorCrecimiento:
        return locale == 'pt' ? 'Promotor de Crescimento' : 'Growth Promoter';
    }
  }

  String get displayDescripcion {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return descripcion;
    switch (this) {
      case MotivoUsoAntimicrobiano.tratamiento:
        return locale == 'pt' ? 'Tratamento de doença diagnosticada' : 'Treatment of diagnosed disease';
      case MotivoUsoAntimicrobiano.metafilaxis:
        return locale == 'pt' ? 'Tratamento preventivo de grupo em risco' : 'Preventive treatment of at-risk group';
      case MotivoUsoAntimicrobiano.profilaxis:
        return locale == 'pt' ? 'Prevenção em animais saudáveis' : 'Prevention in healthy animals';
      case MotivoUsoAntimicrobiano.promotorCrecimiento:
        return locale == 'pt' ? 'Uso proibido em muitos países' : 'Prohibited use in many countries';
    }
  }

  /// Si el uso está restringido o prohibido.
  bool get esRestringido =>
      this == MotivoUsoAntimicrobiano.promotorCrecimiento ||
      this == MotivoUsoAntimicrobiano.profilaxis;

  String toJson() => name;

  static MotivoUsoAntimicrobiano fromJson(String json) {
    return MotivoUsoAntimicrobiano.values.firstWhere(
      (e) => e.name == json,
      orElse: () => MotivoUsoAntimicrobiano.tratamiento,
    );
  }
}

/// Alias para compatibilidad con otras partes del código.
/// CategoriaOmsAntimicrobiano es equivalente a CategoriaAntimicrobiano.
typedef CategoriaOmsAntimicrobiano = CategoriaAntimicrobiano;
