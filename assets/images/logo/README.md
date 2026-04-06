# 🎨 Logos - Granja Total

## Archivos Requeridos

### Logo Principal
```
logo_principal.png          # Logo completo con texto (512x512 px)
logo_principal_white.png    # Versión en blanco para fondos oscuros
logo_icon.png              # Solo el icono sin texto (256x256 px)
logo_splash.png            # Logo para splash screen (1024x1024 px)
```

### Variantes
```
logo_horizontal.png        # Logo horizontal para headers (400x100 px)
logo_small.png            # Versión pequeña para notificaciones (64x64 px)
favicon.png               # Favicon para web (48x48 px)
```

### Formato de archivos
- **Formato**: PNG con transparencia
- **Fondo**: Transparente
- **Color**: Preferiblemente con versión en color y monocromática

## Ejemplo de Uso

```dart
Image.asset(
  'assets/images/logo/logo_principal.png',
  width: 120,
  height: 120,
)
```

---

**Nota**: Asegúrate de que todos los logos tengan fondo transparente para mejor integración con diferentes temas.
