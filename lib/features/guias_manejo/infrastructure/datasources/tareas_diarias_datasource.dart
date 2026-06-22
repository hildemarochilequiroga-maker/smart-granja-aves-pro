/// Datasource Firestore para persistir el estado de las tareas diarias.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

/// Registro de las tareas completadas en un día.
class TareasDiariasRecord {
  const TareasDiariasRecord({
    required this.dia,
    required this.tareasCompletadas,
    required this.totalTareas,
    required this.completadoPor,
    this.ultimaActualizacion,
  });

  factory TareasDiariasRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return TareasDiariasRecord(
      dia: data['dia'] as int,
      tareasCompletadas: List<String>.from(
        data['tareasCompletadas'] as List? ?? [],
      ),
      totalTareas: data['totalTareas'] as int? ?? 0,
      completadoPor: Map<String, String>.from(
        data['completadoPor'] as Map? ?? {},
      ),
      ultimaActualizacion: (data['ultimaActualizacion'] as Timestamp?)
          ?.toDate(),
    );
  }

  final int dia;
  final List<String> tareasCompletadas;
  final int totalTareas;

  /// Mapa de tareaId → userId que la completó.
  final Map<String, String> completadoPor;
  final DateTime? ultimaActualizacion;

  Map<String, dynamic> toFirestore() {
    return {
      'dia': dia,
      'tareasCompletadas': tareasCompletadas,
      'totalTareas': totalTareas,
      'completadoPor': completadoPor,
      'ultimaActualizacion': FieldValue.serverTimestamp(),
    };
  }
}

/// Datasource para persistir tareas diarias en Firestore.
class TareasDiariasDatasource {
  TareasDiariasDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String loteId) {
    return _firestore
        .collection('lotes')
        .doc(loteId)
        .collection('tareas_diarias');
  }

  String _docId(int dia) => 'dia_$dia';

  /// Carga las tareas completadas para un día.
  Future<TareasDiariasRecord?> obtener(String loteId, int dia) async {
    final doc = await _collection(loteId).doc(_docId(dia)).get();
    if (!doc.exists || doc.data() == null) return null;
    return TareasDiariasRecord.fromFirestore(doc);
  }

  /// Observa cambios en tiempo real para un día.
  Stream<TareasDiariasRecord?> watch(String loteId, int dia) {
    return _collection(loteId).doc(_docId(dia)).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return TareasDiariasRecord.fromFirestore(doc);
    });
  }

  /// Marca o desmarca una tarea.
  Future<void> toggleTarea({
    required String loteId,
    required int dia,
    required String tareaId,
    required String userId,
    required int totalTareas,
    required bool completar,
  }) async {
    final docRef = _collection(loteId).doc(_docId(dia));

    await _firestore.runTransaction((tx) async {
      final snapshot = await tx.get(docRef);

      List<String> completadas;
      Map<String, String> porUsuario;

      if (snapshot.exists && snapshot.data() != null) {
        completadas = List<String>.from(
          snapshot.data()!['tareasCompletadas'] as List? ?? [],
        );
        porUsuario = Map<String, String>.from(
          snapshot.data()!['completadoPor'] as Map? ?? {},
        );
      } else {
        completadas = [];
        porUsuario = {};
      }

      if (completar) {
        if (!completadas.contains(tareaId)) {
          completadas.add(tareaId);
        }
        porUsuario[tareaId] = userId;
      } else {
        completadas.remove(tareaId);
        porUsuario.remove(tareaId);
      }

      final record = TareasDiariasRecord(
        dia: dia,
        tareasCompletadas: completadas,
        totalTareas: totalTareas,
        completadoPor: porUsuario,
      );

      if (snapshot.exists) {
        tx.update(docRef, record.toFirestore());
      } else {
        tx.set(docRef, record.toFirestore());
      }
    });
  }
}
