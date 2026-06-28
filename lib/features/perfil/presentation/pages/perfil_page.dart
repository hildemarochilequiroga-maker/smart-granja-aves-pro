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
import '../../../../core/presentation/widgets/form_text_scale.dart';
import '../../../../core/presentation/widgets/full_height_sheet.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../../granjas/domain/entities/granja.dart';
import '../../../granjas/presentation/pages/aceptar_invitacion_granja_page.dart';
import '../../../granjas/presentation/pages/gestionar_colaboradores_page.dart';
import '../../../granjas/presentation/pages/seleccionar_rol_invitacion_page.dart';
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
        title: FormTextScale(
          factor: 1.2,
          child: Text(
            l.profileMyAccount,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: FormTextScale(
        factor: 1.2,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del perfil
            PerfilHeaderCard(
              nombreCompleto: usuario?.nombreCompleto ?? l.profileUser,
              email: usuario?.email ?? '',
              fotoUrl: usuario?.fotoUrl,
              onEditarPerfil: () => mostrarEditarPerfilSheet(context),
            ),
            AppSpacing.gapMd,

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
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const AceptarInvitacionGranjaPage(),
                  ),
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
            AppSpacing.gapSm,

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
              ],
            ),
            AppSpacing.gapSm,

            // Sección: Ayuda
            MenuSection(
              title: l.profileHelpSupport,
              items: [
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
            AppSpacing.gapMd,

            // Cerrar sesión (sólido)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _cerrarSesion(context, ref),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.logout, size: 24),
                label: Text(l.authSignOut),
              ),
            ),
            const SizedBox(height: 32), // Espacio para bottom nav
          ],
          ),
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
        showFullHeightSheet<void>(
          context: context,
          child: SeleccionarRolInvitacionPage(
            granjaId: granja.id,
            granjaNombre: granja.nombre,
          ),
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
        showFullHeightSheet<void>(
          context: context,
          child: GestionarColaboradoresPage(
            granjaId: granja.id,
            granjaNombre: granja.nombre,
          ),
        );
      },
    );
  }

  void _mostrarSelectorIdioma(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(localeProvider);

    showAppBottomSheet(
      context: context,
      title: S.of(context).profileLanguage,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            return AppSheetOptionTile(
              leading: Text(flag, style: const TextStyle(fontSize: 24)),
              label: name,
              selected: isSelected,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(locale);
                Navigator.pop(ctx);
              },
            );
          }),
          AppSpacing.gapMd,
        ],
      ),
    );
  }

  void _mostrarSelectorMoneda(BuildContext context, WidgetRef ref) {
    final currentCurrency = ref.read(currencyProvider);

    showAppBottomSheet(
      context: context,
      title: S.of(context).profileCurrency,
      isScrollControlled: true,
      scrollable: true,
      builder: (ctx) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        children: AppCurrency.values.map((currency) {
          final isSelected = currency == currentCurrency;
          return AppSheetOptionTile(
            leading: Text(
              currency.flag,
              style: const TextStyle(fontSize: 24),
            ),
            label: currency.displayName,
            selected: isSelected,
            onTap: () {
              ref.read(currencyProvider.notifier).setCurrency(currency);
              Navigator.pop(ctx);
            },
          );
        }).toList(),
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
    final l = S.of(context);
    final granjasAsync = ref.read(granjasStreamProvider);

    granjasAsync.when(
      data: (granjas) {
        if (granjas.isEmpty) {
          AppSnackBar.info(
            context,
            message: l.profileNoFarmsMessage,
            actionLabel: l.profileCreate,
            onAction: () => context.push(AppRoutes.granjaCrear),
          );
          return;
        }

        showAppBottomSheet(
          context: context,
          title: titulo,
          subtitle: subtitulo,
          isScrollControlled: true,
          scrollable: true,
          builder: (ctx) => ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            itemCount: granjas.length,
            itemBuilder: (context, index) {
              final granja = granjas[index];
              return AppSheetOptionTile(
                label: granja.nombre,
                subtitle: granja.direccion.direccionCompleta.isNotEmpty
                    ? granja.direccion.direccionCompleta
                    : null,
                onTap: () {
                  Navigator.pop(ctx);
                  onGranjaSeleccionada(granja);
                },
              );
            },
          ),
        );
      },
      loading: () {
        AppSnackBar.info(
          context,
          message: l.profileLoadingFarms,
          duration: const Duration(seconds: 1),
        );
      },
      error: (error, _) {
        AppSnackBar.error(
          context,
          message: l.commonErrorWithMessage(error.toString()),
        );
      },
    );
  }

  Future<void> _cerrarSesion(BuildContext context, WidgetRef ref) async {
    final l = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final confirmar = await showAppBottomSheet<bool>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícono
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppColors.error,
                size: 32,
              ),
            ),
            AppSpacing.gapMd,
            Text(
              l.profileSignOutConfirm,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapXs,
            Text(
              l.profileSignOutMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapLg,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.onSurfaceVariant,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.allMd,
                      ),
                    ),
                    child: Text(l.commonCancel),
                  ),
                ),
                AppSpacing.hGapMd,
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.onError,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.allMd,
                      ),
                    ),
                    child: Text(l.authSignOut),
                  ),
                ),
              ],
            ),
          ],
        ),
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

  void _mostrarAcercaDe(BuildContext context) {
    final l = S.of(context);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
        child: FormTextScale(
          factor: 1.2,
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
                'Smart Granja Aves',
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
      ),
    );
  }
}
