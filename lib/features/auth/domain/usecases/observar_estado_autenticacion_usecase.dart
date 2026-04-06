library;

import '../entities/entities.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para observar cambios en el estado de autenticación
class ObservarEstadoAutenticacionUseCase {
  const ObservarEstadoAutenticacionUseCase(this._repository);

  final AuthRepository _repository;

  /// Stream de cambios en el usuario autenticado
  Stream<Usuario?> call() => _repository.estadoAutenticacion;
}
