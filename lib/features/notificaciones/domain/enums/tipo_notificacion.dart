/// Tipos de notificación disponibles.
///
/// Sistema completo de notificaciones para Smart Granja Aves Pro.
/// Incluye 77 tipos organizados por categoría.
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/core/utils/formatters.dart';
import '../../../../core/theme/app_colors.dart';

/// Enum que define los tipos de notificación.
enum TipoNotificacion {
  // ============================================================
  // INVENTARIO (6 tipos)
  // ============================================================

  /// Alerta de stock bajo en inventario.
  stockBajo('stock_bajo', 'Stock Bajo', Icons.inventory_2, AppColors.warning),

  /// Stock completamente agotado.
  stockAgotado(
    'stock_agotado',
    'Agotado',
    Icons.remove_shopping_cart,
    AppColors.error,
  ),

  /// Producto próximo a vencer.
  proximoVencer(
    'proximo_vencer',
    'Próximo a Vencer',
    Icons.event_busy,
    AppColors.amber,
  ),

  /// Producto vencido.
  productoVencido(
    'producto_vencido',
    'Vencido',
    Icons.warning,
    AppColors.error,
  ),

  /// Stock reabastecido después de estar bajo.
  stockReabastecido(
    'stock_reabastecido',
    'Reabastecido',
    Icons.add_shopping_cart,
    AppColors.success,
  ),

  /// Nuevo movimiento de inventario registrado.
  movimientoInventario(
    'movimiento_inventario',
    'Movimiento',
    Icons.swap_horiz,
    AppColors.info,
  ),

  // ============================================================
  // LOTES (8 tipos)
  // ============================================================

  /// Mortalidad registrada (cualquier cantidad).
  mortalidadRegistrada(
    'mortalidad_registrada',
    'Mortalidad Registrada',
    Icons.warning_amber,
    AppColors.warning,
  ),

  /// Alta mortalidad detectada (>2%).
  mortalidadAlta(
    'mortalidad_alta',
    'Mortalidad Alta',
    Icons.pets,
    AppColors.error,
  ),

  /// Mortalidad crítica detectada (>5%).
  mortalidadCritica(
    'mortalidad_critica',
    'Mortalidad Crítica',
    Icons.emergency,
    AppColors.error,
  ),

  /// Nuevo lote creado.
  loteCreado('lote_creado', 'Nuevo Lote', Icons.egg_alt, AppColors.teal),

  /// Lote finalizado/cerrado.
  loteFinalizado(
    'lote_finalizado',
    'Lote Finalizado',
    Icons.check_circle,
    AppColors.success,
  ),

  /// Peso por debajo del objetivo.
  pesoBajoObjetivo(
    'peso_bajo_objetivo',
    'Peso Bajo',
    Icons.scale,
    AppColors.warning,
  ),

  /// Fecha de cierre de lote próxima.
  loteCierreProximo(
    'lote_cierre_proximo',
    'Cierre Próximo',
    Icons.event_note,
    AppColors.amber,
  ),

  /// Conversión alimenticia anormal.
  conversionAnormal(
    'conversion_anormal',
    'Conversión Anormal',
    Icons.analytics,
    AppColors.warning,
  ),

  /// Sin registros en varios días.
  loteSinRegistros(
    'lote_sin_registros',
    'Sin Registros',
    Icons.warning_amber,
    AppColors.amber,
  ),

  // ============================================================
  // PRODUCCIÓN (6 tipos)
  // ============================================================

  /// Producción registrada.
  produccionRegistrada(
    'produccion_registrada',
    'Producción',
    Icons.egg,
    AppColors.teal,
  ),

  /// Producción baja (<80% esperado).
  produccionBaja(
    'produccion_baja',
    'Producción Baja',
    Icons.trending_down,
    AppColors.warning,
  ),

  /// Caída brusca de producción.
  produccionCaida(
    'produccion_caida',
    'Caída Producción',
    Icons.south,
    AppColors.error,
  ),

