/// Repositorio para programas de vacunación.
library;

import '../entities/entities.dart';

/// Repositorio abstracto para gestión de programas de vacunación.
abstract class ProgramaVacunacionRepository {
  /// Obtiene todos los programas de vacunación de una granja.
  Future<List<ProgramaVacunacion>> obtenerProgramas(String granjaId);

  /// Obtiene un programa por su ID.
  Future<ProgramaVacunacion?> obtenerProgramaPorId(String id);

  /// Obtiene programas por tipo de ave.
  Future<List<ProgramaVacunacion>> obtenerProgramasPorTipoAve(
    String granjaId,
    String tipoAve,
  );

  /// Crea un nuevo programa de vacunación.
  Future<void> crearPrograma(ProgramaVacunacion programa);

  /// Actualiza un programa existente.
  Future<void> actualizarPrograma(ProgramaVacunacion programa);

  /// Elimina un programa.
  Future<void> eliminarPrograma(String id);

  /// Aplica un programa a un lote específico.
  Future<void> aplicarProgramaALote({
    required String programaId,
    required String loteId,
    required DateTime fechaInicio,
  });

  /// Obtiene vacunas pendientes de un lote.
  Future<List<VacunaProgramada>> obtenerVacunasPendientes(String loteId);

  /// Marca una vacuna como aplicada.
  Future<void> marcarVacunaAplicada({
    required String programaId,
    required String vacunaId,
    required String loteId,
    required DateTime fechaAplicacion,
    String? observaciones,
    String? aplicadoPor,
  });

  /// Escucha cambios en los programas de una granja.
  Stream<List<ProgramaVacunacion>> watchProgramas(String granjaId);
}
