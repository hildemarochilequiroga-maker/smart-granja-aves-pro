library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartgranjaavespro/core/utils/formatters.dart';
import '../../domain/domain.dart';
import '../state/state.dart';

// =============================================================================
// GRANJA NOTIFIER - Maneja operaciones CRUD y estado principal
// =============================================================================

class GranjaNotifier extends StateNotifier<GranjaState> {
  final CrearGranjaUseCase _crearUseCase;
  final ActualizarGranjaUseCase _actualizarUseCase;
  final EliminarGranjaUseCase _eliminarUseCase;
  final ActivarGranjaUseCase _activarUseCase;
  final SuspenderGranjaUseCase _suspenderUseCase;
  final PonerEnMantenimientoGranjaUseCase _ponerEnMantenimientoUseCase;
  final BuscarGranjasUseCase _buscarUseCase;

  GranjaNotifier({
    required CrearGranjaUseCase crearUseCase,
    required ActualizarGranjaUseCase actualizarUseCase,
    required EliminarGranjaUseCase eliminarUseCase,
    required ActivarGranjaUseCase activarUseCase,
    required SuspenderGranjaUseCase suspenderUseCase,
    required PonerEnMantenimientoGranjaUseCase ponerEnMantenimientoUseCase,
    required BuscarGranjasUseCase buscarUseCase,
  }) : _crearUseCase = crearUseCase,
       _actualizarUseCase = actualizarUseCase,
       _eliminarUseCase = eliminarUseCase,
       _activarUseCase = activarUseCase,
       _suspenderUseCase = suspenderUseCase,
       _ponerEnMantenimientoUseCase = ponerEnMantenimientoUseCase,
       _buscarUseCase = buscarUseCase,
       super(const GranjaInitial());

  GranjaLoading _loading(String mensaje) => GranjaLoading(
    mensaje: mensaje,
    granja: state.granja,
    granjas: state.granjas.isNotEmpty ? state.granjas : null,
  );

  GranjaError _error(String mensaje, {String? code}) => GranjaError(
    mensaje: mensaje,
    code: code,
    granja: state.granja,
    granjas: state.granjas.isNotEmpty ? state.granjas : null,
  );

  /// Crea una nueva granja
  Future<void> crearGranja(CrearGranjaParams params) async {
    final locale = Formatters.currentLocale;
    state = _loading(switch (locale) { 'es' => 'Creando granja...', 'pt' => 'Criando granja...', _ => 'Creating farm...' });

    final resultado = await _crearUseCase(params);

    resultado.fold(
      (failure) => state = _error(failure.message, code: failure.code),
      (nuevaGranja) => state = GranjaSuccess(
        granja: nuevaGranja,
        mensaje: switch (locale) { 'es' => 'Granja creada exitosamente', 'pt' => 'Granja criada com sucesso', _ => 'Farm created successfully' },
      ),
    );
  }

  /// Actualiza una granja existente
  Future<void> actualizarGranja(ActualizarGranjaParams params) async {
    final locale = Formatters.currentLocale;
    state = _loading(switch (locale) { 'es' => 'Actualizando granja...', 'pt' => 'Atualizando granja...', _ => 'Updating farm...' });

    final resultado = await _actualizarUseCase(params);

    resultado.fold(
      (failure) => state = _error(failure.message, code: failure.code),
      (granjaActualizada) => state = GranjaSuccess(
        granja: granjaActualizada,
        mensaje: switch (locale) { 'es' => 'Granja actualizada exitosamente', 'pt' => 'Granja atualizada com sucesso', _ => 'Farm updated successfully' },
      ),
    );
  }

