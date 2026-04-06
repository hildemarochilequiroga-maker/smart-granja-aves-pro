/// Use Case para cerrar un lote de aves.
///
/// Responsabilidades:
/// - Validar que el lote existe y está activo
/// - Registrar datos finales del cierre
/// - Cambiar estado a cerrado
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lote.dart';
import '../enums/estado_lote.dart';
import '../repositories/lote_repository.dart';

/// Use Case para cerrar un lote.
class CerrarLoteUseCase {
  final LoteRepository _loteRepository;

  CerrarLoteUseCase({required LoteRepository loteRepository})
    : _loteRepository = loteRepository;

  /// Ejecuta el cierre del lote.
  Future<Either<Failure, Lote>> call(CerrarLoteParams params) async {
    try {
      // 1. Obtener el lote
      final loteResult = await _loteRepository.obtenerPorId(params.loteId);

      return loteResult.fold((failure) => Left(failure), (lote) async {
        // 2. Validar que no esté ya cerrado
        if (lote.estado == EstadoLote.cerrado) {
          return Left(
            ValidationFailure(message: ErrorMessages.get('LOTE_YA_CERRADO')),
          );
        }

        if (lote.estado == EstadoLote.vendido) {
          return Left(
            ValidationFailure(message: ErrorMessages.get('LOTE_YA_VENDIDO_UC')),
          );
        }

        // 3. Validar fecha de cierre
        final fechaCierre = params.fechaCierreReal ?? DateTime.now();

        if (fechaCierre.isBefore(lote.fechaIngreso)) {
          return Left(
            ValidationFailure(
              message:
                  ErrorMessages.get('LOTE_FECHA_CIERRE_ANTERIOR_INGRESO'),
            ),
          );
        }

        if (fechaCierre.isAfter(DateTime.now())) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('LOTE_FECHA_CIERRE_FUTURA'),
            ),
          );
        }

        // 4. Cerrar el lote
        final loteCerrado = lote.copyWith(
          estado: EstadoLote.cerrado,
          fechaCierreReal: fechaCierre,
          cantidadActual: params.cantidadFinal ?? lote.avesActuales,
          pesoPromedioActual:
              params.pesoFinalPromedio ?? lote.pesoPromedioActual,
          motivoCierre: params.motivo ?? 'Cierre normal',
          observaciones: params.observaciones != null
              ? '${lote.observaciones ?? ''}\n[Cierre] ${params.observaciones}'
                    .trim()
              : lote.observaciones,
          ultimaActualizacion: DateTime.now(),
        );

        // 5. Persistir
        return await _loteRepository.actualizar(loteCerrado);
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: '${ErrorMessages.get('ERROR_CERRAR_LOTE')}: ${e.toString()}'),
      );
    }
  }
}

/// Parámetros para CerrarLoteUseCase.
class CerrarLoteParams extends Equatable {
  final String loteId;
  final DateTime? fechaCierreReal;
  final int? cantidadFinal;
  final double? pesoFinalPromedio;
  final String? motivo;
  final String? observaciones;

  const CerrarLoteParams({
    required this.loteId,
    this.fechaCierreReal,
    this.cantidadFinal,
    this.pesoFinalPromedio,
    this.motivo,
    this.observaciones,
  });

  @override
  List<Object?> get props => [
    loteId,
    fechaCierreReal,
    cantidadFinal,
    pesoFinalPromedio,
    motivo,
    observaciones,
  ];
}
