import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Estado de una venta de producto.
///
/// Flujo típico:
/// pendiente → confirmada → entregada → facturada
enum EstadoVenta {
  /// Venta registrada pero pendiente de confirmación.
  pendiente('Pendiente', 'Esperando confirmación', '#FF9800'),

  /// Venta confirmada, lista para preparar.
  confirmada('Confirmada', 'Confirmada por el cliente', '#2196F3'),

  /// Producto en preparación/empaque.
  enPreparacion('En Preparación', 'Preparando producto', '#9C27B0'),

  /// Producto listo para despachar.
  listaParaDespacho('Lista para Despacho', 'Lista para entregar', '#00BCD4'),

  /// Producto en tránsito/entrega.
  enTransito('En Tránsito', 'En camino al cliente', '#FF5722'),

  /// Producto entregado al cliente.
  entregada('Entregada', 'Entregada exitosamente', '#4CAF50'),

  /// Venta facturada.
  facturada('Facturada', 'Factura generada', '#8BC34A'),

  /// Venta cancelada.
  cancelada('Cancelada', 'Cancelada', '#F44336'),

  /// Devolución/rechazo del producto.
  devuelta('Devuelta', 'Devuelta por el cliente', '#E91E63');

  const EstadoVenta(this.nombre, this.descripcion, this.colorHex);

  /// Nombre del estado.
  final String nombre;

  /// Descripción del estado.
  final String descripcion;

  /// Color representativo en hexadecimal.
  final String colorHex;

  /// Indica si la venta está activa (no cancelada ni devuelta).
  bool get esActiva {
    return this != EstadoVenta.cancelada && this != EstadoVenta.devuelta;
  }

  /// Indica si la venta ya fue completada.
  bool get esCompletada {
    return this == EstadoVenta.entregada || this == EstadoVenta.facturada;
  }

  /// Indica si se puede modificar la venta.
  bool get esModificable {
    return this == EstadoVenta.pendiente || this == EstadoVenta.confirmada;
  }

  /// Nombre del estado localizado.
  String get displayName {
    final locale = Formatters.currentLocale;
    return switch (this) {
      EstadoVenta.pendiente => switch (locale) { 'es' => 'Pendiente', 'pt' => 'Pendente', _ => 'Pending' },
      EstadoVenta.confirmada => switch (locale) { 'es' => 'Confirmada', 'pt' => 'Confirmada', _ => 'Confirmed' },
      EstadoVenta.enPreparacion => switch (locale) { 'es' => 'En Preparación', 'pt' => 'Em Preparação', _ => 'In Preparation' },
      EstadoVenta.listaParaDespacho =>
        switch (locale) { 'es' => 'Lista para Despacho', 'pt' => 'Pronta para Despacho', _ => 'Ready to Ship' },
      EstadoVenta.enTransito => switch (locale) { 'es' => 'En Tránsito', 'pt' => 'Em Trânsito', _ => 'In Transit' },
      EstadoVenta.entregada => switch (locale) { 'es' => 'Entregada', 'pt' => 'Entregue', _ => 'Delivered' },
      EstadoVenta.facturada => switch (locale) { 'es' => 'Facturada', 'pt' => 'Faturada', _ => 'Invoiced' },
      EstadoVenta.cancelada => switch (locale) { 'es' => 'Cancelada', 'pt' => 'Cancelada', _ => 'Cancelled' },
      EstadoVenta.devuelta => switch (locale) { 'es' => 'Devuelta', 'pt' => 'Devolvida', _ => 'Returned' },
    };
  }

  /// Descripción del estado localizada.
  String get displayDescripcion {
    final locale = Formatters.currentLocale;
    return switch (this) {
      EstadoVenta.pendiente =>
        switch (locale) { 'es' => 'Esperando confirmación', 'pt' => 'Aguardando confirmação', _ => 'Awaiting confirmation' },
      EstadoVenta.confirmada =>
        switch (locale) { 'es' => 'Confirmada por el cliente', 'pt' => 'Confirmada pelo cliente', _ => 'Confirmed by client' },
      EstadoVenta.enPreparacion =>
        switch (locale) { 'es' => 'Preparando producto', 'pt' => 'Preparando produto', _ => 'Preparing product' },
      EstadoVenta.listaParaDespacho =>
        switch (locale) { 'es' => 'Lista para entregar', 'pt' => 'Pronta para entrega', _ => 'Ready for delivery' },
      EstadoVenta.enTransito =>
        switch (locale) { 'es' => 'En camino al cliente', 'pt' => 'A caminho do cliente', _ => 'On the way to client' },
      EstadoVenta.entregada =>
        switch (locale) { 'es' => 'Entregada exitosamente', 'pt' => 'Entregue com sucesso', _ => 'Delivered successfully' },
      EstadoVenta.facturada => switch (locale) { 'es' => 'Factura generada', 'pt' => 'Fatura gerada', _ => 'Invoice generated' },
      EstadoVenta.cancelada => switch (locale) { 'es' => 'Cancelada', 'pt' => 'Cancelada', _ => 'Cancelled' },
      EstadoVenta.devuelta =>
        switch (locale) { 'es' => 'Devuelta por el cliente', 'pt' => 'Devolvida pelo cliente', _ => 'Returned by client' },
    };
  }

  String toJson() => name;

  static EstadoVenta fromJson(String json) {
    return EstadoVenta.values.firstWhere(
      (e) => e.name == json,
      orElse: () => EstadoVenta.pendiente,
    );
  }
}