  /// Primer huevo del lote registrado.
  primerHuevo('primer_huevo', 'Primer Huevo', Icons.egg_alt, AppColors.success),

  /// Récord de producción alcanzado.
  recordProduccion(
    'record_produccion',
    'Récord',
    Icons.emoji_events,
    AppColors.amber,
  ),

  /// Meta de producción alcanzada.
  metaProduccionAlcanzada(
    'meta_produccion_alcanzada',
    'Meta Alcanzada',
    Icons.flag,
    AppColors.success,
  ),

  // ============================================================
  // SALUD / VACUNACIONES (10 tipos)
  // ============================================================

  /// Recordatorio de vacunación (7 días antes).
  recordatorioVacunacion(
    'recordatorio_vacunacion',
    'Vacunación',
    Icons.vaccines,
    AppColors.purple,
  ),

  /// Vacunación programada para mañana.
  vacunacionManana(
    'vacunacion_manana',
    'Vacunación Mañana',
    Icons.vaccines,
    AppColors.deepPurple,
  ),

  /// Vacunación programada para hoy.
  vacunacionHoy(
    'vacunacion_hoy',
    'Vacunación Hoy',
    Icons.vaccines,
    AppColors.deepPurple,
  ),

  /// Vacunación vencida (no aplicada).
  vacunacionVencida(
    'vacunacion_vencida',
    'Vacunación Vencida',
    Icons.vaccines,
    AppColors.error,
  ),

  /// Vacunación aplicada exitosamente.
  vacunacionAplicada(
    'vacunacion_aplicada',
    'Vacunación Aplicada',
    Icons.check_circle,
    AppColors.success,
  ),

  /// Tratamiento iniciado.
  tratamientoIniciado(
    'tratamiento_iniciado',
    'Tratamiento',
    Icons.medical_services,
    AppColors.info,
  ),

  /// Período de retiro activo.
  periodoRetiroActivo(
    'periodo_retiro_activo',
    'Retiro Activo',
    Icons.block,
    AppColors.error,
  ),

  /// Período de retiro finalizado.
  periodoRetiroFin(
    'periodo_retiro_fin',
    'Fin Retiro',
    Icons.check,
    AppColors.success,
  ),

  /// Tratamiento finalizado.
  tratamientoFinalizado(
    'tratamiento_finalizado',
    'Fin Tratamiento',
    Icons.medical_services,
    AppColors.success,
  ),

  /// Nuevo diagnóstico/registro de salud.
  nuevoDiagnostico(
    'nuevo_diagnostico',
    'Diagnóstico',
    Icons.local_hospital,
    AppColors.warning,
  ),

  // ============================================================
  // ALERTAS SANITARIAS (6 tipos)
  // ============================================================

  /// Síntomas respiratorios detectados.
  sintomasRespiratorios(
    'sintomas_respiratorios',
    'Síntomas Respiratorios',
    Icons.air,
    AppColors.warning,
  ),

  /// Consumo anormal de agua.
  consumoAguaAnormal(
    'consumo_agua_anormal',
    'Consumo Agua',
    Icons.water_drop,
    AppColors.info,
  ),

  /// Consumo anormal de alimento.
  consumoAlimentoAnormal(
    'consumo_alimento_anormal',
    'Consumo Alimento',
    Icons.restaurant,
    AppColors.warning,
  ),

  /// Temperatura anormal registrada.
  temperaturaAnormal(
    'temperatura_anormal',
    'Temperatura',
    Icons.thermostat,
    AppColors.error,
  ),

  /// Humedad anormal registrada.
  humedadAnormal('humedad_anormal', 'Humedad', Icons.water, AppColors.info),

  /// Enfermedad confirmada.
  enfermedadConfirmada(
    'enfermedad_confirmada',
    'Enfermedad',
    Icons.coronavirus,
    AppColors.error,
  ),

  // ============================================================
  // BIOSEGURIDAD / INSPECCIONES (7 tipos)
  // ============================================================

