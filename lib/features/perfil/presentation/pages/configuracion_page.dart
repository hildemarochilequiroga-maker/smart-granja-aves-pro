/// Página de configuración de la aplicación.
///
/// Permite gestionar:
/// - Tema de la aplicación
/// - Notificaciones
/// - Datos y almacenamiento
/// - Privacidad y seguridad
/// - Información de la app
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';

/// Página principal de configuración.
class ConfiguracionPage extends ConsumerStatefulWidget {
  const ConfiguracionPage({super.key});

  @override
  ConsumerState<ConfiguracionPage> createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends ConsumerState<ConfiguracionPage> {
  bool _notificacionesActivas = true;
  bool _sonidosActivos = true;
  bool _vibracionActiva = true;
  bool _modoOscuro = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l.settingsTitle),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Título: Apariencia
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              l.settingsAppearance,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          // Sección: Apariencia
          _buildSeccion(
            theme,
            children: [
              _buildSwitch(
                theme,
                titulo: l.settingsDarkMode,
                subtitulo: l.settingsDarkModeSubtitle,
                icono: Icons.dark_mode_outlined,
                iconColor: AppColors.deepPurple,
                valor: _modoOscuro,
                onChanged: (value) {
                  HapticFeedback.selectionClick();
                  setState(() => _modoOscuro = value);
                  _mostrarSnackBar(l.commonComingSoon);
                },
              ),
            ],
          ),
          AppSpacing.gapBase,

