# Sistema de Notificaciones - Smart Granja Aves Pro

## Resumen

Sistema completo de notificaciones con **77 tipos** organizados en **12 categorías**.

---

## Categorías y Tipos de Notificación

### 1. INVENTARIO (6 tipos)
| Tipo | Descripción | Prioridad |
|------|-------------|-----------|
| `stockBajo` | Stock por debajo del mínimo | Alta |
| `stockAgotado` | Stock en cero | Urgente |
| `proximoVencer` | Producto próximo a vencer (7 días) | Normal/Alta |
| `productoVencido` | Producto vencido | Urgente |
| `stockReabastecido` | Stock reabastecido | Baja |
| `movimientoInventario` | Movimiento registrado | Baja |

### 2. LOTES (8 tipos)
| Tipo | Descripción | Prioridad |
|------|-------------|-----------|
| `mortalidadAlta` | Mortalidad >2% | Alta |
| `mortalidadCritica` | Mortalidad >5% | Urgente |
| `loteCreado` | Nuevo lote creado | Normal |
| `loteFinalizado` | Lote cerrado | Normal |
| `pesoBajoObjetivo` | Peso <90% del objetivo | Normal/Alta |
| `loteCierreProximo` | Cierre en próximos 7 días | Normal/Alta |
| `conversionAnormal` | Conversión alimenticia anormal | Alta |
| `loteSinRegistros` | Sin registros en 3+ días | Normal/Alta |

### 3. PRODUCCIÓN (6 tipos)
| Tipo | Descripción | Prioridad |
|------|-------------|-----------|
| `produccionRegistrada` | Producción diaria registrada | Baja |
| `produccionBaja` | Producción <80% esperada | Alta |
| `produccionCaida` | Caída brusca >10% | Urgente |
| `primerHuevo` | Primer huevo del lote | Normal |
| `recordProduccion` | Nuevo récord alcanzado | Normal |
| `metaProduccionAlcanzada` | Meta de producción cumplida | Normal |

### 4. SALUD / VACUNACIONES (10 tipos)
| Tipo | Descripción | Prioridad |
|------|-------------|-----------|
| `recordatorioVacunacion` | Vacunación en próximos 7 días | Normal |
| `vacunacionManana` | Vacunación programada mañana | Alta |
| `vacunacionHoy` | Vacunación programada hoy | Urgente |
| `vacunacionVencida` | Vacunación no aplicada | Urgente |
| `vacunacionAplicada` | Vacunación completada | Baja |
| `tratamientoIniciado` | Tratamiento iniciado | Alta |
| `periodoRetiroActivo` | Período de retiro activo | Urgente |
| `periodoRetiroFin` | Período de retiro finalizado | Alta |
| `tratamientoFinalizado` | Tratamiento completado | Normal |
| `nuevoDiagnostico` | Diagnóstico registrado | Normal/Alta/Urgente |

### 5. ALERTAS SANITARIAS (6 tipos)
| Tipo | Descripción | Prioridad |
|------|-------------|-----------|
| `sintomasRespiratorios` | Síntomas respiratorios detectados | Urgente |
| `consumoAguaAnormal` | Consumo agua ±20% | Alta |
| `consumoAlimentoAnormal` | Consumo alimento ±20% | Alta |
| `temperaturaAnormal` | Temperatura fuera de rango | Urgente |
| `humedadAnormal` | Humedad fuera de rango | Alta |
| `enfermedadConfirmada` | Enfermedad confirmada | Urgente |

### 6. BIOSEGURIDAD / INSPECCIONES (7 tipos)
| Tipo | Descripción | Prioridad |
|------|-------------|-----------|
| `inspeccionPendiente` | Inspección en próximos 3 días | Normal |
| `inspeccionHoy` | Inspección programada hoy | Alta |
| `inspeccionVencida` | Inspección no realizada | Urgente |
| `bioseguridadCritica` | Puntaje <60% | Urgente |
| `bioseguridadBaja` | Puntaje <80% | Alta |
| `inspeccionCompletada` | Inspección OK (≥80%) | Normal |
| `necropsiaRegistrada` | Necropsia registrada | Alta |