  /// Inspección de bioseguridad pendiente.
  inspeccionPendiente(
    'inspeccion_pendiente',
    'Inspección Pendiente',
    Icons.checklist,
    AppColors.amber,
  ),

  /// Inspección programada para hoy.
  inspeccionHoy(
    'inspeccion_hoy',
    'Inspección Hoy',
    Icons.checklist,
    AppColors.info,
  ),

  /// Inspección vencida (no realizada).
  inspeccionVencida(
    'inspeccion_vencida',
    'Inspección Vencida',
    Icons.checklist,
    AppColors.error,
  ),

  /// Puntaje de bioseguridad crítico (<60%).
  bioseguridadCritica(
    'bioseguridad_critica',
    'Bioseguridad Crítica',
    Icons.security,
    AppColors.error,
  ),

  /// Puntaje de bioseguridad bajo (<80%).
  bioseguridadBaja(
    'bioseguridad_baja',
    'Bioseguridad Baja',
    Icons.security,
    AppColors.warning,
  ),

  /// Inspección completada.
  inspeccionCompletada(
    'inspeccion_completada',
    'Inspección OK',
    Icons.check_circle,
    AppColors.success,
  ),

  /// Necropsia registrada.
  necropsiaRegistrada(
    'necropsia_registrada',
    'Necropsia',
    Icons.biotech,
    AppColors.brown,
  ),

  // ============================================================
  // VENTAS / PEDIDOS (8 tipos)
  // ============================================================

  /// Nuevo pedido recibido.
  nuevoPedido(
    'nuevo_pedido',
    'Nuevo Pedido',
    Icons.shopping_bag,
    AppColors.info,
  ),

  /// Pedido confirmado.
  pedidoConfirmado(
    'pedido_confirmado',
    'Pedido Confirmado',
    Icons.thumb_up,
    AppColors.success,
  ),

  /// Entrega programada para mañana.
  entregaManana(
    'entrega_manana',
    'Entrega Mañana',
    Icons.local_shipping,
    AppColors.amber,
  ),

  /// Entrega programada para hoy.
  entregaHoy(
    'entrega_hoy',
    'Entrega Hoy',
    Icons.local_shipping,
    AppColors.info,
  ),

  /// Pedido entregado.
  pedidoEntregado(
    'pedido_entregado',
    'Entregado',
    Icons.check_circle,
    AppColors.success,
  ),

  /// Pedido cancelado.
  pedidoCancelado(
    'pedido_cancelado',
    'Cancelado',
    Icons.cancel,
    AppColors.error,
  ),

  /// Pago recibido.
  pagoRecibido('pago_recibido', 'Pago', Icons.attach_money, AppColors.success),

  /// Nueva venta registrada.
  ventaRegistrada(
    'venta_registrada',
    'Venta',
    Icons.point_of_sale,
    AppColors.teal,
  ),

  // ============================================================
  // COLABORADORES / USUARIOS (6 tipos)
  // ============================================================

  /// Invitación a granja recibida.
  invitacionRecibida(
    'invitacion_recibida',
    'Invitación',
    Icons.card_giftcard,
    AppColors.info,
  ),

  /// Invitación aceptada.
  invitacionAceptada(
    'invitacion_aceptada',
    'Colaborador Nuevo',
    Icons.person_add,
    AppColors.success,
  ),

  /// Invitación rechazada.
  invitacionRechazada(
    'invitacion_rechazada',
    'Invitación Rechazada',
    Icons.person_off,
    AppColors.error,
  ),

  /// Invitación expirada.
  invitacionExpirada(
    'invitacion_expirada',
    'Invitación Expirada',
    Icons.schedule,
    AppColors.grey500,
  ),

  /// Colaborador eliminado de la granja.
  colaboradorEliminado(
    'colaborador_eliminado',
    'Colaborador Removido',
    Icons.person_remove,
    AppColors.error,
  ),

  /// Cambio de rol de colaborador.
  cambioRol('cambio_rol', 'Cambio de Rol', Icons.badge, AppColors.info),

