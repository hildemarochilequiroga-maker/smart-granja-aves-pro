/// Página para aceptar una invitación a una granja.
///
/// Flujo de 2 pasos:
/// 1. Ingresar y verificar código
/// 2. Confirmar y unirse
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../application/providers/colaboradores_providers.dart';
import '../../domain/enums/rol_granja_enum.dart';

/// Página para aceptar una invitación a una granja.
class AceptarInvitacionGranjaPage extends ConsumerStatefulWidget {
  const AceptarInvitacionGranjaPage({super.key, this.codigo});

  final String? codigo;

  @override
  ConsumerState<AceptarInvitacionGranjaPage> createState() =>
      _AceptarInvitacionGranjaPageState();
}

class _AceptarInvitacionGranjaPageState
    extends ConsumerState<AceptarInvitacionGranjaPage>
    with SingleTickerProviderStateMixin {
  late TextEditingController _codigoController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isVerifying = false;
  bool _isLoading = false;
  bool _success = false;
  String? _codigoError;

  // Datos de la invitación verificada
  String? _granjaNombre;
  String? _rolAsignado;
  RolGranja? _rol;
  String? _invitadoPor;
  String? _codigoVerificado;

  @override
  void initState() {
    super.initState();
    _codigoController = TextEditingController(text: widget.codigo ?? '');
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _formatearCodigo(String codigo) {
    return codigo.toUpperCase().trim();
  }

  void _showError(String message) {
    if (!mounted) return;
    AppSnackBar.error(context, message: message);
  }

  Future<void> _verificarCodigo() async {
    final codigo = _formatearCodigo(_codigoController.text);
    debugPrint('🔍 [AceptarInvitacionPage] _verificarCodigo iniciado');
    debugPrint('   └─ código: $codigo');

    if (codigo.isEmpty) {
      debugPrint('⚠️ [AceptarInvitacionPage] Código vacío');
      setState(() => _codigoError = S.of(context).farmEnterValidCode);
      return;
    }

    if (!codigo.contains('-') || codigo.length < 10) {
      debugPrint('⚠️ [AceptarInvitacionPage] Formato inválido');
      setState(() => _codigoError = S.of(context).farmInvalidCodeFormat);
      return;
    }

    setState(() {
      _isVerifying = true;
      _codigoError = null;
    });

    try {
      debugPrint('   ├─ Verificando invitación...');
      final invitacion = await ref.read(
        verificarInvitacionProvider(codigo).future,
      );

      if (!mounted) return;

      if (invitacion == null) {
        debugPrint('❌ [AceptarInvitacionPage] Invitación no encontrada');
        setState(() {
          _codigoError = S.of(context).farmCodeNotFound;
          _isVerifying = false;
        });
        return;
      }

      debugPrint('   ├─ Invitación encontrada:');
      debugPrint('   │  ├─ granja: ${invitacion.granjaNombre}');
      debugPrint('   │  ├─ rol: ${invitacion.rol.name}');
      debugPrint('   │  └─ esValida: ${invitacion.esValida}');

      if (!invitacion.esValida) {
        debugPrint('❌ [AceptarInvitacionPage] Invitación no válida');
        final msg = invitacion.usado
            ? S.of(context).farmCodeAlreadyUsed
            : S.of(context).farmCodeExpired;
        setState(() {
          _codigoError = msg;
          _isVerifying = false;
        });
        return;
      }

      debugPrint(
        '✅ [AceptarInvitacionPage] Invitación válida, mostrando confirmación',
      );
      setState(() {
        _granjaNombre = invitacion.granjaNombre;
        _rolAsignado = invitacion.rol.localizedDisplayName(S.of(context));
        _rol = invitacion.rol;
        _invitadoPor = invitacion.creadoPorNombre;
        _codigoVerificado = codigo;
        _isVerifying = false;
      });
    } on Exception catch (e) {
      debugPrint('❌ [AceptarInvitacionPage] Error: $e');
      setState(() {
        _codigoError = _parseError(e.toString());
        _isVerifying = false;
      });
    }
  }

  Future<void> _confirmarAceptacion() async {
    if (_codigoVerificado == null) return;

    debugPrint('✅ [AceptarInvitacionPage] _confirmarAceptacion iniciado');
    debugPrint('   ├─ código: $_codigoVerificado');
    debugPrint('   └─ granja: $_granjaNombre');

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('   ├─ Aceptando invitación...');
      await ref.read(
        aceptarInvitacionProvider(
          AceptarInvitacionParamsUI(codigo: _codigoVerificado!),
        ).future,
      );

      if (mounted) {
        debugPrint(
          '✅ [AceptarInvitacionPage] Invitación aceptada exitosamente!',
        );
        setState(() => _success = true);
      }
    } on Exception catch (e) {
      debugPrint('❌ [AceptarInvitacionPage] Error aceptando: $e');
      if (mounted) {
        _showError(_parseError(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _volverAIngresar() {
    setState(() {
      _granjaNombre = null;
      _rolAsignado = null;
      _rol = null;
      _invitadoPor = null;
      _codigoVerificado = null;
    });
  }

  String _parseError(String error) {
    final l = S.of(context);
    final msg = error.replaceAll('Exception: ', '');
    if (msg.contains('not found') || msg.contains('no encontrada')) {
      return l.farmCodeNotValidOrExpired;
    }
    if (msg.contains('expired') || msg.contains('expirado')) {
      return l.farmCodeHasExpiredLong;
    }
    if (msg.contains('used') || msg.contains('usado')) {
      return l.farmCodeAlreadyUsed;
    }
    if (msg.contains('autenticado')) {
      return l.farmMustLoginToAccept;
    }
    if (msg.contains('Ya eres miembro')) {
      return l.farmAlreadyMember;
    }
    return msg;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider);

    if (_success) {
      return _buildSuccessView(theme);
    }

    if (_granjaNombre != null && _codigoVerificado != null) {
      return _buildConfirmacionView(theme, currentUser);
    }

    return _buildIngresoCodigoView(theme, currentUser);
  }

  // ============================================================================
  // VISTA 1: Ingreso de código
  // ============================================================================
  Widget _buildIngresoCodigoView(ThemeData theme, dynamic currentUser) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(S.of(context).farmJoinFarm),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      _buildHeader(theme),
                      const SizedBox(height: AppSpacing.xl),

                      // Campo de código
                      _buildCodigoInput(theme),
                    ],
                  ),
                ),
              ),
            ),

            // Botón fijo en la parte inferior
            _buildBottomButton(
              theme,
              onPressed: _isVerifying ? null : _verificarCodigo,
              isLoading: _isVerifying,
              label: S.of(context).farmVerifyCode,
              icon: Icons.search_rounded,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // VISTA 2: Confirmación
  // ============================================================================
  Widget _buildConfirmacionView(ThemeData theme, dynamic currentUser) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(S.of(context).farmConfirmInvitation),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _volverAIngresar,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Indicador de éxito centrado
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          size: 56,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        S.of(context).farmCodeValid,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Detalles de la invitación
                  Card(
                    elevation: 2,
                    shadowColor: theme.colorScheme.onSurface.withValues(
                      alpha: 0.12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.allMd,
                    ),
                    child: Column(
                      children: [
                        // Granja
                        _DetailRow(
                          label: S.of(context).farmGranjaLabel,
                          value: _granjaNombre ?? '',
                          color: theme.colorScheme.onSurface,
                        ),
                        Divider(
                          height: 1,
                          color: theme.colorScheme.outlineVariant,
                        ),
                        // Invitado por
                        _DetailRow(
                          label: S.of(context).farmInvitedBy,
                          value: _invitadoPor ?? '',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Sección de rol
                  Text(
                    S.of(context).farmWhatRoleYouWillHave,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Card del rol con permisos integrados
                  Card(
                    elevation: 2,
                    shadowColor: theme.colorScheme.onSurface.withValues(
                      alpha: 0.12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.allMd,
                      side: const BorderSide(color: AppColors.info, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _rolAsignado ?? '',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.info,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.info.withValues(alpha: 0.15),
                                  borderRadius: AppRadius.allMd,
                                ),
                                child: Text(
                                  S.of(context).farmAssigned,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: AppColors.info,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            _getRolDescription(
                              _rol ?? RolGranja.viewer,
                              context,
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.base),
                          Divider(
                            height: 1,
                            color: AppColors.info.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            S.of(context).farmPermissions,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ..._getPermisosRol(
                            _rol ?? RolGranja.viewer,
                            context,
                          ).map(
                            (p) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: AppColors.info,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      p,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),

          // Botones fijos en la parte inferior
          Container(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: _isLoading ? null : _confirmarAceptacion,
                      icon: _isLoading
                          ? const SizedBox(
                              width: AppSpacing.lg,
                              height: AppSpacing.lg,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : const Icon(Icons.check_circle_rounded),
                      label: Text(
                        _isLoading
                            ? S.of(context).commonJoining
                            : S.of(context).farmJoinTheFarm,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.allMd,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextButton(
                    onPressed: _isLoading ? null : _volverAIngresar,
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.secondary,
                    ),
                    child: Text(
                      S.of(context).farmUseAnotherCode,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // VISTA 3: Éxito
  // ============================================================================
  Widget _buildSuccessView(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icono de éxito animado
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      size: 72,
                      color: AppColors.success,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  S.of(context).farmWelcome,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  S.of(context).farmJoinedSuccessTo,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _granjaNombre ?? S.of(context).farmTheFarm,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.15),
                    borderRadius: AppRadius.allMd,
                  ),
                  child: Text(
                    S.of(context).farmAsRole(_rolAsignado ?? S.of(context).collaboratorRoleFallback),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.info,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: () => context.go(AppRoutes.granjas),
                    icon: const Icon(Icons.agriculture_rounded),
                    label: Text(
                      S.of(context).farmViewMyFarms,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.info,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.allMd,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: Text(S.of(context).commonGoToHome),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // WIDGETS AUXILIARES
  // ============================================================================

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          S.of(context).farmHaveInvitation,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          S.of(context).farmEnterSharedCode,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCodigoInput(ThemeData theme) {
    final hasError = _codigoError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).farmInvitationCode,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _codigoController,
          enabled: !_isVerifying,
          textCapitalization: TextCapitalization.characters,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontFamily: 'monospace',
            letterSpacing: 1.2,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: 'GRANJA-ABC123-XYZ789',
            hintStyle: TextStyle(
              fontFamily: 'monospace',
              letterSpacing: 1.2,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.normal,
            ),
            errorText: _codigoError,
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.error,
            ),
            suffixIcon: _codigoController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _codigoController.clear();
                      setState(() => _codigoError = null);
                    },
                    icon: const Icon(Icons.clear, size: 20),
                  )
                : null,
            filled: true,
            fillColor: theme.colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: hasError
                    ? AppColors.error
                    : theme.colorScheme.outline.withValues(alpha: 0.4),
                width: hasError ? 1.5 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: hasError ? AppColors.error : theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
          textInputAction: TextInputAction.done,
          onChanged: (_) {
            if (_codigoError != null) {
              setState(() => _codigoError = null);
            }
          },
          onSubmitted: _isVerifying ? null : (_) => _verificarCodigo(),
        ),
      ],
    );
  }

  Widget _buildBottomButton(
    ThemeData theme, {
    required VoidCallback? onPressed,
    required bool isLoading,
    required String label,
    required IconData icon,
  }) {
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
          child: FilledButton.icon(
            onPressed: onPressed,
            icon: isLoading
                ? const SizedBox(
                    width: AppSpacing.lg,
                    height: AppSpacing.lg,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : Icon(icon),
            label: Text(
              isLoading ? S.of(context).commonVerifying : label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.info,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
            ),
          ),
        ),
      ),
    );
  }

  List<String> _getPermisosRol(RolGranja rol, BuildContext context) {
    final l = S.of(context);
    return switch (rol) {
      RolGranja.owner => [
        l.farmPermFullControl,
        l.farmPermFullManagement,
        l.farmPermDeleteFarm,
      ],
      RolGranja.admin => [
        l.farmPermEditData,
        l.farmPermInviteUsers,
        l.farmPermManageCollaborators,
      ],
      RolGranja.manager => [
        l.farmPermEditData,
        l.farmPermInviteUsers,
        l.farmPermViewRecords,
      ],
      RolGranja.operator => [
        l.farmPermCreateRecords,
        l.farmPermViewData,
        l.farmPermRegisterTasks,
      ],
      RolGranja.viewer => [
        l.farmPermViewData,
        l.farmPermViewStats,
        l.farmPermReadOnly,
      ],
    };
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
}

// ============================================================================
// WIDGETS AUXILIARES PRIVADOS
// ============================================================================

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