### 7. VENTAS / PEDIDOS (8 tipos)
| Tipo | Descripción | Prioridad |
|------|-------------|-----------|
| `nuevoPedido` | Nuevo pedido recibido | Alta |
| `pedidoConfirmado` | Pedido confirmado | Normal |
| `entregaManana` | Entrega programada mañana | Normal |
| `entregaHoy` | Entrega programada hoy | Alta |
| `pedidoEntregado` | Pedido entregado | Baja |
| `pedidoCancelado` | Pedido cancelado | Alta |
| `pagoRecibido` | Pago recibido | Normal |
| `ventaRegistrada` | Venta registrada | Baja |

### 8. COLABORADORES (6 tipos)
| Tipo | Descripción | Prioridad |
|------|-------------|-----------|
| `invitacionRecibida` | Invitación a granja | Alta |
| `invitacionAceptada` | Nuevo colaborador | Normal |
| `invitacionRechazada` | Invitación rechazada | Baja |
| `invitacionExpirada` | Invitación expirada | Normal |
| `colaboradorEliminado` | Colaborador removido | Alta |
| `cambioRol` | Cambio de rol | Alta |

### 9. GALPONES (4 tipos)
| Tipo | Descripción | Prioridad |
|------|-------------|-----------|
| `galponCreado` | Nuevo galpón | Normal |
| `galponMantenimiento` | Galpón en mantenimiento | Normal |
| `galponCapacidadMaxima` | Capacidad máxima alcanzada | Alta |
| `galponEvento` | Evento registrado | Baja |

### 10. COSTOS / FINANZAS (4 tipos)
| Tipo | Descripción | Prioridad |
|------|-------------|-----------|
| `gastoRegistrado` | Gasto registrado | Baja |
| `gastoInusual` | Gasto >150% promedio | Alta |
| `presupuestoSuperado` | Presupuesto excedido | Alta |
| `resumenSemanal` | Resumen financiero semanal | Baja |

### 11. REPORTES (3 tipos)
| Tipo | Descripción | Prioridad |
|------|-------------|-----------|
| `reporteGenerado` | Reporte listo para descarga | Normal |
| `resumenDiario` | Resumen automático del día | Baja |
| `alertaConsolidada` | Múltiples alertas pendientes | Normal/Alta |

### 12. SISTEMA (4 tipos)
| Tipo | Descripción | Prioridad |
|------|-------------|-----------|
| `sincronizacionCompletada` | Sincronización offline OK | Baja |
| `actualizacionDisponible` | Nueva versión disponible | Normal |
| `mantenimientoSistema` | Mantenimiento programado | Normal |
| `bienvenida` | Mensaje de bienvenida | Normal |
| `general` | Notificación general | Normal |

---

## Arquitectura

### Archivos Principales

```
lib/features/notificaciones/
├── domain/
│   ├── entities/
│   │   └── notificacion.dart          # Entidad de notificación
│   └── enums/
│       ├── tipo_notificacion.dart     # 77 tipos de notificación
│       └── prioridad_notificacion.dart # 4 niveles de prioridad
├── application/
│   ├── services/
│   │   ├── alertas_service.dart       # Servicio con 60+ métodos de alerta
│   │   └── notification_service.dart  # FCM + Local notifications
│   ├── notification_triggers.dart     # Triggers simplificados para integraciones
│   └── providers/
│       └── notificaciones_providers.dart
├── infrastructure/
│   └── repositories/
│       └── notificaciones_repository.dart
└── presentation/
    ├── providers/
    │   └── notificaciones_scheduler_provider.dart # Verificaciones automáticas
    ├── pages/
    │   └── notificaciones_page.dart
    └── widgets/
        ├── notificacion_tile.dart
        ├── notificaciones_badge.dart
        └── notificaciones_empty.dart
```

### Niveles de Prioridad

| Prioridad | Valor | Uso |
|-----------|-------|-----|
| `baja` | 0 | Informativos (registros, confirmaciones) |
| `normal` | 1 | Recordatorios, avisos estándar |
| `alta` | 2 | Requiere atención pronto |
| `urgente` | 3 | Acción inmediata requerida |

---

## Uso

### Disparar Notificaciones Manualmente

