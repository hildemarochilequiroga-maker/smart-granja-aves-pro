/// Entidad que representa un registro de peso del lote.
library;

import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../enums/enums.dart';

/// Registro de peso de un lote.
class RegistroPeso extends Equatable {
  const RegistroPeso({
    required this.id,
    required this.loteId,
    required this.granjaId,
    required this.galponId,
    required this.fecha,
    required this.pesoPromedio,
    required this.cantidadAvesPesadas,
    required this.pesoTotal,
    required this.pesoMinimo,
    required this.pesoMaximo,
    required this.edadDias,
    required this.metodoPesaje,
    required this.usuarioRegistro,
    required this.nombreUsuario,
    required this.createdAt,
    this.observaciones,
    this.fotosUrls = const [],
    this.updatedAt,
  });

  /// ID único del registro.
  final String id;

  /// ID del lote al que pertenece.
  final String loteId;

  /// ID de la granja.
  final String granjaId;

  /// ID del galpón.
  final String galponId;

  /// Fecha del pesaje.
  final DateTime fecha;

  /// Peso promedio en gramos.
  final double pesoPromedio;

  /// Cantidad de aves pesadas.
  final int cantidadAvesPesadas;

  /// Peso total (suma).
  final double pesoTotal;

  /// Peso mínimo registrado.
  final double pesoMinimo;

  /// Peso máximo registrado.
  final double pesoMaximo;

  /// Edad del lote en días.
  final int edadDias;

  /// Método de pesaje utilizado.
  final MetodoPesaje metodoPesaje;

  /// Observaciones (opcional).
  final String? observaciones;

  /// URLs de fotos (máximo 3).
  final List<String> fotosUrls;

  /// UID del usuario que registró.
  final String usuarioRegistro;

  /// Nombre del usuario.
  final String nombreUsuario;

  /// Fecha de creación.
  final DateTime createdAt;

