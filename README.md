# 🐔 Smart Granja Aves Pro

Aplicación Flutter para la gestión integral de granjas avícolas con soporte multi-usuario, control de inventario, salud animal y análisis de producción.

---

## ✨ Características Principales

- **Multi-Usuario por Granja**: 5 roles (Owner, Admin, Manager, Operator, Viewer) con permisos diferenciados
- **Gestión de Lotes**: Control de población, mortalidad, peso y conversión alimenticia
- **Inventario Inteligente**: Alertas de stock bajo, control de vencimientos, trazabilidad
- **Salud Animal**: Programas de vacunación, registros de bioseguridad, necropsias
- **Notificaciones**: 77 tipos de alertas en 12 categorías con FCM
- **Reportes y Análisis**: Dashboard con KPIs, gráficos y exportación PDF

---

## 🛠️ Stack Tecnológico

| Categoría | Tecnología |
|-----------|------------|
| **Framework** | Flutter 3.9+ / Dart |
| **State Management** | Riverpod 2.6 |
| **Backend** | Firebase (Auth, Firestore, Storage, FCM) |
| **Navegación** | GoRouter |
| **Local Storage** | SQLite + SharedPreferences |

---

## 📁 Estructura del Proyecto

```
lib/
├── app/                    # Configuración de la app
├── core/                   # Utilidades, temas, widgets comunes
│   ├── routes/             # GoRouter configuration
│   ├── theme/              # Colores, tipografía
│   └── widgets/            # Widgets reutilizables
└── features/               # Módulos por funcionalidad
    ├── auth/               # Autenticación
    ├── granjas/            # Gestión de granjas y colaboradores
    ├── lotes/              # Control de lotes
    ├── inventario/         # Inventario y movimientos
    ├── salud/              # Salud animal
    ├── produccion/         # Registros de producción
    ├── home/               # Dashboard principal
    └── notificaciones/     # Sistema de notificaciones
```

---

## 🚀 Comenzar

```bash
# Clonar repositorio
git clone <repo-url>
cd smartGranjaAves_pro

# Instalar dependencias
flutter pub get

# Configurar Firebase
flutterfire configure

# Ejecutar
flutter run
```

---

## 📚 Documentación

Consulta la [documentación completa](docs/README.md) para guías detalladas:

- [Sistema Multi-Usuarios](docs/multi-usuarios/02-resumen-ejecutivo.md)
- [Sistema de Notificaciones](docs/features/sistema-notificaciones.md)

---

## 📄 Licencia

Proyecto privado - Todos los derechos reservados.
