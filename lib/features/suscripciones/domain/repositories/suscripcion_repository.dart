library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/suscripcion.dart';

/// Contrato del repositorio de suscripciones.
///
/// El cliente NUNCA escribe el plan: solo lo lee. La escritura ocurre en el
/// servidor (Cloud Function que valida la compra de Google Play). Por eso el
/// contrato es deliberadamente de solo lectura/observación.
abstract class SuscripcionRepository {
  /// Stream de la suscripción del usuario [usuarioId]. Emite
  /// [Suscripcion.gratis] si no existe documento (usuario sin plan de pago).
  Stream<Suscripcion> observar(String usuarioId);

  /// Lectura puntual de la suscripción del usuario. Devuelve gratis si no
  /// existe documento.
  Future<Either<Failure, Suscripcion>> obtener(String usuarioId);
}
