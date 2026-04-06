library;

import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';

/// Value Object que representa coordenadas geográficas
///
/// Inmutable y validado.
class Coordenadas extends Equatable {
  const Coordenadas({required this.latitud, required this.longitud});

  /// Latitud en grados decimales (-90 a 90)
  final double latitud;

  /// Longitud en grados decimales (-180 a 180)
  final double longitud;

  /// Crea desde un mapa JSON
  factory Coordenadas.fromJson(Map<String, dynamic> json) {
    return Coordenadas(
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
    );
  }

  /// Convierte a mapa JSON
  Map<String, dynamic> toJson() {
    return {'latitud': latitud, 'longitud': longitud};
  }

  /// Valida las coordenadas
  String? validar() {
    if (latitud < -90 || latitud > 90) {
      return ErrorMessages.get('COORD_LATITUD_RANGO');
    }
    if (longitud < -180 || longitud > 180) {
      return ErrorMessages.get('COORD_LONGITUD_RANGO');
    }
    return null;
  }

  /// Verifica si las coordenadas son válidas
  bool get esValida => validar() == null;

  @override
  List<Object?> get props => [latitud, longitud];

  @override
  String toString() => 'Coordenadas($latitud, $longitud)';
}
