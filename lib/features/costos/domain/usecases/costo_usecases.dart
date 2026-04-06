import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/costo_gasto.dart';
import '../repositories/costo_repository.dart';

/// Use case para registrar un nuevo costo/gasto.
///
/// Incluye validaciones de negocio antes de persistir.
class RegistrarCostoUseCase {
  final CostoRepository repository;

  RegistrarCostoUseCase(this.repository);

  Future<Either<Failure, CostoGasto>> call(CostoGasto costo) async {
    try {
      // Validaciones de negocio
      final errorValidacion = _validarCosto(costo);
      if (errorValidacion != null) {
        return Left(
          ValidationFailure(message: errorValidacion, code: 'VALIDACION_COSTO'),
        );
      }

      final costoGuardado = await repository.crear(costo);
      return Right(costoGuardado);
    } on CostoGastoException catch (e) {
      return Left(
        ValidationFailure(message: e.message, code: 'COSTO_EXCEPTION'),
      );
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: '${ErrorMessages.get('ERROR_REGISTRAR_COSTO')}: ${e.toString()}'),
      );
    }
  }

  String? _validarCosto(CostoGasto costo) {
    if (costo.granjaId.isEmpty) {
      return ErrorMessages.get('COSTO_SELECT_GRANJA');
    }
    if (costo.concepto.trim().isEmpty) {
      return ErrorMessages.get('COSTO_CONCEPTO_REQUIRED');
    }
    if (costo.monto <= 0) {
      return ErrorMessages.get('COSTO_MONTO_GREATER_ZERO');
    }
    if (costo.registradoPor.isEmpty) {
      return ErrorMessages.get('COSTO_REGISTRADO_POR_REQUIRED');
    }
    return null;
  }
}

/// Use case para obtener costos por lote.
class ObtenerCostosPorLoteUseCase {
  final CostoRepository repository;

  ObtenerCostosPorLoteUseCase(this.repository);

  Future<Either<Failure, List<CostoGasto>>> call(String loteId) async {
    try {
      if (loteId.isEmpty) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('COSTO_LOTE_ID_REQUIRED'),
            code: 'COSTO_LOTE_ID_REQUIRED',
          ),
        );
      }

      final costos = await repository.obtenerPorLote(loteId);
      return Right(costos);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message:
              '${ErrorMessages.get('GENERIC_SERVER_ERROR')}: ${e.toString()}',
        ),
      );
    }
  }
}

/// Use case para calcular el costo total de un lote.
class CalcularCostoTotalLoteUseCase {
  final CostoRepository repository;

  CalcularCostoTotalLoteUseCase(this.repository);

  Future<Either<Failure, double>> call(String loteId) async {
    try {
      if (loteId.isEmpty) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('COSTO_LOTE_ID_REQUIRED'),
            code: 'COSTO_LOTE_ID_REQUIRED',
          ),
        );
      }

      final total = await repository.calcularCostoTotalLote(loteId);
      return Right(total);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message:
              '${ErrorMessages.get('GENERIC_SERVER_ERROR')}: ${e.toString()}',
        ),
      );
    }
  }
}

/// Use case para aprobar un costo.
class AprobarCostoUseCase {
  final CostoRepository repository;

  AprobarCostoUseCase(this.repository);

  Future<Either<Failure, CostoGasto>> call(
    String costoId,
    String aprobadoPor,
  ) async {
    try {
      if (costoId.isEmpty) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('COSTO_ID_REQUIRED'),
            code: 'COSTO_ID_REQUIRED',
          ),
        );
      }
      if (aprobadoPor.isEmpty) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('COSTO_APROBADOR_REQUIRED'),
            code: 'COSTO_APROBADOR_REQUIRED',
          ),
        );
      }

      final costo = await repository.obtenerPorId(costoId);
      if (costo == null) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('COSTO_NOT_FOUND'),
            code: 'COSTO_NOT_FOUND',
          ),
        );
      }

      final costoAprobado = costo.aprobar(aprobadoPor);
      final resultado = await repository.actualizar(costoAprobado);
      return Right(resultado);
    } on CostoGastoException catch (e) {
      return Left(
        ValidationFailure(message: e.message, code: 'COSTO_EXCEPTION'),
      );
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message:
              '${ErrorMessages.get('GENERIC_SERVER_ERROR')}: ${e.toString()}',
        ),
      );
    }
  }
}

