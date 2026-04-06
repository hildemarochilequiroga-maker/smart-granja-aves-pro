import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';

/// Value Object que representa una dirección física.
class Direccion extends Equatable {
  const Direccion({
    required this.calle,
    required this.ciudad,
    required this.departamento,
    this.numero,
    this.distrito,
    this.referencia,
    this.codigoPostal,
  });

  final String calle;
  final String? numero;
  final String? distrito;
  final String ciudad;
  final String departamento;
  final String? codigoPostal;
  final String? referencia;

  @override
  List<Object?> get props => [
    calle,
    numero,
    distrito,
    ciudad,
    departamento,
    codigoPostal,
    referencia,
  ];

  /// Crea una copia con los campos modificados
  Direccion copyWith({
    String? calle,
    String? numero,
    String? distrito,
    String? ciudad,
    String? departamento,
    String? codigoPostal,
    String? referencia,
  }) {
    return Direccion(
      calle: calle ?? this.calle,
      numero: numero ?? this.numero,
      distrito: distrito ?? this.distrito,
      ciudad: ciudad ?? this.ciudad,
      departamento: departamento ?? this.departamento,
      codigoPostal: codigoPostal ?? this.codigoPostal,
      referencia: referencia ?? this.referencia,
    );
  }

  /// Convierte a un String legible
  String get direccionCompleta {
    final partes = <String>[];

    partes.add(calle);
    if (numero != null) partes.add(numero!);
    if (distrito != null) partes.add(distrito!);
    partes.add(ciudad);
    partes.add(departamento);

    return partes.join(', ');
  }

  /// Convierte a Map para serialización
  Map<String, dynamic> toJson() {
    return {
      'calle': calle,
      'numero': numero,
      'distrito': distrito,
      'ciudad': ciudad,
      'departamento': departamento,
      'codigoPostal': codigoPostal,
      'referencia': referencia,
    };
  }

  /// Crea desde Map
  factory Direccion.fromJson(Map<String, dynamic> map) {
    return Direccion(
      calle: map['calle'] as String,
      numero: map['numero'] as String?,
      distrito: map['distrito'] as String?,
      ciudad: map['ciudad'] as String,
      departamento: map['departamento'] as String,
      codigoPostal: map['codigoPostal'] as String?,
      referencia: map['referencia'] as String?,
    );
  }

  /// Dirección vacía por defecto.
  factory Direccion.empty() {
    return const Direccion(calle: '', ciudad: '', departamento: '');
  }

  /// Verifica si la dirección está completa
  bool get esCompleta {
    return calle.isNotEmpty && ciudad.isNotEmpty && departamento.isNotEmpty;
  }

  /// Valida la dirección
  String? validar() {
    if (calle.isEmpty) {
      return ErrorMessages.get('DIR_CALLE_REQUIRED');
    }
    if (ciudad.isEmpty) {
      return ErrorMessages.get('DIR_CIUDAD_REQUIRED');
    }
    if (departamento.isEmpty) {
      return ErrorMessages.get('DIR_DEPARTAMENTO_REQUIRED');
    }
    return null;
  }
}