          // Título: Notificaciones
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              l.settingsNotifications,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          // Sección: Notificaciones
          _buildSeccion(
            theme,
            children: [
              _buildSwitch(
                theme,
                titulo: l.settingsPushNotifications,
                subtitulo: l.settingsPushSubtitle,
                icono: Icons.notifications_active_outlined,
                iconColor: AppColors.info,
                valor: _notificacionesActivas,
                onChanged: (value) {
                  HapticFeedback.selectionClick();
                  setState(() => _notificacionesActivas = value);
                },
              ),
              Divider(
                height: 1,
                indent: 56,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              _buildSwitch(
                theme,
                titulo: l.settingsSounds,
                subtitulo: l.settingsSoundsSubtitle,
                icono: Icons.volume_up_outlined,
                iconColor: AppColors.success,
                valor: _sonidosActivos,
                onChanged: _notificacionesActivas
                    ? (value) {
                        HapticFeedback.selectionClick();
                        setState(() => _sonidosActivos = value);
                      }
                    : null,
              ),
              Divider(
                height: 1,
                indent: 56,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              _buildSwitch(
                theme,
                titulo: l.settingsVibration,
                subtitulo: l.settingsVibrationSubtitle,
                icono: Icons.vibration,
                iconColor: AppColors.warning,
                valor: _vibracionActiva,
                onChanged: _notificacionesActivas
                    ? (value) {
                        HapticFeedback.selectionClick();
                        setState(() => _vibracionActiva = value);
                      }
                    : null,
              ),
              Divider(
                height: 1,
                indent: 56,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              _buildItem(
                theme,
                titulo: l.settingsConfigureAlerts,
                subtitulo: l.settingsConfigureAlertsSubtitle,
                icono: Icons.tune,
                iconColor: AppColors.teal,
                onTap: () => context.push(AppRoutes.notificacionesConfig),
              ),
            ],
          ),
          AppSpacing.gapBase,

          // Título: Datos y Almacenamiento
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              l.settingsDataStorage,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          // Sección: Datos
          _buildSeccion(
            theme,
            children: [
              _buildItem(
                theme,
                titulo: l.settingsClearCache,
                subtitulo: l.settingsClearCacheSubtitle,
                icono: Icons.cleaning_services_outlined,
                iconColor: AppColors.warning,
                onTap: () => _limpiarCache(theme),
              ),
            ],
          ),
          AppSpacing.gapBase,

          // Título: Seguridad
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              l.settingsSecurity,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          // Sección: Seguridad
          _buildSeccion(
            theme,
            children: [
              _buildItem(
                theme,
                titulo: l.settingsChangePassword,
                subtitulo: l.settingsChangePasswordSubtitle,
                icono: Icons.lock_outline,
                iconColor: AppColors.error,
                onTap: () => _cambiarContrasena(theme),
              ),
              Divider(
                height: 1,
                indent: 56,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              _buildItem(
                theme,
                titulo: l.settingsVerifyEmail,
                subtitulo: l.settingsVerifyEmailSubtitle,
                icono: Icons.mark_email_read_outlined,
                iconColor: AppColors.success,
                onTap: () => _verificarEmail(theme),
              ),
            ],
          ),
          AppSpacing.gapXl,

          // Eliminar cuenta
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: AppRadius.allMd,
              border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.settingsDangerZone,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.gapMd,
                Text(
                  l.settingsDeleteAccountWarning,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.gapMd,
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _eliminarCuenta(theme),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.allSm,
                      ),
                    ),
                    child: Text(l.settingsDeleteAccount),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSeccion(ThemeData theme, {required List<Widget> children}) {
    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSwitch(
    ThemeData theme, {
    required String titulo,
    required String subtitulo,
    required IconData icono,
    required bool valor,
    required ValueChanged<bool>? onChanged,
    Color? iconColor,
  }) {
    final enabled = onChanged != null;
    final color = iconColor ?? theme.colorScheme.primary;

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: InkWell(
        onTap: enabled ? () => onChanged(!valor) : null,
        borderRadius: AppRadius.allMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: AppRadius.allMd,
                ),
                child: Icon(icono, size: 20, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitulo,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: valor,
                onChanged: onChanged,
                activeTrackColor: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
    ThemeData theme, {
    required String titulo,
    required String subtitulo,
    required IconData icono,
    required VoidCallback onTap,
    bool showChevron = true,
    Color? iconColor,
  }) {
    final color = iconColor ?? theme.colorScheme.primary;
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: AppRadius.allMd,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: AppRadius.allMd,
              ),
              child: Icon(icono, size: 20, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitulo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (showChevron)
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _limpiarCache(ThemeData theme) async {
    final l = S.of(context);
    final confirmar = await showAppConfirmDialog(
      context: context,
      title: l.settingsClearCacheConfirm,
      message: l.settingsClearCacheMessage,
      type: AppDialogType.warning,
      confirmText: l.settingsClearCacheConfirmButton,
    );

    if (confirmar == true) {
      _mostrarSnackBar(l.settingsCacheClearedSuccess, esExito: true);
    }
  }

  Future<void> _cambiarContrasena(ThemeData theme) async {
    final l = S.of(context);
    final emailController = TextEditingController();

    try {
      final enviar = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
          title: Text(
            l.settingsChangePassword,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.settingsChangePasswordMessage,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapBase,
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: l.settingsYourEmail,
                  border: OutlineInputBorder(borderRadius: AppRadius.allMd),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.onSurfaceVariant,
              ),
              child: Text(l.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
              ),
              child: Text(l.settingsSendLink),
            ),
          ],
        ),
      );

      if (enviar == true) {
        _mostrarSnackBar(l.settingsResetLinkSent, esExito: true);
      }
    } finally {
      emailController.dispose();
    }
  }

  Future<void> _verificarEmail(ThemeData theme) async {
    final l = S.of(context);
    _mostrarSnackBar(l.settingsVerificationEmailSent, esExito: true);
  }

  Future<void> _eliminarCuenta(ThemeData theme) async {
    final l = S.of(context);
    final confirmar = await showAppConfirmDialog(
      context: context,
      title: l.settingsDeleteAccountConfirm,
      message: l.settingsDeleteAccountMessage,
      type: AppDialogType.danger,
    );

    if (confirmar == true) {
      _mostrarSnackBar(l.commonComingSoon);
    }
  }

  void _mostrarSnackBar(String mensaje, {bool esExito = false}) {
    if (esExito) {
      AppSnackBar.success(context, message: mensaje);
    } else {
      AppSnackBar.info(context, message: mensaje);
    }
  }
}
