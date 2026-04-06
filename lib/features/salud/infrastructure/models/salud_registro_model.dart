import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/salud_registro.dart';

/// Modelo de datos para SaludRegistro con serialización Firestore.
class SaludRegistroModel {
  const SaludRegistroModel({
    required this.id,
    required this.loteId,
    required this.granjaId,
    required this.fecha,
    required this.diagnostico,
    required this.registradoPor,
    this.sintomas,
    this.tratamiento,
    this.medicamentos,
    this.dosis,
    this.duracionDias,
    this.veterinario,
    this.observaciones,
    this.fechaCierre,
    this.resultado,
    required this.fechaCreacion,
    required this.ultimaActualizacion,
  });

  final String id;
  final String loteId;
  final String granjaId;
  final DateTime fecha;
  final String diagnostico;
  final String registradoPor;
  final String? sintomas;
  final String? tratamiento;
  final String? medicamentos;
  final String? dosis;
  final int? duracionDias;
  final String? veterinario;
  final String? observaciones;
  final DateTime? fechaCierre;
  final String? resultado;
  final DateTime fechaCreacion;
  final DateTime ultimaActualizacion;

  factory SaludRegistroModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return SaludRegistroModel(
      id: doc.id,
      loteId: data['loteId'] as String? ?? '',
      granjaId: data['granjaId'] as String? ?? '',
      fecha: (data['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
      diagnostico: data['diagnostico'] as String? ?? 'Sin diagnóstico',
      registradoPor: data['registradoPor'] as String? ?? 'Desconocido',
      sintomas: data['sintomas'] as String?,
      tratamiento: data['tratamiento'] as String?,
      medicamentos: data['medicamentos'] as String?,
      dosis: data['dosis'] as String?,
      duracionDias: data['duracionDias'] as int?,
      veterinario: data['veterinario'] as String?,
      observaciones: data['observaciones'] as String?,
      fechaCierre: (data['fechaCierre'] as Timestamp?)?.toDate(),
      resultado: data['resultado'] as String?,
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
      'fecha': Timestamp.fromDate(fecha),
      'diagnostico': diagnostico,
      'registradoPor': registradoPor,
      if (sintomas != null) 'sintomas': sintomas,
      if (tratamiento != null) 'tratamiento': tratamiento,
      if (medicamentos != null) 'medicamentos': medicamentos,
      if (dosis != null) 'dosis': dosis,
      if (duracionDias != null) 'duracionDias': duracionDias,
      if (veterinario != null) 'veterinario': veterinario,
      if (observaciones != null) 'observaciones': observaciones,
      if (fechaCierre != null) 'fechaCierre': Timestamp.fromDate(fechaCierre!),
      if (resultado != null) 'resultado': resultado,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'ultimaActualizacion': Timestamp.fromDate(ultimaActualizacion),
    };
  }

  SaludRegistro toEntity() {
    return SaludRegistro(
      id: id,
      loteId: loteId,
      granjaId: granjaId,
      fecha: fecha,
      diagnostico: diagnostico,
      registradoPor: registradoPor,
      sintomas: sintomas,
      tratamiento: tratamiento,
      medicamentos: medicamentos,
      dosis: dosis,
      duracionDias: duracionDias,
      veterinario: veterinario,
      observaciones: observaciones,
      fechaCierre: fechaCierre,
      resultado: resultado,
      fechaCreacion: fechaCreacion,
      ultimaActualizacion: ultimaActualizacion,
    );
  }

  factory SaludRegistroModel.fromEntity(SaludRegistro registro) {
    return SaludRegistroModel(
      id: registro.id,
      loteId: registro.loteId,
      granjaId: registro.granjaId,
      fecha: registro.fecha,
      diagnostico: registro.diagnostico,
      registradoPor: registro.registradoPor,
      sintomas: registro.sintomas,
      tratamiento: registro.tratamiento,
      medicamentos: registro.medicamentos,
      dosis: registro.dosis,
      duracionDias: registro.duracionDias,
      veterinario: registro.veterinario,
      observaciones: registro.observaciones,
      fechaCierre: registro.fechaCierre,
      resultado: registro.resultado,
      fechaCreacion: registro.fechaCreacion,
      ultimaActualizacion: registro.ultimaActualizacion,
    );
  }
}
