/// Use Case para eliminar un lote de aves.
///
/// Responsabilidades:
/// - Validar que el lote existe
/// - Eliminar el lote y sus registros asociados
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../enums/estado_lote.dart';
import '../repositories/lote_repository.dart';

/// Use Case para eliminar un lote.
class EliminarLoteUseCase {
  final LoteRepository _loteRepository;

  EliminarLoteUseCase({required LoteRepository loteRepository})
    : _loteRepository = loteRepository;

  /// Ejecuta la eliminación del lote.
  Future<Either<Failure, Unit>> call(EliminarLoteParams params) async {
    try {
      // 1. Verificar que el lote existe
      final loteResult = await _loteRepository.obtenerPorId(params.loteId);

      return loteResult.fold((failure) => Left(failure), (lote) async {
        // 2. No permitir eliminar lotes activos
        if (lote.estado == EstadoLote.activo) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('LOTE_NO_ELIMINAR_ACTIVO'),
            ),
          );
        }

        // 3. Eliminar el lote
        return await _loteRepository.eliminar(params.loteId);
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message:
              '${ErrorMessages.get('ERROR_ELIMINAR_LOTE')}: ${e.toString()}',
        ),
      );
    }
  }
}

/// Parámetros para EliminarLoteUseCase.
class EliminarLoteParams extends Equatable {
  final String loteId;

  const EliminarLoteParams({required this.loteId});

  @override
  List<Object?> get props => [loteId];
}
