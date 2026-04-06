import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartgranjaavespro/core/errors/error_messages.dart';
import 'package:smartgranjaavespro/core/utils/formatters.dart';
import '../../domain/entities/galpon.dart';
import '../../domain/enums/estado_galpon.dart';
import '../../domain/enums/tipo_galpon.dart';
import '../../domain/usecases/usecases.dart';
import '../state/galpon_state.dart';

// =============================================================================
// GALPON NOTIFIER - Maneja operaciones CRUD y estado principal
// =============================================================================

class GalponNotifier extends StateNotifier<GalponState> {
  GalponNotifier({
    required CrearGalponUseCase crearUseCase,
    required ActualizarGalponUseCase actualizarUseCase,
    required EliminarGalponUseCase eliminarUseCase,
    required CambiarEstadoUseCase cambiarEstadoUseCase,
    required AsignarLoteUseCase asignarLoteUseCase,
    required LiberarGalponUseCase liberarUseCase,
    required ProgramarMantenimientoUseCase programarMantenimientoUseCase,
    required RegistrarDesinfeccionUseCase registrarDesinfeccionUseCase,
  }) : _crearUseCase = crearUseCase,
       _actualizarUseCase = actualizarUseCase,
       _eliminarUseCase = eliminarUseCase,
       _cambiarEstadoUseCase = cambiarEstadoUseCase,
       _asignarLoteUseCase = asignarLoteUseCase,
       _liberarUseCase = liberarUseCase,
       _programarMantenimientoUseCase = programarMantenimientoUseCase,
       _registrarDesinfeccionUseCase = registrarDesinfeccionUseCase,
       super(const GalponInitial());

  final CrearGalponUseCase _crearUseCase;
  final ActualizarGalponUseCase _actualizarUseCase;
  final EliminarGalponUseCase _eliminarUseCase;
  final CambiarEstadoUseCase _cambiarEstadoUseCase;
  final AsignarLoteUseCase _asignarLoteUseCase;
  final LiberarGalponUseCase _liberarUseCase;
  final ProgramarMantenimientoUseCase _programarMantenimientoUseCase;
  final RegistrarDesinfeccionUseCase _registrarDesinfeccionUseCase;

  GalponLoading _loading(String mensaje) => GalponLoading(
    mensaje: mensaje,
    galpon: state.galpon,
    galpones: state.galpones.isNotEmpty ? state.galpones : null,
  );

  GalponError _error(String mensaje, {String? code}) => GalponError(
    mensaje: mensaje,
    code: code,
    galpon: state.galpon,
    galpones: state.galpones.isNotEmpty ? state.galpones : null,
  );

  /// Crea un nuevo galpón.
  Future<void> crearGalpon(CrearGalponParams params) async {
    final locale = Formatters.currentLocale;
    state = _loading(switch (locale) { 'es' => 'Creando galpón...', 'pt' => 'Criando galpão...', _ => 'Creating house...' });

    final resultado = await _crearUseCase(params);

    resultado.fold(
      (failure) => state = _error(failure.message, code: failure.code),
      (nuevoGalpon) => state = GalponSuccess(
        galpon: nuevoGalpon,
        mensaje: switch (locale) { 'es' => 'Galpón creado exitosamente', 'pt' => 'Galpão criado com sucesso', _ => 'House created successfully' },
      ),
    );
  }

  /// Actualiza un galpón existente.
  Future<void> actualizarGalpon(ActualizarGalponParams params) async {
    final locale = Formatters.currentLocale;
    state = _loading(switch (locale) { 'es' => 'Actualizando galpón...', 'pt' => 'Atualizando galpão...', _ => 'Updating house...' });

    final resultado = await _actualizarUseCase(params);

    resultado.fold(
      (failure) => state = _error(failure.message, code: failure.code),
      (galponActualizado) => state = GalponSuccess(
        galpon: galponActualizado,
        mensaje: switch (locale) { 'es' => 'Galpón actualizado exitosamente', 'pt' => 'Galpão atualizado com sucesso', _ => 'House updated successfully' },
      ),
    );
  }

