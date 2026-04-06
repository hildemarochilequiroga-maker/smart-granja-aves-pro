/// Estados posibles de un lote avícola.
///
/// Define el ciclo de vida de un lote desde su creación
/// hasta su finalización.
library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Enumeración de estados de un lote.
enum EstadoLote {
  /// Lote activo en producción.
  activo,

  /// Lote cerrado/finalizado normalmente.
  cerrado,

  /// Lote en cuarentena por motivos sanitarios.
  cuarentena,

  /// Lote vendido completamente.
  vendido,

  /// Lote en proceso de transferencia a otro galpón.
  enTransferencia,

  /// Lote suspendido temporalmente.
  suspendido;

  /// Nombre para mostrar en UI.
  String get displayName {
    return switch (this) {
      EstadoLote.activo =>
        switch (Formatters.currentLocale) { 'es' => 'Activo', 'pt' => 'Ativo', _ => 'Active' },
      EstadoLote.cerrado =>
        switch (Formatters.currentLocale) { 'es' => 'Cerrado', 'pt' => 'Fechado', _ => 'Closed' },
      EstadoLote.cuarentena =>
        switch (Formatters.currentLocale) { 'es' => 'Cuarentena', 'pt' => 'Quarentena', _ => 'Quarantine' },
      EstadoLote.vendido =>
        switch (Formatters.currentLocale) { 'es' => 'Vendido', 'pt' => 'Vendido', _ => 'Sold' },
      EstadoLote.enTransferencia =>
        switch (Formatters.currentLocale) { 'es' => 'En Transferencia', 'pt' => 'Em Transferência', _ => 'In Transfer' },
      EstadoLote.suspendido =>
        switch (Formatters.currentLocale) { 'es' => 'Suspendido', 'pt' => 'Suspenso', _ => 'Suspended' },
    };
  }

  /// Descripción del estado.
  String get descripcion {
    return switch (this) {
      EstadoLote.activo =>
        switch (Formatters.currentLocale) { 'es' => 'Lote en producción normal', 'pt' => 'Lote em produção normal', _ => 'Batch in normal production' },
      EstadoLote.cerrado =>
        switch (Formatters.currentLocale) { 'es' => 'Lote finalizado', 'pt' => 'Lote finalizado', _ => 'Batch finalized' },
      EstadoLote.cuarentena =>
        switch (Formatters.currentLocale) { 'es' => 'Lote aislado por motivos sanitarios', 'pt' => 'Lote isolado por motivos sanitários', _ => 'Batch isolated for sanitary reasons' },
      EstadoLote.vendido =>
        switch (Formatters.currentLocale) { 'es' => 'Lote vendido completamente', 'pt' => 'Lote vendido completamente', _ => 'Batch completely sold' },
      EstadoLote.enTransferencia =>
        switch (Formatters.currentLocale) { 'es' => 'Lote siendo transferido', 'pt' => 'Lote sendo transferido', _ => 'Batch being transferred' },
      EstadoLote.suspendido =>
        switch (Formatters.currentLocale) { 'es' => 'Lote temporalmente suspendido', 'pt' => 'Lote temporariamente suspenso', _ => 'Batch temporarily suspended' },
    };
  }

  /// Icono asociado al estado.
  String get icono {
    return switch (this) {
      EstadoLote.activo => '🟢',
      EstadoLote.cerrado => '⚫',
      EstadoLote.cuarentena => '🟡',
      EstadoLote.vendido => '💰',
      EstadoLote.enTransferencia => '🔄',
      EstadoLote.suspendido => '⏸️',
    };
  }

  /// Nombre localizado para UI con AppLocalizations.
  String localizedDisplayName(S l) {
    return switch (this) {
      EstadoLote.activo => l.enumEstadoLoteActivo,
      EstadoLote.cerrado => l.enumEstadoLoteCerrado,
      EstadoLote.cuarentena => l.enumEstadoLoteCuarentena,
      EstadoLote.vendido => l.enumEstadoLoteVendido,
      EstadoLote.enTransferencia => l.enumEstadoLoteEnTransferencia,
      EstadoLote.suspendido => l.enumEstadoLoteSuspendido,
    };
  }

  /// Descripción localizada para UI con AppLocalizations.
  String localizedDescripcion(S l) {
    return switch (this) {
      EstadoLote.activo => l.enumEstadoLoteDescActivo,
      EstadoLote.cerrado => l.enumEstadoLoteDescCerrado,
      EstadoLote.cuarentena => l.enumEstadoLoteDescCuarentena,
      EstadoLote.vendido => l.enumEstadoLoteDescVendido,
      EstadoLote.enTransferencia => l.enumEstadoLoteDescEnTransferencia,
      EstadoLote.suspendido => l.enumEstadoLoteDescSuspendido,
    };
  }

  /// Si el lote está operativo.
  bool get estaOperativo => this == EstadoLote.activo;

  /// Si el lote está finalizado (cerrado o vendido).
  bool get estaFinalizado =>
      this == EstadoLote.cerrado || this == EstadoLote.vendido;

  /// Si requiere atención especial.
  bool get requiereAtencion =>
      this == EstadoLote.cuarentena || this == EstadoLote.suspendido;

  /// Si permite registrar eventos (mortalidad, peso, etc).
  bool get permiteRegistros =>
      this == EstadoLote.activo || this == EstadoLote.cuarentena;

  /// Estados a los que puede transicionar.
  List<EstadoLote> get transicionesPermitidas {
    return switch (this) {
      EstadoLote.activo => [
        EstadoLote.cerrado,
        EstadoLote.cuarentena,
        EstadoLote.vendido,
        EstadoLote.enTransferencia,
        EstadoLote.suspendido,
      ],
      EstadoLote.cerrado => [], // Estado final
      EstadoLote.cuarentena => [
        EstadoLote.activo,
        EstadoLote.cerrado,
        EstadoLote.suspendido,
      ],
      EstadoLote.vendido => [], // Estado final
      EstadoLote.enTransferencia => [EstadoLote.activo, EstadoLote.suspendido],
      EstadoLote.suspendido => [
        EstadoLote.activo,
        EstadoLote.cerrado,
        EstadoLote.cuarentena,
      ],
    };
  }

  /// Verifica si puede transicionar a otro estado.
  bool puedeTransicionarA(EstadoLote nuevoEstado) {
    return transicionesPermitidas.contains(nuevoEstado);
  }

  /// Convierte a JSON.
  String toJson() => name;

  /// Parsea desde JSON.
  static EstadoLote fromJson(String json) {
    return EstadoLote.values.firstWhere(
      (e) => e.name == json,
      orElse: () => EstadoLote.activo,
    );
  }

  /// Intenta parsear desde JSON (null-safe).
  static EstadoLote? tryFromJson(String? json) {
    if (json == null) return null;
    try {
      return EstadoLote.values.firstWhere((e) => e.name == json);
    } catch (_) {
      return null;
    }
  }
}
