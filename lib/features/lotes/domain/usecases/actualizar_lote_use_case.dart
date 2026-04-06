/// Use case para actualizar datos generales de un lote existente.
///
/// **Reglas de Negocio:**
/// - Lote debe existir
/// - No se puede editar un lote cerrado
/// - Fecha ingreso no puede ser futura
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lote.dart';
import '../enums/estado_lote.dart';
import '../repositories/lote_repository.dart';

/// Use case para actualizar un lote existente.
class ActualizarLoteUseCase {
  final LoteRepository _loteRepository;

  ActualizarLoteUseCase({required LoteRepository loteRepository})
    : _loteRepository = loteRepository;

  /// Ejecuta la actualización del lote.
  Future<Either<Failure, Lote>> call(ActualizarLoteParams params) async {
    try {
      // 1. Obtener lote actual
      final loteResult = await _loteRepository.obtenerPorId(params.loteId);

      return loteResult.fold((failure) => Left(failure), (loteActual) async {
        // 2. Validar que no esté cerrado
        if (loteActual.estado == EstadoLote.cerrado ||
            loteActual.estado == EstadoLote.vendido) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('LOTE_NO_EDITAR_CERRADO_VENDIDO'),
            ),
          );
        }

        // 3. Construir lote actualizado
        final loteActualizado = loteActual.copyWith(
          codigo: params.codigo,
          nombre: params.nombre,
          proveedor: params.proveedor,
          raza: params.raza,
          edadIngresoDias: params.edadIngresoDias,
          pesoPromedioActual: params.pesoPromedioActual,
          pesoPromedioObjetivo: params.pesoPromedioObjetivo,
          fechaCierreEstimada: params.fechaCierreEstimada,
          observaciones: params.observaciones,
          ultimaActualizacion: DateTime.now(),
        );

        // 4. Persistir lote
        return await _loteRepository.actualizar(loteActualizado);
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message:
              '${ErrorMessages.get('ERROR_ACTUALIZAR_LOTE')}: ${e.toString()}',
        ),
      );
    }
  }
}

/// Parámetros para actualizar un lote.
class ActualizarLoteParams extends Equatable {
  final String loteId;
  final String? codigo;
  final String? nombre;
  final String? proveedor;
  final String? raza;
  final int? edadIngresoDias;
  final double? pesoPromedioActual;
  final double? pesoPromedioObjetivo;
  final DateTime? fechaCierreEstimada;
  final String? observaciones;

  const ActualizarLoteParams({
    required this.loteId,
    this.codigo,
    this.nombre,
    this.proveedor,
    this.raza,
    this.edadIngresoDias,
    this.pesoPromedioActual,
    this.pesoPromedioObjetivo,
    this.fechaCierreEstimada,
    this.observaciones,
  });

  @override
  List<Object?> get props => [
    loteId,
    codigo,
    nombre,
    proveedor,
    raza,
    edadIngresoDias,
    pesoPromedioActual,
    pesoPromedioObjetivo,
    fechaCierreEstimada,
    observaciones,
  ];
}
