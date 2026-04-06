import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/salud_registro.dart';
import '../repositories/salud_repository.dart';
import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';

class RegistrarTratamientoUseCase {
  final SaludRepository saludRepository;

  RegistrarTratamientoUseCase({required this.saludRepository});

  Future<Either<Failure, SaludRegistro>> call(
    RegistrarTratamientoParams params,
  ) async {
    try {
      // Validaciones
      if (params.diagnostico.trim().isEmpty) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('SALUD_DIAGNOSTICO_OBLIGATORIO'),
            field: 'diagnostico',
          ),
        );
      }

      if (params.tratamiento.trim().isEmpty) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('SALUD_TRATAMIENTO_OBLIGATORIO'),
            field: 'tratamiento',
          ),
        );
      }

      final fechaRegistro = params.fechaInicio ?? DateTime.now();
      if (fechaRegistro.isAfter(DateTime.now())) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('SALUD_FECHA_NO_FUTURA'),
            field: 'fechaInicio',
          ),
        );
      }

      // ID temporal, será reemplazado por Firestore
      final registro = SaludRegistro(
        id: '',
        loteId: params.loteId,
        granjaId: params.granjaId,
        fecha: fechaRegistro,
        diagnostico: params.diagnostico,
        registradoPor: params.registradoPor,
        sintomas: params.sintomas,
        tratamiento: params.tratamiento,
        medicamentos: params.medicamentos,
        dosis: params.dosis,
        duracionDias: params.duracionDias,
        veterinario: params.veterinario,
        observaciones: params.observaciones,
        fechaCreacion: DateTime.now(),
        ultimaActualizacion: DateTime.now(),
      );

      return await saludRepository.crear(registro);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format(
            'ERROR_REGISTRAR_TRATAMIENTO',
            {'detail': e.toString()},
          ),
        ),
      );
    }
  }
}

class RegistrarTratamientoParams extends Equatable {
  final String loteId;
  final String granjaId;
  final String diagnostico;
  final String? sintomas;
  final String tratamiento;
  final String? medicamentos;
  final String? dosis;
  final int? duracionDias;
  final String? veterinario;
  final String? observaciones;
  final DateTime? fechaInicio;
  final String registradoPor;

  const RegistrarTratamientoParams({
    required this.loteId,
    required this.granjaId,
    required this.diagnostico,
    this.sintomas,
    required this.tratamiento,
    this.medicamentos,
    this.dosis,
    this.duracionDias,
    this.veterinario,
    this.observaciones,
    this.fechaInicio,
    required this.registradoPor,
  });

  @override
  List<Object?> get props => [
    loteId,
    granjaId,
    diagnostico,
    sintomas,
    tratamiento,
    medicamentos,
    dosis,
    duracionDias,
    veterinario,
    observaciones,
    fechaInicio,
    registradoPor,
  ];
}
