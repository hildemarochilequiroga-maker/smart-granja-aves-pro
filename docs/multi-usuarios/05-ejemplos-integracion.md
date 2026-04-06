# Ejemplos de Integración - Sistema Multi-Usuario

Este archivo contiene ejemplos prácticos de cómo integrar las nuevas páginas y providers en tu aplicación existente.

## 1. Integración en Home Page

### Agregar botón para unirse a una granja

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageEnhanced extends ConsumerWidget {
  const HomePageEnhanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final misGranjas = ref.watch(granjasUsuarioActualProvider());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Granjas'),
        actions: [
          // Botón para unirse a granja
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _mostrarMenuAgregar(context),
            tooltip: 'Agregar granja',
          ),
        ],
      ),
      body: misGranjas.when(
        data: (granjaIds) => _construirListaGranjas(context, ref, granjaIds),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _mostrarMenuAgregar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Crear Nueva Granja'),
            onTap: () {
              Navigator.pop(context);
              // Navegar a crear granja
            },
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard_rounded),
            title: const Text('Unirse con Código'),
            onTap: () {
              Navigator.pop(context);
              _mostrarDialogoAceptarInvitacion(context);
            },
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoAceptarInvitacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AceptarInvitacionGranjaPage(),
    );
  }

  Widget _construirListaGranjas(
    BuildContext context,
    WidgetRef ref,
    List<String> granjaIds,
  ) {
    return ListView.builder(
      itemCount: granjaIds.length,
      itemBuilder: (context, index) {
        return _GranjaCard(
          granjaId: granjaIds[index],
          onTap: () => _navegarAGranja(context, granjaIds[index]),
        );
      },
    );
  }

  void _navegarAGranja(BuildContext context, String granjaId) {
    // context.push('/granjas/$granjaId');
  }
}

// Widget para mostrar una tarjeta de granja con rol
class _GranjaCard extends ConsumerWidget {
  const _GranjaCard({
    required this.granjaId,
    required this.onTap,
  });

  final String granjaId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolAsync = ref.watch(rolUsuarioActualEnGranjaProvider(granjaId));

