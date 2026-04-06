import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_snackbar.dart';

/// Color oficial de WhatsApp
const _kWhatsAppGreen = Color(0xFF25D366);

/// Número de WhatsApp de contacto (con código de país)
const _kWhatsAppNumber = '51990746773';

/// FAB de WhatsApp con animación de pulso que abre un BottomSheet de contacto.
class WhatsAppContactFab extends StatefulWidget {
  const WhatsAppContactFab({super.key});

  @override
  State<WhatsAppContactFab> createState() => _WhatsAppContactFabState();
}

class _WhatsAppContactFabState extends State<WhatsAppContactFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _pulseAnimation.value, child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _kWhatsAppGreen.withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: FloatingActionButton(
          heroTag: 'whatsapp_contact',
          backgroundColor: _kWhatsAppGreen,
          foregroundColor: AppColors.white,
          elevation: 4,
          onPressed: () => _showContactSheet(context),
          child: const Icon(Icons.chat_rounded, size: 28),
        ),
      ),
    );
  }

  void _showContactSheet(BuildContext context) {
    // Detener la animación cuando se abre el sheet
    _pulseController.stop();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => const _ContactBottomSheet(),
    ).whenComplete(() {
      // Reanudar la animación al cerrar
      if (mounted) _pulseController.repeat(reverse: true);
    });
  }
}

// =============================================================================
// BOTTOM SHEET DE CONTACTO
// =============================================================================

class _ContactBottomSheet extends StatelessWidget {
  const _ContactBottomSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: AppRadius.allFull,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Ícono y título
              Container(
                padding: const EdgeInsets.all(AppSpacing.base),
                decoration: BoxDecoration(
                  color: _kWhatsAppGreen.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_rounded,
                  size: 36,
                  color: _kWhatsAppGreen,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                S.of(context).homeWhatsappHelp,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                S.of(context).homeWhatsappContact,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Opciones
              _ContactOption(
                icon: Icons.help_outline_rounded,
                title: S.of(context).homeWhatsappSupport,
                subtitle: S.of(context).homeWhatsappNeedHelp,
                message: S.of(context).whatsappMsgSupport,
                color: AppColors.info,
              ),
              const SizedBox(height: AppSpacing.sm),
              _ContactOption(
                icon: Icons.bug_report_outlined,
                title: S.of(context).homeWhatsappReportProblem,
                subtitle: S.of(context).homeWhatsappFoundBug,
                message: S.of(context).whatsappMsgBug,
                color: AppColors.error,
              ),
              const SizedBox(height: AppSpacing.sm),
              _ContactOption(
                icon: Icons.lightbulb_outline_rounded,
                title: S.of(context).homeWhatsappSuggestImprovement,
                subtitle: S.of(context).homeWhatsappHaveIdea,
                message: S.of(context).whatsappMsgSuggest,
                color: AppColors.warning,
              ),
              const SizedBox(height: AppSpacing.sm),
              _ContactOption(
                icon: Icons.handshake_outlined,
                title: S.of(context).homeWhatsappWorkTogether,
                subtitle: S.of(context).homeWhatsappCollaboration,
                message: S.of(context).whatsappMsgCollab,
                color: AppColors.tertiary,
              ),
              const SizedBox(height: AppSpacing.sm),
              _ContactOption(
                icon: Icons.shopping_cart_outlined,
                title: S.of(context).homeWhatsappPlansAndPricing,
                subtitle: S.of(context).homeWhatsappLicenseInfo,
                message: S.of(context).whatsappMsgPricing,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.sm),
              _ContactOption(
                icon: Icons.chat_bubble_outline_rounded,
                title: S.of(context).homeWhatsappOtherTopic,
                subtitle: S.of(context).homeWhatsappGeneralInquiry,
                message: S.of(context).whatsappMsgGeneral,
                color: AppColors.grey600,
              ),

              const SizedBox(height: AppSpacing.base),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// OPCIÓN DE CONTACTO INDIVIDUAL
// =============================================================================

class _ContactOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String message;
  final Color color;

  const _ContactOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadius.allMd,
      child: InkWell(
        borderRadius: AppRadius.allMd,
        onTap: () {
          Navigator.of(context).pop();
          _openWhatsApp(context, message);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: AppRadius.allSm,
                ),
                child: Icon(icon, size: 22, color: color),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openWhatsApp(BuildContext context, String message) async {
    final uri = Uri.parse(
      'https://wa.me/$_kWhatsAppNumber?text=${Uri.encodeComponent(message)}',
    );

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      if (!context.mounted) return;
      AppSnackBar.error(
        context,
        message: S.of(context).homeWhatsappCouldNotOpen,
      );
    }
  }
}