  /// Elimina un galpón.
  Future<void> eliminarGalpon(String id, {bool forzar = false}) async {
    final locale = Formatters.currentLocale;
    state = _loading(switch (locale) { 'es' => 'Eliminando galpón...', 'pt' => 'Excluindo galpão...', _ => 'Deleting house...' });

    final resultado = await _eliminarUseCase(
      EliminarGalponParams(id: id, forzar: forzar),
    );

    resultado.fold(
      (failure) => state = _error(failure.message, code: failure.code),
      (_) => state = GalponDeleted(
        mensaje: switch (locale) { 'es' => 'Galpón eliminado exitosamente', 'pt' => 'Galpão excluído com sucesso', _ => 'House deleted successfully' },
      ),
    );
  }

  /// Cambia el estado de un galpón.
  Future<void> cambiarEstado(
    String galponId,
    EstadoGalpon nuevoEstado, {
    String? motivo,
    bool forzar = false,
  }) async {
    final locale = Formatters.currentLocale;
    state = _loading(switch (locale) { 'es' => 'Cambiando estado...', 'pt' => 'Alterando estado...', _ => 'Changing status...' });

    final resultado = await _cambiarEstadoUseCase(
      CambiarEstadoParams(
        galponId: galponId,
        nuevoEstado: nuevoEstado,
        motivo: motivo,
        forzar: forzar,
      ),
    );

    resultado.fold(
      (failure) => state = _error(failure.message, code: failure.code),
      (galpon) => state = GalponSuccess(
        galpon: galpon,
        mensaje: switch (locale) { 'es' => 'Estado cambiado a ${nuevoEstado.displayName}', 'pt' => 'Estado alterado para ${nuevoEstado.displayName}', _ => 'Status changed to ${nuevoEstado.displayName}' },
      ),
    );
  }

  /// Asigna un lote a un galpón.
  Future<void> asignarLote(String galponId, String loteId) async {
    final locale = Formatters.currentLocale;
    state = _loading(switch (locale) { 'es' => 'Asignando lote...', 'pt' => 'Atribuindo lote...', _ => 'Assigning batch...' });

    final resultado = await _asignarLoteUseCase(
      AsignarLoteParams(galponId: galponId, loteId: loteId),
    );

    resultado.fold(
      (failure) => state = _error(failure.message, code: failure.code),
      (galpon) => state = GalponSuccess(
        galpon: galpon,
        mensaje: switch (locale) { 'es' => 'Lote asignado exitosamente', 'pt' => 'Lote atribuído com sucesso', _ => 'Batch assigned successfully' },
      ),
    );
  }

  /// Libera un galpón de su lote asignado.
  Future<void> liberarGalpon(
    String galponId, {
    bool requiereDesinfeccion = true,
  }) async {
    final locale = Formatters.currentLocale;
    state = _loading(switch (locale) { 'es' => 'Liberando galpón...', 'pt' => 'Liberando galpão...', _ => 'Releasing house...' });

    final resultado = await _liberarUseCase(
      LiberarGalponParams(
        galponId: galponId,
        requiereDesinfeccion: requiereDesinfeccion,
      ),
    );

    resultado.fold(
      (failure) => state = _error(failure.message, code: failure.code),
      (galpon) => state = GalponSuccess(
        galpon: galpon,
        mensaje: switch (locale) { 'es' => 'Galpón liberado exitosamente', 'pt' => 'Galpão liberado com sucesso', _ => 'House released successfully' },
      ),
    );
  }

