library;

import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';

/// Value Object que representa una dirección física
///
/// Inmutable y validado.
class Direccion extends Equatable {
  const Direccion({
    required this.calle,
    this.numero,
    this.ciudad,
    this.provincia,
    this.departamento,
    this.codigoPostal,
    this.pais = 'Perú',
    this.referencia,
  });

  /// Calle o avenida principal
  final String calle;

  /// Número de la dirección
  final String? numero;

  /// Ciudad o distrito
  final String? ciudad;

  /// Provincia
  final String? provincia;

  /// Departamento o región
  final String? departamento;

  /// Código postal
  final String? codigoPostal;

  /// País
  final String pais;

  /// Referencia adicional
  final String? referencia;

  /// Crea desde un mapa JSON
  factory Direccion.fromJson(Map<String, dynamic> json) {
    return Direccion(
      calle: json['calle'] as String? ?? '',
      numero: json['numero'] as String?,
      ciudad: json['ciudad'] as String?,
      provincia: json['provincia'] as String?,
      departamento: json['departamento'] as String?,
      codigoPostal: json['codigoPostal'] as String?,
      pais: json['pais'] as String? ?? 'Perú',
      referencia: json['referencia'] as String?,
    );
  }

  /// Convierte a mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'calle': calle,
      if (numero != null) 'numero': numero,
      if (ciudad != null) 'ciudad': ciudad,
      if (provincia != null) 'provincia': provincia,
      if (departamento != null) 'departamento': departamento,
      if (codigoPostal != null) 'codigoPostal': codigoPostal,
      'pais': pais,
      if (referencia != null) 'referencia': referencia,
    };
  }

  /// Valida la dirección
  String? validar() {
    if (calle.trim().isEmpty) {
      return ErrorMessages.get('DIR_CALLE_REQUIRED');
    }
    if (calle.length < 3) {
      return ErrorMessages.get('DIR_CALLE_MIN_LENGTH');
    }
    return null;
  }

  /// Verifica si la dirección es válida
  bool get esValida => validar() == null;

  /// Obtiene la dirección formateada en una línea
  String get direccionCorta {
    final partes = <String>[];
    partes.add(calle);
    if (numero != null && numero!.isNotEmpty) {
      partes.add('#$numero');
    }
    if (ciudad != null && ciudad!.isNotEmpty) {
      partes.add(ciudad!);
    }
    return partes.join(', ');
  }

  /// Obtiene la dirección completa formateada
  String get direccionCompleta {
    final partes = <String>[];
    partes.add(calle);
    if (numero != null && numero!.isNotEmpty) {
      partes.add('#$numero');
    }
    if (ciudad != null && ciudad!.isNotEmpty) {
      partes.add(ciudad!);
    }
    if (provincia != null && provincia!.isNotEmpty) {
      partes.add(provincia!);
    }
    if (departamento != null && departamento!.isNotEmpty) {
      partes.add(departamento!);
    }
    partes.add(pais);
    return partes.join(', ');
  }

  /// Crea una copia con campos modificados
  Direccion copyWith({
    String? calle,
    String? numero,
    String? ciudad,
    String? provincia,
    String? departamento,
    String? codigoPostal,
    String? pais,
    String? referencia,
  }) {
    return Direccion(
      calle: calle ?? this.calle,
      numero: numero ?? this.numero,
      ciudad: ciudad ?? this.ciudad,
      provincia: provincia ?? this.provincia,
      departamento: departamento ?? this.departamento,
      codigoPostal: codigoPostal ?? this.codigoPostal,
      pais: pais ?? this.pais,
      referencia: referencia ?? this.referencia,
    );
  }

  @override
  List<Object?> get props => [
    calle,
    numero,
    ciudad,
    provincia,
    departamento,
    codigoPostal,
    pais,
    referencia,
  ];

  @override
  String toString() => direccionCorta;
}