  /// Elimina una granja
  Future<void> eliminarGranja(String id) async {
    final locale = Formatters.currentLocale;
    state = _loading(switch (locale) { 'es' => 'Eliminando granja...', 'pt' => 'Excluindo granja...', _ => 'Deleting farm...' });

    final resultado = await _eliminarUseCase(id);

    resultado.fold(
      (failure) => state = _error(failure.message, code: failure.code),
      (_) => state = GranjaDeleted(
        mensaje: switch (locale) { 'es' => 'Granja eliminada exitosamente', 'pt' => 'Granja excluída com sucesso', _ => 'Farm deleted successfully' },
      ),
    );
  }

  /// Activa una granja
  Future<void> activarGranja(String id) async {
    final locale = Formatters.currentLocale;
    state = _loading(switch (locale) { 'es' => 'Activando granja...', 'pt' => 'Ativando granja...', _ => 'Activating farm...' });

    final resultado = await _activarUseCase(id);

    resultado.fold(
      (failure) => state = _error(failure.message, code: failure.code),
      (granja) => state = GranjaSuccess(
        granja: granja,
        mensaje: switch (locale) { 'es' => 'Granja activada exitosamente', 'pt' => 'Granja ativada com sucesso', _ => 'Farm activated successfully' },
      ),
    );
  }

  /// Suspende una granja
  Future<void> suspenderGranja(String id, {String? razon}) async {
    final locale = Formatters.currentLocale;
    state = _loading(switch (locale) { 'es' => 'Suspendiendo granja...', 'pt' => 'Suspendendo granja...', _ => 'Suspending farm...' });

    final resultado = await _suspenderUseCase(
      SuspenderGranjaParams(granjaId: id, razon: razon),
    );

    resultado.fold(
      (failure) => state = _error(failure.message, code: failure.code),
      (granja) => state = GranjaSuccess(
        granja: granja,
        mensaje: switch (locale) { 'es' => 'Granja suspendida', 'pt' => 'Granja suspensa', _ => 'Farm suspended' },
      ),
    );
  }

  /// Pone una granja en mantenimiento
  Future<void> ponerEnMantenimiento(String id, {String? razon}) async {
    final locale = Formatters.currentLocale;
    state = _loading(
      switch (locale) { 'es' => 'Poniendo en mantenimiento...', 'pt' => 'Colocando em manutenção...', _ => 'Setting maintenance...' },
    );

    final resultado = await _ponerEnMantenimientoUseCase(
      PonerEnMantenimientoParams(granjaId: id, razon: razon),
    );

    resultado.fold(
      (failure) => state = _error(failure.message, code: failure.code),
      (granja) => state = GranjaSuccess(
        granja: granja,
        mensaje: switch (locale) { 'es' => 'Granja en mantenimiento', 'pt' => 'Granja em manutenção', _ => 'Farm in maintenance' },
      ),
    );
  }

  /// Busca granjas por término
  Future<void> buscarGranjas(String usuarioId, {String? nombre}) async {
    final locale = Formatters.currentLocale;
    state = _loading(switch (locale) { 'es' => 'Buscando granjas...', 'pt' => 'Buscando granjas...', _ => 'Searching farms...' });

    final resultado = await _buscarUseCase(
      BuscarGranjasParams(usuarioId: usuarioId, nombre: nombre),
    );

    resultado.fold(
      (failure) => state = _error(failure.message, code: failure.code),
      (granjas) => state = GranjasLoaded(granjas: granjas),
    );
  }

  /// Reinicia el estado al inicial
  void resetear() {
    state = const GranjaInitial();
  }
}

// =============================================================================
// GRANJA SEARCH NOTIFIER - Maneja la búsqueda de granjas
// =============================================================================

class GranjaSearchNotifier extends StateNotifier<GranjaSearchState> {
  final BuscarGranjasUseCase _buscarUseCase;

  GranjaSearchNotifier({required BuscarGranjasUseCase buscarUseCase})
    : _buscarUseCase = buscarUseCase,
      super(GranjaSearchState.initial());

  /// Actualiza el término de búsqueda
  void actualizarTermino(String query) {
    state = state.copyWith(query: query);
  }