    return Card(
      child: ListTile(
        title: Text('Granja $granjaId'),
        subtitle: rolAsync.when(
          data: (rol) => Text(rol?.displayName ?? 'Sin rol'),
          loading: () => const Text('Cargando...'),
          error: (e, st) => const Text('Error'),
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
```

---

## 2. Integración en Granja Detail Page

### Agregar gestión de colaboradores

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GranjaDetailPageEnhanced extends ConsumerWidget {
  const GranjaDetailPageEnhanced({
    Key? key,
    required this.granjaId,
    required this.granjaNombre,
  }) : super(key: key);

  final String granjaId;
  final String granjaNombre;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolActualAsync = ref.watch(rolUsuarioActualEnGranjaProvider(granjaId));

    return Scaffold(
      appBar: AppBar(
        title: Text(granjaNombre),
        actions: [
          // Mostrar rol actual
          rolActualAsync.when(
            data: (rol) => Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Chip(
                  label: Text(rol?.displayName ?? 'Sin rol'),
                  backgroundColor: Colors.blue[200],
                ),
              ),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Secciones principales de la granja
          Expanded(
            child: ListView(
              children: [
                // ... otras secciones (galpones, etc)
                
                // Sección de colaboradores (solo si tienes permiso)
                rolActualAsync.whenData((rol) {
                  if (rol?.canListColaboradores ?? false) {
                    return _seccionColaboradores(context, ref);
                  }
                  return const SizedBox.shrink();
                }).value ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: rolActualAsync.whenData((rol) {
        if (rol?.canInviteUsers ?? false) {
          return FloatingActionButton.extended(
            onPressed: () => _mostrarDialogoInvitar(context),
            icon: const Icon(Icons.person_add_rounded),
            label: const Text('Invitar'),
          );
        }
        return const SizedBox.shrink();
      }).when(
        data: (fab) => fab,
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  void _mostrarDialogoInvitar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => InvitarUsuarioDialog(
        granjaId: granjaId,
        granjaNombre: granjaNombre,
      ),
    );
  }

  Widget _seccionColaboradores(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text('Gestionar Colaboradores'),
      subtitle: const Text('Ver y editar colaboradores de la granja'),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () => _navegarAGestionar(context),
    );
  }

  void _navegarAGestionar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GestionarColaboradoresPage(
          granjaId: granjaId,
          granjaNombre: granjaNombre,
        ),
      ),
    );
  }
}
```

---

## 3. Uso de Providers en Widgets

### Ejemplo 1: Mostrar lista de colaboradores con actualización en tiempo real

```dart
class ColaboradoresWidget extends ConsumerWidget {
  final String granjaId;

  const ColaboradoresWidget({required this.granjaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colaboradoresAsync = ref.watch(usuariosGranjaProvider(granjaId));

    return colaboradoresAsync.when(
      data: (colaboradores) => ListView.builder(
        itemCount: colaboradores.length,
        itemBuilder: (context, index) {
          final colaborador = colaboradores[index];
          return _buildColaboradorItem(colaborador);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildColaboradorItem(GranjaUsuario colaborador) {
    return ListTile(
      title: Text(colaborador.usuarioId),
      subtitle: Text(colaborador.rol.displayName),
      trailing: colaborador.activo
          ? null
          : Chip(label: const Text('Removido'), backgroundColor: Colors.red[100]),
    );
  }
}
```

### Ejemplo 2: Validación de permisos antes de mostrar botones

```dart
class AdminControlsWidget extends ConsumerWidget {
  final String granjaId;

  const AdminControlsWidget({required this.granjaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolAsync = ref.watch(rolUsuarioActualEnGranjaProvider(granjaId));

    return rolAsync.when(
      data: (rol) {
        if (rol?.canChangeRoles ?? false) {
          return Column(
            children: [
              ElevatedButton(
                onPressed: () => _cambiarRoles(context, ref),
                child: const Text('Cambiar Roles'),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Text('Error al cargar permisos'),
    );
  }

  void _cambiarRoles(BuildContext context, WidgetRef ref) {
    // Implementar lógica para cambiar roles
  }
}
```

---

## 4. Manejo de Errores

### Ejemplo: Crear invitación con manejo robusto de errores

```dart
Future<void> crearInvitacionConErrorHandling(
  BuildContext context,
  WidgetRef ref,
) async {
  try {
    final invitacion = await ref.read(
      crearInvitacionProvider(
        CrearInvitacionParamsUI(
          granjaId: 'farm123',
          granjaNombre: 'Mi Granja',
          rol: RolGranja.operator,
          creadoPorId: 'user@email.com',
          creadoPorNombre: 'Juan Pérez',
          emailDestino: null,
        ),
      ).future,
    );

    // Éxito
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invitación creada: ${invitacion.codigo}'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Copiar',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: invitacion.codigo));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copiado')),
              );
            },
          ),
        ),
      );
    }
  } on Exception catch (e) {
    // Error
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
```

---

## 5. Integración con Go Router

### Agregando rutas para las nuevas páginas

```dart
// En tu app_routes.dart

final appRoutes = GoRouter(
  routes: [
    // ... otras rutas
    
    GoRoute(
      path: '/aceptar-invitacion',
      builder: (context, state) {
        final codigo = state.queryParameters['codigo'];
        return AceptarInvitacionGranjaPage(codigo: codigo);
      },
    ),
    
    GoRoute(
      path: '/granjas/:granjaId/colaboradores',
      builder: (context, state) {
        final granjaId = state.pathParameters['granjaId']!;
        final granjaNombre = state.queryParameters['nombre'] ?? 'Granja';
        return GestionarColaboradoresPage(
          granjaId: granjaId,
          granjaNombre: granjaNombre,
        );
      },
    ),
  ],
);

// Uso en la app:
// context.push('/aceptar-invitacion?codigo=FARM-ABC123-XYZ789');
// context.push('/granjas/farm123/colaboradores?nombre=Mi%20Granja');
```

---

## 6. Testing - Ejemplos de Pruebas

### Unit Test para Use Case

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InvitarUsuarioAGranjaUseCase', () {
    late InvitarUsuarioAGranjaUseCase useCase;
    late MockInvitacionesRepository mockRepo;

    setUp(() {
      mockRepo = MockInvitacionesRepository();
      useCase = InvitarUsuarioAGranjaUseCase(mockRepo);
    });

    test('should return InvitacionGranja on success', () async {
      // Arrange
      const params = InvitarUsuarioAGranjaParams(
        granjaId: 'farm123',
        granjaNombre: 'Test Farm',
        rol: RolGranja.operator,
        creadoPorId: 'user123',
        creadoPorNombre: 'Test User',
      );

      final mockInvitacion = InvitacionGranja(
        id: 'inv123',
        codigo: 'FARM-ABC123-XYZ789',
        granjaId: 'farm123',
        granjaNombre: 'Test Farm',
        creadoPorId: 'user123',
        creadoPorNombre: 'Test User',
        rol: RolGranja.operator,
        fechaCreacion: DateTime.now(),
        fechaExpiracion: DateTime.now().add(Duration(days: 30)),
        emailDestino: null,
        usado: false,
      );

      when(mockRepo.crearInvitacion(any))
          .thenAnswer((_) async => Right(mockInvitacion));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (invitacion) {
          expect(invitacion.codigo, 'FARM-ABC123-XYZ789');
          expect(invitacion.granjaId, 'farm123');
        },
      );

      verify(mockRepo.crearInvitacion(any)).called(1);
    });
  });
}
```

---

## 7. Flujo Completo - Ejemplo Práctico

### Usuario nuevo se une a granja

```dart
// 1. Usuario ve botón en home
HomePageEnhanced()
  // 2. Click en "Unirse con Código"
  → _mostrarDialogoAceptarInvitacion()
  → AceptarInvitacionGranjaPage()
  
  // 3. Ingresa código: FARM-ABC123-XYZ789
  → aceptarInvitacionProvider(codigo)
  → Backend valida
  → Crea GranjaUsuario
  → Marca invitación como usada
  → ✅ Éxito
  
  // 4. Usuario ahora aparece en:
  → usuariosGranjaProvider(granjaId)
  → rolUsuarioActualEnGranjaProvider(granjaId)
  → granjasUsuarioActualProvider()
  
  // 5. UI se actualiza automáticamente (Riverpod)
  → Muestra nuevo acceso
  → Habilita botones según rol
  → Navega a home