  // ============================================================
  // GALPONES (4 tipos)
  // ============================================================

  /// Nuevo galpón creado.
  galponCreado(
    'galpon_creado',
    'Nuevo Galpón',
    Icons.home_work,
    AppColors.teal,
  ),

  /// Galpón en mantenimiento.
  galponMantenimiento(
    'galpon_mantenimiento',
    'Mantenimiento',
    Icons.build,
    AppColors.warning,
  ),

  /// Capacidad máxima del galpón alcanzada.
  galponCapacidadMaxima(
    'galpon_capacidad_maxima',
    'Capacidad Máxima',
    Icons.groups,
    AppColors.amber,
  ),

  /// Evento de galpón registrado (desinfección, etc.).
  galponEvento('galpon_evento', 'Evento Galpón', Icons.event, AppColors.info),

  // ============================================================
  // COSTOS / FINANZAS (4 tipos)
  // ============================================================

  /// Gasto registrado.
  gastoRegistrado(
    'gasto_registrado',
    'Gasto',
    Icons.receipt_long,
    AppColors.info,
  ),

  /// Gasto inusualmente alto detectado.
  gastoInusual(
    'gasto_inusual',
    'Gasto Inusual',
    Icons.trending_up,
    AppColors.warning,
  ),

  /// Presupuesto mensual superado.
  presupuestoSuperado(
    'presupuesto_superado',
    'Presupuesto',
    Icons.money_off,
    AppColors.error,
  ),

  /// Resumen financiero semanal.
  resumenSemanal('resumen_semanal', 'Resumen', Icons.analytics, AppColors.info),

  // ============================================================
  // REPORTES (3 tipos)
  // ============================================================

  /// Reporte generado exitosamente.
  reporteGenerado(
    'reporte_generado',
    'Reporte',
    Icons.description,
    AppColors.success,
  ),

  /// Resumen diario automático.
  resumenDiario(
    'resumen_diario',
    'Resumen Diario',
    Icons.summarize,
    AppColors.teal,
  ),

  /// Alerta consolidada (múltiples alertas).
  alertaConsolidada(
    'alerta_consolidada',
    'Alertas',
    Icons.notifications_active,
    AppColors.amber,
  ),

  // ============================================================
  // SISTEMA (4 tipos)
  // ============================================================

  /// Sincronización offline completada.
  sincronizacionCompletada(
    'sincronizacion_completada',
    'Sincronizado',
    Icons.cloud_done,
    AppColors.success,
  ),

  /// Actualización de la app disponible.
  actualizacionDisponible(
    'actualizacion_disponible',
    'Actualización',
    Icons.system_update,
    AppColors.info,
  ),

  /// Mantenimiento programado del sistema.
  mantenimientoSistema(
    'mantenimiento_sistema',
    'Mantenimiento',
    Icons.engineering,
    AppColors.warning,
  ),

  /// Mensaje de bienvenida.
  bienvenida('bienvenida', 'Bienvenida', Icons.waving_hand, AppColors.teal),

  /// Alerta general.
  general('general', 'General', Icons.notifications, AppColors.grey500);

  const TipoNotificacion(this.value, this.label, this.icon, this.color);

  /// Valor para almacenamiento.
  final String value;

  /// Etiqueta para mostrar.
  final String label;

  /// Ícono representativo.
  final IconData icon;

  /// Color asociado.
  final Color color;

