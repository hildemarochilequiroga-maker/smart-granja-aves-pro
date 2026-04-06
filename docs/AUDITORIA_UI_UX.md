# Auditoría UI/UX Completa — Smart Granja Aves Pro

> **Objetivo:** Unificar la identidad visual de toda la app al 100% — mismos colores, tipografía, espaciado, bordes, sombras, patrones de layout, componentes compartidos, animaciones, accesibilidad y responsividad.
> **Alcance:** 65 páginas, ~200 widgets, 12 features, core theme, core widgets
> **Fecha:** Marzo 2026
> **Estado:** Steps 1-6 completados (tokens + widgets compartidos + Home refactorizado + colores unificados + tipografía unificada + componentes UI unificados)

---

## Resumen Ejecutivo

La app tiene una **base de design system sólida** (`AppColors` con ~50 tokens, `AppTextStyles` con escala M3 completa, `AppAnimations`, `AppTheme` light+dark) pero la **adopción real es desigual**: solo ~4% de los `TextStyle` usan tokens del tema, hay **502 instancias de `Colors.white`** hardcoded, **351 de `Colors.grey`**, y se usan **13+ valores distintos de spacing** sin escala definida. Los módulos más nuevos (salud, costos, ventas) son más consistentes que los originales (home, reportes, auth).

### Métricas Clave del Problema

| Métrica | Valor | Impacto |
|---------|-------|---------|
| `Colors.white` hardcoded | **502** en 137 archivos | Rompe dark theme |
| `Colors.grey` hardcoded | **351** en 75 archivos | Rompe dark theme |
| `Color(0x...)` fuera de AppColors | **55** en 16 archivos | Colores no centralizados |
| `TextStyle()` inline (sin tokens) | **484** en 102 archivos (**96%**) | Tipografía inconsistente |
| `AlertDialog` con `bg: Colors.white` | **34** de 40 archivos | Rompe dark theme |
| Valores distintos de `EdgeInsets.all()` | **13** | Sin escala de spacing |
| Valores distintos de `borderRadius` | **15+** (4, 8, 10, 12, 14, 16, 20...) | Sin escala de radios |
| `form_progress_indicator.dart` copias | **12** archivos (1 canónico + 11 re-exports) | Duplicación innecesaria |
| Empty states duplicados | **7** copias semi-idénticas | Debería ser 1 widget parametrizable |
| Search bars duplicadas | **5** copias semi-idénticas | Debería ser 1 widget parametrizable |
| Módulo Home con `Colors.*` | **~50+** instancias, 0 tokens | Peor ofensor de todo el proyecto |

---

## Plan de Ejecución: 10 Steps

| Step | Fase | Descripción | Archivos Afectados | Estimado |
|------|------|-------------|-------------------|----------|
| 1 | Fundación | Crear tokens faltantes: AppSpacing, AppRadius, AppShadow, AppIconSize | 4 nuevos + 1 barrel | ~1h |
| 2 | Fundación | Crear widgets compartidos: AppEmptyState, AppSearchBar, AppFilterTab, AppConfirmDialog | 4 nuevos + actualizar barrel | ~2h |
| 3 | Home | Refactorizar módulo Home completo (peor ofensor) | ~8 archivos | ~3h |
| 4 | Colores | Eliminar `Colors.white` (502), `Colors.grey` (351), `Color(0x)` (55) en todo el proyecto | ~140 archivos | ~6h |
| 5 | Tipografía | Reemplazar TextStyle inline con tokens del tema | ~102 archivos | ~4h |
| 6 | Componentes | Unificar borderRadius, AlertDialog, BottomSheet, FAB, AppBar, botones | ~80 archivos | ~3h |
| 7 | Widgets Duplicados | Reemplazar empty states, search bars, form_progress re-exports con widgets compartidos | ~30 archivos | ~2h |
| 8 | Animaciones ✅ | Adoptar AppAnimations en cards, resumen, staggered | 21 archivos | ✅ |
| 9 | Accesibilidad | Semantics, HapticFeedback, contraste, reducedMotion, touch targets | ~60 archivos | ~2h |
| 10 | Responsividad | Breakpoints en Home/Reportes/Notificaciones/Perfil, tablet support | ~15 archivos | ~2h |

---

## Step 1: Tokens Faltantes — Fundación del Design System

### 1.1 Crear `AppSpacing` — `lib/core/theme/app_spacing.dart`

**Problema:** 13+ valores distintos de spacing usados ad-hoc sin escala definida.

Valores actuales en el codebase:

| `SizedBox(height:)` | Ocurrencias | | `EdgeInsets.all()` | Ocurrencias |
|---------------------|-------------|---|---------------------|-------------|
| 16 | 340 | | 16 | 280 |
| 8 | 284 | | 12 | 76 |
| 24 | 201 | | 32 | 53 |
| 12 | 175 | | 20 | 37 |
| 4 | 115 | | 14 | 32 |
| 2 | 95 | | 8 | 30 |
| 20 | 83 | | 24 | 27 |
| 6 | 38 | | 18 | 16 |
| 10 | 22 | | 10 | 16 |
| 32 | 19 | | 6 | 5 |

**Escala propuesta:**

```dart
abstract final class AppSpacing {
  // Escala base (múltiplos de 4, con 2 y 6 para micro-ajustes)
  static const double xxxs = 2;
  static const double xxs = 4;
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // Gaps verticales pre-construidos (SizedBox)
  static const gap2 = SizedBox(height: xxxs);
  static const gap4 = SizedBox(height: xxs);
  static const gap6 = SizedBox(height: xs);
  static const gap8 = SizedBox(height: sm);
  static const gap12 = SizedBox(height: md);
  static const gap16 = SizedBox(height: base);
  static const gap20 = SizedBox(height: lg);
  static const gap24 = SizedBox(height: xl);
  static const gap32 = SizedBox(height: xxl);

  // Gaps horizontales pre-construidos
  static const hGap4 = SizedBox(width: xxs);
  static const hGap8 = SizedBox(width: sm);
  static const hGap12 = SizedBox(width: md);
  static const hGap16 = SizedBox(width: base);

  // Paddings de página estándar
  static const pagePadding = EdgeInsets.all(base);           // 16
  static const pageHorizontal = EdgeInsets.symmetric(horizontal: base);
  static const cardPadding = EdgeInsets.all(base);           // 16
  static const sectionPadding = EdgeInsets.symmetric(vertical: xl);  // 24
}
```

