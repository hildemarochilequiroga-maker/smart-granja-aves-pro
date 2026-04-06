/// Página para gestionar colaboradores de una granja.
///
/// Muestra la lista de colaboradores y permite:
/// - Ver todos los usuarios con acceso
/// - Cambiar roles
/// - Remover colaboradores
/// - Invitar nuevos usuarios
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../application/providers/colaboradores_providers.dart';
import '../../domain/entities/granja_usuario.dart';
import '../../domain/enums/rol_granja_enum.dart';

/// Página principal de gestión de colaboradores.
class GestionarColaboradoresPage extends ConsumerWidget {
  const GestionarColaboradoresPage({
    super.key,
    required this.granjaId,
    required this.granjaNombre,
  });

  final String granjaId;
  final String granjaNombre;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('👥 [GestionarColaboradoresPage] build');
    debugPrint('   ├─ granjaId: $granjaId');
    debugPrint('   └─ granjaNombre: $granjaNombre');

    final theme = Theme.of(context);
    final colaboradoresAsync = ref.watch(usuariosGranjaProvider(granjaId));
    final currentUser = ref.watch(currentUserProvider);
    final rolUsuarioActualAsync = ref.watch(
      rolUsuarioActualEnGranjaProvider(granjaId),
    );

    debugPrint(
      '   ├─ currentUser: ${currentUser?.id.substring(0, 8) ?? "null"}...',
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(S.of(context).farmCollaborators),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(usuariosGranjaProvider(granjaId)),
            icon: const Icon(Icons.refresh),
            tooltip: S.of(context).commonUpdate,
          ),
        ],
      ),
      floatingActionButton: rolUsuarioActualAsync.when(
        data: (rolActual) {
          if (rolActual == null || !rolActual.canInviteUsers) {
            return null;
          }
          return FloatingActionButton.extended(
            heroTag: 'invitar_fab',
            tooltip: S.of(context).farmInviteCollaboratorToFarm,
            onPressed: () {
              context.push(
                AppRoutes.granjaInvitarById(granjaId),
                extra: {'granjaNombre': granjaNombre},
              );
            },
            icon: const Icon(Icons.person_add_rounded),
            label: Text(S.of(context).farmInviteCollaborator),
          );
        },
        loading: () => null,
        error: (_, __) => null,
      ),
      body: colaboradoresAsync.when(
        data: (colaboradores) {
          if (colaboradores.isEmpty) {
            return _EmptyState(granjaId: granjaId, granjaNombre: granjaNombre);
          }
          return _ColaboradoresList(
            colaboradores: colaboradores,
            granjaId: granjaId,
            currentUserId: currentUser?.id ?? '',
            rolUsuarioActual: rolUsuarioActualAsync.valueOrNull,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(
          error: error.toString(),
          onRetry: () => ref.invalidate(usuariosGranjaProvider(granjaId)),
        ),
      ),
    );
  }
}

/// Estado vacío - sin colaboradores.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.granjaId, required this.granjaNombre});

  final String granjaId;
  final String granjaNombre;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline,
                size: 64,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              S.of(context).farmNoCollaborators,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              S.of(context).farmInviteHelpText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            FilledButton.icon(
              onPressed: () {
                context.push(
                  AppRoutes.granjaInvitarById(granjaId),
                  extra: {'granjaNombre': granjaNombre},
                );
              },
              icon: const Icon(Icons.person_add),
              label: Text(S.of(context).farmInviteUser),
              style: FilledButton.styleFrom(minimumSize: const Size(200, 48)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Estado de error.
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: AppSpacing.base),
            Text(
              S.of(context).commonErrorLoading,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(S.of(context).commonRetry),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lista de colaboradores.
class _ColaboradoresList extends StatelessWidget {
  const _ColaboradoresList({
    required this.colaboradores,
    required this.granjaId,
    required this.currentUserId,
    this.rolUsuarioActual,
  });

  final List<GranjaUsuario> colaboradores;
  final String granjaId;
  final String currentUserId;
  final RolGranja? rolUsuarioActual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Ordenar: owner primero, luego por rol
    final sorted = List<GranjaUsuario>.from(colaboradores)
      ..sort((a, b) {
        final orderA = a.rol.index;
        final orderB = b.rol.index;
        return orderA.compareTo(orderB);
      });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sorted.length + 1, // +1 para el header
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: AppRadius.allMd,
              ),
              child: Center(
                child: Text(
                  S.of(context).farmCollaboratorsCount(colaboradores.length),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        }

        final colaborador = sorted[index - 1];
        final isCurrentUser = colaborador.usuarioId == currentUserId;

        return _ColaboradorCard(
          colaborador: colaborador,
          granjaId: granjaId,
          isCurrentUser: isCurrentUser,
          rolUsuarioActual: rolUsuarioActual,
        );
      },
    );
  }
}

