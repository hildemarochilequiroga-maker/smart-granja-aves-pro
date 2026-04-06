# 📌 Resumen Ejecutivo: Sistema Multi-Usuarios por Granja

## 🎯 Objetivo Principal
Permitir que múltiples usuarios colaboren en la administración de una misma granja con roles y permisos diferenciados.

---

## 🏛️ Arquitectura en 1 Página

### Antes (Actual)
```
Usuario 1 ──► Granja A
Usuario 2 ──► Granja B
Usuario 3 ──► Granja C

❌ Un usuario = una granja
❌ No hay colaboradores
```

### Después (Propuesto)
```
Usuario 1 (OWNER)    ──┐
                       ├──► Granja A (con roles)
Usuario 2 (ADMIN)    ──┤
                       ├──► Colaboradores activos
Usuario 3 (MANAGER)  ──┘

✅ Múltiples usuarios por granja
✅ Roles diferenciados
✅ Invitaciones con código
```

---

## 🔐 Roles y Permisos (Tabla Rápida)

| Permiso | OWNER | ADMIN | MANAGER | OPERATOR | VIEWER |
|---------|:-----:|:-----:|:-------:|:--------:|:------:|
| Invitar usuarios | ✅ | ✅ | ❌ | ❌ | ❌ |
| Cambiar roles | ✅ | ✅ | ❌ | ❌ | ❌ |
| Editar granja | ✅ | ✅ | ❌ | ❌ | ❌ |
| Crear registros | ✅ | ✅ | ✅ | ✅ | ❌ |
| Editar registros | ✅ | ✅ | ✅ | ❌ | ❌ |
| Ver datos | ✅ | ✅ | ✅ | ✅ | ✅ |
| Eliminar granja | ✅ | ❌ | ❌ | ❌ | ❌ |

---

## 💾 Cambios en Base de Datos

### Nuevas Colecciones en Firestore

#### 1. `granja_usuarios` (Join Table)
```json
{
  "id": "granja123_user456",
  "granjaId": "granja123",
  "usuarioId": "user456",
  "rol": "ADMIN",
  "fechaAsignacion": timestamp,
  "fechaExpiracion": null,
  "activo": true,
  "notas": "Asignado como administrador"
}
```

#### 2. `invitaciones_granja` (Temporal)
```json
{
  "id": "inv789",
  "codigo": "FARM-ABC123-XYZ789",
  "granjaId": "granja123",
  "granjaNombre": "Granja Principal",
  "creadoPorId": "user1",
  "creadoPorNombre": "Juan Pérez",
  "rol": "MANAGER",
  "fechaCreacion": timestamp,
  "fechaExpiracion": timestamp,
  "emailDestino": "nuevo@example.com",
  "usado": false,
  "usadoPorId": null,
  "usadoEn": null
}
```

### Cambios en Colección `granjas`
```diff
  granjas/{granjaId}
  {
-   "propietarioId": "user123",
-   "propietarioNombre": "Juan",
+   "propietarioOriginalId": "user123",
+   "usuariosAccesoIds": ["user123", "user456", "user789"],
    "nombre": "Granja Principal",
    "estado": "ACTIVA",
    ...
  }
```

---

## 🔄 Flujos Principales

### 1️⃣ Invitar Usuario (OWNER/ADMIN)

```
┌────────────────┐
│ Admin presiona │
│ "Invitar"      │
└────────┬───────┘
         │
         ▼
    ┌─────────────────────────────┐
    │ Dialog: Selecciona Rol      │
    │ - ADMIN                     │
    │ - MANAGER                   │
    │ - OPERATOR                  │
    │ - VIEWER                    │
    │ Email (opcional): xxx@xx.com│
    └────────┬────────────────────┘
             │
             ▼
    ┌─────────────────────────────┐
    │ Genera código único:        │
    │ FARM-ABC123-XYZ789          │
    │ (válido 30 días)            │
    └────────┬────────────────────┘
             │
             ├─► [Enviar Email] (opcional)
             │
             └─► [Mostrar QR + Código]
                 ↓ Usuario copia/escanea
```

### 2️⃣ Aceptar Invitación (Usuario Nuevo)

```
┌──────────────────────┐
│ Usuario nuevo ingresa│
│ código o escanea QR  │
└──────────┬───────────┘
           │
           ▼
    ┌─────────────────────────────┐
    │ Sistema valida:             │
    │ ✓ Código existe             │
    │ ✓ No ha sido usado          │
    │ ✓ No está expirado          │
    └────────┬────────────────────┘
             │
      ┌──────┴──────┐
      │             │
      ▼ VÁLIDO      ▼ INVÁLIDO
    [OK]         [Error]
      │             │
      ▼             ▼
   ┌──────────────────────────┐
   │ Crear relación en Firestore:
   │ granja_usuarios/{id}     │
   │ - granjaId               │
   │ - usuarioId (current)    │
   │ - rol (del código)       │
   │ - fechaAsignacion: now   │
   │ - activo: true           │
   └────────┬─────────────────┘
            │
            ▼
    ┌──────────────────────┐
    │ ¡Acceso Otorgado!    │
    │ Ahora puedes acceder │
    │ a la granja          │
    └──────────────────────┘
```

### 3️⃣ Listar Colaboradores (OWNER/ADMIN)

```
GET /granjas/{granjaId}/colaboradores
     │
     ▼
Buscar en granja_usuarios
donde granjaId = X
y activo = true
     │
     ▼
Enriquecer con datos de usuarios
(email, nombre, foto)
     │
     ▼
JSON [
  { usuarioId, rol, email, nombre, foto, estado },
  ...
]
```

---

## 📊 Modelos Dart (Resumen)