// Propietario invita usuario
GranjaDetailPageEnhanced()
  // Click en "Invitar"
  → InvitarUsuarioDialog()
  
  // Selecciona rol: "Operario"
  // Ingresa email: nuevo@email.com (opcional)
  // Click en "Generar Invitación"
  
  → crearInvitacionProvider(params)
  → Backend genera código: "FARM-ABC123-XYZ789"
  → Crea doc en invitaciones_granja
  → ✅ Muestra código
  
  // Propietario copia código
  // Comparte con nuevo usuario: "Tu código es FARM-ABC123-XYZ789"
  
  // Nuevo usuario (por email o mensaje):
  // 1. Abre app
  // 2. Ve botón "Unirse con Código"
  // 3. Ingresa: FARM-ABC123-XYZ789
  // 4. Sistema valida y acepta
  // 5. Ya tiene acceso ✅
```

---

## 📞 Soporte y Debugging

### Verificar que usuarios aparecen correctamente

```dart
// En ConsoleWidget o DebugPage
ConsumerWidget debugProviders extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usuariosGranjaProvider('farm123'));
    final role = ref.watch(rolUsuarioActualEnGranjaProvider('farm123'));
    final farms = ref.watch(granjasUsuarioActualProvider());
    
    return Column(
      children: [
        Text('Usuarios: ${users.whenData((u) => u.length)}'),
        Text('Mi rol: ${role.whenData((r) => r?.displayName)}'),
        Text('Mis granjas: ${farms.whenData((f) => f.length)}'),
      ],
    );
  }
}
```

---

✅ **Integración Completa - Ready to Go!**
