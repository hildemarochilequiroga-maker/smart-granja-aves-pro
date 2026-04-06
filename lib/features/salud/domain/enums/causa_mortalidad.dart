/// Clasificación de las causas de mortalidad en aves.
library;

import 'package:smartgranjaavespro/core/errors/error_messages.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

enum CausaMortalidad {
  enfermedad('Enfermedad', 'Patología infecciosa', '#F44336', true),
  accidente('Accidente', 'Trauma o lesión', '#FF9800', false),
  desnutricion('Desnutrición', 'Falta de nutrientes', '#FFC107', false),
  estres('Estrés', 'Factores ambientales', '#9C27B0', false),
  metabolica('Metabólica', 'Problemas fisiológicos', '#673AB7', false),
  depredacion('Depredación', 'Ataques de animales', '#795548', false),
  sacrificio('Sacrificio', 'Muerte en faena', '#607D8B', false),
  vejez('Vejez', 'Fin de vida productiva', '#9E9E9E', false),
  desconocida('Desconocida', 'Causa no identificada', '#B0BEC5', false);

  const CausaMortalidad(
    this.displayName,
    this.descripcion,
    this.colorHex,
    this.esContagiosa,
  );

  final String displayName;
  final String descripcion;
  final String colorHex;
  final bool esContagiosa;

  /// Nombre localizado sin BuildContext (usa ErrorMessages).
  String get localizedDisplay {
    final key = 'CAUSA_MORT_${name.toUpperCase()}';
    return ErrorMessages.get(key);
  }

  String localizedName(S l) {
    switch (this) {
      case CausaMortalidad.enfermedad:
        return l.enumCausaMortEnfermedad;
      case CausaMortalidad.accidente:
        return l.enumCausaMortAccidente;
      case CausaMortalidad.desnutricion:
        return l.enumCausaMortDesnutricion;
      case CausaMortalidad.estres:
        return l.enumCausaMortEstres;
      case CausaMortalidad.metabolica:
        return l.enumCausaMortMetabolica;
      case CausaMortalidad.depredacion:
        return l.enumCausaMortDepredacion;
      case CausaMortalidad.sacrificio:
        return l.enumCausaMortSacrificio;
      case CausaMortalidad.vejez:
        return l.enumCausaMortVejez;
      case CausaMortalidad.desconocida:
        return l.enumCausaMortDesconocida;
    }
  }

  String localizedDescripcion(S l) {
    switch (this) {
      case CausaMortalidad.enfermedad:
        return l.enumCausaMortDescEnfermedad;
      case CausaMortalidad.accidente:
        return l.enumCausaMortDescAccidente;
      case CausaMortalidad.desnutricion:
        return l.enumCausaMortDescDesnutricion;
      case CausaMortalidad.estres:
        return l.enumCausaMortDescEstres;
      case CausaMortalidad.metabolica:
        return l.enumCausaMortDescMetabolica;
      case CausaMortalidad.depredacion:
        return l.enumCausaMortDescDepredacion;
      case CausaMortalidad.sacrificio:
        return l.enumCausaMortDescSacrificio;
      case CausaMortalidad.vejez:
        return l.enumCausaMortDescVejez;
      case CausaMortalidad.desconocida:
        return l.enumCausaMortDescDesconocida;
    }
  }

  String toJson() => name;

  static CausaMortalidad fromJson(String json) {
    return CausaMortalidad.values.firstWhere(
      (e) => e.name == json,
      orElse: () => throw ArgumentError(
        ErrorMessages.format('ENUM_INVALID_CAUSA_MORTALIDAD', {'value': json}),
      ),
    );
  }

  static CausaMortalidad? tryFromJson(String? json) {
    if (json == null) return null;
    try {
      return fromJson(json);
    } catch (_) {
      return null;
    }
  }

  bool get requiereIntervencionVeterinaria {
    return this == CausaMortalidad.enfermedad ||
        this == CausaMortalidad.metabolica;
  }

  bool get requiereAislamiento => esContagiosa;

  bool get esPrevenible {
    return this != CausaMortalidad.vejez && this != CausaMortalidad.metabolica;
  }

  bool get requiereReporteSanitario {
    return this == CausaMortalidad.enfermedad && esContagiosa;
  }

