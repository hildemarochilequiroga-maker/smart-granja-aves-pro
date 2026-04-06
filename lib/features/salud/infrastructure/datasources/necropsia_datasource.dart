/// Datasource de Firestore para registros de necropsias.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';

/// Datasource para gestión de necropsias en Firestore.
class NecropsiaDatasource {
  final FirebaseFirestore _firestore;

  NecropsiaDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _necropsiasCollection(
    String granjaId,
  ) {
    return _firestore
        .collection('granjas')
        .doc(granjaId)
        .collection('necropsias');
  }

  /// Obtiene todas las necropsias de una granja.
  Future<List<Necropsia>> obtenerNecropsias(String granjaId) async {
    try {
      final snapshot = await _necropsiasCollection(
        granjaId,
      ).orderBy('fecha', descending: true).limit(500).get();

      return snapshot.docs.map((doc) => _mapToNecropsia(doc)).toList();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  /// Obtiene necropsias por lote.
  Future<List<Necropsia>> obtenerNecropsiasPorlote(
    String granjaId,
    String loteId,
  ) async {
    try {
      final snapshot = await _necropsiasCollection(granjaId)
          .where('loteId', isEqualTo: loteId)
          .orderBy('fecha', descending: true)
          .limit(500)
          .get();

      return snapshot.docs.map((doc) => _mapToNecropsia(doc)).toList();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  /// Obtiene necropsias por enfermedad detectada.
  Future<List<Necropsia>> obtenerNecropsiaPorEnfermedad(
    String granjaId,
    EnfermedadAvicola enfermedad,
  ) async {
    try {
      final snapshot = await _necropsiasCollection(granjaId)
          .where('enfermedadDetectada', isEqualTo: enfermedad.toJson())
          .limit(500)
          .get();

      return snapshot.docs.map((doc) => _mapToNecropsia(doc)).toList();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  /// Crea un nuevo registro de necropsia.
  Future<void> crearNecropsia(String granjaId, Necropsia necropsia) async {
    try {
      await _necropsiasCollection(
        granjaId,
      ).doc(necropsia.id).set(_necropsiaToMap(necropsia));
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  /// Actualiza un registro existente.
  Future<void> actualizarNecropsia(String granjaId, Necropsia necropsia) async {
    try {
      await _necropsiasCollection(
        granjaId,
      ).doc(necropsia.id).update(_necropsiaToMap(necropsia));
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  /// Elimina un registro.
  Future<void> eliminarNecropsia(String granjaId, String necropsiaId) async {
    try {
      await _necropsiasCollection(granjaId).doc(necropsiaId).delete();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  /// Escucha cambios en las necropsias de una granja.
  Stream<List<Necropsia>> watchNecropsias(String granjaId) {
    return _necropsiasCollection(granjaId)
        .orderBy('fecha', descending: true)
        .limit(200)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => _mapToNecropsia(doc)).toList(),
        );
  }

  Necropsia _mapToNecropsia(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Necropsia(
      id: doc.id,
      granjaId: data['granjaId'] as String? ?? '',
      galponId: data['galponId'] as String? ?? '',
      loteId: data['loteId'] as String? ?? '',
      fecha: (data['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
      numeroAvesExaminadas: data['numeroAvesExaminadas'] as int? ?? 0,
      hallazgos: _mapToHallazgos(data['hallazgos'] as List<dynamic>? ?? []),
      diagnosticoPresuntivo: data['diagnosticoPresuntivo'] as String?,
      diagnosticoConfirmado: data['diagnosticoConfirmado'] as String?,
      enfermedadDetectada: data['enfermedadDetectada'] != null
          ? EnfermedadAvicola.fromJson(data['enfermedadDetectada'] as String)
          : null,
      fotografias:
          (data['fotografias'] as List<dynamic>?)?.cast<String>() ?? [],
      muestrasLaboratorio: _mapToMuestras(
        data['muestrasLaboratorio'] as List<dynamic>? ?? [],
      ),
      recomendaciones: data['recomendaciones'] as String?,
      realizadoPor: data['realizadoPor'] as String? ?? 'Desconocido',
      veterinarioId: data['veterinarioId'] as String?,
      veterinarioNombre: data['veterinarioNombre'] as String?,
      fechaCreacion:
          (data['fechaCreacion'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  List<HallazgoNecropsia> _mapToHallazgos(List<dynamic> hallazgosData) {
    return hallazgosData.map((h) {
      final hallazgo = h as Map<String, dynamic>;
      return HallazgoNecropsia(
        organo: OrganoAfectado.fromJson(hallazgo['organo'] as String),
        descripcion: hallazgo['descripcion'] as String,
        severidad: SeveridadHallazgo.fromJson(
          hallazgo['severidad'] as String? ?? 'leve',
        ),
        fotografiaUrl: hallazgo['fotografiaUrl'] as String?,
      );
    }).toList();
  }

  List<MuestraLaboratorio> _mapToMuestras(List<dynamic> muestrasData) {
    return muestrasData.map((m) {
      final muestra = m as Map<String, dynamic>;
      return MuestraLaboratorio(
        id: muestra['id'] as String,
        tipo: TipoMuestra.fromJson(muestra['tipo'] as String),
        fechaEnvio: (muestra['fechaEnvio'] as Timestamp).toDate(),
        laboratorio: muestra['laboratorio'] as String?,
        fechaResultado: (muestra['fechaResultado'] as Timestamp?)?.toDate(),
        resultado: muestra['resultado'] as String?,
      );
    }).toList();
  }

  Map<String, dynamic> _necropsiaToMap(Necropsia necropsia) {
    return {
      'granjaId': necropsia.granjaId,
      'galponId': necropsia.galponId,
      'loteId': necropsia.loteId,
      'fecha': Timestamp.fromDate(necropsia.fecha),
      'numeroAvesExaminadas': necropsia.numeroAvesExaminadas,
      'hallazgos': necropsia.hallazgos
          .map(
            (h) => {
              'organo': h.organo.toJson(),
              'descripcion': h.descripcion,
              'severidad': h.severidad.toJson(),
              'fotografiaUrl': h.fotografiaUrl,
            },
          )
          .toList(),
      'diagnosticoPresuntivo': necropsia.diagnosticoPresuntivo,
      'diagnosticoConfirmado': necropsia.diagnosticoConfirmado,
      'enfermedadDetectada': necropsia.enfermedadDetectada?.toJson(),
      'fotografias': necropsia.fotografias,
      'muestrasLaboratorio': necropsia.muestrasLaboratorio
          .map(
            (m) => {
              'id': m.id,
              'tipo': m.tipo.toJson(),
              'fechaEnvio': Timestamp.fromDate(m.fechaEnvio),
              'laboratorio': m.laboratorio,
              'fechaResultado': m.fechaResultado != null
                  ? Timestamp.fromDate(m.fechaResultado!)
                  : null,
              'resultado': m.resultado,
            },
          )
          .toList(),
      'recomendaciones': necropsia.recomendaciones,
      'realizadoPor': necropsia.realizadoPor,
      'veterinarioId': necropsia.veterinarioId,
      'veterinarioNombre': necropsia.veterinarioNombre,
      'fechaCreacion': Timestamp.fromDate(necropsia.fechaCreacion),
    };
  }
}
