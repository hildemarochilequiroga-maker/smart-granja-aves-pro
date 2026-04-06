import 'package:equatable/equatable.dart';
import 'package:smartgranjaavespro/core/errors/error_messages.dart';

/// Entidad que representa un registro de salud de un lote.
class SaludRegistro extends Equatable {
  const SaludRegistro({
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
    DateTime? ultimaActualizacion,
  }) : ultimaActualizacion = ultimaActualizacion ?? fechaCreacion;

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

  @override
  List<Object?> get props => [
    id,
    loteId,
    granjaId,
    fecha,
    diagnostico,
    registradoPor,
    sintomas,
    tratamiento,
    medicamentos,
    dosis,
    duracionDias,
    veterinario,
    observaciones,
    fechaCierre,
    resultado,
    fechaCreacion,
    ultimaActualizacion,
  ];

  factory SaludRegistro.crear({
    required String id,
    required String loteId,
    required String granjaId,
    required String diagnostico,
    required String registradoPor,
    DateTime? fecha,
    String? sintomas,
  }) {
    if (diagnostico.trim().isEmpty) {
      throw SaludRegistroException(ErrorMessages.get('SALUD_DIAGNOSTICO_VACIO'));
    }

    return SaludRegistro(
      id: id,
      loteId: loteId,
      granjaId: granjaId,
      fecha: fecha ?? DateTime.now(),
      diagnostico: diagnostico,
      registradoPor: registradoPor,
      sintomas: sintomas,
      fechaCreacion: DateTime.now(),
    );
  }

  bool get estaCerrado => fechaCierre != null;
  bool get estaAbierto => !estaCerrado;

  int? get diasTratamiento {
    if (fechaCierre == null) return null;
    return fechaCierre!.difference(fecha).inDays;
  }

  SaludRegistro agregarMedicamento({
    required String medicamento,
    required String dosis,
  }) {
    final nuevosMedicamentos = medicamentos != null
        ? '$medicamentos, $medicamento'
        : medicamento;
    final nuevaDosis = this.dosis != null ? '${this.dosis}, $dosis' : dosis;

    return copyWith(
      medicamentos: nuevosMedicamentos,
      dosis: nuevaDosis,
      ultimaActualizacion: DateTime.now(),
    );
  }

  SaludRegistro cerrar({required String resultado}) {
    if (estaCerrado) {
      throw SaludRegistroException(ErrorMessages.get('SALUD_REGISTRO_CERRADO'));
    }

    return copyWith(
      fechaCierre: DateTime.now(),
      resultado: resultado,
      ultimaActualizacion: DateTime.now(),
    );
  }

  SaludRegistro copyWith({
    String? id,
    String? loteId,
    String? granjaId,
    DateTime? fecha,
    String? diagnostico,
    String? registradoPor,
    String? sintomas,
    String? tratamiento,
    String? medicamentos,
    String? dosis,
    int? duracionDias,
    String? veterinario,
    String? observaciones,
    DateTime? fechaCierre,
    String? resultado,
    DateTime? fechaCreacion,
    DateTime? ultimaActualizacion,
  }) {
    return SaludRegistro(
      id: id ?? this.id,
      loteId: loteId ?? this.loteId,
      granjaId: granjaId ?? this.granjaId,
      fecha: fecha ?? this.fecha,
      diagnostico: diagnostico ?? this.diagnostico,
      registradoPor: registradoPor ?? this.registradoPor,
      sintomas: sintomas ?? this.sintomas,
      tratamiento: tratamiento ?? this.tratamiento,
      medicamentos: medicamentos ?? this.medicamentos,
      dosis: dosis ?? this.dosis,
      duracionDias: duracionDias ?? this.duracionDias,
      veterinario: veterinario ?? this.veterinario,
      observaciones: observaciones ?? this.observaciones,
      fechaCierre: fechaCierre ?? this.fechaCierre,
      resultado: resultado ?? this.resultado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      ultimaActualizacion: ultimaActualizacion ?? this.ultimaActualizacion,
    );
  }
}

class SaludRegistroException implements Exception {
  SaludRegistroException(this.mensaje);
  final String mensaje;
  @override
  String toString() => 'SaludRegistroException: $mensaje';
}
