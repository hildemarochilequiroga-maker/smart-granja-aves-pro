/// Widget guard para verificar permisos antes de mostrar contenido.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/granjas/application/providers/colaboradores_providers.dart';
import '../../features/granjas/domain/enums/rol_granja_enum.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Tipo de permiso requerido.
enum TipoPermiso {
  // Registros
  crearRegistros,
  editarRegistros,
  eliminarRegistros,
  // Lotes
  crearLotes,
  editarLotes,
  eliminarLotes,
  // Galpones
  crearGalpones,
  editarGalpones,
  eliminarGalpones,
  // Usuarios
  invitarUsuarios,
  cambiarRoles,
  removerUsuarios,
  verColaboradores,
  // Granja
  editarGranja,
  eliminarGranja,
  // Otros
  verReportes,
  exportarDatos,
  gestionarInventario,
  crearVentas,
  verConfiguracion,
}

/// Widget que verifica permisos antes de mostrar su contenido.
///
/// Si el usuario no tiene el permiso requerido:
/// - Muestra un mensaje de acceso denegado si [showAccessDenied] es true
/// - Oculta el contenido si [showAccessDenied] es false
class PermissionGuard extends ConsumerWidget {
  const PermissionGuard({
    super.key,
    required this.granjaId,
    required this.permiso,
    required this.child,
    this.showAccessDenied = true,
    this.accessDeniedMessage,
    this.loadingWidget,
  });

  /// ID de la granja para verificar permisos.
  final String granjaId;

  /// Tipo de permiso requerido.
  final TipoPermiso permiso;

  /// Widget a mostrar si tiene permiso.
  final Widget child;

  /// Si mostrar mensaje de acceso denegado.
  final bool showAccessDenied;

  /// Mensaje personalizado de acceso denegado.
  final String? accessDeniedMessage;

  /// Widget a mostrar mientras carga.
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolAsync = ref.watch(rolUsuarioActualEnGranjaProvider(granjaId));

    return rolAsync.when(
      data: (rol) {
        if (rol == null || !_tienePermiso(rol)) {
          if (!showAccessDenied) return const SizedBox.shrink();
          return _AccessDeniedWidget(
            message: accessDeniedMessage ?? _getMensajeDefecto(context),
          );
        }
        return child;
      },
      loading: () =>
          loadingWidget ?? const Center(child: CircularProgressIndicator()),
      error: (_, __) =>
          _AccessDeniedWidget(message: S.of(context).errorVerifyPermissions),
    );
  }

  bool _tienePermiso(RolGranja rol) {
    switch (permiso) {
      // Registros
      case TipoPermiso.crearRegistros:
        return rol.canCreateRecords;
      case TipoPermiso.editarRegistros:
        return rol.canEditRecords;
      case TipoPermiso.eliminarRegistros:
        return rol.canDeleteRecords;
      // Lotes
      case TipoPermiso.crearLotes:
        return rol.canCreateLotes;
      case TipoPermiso.editarLotes:
        return rol.canEditLotes;
      case TipoPermiso.eliminarLotes:
        return rol.canDeleteLotes;
      // Galpones
      case TipoPermiso.crearGalpones:
        return rol.canCreateGalpones;
      case TipoPermiso.editarGalpones:
        return rol.canEditGalpones;
      case TipoPermiso.eliminarGalpones:
        return rol.canDeleteGalpones;
      // Usuarios
      case TipoPermiso.invitarUsuarios:
        return rol.canInviteUsers;
      case TipoPermiso.cambiarRoles:
        return rol.canChangeRoles;
      case TipoPermiso.removerUsuarios:
        return rol.canRemoveUsers;
      case TipoPermiso.verColaboradores:
        return rol.canListColaboradores;
      // Granja
      case TipoPermiso.editarGranja:
        return rol.canEditGranja;
      case TipoPermiso.eliminarGranja:
        return rol.canDeleteGranja;
      // Otros
      case TipoPermiso.verReportes:
        return rol.canViewReports;
      case TipoPermiso.exportarDatos:
        return rol.canExportData;
      case TipoPermiso.gestionarInventario:
        return rol.canManageInventario;
      case TipoPermiso.crearVentas:
        return rol.canCreateVentas;
      case TipoPermiso.verConfiguracion:
        return rol.canViewConfig;
    }
  }

  String _getMensajeDefecto(BuildContext context) {
    final l = S.of(context);
    switch (permiso) {
      // Registros
      case TipoPermiso.crearRegistros:
        return l.permNoCreateRecords;
      case TipoPermiso.editarRegistros:
        return l.permNoEditRecords;
      case TipoPermiso.eliminarRegistros:
        return l.permNoDeleteRecords;
      // Lotes
      case TipoPermiso.crearLotes:
        return l.permNoCreateBatches;
      case TipoPermiso.editarLotes:
        return l.permNoEditBatches;
      case TipoPermiso.eliminarLotes:
        return l.permNoDeleteBatches;
      // Galpones
      case TipoPermiso.crearGalpones:
        return l.permNoCreateSheds;
      case TipoPermiso.editarGalpones:
        return l.permNoEditSheds;
      case TipoPermiso.eliminarGalpones:
        return l.permNoDeleteSheds;
      // Usuarios
      case TipoPermiso.invitarUsuarios:
        return l.permNoInviteUsers;
      case TipoPermiso.cambiarRoles:
        return l.permNoChangeRoles;
      case TipoPermiso.removerUsuarios:
        return l.permNoRemoveUsers;
      case TipoPermiso.verColaboradores:
        return l.permNoViewCollaborators;
      // Granja
      case TipoPermiso.editarGranja:
        return l.permNoEditFarm;
      case TipoPermiso.eliminarGranja:
        return l.permNoDeleteFarm;
      // Otros
      case TipoPermiso.verReportes:
        return l.permNoViewReports;
      case TipoPermiso.exportarDatos:
        return l.permNoExportData;
      case TipoPermiso.gestionarInventario:
        return l.permNoManageInventory;
      case TipoPermiso.crearVentas:
        return l.permNoRegisterSales;
      case TipoPermiso.verConfiguracion:
        return l.permNoViewSettings;
    }
  }
}

