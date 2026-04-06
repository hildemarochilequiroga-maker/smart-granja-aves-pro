import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/vacunacion.dart';
import '../repositories/vacunacion_repository.dart';
import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';

class ProgramarVacunacionUseCase {
  final VacunacionRepository vacunacionRepository;

  ProgramarVacunacionUseCase({required this.vacunacionRepository});

  Future<Either<Failure, Vacunacion>> call(
    ProgramarVacunacionParams params,
  ) async {
    try {
      // Validaciones
      if (params.nombreVacuna.trim().isEmpty) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('VACUNA_NOMBRE_OBLIGATORIO'),
            field: 'nombreVacuna',
          ),
        );
      }

      // ID temporal, será reemplazado por Firestore
      final vacunacion = Vacunacion(
        id: '',
        loteId: params.loteId,
        granjaId: params.granjaId,
        nombreVacuna: params.nombreVacuna,
        fechaProgramada: params.fechaProgramada,
        programadoPor: params.programadoPor,
        edadAplicacionSemanas: params.edadAplicacionSemanas,
        dosis: params.dosis,
        via: params.via,
        laboratorio: params.laboratorio,
        observaciones: params.observaciones,
        aplicada: false,
        fechaCreacion: DateTime.now(),
      );

      return await vacunacionRepository.crear(vacunacion);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format(
            'ERROR_PROGRAMAR_VACUNACION',
            {'detail': e.toString()},
          ),
        ),
      );
    }
  }
}

class ProgramarVacunacionParams extends Equatable {
  final String loteId;
  final String granjaId;
  final String nombreVacuna;
  final DateTime fechaProgramada;
  final int? edadAplicacionSemanas;
  final String? dosis;
  final String? via;
  final String? laboratorio;
  final String? observaciones;
  final String programadoPor;

  const ProgramarVacunacionParams({
    required this.loteId,
    required this.granjaId,
    required this.nombreVacuna,
    required this.fechaProgramada,
    this.edadAplicacionSemanas,
    this.dosis,
    this.via,
    this.laboratorio,
    this.observaciones,
    required this.programadoPor,
  });

  @override
  List<Object?> get props => [
    loteId,
    granjaId,
    nombreVacuna,
    fechaProgramada,
    edadAplicacionSemanas,
    dosis,
    via,
    laboratorio,
    observaciones,
    programadoPor,
  ];
}
