import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Estado de un pedido de venta en el sistema.
///
/// Define el ciclo de vida de una transacción comercial
/// desde su creación hasta su finalización.
enum EstadoPedido {
  /// Pedido creado pero no confirmado.
  pendiente('Pendiente', 'Pedido en espera de confirmación', '#FFC107'),

  /// Pedido confirmado y en preparación.
  confirmado('Confirmado', 'Pedido aprobado', '#2196F3'),

  /// Pedido en proceso de preparación para envío.
  enPreparacion('En Preparación', 'Pedido siendo preparado', '#FF9800'),

  /// Pedido listo para ser despachado.
  listoParaDespacho('Listo Despacho', 'Preparado para envío', '#9C27B0'),

  /// Pedido en tránsito hacia el cliente.
  enTransito('En Tránsito', 'Pedido en camino', '#00BCD4'),

  /// Pedido entregado al cliente.
  entregado('Entregado', 'Pedido completado', '#4CAF50'),

  /// Pedido cancelado antes de la entrega.
  cancelado('Cancelado', 'Pedido anulado', '#F44336'),

  /// Pedido devuelto por el cliente.
  devuelto('Devuelto', 'Pedido retornado', '#E91E63'),

  /// Pedido entregado parcialmente.
  parcial('Parcial', 'Entrega incompleta', '#FF5722');

  const EstadoPedido(this.displayName, this.descripcion, this.colorHex);

  final String displayName;
  final String descripcion;
  final String colorHex;

  String toJson() => name;

  static EstadoPedido fromJson(String json) {
    return EstadoPedido.values.firstWhere(
      (e) => e.name == json,
      orElse: () => EstadoPedido.pendiente,
    );
  }

  static EstadoPedido? tryFromJson(String? json) {
    if (json == null) return null;
    try {
      return fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Verifica si el pedido está activo (en proceso).
  bool get estaActivo {
    return this == EstadoPedido.pendiente ||
        this == EstadoPedido.confirmado ||
        this == EstadoPedido.enPreparacion ||
        this == EstadoPedido.listoParaDespacho ||
        this == EstadoPedido.enTransito ||
        this == EstadoPedido.parcial;
  }

  /// Verifica si el pedido está finalizado (completo o cancelado).
  bool get estaFinalizado {
    return this == EstadoPedido.entregado ||
        this == EstadoPedido.cancelado ||
        this == EstadoPedido.devuelto;
  }

  /// Verifica si puede ser modificado.
  bool get puedeModificarse {
    return this == EstadoPedido.pendiente;
  }

  /// Verifica si puede ser cancelado.
  bool get puedeCancelarse {
    return this == EstadoPedido.pendiente ||
        this == EstadoPedido.confirmado ||
        this == EstadoPedido.enPreparacion;
  }

  /// Nombre localizado del estado.
  String get localizedName {
    final locale = Formatters.currentLocale;
    return switch (this) {
      EstadoPedido.pendiente => switch (locale) { 'es' => 'Pendiente', 'pt' => 'Pendente', _ => 'Pending' },
      EstadoPedido.confirmado => switch (locale) { 'es' => 'Confirmado', 'pt' => 'Confirmado', _ => 'Confirmed' },
      EstadoPedido.enPreparacion => switch (locale) { 'es' => 'En Preparación', 'pt' => 'Em Preparação', _ => 'In Preparation' },
      EstadoPedido.listoParaDespacho =>
        switch (locale) { 'es' => 'Listo Despacho', 'pt' => 'Pronto Despacho', _ => 'Ready to Ship' },
      EstadoPedido.enTransito => switch (locale) { 'es' => 'En Tránsito', 'pt' => 'Em Trânsito', _ => 'In Transit' },
      EstadoPedido.entregado => switch (locale) { 'es' => 'Entregado', 'pt' => 'Entregue', _ => 'Delivered' },
      EstadoPedido.cancelado => switch (locale) { 'es' => 'Cancelado', 'pt' => 'Cancelado', _ => 'Cancelled' },
      EstadoPedido.devuelto => switch (locale) { 'es' => 'Devuelto', 'pt' => 'Devolvido', _ => 'Returned' },
      EstadoPedido.parcial => switch (locale) { 'es' => 'Parcial', 'pt' => 'Parcial', _ => 'Partial' },
    };
  }

  /// Descripción localizada del estado.
  String get localizedDescripcion {
    final locale = Formatters.currentLocale;
    return switch (this) {
      EstadoPedido.pendiente =>
        switch (locale) { 'es' => 'Pedido en espera de confirmación', 'pt' => 'Pedido aguardando confirmação', _ => 'Order awaiting confirmation' },
      EstadoPedido.confirmado => switch (locale) { 'es' => 'Pedido aprobado', 'pt' => 'Pedido aprovado', _ => 'Order approved' },
      EstadoPedido.enPreparacion =>
        switch (locale) { 'es' => 'Pedido siendo preparado', 'pt' => 'Pedido sendo preparado', _ => 'Order being prepared' },
      EstadoPedido.listoParaDespacho =>
        switch (locale) { 'es' => 'Preparado para envío', 'pt' => 'Preparado para envio', _ => 'Ready for shipping' },
      EstadoPedido.enTransito => switch (locale) { 'es' => 'Pedido en camino', 'pt' => 'Pedido a caminho', _ => 'Order on the way' },
      EstadoPedido.entregado => switch (locale) { 'es' => 'Pedido completado', 'pt' => 'Pedido completado', _ => 'Order completed' },
      EstadoPedido.cancelado => switch (locale) { 'es' => 'Pedido anulado', 'pt' => 'Pedido anulado', _ => 'Order voided' },
      EstadoPedido.devuelto => switch (locale) { 'es' => 'Pedido retornado', 'pt' => 'Pedido devolvido', _ => 'Order returned' },
      EstadoPedido.parcial =>
        switch (locale) { 'es' => 'Entrega incompleta', 'pt' => 'Entrega incompleta', _ => 'Incomplete delivery' },
    };
  }

  /// Estados a los que puede transicionar.
  List<EstadoPedido> get transicionesPermitidas {
    switch (this) {
      case EstadoPedido.pendiente:
        return [EstadoPedido.confirmado, EstadoPedido.cancelado];
      case EstadoPedido.confirmado:
        return [EstadoPedido.enPreparacion, EstadoPedido.cancelado];
      case EstadoPedido.enPreparacion:
        return [EstadoPedido.listoParaDespacho, EstadoPedido.cancelado];
      case EstadoPedido.listoParaDespacho:
        return [EstadoPedido.enTransito, EstadoPedido.cancelado];
      case EstadoPedido.enTransito:
        return [EstadoPedido.entregado, EstadoPedido.parcial];
      case EstadoPedido.parcial:
        return [EstadoPedido.entregado, EstadoPedido.devuelto];
      case EstadoPedido.entregado:
        return [EstadoPedido.devuelto];
      case EstadoPedido.cancelado:
      case EstadoPedido.devuelto:
        return [];
    }
  }

  /// Verifica si puede transicionar a un estado específico.
  bool puedeTransicionarA(EstadoPedido nuevoEstado) {
    return transicionesPermitidas.contains(nuevoEstado);
  }
}
