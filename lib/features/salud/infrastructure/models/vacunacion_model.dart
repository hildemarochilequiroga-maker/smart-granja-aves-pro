import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/vacunacion.dart';

/// Modelo de datos para Vacunacion con serialización Firestore.
class VacunacionModel {
  const VacunacionModel({
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
    required this.aplicada,
    required this.fechaCreacion,
    required this.ultimaActualizacion,
  });

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

  factory VacunacionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return VacunacionModel(
      id: doc.id,
      loteId: data['loteId'] as String? ?? '',
      granjaId: data['granjaId'] as String? ?? '',
      nombreVacuna: data['nombreVacuna'] as String? ?? 'Sin nombre',
      fechaProgramada:
          (data['fechaProgramada'] as Timestamp?)?.toDate() ?? DateTime.now(),
      programadoPor: data['programadoPor'] as String? ?? 'Desconocido',
      fechaAplicacion: (data['fechaAplicacion'] as Timestamp?)?.toDate(),
      edadAplicacionSemanas: data['edadAplicacionSemanas'] as int?,
      dosis: data['dosis'] as String?,
      via: data['via'] as String?,
      responsable: data['responsable'] as String?,
      loteVacuna: data['loteVacuna'] as String?,
      laboratorio: data['laboratorio'] as String?,
      proximaAplicacion: (data['proximaAplicacion'] as Timestamp?)?.toDate(),
      observaciones: data['observaciones'] as String?,
      aplicada: data['aplicada'] as bool? ?? false,
      fechaCreacion:
          (data['fechaCreacion'] as Timestamp?)?.toDate() ?? DateTime.now(),
      ultimaActualizacion:
          (data['ultimaActualizacion'] as Timestamp?)?.toDate() ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'loteId': loteId,
      'granjaId': granjaId,
      'nombreVacuna': nombreVacuna,
      'fechaProgramada': Timestamp.fromDate(fechaProgramada),
      'programadoPor': programadoPor,
      if (fechaAplicacion != null)
        'fechaAplicacion': Timestamp.fromDate(fechaAplicacion!),
      if (edadAplicacionSemanas != null)
        'edadAplicacionSemanas': edadAplicacionSemanas,
      if (dosis != null) 'dosis': dosis,
      if (via != null) 'via': via,
      if (responsable != null) 'responsable': responsable,
      if (loteVacuna != null) 'loteVacuna': loteVacuna,
      if (laboratorio != null) 'laboratorio': laboratorio,
      if (proximaAplicacion != null)
        'proximaAplicacion': Timestamp.fromDate(proximaAplicacion!),
      if (observaciones != null) 'observaciones': observaciones,
      'aplicada': aplicada,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'ultimaActualizacion': Timestamp.fromDate(ultimaActualizacion),
    };
  }

  Vacunacion toEntity() {
    return Vacunacion(
      id: id,
      loteId: loteId,
      granjaId: granjaId,
      nombreVacuna: nombreVacuna,
      fechaProgramada: fechaProgramada,
      programadoPor: programadoPor,
      fechaAplicacion: fechaAplicacion,
      edadAplicacionSemanas: edadAplicacionSemanas,
      dosis: dosis,
      via: via,
      responsable: responsable,
      loteVacuna: loteVacuna,
      laboratorio: laboratorio,
      proximaAplicacion: proximaAplicacion,
      observaciones: observaciones,
      aplicada: aplicada,
      fechaCreacion: fechaCreacion,
      ultimaActualizacion: ultimaActualizacion,
    );
  }

  factory VacunacionModel.fromEntity(Vacunacion vacunacion) {
    return VacunacionModel(
      id: vacunacion.id,
      loteId: vacunacion.loteId,
      granjaId: vacunacion.granjaId,
      nombreVacuna: vacunacion.nombreVacuna,
      fechaProgramada: vacunacion.fechaProgramada,
      programadoPor: vacunacion.programadoPor,
      fechaAplicacion: vacunacion.fechaAplicacion,
      edadAplicacionSemanas: vacunacion.edadAplicacionSemanas,
      dosis: vacunacion.dosis,
      via: vacunacion.via,
      responsable: vacunacion.responsable,
      loteVacuna: vacunacion.loteVacuna,
      laboratorio: vacunacion.laboratorio,
      proximaAplicacion: vacunacion.proximaAplicacion,
      observaciones: vacunacion.observaciones,
      aplicada: vacunacion.aplicada,
      fechaCreacion: vacunacion.fechaCreacion,
      ultimaActualizacion: vacunacion.ultimaActualizacion,
    );
  }
}
