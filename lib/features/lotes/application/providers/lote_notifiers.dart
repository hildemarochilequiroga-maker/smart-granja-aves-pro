import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/lote.dart';
import '../../domain/enums/estado_lote.dart';
import '../../domain/repositories/lote_repository.dart';
import '../state/lote_state.dart';

// =============================================================================
// NOTIFIER PRINCIPAL DE LOTES
// =============================================================================

/// Notifier para operaciones CRUD de lotes.
/// Retorna Either para que los callers puedan reaccionar al resultado.
class LoteNotifier extends StateNotifier<LoteState> {
  LoteNotifier({required LoteRepository repository})
    : _repository = repository,
      super(const LoteInitial());

  final LoteRepository _repository;

  LoteLoading _loading(String mensaje) => LoteLoading(
    mensaje: mensaje,
    lote: state.lote,
    lotes: state.lotes.isNotEmpty ? state.lotes : null,
  );

  LoteError _error(String mensaje, {String? code}) => LoteError(
    mensaje: mensaje,
    code: code,
    lote: state.lote,
    lotes: state.lotes.isNotEmpty ? state.lotes : null,
  );

  /// Crea un nuevo lote.
  Future<Either<Failure, Lote>> crear(Lote lote) async {
    state = _loading(
      switch (Formatters.currentLocale) { 'es' => 'Creando lote...', 'pt' => 'Criando lote...', _ => 'Creating batch...' },
    );
    final result = await _repository.crear(lote);
    state = result.fold(
      (failure) => _error(failure.message),
      (loteCreado) => LoteSuccess(
        lote: loteCreado,
        mensaje: switch (Formatters.currentLocale) { 'es' => 'Lote creado exitosamente', 'pt' => 'Lote criado com sucesso', _ => 'Batch created successfully' },
      ),
    );
    return result;
  }

  /// Actualiza un lote existente.
  Future<Either<Failure, Lote>> actualizar(Lote lote) async {
    state = _loading(
      switch (Formatters.currentLocale) { 'es' => 'Actualizando lote...', 'pt' => 'Atualizando lote...', _ => 'Updating batch...' },
    );
    final result = await _repository.actualizar(lote);
    state = result.fold(
      (failure) => _error(failure.message),
      (loteActualizado) => LoteSuccess(
        lote: loteActualizado,
        mensaje: switch (Formatters.currentLocale) { 'es' => 'Lote actualizado exitosamente', 'pt' => 'Lote atualizado com sucesso', _ => 'Batch updated successfully' },
      ),
    );
    return result;
  }

  /// Edita los datos básicos de un lote (formulario de edición) sin tocar los
  /// acumulados ni arriesgar sobrescribir registros concurrentes.
  Future<Either<Failure, Lote>> editarDatos(Lote lote) async {
    state = _loading(
      switch (Formatters.currentLocale) { 'es' => 'Actualizando lote...', 'pt' => 'Atualizando lote...', _ => 'Updating batch...' },
    );
    final result = await _repository.editarDatosBasicos(lote);
    state = result.fold(
      (failure) => _error(failure.message),
      (loteActualizado) => LoteSuccess(
        lote: loteActualizado,
        mensaje: switch (Formatters.currentLocale) { 'es' => 'Lote actualizado exitosamente', 'pt' => 'Lote atualizado com sucesso', _ => 'Batch updated successfully' },
      ),
    );
    return result;
  }

  /// Elimina un lote.
  Future<Either<Failure, void>> eliminar(String id) async {
    state = _loading(
      switch (Formatters.currentLocale) { 'es' => 'Eliminando lote...', 'pt' => 'Excluindo lote...', _ => 'Deleting batch...' },
    );
    final result = await _repository.eliminar(id);
    state = result.fold(
      (failure) => _error(failure.message),
      (_) => LoteDeleted(
        mensaje: switch (Formatters.currentLocale) { 'es' => 'Lote eliminado exitosamente', 'pt' => 'Lote excluído com sucesso', _ => 'Batch deleted successfully' },
      ),
    );
    return result;
  }

  /// Registra mortalidad en un lote.
  Future<Either<Failure, Lote>> registrarMortalidad(
    String loteId,
    int cantidad, {
    String? observacion,
  }) async {
    state = _loading(
      switch (Formatters.currentLocale) { 'es' => 'Registrando mortalidad...', 'pt' => 'Registrando mortalidade...', _ => 'Recording mortality...' },
    );
    final result = await _repository.registrarMortalidad(
      loteId,
      cantidad,
      observacion: observacion,
    );
    state = result.fold(
      (failure) => _error(failure.message),
      (lote) => LoteSuccess(
        lote: lote,
        mensaje: switch (Formatters.currentLocale) { 'es' => 'Mortalidad registrada', 'pt' => 'Mortalidade registrada', _ => 'Mortality recorded' },
      ),
    );
    return result;
  }