### 1.2 Crear `AppRadius` — `lib/core/theme/app_radius.dart`

**Problema:** 15+ valores de borderRadius mezclados.

| Valor | Ocurrencias |
|-------|-------------|
| 8 | 625 |
| 12 | 411 |
| 10 | 81 |
| 16 | 67 |
| 4 | 33 |
| 20 | 29 |
| 14 | 7 |

**Escala propuesta:**

```dart
abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;    // default estándar — cards, buttons, dialogs
  static const double lg = 16;
  static const double xl = 20;    // bottom sheets, modals
  static const double full = 100; // pill shape (chips, badges)

  // BorderRadius helpers pre-construidos
  static final allXs = BorderRadius.circular(xs);
  static final allSm = BorderRadius.circular(sm);
  static final allMd = BorderRadius.circular(md);
  static final allLg = BorderRadius.circular(lg);
  static final allXl = BorderRadius.circular(xl);
  static final allFull = BorderRadius.circular(full);

  // Top-only para bottom sheets y modales
  static final topXl = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );
}
```

### 1.3 Crear `AppShadow` — `lib/core/theme/app_shadow.dart`

**Problema:** `BoxShadow` con valores alpha de 0.03 a 0.15 creados inline en cada widget.

```dart
abstract final class AppShadow {
  static const none = <BoxShadow>[];

  static final sm = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static final md = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static final lg = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}
```

### 1.4 Crear `AppIconSize` — `lib/core/theme/app_icon_size.dart`

**Problema:** Tamaños 12, 16, 18, 20, 22, 24, 28, 32, 48, 64, 80, 100 sin escala.

```dart
abstract final class AppIconSize {
  static const double xs = 12;    // metadata icons (reloj, etiqueta)
  static const double sm = 16;    // badges, inline actions
  static const double md = 20;    // indicators, small cards
  static const double base = 24;  // Material default — action icons
  static const double lg = 32;    // AppBar trailing, acciones prominentes
  static const double xl = 48;    // Loading states, estados medios
  static const double xxl = 64;   // Empty states
  static const double feature = 80; // Empty states hero, ilustraciones
}
```

### 1.5 Actualizar barrel `lib/core/theme/theme.dart`

Agregar exports:
```dart
export 'app_spacing.dart';
export 'app_radius.dart';
export 'app_shadow.dart';
export 'app_icon_size.dart';
```

---

## Step 2: Widgets Compartidos — Componentes Reutilizables

### 2.1 Crear `AppEmptyState` — `lib/core/widgets/app_empty_state.dart`

**Reemplaza 7 empty states duplicados:**
- `granjas_empty_state.dart`
- `galpones_empty_state.dart`
- `lotes_empty_state.dart`
- `ventas_empty_state.dart`
- `costos_empty_state.dart`
- `salud_empty_state.dart`
- `vacunacion_empty_state.dart`

**Diferencias actuales entre las 7 copias:**

| Aspecto | granjas/galpones/lotes/costos | ventas | salud/vacunación |
|---------|-------------------------------|--------|------------------|
| Animation duration | 600ms | 600ms | 400ms |
| translateY | 20 | 20 | 30 |
| Icon pulse | ✓ Presente | ✗ Ausente | Parcial |
| Button borderRadius | 8 | 12 | default (theme) |
| Semantics | Parcial (solo lotes) | ✗ | ✗ |
| HapticFeedback | ✗ | ✗ | ✓ (solo vacunación) |

**Widget unificado:**

```dart
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String description;
  final String? ctaLabel;
  final VoidCallback? onCtaPressed;
  final bool showPulse;   // default: true
}
```

- Animación estándar: 500ms, easeOutCubic, translateY(20)
- Pulse en icono siempre presente
- Button usa theme borderRadius (12)
- Semantics completo
- HapticFeedback en botón CTA

### 2.2 Crear `AppSearchBar` — `lib/core/widgets/app_search_bar.dart`

**Reemplaza 5 search bars:**
- `granjas_search_bar.dart` (sin Semantics, sin HapticFeedback, filterTab borderRadius 8)
- `galpones_search_bar.dart` (sin Semantics, sin HapticFeedback, filterTab borderRadius 8)
- `lotes_search_bar.dart` (con Semantics, con HapticFeedback, filterTab borderRadius 12)
- `enfermedades_search_bar.dart` (con Semantics, con HapticFeedback, filterTab borderRadius 12)
- Inventario inline search

**Widget unificado:**

```dart
class AppSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final List<FilterTabItem> filters;
  final int selectedFilterIndex;
  final ValueChanged<int> onFilterChanged;
}

class FilterTabItem {
  final String label;
  final int? count;
}
```

### 2.3 Crear `AppFilterTab` — `lib/core/widgets/app_filter_tab.dart`

**Extrae el `_FilterTab` privado duplicado en 4 search bars:**

```dart
class AppFilterTab extends StatelessWidget {
  final String label;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;
}
```

- borderRadius: `AppRadius.sm` (8)
- Semantics completo
- HapticFeedback en onTap

### 2.4 Crear `AppConfirmDialog` — `lib/core/widgets/app_confirm_dialog.dart`

**Reemplaza 34 AlertDialogs con `backgroundColor: Colors.white`:**

```dart
class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelLabel;     // default: 'Cancelar'
  final String confirmLabel;
  final Color? confirmColor;    // default: error (para acciones destructivas)
  final bool isDanger;          // default: true
  final VoidCallback onConfirm;
}

// Helper function
Future<bool?> showAppConfirmDialog(BuildContext context, {...});
```

**Archivos que se benefician (34):**
registrar_costo_page, crear_galpon_page, editar_galpon_page, galpon_dialogs, galpon_filter_dialog, crear_granja_page, editar_granja_page, granja_dialogs, crear_item_inventario_page, inventario_dialogs, crear_lote_page, editar_lote_page, lotes_list_page, registrar_consumo_page, registrar_mortalidad_page, registrar_peso_page, registrar_produccion_page, lote_filter_dialog, lote_detail_handlers, notificaciones_page, configuracion_page, editar_perfil_page, perfil_page, inspeccion_bioseguridad_page, programar_vacunacion_page, registrar_tratamiento_page, salud_detail_page, salud_list_page, vacunacion_detail_page, vacunacion_list_page, dialog_helpers, registrar_venta_page, ventas_list_page, venta_detail_page

