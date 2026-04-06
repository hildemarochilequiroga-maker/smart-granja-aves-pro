/// Página de perfil y configuración.
///
/// Contiene:
/// - Información del usuario
/// - Colaboración (invitaciones)
/// - Configuración
/// - Ayuda y soporte
/// - Cerrar sesión
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/currency_provider.dart';
import '../../../../core/config/locale_provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../../granjas/domain/entities/granja.dart';
import '../widgets/widgets.dart';

/// Página de perfil con menú de opciones.
class PerfilPage extends ConsumerWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final usuario = ref.watch(currentUserProvider);
    final l = S.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          l.profileMyAccount,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del perfil
            PerfilHeaderCard(
              nombreCompleto: usuario?.nombreCompleto ?? l.profileUser,
              email: usuario?.email ?? '',
              fotoUrl: usuario?.fotoUrl,
              onEditarPerfil: () {
                context.push(AppRoutes.editarPerfil);
              },
            ),
            AppSpacing.gapXl,

            // Sección: Colaboración
            MenuSection(
              title: l.profileCollaboration,
              items: [
                MenuItem(
                  icon: Icons.person_add_alt_1,
                  label: l.profileInviteToFarm,
                  iconColor: AppColors.teal,
                  subtitle: l.profileShareAccess,
                  onTap: () => _seleccionarGranjaParaInvitar(context, ref),
                ),
                MenuItem(
                  icon: Icons.card_giftcard,
                  label: l.profileAcceptInvitation,
                  iconColor: AppColors.purple,
                  subtitle: l.profileJoinFarm,
                  onTap: () => context.push(AppRoutes.aceptarInvitacion),
                ),
                MenuItem(
                  icon: Icons.group,
                  label: l.profileManageCollaborators,
                  iconColor: AppColors.indigo,
                  subtitle: l.profileViewManageAccess,
                  onTap: () =>
                      _seleccionarGranjaParaColaboradores(context, ref),
                ),
              ],
            ),
            AppSpacing.gapBase,

            // Sección: Configuración
            MenuSection(
              title: l.profileSettings,
              items: [
                MenuItem(
                  icon: Icons.language,
                  label: l.profileLanguage,
                  iconColor: AppColors.info,
                  subtitle: ref
                      .watch(localeProvider.notifier)
                      .currentLanguageName,
                  onTap: () => _mostrarSelectorIdioma(context, ref),
                ),
                MenuItem(
                  icon: Icons.attach_money,
                  label: l.profileCurrency,
                  iconColor: AppColors.success,
                  subtitle: ref.watch(currencyProvider).displayName,
                  onTap: () => _mostrarSelectorMoneda(context, ref),
                ),
                MenuItem(
                  icon: Icons.notifications_outlined,
                  label: l.profileNotifications,
                  iconColor: AppColors.amber,
                  subtitle: l.profileConfigureAlerts,
                  onTap: () => context.push(AppRoutes.notificacionesConfig),
                ),
                MenuItem(
                  icon: Icons.settings,
                  label: l.profileGeneralSettings,
                  iconColor: AppColors.grey600,
                  subtitle: l.profileAppPreferences,
                  onTap: () => context.push(AppRoutes.configuracion),
                ),
              ],
            ),
            AppSpacing.gapBase,

            // Sección: Ayuda
            MenuSection(
              title: l.profileHelpSupport,
              items: [
                MenuItem(
                  icon: Icons.help_outline,
                  label: l.profileHelpCenter,
                  iconColor: AppColors.info,
                  subtitle: l.profileFaqGuides,
                  onTap: () => _mostrarAyuda(context),
                ),
                MenuItem(
                  icon: Icons.feedback_outlined,
                  label: l.profileSendFeedback,
                  iconColor: AppColors.cyan,
                  subtitle: l.profileShareIdeas,
                  onTap: () => _mostrarEnviarSugerencia(context),
                ),
                MenuItem(
                  icon: Icons.privacy_tip_outlined,
                  label: l.authPrivacyPolicy,
                  iconColor: AppColors.warning,
                  onTap: () => context.push(AppRoutes.legalPrivacidad),
                ),
                MenuItem(
                  icon: Icons.description_outlined,
                  label: l.authTermsAndConditions,
                  iconColor: AppColors.info,
                  onTap: () => context.push(AppRoutes.legalTerminos),
                ),
                MenuItem(
                  icon: Icons.info_outline,
                  label: l.profileAbout,
                  iconColor: AppColors.grey500,
                  subtitle: l.profileAppInfo,
                  onTap: () => _mostrarAcercaDe(context),
                ),
              ],
            ),
            AppSpacing.gapXl,

            // Cerrar sesión
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _cerrarSesion(context, ref),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(
                    color: theme.colorScheme.error.withValues(alpha: 0.5),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.logout),
                label: Text(l.authSignOut),
              ),
            ),
            const SizedBox(height: 80), // Espacio para bottom nav
          ],
        ),
      ),
    );
  }

  void _seleccionarGranjaParaInvitar(BuildContext context, WidgetRef ref) {
    debugPrint('📨 [PerfilPage] _seleccionarGranjaParaInvitar');
    final l = S.of(context);
    _mostrarSelectorGranja(
      context,
      ref,
      titulo: l.profileInviteToFarm,
      subtitulo: l.profileSelectFarmToInvite,
      icono: Icons.person_add_alt_1,
      color: AppColors.teal,
      onGranjaSeleccionada: (granja) {
        debugPrint(
          '   └─ Granja seleccionada: ${granja.nombre} (${granja.id})',
        );
        context.push(
          AppRoutes.granjaInvitarById(granja.id),
          extra: {'granjaNombre': granja.nombre},
        );
      },
    );
  }

  void _seleccionarGranjaParaColaboradores(
    BuildContext context,
    WidgetRef ref,
  ) {
    debugPrint('👥 [PerfilPage] _seleccionarGranjaParaColaboradores');
    final l = S.of(context);
    _mostrarSelectorGranja(
      context,
      ref,
      titulo: l.profileManageCollaborators,
      subtitulo: l.profileSelectFarm,
      icono: Icons.group,
      color: AppColors.indigo,
      onGranjaSeleccionada: (granja) {
        debugPrint(
          '   └─ Granja seleccionada: ${granja.nombre} (${granja.id})',
        );
        context.push(
          AppRoutes.granjaColaboradoresById(granja.id),
          extra: {'granjaNombre': granja.nombre},
        );
      },
    );
  }

  void _mostrarSelectorIdioma(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentLocale = ref.read(localeProvider);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).profileLanguage,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapMd,
            ...LocaleNotifier.supportedLocales.map((locale) {
              final isSelected =
                  locale.languageCode == currentLocale.languageCode;
              final name = switch (locale.languageCode) {
                'es' => 'Español',
                'en' => 'English',
                'pt' => 'Português',
                _ => locale.languageCode,
              };
              final flag = switch (locale.languageCode) {
                'es' => '🇪🇸',
                'en' => '🇺🇸',
                'pt' => '🇧🇷',
                _ => '🏳️',
              };
              return ListTile(
                leading: Text(flag, style: const TextStyle(fontSize: 24)),
                title: Text(
                  name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                    : null,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(locale);
                  Navigator.pop(ctx);
                },
              );
            }),
            AppSpacing.gapMd,
          ],
        ),
      ),
    );
  }

  void _mostrarSelectorMoneda(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentCurrency = ref.read(currencyProvider);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).profileCurrency,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapMd,
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: AppCurrency.values.map((currency) {
                  final isSelected = currency == currentCurrency;
                  return ListTile(
                    leading: Text(
                      currency.flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      currency.displayName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.allSm,
                    ),
                    onTap: () {
                      ref.read(currencyProvider.notifier).setCurrency(currency);
                      Navigator.pop(ctx);
                    },
                  );
                }).toList(),
              ),
            ),
            AppSpacing.gapMd,
          ],
        ),
      ),
    );
  }

  void _mostrarSelectorGranja(
    BuildContext context,
    WidgetRef ref, {
    required String titulo,
    required String subtitulo,
    required IconData icono,
    required Color color,
    required void Function(Granja granja) onGranjaSeleccionada,
  }) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final granjasAsync = ref.read(granjasStreamProvider);

    granjasAsync.when(
      data: (granjas) {
        if (granjas.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.profileNoFarmsMessage),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: l.profileCreate,
                onPressed: () => context.push(AppRoutes.granjaCrear),
              ),
            ),
          );
          return;
        }

        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (ctx) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.gapXxs,
                Text(
                  subtitulo,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.gapBase,
                Divider(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                  height: 1,
                ),
                AppSpacing.gapMd,
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.4,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: granjas.length,
                    itemBuilder: (context, index) {
                      final granja = granjas[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Card(
                          elevation: 2,
                          shadowColor: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.allMd,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(ctx);
                              onGranjaSeleccionada(granja);
                            },
                            borderRadius: AppRadius.allMd,
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          granja.nombre,
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    theme.colorScheme.onSurface,
                                              ),
                                        ),
                                        if (granja
                                            .direccion
                                            .direccionCompleta
                                            .isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            granja.direccion.direccionCompleta,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                AppSpacing.gapSm,
              ],
            ),
          ),
        );
      },
      loading: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.profileLoadingFarms),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      error: (error, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.commonErrorWithMessage(error.toString())),
            behavior: SnackBarBehavior.floating,
            backgroundColor: theme.colorScheme.error,
          ),
        );
      },
    );
  }

  Future<void> _cerrarSesion(BuildContext context, WidgetRef ref) async {
    final l = S.of(context);
    final confirmar = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
        title: Text(
          l.profileSignOutConfirm,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          l.profileSignOutMessage,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
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
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
            ),
            child: Text(l.authSignOut),
          ),
        ],
      ),
    );

    if (confirmar == true && context.mounted) {
      await ref.read(authProvider.notifier).cerrarSesion();

      // Invalidar providers con estado de granja/usuario para evitar datos stale
      ref.invalidate(granjaSeleccionadaProvider);

      if (context.mounted) {
        context.go(AppRoutes.authGate);
      }
    }
  }

  void _mostrarAyuda(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.profileHelpCenter,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            AppSpacing.gapXxs,
            Text(
              l.profileHelpQuestion,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.gapBase,
            Divider(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              height: 1,
            ),
            AppSpacing.gapMd,
            _buildAyudaItem(
              context,
              theme,
              icon: Icons.email_outlined,
              iconColor: AppColors.info,
              title: l.profileEmailSupport,
              subtitle: 'soporte@smartgranjaaves.com',
            ),
            AppSpacing.gapSm,
            _buildAyudaItem(
              context,
              theme,
              icon: Icons.help_outline,
              iconColor: AppColors.success,
              title: l.profileFaq,
              subtitle: l.profileFaqSubtitle,
            ),
            AppSpacing.gapSm,
            _buildAyudaItem(
              context,
              theme,
              icon: Icons.article_outlined,
              iconColor: AppColors.warning,
              title: l.profileUserManual,
              subtitle: l.profileUserManualSubtitle,
            ),
            AppSpacing.gapSm,
          ],
        ),
      ),
    );
  }

  Widget _buildAyudaItem(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.onSurface.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      child: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: AppRadius.allMd,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: AppRadius.allMd,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarEnviarSugerencia(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.profileSendFeedback,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            AppSpacing.gapXxs,
            Text(
              l.profileFeedbackQuestion,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.gapBase,
            Divider(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              height: 1,
            ),
            AppSpacing.gapMd,
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l.profileFeedbackHint,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.6,
                  ),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.allMd,
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.allMd,
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            AppSpacing.gapBase,
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.profileFeedbackThanks),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(l.profileSendFeedback),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarAcercaDe(BuildContext context) {
    final l = S.of(context);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo de la app
              ClipRRect(
                borderRadius: AppRadius.allLg,
                child: Builder(
                  builder: (context) {
                    final dpr = MediaQuery.devicePixelRatioOf(context);
                    return Image.asset(
                      AppAssets.logoIcon,
                      width: 80,
                      height: 80,
                      cacheWidth: (80 * dpr).round(),
                      cacheHeight: (80 * dpr).round(),
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.agriculture,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
              AppSpacing.gapBase,

              // Nombre de la app centrado
              Text(
                'Smart Granja Aves Pro',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapXxs,

              // Versión
              Text(
                l.profileVersionText('1.0.0'),
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppSpacing.gapLg,

              // Descripción
              Text(
                l.profileAppDescription,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapBase,

              // Copyright
              Text(
                l.profileCopyright,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapLg,

              // Botón cerrar
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.allMd,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(l.commonClose),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
