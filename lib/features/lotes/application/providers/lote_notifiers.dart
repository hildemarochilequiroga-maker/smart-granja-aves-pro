import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/lote.dart';
import '../../domain/enums/estado_lote.dart';
import '../../domain/enums/tipo_ave.dart';
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

// =============================================================================
// NOTIFIER DE FORMULARIO
// =============================================================================

/// Notifier para el formulario de lotes.
class LoteFormNotifier extends StateNotifier<LoteFormState> {
  LoteFormNotifier() : super(LoteFormState.initial());

  /// Inicializa para creación.
  void iniciarCreacion() {
    state = LoteFormState.initial();
  }

  /// Inicializa para edición.
  void iniciarEdicion(Lote lote) {
    state = LoteFormState.edit(lote);
  }

  /// Actualiza el código.
  void setCodigo(String? value) {
    state = state.copyWith(codigo: value, codigoError: _validarCodigo(value));
    _validarFormulario();
  }

  /// Actualiza el nombre.
  void setNombre(String? value) {
    state = state.copyWith(nombre: value);
    _validarFormulario();
  }

  /// Actualiza el tipo de ave.
  void setTipoAve(TipoAve? value) {
    state = state.copyWith(
      tipoAve: value,
      tipoAveError: value == null
          ? (switch (Formatters.currentLocale) { 'es' => 'Seleccione el tipo de ave', 'pt' => 'Selecione o tipo de ave', _ => 'Select bird type' })
          : null,
    );
    _validarFormulario();
  }

  /// Actualiza la cantidad inicial.
  void setCantidadInicial(int? value) {
    state = state.copyWith(
      cantidadInicial: value,
      cantidadError: _validarCantidad(value),
    );
    _validarFormulario();
  }

  /// Actualiza la fecha de ingreso.
  void setFechaIngreso(DateTime? value) {
    state = state.copyWith(
      fechaIngreso: value,
      fechaError: value == null
          ? (switch (Formatters.currentLocale) { 'es' => 'Seleccione la fecha de ingreso', 'pt' => 'Selecione a data de entrada', _ => 'Select entry date' })
          : null,
    );
    _validarFormulario();
  }

  /// Actualiza el proveedor.
  void setProveedor(String? value) {
    state = state.copyWith(proveedor: value);
  }

  /// Actualiza la raza.
  void setRaza(String? value) {
    state = state.copyWith(raza: value);
  }

  /// Actualiza la edad de ingreso.
  void setEdadIngresoDias(int value) {
    state = state.copyWith(edadIngresoDias: value);
  }

  /// Actualiza el peso promedio objetivo.
  void setPesoPromedioObjetivo(double? value) {
    state = state.copyWith(pesoPromedioObjetivo: value);
  }

  /// Actualiza la fecha de cierre estimada.
  void setFechaCierreEstimada(DateTime? value) {
    state = state.copyWith(fechaCierreEstimada: value);
  }

  /// Actualiza el costo por ave.
  void setCostoAveInicial(double? value) {
    state = state.copyWith(costoAveInicial: value);
  }

  /// Actualiza las observaciones.
  void setObservaciones(String? value) {
    state = state.copyWith(observaciones: value);
  }

  /// Avanza al siguiente paso.
  void siguientePaso() {
    if (state.currentStep < state.totalSteps - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  /// Retrocede al paso anterior.
  void pasoAnterior() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  /// Marca como enviando.
  void setSubmitting(bool value) {
    state = state.copyWith(isSubmitting: value);
  }

  /// Marca como exitoso.
  void setSuccess() {
    state = state.copyWith(isSuccess: true, isSubmitting: false);
  }

  /// Establece error.
  void setError(String mensaje) {
    state = state.copyWith(errorMessage: mensaje, isSubmitting: false);
  }

  /// Reinicia el formulario.
  void reset() {
    state = LoteFormState.initial();
  }

  // Validaciones privadas
  String? _validarCodigo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return switch (Formatters.currentLocale) { 'es' => 'El código es obligatorio', 'pt' => 'O código é obrigatório', _ => 'Code is required' };
    }
    if (value.length < 3) {
      return switch (Formatters.currentLocale) { 'es' => 'Mínimo 3 caracteres', 'pt' => 'Mínimo 3 caracteres', _ => 'Minimum 3 characters' };
    }
    return null;
  }