/// Widget de acceso denegado.
class _AccessDeniedWidget extends StatelessWidget {
  const _AccessDeniedWidget({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_outline, size: 48, color: AppColors.error),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Acceso restringido',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extensión para verificar permisos de forma reactiva.
extension PermissionCheckExtension on WidgetRef {
  /// Verifica si el usuario actual puede crear registros en la granja.
  Future<bool> canCreateRecords(String granjaId) async {
    final rol = await read(rolUsuarioActualEnGranjaProvider(granjaId).future);
    return rol?.canCreateRecords ?? false;
  }

  /// Verifica si el usuario actual puede editar registros en la granja.
  Future<bool> canEditRecords(String granjaId) async {
    final rol = await read(rolUsuarioActualEnGranjaProvider(granjaId).future);
    return rol?.canEditRecords ?? false;
  }

  /// Obtiene el rol actual del usuario en la granja.
  Future<RolGranja?> getCurrentRole(String granjaId) async {
    return await read(rolUsuarioActualEnGranjaProvider(granjaId).future);
  }
}

/// Botón que solo se muestra si el usuario tiene permiso.
class PermissionButton extends ConsumerWidget {
  const PermissionButton({
    super.key,
    required this.granjaId,
    required this.permiso,
    required this.onPressed,
    required this.child,
    this.style,
  });

  final String granjaId;
  final TipoPermiso permiso;
  final VoidCallback onPressed;
  final Widget child;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolAsync = ref.watch(rolUsuarioActualEnGranjaProvider(granjaId));

    return rolAsync.when(
      data: (rol) {
        if (rol == null || !_tienePermiso(rol)) {
          return const SizedBox.shrink();
        }
        return FilledButton(onPressed: onPressed, style: style, child: child);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  bool _tienePermiso(RolGranja rol) {
    switch (permiso) {
      // Registros
      case TipoPermiso.crearRegistros:
        return rol.canCreateRecords;
      case TipoPermiso.editarRegistros:
        return rol.canEditRecords;
      case TipoPermiso.eliminarRegistros:
        return rol.canDeleteRecords;
      // Lotes
      case TipoPermiso.crearLotes:
        return rol.canCreateLotes;
      case TipoPermiso.editarLotes:
        return rol.canEditLotes;
      case TipoPermiso.eliminarLotes:
        return rol.canDeleteLotes;
      // Galpones
      case TipoPermiso.crearGalpones:
        return rol.canCreateGalpones;
      case TipoPermiso.editarGalpones:
        return rol.canEditGalpones;
      case TipoPermiso.eliminarGalpones:
        return rol.canDeleteGalpones;
      // Usuarios
      case TipoPermiso.invitarUsuarios:
        return rol.canInviteUsers;
      case TipoPermiso.cambiarRoles:
        return rol.canChangeRoles;
      case TipoPermiso.removerUsuarios:
        return rol.canRemoveUsers;
      case TipoPermiso.verColaboradores:
        return rol.canListColaboradores;
      // Granja
      case TipoPermiso.editarGranja:
        return rol.canEditGranja;
      case TipoPermiso.eliminarGranja:
        return rol.canDeleteGranja;
      // Otros
      case TipoPermiso.verReportes:
        return rol.canViewReports;
      case TipoPermiso.exportarDatos:
        return rol.canExportData;
      case TipoPermiso.gestionarInventario:
        return rol.canManageInventario;
      case TipoPermiso.crearVentas:
        return rol.canCreateVentas;
      case TipoPermiso.verConfiguracion:
        return rol.canViewConfig;
    }
  }
}
