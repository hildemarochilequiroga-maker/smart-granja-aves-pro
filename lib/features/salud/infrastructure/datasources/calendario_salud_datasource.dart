/// Datasource de Firestore para eventos del calendario de salud.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/error_messages.dart';
import '../../domain/entities/entities.dart';

/// Datasource para gestión de eventos de salud en Firestore.
class CalendarioSaludDatasource {
  final FirebaseFirestore _firestore;

  CalendarioSaludDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _eventosCollection(
    String granjaId,
  ) {
    return _firestore
        .collection('granjas')
        .doc(granjaId)
        .collection('eventos_salud');
  }

  /// Obtiene todos los eventos de una granja.
  Future<List<EventoSalud>> obtenerEventos(String granjaId) async {
    try {
      final snapshot = await _eventosCollection(
        granjaId,
      ).orderBy('fechaProgramada', descending: false).limit(500).get();

      return snapshot.docs.map((doc) => _mapToEventoSalud(doc)).toList();
    } on Exception catch (e) {
      throw Exception(
        ErrorMessages.format('ERR_GET_HEALTH_EVENTS', {'e': '$e'}),
      );
    }
  }

  /// Obtiene eventos por rango de fechas.
  Future<List<EventoSalud>> obtenerEventosPorFecha({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    try {
      final snapshot = await _eventosCollection(granjaId)
          .where(
            'fechaProgramada',
            isGreaterThanOrEqualTo: Timestamp.fromDate(fechaInicio),
          )
          .where(
            'fechaProgramada',
            isLessThanOrEqualTo: Timestamp.fromDate(fechaFin),
          )
          .orderBy('fechaProgramada')
          .get();

      return snapshot.docs.map((doc) => _mapToEventoSalud(doc)).toList();
    } on Exception catch (e) {
      throw Exception(
        ErrorMessages.format('ERR_GET_EVENTS_BY_DATE', {'e': '$e'}),
      );
    }
  }

  /// Obtiene eventos por lote.
  Future<List<EventoSalud>> obtenerEventosPorLote(
    String granjaId,
    String loteId,
  ) async {
    try {
      final snapshot = await _eventosCollection(granjaId)
          .where('loteId', isEqualTo: loteId)
          .orderBy('fechaProgramada')
          .limit(500)
          .get();

      return snapshot.docs.map((doc) => _mapToEventoSalud(doc)).toList();
    } on Exception catch (e) {
      throw Exception(
        ErrorMessages.format('ERR_GET_EVENTS_BY_BATCH', {'e': '$e'}),
      );
    }
  }

  /// Obtiene eventos por tipo.
  Future<List<EventoSalud>> obtenerEventosPorTipo(
    String granjaId,
    TipoEventoSalud tipo,
  ) async {
    try {
      final snapshot = await _eventosCollection(granjaId)
          .where('tipo', isEqualTo: tipo.toJson())
          .orderBy('fechaProgramada')
          .get();

      return snapshot.docs.map((doc) => _mapToEventoSalud(doc)).toList();
    } on Exception catch (e) {
      throw Exception(
        ErrorMessages.format('ERR_GET_EVENTS_BY_TYPE', {'e': '$e'}),
      );
    }
  }

  /// Obtiene eventos pendientes.
  Future<List<EventoSalud>> obtenerEventosPendientes(String granjaId) async {
    try {
      final snapshot = await _eventosCollection(granjaId)
          .where('estado', isEqualTo: EstadoEventoSalud.pendiente.toJson())
          .orderBy('fechaProgramada')
          .get();

      return snapshot.docs.map((doc) => _mapToEventoSalud(doc)).toList();
    } on Exception catch (e) {
      throw Exception(
        ErrorMessages.format('ERR_GET_PENDING_EVENTS', {'e': '$e'}),
      );
    }
  }

  /// Obtiene eventos vencidos.
  Future<List<EventoSalud>> obtenerEventosVencidos(String granjaId) async {
    try {
      final ahora = DateTime.now();
      final snapshot = await _eventosCollection(granjaId)
          .where('estado', isEqualTo: EstadoEventoSalud.pendiente.toJson())
          .where('fechaProgramada', isLessThan: Timestamp.fromDate(ahora))
          .get();

      return snapshot.docs.map((doc) => _mapToEventoSalud(doc)).toList();
    } on Exception catch (e) {
      throw Exception(
        ErrorMessages.format('ERR_GET_OVERDUE_EVENTS', {'e': '$e'}),
      );
    }
  }

  /// Obtiene eventos próximos (7 días).
  Future<List<EventoSalud>> obtenerEventosProximos(String granjaId) async {
    try {
      final ahora = DateTime.now();
      final enSieteDias = ahora.add(const Duration(days: 7));
      final snapshot = await _eventosCollection(granjaId)
          .where('estado', isEqualTo: EstadoEventoSalud.pendiente.toJson())
          .where(
            'fechaProgramada',
            isGreaterThanOrEqualTo: Timestamp.fromDate(ahora),
          )
          .where(
            'fechaProgramada',
            isLessThanOrEqualTo: Timestamp.fromDate(enSieteDias),
          )
          .orderBy('fechaProgramada')
          .get();

      return snapshot.docs.map((doc) => _mapToEventoSalud(doc)).toList();
    } on Exception catch (e) {
      throw Exception(
        ErrorMessages.format('ERR_GET_UPCOMING_EVENTS', {'e': '$e'}),
      );
    }
  }

  /// Crea un nuevo evento.
  Future<void> crearEvento(String granjaId, EventoSalud evento) async {
    try {
      await _eventosCollection(
        granjaId,
      ).doc(evento.id).set(_eventoToMap(evento));
    } on Exception catch (e) {
      throw Exception(ErrorMessages.format('ERR_CREATING_EVENT', {'e': '$e'}));
    }
  }

  /// Actualiza un evento existente.
  Future<void> actualizarEvento(String granjaId, EventoSalud evento) async {
    try {
      await _eventosCollection(
        granjaId,
      ).doc(evento.id).update(_eventoToMap(evento));
    } on Exception catch (e) {
      throw Exception(
        ErrorMessages.format('ERR_UPDATE_HEALTH_EVENT', {'e': '$e'}),
      );
    }
  }

  /// Marca un evento como completado.
  Future<void> completarEvento({
    required String granjaId,
    required String eventoId,
    required String ejecutadoPor,
    String? observaciones,
  }) async {
    try {
      await _eventosCollection(granjaId).doc(eventoId).update({
        'estado': EstadoEventoSalud.completado.toJson(),
        'fechaEjecucion': Timestamp.fromDate(DateTime.now()),
        'ejecutadoPor': ejecutadoPor,
        'observaciones': observaciones,
      });
    } on Exception catch (e) {
      throw Exception(
        ErrorMessages.format('ERR_COMPLETING_EVENT', {'e': '$e'}),
      );
    }
  }

  /// Cancela un evento.
  Future<void> cancelarEvento({
    required String granjaId,
    required String eventoId,
    required String motivo,
  }) async {
    try {
      await _eventosCollection(granjaId).doc(eventoId).update({
        'estado': EstadoEventoSalud.cancelado.toJson(),
        'observaciones': motivo,
      });
    } on Exception catch (e) {
      throw Exception(ErrorMessages.format('ERR_CANCELING_EVENT', {'e': '$e'}));
    }
  }

  /// Elimina un evento.
  Future<void> eliminarEvento(String granjaId, String eventoId) async {
    try {
      await _eventosCollection(granjaId).doc(eventoId).delete();
    } on Exception catch (e) {
      throw Exception(ErrorMessages.format('ERR_DELETING_EVENT', {'e': '$e'}));
    }
  }

  /// Escucha cambios en los eventos de una granja.
  Stream<List<EventoSalud>> watchEventos(String granjaId) {
    return _eventosCollection(granjaId)
        .orderBy('fechaProgramada')
        .limit(200)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => _mapToEventoSalud(doc)).toList(),
        );
  }

  EventoSalud _mapToEventoSalud(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return EventoSalud(
      id: doc.id,
      granjaId: data['granjaId'] as String? ?? '',
      galponId: data['galponId'] as String?,
      loteId: data['loteId'] as String?,
      tipo: TipoEventoSalud.fromJson(data['tipo'] as String? ?? 'vacunacion'),
      titulo: data['titulo'] as String? ?? 'Sin título',
      descripcion: data['descripcion'] as String?,
      fechaProgramada:
          (data['fechaProgramada'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fechaEjecucion: (data['fechaEjecucion'] as Timestamp?)?.toDate(),
      estado: EstadoEventoSalud.fromJson(
        data['estado'] as String? ?? 'pendiente',
      ),
      recordatorioHoras: data['recordatorioHoras'] as int? ?? 24,
      ejecutadoPor: data['ejecutadoPor'] as String?,
      observaciones: data['observaciones'] as String?,
      documentoAdjunto: data['documentoAdjunto'] as String?,
      prioridad: PrioridadEvento.fromJson(
        data['prioridad'] as String? ?? 'normal',
      ),
      creadoPor: data['creadoPor'] as String? ?? '',
      fechaCreacion:
          (data['fechaCreacion'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> _eventoToMap(EventoSalud evento) {
    return {
      'granjaId': evento.granjaId,
      'galponId': evento.galponId,
      'loteId': evento.loteId,
      'tipo': evento.tipo.toJson(),
      'titulo': evento.titulo,
      'descripcion': evento.descripcion,
      'fechaProgramada': Timestamp.fromDate(evento.fechaProgramada),
      'fechaEjecucion': evento.fechaEjecucion != null
          ? Timestamp.fromDate(evento.fechaEjecucion!)
          : null,
      'estado': evento.estado.toJson(),
      'recordatorioHoras': evento.recordatorioHoras,
      'ejecutadoPor': evento.ejecutadoPor,
      'observaciones': evento.observaciones,
      'documentoAdjunto': evento.documentoAdjunto,
      'prioridad': evento.prioridad.toJson(),
      'creadoPor': evento.creadoPor,
      'fechaCreacion': Timestamp.fromDate(evento.fechaCreacion),
    };
  }
}