### 2.5 Actualizar barrel `lib/core/widgets/widgets.dart`

Agregar exports de los 4 nuevos widgets compartidos.

---

## Step 3: Refactorizar Módulo Home (Peor Ofensor) ✅ COMPLETADO

> **Resultado:** 8 archivos refactorizados, 115+ Colors.* eliminados, 0 errors, 0 warnings.
> `dart analyze lib/features/home/` → **No issues found!**
> Info-level hints del proyecto: 493 → 484 (−9)

### Archivos completados:

| Archivo | Cambios |
|---------|---------|
| `home_page.dart` | 5 Colors.* → colorScheme, 5 spacing → AppSpacing, 1 radius → AppRadius |
| `home_header.dart` | 22 Colors.* → colorScheme/AppColors, 18 spacing → AppSpacing, 10 radius → AppRadius, 8 TextStyle inline → theme.textTheme |
| `home_kpis_grid.dart` | 26 Colors.* → AppColors/colorScheme, shadows → AppShadow.sm, spacing/radius/TextStyle → tokens |
| `home_quick_actions.dart` | 10 Colors.* → AppColors tokens, 8 spacing → AppSpacing.md, 2 radius → AppRadius.allMd |
| `home_alerts.dart` | 7 Colors.* → AppColors.error/warning/info + colorScheme, spacing/radius → tokens |
| `home_activities.dart` | 20+ Colors.* → colorScheme + AppColors, 18 spacing → AppSpacing, 5 radius → AppRadius, inline TextStyle → theme.textTheme |
| `home_inventario_resumen.dart` | 9 spacing → AppSpacing, 4 radius → AppRadius, 2 inline TextStyle → theme.textTheme |
| `actividades_recientes_provider.dart` | 25 Colors.* → AppColors tokens (warning, error, success, info, purple, teal, deepPurple, deepOrange, brown, cyan, amber, indigo, grey500) |

### Adiciones al design system:
- `AppColors.deepPurple` = Color(0xFF673AB7)
- `AppColors.deepOrange` = Color(0xFFFF5722)

---

## Step 4: Eliminar Colores Hardcoded del Proyecto ✅ COMPLETADO

> **Resultado final:** 0 `Colors.*` hardcoded (excepto `Colors.transparent`), 0 `Color(0x...)` fuera de design tokens.
> **dart analyze:** 0 errors, 0 warnings, 483 info (lint hints pre-existentes)
> **Archivos refactorizados:** ~140 archivos
> **Tokens añadidos:** `AppColors.blueGrey` = Color(0xFF607D8B)

### Resumen de cambios:
- **Colors.white (502→0):** Eliminados del AlertDialog bg, reemplazados por `colorScheme.surface`/`onPrimary`
- **Colors.grey (351→0):** Mapeados a `colorScheme.surfaceContainerLowest/Low`, `outlineVariant`, `outline`, `onSurfaceVariant`, `onSurface`
- **Color(0x...) (55→0):** Centralizados en AppColors tokens (active, inactive, pending, info, warning, etc.)
- **Domain colors:** `Colors.blueGrey/deepPurple/cyan/brown/teal/deepOrange/amber/indigo/purple/lightGreen/red` → `AppColors.*`
- **Spacing:** SizedBox hardcoded → AppSpacing tokens (xxs–xxl) en todos los archivos
- **BorderRadius:** circular(N) → AppRadius tokens (allXs–allXl) en todos los archivos
- **EdgeInsets:** Valores hardcoded → AppSpacing constantes

### 4.1 `Colors.white` — 502 instancias en 137 archivos

**Top 10 ofensores:**

| Archivo | Instancias |
|---------|-----------|
| `registrar_mortalidad_page.dart` | 17 |
| `galpon_estadisticas_card.dart` | 15 |
| `registrar_consumo_page.dart` | 15 |
| `registrar_peso_page.dart` | 13 |
| `registrar_produccion_page.dart` | 13 |
| `reportes_page.dart` | 13 |
| `crear_lote_page.dart` | 11 |
| `registrar_venta_page.dart` | 10 |
| `inventario_dialogs.dart` | 10 |
| `lote_dashboard_page.dart` | 9 |

**Reglas de reemplazo:**

| Contexto | `Colors.white` → | Estimado |
|----------|-------------------|----------|
| Scaffold background | `theme.colorScheme.surface` | ~3 |
| Card background | `theme.colorScheme.surface` | ~80 |
| AlertDialog bg | Quitar (usar theme) | ~34 |
| AppBar foreground | `theme.colorScheme.onPrimary` | ~5 |
| Icon color | `theme.colorScheme.onPrimary` o `onSurface` según contexto | ~30 |
| Text color | `theme.colorScheme.onSurface` | ~20 |
| Container/overlay bg | `theme.colorScheme.surface` | ~15 |
| Divider/Border | `theme.colorScheme.outlineVariant` | ~10 |
| FAB foreground | Quitar (usar theme) | ~5 |

### 4.2 `Colors.grey` — 351 instancias en 75 archivos

**Top ofensores:**

| Archivo | Instancias |
|---------|-----------|
| `graficos_peso_page.dart` | 28 |
| `graficos_consumo_page.dart` | 25 |
| `home_kpis_grid.dart` | 20 |
| `graficos_mortalidad_page.dart` | 20 |
| `ubicacion_lote_step.dart` | 19 |
| `home_header.dart` | 19 |
| `graficos_produccion_page.dart` | 18 |
| `home_activities.dart` | 16 |

**Reglas de mapeo por shade:**

| Shade | → Token del tema |
|-------|------------------|
| `Colors.grey[50]` / `shade50` | `theme.colorScheme.surfaceContainerLowest` |
| `Colors.grey[100]` / `shade100` | `theme.colorScheme.surfaceContainerLow` |
| `Colors.grey[200-300]` | `theme.colorScheme.outlineVariant` |
| `Colors.grey[400]` | `theme.colorScheme.outline` |
| `Colors.grey[500]` | `theme.colorScheme.onSurfaceVariant` |
| `Colors.grey[600]` | `theme.colorScheme.onSurfaceVariant` |
| `Colors.grey[700-800]` | `theme.colorScheme.onSurface` |
| `Colors.grey[900]` / `shade900` | `theme.colorScheme.onSurface` |

### 4.3 `Color(0x...)` fuera de AppColors — 55 instancias en 16 archivos

