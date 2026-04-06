# 🎬 Animaciones Lottie

## Archivos Sugeridos

### Animaciones de Carga
```
loading.json              # Spinner de carga general
loading_chicken.json      # Animación temática de pollo
loading_dots.json        # Puntos animados
loading_progress.json    # Barra de progreso animada
```

### Animaciones de Estados
```
success.json             # Checkmark animado
error.json               # X o advertencia animada
empty_box.json           # Caja vacía para estados vacíos
no_data.json             # Sin datos disponibles
searching.json           # Lupa buscando
```

### Animaciones de Acciones
```
confetti.json            # Celebración
upload.json              # Subiendo archivos
download.json            # Descargando
sync.json                # Sincronizando
notification.json        # Campana de notificación
```

### Animaciones Temáticas
```
chicken_walking.json     # Pollo caminando
egg_hatching.json        # Huevo rompiéndose
farm_scene.json          # Escena de granja animada
growth_chart.json        # Gráfico de crecimiento
money_flow.json          # Flujo de dinero
```

## Especificaciones

- **Formato**: JSON (Lottie)
- **Tamaño**: < 100 KB por archivo
- **FPS**: 30-60 fps
- **Duración**: 1-3 segundos (loops)

## Recursos para Descargar

1. **LottieFiles**: https://lottiefiles.com
2. **IconScout**: https://iconscout.com/lottie-animations
3. **Lordicon**: https://lordicon.com

## Instalación

```yaml
dependencies:
  lottie: ^3.0.0
```

## Uso en Flutter

```dart
import 'package:lottie/lottie.dart';

Lottie.asset(
  'assets/animations/loading_chicken.json',
  width: 200,
  height: 200,
  repeat: true,
)
```

## Tipos de Animaciones por Pantalla

### Splash Screen
- `loading_chicken.json` - Mientras carga la app

### Login/Register
- `success.json` - Login exitoso
- `error.json` - Error de credenciales

### Dashboard
- `sync.json` - Sincronizando datos
- `notification.json` - Nueva alerta

### Estados Vacíos
- `empty_box.json` - No hay inventario
- `no_data.json` - No hay reportes

### Confirmaciones
- `confetti.json` - Registro exitoso
- `success.json` - Acción completada

---

**Tip**: Las animaciones Lottie son más eficientes que GIFs y se ven mejor en cualquier resolución.
