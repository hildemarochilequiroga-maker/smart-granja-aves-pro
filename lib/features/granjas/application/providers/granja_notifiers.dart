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
