/// Datasource remoto para programas de vacunación.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/entities.dart';

/// Datasource de Firestore para programas de vacunación.
class ProgramaVacunacionDatasource {
  final FirebaseFirestore _firestore;

  ProgramaVacunacionDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String granjaId) {
    return _firestore
        .collection('granjas')
        .doc(granjaId)
        .collection('programas_vacunacion');
  }

  CollectionReference<Map<String, dynamic>> get _plantillasGlobales {
    return _firestore.collection('plantillas_vacunacion');
  }

  /// Obtiene todos los programas de vacunación de una granja.
  Future<List<ProgramaVacunacion>> obtenerProgramas(String granjaId) async {
    final snapshot = await _collection(
      granjaId,
    ).where('activo', isEqualTo: true).orderBy('nombre').limit(500).get();
    return snapshot.docs
        .map(
          (doc) => ProgramaVacunacion.fromJson({'id': doc.id, ...doc.data()}),
        )
        .toList();
  }

  /// Obtiene un programa por su ID.
  Future<ProgramaVacunacion?> obtenerProgramaPorId(
    String granjaId,
    String id,
  ) async {
    final doc = await _collection(granjaId).doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return ProgramaVacunacion.fromJson({'id': doc.id, ...doc.data()!});
  }

  /// Obtiene programas por tipo de ave.
  Future<List<ProgramaVacunacion>> obtenerProgramasPorTipoAve(
    String granjaId,
    String tipoAve,
  ) async {
    final snapshot = await _collection(granjaId)
        .where('tipoAve', isEqualTo: tipoAve)
        .where('activo', isEqualTo: true)
        .get();
    return snapshot.docs
        .map(
          (doc) => ProgramaVacunacion.fromJson({'id': doc.id, ...doc.data()}),
        )
        .toList();
  }

  /// Crea un nuevo programa de vacunación.
  Future<String> crearPrograma(ProgramaVacunacion programa) async {
    final json = programa.toJson();
    json.remove('id');
    final docRef = await _collection(programa.granjaId!).add(json);
    return docRef.id;
  }

  /// Actualiza un programa existente.
  Future<void> actualizarPrograma(ProgramaVacunacion programa) async {
    await _collection(
      programa.granjaId!,
    ).doc(programa.id).update(programa.toJson());
  }

  /// Elimina un programa (soft delete).
  Future<void> eliminarPrograma(String granjaId, String id) async {
    await _collection(granjaId).doc(id).update({'activo': false});
  }

  /// Obtiene las plantillas globales de vacunación.
  Future<List<ProgramaVacunacion>> obtenerPlantillasGlobales() async {
    final snapshot = await _plantillasGlobales
        .where('activo', isEqualTo: true)
        .get();
    return snapshot.docs
        .map(
          (doc) => ProgramaVacunacion.fromJson({'id': doc.id, ...doc.data()}),
        )
        .toList();
  }

  /// Escucha cambios en los programas de una granja.
  Stream<List<ProgramaVacunacion>> watchProgramas(String granjaId) {
    return _collection(granjaId)
        .where('activo', isEqualTo: true)
        .orderBy('nombre')
        .limit(200)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    ProgramaVacunacion.fromJson({'id': doc.id, ...doc.data()}),
              )
              .toList(),
        );
  }
}
