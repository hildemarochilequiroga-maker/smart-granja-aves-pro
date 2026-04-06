/// Use Case para registrar mortalidad en un lote.
///
/// Responsabilidades:
/// - Validar que el lote existe y está activo
/// - Registrar la mortalidad con causa
/// - Actualizar estadísticas del lote
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lote.dart';
import '../enums/estado_lote.dart';
import '../../../salud/domain/enums/causa_mortalidad.dart';
import '../repositories/lote_repository.dart';

/// Use Case para registrar mortalidad en un lote.
class RegistrarMortalidadUseCase {
  final LoteRepository _loteRepository;

  RegistrarMortalidadUseCase({required LoteRepository loteRepository})
    : _loteRepository = loteRepository;

  /// Ejecuta el registro de mortalidad.
  Future<Either<Failure, Lote>> call(RegistrarMortalidadParams params) async {
    try {
      // 1. Obtener el lote
      final loteResult = await _loteRepository.obtenerPorId(params.loteId);

      return loteResult.fold((failure) => Left(failure), (lote) async {
        // 2. Validar que esté activo
        if (lote.estado != EstadoLote.activo &&
            lote.estado != EstadoLote.cuarentena) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.format('LOTE_NO_REGISTRAR_MORTALIDAD_UC', {
                'estado': lote.estado.displayName,
              }),
            ),
          );
        }

        // 3. Validar cantidad
        if (params.cantidad <= 0) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('LOTE_MORTALIDAD_MAYOR_CERO'),
            ),
          );
        }

        // 4. Validar que no excede aves actuales
        final cantidadActualLote = lote.avesActuales;
        if (params.cantidad > cantidadActualLote) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.format('LOTE_MORTALIDAD_EXCEDE_CANTIDAD', {
                'cantidad': params.cantidad.toString(),
                'cantidadActual': cantidadActualLote.toString(),
              }),
            ),
          );
        }

        // 5. Registrar la mortalidad usando el metodo de dominio
        try {
          final loteActualizado = lote.registrarMortalidad(
            params.cantidad,
            observacion: params.observaciones,
          );

          // 6. Persistir
          return await _loteRepository.actualizar(loteActualizado);
        } on LoteException catch (e) {
          return Left(ValidationFailure(message: e.mensaje));
        }
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERROR_REGISTRAR_MORTALIDAD', {
            'detail': e.toString(),
          }),
        ),
      );
    }
  }
}

/// Parametros para RegistrarMortalidadUseCase.
class RegistrarMortalidadParams extends Equatable {
  final String loteId;
  final int cantidad;
  final CausaMortalidad causa;
  final DateTime? fecha;
  final String? observaciones;

  const RegistrarMortalidadParams({
    required this.loteId,
    required this.cantidad,
    required this.causa,
    this.fecha,
    this.observaciones,
  });

  @override
  List<Object?> get props => [loteId, cantidad, causa, fecha, observaciones];
}
