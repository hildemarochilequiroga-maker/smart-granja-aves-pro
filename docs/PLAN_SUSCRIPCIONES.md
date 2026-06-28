# Plan de implementación — Suscripciones (Gratis / Pro / Plus)

> Estado: PLAN APROBADO PARA IMPLEMENTAR (aún sin código).
> Decisiones tomadas: **Google Play Billing** · enforcement **cliente + servidor** · plan **detallado por fases**.

---

## 0. Resumen de los planes

| Recurso | **Gratis** (US$0) | **Pro** (US$14.90 / S/49.90 mes) | **Plus** (US$34.90 / S/99.90 mes) |
|---|---|---|---|
| Granjas | 1 | 2 | ∞ |
| Galpones | 1 | 8 | ∞ |
| Lotes activos | 1 | 8 | ∞ |
| Usuarios (incl. colaboradores) | 1 | 4 | ∞ |
| Producción, mortalidad, alimento, costos, ventas, alertas | ✓ | ✓ | ✓ |
| Reportes | básicos | completos | completos |
| Apoyo prioritario | — | — | ✓ |

**Notas de diseño clave:**
- "Lotes activos" = lotes con `estado == activo`. Cerrar/vender un lote libera cupo. Esto ya es consultable (`EstadoLote.activo`).
- "Usuarios" = propietario + colaboradores aceptados en `granja_usuarios` (activo == true). En Gratis el único usuario es el propietario (no puede invitar).
- El límite de granjas se cuenta por **propietario** (`granjas.propietarioId == uid`). Los recursos hijos (galpones/lotes/usuarios) se cuentan **por granja**.
- ∞ se modela como un número centinela alto (p. ej. `-1` = ilimitado) para no dispersar `null` por el código.

---

## 1. Modelo de datos y entidad de plan (dominio)

**Objetivo:** una sola fuente de verdad para "qué puede hacer este usuario".

### 1.1 Enum `PlanSuscripcion`
Nuevo archivo `lib/features/suscripciones/domain/enums/plan_suscripcion.dart`:
- `gratis`, `pro`, `plus`.
- `fromString` / `toJson` (igual patrón que los demás enums del proyecto).

### 1.2 Value object `PlanLimites` (entitlements)
`lib/features/suscripciones/domain/value_objects/plan_limites.dart`:
```
class PlanLimites {
  final int maxGranjas;       // -1 = ilimitado
  final int maxGalpones;      // por granja
  final int maxLotesActivos;  // por granja
  final int maxUsuarios;      // por granja
  final bool reportesCompletos;
  final bool apoyoPrioritario;
  bool permite(int actual, int max) => max < 0 || actual < max;
}
```
- Tabla estática `PlanLimites.para(PlanSuscripcion)` con los valores de la sección 0.
- **Una sola tabla** = cambiar precios/límites en un solo lugar.

### 1.3 Entidad `Suscripcion`
`lib/features/suscripciones/domain/entities/suscripcion.dart`:
- `plan: PlanSuscripcion`
- `estado: EstadoSuscripcion` (`activa`, `enGracia`, `expirada`, `cancelada`)
- `vigenteHasta: DateTime?`
- `origen: OrigenSuscripcion` (`playBilling`, `manual`, `gratis`)
- `playPurchaseToken: String?`, `playProductId: String?` (para validación servidor)
- getter `planEfectivo`: si `estado != activa && estado != enGracia` ⇒ degradar a `gratis`.

### 1.4 Persistencia
Documento Firestore **`suscripciones/{uid}`** (1 por usuario propietario), no dentro de `usuarios/` (separa el dato sensible de billing del perfil y simplifica reglas).
- Lo **escribe solo el servidor** (Cloud Function que valida la compra). El cliente solo lee.
- El cliente cachea el plan en memoria vía provider.

> Decisión: el plan se ata al **propietario de la granja**, no a cada colaborador. Un colaborador opera dentro de los límites del plan del dueño de esa granja.