  /// Registra descarte en un lote.
  Future<Either<Failure, Lote>> registrarDescarte(
    String loteId,
    int cantidad, {
    String? motivo,
  }) async {
    state = _loading(
      switch (Formatters.currentLocale) { 'es' => 'Registrando descarte...', 'pt' => 'Registrando descarte...', _ => 'Recording discard...' },
    );
    final result = await _repository.registrarDescarte(
      loteId,
      cantidad,
      motivo: motivo,
    );
    state = result.fold(
      (failure) => _error(failure.message),
      (lote) => LoteSuccess(
        lote: lote,
        mensaje: switch (Formatters.currentLocale) { 'es' => 'Descarte registrado', 'pt' => 'Descarte registrado', _ => 'Discard recorded' },
      ),
    );
    return result;
  }

  /// Registra venta de aves.
  Future<Either<Failure, Lote>> registrarVenta(
    String loteId,
    int cantidad,
  ) async {
    state = _loading(
      switch (Formatters.currentLocale) { 'es' => 'Registrando venta...', 'pt' => 'Registrando venda...', _ => 'Recording sale...' },
    );
    final result = await _repository.registrarVenta(loteId, cantidad);
    state = result.fold(
      (failure) => _error(failure.message),
      (lote) => LoteSuccess(
        lote: lote,
        mensaje: switch (Formatters.currentLocale) { 'es' => 'Venta registrada', 'pt' => 'Venda registrada', _ => 'Sale recorded' },
      ),
    );
    return result;
  }

  /// Actualiza el peso promedio.
  Future<Either<Failure, Lote>> actualizarPeso(
    String loteId,
    double nuevoPeso,
  ) async {
    state = _loading(
      switch (Formatters.currentLocale) { 'es' => 'Actualizando peso...', 'pt' => 'Atualizando peso...', _ => 'Updating weight...' },
    );
    final result = await _repository.actualizarPeso(loteId, nuevoPeso);
    state = result.fold(
      (failure) => _error(failure.message),
      (lote) => LoteSuccess(
        lote: lote,
        mensaje: switch (Formatters.currentLocale) { 'es' => 'Peso actualizado', 'pt' => 'Peso atualizado', _ => 'Weight updated' },
      ),
    );
    return result;
  }

  /// Cambia el estado del lote.
  Future<Either<Failure, Lote>> cambiarEstado(
    String loteId,
    EstadoLote nuevoEstado, {
    String? motivo,
  }) async {
    state = _loading(
      switch (Formatters.currentLocale) { 'es' => 'Cambiando estado...', 'pt' => 'Alterando estado...', _ => 'Changing status...' },
    );
    final result = await _repository.cambiarEstado(
      loteId,
      nuevoEstado,
      motivo: motivo,
    );
    state = result.fold(
      (failure) => _error(failure.message),
      (lote) => LoteSuccess(
        lote: lote,
        mensaje: switch (Formatters.currentLocale) { 'es' => 'Estado cambiado a ${nuevoEstado.displayName}', 'pt' => 'Estado alterado para ${nuevoEstado.displayName}', _ => 'Status changed to ${nuevoEstado.displayName}' },
      ),
    );
    return result;
  }

  /// Cierra un lote.
  Future<Either<Failure, Lote>> cerrar(String loteId, {String? motivo}) async {
    state = _loading(
      switch (Formatters.currentLocale) { 'es' => 'Cerrando lote...', 'pt' => 'Fechando lote...', _ => 'Closing batch...' },
    );
    final result = await _repository.cerrar(loteId, motivo: motivo);
    state = result.fold(
      (failure) => _error(failure.message),
      (lote) => LoteSuccess(
        lote: lote,
        mensaje: switch (Formatters.currentLocale) { 'es' => 'Lote cerrado exitosamente', 'pt' => 'Lote fechado com sucesso', _ => 'Batch closed successfully' },
      ),
    );
    return result;
  }

  /// Marca un lote como vendido.
  Future<Either<Failure, Lote>> marcarVendido(
    String loteId, {
    String? comprador,
  }) async {
    state = _loading(
      switch (Formatters.currentLocale) { 'es' => 'Registrando venta completa...', 'pt' => 'Registrando venda completa...', _ => 'Recording full sale...' },
    );
    final result = await _repository.marcarVendido(
      loteId,
      comprador: comprador,
    );
    state = result.fold(
      (failure) => _error(failure.message),
      (lote) => LoteSuccess(
        lote: lote,
        mensaje: switch (Formatters.currentLocale) { 'es' => 'Lote marcado como vendido', 'pt' => 'Lote marcado como vendido', _ => 'Batch marked as sold' },
      ),
    );
    return result;
  }

  /// Transfiere un lote a otro galpón.
  Future<Either<Failure, Lote>> transferir(
    String loteId,
    String nuevoGalponId,
  ) async {
    state = _loading(
      switch (Formatters.currentLocale) { 'es' => 'Transfiriendo lote...', 'pt' => 'Transferindo lote...', _ => 'Transferring batch...' },
    );
    final result = await _repository.transferir(loteId, nuevoGalponId);
    state = result.fold(
      (failure) => _error(failure.message),
      (lote) => LoteSuccess(
        lote: lote,
        mensaje: switch (Formatters.currentLocale) { 'es' => 'Lote transferido exitosamente', 'pt' => 'Lote transferido com sucesso', _ => 'Batch transferred successfully' },
      ),
    );
    return result;
  }

  /// Reinicia el estado.
  void reset() {
    state = const LoteInitial();
  }
}