  int get nivelGravedad {
    switch (this) {
      case CausaMortalidad.enfermedad:
        return 10;
      case CausaMortalidad.metabolica:
        return 7;
      case CausaMortalidad.desnutricion:
        return 6;
      case CausaMortalidad.estres:
        return 5;
      case CausaMortalidad.depredacion:
        return 4;
      case CausaMortalidad.accidente:
        return 3;
      case CausaMortalidad.desconocida:
        return 5;
      case CausaMortalidad.sacrificio:
        return 1;
      case CausaMortalidad.vejez:
        return 1;
    }
  }

  List<String> get accionesRecomendadas {
    switch (this) {
      case CausaMortalidad.enfermedad:
        return [
          ErrorMessages.get('CAUSA_ACT_ENF_1'),
          ErrorMessages.get('CAUSA_ACT_ENF_2'),
          ErrorMessages.get('CAUSA_ACT_ENF_3'),
          ErrorMessages.get('CAUSA_ACT_ENF_4'),
          ErrorMessages.get('CAUSA_ACT_ENF_5'),
        ];
      case CausaMortalidad.accidente:
        return [
          ErrorMessages.get('CAUSA_ACT_ACC_1'),
          ErrorMessages.get('CAUSA_ACT_ACC_2'),
          ErrorMessages.get('CAUSA_ACT_ACC_3'),
          ErrorMessages.get('CAUSA_ACT_ACC_4'),
        ];
      case CausaMortalidad.desnutricion:
        return [
          ErrorMessages.get('CAUSA_ACT_DES_1'),
          ErrorMessages.get('CAUSA_ACT_DES_2'),
          ErrorMessages.get('CAUSA_ACT_DES_3'),
          ErrorMessages.get('CAUSA_ACT_DES_4'),
        ];
      case CausaMortalidad.estres:
        return [
          ErrorMessages.get('CAUSA_ACT_EST_1'),
          ErrorMessages.get('CAUSA_ACT_EST_2'),
          ErrorMessages.get('CAUSA_ACT_EST_3'),
        ];
      case CausaMortalidad.metabolica:
        return [
          ErrorMessages.get('CAUSA_ACT_MET_1'),
          ErrorMessages.get('CAUSA_ACT_MET_2'),
          ErrorMessages.get('CAUSA_ACT_MET_3'),
        ];
      case CausaMortalidad.depredacion:
        return [
          ErrorMessages.get('CAUSA_ACT_DEP_1'),
          ErrorMessages.get('CAUSA_ACT_DEP_2'),
          ErrorMessages.get('CAUSA_ACT_DEP_3'),
        ];
      case CausaMortalidad.sacrificio:
      case CausaMortalidad.vejez:
        return [ErrorMessages.get('CAUSA_ACT_NORMAL')];
      case CausaMortalidad.desconocida:
        return [
          ErrorMessages.get('CAUSA_ACT_DESC_1'),
          ErrorMessages.get('CAUSA_ACT_DESC_2'),
          ErrorMessages.get('CAUSA_ACT_DESC_3'),
        ];
    }
  }

  String get categoria {
    switch (this) {
      case CausaMortalidad.enfermedad:
        return ErrorMessages.get('CAUSA_CAT_SANITARIA');
      case CausaMortalidad.accidente:
      case CausaMortalidad.depredacion:
        return ErrorMessages.get('CAUSA_CAT_MANEJO');
      case CausaMortalidad.desnutricion:
        return ErrorMessages.get('CAUSA_CAT_NUTRICIONAL');
      case CausaMortalidad.estres:
        return ErrorMessages.get('CAUSA_CAT_AMBIENTAL');
      case CausaMortalidad.metabolica:
        return ErrorMessages.get('CAUSA_CAT_FISIOLOGICA');
      case CausaMortalidad.sacrificio:
      case CausaMortalidad.vejez:
        return ErrorMessages.get('CAUSA_CAT_NATURAL');
      case CausaMortalidad.desconocida:
        return ErrorMessages.get('CAUSA_CAT_SIN_CLASIFICAR');
    }
  }

  bool get debeGenerarAlerta => nivelGravedad >= 6;
}
