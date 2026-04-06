import 'package:equatable/equatable.dart';
import 'package:smartgranjaavespro/core/errors/error_messages.dart';

/// Entidad que representa una vacunación aplicada a un lote.
class Vacunacion extends Equatable {
  const Vacunacion({
    required this.id,
    required this.loteId,
    required this.granjaId,
    required this.nombreVacuna,
    required this.fechaProgramada,
    required this.programadoPor,
    this.fechaAplicacion,
    this.edadAplicacionSemanas,
    this.dosis,
    this.via,
    this.responsable,
    this.loteVacuna,
    this.laboratorio,
    this.proximaAplicacion,
    this.observaciones,
    this.aplicada = false,
    required this.fechaCreacion,
    DateTime? ultimaActualizacion,
  }) : ultimaActualizacion = ultimaActualizacion ?? fechaCreacion;

  final String id;
  final String loteId;
  final String granjaId;
  final String nombreVacuna;
  final DateTime fechaProgramada;
  final String programadoPor;
  final DateTime? fechaAplicacion;
  final int? edadAplicacionSemanas;
  final String? dosis;
  final String? via;
  final String? responsable;
  final String? loteVacuna;
  final String? laboratorio;
  final DateTime? proximaAplicacion;
  final String? observaciones;
  final bool aplicada;
  final DateTime fechaCreacion;
  final DateTime ultimaActualizacion;

  @override
  List<Object?> get props => [
    id,
    loteId,
    granjaId,
    nombreVacuna,
    fechaProgramada,
    programadoPor,
    fechaAplicacion,
    edadAplicacionSemanas,
    dosis,
    via,
    responsable,
    loteVacuna,
    laboratorio,
    proximaAplicacion,
    observaciones,
    aplicada,
    fechaCreacion,
    ultimaActualizacion,
  ];

  factory Vacunacion.programar({
    required String id,
    required String loteId,
    required String granjaId,
    required String nombreVacuna,
    required DateTime fechaProgramada,
    required String programadoPor,
  }) {
    if (nombreVacuna.trim().isEmpty) {
      throw VacunacionException(ErrorMessages.get('VACUNA_NOMBRE_VACIO'));
    }

    return Vacunacion(
      id: id,
      loteId: loteId,
      granjaId: granjaId,
      nombreVacuna: nombreVacuna,
      fechaProgramada: fechaProgramada,
      programadoPor: programadoPor,
      aplicada: false,
      fechaCreacion: DateTime.now(),
    );
  }

  bool get fueAplicada => aplicada;
  bool get estaPendiente => !fueAplicada;

  int? get diasHastaProgramada {
    if (fueAplicada) return null;
    return fechaProgramada.difference(DateTime.now()).inDays;
  }

  bool get estaVencida {
    if (fueAplicada) return false;
    final dias = diasHastaProgramada;
    return dias != null && dias < 0;
  }

  bool get esProxima {
    final dias = diasHastaProgramada;
    if (dias == null) return false;
    return dias >= 0 && dias <= 7;
  }

  Vacunacion marcarAplicada({
    required int edadSemanas,
    required String dosis,
    required String via,
    String? responsable,
    String? loteVacuna,
    String? observaciones,
  }) {
    if (fueAplicada) {
      throw VacunacionException(ErrorMessages.get('VACUNA_YA_APLICADA'));
    }

    return copyWith(
      fechaAplicacion: DateTime.now(),
      edadAplicacionSemanas: edadSemanas,
      dosis: dosis,
      via: via,
      responsable: responsable,
      loteVacuna: loteVacuna,
      observaciones: observaciones,
      aplicada: true,
      ultimaActualizacion: DateTime.now(),
    );
  }

  Vacunacion programarProxima(DateTime fecha) {
    return copyWith(
      proximaAplicacion: fecha,
      ultimaActualizacion: DateTime.now(),
    );
  }

  Vacunacion copyWith({
    String? id,
    String? loteId,
    String? granjaId,
    String? nombreVacuna,
    DateTime? fechaProgramada,
    String? programadoPor,
    DateTime? fechaAplicacion,
    int? edadAplicacionSemanas,
    String? dosis,
    String? via,
    String? responsable,
    String? loteVacuna,
    String? laboratorio,
    DateTime? proximaAplicacion,
    String? observaciones,
    bool? aplicada,
    DateTime? fechaCreacion,
    DateTime? ultimaActualizacion,
  }) {
    return Vacunacion(
      id: id ?? this.id,
      loteId: loteId ?? this.loteId,
      granjaId: granjaId ?? this.granjaId,
      nombreVacuna: nombreVacuna ?? this.nombreVacuna,
      fechaProgramada: fechaProgramada ?? this.fechaProgramada,
      programadoPor: programadoPor ?? this.programadoPor,
      fechaAplicacion: fechaAplicacion ?? this.fechaAplicacion,
      edadAplicacionSemanas:
          edadAplicacionSemanas ?? this.edadAplicacionSemanas,
      dosis: dosis ?? this.dosis,
      via: via ?? this.via,
      responsable: responsable ?? this.responsable,
      loteVacuna: loteVacuna ?? this.loteVacuna,
      laboratorio: laboratorio ?? this.laboratorio,
      proximaAplicacion: proximaAplicacion ?? this.proximaAplicacion,
      observaciones: observaciones ?? this.observaciones,
      aplicada: aplicada ?? this.aplicada,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      ultimaActualizacion: ultimaActualizacion ?? this.ultimaActualizacion,
    );
  }
}

class VacunacionException implements Exception {
  VacunacionException(this.mensaje);
  final String mensaje;
  @override
  String toString() => 'VacunacionException: $mensaje';
}