```dart
import 'package:smartgranjaavespro/features/notificaciones/notificaciones.dart';

// Usar el singleton de triggers
final triggers = NotificacionTriggers.instance;

// Ejemplo: Notificar lote creado
await triggers.onLoteCreado(
  granjaId: 'granja123',
  loteId: 'lote456',
  loteNombre: 'Lote Ponedoras A',
  cantidadAves: 5000,
  galponNombre: 'Galpón 1',
);

// Ejemplo: Notificar mortalidad
await triggers.onMortalidadRegistrada(
  granjaId: 'granja123',
  loteId: 'lote456',
  cantidadMuertos: 150,
  cantidadTotal: 5000,
);

// Ejemplo: Notificar producción con validaciones
await triggers.onProduccionRegistrada(
  granjaId: 'granja123',
  loteId: 'lote456',
  loteNombre: 'Lote A',
  cantidadHuevos: 4200,
  porcentajeProduccion: 84.0,
  porcentajeEsperado: 85.0,
  esPrimerHuevo: false,
  recordAnterior: 4100,
);
```

### Verificaciones Automáticas

El scheduler ejecuta verificaciones cada 15 minutos:

```dart
// Se inicia automáticamente al seleccionar granja
ref.watch(autoStartSchedulerProvider);

// O manualmente
ref.read(notificacionesSchedulerProvider.notifier).iniciar();

// Ejecutar verificación inmediata
ref.read(notificacionesSchedulerProvider.notifier).ejecutarAhora();
```

### Verificaciones Programadas

| Verificación | Descripción |
|--------------|-------------|
| `verificarStockBajo` | Inventario con stock bajo/agotado |
| `verificarVencimientos` | Productos próximos a vencer/vencidos |
| `verificarLotesCierreProximo` | Lotes próximos a cerrar |
| `verificarLotesSinRegistros` | Lotes sin actividad reciente |
| `verificarVacunacionesProgramadas` | Vacunaciones pendientes |
| `verificarInspeccionesPendientes` | Inspecciones de bioseguridad |
| `verificarEntregasProgramadas` | Pedidos con entrega próxima |

---

## Destinatarios por Rol

| Notificación | Owner | Admin | Manager | Operator | Viewer |
|--------------|:-----:|:-----:|:-------:|:--------:|:------:|
| Stock bajo | ✓ | ✓ | ✓ | | |
| Mortalidad | ✓ | ✓ | ✓ | | |
| Producción | ✓ | ✓ | | | |
| Vacunaciones | ✓ | ✓ | ✓ | | |
| Nuevo lote | ✓ | ✓ | ✓ | ✓ | |
| Primer huevo | ✓ | ✓ | ✓ | ✓ | |
| Invitaciones | ✓ | | | | |
| Ventas | ✓ | ✓ | ✓ | | |
| Costos | ✓ | ✓ | | | |

---

## Integración con Módulos

Para integrar notificaciones en un módulo existente:

1. Importar el archivo de triggers:
```dart
import 'package:smartgranjaavespro/features/notificaciones/notificaciones.dart';
```

2. Llamar al trigger correspondiente después de la acción:
```dart
// En un servicio de lotes
Future<void> crearLote(Lote lote) async {
  final loteId = await _repository.crear(lote);
  
  // Disparar notificación
  await NotificacionTriggers.instance.onLoteCreado(
    granjaId: lote.granjaId,
    loteId: loteId,
    loteNombre: lote.nombre,
    cantidadAves: lote.cantidadInicial,
    galponNombre: lote.galponNombre,
  );
}
```

---

## Firebase Indexes Requeridos

```json
{
  "indexes": [
    {
      "collectionGroup": "notificaciones",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "usuarioId", "order": "ASCENDING" },
        { "fieldPath": "leida", "order": "ASCENDING" },
        { "fieldPath": "fechaCreacion", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "notificaciones",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "granjaId", "order": "ASCENDING" },
        { "fieldPath": "tipo", "order": "ASCENDING" },
        { "fieldPath": "fechaCreacion", "order": "DESCENDING" }
      ]
    }
  ]
}
```

---

## Changelog

### v2.0.0 (Actual)
- ✅ Expandido de 9 a 77 tipos de notificación
- ✅ 12 categorías organizadas
- ✅ Scheduler automático cada 15 minutos
- ✅ 60+ métodos de alerta en AlertasService
- ✅ NotificacionTriggers para integración simplificada
- ✅ Soporte para push notifications (FCM)
- ✅ Notificaciones locales para alertas urgentes
- ✅ Sistema de prioridades (baja/normal/alta/urgente)
