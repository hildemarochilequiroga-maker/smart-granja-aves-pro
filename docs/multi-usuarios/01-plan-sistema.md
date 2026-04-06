# Plan Completo: Sistema de Múltiples Usuarios por Granja

**Fecha**: 26 de Diciembre 2025
**Objetivo**: Permitir que múltiples usuarios administren una misma granja con diferentes roles y permisos

---

## 📋 Tabla de Contenidos
1. [Análisis Actual](#análisis-actual)
2. [Arquitectura Propuesta](#arquitectura-propuesta)
3. [Modelos de Datos](#modelos-de-datos)
4. [Funcionalidades](#funcionalidades)
5. [Plan de Implementación](#plan-de-implementación)
6. [Código Ejemplo](#código-ejemplo)

---

## 🔍 Análisis Actual

### Estado Actual del Proyecto
- **Framework**: Flutter + Riverpod
- **Backend**: Firebase (Auth + Firestore)
- **Autenticación**: Soporta Email, Google, Apple
- **Granjas**: Cada granja tiene un `propietarioId` único (relación 1 propietario : N granjas)
- **Modelo Actual**: Un usuario = dueño de sus granjas

### Limitación Actual
- No hay soporte para colaboradores en una granja
- Solo el dueño (`propietarioId`) puede acceder a la granja
- No hay sistema de invitaciones o códigos de acceso
- No hay roles/permisos granulares

---

## 🏗️ Arquitectura Propuesta

### Estructura de Relaciones

```
Usuario (owner/admin/manager/operator)
  ├── Mi Perfil (email, nombre, teléfono, foto)
  └── Granjas Accesibles
      ├── Granja 1 (rol: ADMIN)
      │   ├── Galpones
      │   ├── Lotes
      │   ├── Registros
      │   └── Colaboradores (lista de usuarios)
      │
      ├── Granja 2 (rol: MANAGER)
      │   └── [acceso limitado]
      │
      └── Granja 3 (rol: OPERATOR)
          └── [solo lectura/registros]

Invitación (código temporal)
  ├── Código: "ABC123XYZ"
  ├── Granja: "granja_123"
  ├── Rol: "MANAGER"
  ├── CreadoPor: usuario_admin
  ├── FechaExpiracion: 2025-01-15
  └── Usado: false
```

### Roles y Permisos

| Rol | Descripción | Permisos |
|-----|-------------|----------|
| **OWNER** | Propietario original de la granja | ✅ Todo (crear, editar, eliminar, invitar) |
| **ADMIN** | Administrador de la granja | ✅ Todo excepto eliminar granja |
| **MANAGER** | Gestor operativo | ✅ Ver, editar registros, no gestionar usuarios |
| **OPERATOR** | Operario de campo | ✅ Solo crear registros (producción, peso, etc) |
| **VIEWER** | Visualizador | ✅ Solo lectura |

---

## 📊 Modelos de Datos

### 1. Nueva Entidad: GranjaUsuario (Pivot/Join Table)

```dart
class GranjaUsuario extends Equatable {
  const GranjaUsuario({
    required this.id,
    required this.granjaId,
    required this.usuarioId,
    required this.rol,
    required this.fechaAsignacion,
    this.fechaExpiracion,
    this.activo = true,
    this.notas,
  });

  /// ID único de la relación
  final String id;

  /// ID de la granja
  final String granjaId;

  /// ID del usuario
  final String usuarioId;

  /// Rol del usuario en la granja (OWNER, ADMIN, MANAGER, etc)
  final RolGranja rol;

  /// Fecha en que se asignó el usuario a la granja
  final DateTime fechaAsignacion;

  /// Fecha de expiración de acceso (opcional)
  final DateTime? fechaExpiracion;

  /// Indica si el usuario aún tiene acceso activo
  final bool activo;

  /// Notas sobre la asignación
  final String? notas;

  @override
  List<Object?> get props => [
    id,
    granjaId,
    usuarioId,
    rol,
    fechaAsignacion,
    fechaExpiracion,
    activo,
    notas,
  ];
}

enum RolGranja {
  owner,    // Propietario
  admin,    // Administrador
  manager,  // Gestor
  operator, // Operario
  viewer;   // Visualizador

  String get displayName {
    switch (this) {
      case RolGranja.owner:
        return 'Propietario';
      case RolGranja.admin:
        return 'Administrador';
      case RolGranja.manager:
        return 'Gestor';
      case RolGranja.operator:
        return 'Operario';
      case RolGranja.viewer:
        return 'Visualizador';
    }
  }

  bool canManageUsers() => this == RolGranja.owner || this == RolGranja.admin;
  bool canEditGranja() => this == RolGranja.owner || this == RolGranja.admin;
  bool canDeleteGranja() => this == RolGranja.owner;
  bool canCreateRecords() => 
    this == RolGranja.owner || 
    this == RolGranja.admin || 
    this == RolGranja.manager ||
    this == RolGranja.operator;
}
```

### 2. Nueva Entidad: InvitacionGranja

```dart
class InvitacionGranja extends Equatable {
  const InvitacionGranja({
    required this.id,
    required this.codigo,
    required this.granjaId,
    required this.granjaNombre,
    required this.creadoPorId,
    required this.creadoPorNombre,
    required this.rol,
    required this.fechaCreacion,
    required this.fechaExpiracion,
    this.emailDestino,
    this.usado = false,
    this.usadoPorId,
    this.usadoEn,
  });

  /// ID único de la invitación
  final String id;

  /// Código único para invitación (ej: "FARM-ABC123-XYZ789")
  final String codigo;

  /// ID de la granja
  final String granjaId;

  /// Nombre de la granja (para referencia)
  final String granjaNombre;

  /// ID del usuario que creó la invitación
  final String creadoPorId;

  /// Nombre del usuario que creó la invitación
  final String creadoPorNombre;

  /// Rol que se asignará al usuario que use la invitación
  final RolGranja rol;

  /// Fecha de creación
  final DateTime fechaCreacion;

  /// Fecha de expiración (máximo 30 días)
  final DateTime fechaExpiracion;

  /// Email al que se invita (opcional, para envío de email)
  final String? emailDestino;

  /// Si ya fue utilizado
  final bool usado;

  /// ID del usuario que usó la invitación
  final String? usadoPorId;

  /// Fecha en que se usó
  final DateTime? usadoEn;

  bool get esValida => 
    !usado && 
    fechaExpiracion.isAfter(DateTime.now());

  @override
  List<Object?> get props => [
    id,
    codigo,
    granjaId,
    rol,
    fechaCreacion,
    fechaExpiracion,
    usado,
  ];
}
```

### 3. Cambio en Granja (Modificación)

```dart
// En class Granja, AGREGAR:

// REMOVER o DEPRECAR:
// final String propietarioId;
// final String propietarioNombre;

// AGREGAR:
/// Lista de IDs de usuarios que tienen acceso (relación con GranjaUsuario)
final List<String> usuariosAccesoIds; // [usuario1, usuario2, usuario3]

/// ID del usuario propietario original (para referencia)
final String propietarioOriginalId;
```

### 4. Estructura Firestore

```
firestore/
├── usuarios/
│   └── {userId}/
│       ├── id: "user123"
│       ├── email: "admin@example.com"
│       ├── nombre: "Juan"
│       ├── apellido: "Pérez"
│       ├── fotoUrl: "..."
│       └── (campos existentes)
│
├── granjas/
│   └── {granjaId}/
│       ├── id: "granja123"
│       ├── nombre: "Granja Principal"
│       ├── propietarioOriginalId: "user1"
│       ├── usuariosAccesoIds: ["user1", "user2", "user3"]
│       ├── estado: "ACTIVA"
│       └── (campos existentes)
│
├── granja_usuarios/  ← NUEVA COLECCIÓN
│   └── {granjaId}_{userId}/
│       ├── id: "rel123"
│       ├── granjaId: "granja123"
│       ├── usuarioId: "user2"
│       ├── rol: "ADMIN"
│       ├── fechaAsignacion: timestamp
│       ├── activo: true
│       └── notas: "Asignado como admin"
│
└── invitaciones_granja/  ← NUEVA COLECCIÓN
    └── {invitacionId}/
        ├── id: "inv123"
        ├── codigo: "FARM-ABC123-XYZ789"
        ├── granjaId: "granja123"
        ├── granjaNombre: "Granja Principal"
        ├── creadoPorId: "user1"
        ├── creadoPorNombre: "Juan"
        ├── rol: "MANAGER"
        ├── fechaCreacion: timestamp
        ├── fechaExpiracion: timestamp
        ├── emailDestino: "nuevo@example.com"
        ├── usado: false
        └── usadoEn: null
```

---

## ✨ Funcionalidades

### 1. Invitar Usuarios a Granja
- **Actores**: OWNER, ADMIN
- **Entradas**: 
  - Email del usuario (opcional)
  - Rol deseado
  - Notas internas
- **Proceso**:
  1. Generar código único de 12 caracteres
  2. Crear documento en `invitaciones_granja`
  3. Enviar email con código (si se proporciona email)
  4. Mostrar código QR/texto para compartir
- **Salida**: InvitacionGranja creada

### 2. Aceptar Invitación (Usuarios Nuevos)
- **Actores**: Cualquier usuario autenticado
- **Entradas**: Código de invitación
- **Proceso**:
  1. Validar que código exista y sea válido
  2. Validar que no haya sido usado
  3. Validar fecha de expiración
  4. Crear GranjaUsuario
  5. Actualizar usuariosAccesoIds en Granja
  6. Marcar invitación como usada
- **Salida**: Usuario ahora tiene acceso a la granja

### 3. Listar Colaboradores
- **Actores**: OWNER, ADMIN
- **Entradas**: granjaId
- **Proceso**:
  1. Obtener todos los GranjaUsuario donde granjaId = X y activo = true
  2. Enrichir con datos del Usuario (email, nombre, foto)
  3. Mostrar rol, fecha de asignación, estado
- **Salida**: Lista de colaboradores

### 4. Cambiar Rol de Colaborador
- **Actores**: OWNER, ADMIN (no pueden cambiar rol de OWNER)
- **Entradas**: granjaId, usuarioId, nuevoRol
- **Proceso**:
  1. Obtener GranjaUsuario
  2. Validar permisos del usuario actual
  3. Actualizar rol
  4. Registrar auditoría
- **Salida**: GranjaUsuario actualizado

### 5. Remover Colaborador
- **Actores**: OWNER, ADMIN (no pueden remover OWNER)
- **Entradas**: granjaId, usuarioId
- **Proceso**:
  1. Marcar GranjaUsuario como inactivo (soft delete)
  2. Remover de usuariosAccesoIds
  3. Registrar auditoría
- **Salida**: Acceso revocado

### 6. Listar Granjas del Usuario
- **Actores**: Cualquier usuario
- **Entradas**: usuarioId
- **Proceso**:
  1. Obtener todos los GranjaUsuario donde usuarioId = X y activo = true
  2. Obtener datos de cada Granja
  3. Incluir rol del usuario en cada granja
- **Salida**: Lista de granjas accesibles con rol

### 7. Auditoría de Acceso (Bonus)
- Registrar quién cambió qué, cuándo y por qué
- Útil para compliance y debugging

---

## 🚀 Plan de Implementación

### Fase 1: Modelos y Entities (2-3 horas)

**Archivos a crear:**
```
lib/features/granjas/domain/entities/
├── granja_usuario.dart (nueva)
├── invitacion_granja.dart (nueva)
└── rol_granja.dart (nueva)

lib/features/granjas/domain/enums/
└── rol_granja_enum.dart (nueva)

lib/features/granjas/infrastructure/models/
├── granja_usuario_model.dart (nueva)
└── invitacion_granja_model.dart (nueva)
```

### Fase 2: Datasources y Repositories (3-4 horas)

**Archivos a crear:**
```
lib/features/granjas/infrastructure/datasources/
├── granja_usuarios_firebase_datasource.dart (nueva)
└── invitaciones_granja_firebase_datasource.dart (nueva)

lib/features/granjas/domain/repositories/
├── granja_usuarios_repository.dart (nueva)
└── invitaciones_granja_repository.dart (nueva)

lib/features/granjas/infrastructure/repositories/
├── granja_usuarios_repository_impl.dart (nueva)
└── invitaciones_granja_repository_impl.dart (nueva)
```

### Fase 3: Use Cases (2-3 horas)

**Archivos a crear:**
```
lib/features/granjas/domain/usecases/
├── invitar_usuario_a_granja_usecase.dart (nueva)
├── aceptar_invitacion_granja_usecase.dart (nueva)
├── listar_colaboradores_granja_usecase.dart (nueva)
├── cambiar_rol_colaborador_usecase.dart (nueva)
├── remover_colaborador_granja_usecase.dart (nueva)
└── listar_granjas_usuario_usecase.dart (nueva)
```

### Fase 4: State Management (Riverpod) (2-3 horas)

**Archivos a actualizar/crear:**
```
lib/features/granjas/application/providers/
├── granja_usuarios_providers.dart (nueva)
├── invitaciones_granja_providers.dart (nueva)
├── granja_notifiers.dart (actualizar)
└── granja_providers.dart (actualizar)
```

### Fase 5: UI - Gestión de Colaboradores (4-5 horas)

**Archivos a crear:**
```
lib/features/granjas/presentation/pages/
├── gestionar_colaboradores_page.dart (nueva)
└── invitar_usuario_page.dart (nueva)

lib/features/granjas/presentation/widgets/
├── colaboradores_list.dart (nueva)
├── invitar_usuario_dialog.dart (nueva)
├── aceptar_invitacion_page.dart (nueva)
└── mostrar_codigo_invitacion_dialog.dart (nueva)
```

### Fase 6: Integración en Home (2 horas)

- Actualizar selector de granja en home
- Mostrar rol actual del usuario
- Ajustes de permisos en acciones según rol

### Fase 7: Testing y Validación (2-3 horas)

- Unit tests para use cases
- Widget tests para UI
- Pruebas de integración E2E

**Tiempo Total Estimado**: 16-22 horas

---

## 💻 Código Ejemplo

### 1. Entidades Principales

**granja_usuario.dart:**
```dart
library;

import 'package:equatable/equatable.dart';

import '../enums/rol_granja_enum.dart';

/// Entidad que representa la relación usuario-granja
/// 
/// Representa que un usuario tiene un rol específico en una granja
/// (relación many-to-many entre usuarios y granjas)
class GranjaUsuario extends Equatable {
  const GranjaUsuario({
    required this.id,
    required this.granjaId,
    required this.usuarioId,
    required this.rol,
    required this.fechaAsignacion,
    this.fechaExpiracion,
    this.activo = true,
    this.notas,
  });

  /// ID único de la relación
  final String id;

  /// ID de la granja
  final String granjaId;

  /// ID del usuario
  final String usuarioId;

  /// Rol del usuario en la granja
  final RolGranja rol;

  /// Fecha en que se asignó el usuario
  final DateTime fechaAsignacion;

  /// Fecha de expiración de acceso (opcional)
  final DateTime? fechaExpiracion;

  /// Indica si el acceso está activo
  final bool activo;

  /// Notas adicionales
  final String? notas;

  /// Verifica si el acceso está expirado
  bool get espirado => fechaExpiracion != null && 
    fechaExpiracion!.isBefore(DateTime.now());

  /// Verifica si el acceso es válido (activo y no expirado)
  bool get esValido => activo && !espirado;

  /// Crea una copia con campos opcionalmente reemplazados
  GranjaUsuario copyWith({
    String? id,
    String? granjaId,
    String? usuarioId,
    RolGranja? rol,
    DateTime? fechaAsignacion,
    DateTime? fechaExpiracion,
    bool? activo,
    String? notas,
  }) {
    return GranjaUsuario(
      id: id ?? this.id,
      granjaId: granjaId ?? this.granjaId,
      usuarioId: usuarioId ?? this.usuarioId,
      rol: rol ?? this.rol,
      fechaAsignacion: fechaAsignacion ?? this.fechaAsignacion,
      fechaExpiracion: fechaExpiracion ?? this.fechaExpiracion,
      activo: activo ?? this.activo,
      notas: notas ?? this.notas,
    );
  }

  @override
  List<Object?> get props => [
    id,
    granjaId,
    usuarioId,
    rol,
    fechaAsignacion,
    fechaExpiracion,
    activo,
  ];
}
```

**invitacion_granja.dart:**
```dart
library;

import 'package:equatable/equatable.dart';

import '../enums/rol_granja_enum.dart';

/// Entidad que representa una invitación a una granja
/// 
/// Los usuarios pueden ser invitados a granjas mediante un código temporal
/// que expira después de 30 días
class InvitacionGranja extends Equatable {
  const InvitacionGranja({
    required this.id,
    required this.codigo,
    required this.granjaId,
    required this.granjaNombre,
    required this.creadoPorId,
    required this.creadoPorNombre,
    required this.rol,
    required this.fechaCreacion,
    required this.fechaExpiracion,
    this.emailDestino,
    this.usado = false,
    this.usadoPorId,
    this.usadoEn,
  });

  /// ID único de la invitación
  final String id;

  /// Código único (ej: "FARM-ABC123-XYZ789")
  /// Formato: FARM-{8 caracteres aleatorios}-{8 caracteres aleatorios}
  final String codigo;

  /// ID de la granja
  final String granjaId;

  /// Nombre de la granja (para referencia)
  final String granjaNombre;

  /// ID del usuario que creó la invitación
  final String creadoPorId;

  /// Nombre completo del usuario que creó la invitación
  final String creadoPorNombre;

  /// Rol que se asignará
  final RolGranja rol;

  /// Fecha de creación
  final DateTime fechaCreacion;

  /// Fecha de expiración (máximo 30 días desde creación)
  final DateTime fechaExpiracion;

  /// Email al que fue invitado (para referencia)
  final String? emailDestino;

  /// Si ya fue utilizado
  final bool usado;

  /// ID del usuario que la utilizó
  final String? usadoPorId;

  /// Fecha en que se utilizó
  final DateTime? usadoEn;

  /// Verifica si la invitación es válida (no usada y no expirada)
  bool get esValida => 
    !usado && 
    fechaExpiracion.isAfter(DateTime.now());

  /// Días restantes para usar la invitación
  int get diasRestantes {
    final diferencia = fechaExpiracion.difference(DateTime.now()).inDays;
    return diferencia.isNegative ? 0 : diferencia;
  }

  /// Crea una copia con campos opcionalmente reemplazados
  InvitacionGranja copyWith({
    String? id,
    String? codigo,
    String? granjaId,
    String? granjaNombre,
    String? creadoPorId,
    String? creadoPorNombre,
    RolGranja? rol,
    DateTime? fechaCreacion,
    DateTime? fechaExpiracion,
    String? emailDestino,
    bool? usado,
    String? usadoPorId,
    DateTime? usadoEn,
  }) {
    return InvitacionGranja(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      granjaId: granjaId ?? this.granjaId,
      granjaNombre: granjaNombre ?? this.granjaNombre,
      creadoPorId: creadoPorId ?? this.creadoPorId,
      creadoPorNombre: creadoPorNombre ?? this.creadoPorNombre,
      rol: rol ?? this.rol,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaExpiracion: fechaExpiracion ?? this.fechaExpiracion,
      emailDestino: emailDestino ?? this.emailDestino,
      usado: usado ?? this.usado,
      usadoPorId: usadoPorId ?? this.usadoPorId,
      usadoEn: usadoEn ?? this.usadoEn,
    );
  }

  @override
  List<Object?> get props => [
    id,
    codigo,
    granjaId,
    rol,
    fechaCreacion,
    fechaExpiracion,
    usado,
  ];
}
```

**rol_granja_enum.dart:**
```dart
library;

/// Enumeración de roles disponibles en una granja
enum RolGranja {
  owner,      // Propietario original
  admin,      // Administrador
  manager,    // Gestor operativo
  operator,   // Operario de campo
  viewer;     // Visualizador

  /// Nombre legible del rol
  String get displayName {
    switch (this) {
      case RolGranja.owner:
        return 'Propietario';
      case RolGranja.admin:
        return 'Administrador';
      case RolGranja.manager:
        return 'Gestor';
      case RolGranja.operator:
        return 'Operario';
      case RolGranja.viewer:
        return 'Visualizador';
    }
  }

  /// Descripción del rol
  String get descripcion {
    switch (this) {
      case RolGranja.owner:
        return 'Control total, puede eliminar la granja';
      case RolGranja.admin:
        return 'Control total excepto eliminar';
      case RolGranja.manager:
        return 'Puede editar registros y lotes';
      case RolGranja.operator:
        return 'Solo puede crear registros';
      case RolGranja.viewer:
        return 'Solo lectura';
    }
  }

  /// Convierte string a enum
  static RolGranja fromString(String value) {
    return RolGranja.values.firstWhere(
      (e) => e.name == value,
      orElse: () => RolGranja.viewer,
    );
  }

  // ==================== PERMISOS ====================

  /// Puede invitar usuarios
  bool get canInviteUsers => 
    this == RolGranja.owner || this == RolGranja.admin;

  /// Puede cambiar roles de otros usuarios
  bool get canChangeRoles => 
    this == RolGranja.owner || this == RolGranja.admin;

  /// Puede remover usuarios
  bool get canRemoveUsers => 
    this == RolGranja.owner || this == RolGranja.admin;

  /// Puede editar datos de la granja
  bool get canEditGranja => 
    this == RolGranja.owner || this == RolGranja.admin;

  /// Puede eliminar la granja
  bool get canDeleteGranja => this == RolGranja.owner;

  /// Puede crear registros (producción, peso, consumo, etc)
  bool get canCreateRecords => 
    this == RolGranja.owner || 
    this == RolGranja.admin || 
    this == RolGranja.manager ||
    this == RolGranja.operator;

  /// Puede editar registros
  bool get canEditRecords => 
    this == RolGranja.owner || 
    this == RolGranja.admin || 
    this == RolGranja.manager;

  /// Puede ver reportes y análisis
  bool get canViewReports => 
    this != RolGranja.viewer; // Todos excepto viewer

  /// Puede exportar datos
  bool get canExportData => 
    this == RolGranja.owner || 
    this == RolGranja.admin || 
    this == RolGranja.manager;
}
```

### 2. Models (para Firestore)

**granja_usuario_model.dart:**
```dart
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/granja_usuario.dart';
import '../../domain/enums/rol_granja_enum.dart';

/// Modelo de datos para la relación usuario-granja
class GranjaUsuarioModel extends GranjaUsuario {
  const GranjaUsuarioModel({
    required super.id,
    required super.granjaId,
    required super.usuarioId,
    required super.rol,
    required super.fechaAsignacion,
    super.fechaExpiracion,
    super.activo = true,
    super.notas,
  });

  /// Crea desde JSON
  factory GranjaUsuarioModel.fromJson(Map<String, dynamic> json) {
    return GranjaUsuarioModel(
      id: json['id'] as String? ?? '',
      granjaId: json['granjaId'] as String? ?? '',
      usuarioId: json['usuarioId'] as String? ?? '',
      rol: RolGranja.fromString(json['rol'] as String? ?? 'viewer'),
      fechaAsignacion: _parseDateTime(json['fechaAsignacion']),
      fechaExpiracion: _parseDateTime(json['fechaExpiracion']),
      activo: json['activo'] as bool? ?? true,
      notas: json['notas'] as String?,
    );
  }

  /// Crea desde Firestore
  factory GranjaUsuarioModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return GranjaUsuarioModel.fromJson({'id': doc.id, ...data});
  }

  /// Crea desde entidad de dominio
  factory GranjaUsuarioModel.fromEntity(GranjaUsuario entity) {
    return GranjaUsuarioModel(
      id: entity.id,
      granjaId: entity.granjaId,
      usuarioId: entity.usuarioId,
      rol: entity.rol,
      fechaAsignacion: entity.fechaAsignacion,
      fechaExpiracion: entity.fechaExpiracion,
      activo: entity.activo,
      notas: entity.notas,
    );
  }

  /// Convierte a JSON para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'granjaId': granjaId,
      'usuarioId': usuarioId,
      'rol': rol.name,
      'fechaAsignacion': Timestamp.fromDate(fechaAsignacion),
      'fechaExpiracion': fechaExpiracion != null 
        ? Timestamp.fromDate(fechaExpiracion!) 
        : null,
      'activo': activo,
      'notas': notas,
    };
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
```

### 3. Repository Interface

**granja_usuarios_repository.dart:**
```dart
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/granja_usuario.dart';
import '../enums/rol_granja_enum.dart';

/// Repositorio para gestionar usuarios de granjas
abstract class GranjaUsuariosRepository {
  /// Obtiene todos los usuarios de una granja
  Future<Either<Failure, List<GranjaUsuario>>> obtenerUsuariosPorGranja({
    required String granjaId,
    bool soloActivos = true,
  });

  /// Obtiene el rol de un usuario en una granja específica
  Future<Either<Failure, RolGranja?>> obtenerRolUsuarioEnGranja({
    required String granjaId,
    required String usuarioId,
  });

  /// Asigna un usuario a una granja con un rol
  Future<Either<Failure, GranjaUsuario>> asignarUsuarioAGranja({
    required String granjaId,
    required String usuarioId,
    required RolGranja rol,
    String? notas,
  });

  /// Cambia el rol de un usuario en una granja
  Future<Either<Failure, GranjaUsuario>> cambiarRolUsuario({
    required String granjaId,
    required String usuarioId,
    required RolGranja nuevoRol,
  });

  /// Remueve un usuario de una granja (soft delete)
  Future<Either<Failure, void>> removerUsuarioDe Granja({
    required String granjaId,
    required String usuarioId,
  });

  /// Obtiene todas las granjas donde un usuario tiene acceso
  Future<Either<Failure, List<String>>> obtenerGranjasPorUsuario({
    required String usuarioId,
    bool soloActivas = true,
  });
}
```

### 4. Use Case: Invitar Usuario

**invitar_usuario_a_granja_usecase.dart:**
```dart
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/invitacion_granja.dart';
import '../enums/rol_granja_enum.dart';
import '../repositories/invitaciones_granja_repository.dart';

/// Caso de uso para invitar un usuario a una granja
/// 
/// Genera un código único de invitación que el usuario puede usar
/// para acceder a la granja con un rol específico
class InvitarUsuarioAGranjaUseCase
    implements UseCase<InvitacionGranja, InvitarUsuarioAGranjaParams> {
  const InvitarUsuarioAGranjaUseCase(this._repository);

  final InvitacionesGranjaRepository _repository;

  @override
  Future<Either<Failure, InvitacionGranja>> call(
    InvitarUsuarioAGranjaParams params,
  ) {
    return _repository.crearInvitacion(
      granjaId: params.granjaId,
      rol: params.rol,
      creadoPorId: params.creadoPorId,
      creadoPorNombre: params.creadoPorNombre,
      emailDestino: params.emailDestino,
      granjaNombre: params.granjaNombre,
    );
  }
}

class InvitarUsuarioAGranjaParams {
  const InvitarUsuarioAGranjaParams({
    required this.granjaId,
    required this.granjaNombre,
    required this.rol,
    required this.creadoPorId,
    required this.creadoPorNombre,
    this.emailDestino,
  });

  final String granjaId;
  final String granjaNombre;
  final RolGranja rol;
  final String creadoPorId;
  final String creadoPorNombre;
  final String? emailDestino;
}
```

### 5. Providers (Riverpod)

**granja_usuarios_providers.dart:**
```dart
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/providers/auth_provider.dart';
import '../../domain/entities/granja_usuario.dart';
import '../../domain/enums/rol_granja_enum.dart';
import '../../domain/repositories/granja_usuarios_repository.dart';
import '../../infrastructure/datasources/granja_usuarios_firebase_datasource.dart';
import '../../infrastructure/repositories/granja_usuarios_repository_impl.dart';

// =============================================================================
// DATASOURCES
// =============================================================================

final granjaUsuariosFirebaseDatasourceProvider = 
    Provider<GranjaUsuariosFirebaseDatasource>((ref) {
  return GranjaUsuariosFirebaseDatasource();
});

// =============================================================================
// REPOSITORIES
// =============================================================================

final granjaUsuariosRepositoryProvider = 
    Provider<GranjaUsuariosRepository>((ref) {
  return GranjaUsuariosRepositoryImpl(
    datasource: ref.watch(granjaUsuariosFirebaseDatasourceProvider),
  );
});

// =============================================================================
// OBTENER USUARIOS DE UNA GRANJA
// =============================================================================

final usuariosGranjaProvider = FutureProvider.family<
  List<GranjaUsuario>,
  String
>((ref, granjaId) async {
  final repository = ref.watch(granjaUsuariosRepositoryProvider);
  final result = await repository.obtenerUsuariosPorGranja(
    granjaId: granjaId,
    soloActivos: true,
  );

  return result.fold(
    (failure) => [],
    (usuarios) => usuarios,
  );
});

// =============================================================================
// OBTENER ROL DEL USUARIO ACTUAL EN UNA GRANJA
// =============================================================================

final rolUsuarioActualEnGranjaProvider = FutureProvider.family<
  RolGranja?,
  String
>((ref, granjaId) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) return null;

  final repository = ref.watch(granjaUsuariosRepositoryProvider);
  final result = await repository.obtenerRolUsuarioEnGranja(
    granjaId: granjaId,
    usuarioId: currentUser.id,
  );

  return result.fold(
    (failure) => null,
    (rol) => rol,
  );
});

// =============================================================================
// OBTENER GRANJAS DEL USUARIO ACTUAL
// =============================================================================

final granjasUsuarioActualProvider = FutureProvider<List<String>>((ref) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) return [];

  final repository = ref.watch(granjaUsuariosRepositoryProvider);
  final result = await repository.obtenerGranjasPorUsuario(
    usuarioId: currentUser.id,
    soloActivas: true,
  );

  return result.fold(
    (failure) => [],
    (granjas) => granjas,
  );
});
```

### 6. Cambios en Home (UI)

**home_page.dart (actualizado):**
```dart
// En HomeHeader, cambiar:

// ANTES:
Text(
  'Mi Granja',
  style: ...
),

// DESPUÉS:
Consumer(
  builder: (context, ref, child) {
    final currentUser = ref.watch(currentUserProvider);
    final rolActual = ref.watch(
      rolUsuarioActualEnGranjaProvider('granja_id_actual'),
    );

    return rolActual.when(
      data: (rol) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mi Granja'),
          if (rol != null)
            Text(
              'Rol: ${rol.displayName}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.blue,
              ),
            ),
        ],
      ),
      loading: () => Text('Cargando...'),
      error: (_, __) => Text('Mi Granja'),
    );
  },
)
```

### 7. Firestore Rules (Security Rules)

```
// firestore.rules

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Usuarios
    match /usuarios/{userId} {
      allow read: if request.auth.uid == userId || 
                     request.auth.uid != null;
      allow write: if request.auth.uid == userId;
    }

    // Granjas
    match /granjas/{granjaId} {
      // Leer si el usuario tiene acceso a la granja
      allow read: if hasAccessToGranja(granjaId);
      
      // Escribir solo si es OWNER o ADMIN
      allow write: if hasRoleInGranja(granjaId, ['owner', 'admin']);
      
      // Eliminar solo si es OWNER
      allow delete: if hasRoleInGranja(granjaId, ['owner']);
    }

    // Relación usuario-granja
    match /granja_usuarios/{document=**} {
      allow read: if hasAccessToGranja(document.data.granjaId);
      allow create: if canInviteUsers(document.data.granjaId);
      allow update: if canChangeRoles(document.data.granjaId);
      allow delete: if canRemoveUsers(document.data.granjaId);
    }

    // Invitaciones
    match /invitaciones_granja/{invitacionId} {
      allow read: if resource.data.emailDestino == request.auth.token.email ||
                     hasAccessToGranja(resource.data.granjaId);
      allow create: if canInviteUsers(request.resource.data.granjaId);
      allow delete: if canInviteUsers(resource.data.granjaId);
    }

    // Funciones helper
    function hasAccessToGranja(granjaId) {
      return exists(/databases/$(database)/documents/granja_usuarios/$(granjaId)_$(request.auth.uid))
             && get(/databases/$(database)/documents/granja_usuarios/$(granjaId)_$(request.auth.uid)).data.activo == true;
    }

    function hasRoleInGranja(granjaId, roles) {
      return hasAccessToGranja(granjaId) &&
             get(/databases/$(database)/documents/granja_usuarios/$(granjaId)_$(request.auth.uid)).data.rol in roles;
    }

    function canInviteUsers(granjaId) {
      return hasRoleInGranja(granjaId, ['owner', 'admin']);
    }

    function canChangeRoles(granjaId) {
      return hasRoleInGranja(granjaId, ['owner', 'admin']);
    }

    function canRemoveUsers(granjaId) {
      return hasRoleInGranja(granjaId, ['owner', 'admin']);
    }
  }
}
```

---

## 📊 Diagrama de Flujo

### Invitar Usuario

```
┌─────────────────────┐
│   Usuario ADMIN     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Click "Invitar"     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Dialog: Rol + Email │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ GenerarCódigo       │
│ "FARM-ABC123-..."   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Guardar en Firestore│
│ invitaciones_granja │
└──────────┬──────────┘
           │
           ├─► Enviar Email (opcional)
           │
           └─► Mostrar QR/Código
```

### Aceptar Invitación

```
┌─────────────────────┐
│  Usuario Nuevo      │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Ingresa Código      │
│ "FARM-ABC123-..."   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ ValidarCódigo       │
│ (existe, válido)    │
└──────────┬──────────┘
           │
           ├─► ¿Válido?
           │   ├─ NO  ─► Error
           │   │
           │   └─ SÍ  ▼
           │    ┌──────────────────┐
           │    │ Crear GranjaUser │
           └───►│ Marcar Usada     │
                │ Actualizar Acceso│
                └────────┬─────────┘
                         │
                         ▼
                 ┌──────────────────┐
                 │ ¡Acceso Otorgado!│
                 └──────────────────┘
```

---

## 🎯 Resumen Ejecutivo

| Aspecto | Detalle |
|--------|---------|
| **Objetivo** | Permitir múltiples usuarios en una granja |
| **Modelos Nuevos** | GranjaUsuario, InvitacionGranja, RolGranja |
| **Colecciones Firestore** | granja_usuarios, invitaciones_granja |
| **Roles** | OWNER, ADMIN, MANAGER, OPERATOR, VIEWER |
| **Sistema Invitación** | Códigos únicos (12 caracteres) con expiración 30 días |
| **Tiempo Estimado** | 16-22 horas |
| **Complejidad** | Media-Alta |
| **Prioridad** | Alta |

---

## ✅ Checklist de Implementación

- [ ] Crear entidades (GranjaUsuario, InvitacionGranja, RolGranja)
- [ ] Crear models para Firestore
- [ ] Crear interfaces de repositorio
- [ ] Crear implementación de repositorio
- [ ] Crear use cases
- [ ] Crear providers Riverpod
- [ ] Crear UI para invitar usuarios
- [ ] Crear UI para aceptar invitación
- [ ] Crear UI para listar colaboradores
- [ ] Actualizar security rules de Firestore
- [ ] Crear tests unitarios
- [ ] Crear tests de UI
- [ ] Documentación de API
- [ ] Pruebas E2E

---

## 📞 Próximas Preguntas a Responder

1. ¿Quieres envío de emails con invitaciones?
2. ¿Límite de usuarios por granja?
3. ¿Historial de auditoría completo?
4. ¿Notificaciones en tiempo real?
5. ¿Integración con permisos granulares en API?