  String? _validarCantidad(int? value) {
    if (value == null || value <= 0) {
      return switch (Formatters.currentLocale) { 'es' => 'Ingrese una cantidad válida', 'pt' => 'Insira uma quantidade válida', _ => 'Enter a valid quantity' };
    }
    return null;
  }

  void _validarFormulario() {
    final isValid =
        state.codigo != null &&
        state.codigo!.isNotEmpty &&
        state.tipoAve != null &&
        state.cantidadInicial != null &&
        state.cantidadInicial! > 0 &&
        state.fechaIngreso != null &&
        !state.hasValidationErrors;

    state = state.copyWith(isValid: isValid);
  }
}

// =============================================================================
// NOTIFIER DE BÚSQUEDA
// =============================================================================

/// Notifier para búsqueda de lotes.
class LoteSearchNotifier extends StateNotifier<LoteSearchState> {
  LoteSearchNotifier({required LoteRepository repository})
    : _repository = repository,
      super(LoteSearchState.initial());

  final LoteRepository _repository;

  /// Busca lotes por query.
  Future<void> buscar(String granjaId, String query) async {
    state = state.copyWith(query: query, isSearching: true);

    if (query.isEmpty &&
        state.estadoFiltro == null &&
        state.tipoAveFiltro == null) {
      state = state.copyWith(results: [], isSearching: false);
      return;
    }

    final result = await _repository.buscar(granjaId, query);

    result.fold(
      (failure) => state = state.copyWith(
        errorMessage: failure.message,
        isSearching: false,
      ),
      (lotes) {
        var filtrados = lotes;

        // Aplicar filtro de estado
        if (state.estadoFiltro != null) {
          filtrados = filtrados
              .where((l) => l.estado == state.estadoFiltro)
              .toList();
        }

        // Aplicar filtro de tipo de ave
        if (state.tipoAveFiltro != null) {
          filtrados = filtrados
              .where((l) => l.tipoAve == state.tipoAveFiltro)
              .toList();
        }

        state = state.copyWith(results: filtrados, isSearching: false);
      },
    );
  }

  /// Filtra por estado.
  void filtrarPorEstado(EstadoLote? estado) {
    state = state.copyWith(estadoFiltro: estado);
  }

  /// Filtra por tipo de ave.
  void filtrarPorTipoAve(TipoAve? tipo) {
    state = state.copyWith(tipoAveFiltro: tipo);
  }

  /// Limpia todos los filtros.
  void limpiarFiltros() {
    state = state.clearFiltros();
  }

  /// Limpia la búsqueda.
  void limpiar() {
    state = LoteSearchState.initial();
  }
}

// =============================================================================
// NOTIFIER DE ESTADÍSTICAS
// =============================================================================

/// Notifier para estadísticas de lotes.
class LoteStatsNotifier extends StateNotifier<LoteStatsState> {
  LoteStatsNotifier({required LoteRepository repository})
    : _repository = repository,
      super(LoteStatsState.initial());

  final LoteRepository _repository;

  /// Carga las estadísticas de una granja.
  Future<void> cargar(String granjaId) async {
    state = state.copyWith(isLoading: true);

    final result = await _repository.obtenerEstadisticas(granjaId);

    result.fold(
      (failure) => state = state.copyWith(
        errorMessage: failure.message,
        isLoading: false,
      ),
      (stats) => state = state.copyWith(
        totalLotes: stats['totalLotes'] as int? ?? 0,
        lotesActivos: stats['lotesActivos'] as int? ?? 0,
        lotesCerrados: stats['lotesCerrados'] as int? ?? 0,
        totalAvesActuales: stats['totalAves'] as int? ?? 0,
        mortalidadPromedio: stats['mortalidadPromedio'] as double? ?? 0.0,
        isLoading: false,
      ),
    );
  }

  /// Reinicia las estadísticas.
  void reset() {
    state = LoteStatsState.initial();
  }
}
