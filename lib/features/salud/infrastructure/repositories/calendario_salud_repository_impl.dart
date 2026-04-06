/// Implementación del repositorio de calendario de salud.
library;

import '../../../../core/errors/error_messages.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/calendario_salud_repository.dart';
import '../datasources/calendario_salud_datasource.dart';

/// Implementación del repositorio de calendario de salud.
class CalendarioSaludRepositoryImpl implements CalendarioSaludRepository {
  final CalendarioSaludDatasource _datasource;
  final String _granjaId;

  CalendarioSaludRepositoryImpl(this._datasource, this._granjaId);

  @override
  Future<List<EventoSalud>> obtenerEventos(String granjaId) async {
    return _datasource.obtenerEventos(granjaId);
  }

  @override
  Future<EventoSalud?> obtenerEventoPorId(String id) async {
    final eventos = await _datasource.obtenerEventos(_granjaId);
    try {
      return eventos.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<EventoSalud>> obtenerEventosPorFecha({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    return _datasource.obtenerEventosPorFecha(
      granjaId: granjaId,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
  }

  @override
  Future<List<EventoSalud>> obtenerEventosPorLote(String loteId) async {
    return _datasource.obtenerEventosPorLote(_granjaId, loteId);
  }

  @override
  Future<List<EventoSalud>> obtenerEventosPorTipo(
    String granjaId,
    TipoEventoSalud tipo,
  ) async {
    return _datasource.obtenerEventosPorTipo(granjaId, tipo);
  }

  @override
  Future<List<EventoSalud>> obtenerEventosPendientes(String granjaId) async {
    return _datasource.obtenerEventosPendientes(granjaId);
  }

  @override
  Future<List<EventoSalud>> obtenerEventosVencidos(String granjaId) async {
    return _datasource.obtenerEventosVencidos(granjaId);
  }

  @override
  Future<List<EventoSalud>> obtenerEventosProximos(String granjaId) async {
    return _datasource.obtenerEventosProximos(granjaId);
  }

  @override
  Future<CalendarioSalud> obtenerCalendario({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    final eventos = await _datasource.obtenerEventosPorFecha(
      granjaId: granjaId,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );

    return CalendarioSalud(
      granjaId: granjaId,
      eventos: eventos,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
  }

  @override
  Future<void> crearEvento(EventoSalud evento) async {
    await _datasource.crearEvento(_granjaId, evento);
  }

  @override
  Future<void> actualizarEvento(EventoSalud evento) async {
    await _datasource.actualizarEvento(_granjaId, evento);
  }

  @override
  Future<void> completarEvento({
    required String eventoId,
    required String ejecutadoPor,
    String? observaciones,
  }) async {
    await _datasource.completarEvento(
      granjaId: _granjaId,
      eventoId: eventoId,
      ejecutadoPor: ejecutadoPor,
      observaciones: observaciones,
    );
  }

  @override
  Future<void> cancelarEvento({
    required String eventoId,
    required String motivo,
  }) async {
    await _datasource.cancelarEvento(
      granjaId: _granjaId,
      eventoId: eventoId,
      motivo: motivo,
    );
  }

  @override
  Future<void> reprogramarEvento({
    required String eventoId,
    required DateTime nuevaFecha,
    String? motivo,
  }) async {
    final evento = await obtenerEventoPorId(eventoId);
    if (evento == null) {
      throw Exception(ErrorMessages.get('ERR_EVENT_NOT_FOUND'));
    }

    final eventoActualizado = evento.copyWith(
      fechaProgramada: nuevaFecha,
      observaciones: motivo ?? evento.observaciones,
    );

    await _datasource.actualizarEvento(_granjaId, eventoActualizado);
  }

  @override
  Future<void> eliminarEvento(String id) async {
    await _datasource.eliminarEvento(_granjaId, id);
  }

  @override
  Future<void> crearEventosDesdePrograma({
    required String granjaId,
    required String loteId,
    required String programaId,
    required DateTime fechaInicio,
    required String creadoPor,
  }) async {
    // Integración con ProgramaVacunacion pendiente
    // Se implementará cuando se conecten los servicios
    throw UnimplementedError(ErrorMessages.get('ERR_UNIMPLEMENTED_VACCINATION_INTEGRATION'));
  }

  @override
  Stream<List<EventoSalud>> watchEventos(String granjaId) {
    return _datasource.watchEventos(granjaId);
  }

  @override
  Stream<List<EventoSalud>> watchEventosProximos(String granjaId) {
    return _datasource.watchEventos(granjaId).map((eventos) {
      final ahora = DateTime.now();
      final enSieteDias = ahora.add(const Duration(days: 7));
      return eventos
          .where(
            (e) =>
                e.estaPendiente &&
                e.fechaProgramada.isAfter(ahora) &&
                e.fechaProgramada.isBefore(enSieteDias),
          )
          .toList();
    });
  }
}