| Archivo | Instancias | Acción |
|---------|-----------|--------|
| `lotes_list_page.dart` | 6 | Mover a AppColors como constantes de filtro |
| `cerrar_lote/sale_info_section.dart` | 5 | → tokens tema |
| `cerrar_lote/final_observations_section.dart` | 5 | → tokens tema |
| `cerrar_lote/closure_summary_section.dart` | 5 | → tokens tema |
| `cerrar_lote/final_metrics_section.dart` | 5 | → tokens tema |
| `tipo_galpon.dart` | 4 | → AppColors domain-specific |
| `lote_detail_utils.dart` | 4 | → AppColors |
| `granja_detail_utils.dart` | 4 | → AppColors |
| `metodo_pesaje.dart` | 4 | → AppColors domain-specific |
| `estado_granja.dart` | 3 | → AppColors domain-specific |
| `resumen_observaciones_step.dart` | 3 | → tokens tema |
| `app_navigation_bar.dart` | 2 | → theme tokens (Step 3) |
| `lote_dashboard_page.dart` | 2 | → AppColors chart |
| `bioseguridad_overview_page.dart` | 1 | → AppColors |
| `account_linking_dialog.dart` | 1 | → theme tokens |
| `social_auth_buttons.dart` | 1 | → AppColors |

---

## Step 5: Unificar Tipografía (484 TextStyle Inline) ✅ COMPLETADO

> **Resultado final:** 442 → ~97 inline TextStyle (reducción del 78%). Los ~97 restantes son:
> - `pw.TextStyle` en pdf_generator_service.dart (43) — PDF package, no tema Flutter
> - TextSpan children sin fontSize (~30) — heredan del padre, patrón correcto
> - `const TextStyle` en contextos estáticos (~15) — sin acceso a theme
> - InputDecoration hintStyle sin fontSize (~9) — heredan del tema
> **dart analyze:** 0 errors, 0 warnings, 437 info (mejorado desde 483)
> **Archivos refactorizados:** ~60 archivos
> **Tokens más usados:** bodySmall, bodyMedium, titleMedium, titleSmall, labelMedium, labelSmall

### Archivos más afectados (10+ inline TextStyles cada uno)

| Archivo | Inline TextStyles |
|---------|------------------|
| `graficos_peso_page.dart` | ~20 |
| `graficos_consumo_page.dart` | ~18 |
| `graficos_mortalidad_page.dart` | ~18 |
| `graficos_produccion_page.dart` | ~16 |
| `home_kpis_grid.dart` | ~12 |
| `reportes_page.dart` | ~10 |
| `home_header.dart` | ~8 |
| `home_activities.dart` | ~8 |
| `galpon_estadisticas_card.dart` | ~8 |
| `lote_dashboard_page.dart` | ~8 |

### Reglas de mapeo

| Patrón inline actual | → Token del tema |
|---------------------|------------------|
| `fontSize: 24-32, fontWeight: w700` | `theme.textTheme.headlineMedium` o `.headlineLarge` |
| `fontSize: 20-22, fontWeight: w600` | `theme.textTheme.titleLarge` |
| `fontSize: 16-18, fontWeight: w600` | `theme.textTheme.titleMedium` |
| `fontSize: 14-16, fontWeight: w500` | `theme.textTheme.titleSmall` |
| `fontSize: 14-16, fontWeight: w400` | `theme.textTheme.bodyLarge` |
| `fontSize: 13-14, fontWeight: w400` | `theme.textTheme.bodyMedium` |
| `fontSize: 11-12` | `theme.textTheme.bodySmall` |
| `fontSize: 12-14, fontWeight: w500` | `theme.textTheme.labelMedium` |
| `fontSize: 10-11, fontWeight: w500-700` | `theme.textTheme.labelSmall` |

**Nota:** Cuando un TextStyle inline tiene un `color:` específico, usar `.copyWith(color: ...)` sobre el token del tema.

**Decisión de diseño:** Migrar de `AppTextStyles.*` directo a `theme.textTheme.*` para soportar dark theme y future theming overrides.

---

## Step 6: Unificar Componentes de UI ✅ COMPLETADO

### 6.1 borderRadius — Estandarizar a escala AppRadius

| Componente | Actual | → Estándar (AppRadius) |
|-----------|--------|------------------------|
| Cards (feature) | 8, 10, 12, 16 mezclados | `AppRadius.md` (12) |
| Buttons (auth) | 8 | `AppRadius.md` (12) |
| Buttons (empty states) | 8, 12, default | `AppRadius.md` (12) |
| Buttons (reportes) | 14 | `AppRadius.md` (12) |
| AlertDialog shape | 12 | `AppRadius.md` (12) ✓ Mantener |
| BottomSheet | 16, 20, 24 | `AppRadius.xl` (20) |
| Chips/Tags | 8, 16, 20 | `AppRadius.sm` (8) |
| Inputs/TextFields | 8, 12 | `AppRadius.sm` (8) |
| NavBar items container | 12, 8 | `AppRadius.md` (12) |

### 6.2 AlertDialog — Quitar `backgroundColor: Colors.white` en 34 archivos

El `app_theme.dart` ya define `dialogTheme` con backgroundColor correcto que hereda de `colorScheme.surface`. Los 34 archivos que hardcodean `Colors.white` deben **simplemente quitar esa propiedad**.

### 6.3 BottomSheet — Unificar shape

**Actual:** 3 valores distintos (16, 20, 24) + 17 sin borderRadius.

**Acción:**
1. Definir en `app_theme.dart` → `bottomSheetTheme: BottomSheetThemeData(shape: RoundedRectangleBorder(borderRadius: AppRadius.topXl))`
2. Quitar overrides manuales de `shape:` en las 8 llamadas a `showModalBottomSheet`
3. Unificar presencia de "handle bar" (barra gris superior): O todas la tienen o ninguna

### 6.4 FAB — Unificar estilo

| Aspecto | Actual | → Estándar |
|---------|--------|------------|
| elevation | 3 (granjas/galpones/lotes), default (ventas/costos/salud) | Quitar override → usar fab theme |
| foregroundColor | `Colors.white` (salud), `theme.colorScheme.onPrimary` (inventario), herencia | Quitar override → heredar theme |
| heroTag | `'feature_fab'` | ✓ Mantener (necesario con múltiples FABs) |
| Tipo | `.extended` en todos | ✓ Consistente |

