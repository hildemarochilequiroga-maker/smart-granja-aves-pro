library;

import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';

/// Value Object que representa los umbrales ambientales
///
/// Define los rangos aceptables para temperatura, humedad, etc.
class UmbralesAmbientales extends Equatable {
  const UmbralesAmbientales({
    required this.temperaturaMinima,
    required this.temperaturaMaxima,
    required this.humedadMinima,
    required this.humedadMaxima,
    this.amonicoMaximo,
    this.co2Maximo,
    this.iluminacionMinima,
    this.iluminacionMaxima,
  });

  /// Temperatura mínima aceptable en °C
  final double temperaturaMinima;

  /// Temperatura máxima aceptable en °C
  final double temperaturaMaxima;

  /// Humedad relativa mínima en %
  final double humedadMinima;

  /// Humedad relativa máxima en %
  final double humedadMaxima;

  /// Nivel máximo de amoníaco en ppm
  final double? amonicoMaximo;

  /// Nivel máximo de CO2 en ppm
  final double? co2Maximo;

  /// Iluminación mínima en lux
  final double? iluminacionMinima;

  /// Iluminación máxima en lux
  final double? iluminacionMaxima;

  /// Umbrales para pollos de engorde (adultos)
  factory UmbralesAmbientales.engordeAdulto() {
    return const UmbralesAmbientales(
      temperaturaMinima: 18.0,
      temperaturaMaxima: 24.0,
      humedadMinima: 50.0,
      humedadMaxima: 70.0,
      amonicoMaximo: 25.0,
      co2Maximo: 3000.0,
      iluminacionMinima: 5.0,
      iluminacionMaxima: 20.0,
    );
  }

  /// Umbrales para pollitos recién nacidos
  factory UmbralesAmbientales.pollitosRecienNacidos() {
    return const UmbralesAmbientales(
      temperaturaMinima: 32.0,
      temperaturaMaxima: 35.0,
      humedadMinima: 60.0,
      humedadMaxima: 70.0,
      amonicoMaximo: 10.0,
      co2Maximo: 2500.0,
      iluminacionMinima: 20.0,
      iluminacionMaxima: 40.0,
    );
  }

  /// Umbrales para gallinas ponedoras
  factory UmbralesAmbientales.ponedoras() {
    return const UmbralesAmbientales(
      temperaturaMinima: 18.0,
      temperaturaMaxima: 26.0,
      humedadMinima: 40.0,
      humedadMaxima: 70.0,
      amonicoMaximo: 20.0,
      co2Maximo: 2500.0,
      iluminacionMinima: 10.0,
      iluminacionMaxima: 30.0,
    );
  }

  /// Crea desde un mapa JSON
  factory UmbralesAmbientales.fromJson(Map<String, dynamic> json) {
    return UmbralesAmbientales(
      temperaturaMinima: (json['temperaturaMinima'] as num).toDouble(),
      temperaturaMaxima: (json['temperaturaMaxima'] as num).toDouble(),
      humedadMinima: (json['humedadMinima'] as num).toDouble(),
      humedadMaxima: (json['humedadMaxima'] as num).toDouble(),
      amonicoMaximo: json['amonicoMaximo'] != null
          ? (json['amonicoMaximo'] as num).toDouble()
          : null,
      co2Maximo: json['co2Maximo'] != null
          ? (json['co2Maximo'] as num).toDouble()
          : null,
      iluminacionMinima: json['iluminacionMinima'] != null
          ? (json['iluminacionMinima'] as num).toDouble()
          : null,
      iluminacionMaxima: json['iluminacionMaxima'] != null
          ? (json['iluminacionMaxima'] as num).toDouble()
          : null,
    );
  }

  /// Convierte a mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'temperaturaMinima': temperaturaMinima,
      'temperaturaMaxima': temperaturaMaxima,
      'humedadMinima': humedadMinima,
      'humedadMaxima': humedadMaxima,
      if (amonicoMaximo != null) 'amonicoMaximo': amonicoMaximo,
      if (co2Maximo != null) 'co2Maximo': co2Maximo,
      if (iluminacionMinima != null) 'iluminacionMinima': iluminacionMinima,
      if (iluminacionMaxima != null) 'iluminacionMaxima': iluminacionMaxima,
    };
  }

  /// Valida los umbrales
  String? validar() {
    if (temperaturaMinima >= temperaturaMaxima) {
      return ErrorMessages.get('UMBRAL_TEMP_MIN_MAYOR_MAX');
    }
    if (humedadMinima >= humedadMaxima) {
      return ErrorMessages.get('UMBRAL_HUM_MIN_MAYOR_MAX');
    }
    if (humedadMinima < 0 || humedadMaxima > 100) {
      return ErrorMessages.get('UMBRAL_HUM_RANGO');
    }
    if (amonicoMaximo != null && amonicoMaximo! < 0) {
      return ErrorMessages.get('UMBRAL_AMONIACO_NEGATIVO');
    }
    if (co2Maximo != null && co2Maximo! < 0) {
      return ErrorMessages.get('UMBRAL_CO2_NEGATIVO');
    }
    return null;
  }

  /// Verifica si los umbrales son válidos
  bool get esValido => validar() == null;

  /// Verifica si una temperatura está dentro del rango
  bool temperaturaEnRango(double temperatura) {
    return temperatura >= temperaturaMinima && temperatura <= temperaturaMaxima;
  }

  /// Verifica si una humedad está dentro del rango
  bool humedadEnRango(double humedad) {
    return humedad >= humedadMinima && humedad <= humedadMaxima;
  }

  /// Crea una copia con campos modificados
  UmbralesAmbientales copyWith({
    double? temperaturaMinima,
    double? temperaturaMaxima,
    double? humedadMinima,
    double? humedadMaxima,
    double? amonicoMaximo,
    double? co2Maximo,
    double? iluminacionMinima,
    double? iluminacionMaxima,
  }) {
    return UmbralesAmbientales(
      temperaturaMinima: temperaturaMinima ?? this.temperaturaMinima,
      temperaturaMaxima: temperaturaMaxima ?? this.temperaturaMaxima,
      humedadMinima: humedadMinima ?? this.humedadMinima,
      humedadMaxima: humedadMaxima ?? this.humedadMaxima,
      amonicoMaximo: amonicoMaximo ?? this.amonicoMaximo,
      co2Maximo: co2Maximo ?? this.co2Maximo,
      iluminacionMinima: iluminacionMinima ?? this.iluminacionMinima,
      iluminacionMaxima: iluminacionMaxima ?? this.iluminacionMaxima,
    );
  }

  @override
  List<Object?> get props => [
    temperaturaMinima,
    temperaturaMaxima,
    humedadMinima,
    humedadMaxima,
    amonicoMaximo,
    co2Maximo,
    iluminacionMinima,
    iluminacionMaxima,
  ];
}
