import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/vacunacion.dart';
import '../repositories/vacunacion_repository.dart';
import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';

class MarcarVacunacionAplicadaUseCase {
  final VacunacionRepository vacunacionRepository;

  MarcarVacunacionAplicadaUseCase({required this.vacunacionRepository});

  Future<Either<Failure, Vacunacion>> call(
    MarcarVacunacionAplicadaParams params,
  ) async {
    try {
      final vacunacionResult = await vacunacionRepository.obtenerPorId(
        params.vacunacionId,
      );

      return await vacunacionResult.fold((failure) async => Left(failure), (
        vacunacion,
      ) async {
        if (vacunacion == null) {
          return Left(NotFoundFailure(message: ErrorMessages.get('VACUNACION_NO_ENCONTRADA')));
        }

        if (vacunacion.aplicada == true) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('VACUNA_YA_APLICADA'),
              code: 'VACUNA_YA_APLICADA',
            ),
          );
        }

        // Validar campos requeridos
        if (params.edadAplicacionSemanas == null ||
            params.edadAplicacionSemanas! <= 0) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('VACUNA_EDAD_OBLIGATORIA'),
              field: 'edadAplicacionSemanas',
            ),
          );
        }

        if (params.dosis == null || params.dosis!.trim().isEmpty) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('VACUNA_DOSIS_OBLIGATORIA'),
              field: 'dosis',
            ),
          );
        }

        if (params.via == null || params.via!.trim().isEmpty) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('VACUNA_VIA_OBLIGATORIA'),
              field: 'via',
            ),
          );
        }

        final vacunacionAplicada = vacunacion.marcarAplicada(
          edadSemanas: params.edadAplicacionSemanas!,
          dosis: params.dosis!,
          via: params.via!,
          responsable: params.aplicadoPor,
          loteVacuna: params.loteVacuna,
          observaciones: params.observaciones,
        );

        return await vacunacionRepository.actualizar(vacunacionAplicada);
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: '${ErrorMessages.get('ERROR_APLICAR_VACUNA')}: ${e.toString()}'),
      );
    }
  }
}

class MarcarVacunacionAplicadaParams extends Equatable {
  final String vacunacionId;
  final DateTime fechaAplicacion;
  final String aplicadoPor;
  final int? edadAplicacionSemanas;
  final String? dosis;
  final String? via;
  final String? loteVacuna;
  final String? observaciones;

  const MarcarVacunacionAplicadaParams({
    required this.vacunacionId,
    required this.fechaAplicacion,
    required this.aplicadoPor,
    this.edadAplicacionSemanas,
    this.dosis,
    this.via,
    this.loteVacuna,
    this.observaciones,
  });

  @override
  List<Object?> get props => [
    vacunacionId,
    fechaAplicacion,
    aplicadoPor,
    edadAplicacionSemanas,
    dosis,
    via,
    loteVacuna,
    observaciones,
  ];
}
