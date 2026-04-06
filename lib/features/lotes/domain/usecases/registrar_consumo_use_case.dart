/// Use Case para registrar consumo de alimento en un lote.
///
/// Responsabilidades:
/// - Validar que el lote existe y está activo
/// - Registrar el consumo de alimento
///
/// NOTA: El consumo se registra en metadatos hasta implementar
/// entidad RegistroConsumo separada.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lote.dart';
import '../enums/enums.dart';
import '../repositories/lote_repository.dart';

/// Use Case para registrar consumo de alimento.
class RegistrarConsumoUseCase {
  final LoteRepository _loteRepository;

  RegistrarConsumoUseCase({required LoteRepository loteRepository})
    : _loteRepository = loteRepository;

  /// Ejecuta el registro de consumo.
  Future<Either<Failure, Lote>> call(RegistrarConsumoParams params) async {
    try {
      // 1. Obtener el lote
      final loteResult = await _loteRepository.obtenerPorId(params.loteId);

      return loteResult.fold((failure) => Left(failure), (lote) async {
        // 2. Validar que permita operaciones
        if (lote.estado == EstadoLote.cerrado ||
            lote.estado == EstadoLote.vendido) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.format('LOTE_NO_REGISTRAR_CONSUMO_UC', {
                'estado': lote.estado.displayName,
              }),
            ),
          );
        }

        // 3. Validar cantidad
        if (params.cantidadKg <= 0) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('LOTE_CANTIDAD_ALIMENTO_MAYOR_CERO'),
            ),
          );
        }

        // 4. Registrar en metadatos (temporal)
        final fecha = params.fecha ?? DateTime.now();
        final registros = List<Map<String, dynamic>>.from(
          lote.metadatos['consumos'] as List? ?? [],
        );
        registros.add({
          'cantidad_kg': params.cantidadKg,
          'tipo_alimento': params.tipoAlimento.name,
          'fecha': fecha.toIso8601String(),
          'observaciones': params.observaciones,
        });

        final nuevosMetadatos = Map<String, dynamic>.from(lote.metadatos);
        nuevosMetadatos['consumos'] = registros;
        nuevosMetadatos['consumo_total_kg'] = registros.fold<double>(
          0.0,
          (sum, r) => sum + (r['cantidad_kg'] as double? ?? 0.0),
        );

        final loteActualizado = lote.copyWith(
          metadatos: nuevosMetadatos,
          ultimaActualizacion: DateTime.now(),
        );

        // 5. Persistir
        return await _loteRepository.actualizar(loteActualizado);
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message:
              '${ErrorMessages.get('ERROR_REGISTRAR_CONSUMO')}: ${e.toString()}',
        ),
      );
    }
  }
}

/// Parámetros para RegistrarConsumoUseCase.
class RegistrarConsumoParams extends Equatable {
  final String loteId;
  final double cantidadKg;
  final TipoAlimento tipoAlimento;
  final DateTime? fecha;
  final String? observaciones;

  const RegistrarConsumoParams({
    required this.loteId,
    required this.cantidadKg,
    required this.tipoAlimento,
    this.fecha,
    this.observaciones,
  });

  @override
  List<Object?> get props => [
    loteId,
    cantidadKg,
    tipoAlimento,
    fecha,
    observaciones,
  ];
}