  /// Programa mantenimiento para un galpón.
  Future<void> programarMantenimiento(
    String galponId,
    DateTime fechaInicio,
    String descripcion, {
    bool forzar = false,
  }) async {
    final locale = Formatters.currentLocale;
    state = _loading(
      switch (locale) { 'es' => 'Programando mantenimiento...', 'pt' => 'Programando manutenção...', _ => 'Scheduling maintenance...' },
    );

    final resultado = await _programarMantenimientoUseCase(
      ProgramarMantenimientoParams(
        galponId: galponId,
        fechaInicio: fechaInicio,
        descripcion: descripcion,
        forzar: forzar,
      ),
    );

    resultado.fold(
      (failure) => state = _error(failure.message, code: failure.code),
      (galpon) => state = GalponSuccess(
        galpon: galpon,
        mensaje: switch (locale) { 'es' => 'Mantenimiento programado', 'pt' => 'Manutenção programada', _ => 'Maintenance scheduled' },
      ),
    );
  }

  /// Registra desinfección de un galpón.
  Future<void> registrarDesinfeccion(
    String galponId,
    DateTime fechaDesinfeccion,
    List<String> productos, {
    String? observaciones,
    bool forzar = false,
  }) async {
    final locale = Formatters.currentLocale;
    state = _loading(
      switch (locale) { 'es' => 'Registrando desinfección...', 'pt' => 'Registrando desinfecção...', _ => 'Registering disinfection...' },
    );

    final resultado = await _registrarDesinfeccionUseCase(
      RegistrarDesinfeccionParams(
        galponId: galponId,
        fechaDesinfeccion: fechaDesinfeccion,
        productos: productos,
        observaciones: observaciones,
        forzar: forzar,
      ),
    );

    resultado.fold(
      (failure) => state = _error(failure.message, code: failure.code),
      (galpon) => state = GalponSuccess(
        galpon: galpon,
        mensaje: switch (locale) { 'es' => 'Desinfección registrada', 'pt' => 'Desinfecção registrada', _ => 'Disinfection registered' },
      ),
    );
  }

  /// Reinicia el estado al inicial.
  void resetear() {
    state = const GalponInitial();
  }
}

// =============================================================================
// GALPON SEARCH NOTIFIER - Maneja la búsqueda de galpones
// =============================================================================

class GalponSearchNotifier extends StateNotifier<GalponSearchState> {
  GalponSearchNotifier({
    required ObtenerPorGranjaUseCase obtenerPorGranjaUseCase,
    required ObtenerDisponiblesUseCase obtenerDisponiblesUseCase,
  }) : _obtenerPorGranjaUseCase = obtenerPorGranjaUseCase,
       _obtenerDisponiblesUseCase = obtenerDisponiblesUseCase,
       super(GalponSearchState.initial());

  final ObtenerPorGranjaUseCase _obtenerPorGranjaUseCase;
  final ObtenerDisponiblesUseCase _obtenerDisponiblesUseCase;

  List<Galpon> _todosLosGalpones = [];

  /// Carga todos los galpones de una granja.
  Future<void> cargarGalpones(String granjaId) async {
    state = state.copyWith(isSearching: true);

    final resultado = await _obtenerPorGranjaUseCase(
      ObtenerPorGranjaParams(granjaId: granjaId),
    );

    resultado.fold(
      (failure) => state = state.copyWith(
        isSearching: false,
        errorMessage: failure.message,
      ),
      (galpones) {
        _todosLosGalpones = galpones;
        state = state.copyWith(
          isSearching: false,
          results: _aplicarFiltros(galpones),
        );
      },
    );
  }

  /// Carga galpones disponibles de una granja.
  Future<void> cargarDisponibles(String granjaId) async {
    state = state.copyWith(isSearching: true);

    final resultado = await _obtenerDisponiblesUseCase(
      ObtenerDisponiblesParams(granjaId: granjaId),
    );

    resultado.fold(
      (failure) => state = state.copyWith(
        isSearching: false,
        errorMessage: failure.message,
      ),
      (galpones) {
        _todosLosGalpones = galpones;
        state = state.copyWith(
          isSearching: false,
          results: _aplicarFiltros(galpones),
        );
      },
    );
  }

  /// Actualiza el término de búsqueda.
  void actualizarTermino(String query) {
    state = state.copyWith(query: query);
    _filtrar();
  }