### Enum: RolGranja
```dart
enum RolGranja {
  owner,      // Propietario - Todo
  admin,      // Admin - Todo excepto borrar
  manager,    // Gestor - Registros
  operator,   // Operario - Solo crear
  viewer;     // Visualizador - Solo leer
}
```

### Class: GranjaUsuario
```dart
class GranjaUsuario {
  String id;
  String granjaId;
  String usuarioId;
  RolGranja rol;
  DateTime fechaAsignacion;
  DateTime? fechaExpiracion;
  bool activo;
  String? notas;
}
```

### Class: InvitacionGranja
```dart
class InvitacionGranja {
  String id;
  String codigo;        // "FARM-ABC123-XYZ789"
  String granjaId;
  String granjaNombre;
  String creadoPorId;
  String creadoPorNombre;
  RolGranja rol;
  DateTime fechaCreacion;
  DateTime fechaExpiracion; // +30 días
  String? emailDestino;
  bool usado;
  String? usadoPorId;
  DateTime? usadoEn;
  
  bool get esValida => !usado && 
                        fechaExpiracion.isAfter(DateTime.now());
}
```

---

## 🗂️ Estructura de Carpetas

```
lib/features/granjas/
├── domain/
│   ├── entities/
│   │   ├── granja_usuario.dart (NEW)
│   │   ├── invitacion_granja.dart (NEW)
│   │   └── granja.dart (MODIFICADO)
│   ├── enums/
│   │   └── rol_granja_enum.dart (NEW)
│   ├── repositories/
│   │   ├── granja_usuarios_repository.dart (NEW)
│   │   └── invitaciones_granja_repository.dart (NEW)
│   └── usecases/
│       ├── invitar_usuario_a_granja_usecase.dart (NEW)
│       ├── aceptar_invitacion_granja_usecase.dart (NEW)
│       ├── listar_colaboradores_granja_usecase.dart (NEW)
│       └── ... (5 más)
│
├── infrastructure/
│   ├── datasources/
│   │   ├── granja_usuarios_firebase_datasource.dart (NEW)
│   │   └── invitaciones_granja_firebase_datasource.dart (NEW)
│   ├── models/
│   │   ├── granja_usuario_model.dart (NEW)
│   │   └── invitacion_granja_model.dart (NEW)
│   └── repositories/
│       ├── granja_usuarios_repository_impl.dart (NEW)
│       └── invitaciones_granja_repository_impl.dart (NEW)
│
├── application/
│   ├── providers/
│   │   ├── granja_usuarios_providers.dart (NEW)
│   │   └── invitaciones_granja_providers.dart (NEW)
│   └── state/
│       └── granja_state.dart (MODIFICADO)
│
└── presentation/
    ├── pages/
    │   ├── gestionar_colaboradores_page.dart (NEW)
    │   ├── invitar_usuario_page.dart (NEW)
    │   └── aceptar_invitacion_page.dart (NEW)
    └── widgets/
        ├── colaboradores_list.dart (NEW)
        ├── invitar_usuario_dialog.dart (NEW)
        └── ... (más widgets)
```

---

## 📋 Plan de Desarrollo (Timeline)

| Fase | Tarea | Duración | Estado |
|------|-------|----------|--------|
| **1** | Crear entidades y enums | 2 h | ⏳ |
| **2** | Modelos Firestore | 1 h | ⏳ |
| **3** | Datasources y Repositories | 3 h | ⏳ |
| **4** | Use Cases | 2 h | ⏳ |
| **5** | Providers Riverpod | 2 h | ⏳ |
| **6** | UI - Invitar | 2 h | ⏳ |
| **7** | UI - Aceptar | 1.5 h | ⏳ |
| **8** | UI - Listar Colaboradores | 1.5 h | ⏳ |
| **9** | Integración en Home | 1 h | ⏳ |
| **10** | Security Rules Firestore | 1 h | ⏳ |
| **11** | Tests | 2 h | ⏳ |
| **TOTAL** | | **19 h** | |

---

## 🔐 Security Rules (Firestore)

```javascript
// Versión SIMPLIFICADA
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Solo leer si tienes acceso a la granja
    match /granjas/{granjaId} {
      allow read: if userHasAccessToGranja(granjaId);
      allow write: if userIsAdminInGranja(granjaId);
    }

    // Relaciones usuario-granja
    match /granja_usuarios/{doc=**} {
      allow read: if userHasAccessToGranja(doc.data.granjaId);
      allow create: if userCanInviteInGranja(doc.data.granjaId);
      allow update: if userCanChangeRolesInGranja(doc.data.granjaId);
      allow delete: if userCanRemoveUsersInGranja(doc.data.granjaId);
    }

    // Invitaciones
    match /invitaciones_granja/{invId} {
      allow read: if userHasAccessToGranja(resource.data.granjaId) ||
                     resource.data.emailDestino == request.auth.token.email;
      allow create: if userCanInviteInGranja(request.resource.data.granjaId);
      allow delete: if userCanInviteInGranja(resource.data.granjaId);
    }
  }
}
```

---

## 🚀 Próximos Pasos

### 1. **Revisión**
   - [ ] ¿Te gusta el plan?
   - [ ] ¿Agregar más roles?
   - [ ] ¿Cambiar duración de invitación?

### 2. **Confirmación**
   - [ ] ¿Proceder con implementación?
   - [ ] ¿Prioridad?

### 3. **Preguntas**
   1. ¿Envío de emails con invitaciones?
   2. ¿Máximo de usuarios por granja?
   3. ¿Auditoría completa de cambios?
   4. ¿Notificaciones en tiempo real?

---

**Archivo Completo**: Ver `PLAN_MULTIPLES_USUARIOS_GRANJA.md`