  /// Ejecuta la búsqueda
  Future<void> buscar(String usuarioId) async {
    if (state.query.isEmpty) {
      state = state.copyWith(results: [], isSearching: false);
      return;
    }

    state = state.copyWith(isSearching: true, errorMessage: null);

    final resultado = await _buscarUseCase(
      BuscarGranjasParams(usuarioId: usuarioId, nombre: state.query),
    );

    resultado.fold(
      (failure) => state = state.copyWith(
        isSearching: false,
        errorMessage: failure.message,
        results: [],
      ),
      (granjas) => state = state.copyWith(isSearching: false, results: granjas),
    );
  }

  /// Limpia la búsqueda
  void limpiar() {
    state = GranjaSearchState.initial();
  }
}

// =============================================================================
// GRANJA FORM NOTIFIER - Maneja el estado del formulario
// =============================================================================

class GranjaFormNotifier extends StateNotifier<GranjaFormState> {
  GranjaFormNotifier() : super(GranjaFormState.initial());

  /// Actualiza el nombre
  void actualizarNombre(String valor) {
    state = state.copyWith(nombre: valor);
    _validar();
  }

  /// Actualiza el propietario
  void actualizarPropietario(String valor) {
    state = state.copyWith(propietario: valor);
    _validar();
  }

  /// Actualiza la dirección
  void actualizarDireccion(String valor) {
    state = state.copyWith(direccion: valor);
    _validar();
  }

  /// Actualiza el teléfono
  void actualizarTelefono(String valor) {
    state = state.copyWith(telefono: valor);
  }

  /// Actualiza el correo
  void actualizarCorreo(String valor) {
    state = state.copyWith(correo: valor);
    _validar();
  }

  /// Actualiza el RUC
  void actualizarRuc(String valor) {
    state = state.copyWith(ruc: valor);
    _validar();
  }

  /// Actualiza la capacidad
  void actualizarCapacidad(int? valor) {
    state = state.copyWith(capacidad: valor);
  }

  /// Actualiza el área
  void actualizarArea(double? valor) {
    state = state.copyWith(area: valor);
  }

  /// Carga una granja existente para edición
  void cargarGranja(Granja granja) {
    state = GranjaFormState.edit(granja);
  }

  /// Reinicia el formulario
  void reiniciar() {
    state = GranjaFormState.initial();
  }

  /// Valida el formulario
  void _validar() {
    String? nombreError;
    String? propietarioError;
    String? direccionError;
    String? correoError;
    String? rucError;

    // Validar nombre
    if (state.nombre == null || state.nombre!.trim().isEmpty) {
      nombreError = 'El nombre es requerido';
    } else if (state.nombre!.trim().length < 3) {
      nombreError = 'El nombre debe tener al menos 3 caracteres';
    }

    // Validar propietario
    if (state.propietario == null || state.propietario!.trim().isEmpty) {
      propietarioError = 'El propietario es requerido';
    }

    // Validar dirección
    if (state.direccion == null || state.direccion!.trim().isEmpty) {
      direccionError = 'La dirección es requerida';
    }

    // Validar correo si está presente
    if (state.correo != null && state.correo!.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(state.correo!)) {
        correoError = 'El correo no es válido';
      }
    }

    // Validar RUC si está presente
    if (state.ruc != null && state.ruc!.isNotEmpty) {
      if (state.ruc!.length != 11 || int.tryParse(state.ruc!) == null) {
        rucError = 'El RUC debe tener 11 dígitos numéricos';
      }
    }

    final esValido =
        nombreError == null &&
        propietarioError == null &&
        direccionError == null &&
        correoError == null &&
        rucError == null;

    state = state.copyWith(
      isValid: esValido,
      nombreError: nombreError,
      propietarioError: propietarioError,
      direccionError: direccionError,
      correoError: correoError,
      rucError: rucError,
    );
  }
}
