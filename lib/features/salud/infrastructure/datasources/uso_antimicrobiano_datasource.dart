/// Datasource de Firestore para uso de antimicrobianos.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';

/// Datasource para gestión de uso de antimicrobianos en Firestore.
class UsoAntimicrobianoDatasource {
  final FirebaseFirestore _firestore;

  UsoAntimicrobianoDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _usosCollection(String granjaId) {
    return _firestore
        .collection('granjas')
        .doc(granjaId)
        .collection('usos_antimicrobianos');
  }

  /// Obtiene todos los usos de antimicrobianos de una granja.
  Future<List<UsoAntimicrobiano>> obtenerUsos(String granjaId) async {
    try {
      final snapshot = await _usosCollection(
        granjaId,
      ).orderBy('fechaInicio', descending: true).limit(500).get();

      return snapshot.docs.map((doc) => _mapToUsoAntimicrobiano(doc)).toList();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  /// Obtiene usos por lote.
  Future<List<UsoAntimicrobiano>> obtenerUsosPorLote(
    String granjaId,
    String loteId,
  ) async {
    try {
      final snapshot = await _usosCollection(granjaId)
          .where('loteId', isEqualTo: loteId)
          .orderBy('fechaInicio', descending: true)
          .limit(500)
          .get();

      return snapshot.docs.map((doc) => _mapToUsoAntimicrobiano(doc)).toList();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  /// Obtiene lotes en período de retiro.
  Future<List<UsoAntimicrobiano>> obtenerLotesEnRetiro(String granjaId) async {
    try {
      final ahora = DateTime.now();
      final snapshot = await _usosCollection(granjaId)
          .where('fechaLiberacion', isGreaterThan: Timestamp.fromDate(ahora))
          .limit(500)
          .get();

      return snapshot.docs.map((doc) => _mapToUsoAntimicrobiano(doc)).toList();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  /// Crea un nuevo registro de uso.
  Future<void> crearUso(String granjaId, UsoAntimicrobiano uso) async {
    try {
      await _usosCollection(granjaId).doc(uso.id).set(_usoToMap(uso));
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  /// Actualiza un registro existente.
  Future<void> actualizarUso(String granjaId, UsoAntimicrobiano uso) async {
    try {
      await _usosCollection(granjaId).doc(uso.id).update(_usoToMap(uso));
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  /// Elimina un registro.
  Future<void> eliminarUso(String granjaId, String usoId) async {
    try {
      await _usosCollection(granjaId).doc(usoId).delete();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  /// Escucha cambios en los usos de una granja.
  Stream<List<UsoAntimicrobiano>> watchUsos(String granjaId) {
    return _usosCollection(granjaId)
        .orderBy('fechaInicio', descending: true)
        .limit(200)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => _mapToUsoAntimicrobiano(doc)).toList(),
        );
  }

  UsoAntimicrobiano _mapToUsoAntimicrobiano(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return UsoAntimicrobiano(
      id: doc.id,
      granjaId: data['granjaId'] as String? ?? '',
      galponId: data['galponId'] as String? ?? '',
      loteId: data['loteId'] as String? ?? '',
      fechaInicio:
          (data['fechaInicio'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fechaFin: (data['fechaFin'] as Timestamp?)?.toDate() ?? DateTime.now(),
      antimicrobiano: data['antimicrobiano'] as String? ?? 'Desconocido',
      principioActivo: data['principioActivo'] as String? ?? 'Desconocido',
      familia: FamiliaAntimicrobiano.values.firstWhere(
        (e) => e.name == data['familia'],
        orElse: () => FamiliaAntimicrobiano.tetraciclinas,
      ),
      categoriaOms: CategoriaOmsAntimicrobiano.values.firstWhere(
        (e) => e.name == data['categoriaOms'],
        orElse: () => CategoriaOmsAntimicrobiano.importante,
      ),
      dosis: (data['dosis'] as num?)?.toDouble() ?? 0.0,
      unidadDosis: data['unidadDosis'] as String? ?? 'mg/kg',
      viaAdministracion: ViaAdministracion.values.firstWhere(
        (e) => e.name == data['viaAdministracion'],
        orElse: () => ViaAdministracion.oral,
      ),
      motivoUso: MotivoUsoAntimicrobiano.values.firstWhere(
        (e) => e.name == data['motivoUso'],
        orElse: () => MotivoUsoAntimicrobiano.tratamiento,
      ),
      diagnostico: data['diagnostico'] as String?,
      enfermedadTratada: data['enfermedadTratada'] != null
          ? EnfermedadAvicola.fromJson(data['enfermedadTratada'] as String)
          : null,
      avesAfectadas: data['avesAfectadas'] as int? ?? 0,
      tiempoRetiro: data['tiempoRetiro'] as int? ?? 0,
      fechaLiberacion:
          (data['fechaLiberacion'] as Timestamp?)?.toDate() ?? DateTime.now(),
      veterinarioId: data['veterinarioId'] as String?,
      veterinarioNombre: data['veterinarioNombre'] as String?,
      numeroReceta: data['numeroReceta'] as String?,
      proveedor: data['proveedor'] as String?,
      loteProducto: data['loteProducto'] as String?,
      fechaVencimiento: (data['fechaVencimiento'] as Timestamp?)?.toDate(),
      creadoPor: data['creadoPor'] as String? ?? 'Desconocido',
      fechaCreacion:
          (data['fechaCreacion'] as Timestamp?)?.toDate() ?? DateTime.now(),
      observaciones: data['observaciones'] as String?,
    );
  }

  Map<String, dynamic> _usoToMap(UsoAntimicrobiano uso) {
    return {
      'granjaId': uso.granjaId,
      'galponId': uso.galponId,
      'loteId': uso.loteId,
      'fechaInicio': Timestamp.fromDate(uso.fechaInicio),
      'fechaFin': Timestamp.fromDate(uso.fechaFin),
      'antimicrobiano': uso.antimicrobiano,
      'principioActivo': uso.principioActivo,
      'familia': uso.familia.name,
      'categoriaOms': uso.categoriaOms.name,
      'dosis': uso.dosis,
      'unidadDosis': uso.unidadDosis,
      'viaAdministracion': uso.viaAdministracion.name,
      'motivoUso': uso.motivoUso.name,
      'diagnostico': uso.diagnostico,
      'enfermedadTratada': uso.enfermedadTratada?.toJson(),
      'avesAfectadas': uso.avesAfectadas,
      'tiempoRetiro': uso.tiempoRetiro,
      'fechaLiberacion': Timestamp.fromDate(uso.fechaLiberacion),
      'veterinarioId': uso.veterinarioId,
      'veterinarioNombre': uso.veterinarioNombre,
      'numeroReceta': uso.numeroReceta,
      'proveedor': uso.proveedor,
      'loteProducto': uso.loteProducto,
      'fechaVencimiento': uso.fechaVencimiento != null
          ? Timestamp.fromDate(uso.fechaVencimiento!)
          : null,
      'creadoPor': uso.creadoPor,
      'fechaCreacion': Timestamp.fromDate(uso.fechaCreacion),
      'observaciones': uso.observaciones,
    };
  }
}