/// Use case para rechazar un costo.
class RechazarCostoUseCase {
  final CostoRepository repository;

  RechazarCostoUseCase(this.repository);

  Future<Either<Failure, CostoGasto>> call(
    String costoId,
    String motivo,
  ) async {
    try {
      if (costoId.isEmpty) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('COSTO_ID_REQUIRED'),
            code: 'COSTO_ID_REQUIRED',
          ),
        );
      }
      if (motivo.trim().isEmpty) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('COSTO_MOTIVO_RECHAZO_REQUIRED'),
            code: 'COSTO_MOTIVO_RECHAZO_REQUIRED',
          ),
        );
      }

      final costo = await repository.obtenerPorId(costoId);
      if (costo == null) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('COSTO_NOT_FOUND'),
            code: 'COSTO_NOT_FOUND',
          ),
        );
      }

      final costoRechazado = costo.rechazar(motivo: motivo);
      final resultado = await repository.actualizar(costoRechazado);
      return Right(resultado);
    } on CostoGastoException catch (e) {
      return Left(
        ValidationFailure(message: e.message, code: 'COSTO_EXCEPTION'),
      );
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message:
              '${ErrorMessages.get('GENERIC_SERVER_ERROR')}: ${e.toString()}',
        ),
      );
    }
  }
}

/// Use case para obtener costos pendientes de aprobación.
class ObtenerCostosPendientesUseCase {
  final CostoRepository repository;

  ObtenerCostosPendientesUseCase(this.repository);

  Future<Either<Failure, List<CostoGasto>>> call(String granjaId) async {
    try {
      if (granjaId.isEmpty) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('COSTO_GRANJA_ID_REQUIRED'),
            code: 'COSTO_GRANJA_ID_REQUIRED',
          ),
        );
      }

      final costos = await repository.obtenerPendientesAprobacion(granjaId);
      return Right(costos);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message:
              '${ErrorMessages.get('GENERIC_SERVER_ERROR')}: ${e.toString()}',
        ),
      );
    }
  }
}

/// Use case para obtener costos por período.
class ObtenerCostosPorPeriodoUseCase {
  final CostoRepository repository;

  ObtenerCostosPorPeriodoUseCase(this.repository);

  Future<Either<Failure, List<CostoGasto>>> call({
    required String granjaId,
    required DateTime desde,
    required DateTime hasta,
  }) async {
    try {
      if (granjaId.isEmpty) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('COSTO_GRANJA_ID_REQUIRED'),
            code: 'COSTO_GRANJA_ID_REQUIRED',
          ),
        );
      }
      if (desde.isAfter(hasta)) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('COSTO_FECHA_RANGO_INVALIDO'),
            code: 'COSTO_FECHA_RANGO_INVALIDO',
          ),
        );
      }

      final costos = await repository.obtenerPorPeriodo(
        granjaId: granjaId,
        desde: desde,
        hasta: hasta,
      );
      return Right(costos);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message:
              '${ErrorMessages.get('GENERIC_SERVER_ERROR')}: ${e.toString()}',
        ),
      );
    }
  }
}

/// Use case para obtener distribución de costos por tipo.
class ObtenerDistribucionCostosUseCase {
  final CostoRepository repository;

  ObtenerDistribucionCostosUseCase(this.repository);

  Future<Either<Failure, Map<dynamic, double>>> call(String granjaId) async {
    try {
      if (granjaId.isEmpty) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('COSTO_GRANJA_ID_REQUIRED'),
            code: 'COSTO_GRANJA_ID_REQUIRED',
          ),
        );
      }

      final distribucion = await repository.obtenerDistribucionPorTipo(
        granjaId,
      );
      return Right(distribucion);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message:
              '${ErrorMessages.get('GENERIC_SERVER_ERROR')}: ${e.toString()}',
        ),
      );
    }
  }
}