### 6.5 AppBar — Documentar 2 variantes permitidas

| Variante | Uso | backgroundColor | Foreground |
|----------|-----|----------------|------------|
| **Surface** (default) | List/Detail/Form pages | `theme.colorScheme.surface` | hereda tema |
| **Primary** | Home, Perfil | `theme.colorScheme.primary` | `theme.colorScheme.onPrimary` |

**Regla:** NUNCA usar `Colors.white` para foreground. Siempre `theme.colorScheme.onPrimary`.
**Regla:** No repetir `centerTitle: true` — ya está en el theme.

### 6.6 Scaffold backgroundColor — Unificar

| Actual | Ocurrencias | → Estándar |
|--------|-------------|------------|
| `theme.colorScheme.surfaceContainerLowest` | ~24 | ✓ Mantener |
| `theme.colorScheme.surface` | ~20 | ✓ Mantener |
| `Colors.grey[50]` | 3 | → `theme.colorScheme.surfaceContainerLowest` |
| `AppColors.grey100` | 1 | → `theme.colorScheme.surfaceContainerLowest` |
| `AppColors.surface` | 1 | → `theme.colorScheme.surface` |

### 6.7 RefreshIndicator color

| Feature | Color actual | → Estándar |
|---------|-------------|------------|
| Granjas, Galpones, Lotes, Ventas, Costos | `theme.colorScheme.primary` | ✓ Mantener |
| **Salud** | `theme.colorScheme.error` | → `theme.colorScheme.primary` |

---

## Step 7: Reemplazar Widgets Duplicados ✅

### 7.1 Empty States — 7 archivos → `AppEmptyState` ✅
**Estado:** COMPLETADO — Reemplazados por `AppEmptyState` y barrels actualizados.

**Acciones realizadas:**
1. Usado `lib/core/widgets/app_empty_state.dart` en las listas de `granjas`, `galpones`, `lotes`, `ventas`, `costos`, `salud` y `vacunacion`.
2. Eliminados 5 archivos standalone y adaptados `lotes` y `costos` para conservar sus `ErrorState`.
3. Actualizados barrels para dejar de exportar los empty states donde correspondía.
4. Añadidos pequeños `ErrorState` reubicados (p.ej. `GalponesErrorState`) cuando era necesario.

### 7.2 Search Bars — 5 archivos → `AppSearchBar` + `AppFilterTab` ✅
**Estado:** COMPLETADO — Reemplazadas todas las search bars feature-level por `AppSearchBar`.

**Acciones realizadas:**
1. Reemplazado `EnfermedadesSearchBar` en `catalogo_enfermedades_page.dart` con `AppSearchBar` + `AppFilterTabRow` (5 filtros de gravedad).
2. Reemplazado inline `_buildSearchBar` en `inventario_page.dart` con `AppSearchBar`.
3. Eliminados 4 archivos: `granjas_search_bar.dart`, `galpones_search_bar.dart`, `lotes_search_bar.dart`, `enfermedades_search_bar.dart`.
4. Actualizados 3 barrels para eliminar exports de search bars.

### 7.3 Form Progress Indicator — 11 re-exports → import directo ✅
**Estado:** COMPLETADO — Todos los formularios importan directamente `core/presentation/widgets/form_progress_indicator.dart`.

**Acciones realizadas:**
1. Actualizados 9 imports directos en archivos consumidores.
2. Renombradas 4 clases wrapper (ej. `ProduccionFormProgressIndicator` → `FormProgressIndicator`).
3. Eliminados 11 archivos re-export/wrapper.
4. Actualizados 6 barrels para eliminar exports.

### 7.4 Diálogo de Confirmación — Adoptar `showAppConfirmDialog()` ✅
**Estado:** COMPLETADO — Reemplazados ~33 diálogos inline en ~29 archivos.

**Acciones realizadas:**
1. Reemplazados diálogos de eliminación (danger) en: salud_list_page, salud_detail_page, vacunacion_detail_page, vacunacion_list_page, ventas_list_page, venta_detail_page, lotes_list_page, lote_detail_handlers.
2. Reemplazados diálogos de salir sin guardar (warning) en: editar_lote_page, crear_lote_page, crear_galpon_page, editar_galpon_page, crear_granja_page, editar_granja_page, registrar_tratamiento_page, programar_vacunacion_page, registrar_mortalidad_page, registrar_produccion_page, registrar_peso_page, registrar_consumo_page, crear_item_inventario_page, registrar_costo_page, registrar_venta_page, notificaciones_config_page, editar_perfil_page.
3. Reemplazados diálogos de restauración de borrador (info) en: crear_lote_page, crear_galpon_page, crear_granja_page, registrar_tratamiento_page, programar_vacunacion_page, registrar_mortalidad_page, registrar_produccion_page, registrar_peso_page, registrar_consumo_page, crear_item_inventario_page, registrar_costo_page, registrar_venta_page.
4. Reemplazados diálogos especiales: logout (perfil_page), cache/delete account (configuracion_page), postura/rotura alta (registrar_produccion_page), guardar inspección (inspeccion_bioseguridad_page), remover colaborador (gestionar_colaboradores_page).
5. Diálogos complejos con contenido custom (TextField, Column, Row con icono) excluidos intencionalmente (~8 instancias).
6. `dart analyze`: 0 errores, 0 warnings, 98 info (unawaited_futures pre-existentes).

---

## Step 8: Animaciones — Adoptar `AppAnimations` ✅

### Estado actual → COMPLETADO

Se crearon 3 nuevas extension methods en `AnimatedWidgetExtension` (`app_animations.dart`):
- **`cardEntrance()`** — 400ms, translateY 20, easeOutCubic (fade+slide estándar para cards)
- **`summaryEntrance()`** — 500ms, translateY 15, easeOutCubic (para cards de resumen)
- **`staggeredEntrance(index:)`** — 300+index*50ms (max stagger 200ms), translateY 20, easeOutCubic