  /// Etiqueta localizada del tipo de notificación
  String get displayLabel {
    final locale = Formatters.currentLocale;
    return switch (this) {
      // Inventario
      TipoNotificacion.stockBajo => switch (locale) { 'es' => 'Stock Bajo', 'pt' => 'Estoque Baixo', _ => 'Low Stock' },
      TipoNotificacion.stockAgotado => switch (locale) { 'es' => 'Agotado', 'pt' => 'Esgotado', _ => 'Depleted' },
      TipoNotificacion.proximoVencer =>
        switch (locale) { 'es' => 'Próximo a Vencer', 'pt' => 'Próximo ao Vencimento', _ => 'Near Expiry' },
      TipoNotificacion.productoVencido => switch (locale) { 'es' => 'Vencido', 'pt' => 'Vencido', _ => 'Expired' },
      TipoNotificacion.stockReabastecido => switch (locale) { 'es' => 'Reabastecido', 'pt' => 'Reabastecido', _ => 'Restocked' },
      TipoNotificacion.movimientoInventario => switch (locale) { 'es' => 'Movimiento', 'pt' => 'Movimentação', _ => 'Movement' },
      // Lotes
      TipoNotificacion.mortalidadRegistrada =>
        switch (locale) { 'es' => 'Mortalidad Registrada', 'pt' => 'Mortalidade Registrada', _ => 'Mortality Recorded' },
      TipoNotificacion.mortalidadAlta =>
        switch (locale) { 'es' => 'Mortalidad Alta', 'pt' => 'Mortalidade Alta', _ => 'High Mortality' },
      TipoNotificacion.mortalidadCritica =>
        switch (locale) { 'es' => 'Mortalidad Crítica', 'pt' => 'Mortalidade Crítica', _ => 'Critical Mortality' },
      TipoNotificacion.loteCreado => switch (locale) { 'es' => 'Nuevo Lote', 'pt' => 'Novo Lote', _ => 'New Batch' },
      TipoNotificacion.loteFinalizado =>
        switch (locale) { 'es' => 'Lote Finalizado', 'pt' => 'Lote Finalizado', _ => 'Batch Finished' },
      TipoNotificacion.pesoBajoObjetivo => switch (locale) { 'es' => 'Peso Bajo', 'pt' => 'Peso Baixo', _ => 'Low Weight' },
      TipoNotificacion.loteCierreProximo =>
        switch (locale) { 'es' => 'Cierre Próximo', 'pt' => 'Fechamento Próximo', _ => 'Near Closing' },
      TipoNotificacion.conversionAnormal =>
        switch (locale) { 'es' => 'Conversión Anormal', 'pt' => 'Conversão Anormal', _ => 'Abnormal Conversion' },
      TipoNotificacion.loteSinRegistros =>
        switch (locale) { 'es' => 'Sin Registros', 'pt' => 'Sem Registros', _ => 'No Records' },
      // Producción
      TipoNotificacion.produccionRegistrada =>
        switch (locale) { 'es' => 'Producción', 'pt' => 'Produção', _ => 'Production' },
      TipoNotificacion.produccionBaja =>
        switch (locale) { 'es' => 'Producción Baja', 'pt' => 'Produção Baixa', _ => 'Low Production' },
      TipoNotificacion.produccionCaida =>
        switch (locale) { 'es' => 'Caída Producción', 'pt' => 'Queda na Produção', _ => 'Production Drop' },
      TipoNotificacion.primerHuevo => switch (locale) { 'es' => 'Primer Huevo', 'pt' => 'Primeiro Ovo', _ => 'First Egg' },
      TipoNotificacion.recordProduccion => switch (locale) { 'es' => 'Récord', 'pt' => 'Recorde', _ => 'Record' },
      TipoNotificacion.metaProduccionAlcanzada =>
        switch (locale) { 'es' => 'Meta Alcanzada', 'pt' => 'Meta Alcançada', _ => 'Goal Reached' },
      // Salud / Vacunaciones
      TipoNotificacion.recordatorioVacunacion =>
        switch (locale) { 'es' => 'Vacunación', 'pt' => 'Vacinação', _ => 'Vaccination' },
      TipoNotificacion.vacunacionManana =>
        switch (locale) { 'es' => 'Vacunación Mañana', 'pt' => 'Vacinação Amanhã', _ => 'Vaccination Tomorrow' },
      TipoNotificacion.vacunacionHoy =>
        switch (locale) { 'es' => 'Vacunación Hoy', 'pt' => 'Vacinação Hoje', _ => 'Vaccination Today' },
      TipoNotificacion.vacunacionVencida =>
        switch (locale) { 'es' => 'Vacunación Vencida', 'pt' => 'Vacinação Vencida', _ => 'Vaccination Overdue' },
      TipoNotificacion.vacunacionAplicada =>
        switch (locale) { 'es' => 'Vacunación Aplicada', 'pt' => 'Vacinação Aplicada', _ => 'Vaccination Applied' },
      TipoNotificacion.tratamientoIniciado =>
        switch (locale) { 'es' => 'Tratamiento', 'pt' => 'Tratamento', _ => 'Treatment' },
      TipoNotificacion.periodoRetiroActivo =>
        switch (locale) { 'es' => 'Retiro Activo', 'pt' => 'Retirada Ativa', _ => 'Active Withdrawal' },
      TipoNotificacion.periodoRetiroFin =>
        switch (locale) { 'es' => 'Fin Retiro', 'pt' => 'Fim Retirada', _ => 'Withdrawal End' },
      TipoNotificacion.tratamientoFinalizado =>
        switch (locale) { 'es' => 'Fin Tratamiento', 'pt' => 'Fim Tratamento', _ => 'Treatment End' },
      TipoNotificacion.nuevoDiagnostico => switch (locale) { 'es' => 'Diagnóstico', 'pt' => 'Diagnóstico', _ => 'Diagnosis' },
      // Alertas Sanitarias
      TipoNotificacion.sintomasRespiratorios =>
        switch (locale) { 'es' => 'Síntomas Respiratorios', 'pt' => 'Sintomas Respiratórios', _ => 'Respiratory Symptoms' },
      TipoNotificacion.consumoAguaAnormal =>
        switch (locale) { 'es' => 'Consumo Agua', 'pt' => 'Consumo Água', _ => 'Water Consumption' },
      TipoNotificacion.consumoAlimentoAnormal =>
        switch (locale) { 'es' => 'Consumo Alimento', 'pt' => 'Consumo Ração', _ => 'Feed Consumption' },
      TipoNotificacion.temperaturaAnormal =>
        switch (locale) { 'es' => 'Temperatura', 'pt' => 'Temperatura', _ => 'Temperature' },
      TipoNotificacion.humedadAnormal => switch (locale) { 'es' => 'Humedad', 'pt' => 'Umidade', _ => 'Humidity' },
      TipoNotificacion.enfermedadConfirmada => switch (locale) { 'es' => 'Enfermedad', 'pt' => 'Doença', _ => 'Disease' },
      // Bioseguridad / Inspecciones
      TipoNotificacion.inspeccionPendiente =>
        switch (locale) { 'es' => 'Inspección Pendiente', 'pt' => 'Inspeção Pendente', _ => 'Pending Inspection' },
      TipoNotificacion.inspeccionHoy =>
        switch (locale) { 'es' => 'Inspección Hoy', 'pt' => 'Inspeção Hoje', _ => 'Inspection Today' },
      TipoNotificacion.inspeccionVencida =>
        switch (locale) { 'es' => 'Inspección Vencida', 'pt' => 'Inspeção Vencida', _ => 'Inspection Overdue' },
      TipoNotificacion.bioseguridadCritica =>
        switch (locale) { 'es' => 'Bioseguridad Crítica', 'pt' => 'Biossegurança Crítica', _ => 'Critical Biosecurity' },
      TipoNotificacion.bioseguridadBaja =>
        switch (locale) { 'es' => 'Bioseguridad Baja', 'pt' => 'Biossegurança Baixa', _ => 'Low Biosecurity' },
      TipoNotificacion.inspeccionCompletada =>
        switch (locale) { 'es' => 'Inspección OK', 'pt' => 'Inspeção OK', _ => 'Inspection OK' },
      TipoNotificacion.necropsiaRegistrada => switch (locale) { 'es' => 'Necropsia', 'pt' => 'Necropsia', _ => 'Necropsy' },
      // Ventas / Pedidos
      TipoNotificacion.nuevoPedido => switch (locale) { 'es' => 'Nuevo Pedido', 'pt' => 'Novo Pedido', _ => 'New Order' },
      TipoNotificacion.pedidoConfirmado =>
        switch (locale) { 'es' => 'Pedido Confirmado', 'pt' => 'Pedido Confirmado', _ => 'Order Confirmed' },
      TipoNotificacion.entregaManana =>
        switch (locale) { 'es' => 'Entrega Mañana', 'pt' => 'Entrega Amanhã', _ => 'Delivery Tomorrow' },
      TipoNotificacion.entregaHoy => switch (locale) { 'es' => 'Entrega Hoy', 'pt' => 'Entrega Hoje', _ => 'Delivery Today' },
      TipoNotificacion.pedidoEntregado => switch (locale) { 'es' => 'Entregado', 'pt' => 'Entregue', _ => 'Delivered' },
      TipoNotificacion.pedidoCancelado => switch (locale) { 'es' => 'Cancelado', 'pt' => 'Cancelado', _ => 'Cancelled' },
      TipoNotificacion.pagoRecibido => switch (locale) { 'es' => 'Pago', 'pt' => 'Pagamento', _ => 'Payment' },
      TipoNotificacion.ventaRegistrada => switch (locale) { 'es' => 'Venta', 'pt' => 'Venda', _ => 'Sale' },
      // Colaboradores / Usuarios
      TipoNotificacion.invitacionRecibida => switch (locale) { 'es' => 'Invitación', 'pt' => 'Convite', _ => 'Invitation' },
      TipoNotificacion.invitacionAceptada =>
        switch (locale) { 'es' => 'Colaborador Nuevo', 'pt' => 'Novo Colaborador', _ => 'New Collaborator' },
      TipoNotificacion.invitacionRechazada =>
        switch (locale) { 'es' => 'Invitación Rechazada', 'pt' => 'Convite Recusado', _ => 'Invitation Rejected' },
      TipoNotificacion.invitacionExpirada =>
        switch (locale) { 'es' => 'Invitación Expirada', 'pt' => 'Convite Expirado', _ => 'Invitation Expired' },
      TipoNotificacion.colaboradorEliminado =>
        switch (locale) { 'es' => 'Colaborador Removido', 'pt' => 'Colaborador Removido', _ => 'Collaborator Removed' },
      TipoNotificacion.cambioRol => switch (locale) { 'es' => 'Cambio de Rol', 'pt' => 'Mudança de Função', _ => 'Role Change' },
      // Galpones
      TipoNotificacion.galponCreado => switch (locale) { 'es' => 'Nuevo Galpón', 'pt' => 'Novo Galpão', _ => 'New House' },
      TipoNotificacion.galponMantenimiento =>
        switch (locale) { 'es' => 'Mantenimiento', 'pt' => 'Manutenção', _ => 'Maintenance' },
      TipoNotificacion.galponCapacidadMaxima =>
        switch (locale) { 'es' => 'Capacidad Máxima', 'pt' => 'Capacidade Máxima', _ => 'Maximum Capacity' },
      TipoNotificacion.galponEvento => switch (locale) { 'es' => 'Evento Galpón', 'pt' => 'Evento Galpão', _ => 'House Event' },
      // Costos / Finanzas
      TipoNotificacion.gastoRegistrado => switch (locale) { 'es' => 'Gasto', 'pt' => 'Despesa', _ => 'Expense' },
      TipoNotificacion.gastoInusual =>
        switch (locale) { 'es' => 'Gasto Inusual', 'pt' => 'Despesa Incomum', _ => 'Unusual Expense' },
      TipoNotificacion.presupuestoSuperado => switch (locale) { 'es' => 'Presupuesto', 'pt' => 'Orçamento', _ => 'Budget' },
      TipoNotificacion.resumenSemanal => switch (locale) { 'es' => 'Resumen', 'pt' => 'Resumo', _ => 'Summary' },
      // Reportes
      TipoNotificacion.reporteGenerado => switch (locale) { 'es' => 'Reporte', 'pt' => 'Relatório', _ => 'Report' },
      TipoNotificacion.resumenDiario =>
        switch (locale) { 'es' => 'Resumen Diario', 'pt' => 'Resumo Diário', _ => 'Daily Summary' },
      TipoNotificacion.alertaConsolidada => switch (locale) { 'es' => 'Alertas', 'pt' => 'Alertas', _ => 'Alerts' },
      // Sistema
      TipoNotificacion.sincronizacionCompletada =>
        switch (locale) { 'es' => 'Sincronizado', 'pt' => 'Sincronizado', _ => 'Synced' },
      TipoNotificacion.actualizacionDisponible =>
        switch (locale) { 'es' => 'Actualización', 'pt' => 'Atualização', _ => 'Update' },
      TipoNotificacion.mantenimientoSistema =>
        switch (locale) { 'es' => 'Mantenimiento', 'pt' => 'Manutenção', _ => 'Maintenance' },
      TipoNotificacion.bienvenida => switch (locale) { 'es' => 'Bienvenida', 'pt' => 'Boas-vindas', _ => 'Welcome' },
      TipoNotificacion.general => switch (locale) { 'es' => 'General', 'pt' => 'Geral', _ => 'General' },
    };
  }

