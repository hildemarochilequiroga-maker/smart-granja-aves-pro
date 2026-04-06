/// Use Case para registrar el peso de un lote.
///
/// Actualiza el peso promedio actual del lote.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lote.dart';
import '../enums/estado_lote.dart';
import '../repositories/lote_repository.dart';

/// Use Case para registrar el peso de un lote.
class RegistrarPesoUseCase {
  final LoteRepository _loteRepository;

  RegistrarPesoUseCase({required LoteRepository loteRepository})
    : _loteRepository = loteRepository;

  /// Ejecuta el registro de peso.
  Future<Either<Failure, Lote>> call(RegistrarPesoParams params) async {
    try {
      // 1. Obtener el lote
      final loteResult = await _loteRepository.obtenerPorId(params.loteId);

      return loteResult.fold((failure) => Left(failure), (lote) async {
        // 2. Validar que permita operaciones
        if (lote.estado == EstadoLote.cerrado ||
            lote.estado == EstadoLote.vendido) {
          return Left(
            ValidationFailure(
              message:
                  ErrorMessages.format('LOTE_NO_REGISTRAR_PESO', {'estado': lote.estado.displayName}),
            ),
          );
        }

        // 3. Validar peso (convertir gramos a kg)
        final pesoKg = params.pesoPromedioGramos / 1000.0;
        if (pesoKg <= 0) {
          return Left(
            ValidationFailure(message: ErrorMessages.get('LOTE_PESO_MAYOR_CERO')),
          );
        }

        // 4. Usar el método de dominio para actualizar peso
        try {
          final loteActualizado = lote.actualizarPeso(pesoKg);

          // 5. Persistir
          return await _loteRepository.actualizar(loteActualizado);
        } on LoteException catch (e) {
          return Left(ValidationFailure(message: e.mensaje));
        }
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: '${ErrorMessages.get('ERROR_REGISTRAR_PESO')}: ${e.toString()}'),
      );
    }
  }
}

/// Parámetros para RegistrarPesoUseCase.
class RegistrarPesoParams extends Equatable {
  final String loteId;
  final double pesoPromedioGramos;
  final DateTime? fecha;
  final String? observaciones;

  const RegistrarPesoParams({
    required this.loteId,
    required this.pesoPromedioGramos,
    this.fecha,
    this.observaciones,
  });

  @override
  List<Object?> get props => [loteId, pesoPromedioGramos, fecha, observaciones];
}