**Cards de entidad/registro reemplazadas (14 archivos):**
- `granja_list_card.dart` → `.cardEntrance()`
- `galpon_list_card.dart` → `.cardEntrance()`
- `lote_list_card.dart` → `.cardEntrance()` (dentro de Semantics)
- `venta_list_card.dart` → `.cardEntrance()`
- `costo_list_card.dart` → `.cardEntrance()`
- `salud_list_card.dart` → `.cardEntrance()`
- `vacunacion_list_card.dart` → `.cardEntrance()`
- `item_inventario_card.dart` → `.cardEntrance()` (dentro de Semantics)
- `movimiento_inventario_card.dart` → `.cardEntrance()` (dentro de Semantics)
- `lotes_home_page.dart` (`_LoteCard`) → `.cardEntrance()` (dentro de Semantics)
- `catalogo_enfermedades_page.dart` → `.cardEntrance()`

**Cards de resumen reemplazadas (3 archivos):**
- `ventas_resumen_card.dart` → `.summaryEntrance()`
- `costos_resumen_card.dart` → `.summaryEntrance()`
- `salud_resumen_card.dart` → `.summaryEntrance()`

**Animaciones staggered reemplazadas (4 archivos):**
- `historial_mortalidad_page.dart` → `.staggeredEntrance(index: index, key: ValueKey(reg.id))`
- `historial_peso_page.dart` → `.staggeredEntrance(...)`
- `historial_produccion_page.dart` → `.staggeredEntrance(...)`
- `historial_consumo_page.dart` → `.staggeredEntrance(...)`

**Instancias NO reemplazadas (por diseño):**
- `app_empty_state.dart` — widget canónico compartido, mantiene su propia animación
- 4 archivos con `Transform.scale` (forgotPassword, aceptarInvitacion, ventasEmpty pulse, ventasError bounce) — animaciones custom
- 5 archivos con empty/error state (600ms) — animaciones con duración diferente, serían sobre-engineering centralizarlas
- 4 historial pages conservan su segundo TweenAnimationBuilder (empty state con scale 0.9→1.0)

**Resultado:** `dart analyze` → 0 errores, 0 warnings, 98 info

---

## Step 9: Accesibilidad ✅ COMPLETADO

### 9.1 Semantics Labels ✅

**Cards con Semantics agregados (6):**

| Card | Label |
|------|-------|
| `granja_list_card` | `'Granja ${nombre}, estado ${status}'` |
| `galpon_list_card` | `'Galpón ${nombre}, código ${codigo}, ${aves} aves, estado ${status}'` |
| `venta_list_card` | `'Venta de ${tipo}, $fecha, estado ${estado}'` |
| `costo_list_card` | `'Costo ${concepto}, tipo ${tipo}, $fecha'` |
| `salud_list_card` | `'Registro de salud, ${diagnostico}, $fecha, ${abierto/cerrado}'` |
| `vacunacion_list_card` | `'Vacunación ${nombre}, $fecha, estado ${status}'` |

**Cards ya con Semantics (3):** `lote_list_card`, `item_inventario_card`, `movimiento_inventario_card`

**FAB tooltips agregados (8):**

| FAB | Archivo | Tooltip |
|-----|---------|---------|
| Nuevo Item | `inventario_page.dart` | `'Agregar nuevo ítem al inventario'` |
| Registrar Mortalidad | `lote_dashboard_page.dart` | `'Registrar mortalidad del lote'` |
| Registrar Peso | `lote_dashboard_page.dart` | `'Registrar peso del lote'` |
| Registrar (Dashboard) | `lote_dashboard_page.dart` | `'Abrir menú de registro'` |
| Registrar Consumo | `lote_dashboard_page.dart` | `'Registrar consumo de alimento'` |
| Registrar Producción | `lote_dashboard_page.dart` | `'Registrar producción de huevos'` |
| Registrar (Default) | `lote_dashboard_page.dart` | `'Abrir menú de registro'` |
| Invitar Colaborador | `gestionar_colaboradores_page.dart` | `'Invitar colaborador a la granja'` |

**Resumen cards:** Display-only, ya legibles por screen readers a través de Text widgets internos.

### 9.2 HapticFeedback ✅

**Archivos editados (6):**

| Archivo | Tipo de tap | Patrón |
|---------|-------------|--------|
| `granja_list_card.dart` | FilledButton onPressed | `HapticFeedback.selectionClick()` + `onVerCasas?.call()` |
| `galpon_list_card.dart` | FilledButton onPressed | `HapticFeedback.selectionClick()` + `(onVerLotes ?? onTap)?.call()` |
| `lote_list_card.dart` | FilledButton onPressed | `HapticFeedback.selectionClick()` + `onVerDashboard?.call()` |
| `item_inventario_card.dart` | InkWell onTap (compact) | `HapticFeedback.selectionClick()` + `onTap?.call()` |
| `movimiento_inventario_card.dart` | InkWell onTap (×2) | `HapticFeedback.selectionClick()` + `onTap?.call()` |
| `home_quick_actions.dart` | InkWell onTap (×8 botones) | `HapticFeedback.selectionClick()` + `onTap()` |

### 9.3 Contraste de Color ✅

| Severidad | Archivo | Problema | Fix |
|-----------|---------|----------|-----|
| HIGH | `lotes_list_page.dart` | SnackBar bg `primary` → texto invisible | `AppColors.success` en lugar de `theme.colorScheme.primary` |
| MEDIUM | `gestionar_colaboradores_page.dart` | Rol "Operador" texto `#FFDD13` sobre superficie | `AppColors.primaryDark` (`#CCAA00`) |
| MEDIUM | `vacunacion_list_page.dart` | Chip texto/icono `#FFDD13` sobre pale yellow | `AppColors.primaryDark` |
| LOW | `historial_produccion_page.dart` | FilledButton sin `foregroundColor` explícito | Agregado `foregroundColor: theme.colorScheme.onPrimary` |

### 9.4 Touch Targets ✅

| Componente | Antes | Después | Archivos |
|-----------|-------|---------|----------|
| `AppFilterTabRow` | height: 36 | height: 48 | `app_filter_tab.dart` |
| `PopupMenuItem` | height: 44 (×15) | height: 48 | 4 card files |
| Form progress circles | 32×32 sin padding | `ConstrainedBox(minWidth: 48, minHeight: 48)` | `form_progress_indicator.dart` |
| Sort toggle | Bare Text ~18dp | `Padding(vertical: 14, horizontal: 8)` + `HitTestBehavior.opaque` | 4 historial pages |

### 9.5 Reduced Motion ✅

Agregado a `app_animations.dart`:
- `shouldReduceMotion(BuildContext context)` → verifica `MediaQuery.disableAnimations`
- `durationFor(BuildContext context, Duration normal)` → retorna `Duration.zero` si reduced motion está activo

