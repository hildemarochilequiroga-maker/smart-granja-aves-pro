# 🎯 Iconos Personalizados

## Archivos Sugeridos

### Categorías de Negocio
```
icon_chicken.png            # Icono de pollo/ave
icon_egg.png               # Icono de huevo
icon_farm.png              # Icono de granja
icon_house.png             # Icono de casa/galpón
icon_feed.png              # Icono de alimento
icon_medicine.png          # Icono de medicina
icon_vaccine.png           # Icono de vacuna
```

### Funcionalidades
```
icon_inventory.png         # Icono de inventario
icon_costs.png            # Icono de costos
icon_sales.png            # Icono de ventas
icon_reports.png          # Icono de reportes
icon_analytics.png        # Icono de análisis
icon_alerts.png           # Icono de alertas
icon_settings.png         # Icono de configuración
```

### Usuarios y Roles
```
icon_admin.png            # Icono de administrador
icon_supervisor.png       # Icono de supervisor
icon_worker.png           # Icono de operario
icon_team.png             # Icono de equipo
```

### Estados
```
icon_success.png          # Check/éxito
icon_error.png            # Error/advertencia
icon_info.png             # Información
icon_warning.png          # Precaución
```

### Especificaciones
- **Tamaño**: 128x128 px (PNG) o vectorial (SVG)
- **Formato**: PNG con transparencia o SVG
- **Estilo**: Flat, line art o filled según diseño
- **Colores**: Versión monocromática + versión con color

## Resoluciones Múltiples

Crear en 3 tamaños para diferentes densidades:
```
icon_name.png          # 1x (128x128)
icon_name@2x.png       # 2x (256x256)
icon_name@3x.png       # 3x (384x384)
```

## Ejemplo de Uso

```dart
Image.asset(
  'assets/images/icons/icon_chicken.png',
  width: 48,
  height: 48,
  color: Theme.of(context).primaryColor,
)
```

---

**Nota**: Para iconos simples, considera usar `Icons` de Material Design. Usa assets solo para iconos personalizados únicos de tu negocio.
