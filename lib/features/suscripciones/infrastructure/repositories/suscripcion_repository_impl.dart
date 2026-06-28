library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/suscripcion.dart';
import '../../domain/repositories/suscripcion_repository.dart';
import '../datasources/suscripcion_datasource.dart';

/// Implementación del repositorio de suscripciones.
///
/// Estrategia fail-safe: si la lectura puntual falla por cualquier motivo,
/// se degrada a la suscripción gratis en vez de propagar el error, para que
/// un fallo de red nunca bloquee al usuario ni le conceda capacidades de más.
class SuscripcionRepositoryImpl implements SuscripcionRepository {
  SuscripcionRepositoryImpl(this._datasource);

  final SuscripcionDatasource _datasource;

  @override
  Stream<Suscripcion> observar(String usuarioId) {
    return _datasource
        .observar(usuarioId)
        .map((model) => model.toEntity())
        .handleError((_) => Suscripcion.gratis(usuarioId));
  }

  @override
  Future<Either<Failure, Suscripcion>> obtener(String usuarioId) async {
    try {
      final model = await _datasource.obtener(usuarioId);
      return Right(model.toEntity());
    } on Exception {
      // Degradación segura: ante cualquier error, plan gratis.
      return Right(Suscripcion.gratis(usuarioId));
    }
  }
}
