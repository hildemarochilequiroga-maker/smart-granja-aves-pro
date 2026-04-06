# 🖼️ Fondos y Patrones

## Archivos Sugeridos

### Fondos
```
auth_background.png          # Fondo para login/register
splash_background.png        # Fondo para splash screen
dashboard_pattern.png        # Patrón sutil para dashboard
card_background.png         # Fondo para cards destacadas
gradient_primary.png        # Gradiente en colores primarios
```

### Patrones
```
pattern_dots.png            # Patrón de puntos
pattern_lines.png           # Patrón de líneas
pattern_waves.png           # Patrón de ondas
pattern_mesh.png            # Patrón de malla
```

### Especificaciones
- **Tamaño**: 1080x1920 px (vertical) o 1920x1080 px (horizontal)
- **Formato**: JPG para fondos completos, PNG para patrones
- **Opacidad**: Reducida (20-40%) para no distraer del contenido
- **Colores**: Tonos suaves, no saturados

## Recomendaciones

- Usar gradientes sutiles en lugar de colores sólidos
- Los patrones deben ser repetibles (seamless)
- Fondos de baja saturación para mejor legibilidad
- Versión clara y oscura para modo light/dark

## Ejemplo de Uso

```dart
Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/backgrounds/auth_background.png'),
      fit: BoxFit.cover,
      opacity: 0.3,
    ),
  ),
)
```
