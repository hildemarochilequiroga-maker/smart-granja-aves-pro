/// Use Case para registrar producción de huevos en un lote.
///
/// Responsabilidades:
/// - Validar que el lote es de ponedoras
/// - Validar que el lote está activo
/// - Registrar la producción de huevos
///
/// NOTA: La producción se registra en metadatos hasta implementar
/// entidad RegistroProduccion separada.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lote.dart';
import '../enums/enums.dart';
import '../repositories/lote_repository.dart';

/// Use Case para registrar producción de huevos.
class RegistrarProduccionUseCase {
  final LoteRepository _loteRepository;

  RegistrarProduccionUseCase({required LoteRepository loteRepository})
    : _loteRepository = loteRepository;

  /// Ejecuta el registro de producción.
  Future<Either<Failure, Lote>> call(RegistrarProduccionParams params) async {
    try {
      // 1. Obtener el lote
      final loteResult = await _loteRepository.obtenerPorId(params.loteId);

      return loteResult.fold((failure) => Left(failure), (lote) async {
        // 2. Validar que sea lote de ponedoras
        if (!lote.tipoAve.esPonedora) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('LOTE_SOLO_PONEDORAS_PRODUCCION'),
            ),
          );
        }

        // 3. Validar que permita operaciones
        if (lote.estado == EstadoLote.cerrado ||
            lote.estado == EstadoLote.vendido) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.format('LOTE_NO_REGISTRAR_PRODUCCION_UC', {
                'estado': lote.estado.displayName,
              }),
            ),
          );
        }

        // 4. Validar cantidad
        if (params.huevosRecolectados <= 0) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('LOTE_HUEVOS_MAYOR_CERO'),
            ),
          );
        }

        // 5. Registrar producción en metadatos
        final fecha = params.fecha ?? DateTime.now();
        final registros = List<Map<String, dynamic>>.from(
          lote.metadatos['produccion'] as List? ?? [],
        );
        registros.add({
          'huevos_recolectados': params.huevosRecolectados,
          'huevos_rotos': params.huevosRotos ?? 0,
          'huevos_sucios': params.huevosSucios ?? 0,
          'fecha': fecha.toIso8601String(),
          'observaciones': params.observaciones,
        });

        final nuevosMetadatos = Map<String, dynamic>.from(lote.metadatos);
        nuevosMetadatos['produccion'] = registros;
        nuevosMetadatos['huevos_total'] = registros.fold<int>(
          0,
          (sum, r) => sum + (r['huevos_recolectados'] as int? ?? 0),
        );

        // Registrar fecha primer huevo si es primera producción
        if (nuevosMetadatos['fecha_primer_huevo'] == null) {
          nuevosMetadatos['fecha_primer_huevo'] = fecha.toIso8601String();
        }

        final loteActualizado = lote.copyWith(
          metadatos: nuevosMetadatos,
          ultimaActualizacion: DateTime.now(),
        );

        // 6. Persistir
        return await _loteRepository.actualizar(loteActualizado);
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERROR_REGISTRAR_PRODUCCION', {
            'detail': e.toString(),
          }),
        ),
      );
    }
  }
}

/// Parámetros para RegistrarProduccionUseCase.
class RegistrarProduccionParams extends Equatable {
  final String loteId;
  final int huevosRecolectados;
  final DateTime? fecha;
  final int? huevosRotos;
  final int? huevosSucios;
  final Map<ClasificacionHuevo, int>? clasificacion;
  final String? observaciones;

  const RegistrarProduccionParams({
    required this.loteId,
    required this.huevosRecolectados,
    this.fecha,
    this.huevosRotos,
    this.huevosSucios,
    this.clasificacion,
    this.observaciones,
  });

  @override
  List<Object?> get props => [
    loteId,
    huevosRecolectados,
    fecha,
    huevosRotos,
    huevosSucios,
    clasificacion,
    observaciones,
  ];
}