/// Card de un colaborador.
class _ColaboradorCard extends ConsumerStatefulWidget {
  const _ColaboradorCard({
    required this.colaborador,
    required this.granjaId,
    required this.isCurrentUser,
    this.rolUsuarioActual,
  });

  final GranjaUsuario colaborador;
  final String granjaId;
  final bool isCurrentUser;
  final RolGranja? rolUsuarioActual;

  @override
  ConsumerState<_ColaboradorCard> createState() => _ColaboradorCardState();
}

class _ColaboradorCardState extends ConsumerState<_ColaboradorCard> {
  bool _isLoading = false;

  Future<void> _cambiarRol(RolGranja nuevoRol) async {
    debugPrint('🔄 [ColaboradorCard] _cambiarRol');
    debugPrint(
      '   ├─ usuarioId: ${widget.colaborador.usuarioId.substring(0, 8)}...',
    );
    debugPrint('   ├─ rolActual: ${widget.colaborador.rol.name}');
    debugPrint('   └─ nuevoRol: ${nuevoRol.name}');

    if (nuevoRol == widget.colaborador.rol) {
      debugPrint('   ⚠️ Rol sin cambios');
      return;
    }
    if (widget.colaborador.rol == RolGranja.owner) {
      debugPrint('   ❌ No se puede cambiar rol del propietario');
      _showError(S.of(context).farmCannotChangeOwnerRole);
      return;
    }

    setState(() => _isLoading = true);

    try {
      debugPrint('   ├─ Cambiando rol...');
      await ref.read(
        cambiarRolProvider(
          CambiarRolParamsUI(
            granjaId: widget.granjaId,
            usuarioId: widget.colaborador.usuarioId,
            nuevoRol: nuevoRol,
          ),
        ).future,
      );

      if (mounted) {
        debugPrint('✅ [ColaboradorCard] Rol cambiado exitosamente');
        AppSnackBar.success(
          context,
          message: S
              .of(context)
              .farmRoleUpdated(nuevoRol.localizedDisplayName(S.of(context))),
        );
        ref.invalidate(usuariosGranjaProvider(widget.granjaId));
      }
    } on Exception catch (e) {
      debugPrint('❌ [ColaboradorCard] Error cambiando rol: $e');
      if (mounted) {
        _showError(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _removerColaborador() async {
    debugPrint('🗑️ [ColaboradorCard] _removerColaborador');
    debugPrint(
      '   ├─ usuarioId: ${widget.colaborador.usuarioId.substring(0, 8)}...',
    );
    debugPrint('   ├─ isCurrentUser: ${widget.isCurrentUser}');
    debugPrint('   └─ rol: ${widget.colaborador.rol.name}');

    if (widget.colaborador.rol == RolGranja.owner) {
      debugPrint('   ❌ No se puede remover al propietario');
      _showError(S.of(context).farmCannotRemoveOwner);
      return;
    }

    final confirmado = await showAppConfirmDialog(
      context: context,
      title: S.of(context).farmRemoveCollaborator,
      message: widget.isCurrentUser
          ? S.of(context).farmConfirmLeave
          : S.of(context).farmConfirmRemoveUser,
      type: AppDialogType.danger,
      confirmText: widget.isCurrentUser
          ? S.of(context).farmLeaveAction
          : S.of(context).farmRemoveAction,
    );

    if (!confirmado) {
      debugPrint('   ⚠️ Acción cancelada por el usuario');
      return;
    }

    debugPrint('   ├─ Usuario confirmó, removiendo...');
    setState(() => _isLoading = true);

    try {
      await ref.read(
        removerColaboradorProvider(
          RemoverColaboradorParamsUI(
            granjaId: widget.granjaId,
            usuarioId: widget.colaborador.usuarioId,
          ),
        ).future,
      );

      if (mounted) {
        debugPrint(
          '✅ [ColaboradorCard] Usuario removido/abandonó exitosamente',
        );
        AppSnackBar.success(
          context,
          message: widget.isCurrentUser
              ? S.of(context).farmLeftFarm
              : S.of(context).farmCollaboratorRemoved,
        );

        if (widget.isCurrentUser) {
          debugPrint('   └─ Navegando a lista de granjas...');
          context.go(AppRoutes.granjas);
        } else {
          ref.invalidate(usuariosGranjaProvider(widget.granjaId));
        }
      }
    } on Exception catch (e) {
      debugPrint('❌ [ColaboradorCard] Error removiendo: $e');
      if (mounted) {
        _showError(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    AppSnackBar.error(context, message: message);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rol = widget.colaborador.rol;
    final isOwner = rol == RolGranja.owner;
    final rolColor = _getRolColor(rol);

    // Permisos del usuario actual
    final puedeGestionar = widget.rolUsuarioActual?.canChangeRoles ?? false;
    final puedeRemover = widget.rolUsuarioActual?.canRemoveUsers ?? false;
    // El usuario actual siempre puede abandonar (si no es owner)
    final puedeAbandonar = widget.isCurrentUser && !isOwner;
    // Mostrar menú si puede gestionar otros O puede abandonar
    final mostrarMenu = (!isOwner && puedeGestionar) || puedeAbandonar;

    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.onSurface.withValues(alpha: 0.3),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.allMd,
          border: Border(left: BorderSide(color: rolColor, width: 4)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rol
                    Row(
                      children: [
                        Text(
                          rol.localizedDisplayName(S.of(context)),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: rolColor,
                          ),
                        ),
                        if (widget.isCurrentUser) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: AppRadius.allXs,
                            ),
                            child: Text(
                              S.of(context).commonYouTag,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // Nombre completo del usuario
                    Text(
                      widget.colaborador.nombreCompleto ??
                          S.of(context).commonNoName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    // Email del usuario
                    Text(
                      widget.colaborador.email ?? S.of(context).commonNoEmail,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    // Fecha de asignación
                    Text(
                      S
                          .of(context)
                          .commonSince(
                            _formatDate(widget.colaborador.fechaAsignacion),
                          ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Loading o acciones
              if (_isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (mostrarMenu)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onSelected: (value) {
                    if (value == 'remove' || value == 'abandon') {
                      _removerColaborador();
                    } else {
                      final nuevoRol = RolGranja.values.firstWhere(
                        (r) => r.name == value,
                        orElse: () => widget.colaborador.rol,
                      );
                      _cambiarRol(nuevoRol);
                    }
                  },
                  itemBuilder: (context) => [
                    // Opciones de cambiar rol (solo si tiene permiso y no es él mismo)
                    if (puedeGestionar && !widget.isCurrentUser) ...[
                      PopupMenuItem(
                        enabled: false,
                        child: Text(
                          S.of(context).farmChangeRoleTo,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...RolGranja.values
                          .where((r) => r != RolGranja.owner && r != rol)
                          .map(
                            (r) => PopupMenuItem(
                              value: r.name,
                              child: Row(
                                children: [
                                  Icon(
                                    _getRolIcon(r),
                                    size: 18,
                                    color: _getRolColor(r),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(r.localizedDisplayName(S.of(context))),
                                ],
                              ),
                            ),
                          ),
                      const PopupMenuDivider(),
                    ],
                    // Opción de remover (solo si tiene permiso) o abandonar (si es él mismo)
                    if (puedeAbandonar)
                      PopupMenuItem(
                        value: 'abandon',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.exit_to_app,
                              size: 18,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              S.of(context).farmLeaveFarm,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (puedeRemover && !widget.isCurrentUser)
                      PopupMenuItem(
                        value: 'remove',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_remove,
                              size: 18,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              S.of(context).farmRemoveUser,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getRolColor(RolGranja rol) {
    return switch (rol) {
      RolGranja.owner => AppColors.purple,
      RolGranja.admin => AppColors.error,
      RolGranja.manager => AppColors.warning,
      RolGranja.operator => AppColors.primaryDark,
      RolGranja.viewer => AppColors.grey600,
    };
  }

  IconData _getRolIcon(RolGranja rol) {
    return switch (rol) {
      RolGranja.owner => Icons.star,
      RolGranja.admin => Icons.admin_panel_settings,
      RolGranja.manager => Icons.manage_accounts,
      RolGranja.operator => Icons.engineering,
      RolGranja.viewer => Icons.visibility,
    };
  }
}
