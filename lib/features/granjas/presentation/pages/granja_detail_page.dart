/// Página de detalle de una granja específica.
///
/// Muestra información completa de la granja con diseño moderno:
/// - AppBar básico con acciones
/// - Secciones organizadas con cards
/// - Navegación intuitiva a galpones
/// - Acciones rápidas accesibles
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/application.dart';
import '../../domain/entities/granja.dart';
import '../widgets/granja_form_widgets.dart';
import '../widgets/granja_detail/granja_detail.dart';

/// Página de detalle de granja.
class GranjaDetailPage extends ConsumerWidget {
  const GranjaDetailPage({required this.granjaId, super.key});

  final String granjaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final granjaAsync = ref.watch(granjaByIdProvider(granjaId));

    return granjaAsync.when(
      data: (granja) {
        if (granja == null) {
          return _buildNotFoundView(context, theme);
        }
        return _GranjaDetailView(granja: granja);
      },
      loading: () => Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(S.of(context).commonError)),
        body: GranjaErrorWidget(
          mensaje: error.toString(),
          onReintentar: () => ref.invalidate(granjaByIdProvider(granjaId)),
        ),
      ),
    );
  }

  Widget _buildNotFoundView(BuildContext context, ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: Text(S.of(context).farmNotFound)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: AppSpacing.base),
            Text(S.of(context).farmNotFound, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: () => context.go(AppRoutes.granjas),
                icon: const Icon(Icons.arrow_back),
                label: Text(S.of(context).commonBack),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vista principal del detalle de granja.
class _GranjaDetailView extends ConsumerWidget {
  const _GranjaDetailView({required this.granja});

  final Granja granja;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = S.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l.commonDetails),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () =>
                context.push(AppRoutes.granjaEditarById(granja.id)),
            tooltip: l.farmEditTooltip,
          ),
          _buildMenuButton(context, ref, theme),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con nombre y estado
            GranjaHeader(granja: granja),

            const SizedBox(height: AppSpacing.xl),

            // Título Información General
            GranjaSectionTitle(title: l.farmGeneralInfo),
            const SizedBox(height: AppSpacing.md),

            // Información General
            GranjaInformacionGeneral(granja: granja),

            // Título Notas (si existen)
            if (granja.notas != null && granja.notas!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              GranjaSectionTitle(title: l.farmNotes),
              const SizedBox(height: AppSpacing.md),
              GranjaNotasSection(granja: granja),
            ],

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurfaceVariant),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
      color: theme.colorScheme.surface,
      elevation: 3,
      offset: const Offset(0, 40),
      tooltip: S.of(context).commonMoreOptions,
      onSelected: (value) =>
          GranjaDetailHandlers.handleMenuAction(context, ref, granja, value),
      itemBuilder: (context) => _buildMenuItems(context, theme),
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems(
    BuildContext context,
    ThemeData theme,
  ) {
    final l = S.of(context);
    return [
      PopupMenuItem(
        value: 'cambiar_estado',
        height: 44,
        child: Text(
          l.commonChangeStatus,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const PopupMenuDivider(height: 8),
      PopupMenuItem(
        value: 'delete',
        height: 44,
        child: Text(
          l.commonDelete,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ];
  }
}
