/// Página que muestra el código de invitación generado.
///
/// Segunda etapa del flujo de invitación:
/// Muestra el código con opción para compartir
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../domain/entities/invitacion_granja.dart';
import '../../domain/enums/rol_granja_enum.dart';

/// Página que muestra el código de invitación generado.
class CodigoInvitacionPage extends ConsumerStatefulWidget {
  const CodigoInvitacionPage({
    super.key,
    required this.invitacion,
    required this.granjaNombre,
    required this.rol,
  });

  final InvitacionGranja invitacion;
  final String granjaNombre;
  final RolGranja rol;

  @override
  ConsumerState<CodigoInvitacionPage> createState() =>
      _CodigoInvitacionPageState();
}

class _CodigoInvitacionPageState extends ConsumerState<CodigoInvitacionPage> {
  bool _copiado = false;

  @override
  void initState() {
    super.initState();
    debugPrint('📝 [CodigoInvitacionPage] initState');
    debugPrint('   ├─ código: ${widget.invitacion.codigo}');
    debugPrint('   ├─ granjaNombre: ${widget.granjaNombre}');
    debugPrint('   ├─ rol: ${widget.rol.name}');
    debugPrint('   └─ expira: ${widget.invitacion.fechaExpiracion}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          title: Text(widget.granjaNombre),
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _handleBack,
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
                    // Indicador de éxito
                    _buildSuccessIndicator(theme),
                    const SizedBox(height: AppSpacing.xl),

                    // Card del código
                    _buildCodigoCard(theme),
                    const SizedBox(height: 2),

                    // Generar nuevo código (debajo del código a la derecha)
                    _buildGenerarNuevoButton(theme),
                    const SizedBox(height: AppSpacing.xl),

                    // Título de sección
                    Text(
                      S.of(context).farmWhatRoleWillUserHave,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Rol seleccionado
                    _buildRolCard(theme),
                    const SizedBox(height: AppSpacing.lg),

                    // Validez
                    _buildValidez(theme),
                  ],
                ),
              ),
            ),

            // Botón compartir fijo abajo
            _buildBottomButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessIndicator(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: AppColors.success,
            size: 56,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          S.of(context).farmCodeGenerated,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildRolCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.onSurface.withValues(alpha: 0.12),
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
                    widget.rol.localizedDisplayName(S.of(context)),
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
                    S.of(context).commonSelected,
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
              _getRolDescription(widget.rol, context),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerarNuevoButton(ThemeData theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _generarNuevoCodigo,
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          S.of(context).farmGenerateNewCode,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCodigoCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.onSurface.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      child: InkWell(
        onTap: _copiarCodigo,
        borderRadius: AppRadius.allMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.invitacion.codigo,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    letterSpacing: 2,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _copiado
                    ? const Icon(
                        Icons.check_circle,
                        key: ValueKey('check'),
                        color: AppColors.success,
                        size: 22,
                      )
                    : Icon(
                        Icons.copy_rounded,
                        key: const ValueKey('copy'),
                        color: theme.colorScheme.onSurface,
                        size: 22,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValidez(ThemeData theme) {
    return Text(
      S
          .of(context)
          .commonValidUntil(_formatearFecha(widget.invitacion.fechaExpiracion)),
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildBottomButton(ThemeData theme) {
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
            onPressed: _compartirGeneral,
            icon: const Icon(Icons.share_rounded),
            label: Text(
              S.of(context).commonShare,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
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

  void _handleBack() {
    context.pop();
    context.pop();
  }

  void _copiarCodigo() {
    Clipboard.setData(ClipboardData(text: widget.invitacion.codigo));
    setState(() => _copiado = true);

    AppSnackBar.success(
      context,
      message: S.of(context).farmCodeCopied,
      duration: const Duration(seconds: 2),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _copiado = false);
    });
  }

  String _getMensajeInvitacion() {
    return S
        .of(context)
        .farmInvitationMessage(
          widget.granjaNombre,
          widget.invitacion.codigo,
          widget.rol.localizedDisplayName(S.of(context)),
          _formatearFecha(widget.invitacion.fechaExpiracion),
        );
  }

  Future<void> _compartirGeneral() async {
    await Share.share(
      _getMensajeInvitacion(),
      subject: S.of(context).farmInvitationSubject(widget.granjaNombre),
    );
  }

  void _generarNuevoCodigo() {
    context.pop();
  }

  String _formatearFecha(DateTime fecha) {
    final l = S.of(context);
    final meses = [
      l.monthJan,
      l.monthFeb,
      l.monthMar,
      l.monthApr,
      l.monthMay,
      l.monthJun,
      l.monthJul,
      l.monthAug,
      l.monthSep,
      l.monthOct,
      l.monthNov,
      l.monthDec,
    ];
    return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
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
