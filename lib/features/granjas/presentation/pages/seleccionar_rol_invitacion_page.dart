/// Página para seleccionar el rol de la invitación.
///
/// Primera etapa del flujo de invitación:
/// Usuario selecciona el rol → Genera código → Navega a página de código
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../application/providers/colaboradores_providers.dart';
import '../../domain/enums/rol_granja_enum.dart';

/// Página para seleccionar el rol antes de generar la invitación.
class SeleccionarRolInvitacionPage extends ConsumerStatefulWidget {
  const SeleccionarRolInvitacionPage({
    super.key,
    required this.granjaId,
    required this.granjaNombre,
  });

  final String granjaId;
  final String granjaNombre;

  @override
  ConsumerState<SeleccionarRolInvitacionPage> createState() =>
      _SeleccionarRolInvitacionPageState();
}

class _SeleccionarRolInvitacionPageState
    extends ConsumerState<SeleccionarRolInvitacionPage> {
  RolGranja _rolSeleccionado = RolGranja.operator;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    debugPrint('📨 [SeleccionarRolPage] build');
    debugPrint('   ├─ granjaId: ${widget.granjaId}');
    debugPrint('   └─ granjaNombre: ${widget.granjaNombre}');

    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider);

    // Verificar permisos del usuario actual
    final rolUsuarioAsync = ref.watch(
      rolUsuarioActualEnGranjaProvider(widget.granjaId),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(S.of(context).farmInviteUser),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: rolUsuarioAsync.when(
        data: (rolUsuario) {
          if (currentUser == null) {
            return _buildNoPermissionView(
              theme,
              context,
              S.of(context).farmMustLoginToInvite,
              Icons.login,
            );
          }

          if (rolUsuario == null || !rolUsuario.canInviteUsers) {
            return _buildNoPermissionView(
              theme,
              context,
              S.of(context).farmNoPermToInvite,
              Icons.lock_outline,
            );
          }

          return _buildContent(theme, currentUser);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildNoPermissionView(
          theme,
          context,
          S.of(context).farmVerifyPermError(error.toString()),
          Icons.error_outline,
        ),
      ),
    );
  }

  Widget _buildNoPermissionView(
    ThemeData theme,
    BuildContext context,
    String message,
    IconData icon,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).farmNoPermissions,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapMd,
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapXl,
            OutlinedButton(
              onPressed: () => context.pop(),
              child: Text(S.of(context).commonBack),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, dynamic currentUser) {
    return Column(
      children: [
        // Contenido scrolleable
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                _buildHeader(theme),
                AppSpacing.gapXl,

                // Selector de rol
                _buildRolSelector(theme),

                // Error message
                if (_errorMessage != null) ...[
                  AppSpacing.gapBase,
                  _buildErrorMessage(theme),
                ],
              ],
            ),
          ),
        ),

        // Botón fijo en la parte inferior
        _buildBottomButton(theme, currentUser),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Text(
      widget.granjaNombre,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildRolSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).farmWhatRoleWillUserHave,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.gapSm,
        Text(
          S.of(context).farmChoosePermissions,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.gapLg,

        // Lista de roles (excluyendo owner)
        ...RolGranja.values.where((r) => r != RolGranja.owner).map((rol) {
          final isSelected = _rolSeleccionado == rol;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RolCard(
              rol: rol,
              isSelected: isSelected,
              onTap: () => setState(() => _rolSeleccionado = rol),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildErrorMessage(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: AppRadius.allMd,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Text(
        _errorMessage!,
        style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.error),
      ),
    );
  }

  Widget _buildBottomButton(ThemeData theme, dynamic currentUser) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: _isLoading
                ? null
                : () => _generarInvitacion(currentUser),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allLg),
            ),
            child: _isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                : Text(
                    S.of(context).farmGenerateCode,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _generarInvitacion(dynamic currentUser) async {
    debugPrint('📨 [SeleccionarRolPage] _generarInvitacion');
    debugPrint('   ├─ granjaId: ${widget.granjaId}');
    debugPrint('   ├─ granjaNombre: ${widget.granjaNombre}');
    debugPrint('   ├─ rolSeleccionado: ${_rolSeleccionado.name}');
    debugPrint('   └─ creadoPor: ${currentUser.id.substring(0, 8)}...');

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      debugPrint('   ├─ Creando invitación...');
      final invitacion = await ref.read(
        crearInvitacionProvider(
          CrearInvitacionParams(
            granjaId: widget.granjaId,
            granjaNombre: widget.granjaNombre,
            rol: _rolSeleccionado,
            creadoPorId: currentUser.id,
            creadoPorNombre: currentUser.nombreCompleto,
          ),
        ).future,
      );

      debugPrint('✅ [SeleccionarRolPage] Invitación creada:');
      debugPrint('   ├─ código: ${invitacion.codigo}');
      debugPrint('   └─ expira: ${invitacion.fechaExpiracion}');

      if (mounted) {
        debugPrint('   └─ Navegando a página de código...');
        // Navegar a la página del código generado
        unawaited(
          context.push(
            AppRoutes.granjaInvitacionCodigoById(widget.granjaId),
            extra: {
              'invitacion': invitacion,
              'granjaNombre': widget.granjaNombre,
              'rol': _rolSeleccionado,
            },
          ),
        );
      }
    } on Exception catch (e) {
      debugPrint('❌ [SeleccionarRolPage] Error: $e');
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

/// Card para mostrar un rol seleccionable.
class _RolCard extends StatelessWidget {
  const _RolCard({
    required this.rol,
    required this.isSelected,
    required this.onTap,
  });

  final RolGranja rol;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const color = AppColors.info;

    return Card(
      elevation: isSelected ? 4 : 1,
      shadowColor: isSelected
          ? color.withValues(alpha: 0.4)
          : theme.colorScheme.onSurface.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allLg,
        side: BorderSide(
          color: isSelected ? color : theme.colorScheme.outlineVariant,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.allLg,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      rol.localizedDisplayName(S.of(context)),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? color : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: AppRadius.allMd,
                      ),
                      child: Text(
                        S.of(context).commonSelected,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              AppSpacing.gapXs,
              Text(
                _getRolDescription(rol, context),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.gapMd,
              // Chips de permisos
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: _getPermisos(rol, context)
                    .map(
                      (permiso) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: AppRadius.allSm,
                        ),
                        child: Text(
                          permiso,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRolDescription(RolGranja rol, BuildContext context) {
    final l = S.of(context);
    return switch (rol) {
      RolGranja.owner => l.farmRoleFullControl,
      RolGranja.admin => l.farmRoleFullManagement,
      RolGranja.manager => l.farmRoleOperationsMgmt,
      RolGranja.operator => l.farmRoleDailyRecords,
      RolGranja.viewer => l.farmRoleViewOnly,
    };
  }

  List<String> _getPermisos(RolGranja rol, BuildContext context) {
    final l = S.of(context);
    return switch (rol) {
      RolGranja.owner => [l.farmPermAll],
      RolGranja.admin => [l.farmPermEdit, l.farmPermInvite, l.farmPermManage],
      RolGranja.manager => [
        l.farmPermEdit,
        l.farmPermInvite,
        l.farmPermRecords,
      ],
      RolGranja.operator => [l.farmPermRecords, l.farmPermViewData],
      RolGranja.viewer => [l.farmPermReadOnly],
    };
  }
}
