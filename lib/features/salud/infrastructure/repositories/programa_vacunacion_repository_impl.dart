/// Implementación del repositorio de programas de vacunación.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/error_messages.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/programa_vacunacion_repository.dart';
import '../datasources/programa_vacunacion_datasource.dart';

/// Implementación del repositorio de programas de vacunación.
class ProgramaVacunacionRepositoryImpl implements ProgramaVacunacionRepository {
  final ProgramaVacunacionDatasource _datasource;
  final FirebaseFirestore _firestore;

  ProgramaVacunacionRepositoryImpl(
    this._datasource, {
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<ProgramaVacunacion>> obtenerProgramas(String granjaId) async {
    return _datasource.obtenerProgramas(granjaId);
  }

  @override
  Future<ProgramaVacunacion?> obtenerProgramaPorId(String id) async {
    // Nota: Para búsqueda global, se requiere conocer el granjaId
    return null;
  }

  @override
  Future<List<ProgramaVacunacion>> obtenerProgramasPorTipoAve(
    String granjaId,
    String tipoAve,
  ) async {
    return _datasource.obtenerProgramasPorTipoAve(granjaId, tipoAve);
  }

  @override
  Future<void> crearPrograma(ProgramaVacunacion programa) async {
    await _datasource.crearPrograma(programa);
  }

  @override
  Future<void> actualizarPrograma(ProgramaVacunacion programa) async {
    await _datasource.actualizarPrograma(programa);
  }

  @override
  Future<void> eliminarPrograma(String id) async {
    throw UnimplementedError(ErrorMessages.get('ERR_UNIMPLEMENTED_GRANJA_ID_REQUIRED'));
  }

  @override
  Future<void> aplicarProgramaALote({
    required String programaId,
    required String loteId,
    required DateTime fechaInicio,
  }) async {
    // Crear registro de aplicación de programa al lote
    await _firestore.collection('lotes').doc(loteId).update({
      'programaVacunacionId': programaId,
      'fechaInicioProgramaVacunacion': fechaInicio.toIso8601String(),
    });
  }

  @override
  Future<List<VacunaProgramada>> obtenerVacunasPendientes(String loteId) async {
    // Obtener el lote y su programa de vacunación
    final loteDoc = await _firestore.collection('lotes').doc(loteId).get();
    if (!loteDoc.exists || loteDoc.data() == null) return [];

    final data = loteDoc.data()!;
    final programaId = data['programaVacunacionId'] as String?;
    final granjaId = data['granjaId'] as String?;
    if (programaId == null || granjaId == null) return [];

    final programa = await _datasource.obtenerProgramaPorId(
      granjaId,
      programaId,
    );
    if (programa == null) return [];

    // Obtener vacunas ya aplicadas
    final vacunasAplicadas = await _firestore
        .collection('lotes')
        .doc(loteId)
        .collection('vacunas_aplicadas')
        .get();
    final idsAplicadas = vacunasAplicadas.docs
        .map((doc) => doc.data()['vacunaId'])
        .toSet();

    // Filtrar pendientes
    return programa.vacunas
        .where((v) => !idsAplicadas.contains(v.nombre))
        .toList();
  }

  @override
  Future<void> marcarVacunaAplicada({
    required String programaId,
    required String vacunaId,
    required String loteId,
    required DateTime fechaAplicacion,
    String? observaciones,
    String? aplicadoPor,
  }) async {
    await _firestore
        .collection('lotes')
        .doc(loteId)
        .collection('vacunas_aplicadas')
        .add({
          'programaId': programaId,
          'vacunaId': vacunaId,
          'fechaAplicacion': fechaAplicacion.toIso8601String(),
          'observaciones': observaciones,
          'aplicadoPor': aplicadoPor,
          'fechaRegistro': FieldValue.serverTimestamp(),
        });
  }

  @override
  Stream<List<ProgramaVacunacion>> watchProgramas(String granjaId) {
    return _datasource.watchProgramas(granjaId);
  }
}
