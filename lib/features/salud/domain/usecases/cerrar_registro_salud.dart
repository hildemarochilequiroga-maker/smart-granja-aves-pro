import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/salud_registro.dart';
import '../repositories/salud_repository.dart';
import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';

class CerrarRegistroSaludUseCase {
  final SaludRepository saludRepository;

  CerrarRegistroSaludUseCase({required this.saludRepository});

  Future<Either<Failure, SaludRegistro>> call(
    CerrarRegistroSaludParams params,
  ) async {
    try {
      final registroResult = await saludRepository.obtenerPorId(
        params.registroId,
      );

      return await registroResult.fold((failure) async => Left(failure), (
        registro,
      ) async {
        if (registro == null) {
          return Left(
            NotFoundFailure(
              message: ErrorMessages.get('REGISTRO_SALUD_NO_ENCONTRADO'),
            ),
          );
        }

        if (registro.estaCerrado) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('SALUD_REGISTRO_CERRADO'),
              code: 'REGISTRO_YA_CERRADO',
            ),
          );
        }

        var registroCerrado = registro.cerrar(resultado: params.resultado);

        // Aplicar observaciones finales si existen
        if (params.observacionesFinales != null &&
            params.observacionesFinales!.trim().isNotEmpty) {
          final observacionesActualizadas = registro.observaciones != null
              ? '${registro.observaciones}\n\nObservaciones finales: ${params.observacionesFinales}'
              : 'Observaciones finales: ${params.observacionesFinales}';
          registroCerrado = registroCerrado.copyWith(
            observaciones: observacionesActualizadas,
          );
        }

        return await saludRepository.actualizar(registroCerrado);
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format(
            'ERROR_CERRAR_REGISTRO_SALUD',
            {'detail': e.toString()},
          ),
        ),
      );
    }
  }
}

class CerrarRegistroSaludParams extends Equatable {
  final String registroId;
  final String resultado;
  final String? observacionesFinales;

  const CerrarRegistroSaludParams({
    required this.registroId,
    required this.resultado,
    this.observacionesFinales,
  });

  @override
  List<Object?> get props => [registroId, resultado, observacionesFinales];
}
