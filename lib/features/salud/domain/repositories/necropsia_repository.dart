/// Repositorio para registros de necropsias.
library;

import '../entities/entities.dart';
import '../enums/enums.dart';

/// Repositorio abstracto para gestión de necropsias.
abstract class NecropsiaRepository {
  /// Obtiene todas las necropsias de una granja.
  Future<List<Necropsia>> obtenerNecropsias(String granjaId);

  /// Obtiene una necropsia por su ID.
  Future<Necropsia?> obtenerNecropsiaPorId(String id);

  /// Obtiene necropsias por lote.
  Future<List<Necropsia>> obtenerNecropsiasPorlote(String loteId);

  /// Obtiene necropsias por rango de fechas.
  Future<List<Necropsia>> obtenerNecropsiaPorFecha({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  /// Obtiene necropsias por enfermedad detectada.
  Future<List<Necropsia>> obtenerNecropsiaPorEnfermedad(
    String granjaId,
    EnfermedadAvicola enfermedad,
  );

  /// Crea un nuevo registro de necropsia.
  Future<void> crearNecropsia(Necropsia necropsia);

  /// Actualiza un registro existente.
  Future<void> actualizarNecropsia(Necropsia necropsia);

  /// Actualiza los resultados de laboratorio.
  Future<void> actualizarResultadoLaboratorio({
    required String necropsiaId,
    required String muestraId,
    required String resultado,
    required DateTime fechaResultado,
  });

  /// Confirma el diagnóstico de una necropsia.
  Future<void> confirmarDiagnostico({
    required String necropsiaId,
    required String diagnosticoConfirmado,
    EnfermedadAvicola? enfermedadDetectada,
  });

  /// Elimina un registro.
  Future<void> eliminarNecropsia(String id);

  /// Obtiene estadísticas de enfermedades detectadas.
  Future<Map<EnfermedadAvicola, int>> obtenerEstadisticasEnfermedades({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  /// Escucha cambios en las necropsias de una granja.
  Stream<List<Necropsia>> watchNecropsias(String granjaId);
}