---

## 2. Capa de aplicación — providers de entitlements

`lib/features/suscripciones/application/providers/`:

- `suscripcionProvider` (`StreamProvider`) — observa `suscripciones/{uid}` del usuario actual; emite `Suscripcion` (default `gratis` si no existe el doc).
- `planLimitesProvider` — deriva `PlanLimites` del `planEfectivo`.
- Providers de conteo (algunos ya existen, reusar):
  - `conteoGranjasProvider` (ya existe en `granja_providers.dart`).
  - `conteoGalponesPorGranjaProvider` (derivar de galpones stream).
  - `conteoLotesActivosPorGranjaProvider` (filtrar `EstadoLote.activo`).
  - `conteoUsuariosPorGranjaProvider` (de `granja_usuarios` activos).
- `puedeCrearXProvider.family` — combina conteo + límite ⇒ `bool` + razón. Alimenta tanto el bloqueo como el paywall.

---

## 3. Enforcement en CLIENTE (UX — el upsell elegante)

**Punto de enganche:** los 3 usecases de creación ya hacen lectura previa y devuelven `Either<Failure, T>`. Se añade una verificación de límite **antes** de crear.

### 3.1 Nuevo `LimitePlanFailure`
En `lib/core/errors/failures.dart`: subtipo con `planActual`, `recursoBloqueado` (granja/galpon/lote/usuario) y `planSugerido`. Permite que la UI muestre el paywall correcto en vez de un error genérico.

### 3.2 Inyectar verificación en usecases
- `CrearGranjaUseCase`: tras `obtenerPorUsuario`, si `granjas.length >= maxGranjas` ⇒ `Left(LimitePlanFailure(...))`.
- `CrearGalponUseCase`: ya carga `galpones` de la granja ⇒ comparar con `maxGalpones`.
- `CrearLoteUseCase`: contar lotes activos de la granja ⇒ comparar con `maxLotesActivos`.
- `InvitarUsuarioAGranjaUseCase` (en `colaboradores_usecases.dart`): contar `granja_usuarios` activos ⇒ comparar con `maxUsuarios`.

> Los usecases necesitan acceso a `PlanLimites`. Se pasa el límite como parámetro (resuelto en el provider del usecase) para mantener el dominio puro y testeable.

### 3.3 UI de bloqueo / paywall
- Widget `PlanLimiteSheet` (reusa `AppBottomSheetScaffold`, ver memoria de bottom sheets) que se muestra cuando un `LimitePlanFailure` llega a la página: explica el límite alcanzado y ofrece "Mejorar a Pro/Plus".
- Botones "+ Nueva granja / galpón / lote" e "Invitar usuario": consultan `puedeCrearXProvider` y, si está al límite, muestran candado + abren el paywall en vez de la pantalla de creación.
- Gating de **reportes completos**: en la pantalla de reportes, las secciones avanzadas se muestran bloqueadas (blur/candado) si `!reportesCompletos`.

---

## 4. Pantalla de planes (Paywall)

`lib/features/suscripciones/presentation/pages/planes_page.dart`:
- 3 cards (Gratis / Pro / Plus) con el copy exacto que diste (precio USD + equivalente S/).
- Marca el plan actual; CTA contextual ("Plan actual" / "Elegir Pro" / "Elegir Plus").
- Precios y "equivalente en soles" se leen de la config de producto de Play (no hardcodear el precio final; el copy de S/ puede venir de l10n + Play price string).
- Accesos: desde Perfil, desde cada `PlanLimiteSheet`, y un punto en Home (opcional).
- i18n completo en es/en/pt (claves nuevas `plan*`).

---

## 5. Google Play Billing (cobro)

**Paquete:** `in_app_purchase` (oficial Flutter) + `in_app_purchase_android`.

### 5.1 Productos en Play Console
- Suscripciones: `pro_mensual`, `plus_mensual` (base plans mensuales).
- Configurar precios por país (USD base, Play calcula S/ y demás).