  /// Aplica filtro por estado.
  void filtrarPorEstado(EstadoGalpon? estado) {
    state = estado == null
        ? state.clearEstadoFiltro()
        : state.copyWith(estadoFiltro: estado);
    _filtrar();
  }

  /// Aplica los filtros activos.
  void _filtrar() {
    final filtrados = _aplicarFiltros(_todosLosGalpones);
    state = state.copyWith(results: filtrados);
  }

  /// Aplica todos los filtros a una lista de galpones.
  List<Galpon> _aplicarFiltros(List<Galpon> galpones) {
    var resultado = galpones;

    // Filtrar por término de búsqueda
    if (state.query.isNotEmpty) {
      final queryLower = state.query.toLowerCase();
      resultado = resultado.where((g) {
        return g.nombre.toLowerCase().contains(queryLower) ||
            g.codigo.toLowerCase().contains(queryLower) ||
            (g.descripcion?.toLowerCase().contains(queryLower) ?? false);
      }).toList();
    }

    // Filtrar por estado
    if (state.estadoFiltro != null) {
      resultado = resultado
          .where((g) => g.estado == state.estadoFiltro)
          .toList();
    }

    return resultado;
  }

  /// Limpia la búsqueda.
  void limpiar() {
    state = GalponSearchState.initial().copyWith(results: _todosLosGalpones);
  }
}

// =============================================================================
// GALPON FORM NOTIFIER - Maneja el estado del formulario
// =============================================================================

class GalponFormNotifier extends StateNotifier<GalponFormState> {
  GalponFormNotifier() : super(GalponFormState.initial());

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

  /// Va a un paso específico.
  void irAPaso(int paso) {
    if (paso >= 0 && paso < state.totalSteps) {
      state = state.copyWith(currentStep: paso);
    }
  }

  /// Actualiza el código.
  void actualizarCodigo(String valor) {
    state = state.copyWith(codigo: valor);
    _validar();
  }

  /// Actualiza el nombre.
  void actualizarNombre(String valor) {
    state = state.copyWith(nombre: valor);
    _validar();
  }

  /// Actualiza el tipo.
  void actualizarTipo(TipoGalpon tipo) {
    state = state.copyWith(tipo: tipo.toJson());
    _validar();
  }

  /// Actualiza la capacidad máxima.
  void actualizarCapacidadMaxima(int? valor) {
    state = state.copyWith(capacidadMaxima: valor);
    _validar();
  }

  /// Actualiza el área.
  void actualizarArea(double? valor) {
    state = state.copyWith(areaM2: valor);
  }

  /// Actualiza la descripción.
  void actualizarDescripcion(String? valor) {
    state = state.copyWith(descripcion: valor);
  }

  /// Actualiza la ubicación.
  void actualizarUbicacion(String? valor) {
    state = state.copyWith(ubicacion: valor);
  }

  /// Actualiza el número de corrales.
  void actualizarNumeroCorrales(int? valor) {
    state = state.copyWith(numeroCorrales: valor);
  }

  /// Actualiza el sistema de bebederos.
  void actualizarSistemaBebederos(String? valor) {
    state = state.copyWith(sistemaBebederos: valor);
  }

  /// Actualiza el sistema de comederos.
  void actualizarSistemaComederos(String? valor) {
    state = state.copyWith(sistemaComederos: valor);
  }

  /// Actualiza el sistema de ventilación.
  void actualizarSistemaVentilacion(String? valor) {
    state = state.copyWith(sistemaVentilacion: valor);
  }

  /// Actualiza el sistema de calefacción.
  void actualizarSistemaCalefaccion(String? valor) {
    state = state.copyWith(sistemaCalefaccion: valor);
  }

  /// Actualiza el sistema de iluminación.
  void actualizarSistemaIluminacion(String? valor) {
    state = state.copyWith(sistemaIluminacion: valor);
  }

  /// Actualiza si tiene balanza.
  void actualizarTieneBalanza(bool valor) {
    state = state.copyWith(tieneBalanza: valor);
  }

