import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartgranjaavespro/core/utils/formatters.dart';
import '../../domain/enums/estado_galpon.dart';
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