### 5.2 Flujo de compra (cliente)
`lib/features/suscripciones/infrastructure/billing/`:
1. `BillingService` inicializa `InAppPurchase.instance`, carga productos, escucha `purchaseStream`.
2. Usuario elige plan ⇒ `buyNonConsumable` / flujo de suscripción.
3. Al recibir `PurchaseStatus.purchased`: **no confiar en el cliente** — enviar el `purchaseToken` a una Cloud Function para validar.
4. `completePurchase()` tras confirmación del servidor.

### 5.3 Validación servidor (Cloud Function)
Nueva function `validarCompraPlay` (HTTPS callable, en `functions/src/`):
- Recibe `purchaseToken` + `productId`.
- Valida contra **Google Play Developer API** (`androidpublisher.purchases.subscriptionsv2.get`) usando un service account con permiso. ⚠️ Requiere habilitar la API y crear/asignar service account (acción del usuario en Play Console + Google Cloud).
- Si es válida y activa ⇒ escribe `suscripciones/{uid}` con plan, estado, `vigenteHasta`, token.
- Idempotente (reusar patrón `isAlreadyProcessed`).

### 5.4 Renovaciones / cancelaciones (Real-Time Developer Notifications)
- Configurar **RTDN** (Pub/Sub) en Play Console ⇒ topic.
- Function `onPlayNotification` (trigger Pub/Sub) actualiza `suscripciones/{uid}` en renovación, cancelación, gracia o expiración ⇒ degradación automática a `gratis`.
- Esto cierra el caso "pagó, dejó de pagar, sigue con acceso": el servidor degrada solo.

---

## 6. Enforcement en SERVIDOR (seguridad real)

Aunque el cliente bloquee, un usuario técnico podría escribir directo a Firestore. Las **reglas** deben validar los límites.

### 6.1 Helper en `firestore.rules`
- Función `planDe(uid)` que lee `suscripciones/{uid}` (o default gratis) ⇒ devuelve límites.
- En `allow create` de `granjas`, `galpones`, `lotes`, `granja_usuarios`: añadir condición de conteo.

> ⚠️ **Limitación de Firestore rules:** no pueden contar documentos de una colección (no hay `count()` en reglas). Dos estrategias:
> - **(a) Contadores denormalizados:** mantener `numeroTotalGalpones`, `numeroLotesActivos`, `numeroUsuarios` en el doc `granjas/{id}` (ya existe `numeroTotalGalpones`), actualizados por Functions/transacciones. Las reglas comparan contra esos contadores. **Recomendada.**
> - **(b) Enforcement de límites solo en Cloud Functions** (las creaciones pasan por callable functions). Más invasivo en el código actual.
> Plan: usar **(a)** — extender los contadores denormalizados y validarlos en reglas. Encaja con la cascada y contadores que ya existen.

### 6.2 Contadores denormalizados
- `granjas/{id}`: `numeroGalpones`, `numeroLotesActivos`, `numeroUsuarios` (mantener con `FieldValue.increment` en las transacciones de crear/cerrar/eliminar — ya hay transacciones en esos flujos).
- `usuarios/{uid}` o doc agregado: `numeroGranjas`.
- Reglas comparan `recursoActual < limiteDelPlan`.

---

## 7. Migración de usuarios actuales

- Todos los usuarios existentes sin doc `suscripciones/{uid}` ⇒ tratados como **gratis** por default (sin migración destructiva).
- **Riesgo:** usuarios que hoy ya tienen >1 granja/galpón/lote quedarían "por encima" del límite gratis. Decisión de negocio:
  - **Opción grandfathering (recomendada):** Cloud Function de migración única que detecta usuarios con uso > límite gratis y les asigna `plan: pro` (o `plus`) `origen: manual`, `vigenteHasta: <fecha promo>`. Así nadie pierde acceso de golpe.
  - Alternativa: bloquear solo la **creación** de nuevos recursos por encima del límite, sin borrar los existentes (más simple, menos amable).