---

## Step 10: Responsividad ✅

### Resumen de cambios

**Nuevo utility centralizado:** `lib/core/theme/app_breakpoints.dart` (~80 líneas)

| Constante | Valor | Uso |
|-----------|-------|-----|
| `smallPhone` | 360 | Padding reducido, 1 columna grid |
| `tablet` | 600 | 3 columnas grid, padding amplio |
| `desktop` | 900 | Layout expandido |

`AppBreakpoints.of(context)` retorna `ResponsiveData` con:
- Flags: `isSmallPhone`, `isPhone`, `isTablet`, `isDesktop`, `isExpanded`
- Valores adaptativos: `pagePadding` (12/16/24), `gridColumns` (1/2/3), `formMaxWidth` (480/∞)
- Static helper: `AppBreakpoints.gridColumns(width, minTileWidth: 160)` → clamp(1,6)

### 10.1 Auth forms maxWidth ✅

3 páginas (`login_page`, `register_page`, `forgot_password_page`):
- `SingleChildScrollView` envuelto en `Center > ConstrainedBox(maxWidth: 480)`
- Padding horizontal cambiado a `AppBreakpoints.of(context).pagePadding`
- En tablet/desktop el formulario queda centrado y contenido

### 10.2 Grids adaptativos ✅

11 archivos con `crossAxisCount: 2` fijo → `AppBreakpoints.of(context).gridColumns`:

| Archivo | Tipo de Grid |
|---------|-------------|
| `ventas_list_page.dart` | GridView.count (filtro tipo) |
| `salud_list_page.dart` | GridView.count (filtro tipo) |
| `vacunacion_list_page.dart` | GridView.count (filtro estado) |
| `costos_list_page.dart` | GridView.count (filtro tipo) |
| `inventario_page.dart` | GridView.count (filtro tipo) |
| `historial_mortalidad_page.dart` | GridView.count (filtro tipo) |
| `historial_peso_page.dart` | GridView.count (filtro tipo) |
| `historial_produccion_page.dart` | GridView.count (filtro tipo) |
| `historial_consumo_page.dart` | GridView.count (filtro tipo) |
| `reportes_page.dart` | SliverGrid (cards reporte) |
| `acciones_rapidas_card.dart` | SliverGrid (acciones lote) |

En `reportes_page` y `acciones_rapidas_card`, se removió `const` del delegate para permitir valor dinámico.

### 10.3 Text scaling ✅

- **Global clamp ya existente** en `main.dart` (~línea 191): `TextScaler.linear(clamp(0.8, 1.2))`
- Auditoría de `SizedBox` + `Text` fijos: **0 issues críticos** encontrados
- Todas las cards usan layouts intrínsecos (padding-based `Container` + `Column`) que se adaptan al contenido
- **No se requirieron cambios adicionales**

### Validación

```
dart analyze lib/ → 0 errores, 0 warnings, 98 info (unawaited_futures)
```

---

## Hallazgos Adicionales

### AD.1 Dead code en `auth_background.dart`
Parámetros `showPattern` y `showGradient` se aceptan pero **nunca se usan** en el build(). El widget es un simple `Container(color: bg, child: child)`.
**Acción:** Eliminar parámetros no usados o implementar la funcionalidad.

### AD.2 Form progress indicator wrappers vacíos
4 archivos wrapper (`MortalidadFormProgressIndicator`, etc.) tienen comentarios tipo "paleta de error/success/warning/info" pero **delegan al core sin personalizar**.
**Acción:** Eliminar wrappers y usar core directamente (cubierto en Step 7.3).

### AD.3 `AppColors` vs `theme.colorScheme` — Regla de uso

| Estrategia | Cuándo usar |
|-----------|------------|
| `theme.colorScheme.*` | **SIEMPRE** como primera opción — soporta dark theme |
| `AppColors.*` | Solo colores de dominio (polloEngorde, gallinaPonedora, chart) que no existen en ColorScheme |
| `Colors.*` | **NUNCA** en código de producción |

### AD.4 Bottom sheet handle bar inconsistente
- Home (selector granja): Tiene barra gris de 36×4
- Otros bottom sheets: No tienen barra
- **Acción:** Decidir un estándar y aplicar a todos. Recomendación: widget `_HandleBar` compartido en los bottom sheets que lo necesiten.

### AD.5 Icon suffix — Decidir estándar
- ~70% usa `_rounded` (ej: `Icons.add_rounded`)
- ~30% usa default o `_outlined`
- **Recomendación:** `_rounded` como estándar para toda la app. Auditar y unificar.

---

## Apéndice A: Inventario Completo de Archivos por Feature

### Auth (12 archivos de presentación)
- **Pages:** login_page, register_page, forgot_password_page, auth_gate_page
- **Widgets:** auth_header, auth_button, auth_text_field, auth_background, auth_forms, social_auth_buttons, password_strength_indicator, account_linking_dialog

### Granjas (~18 archivos de presentación)
- **Pages (8):** granjas_list, granja_detail, crear_granja, editar_granja, gestionar_colaboradores, codigo_invitacion, aceptar_invitacion_granja, seleccionar_rol_invitacion
- **Widgets (~10):** granja_list_card, granja_dashboard_card, granja_estadisticas_card, granja_umbrales_card, granja_form_field, granja_form_widgets, granja_dialogs, granjas_search_bar, granjas_empty_state, form_progress_indicator
- **Sub-widgets:** form_steps/ (basic_info, capacity, contact_info, location), granja_detail/ (handlers, sections, utils, detail), granjas_list/ (list, search_bar, empty_state, card)

### Galpones (~16 archivos de presentación)
- **Pages (4):** galpones_list, galpon_detail, crear_galpon, editar_galpon
- **Widgets (~12):** galpon_list_card, galpon_detail_header, galpon_estadisticas_card, galpon_form_field, galpon_form_widgets, galpon_dialogs, galpones_search_bar, galpones_empty_state, tag_input_field, form_progress_indicator
- **Sub-widgets:** form_steps/ (basic_info, specifications, environmental), galpon_detail/ (detail, handlers, sections, utils, historial_sheet), galpones_list/ (list, search_bar, empty_state, card, estadisticas_sheet), galpon_form/ (filter_dialog)