  /// Fecha de actualización.
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id,
    loteId,
    granjaId,
    galponId,
    fecha,
    pesoPromedio,
    cantidadAvesPesadas,
    pesoTotal,
    pesoMinimo,
    pesoMaximo,
    edadDias,
    metodoPesaje,
    observaciones,
    fotosUrls,
    usuarioRegistro,
    nombreUsuario,
    createdAt,
    updatedAt,
  ];

  // ==================== PROPIEDADES CALCULADAS ====================

  /// Ganancia Diaria Promedio (GDP) en gramos/día.
  double get gananciaDialiaPromedio {
    if (edadDias == 0) return 0;
    return pesoPromedio / edadDias;
  }

  /// Peso promedio en kilogramos.
  double get pesoPromedioKg => pesoPromedio / 1000;

  /// Coeficiente de variación (uniformidad).
  double get coeficienteVariacion {
    if (pesoPromedio == 0) return 0;
    final rango = pesoMaximo - pesoMinimo;
    return (rango / pesoPromedio) * 100;
  }

  /// Si tiene buena uniformidad (CV < 10%).
  bool get tieneBuenaUniformidad => coeficienteVariacion < 10;

  /// Proyección de peso a edad objetivo.
  double proyeccionPeso(int edadObjetivo) {
    if (edadDias == 0) {
      return pesoPromedio + (pesoPromedio * edadObjetivo / 42);
    }

    final diasRestantes = edadObjetivo - edadDias;
    if (diasRestantes <= 0) return pesoPromedio;

    return pesoPromedio + (gananciaDialiaPromedio * diasRestantes);
  }

  /// Si es un registro reciente (últimas 48 horas).
  bool get esReciente {
    final diferencia = DateTime.now().difference(createdAt);
    return diferencia.inHours <= 48;
  }

  // ==================== MÉTODOS ====================

  /// Crea una copia con campos modificados.
  RegistroPeso copyWith({
    String? id,
    String? loteId,
    String? granjaId,
    String? galponId,
    DateTime? fecha,
    double? pesoPromedio,
    int? cantidadAvesPesadas,
    double? pesoTotal,
    double? pesoMinimo,
    double? pesoMaximo,
    int? edadDias,
    MetodoPesaje? metodoPesaje,
    String? observaciones,
    List<String>? fotosUrls,
    String? usuarioRegistro,
    String? nombreUsuario,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RegistroPeso(
      id: id ?? this.id,
      loteId: loteId ?? this.loteId,
      granjaId: granjaId ?? this.granjaId,
      galponId: galponId ?? this.galponId,
      fecha: fecha ?? this.fecha,
      pesoPromedio: pesoPromedio ?? this.pesoPromedio,
      cantidadAvesPesadas: cantidadAvesPesadas ?? this.cantidadAvesPesadas,
      pesoTotal: pesoTotal ?? this.pesoTotal,
      pesoMinimo: pesoMinimo ?? this.pesoMinimo,
      pesoMaximo: pesoMaximo ?? this.pesoMaximo,
      edadDias: edadDias ?? this.edadDias,
      metodoPesaje: metodoPesaje ?? this.metodoPesaje,
      observaciones: observaciones ?? this.observaciones,
      fotosUrls: fotosUrls ?? this.fotosUrls,
      usuarioRegistro: usuarioRegistro ?? this.usuarioRegistro,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Validación del registro.
  String? validar() {
    if (loteId.isEmpty) return ErrorMessages.get('VAL_LOTE_ID_REQUIRED');
    if (granjaId.isEmpty) return ErrorMessages.get('VAL_GRANJA_ID_REQUIRED');
    if (galponId.isEmpty) return ErrorMessages.get('VAL_GALPON_ID_REQUIRED');
    if (pesoPromedio <= 0) {
      return ErrorMessages.get('REG_PESO_PROMEDIO_MAYOR_CERO');
    }
    if (cantidadAvesPesadas <= 0) {
      return ErrorMessages.get('REG_PESO_AVES_MINIMA');
    }
    if (pesoTotal <= 0) {
      return ErrorMessages.get('REG_PESO_TOTAL_MAYOR_CERO');
    }
    if (pesoMinimo <= 0) {
      return ErrorMessages.get('REG_PESO_MINIMO_MAYOR_CERO');
    }
    if (pesoMaximo < pesoMinimo) {
      return ErrorMessages.get('REG_PESO_MAX_MAYOR_MIN');
    }
    if (edadDias < 0) return ErrorMessages.get('VAL_EDAD_NEGATIVA');
    if (fotosUrls.length > 3) return ErrorMessages.get('REG_PESO_MAX_FOTOS');
    return null;
  }

  /// Si el registro es válido.
  bool get esValido => validar() == null;

  /// Factory para crear un nuevo registro de peso.
  factory RegistroPeso.nuevo({
    required String loteId,
    required String galponId,
    required double pesoPromedio,
    required MetodoPesaje metodoPesaje,
    required DateTime fecha,
    required int edadDias,
    int? cantidadAvesPesadas,
    double? pesoMinimo,
    double? pesoMaximo,
    double? uniformidad,
    String? observaciones,
    String granjaId = '',
    String usuarioRegistro = '',
    String nombreUsuario = '',
  }) {
    final cantAves = cantidadAvesPesadas ?? 1;
    final pesoPromedioG = pesoPromedio * 1000; // Convertir kg a gramos

    return RegistroPeso(
      id: '',
      loteId: loteId,
      granjaId: granjaId,
      galponId: galponId,
      fecha: fecha,
      pesoPromedio: pesoPromedioG,
      cantidadAvesPesadas: cantAves,
      pesoTotal: pesoPromedioG * cantAves,
      pesoMinimo: (pesoMinimo ?? pesoPromedio * 0.9) * 1000,
      pesoMaximo: (pesoMaximo ?? pesoPromedio * 1.1) * 1000,
      edadDias: edadDias,
      metodoPesaje: metodoPesaje,
      observaciones: observaciones,
      usuarioRegistro: usuarioRegistro,
      nombreUsuario: nombreUsuario,
      createdAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'RegistroPeso(id: $id, peso: ${pesoPromedio}g, '
        'aves: $cantidadAvesPesadas, fecha: $fecha)';
  }
}