- Script/ën función reutilizando el patrón del borrado de datos ya hecho.

---

## 8. Orden de implementación (fases)

| Fase | Entregable | Depende de |
|---|---|---|
| **F1** | Dominio: enum `PlanSuscripcion`, `PlanLimites`, entidad `Suscripcion`, modelo Firestore | — |
| **F2** | Providers de entitlements + conteos (`planLimitesProvider`, `puedeCrearXProvider`) | F1 |
| **F3** | `LimitePlanFailure` + enganche en los 4 usecases de creación (cliente) | F2 |
| **F4** | UI: `PlanLimiteSheet`, candados en botones de creación, gating de reportes | F3 |
| **F5** | Pantalla de planes (paywall) + i18n es/en/pt | F1 |
| **F6** | Google Play Billing: `BillingService`, compra, `purchaseStream` | F5 |
| **F7** | Cloud Function `validarCompraPlay` + escritura de `suscripciones/{uid}` | F6 |
| **F8** | RTDN: `onPlayNotification` (renovación/cancelación/expiración) | F7 |
| **F9** | Contadores denormalizados + reglas Firestore con límites (enforcement servidor) | F7 |
| **F10** | Migración/grandfathering de usuarios actuales | F9 |
| **F11** | QA: pruebas de cada límite, compra sandbox, degradación, analyze 0, build release | todas |

**Sugerencia de corte de valor:** F1–F5 entregan ya un producto usable (planes definidos, límites aplicados en cliente, paywall visible) aunque el cobro real (F6+) llegue después. Si quieres "lanzar rápido", F1–F5 + asignación manual de plan es un MVP vendible; F6–F9 lo hacen autónomo y seguro.

---

## 9. Acciones que dependen del usuario (fuera del código)

1. **Play Console:** crear los productos de suscripción (`pro_mensual`, `plus_mensual`), fijar precios por país.
2. **Google Cloud:** habilitar *Google Play Developer API* + service account con acceso para validar compras (F7).
3. **Play Console:** configurar *Real-Time Developer Notifications* (Pub/Sub topic) (F8).
4. **Cuenta de pruebas** de licencias para test sandbox de compras.
5. Confirmar política de **grandfathering** (sección 7) — afecta a usuarios actuales.

---

## 10. Archivos que se crearán / tocarán (mapa rápido)

**Nuevos (feature `suscripciones`):**
- `domain/enums/plan_suscripcion.dart`, `domain/value_objects/plan_limites.dart`
- `domain/entities/suscripcion.dart`, `domain/repositories/suscripcion_repository.dart`
- `infrastructure/models/suscripcion_model.dart`, `infrastructure/datasources/suscripcion_datasource.dart`
- `infrastructure/billing/billing_service.dart`
- `application/providers/suscripcion_providers.dart`
- `presentation/pages/planes_page.dart`, `presentation/widgets/plan_limite_sheet.dart`, `plan_card.dart`

**Modificados:**
- `core/errors/failures.dart` (+`LimitePlanFailure`)
- `features/granjas/domain/usecases/crear_granja.dart`
- `features/galpones/domain/usecases/crear_galpon.dart`
- `features/lotes/domain/usecases/crear_lote_use_case.dart`
- `features/granjas/domain/usecases/colaboradores_usecases.dart`
- providers de cada usecase (inyectar límites)
- páginas de listado/creación (candados + paywall): `granjas_list_page`, galpón/lote create, gestionar colaboradores, reportes
- `features/perfil/presentation/pages/perfil_page.dart` (acceso a planes)
- `firestore.rules` (límites + lectura de `suscripciones`)
- `firestore.indexes.json` (si hace falta para conteos)
- `functions/src/index.ts` (`validarCompraPlay`, `onPlayNotification`)
- `pubspec.yaml` (`in_app_purchase`)
- `lib/l10n/app_*.arb` (claves de planes/paywall)