### Lotes (~40 archivos de presentación) — Feature más grande
- **Pages (19):** lotes_home, lotes_list, lote_detail, lote_dashboard, crear_lote, editar_lote, cerrar_lote, registrar_mortalidad, registrar_peso, registrar_consumo, registrar_produccion, historial_mortalidad, historial_peso, historial_consumo, historial_produccion, graficos_mortalidad, graficos_peso, graficos_consumo, graficos_produccion
- **Widgets (~20):** lote_list_card, lote_form_field, lote_filter_dialog, lotes_search_bar, lotes_empty_state, form_progress_indicator
- **Sub-widgets:** dashboard/ (mortalidad, produccion, peso, consumo tabs), lote_detail/ (detail, components, handlers, sections, utils, kpis_card, info_general_card, estado_card, acciones_rapidas_card, ultimos_registros_card), cerrar_lote/ (cerrar_lote, closure_summary, final_metrics, final_observations, sale_info), lote_form_steps/ (basic_info, detalles, ubicacion, resumen), mortalidad_form_steps/ (evento_info, detalles_descripcion, evidencia_fotografica), peso_form_steps/ (informacion_pesaje, rangos_peso, observaciones_fotos), produccion_form_steps/ (informacion_produccion, clasificacion_huevos, observaciones_fotos), consumo_form_steps/ (informacion_consumo, detalles_costos, observaciones_consumo, resumen_observaciones, selector_alimento_inventario)

### Ventas (~10 archivos de presentación)
- **Pages (4):** ventas_list, venta_detail, registrar_venta, editar_venta
- **Widgets (~6):** venta_list_card, ventas_resumen_card, ventas_empty_state, ventas_error_state, form_progress_indicator
- **Sub-widgets:** ventas_list/ (card, resumen, error_state, empty_state), form_steps (tipo_producto_step, seleccion_granja_lote_venta_step, cliente_step)

### Costos (~8 archivos de presentación)
- **Pages (3):** costos_list, costo_detail, registrar_costo
- **Widgets (~5):** costo_list_card, costos_resumen_card, costos_empty_state, costos_loading_state, form_progress_indicator
- **Sub-widgets:** costos_list/ (list, card, resumen, empty, loading), steps/ (tipo_concepto, monto, detalles)

### Salud (~20 archivos de presentación)
- **Pages (7):** salud_list, salud_detail, vacunacion_list, vacunacion_detail, registrar_tratamiento, programar_vacunacion, inspeccion_bioseguridad, bioseguridad_overview, catalogo_enfermedades
- **Widgets (~15):** enfermedades_search_bar
- **Sub-widgets:** salud_list/ (card, resumen, error, empty), vacunacion_list/ (card, resumen, error, empty), common/ (salud_detail_section, form_step_info, dialog_helpers, salud_form_field, shimmer_loading, swipeable_card), bioseguridad_form_steps/ (granja_galpon, checklist, observaciones_firma), vacunacion_form_steps/ (vacuna_info, aplicacion_observaciones), tratamiento_form_steps/ (seleccion_granja_lote, diagnostico_info, tratamiento_detalles, informacion_adicional)

### Inventario (~10 archivos de presentación)
- **Pages (4):** inventario, item_detalle_inventario, crear_item_inventario, historial_movimientos
- **Widgets (~6):** item_inventario_card, stock_indicator, movimiento_inventario_card, inventario_selector, inventario_dialogs
- **Sub-widgets:** form_steps/ (tipo_item, basic_info, details, stock, imagen_producto_section)

### Home (~8 archivos de presentación)
- **Pages (2):** home_page (pages/), home_page (widgets/home/)
- **Widgets (6):** home_header, home_kpis_grid, home_quick_actions, home_activities, home_alerts, home_inventario_resumen, home_exports

### Perfil (~6 archivos de presentación)
- **Pages (4):** perfil, configuracion, editar_perfil, notificaciones_config
- **Widgets (3):** perfil_header_card, menu_section, sync_settings_section

### Notificaciones (~4 archivos de presentación)
- **Pages (1):** notificaciones
- **Widgets (3):** notificacion_tile, notificaciones_empty, notificaciones_badge

### Reportes (~3 archivos de presentación)
- **Pages (1):** reportes
- **Widgets (2):** reporte_card, reporte_preview_dialog

### Core (~12 archivos compartidos)
- **Navigation (2):** main_shell_page, app_navigation_bar
- **Pages (1):** error_page
- **Widgets (7):** app_states, app_loading, app_image, skeleton_loading, connectivity_banner, permission_guard, sync_status_indicator
- **Presentation Widgets (2):** form_widgets, form_progress_indicator
- **Theme (4+4 nuevos):** app_colors, app_text_styles, app_theme, app_animations + (app_spacing, app_radius, app_shadow, app_icon_size)

---

## Apéndice B: Orden de Ejecución

```
Step 1  ✅ Tokens (AppSpacing, AppRadius, AppShadow, AppIconSize)
Step 2  ✅ Widgets compartidos (AppEmptyState, AppSearchBar, AppFilterTab, AppConfirmDialog)
Step 3  ✅ Home refactor completo (~8 archivos, ~50+ colores hardcoded)
Step 4  ✅ Eliminar Colors.white/grey/Color(0x) en todo el proyecto (~140 archivos, ~900 instancias)
Step 5  ✅ Tipografía: reemplazar 484 TextStyle inline con tokens (~102 archivos)
Step 6  ✅ Unificar componentes: borderRadius (147→AppRadius tokens), BottomSheet theme, FAB (43 props removed), AppBar (15 centerTitle), Scaffold bg, RefreshIndicator
Step 7  ✅ Reemplazar widgets duplicados (7 empty states, 5 search bars, 11 form_progress re-exports, 34 confirm dialogs)
Step 8  ✅ Animaciones: adoptar AppAnimations extensions en cards (14), resumen (3), staggered (4) = 21 archivos
Step 9  ✅ Accesibilidad: Semantics (6 cards + 8 FAB tooltips), HapticFeedback (6 archivos), contraste (4 fixes), touch targets (4 categorías), reducedMotion helpers
Step 10 ✅ Responsividad: app_breakpoints.dart utility, auth maxWidth=480, 11 grids adaptativos, text scaling safe (global clamp 0.8–1.2x)
```

**Validación después de cada step:**
- `dart analyze lib/` → 0 errores, 0 warnings
- `flutter test` → 258 tests pasan
- Verificación visual en dispositivo/emulador
