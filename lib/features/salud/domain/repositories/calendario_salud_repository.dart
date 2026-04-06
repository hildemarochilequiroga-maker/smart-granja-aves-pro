/// Repositorio para eventos del calendario de salud.
library;

import '../entities/entities.dart';

/// Repositorio abstracto para gestión del calendario de salud.
abstract class CalendarioSaludRepository {
  /// Obtiene todos los eventos de una granja.
  Future<List<EventoSalud>> obtenerEventos(String granjaId);

  /// Obtiene un evento por su ID.
  Future<EventoSalud?> obtenerEventoPorId(String id);

  /// Obtiene eventos por rango de fechas.
  Future<List<EventoSalud>> obtenerEventosPorFecha({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  /// Obtiene eventos por lote.
  Future<List<EventoSalud>> obtenerEventosPorLote(String loteId);

  /// Obtiene eventos por tipo.
  Future<List<EventoSalud>> obtenerEventosPorTipo(
    String granjaId,
    TipoEventoSalud tipo,
  );

  /// Obtiene eventos pendientes.
  Future<List<EventoSalud>> obtenerEventosPendientes(String granjaId);

  /// Obtiene eventos vencidos.
  Future<List<EventoSalud>> obtenerEventosVencidos(String granjaId);

  /// Obtiene eventos próximos (7 días).
  Future<List<EventoSalud>> obtenerEventosProximos(String granjaId);

  /// Obtiene el calendario completo de un período.
  Future<CalendarioSalud> obtenerCalendario({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  /// Crea un nuevo evento.
  Future<void> crearEvento(EventoSalud evento);

  /// Actualiza un evento existente.
  Future<void> actualizarEvento(EventoSalud evento);

  /// Marca un evento como completado.
  Future<void> completarEvento({
    required String eventoId,
    required String ejecutadoPor,
    String? observaciones,
  });

  /// Cancela un evento.
  Future<void> cancelarEvento({
    required String eventoId,
    required String motivo,
  });

  /// Reprograma un evento.
  Future<void> reprogramarEvento({
    required String eventoId,
    required DateTime nuevaFecha,
    String? motivo,
  });

  /// Elimina un evento.
  Future<void> eliminarEvento(String id);

  /// Crea eventos desde un programa de vacunación.
  Future<void> crearEventosDesdePrograma({
    required String granjaId,
    required String loteId,
    required String programaId,
    required DateTime fechaInicio,
    required String creadoPor,
  });

  /// Escucha cambios en los eventos de una granja.
  Stream<List<EventoSalud>> watchEventos(String granjaId);

  /// Escucha eventos próximos en tiempo real.
  Stream<List<EventoSalud>> watchEventosProximos(String granjaId);
}