  /// Actualiza sensor de temperatura.
  void actualizarSensorTemperatura(bool valor) {
    state = state.copyWith(sensorTemperatura: valor);
  }

  /// Actualiza sensor de humedad.
  void actualizarSensorHumedad(bool valor) {
    state = state.copyWith(sensorHumedad: valor);
  }

  /// Actualiza sensor de CO2.
  void actualizarSensorCO2(bool valor) {
    state = state.copyWith(sensorCO2: valor);
  }

  /// Actualiza sensor de amoníaco.
  void actualizarSensorAmoniaco(bool valor) {
    state = state.copyWith(sensorAmoniaco: valor);
  }

  /// Carga un galpón existente para edición.
  void cargarGalpon(Galpon galpon) {
    state = GalponFormState.edit(galpon);
  }

  /// Reinicia el formulario.
  void reiniciar() {
    state = GalponFormState.initial();
  }

  /// Valida el formulario.
  void _validar() {
    String? codigoError;
    String? nombreError;
    String? tipoError;
    String? capacidadError;

    // Validar código
    if (state.codigo == null || state.codigo!.trim().isEmpty) {
      codigoError = ErrorMessages.get('GALPON_FORM_CODIGO_REQUERIDO');
    } else if (state.codigo!.trim().length < 2) {
      codigoError = ErrorMessages.get('GALPON_FORM_CODIGO_MIN');
    }

    // Validar nombre
    if (state.nombre == null || state.nombre!.trim().isEmpty) {
      nombreError = ErrorMessages.get('GALPON_FORM_NOMBRE_REQUERIDO');
    } else if (state.nombre!.trim().length < 3) {
      nombreError = ErrorMessages.get('GALPON_FORM_NOMBRE_MIN');
    }

    // Validar tipo
    if (state.tipo == null || state.tipo!.isEmpty) {
      tipoError = ErrorMessages.get('GALPON_FORM_TIPO_REQUERIDO');
    }

    // Validar capacidad
    if (state.capacidadMaxima == null || state.capacidadMaxima! <= 0) {
      capacidadError = ErrorMessages.get('GALPON_FORM_CAPACIDAD_POSITIVA');
    }

    final esValido =
        codigoError == null &&
        nombreError == null &&
        tipoError == null &&
        capacidadError == null;

    state = state.copyWith(
      isValid: esValido,
      codigoError: codigoError,
      nombreError: nombreError,
      tipoError: tipoError,
      capacidadError: capacidadError,
    );
  }
}

// =============================================================================
// GALPON STATS NOTIFIER - Maneja estadísticas de galpones
// =============================================================================

class GalponStatsNotifier extends StateNotifier<GalponStatsState> {
  GalponStatsNotifier({
    required ObtenerEstadisticasUseCase obtenerEstadisticasUseCase,
  }) : _obtenerEstadisticasUseCase = obtenerEstadisticasUseCase,
       super(GalponStatsState.initial());

  final ObtenerEstadisticasUseCase _obtenerEstadisticasUseCase;

  /// Carga las estadísticas de una granja.
  Future<void> cargarEstadisticas(String granjaId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final resultado = await _obtenerEstadisticasUseCase(
      ObtenerEstadisticasParams(granjaId: granjaId),
    );

    resultado.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (estadisticas) => state = GalponStatsState(
        totalGalpones: estadisticas.total,
        galponesActivos: estadisticas.activos,
        galponesDisponibles: estadisticas.disponibles,
        galponesOcupados: estadisticas.ocupados,
        galponesEnMantenimiento: estadisticas.enMantenimiento,
        galponesEnDesinfeccion: estadisticas.enDesinfeccion,
        galponesEnCuarentena: estadisticas.enCuarentena,
        galponesInactivos: estadisticas.inactivos,
        capacidadTotal: estadisticas.capacidadTotal,
        avesActuales: estadisticas.avesActuales,
        areaTotalM2: estadisticas.areaTotal,
      ),
    );
  }

  /// Reinicia las estadísticas.
  void reiniciar() {
    state = GalponStatsState.initial();
  }
}