  /// Categoría de la notificación.
  String get categoria => switch (this) {
    stockBajo ||
    stockAgotado ||
    proximoVencer ||
    productoVencido ||
    stockReabastecido ||
    movimientoInventario => 'Inventario',

    mortalidadRegistrada ||
    mortalidadAlta ||
    mortalidadCritica ||
    loteCreado ||
    loteFinalizado ||
    pesoBajoObjetivo ||
    loteCierreProximo ||
    conversionAnormal ||
    loteSinRegistros => 'Lotes',

    produccionRegistrada ||
    produccionBaja ||
    produccionCaida ||
    primerHuevo ||
    recordProduccion ||
    metaProduccionAlcanzada => 'Producción',

    recordatorioVacunacion ||
    vacunacionManana ||
    vacunacionHoy ||
    vacunacionVencida ||
    vacunacionAplicada ||
    tratamientoIniciado ||
    periodoRetiroActivo ||
    periodoRetiroFin ||
    tratamientoFinalizado ||
    nuevoDiagnostico => 'Salud',

    sintomasRespiratorios ||
    consumoAguaAnormal ||
    consumoAlimentoAnormal ||
    temperaturaAnormal ||
    humedadAnormal ||
    enfermedadConfirmada => 'Alertas Sanitarias',

    inspeccionPendiente ||
    inspeccionHoy ||
    inspeccionVencida ||
    bioseguridadCritica ||
    bioseguridadBaja ||
    inspeccionCompletada ||
    necropsiaRegistrada => 'Bioseguridad',

    nuevoPedido ||
    pedidoConfirmado ||
    entregaManana ||
    entregaHoy ||
    pedidoEntregado ||
    pedidoCancelado ||
    pagoRecibido ||
    ventaRegistrada => 'Ventas',

    invitacionRecibida ||
    invitacionAceptada ||
    invitacionRechazada ||
    invitacionExpirada ||
    colaboradorEliminado ||
    cambioRol => 'Colaboradores',

    galponCreado ||
    galponMantenimiento ||
    galponCapacidadMaxima ||
    galponEvento => 'Galpones',

    gastoRegistrado ||
    gastoInusual ||
    presupuestoSuperado ||
    resumenSemanal => 'Finanzas',

    reporteGenerado || resumenDiario || alertaConsolidada => 'Reportes',

    sincronizacionCompletada ||
    actualizacionDisponible ||
    mantenimientoSistema ||
    bienvenida ||
    general => 'Sistema',
  };

  /// Crea desde string.
  static TipoNotificacion fromString(String value) {
    return TipoNotificacion.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TipoNotificacion.general,
    );
  }
}
