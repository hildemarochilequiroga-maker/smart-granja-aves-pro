/// Página de detalle de un lote específico.
///
/// Muestra información completa del lote con diseño moderno:
/// - Hero image con información superpuesta
/// - Secciones organizadas con cards
/// - Acciones rápidas accesibles
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/sync_status_indicator.dart';
import '../../application/providers/providers.dart';
import '../../application/state/lote_state.dart';
import '../../domain/entities/lote.dart';
import '../widgets/lote_detail/lote_detail.dart';
import 'package:smartgranjaavespro/core/theme/app_radius.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Página de detalle de lote.
class LoteDetailPage extends ConsumerWidget {
  const LoteDetailPage({
    super.key,
    required this.granjaId,
    required this.loteId,
  });

  final String granjaId;
  final String loteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loteAsync = ref.watch(loteByIdProvider(loteId));

    // Escuchar cambios en el estado de operaciones
    ref.listen(loteNotifierProvider, (previous, next) {
      switch (next) {
        case LoteSuccess(:final mensaje):
          AppSnackBar.success(
            context,
            message: mensaje ?? S.of(context).batchOperationSuccess,
          );
        case LoteError(:final mensaje):
          AppSnackBar.error(context, message: mensaje);
        case LoteDeleted(:final mensaje):
          AppSnackBar.success(
            context,
            message: mensaje ?? S.of(context).batchDeletedSuccess,
          );
          context.pop();
        default:
          break;
      }
    });

    return loteAsync.when(
      data: (lote) {
        if (lote == null) {
          return _buildNotFoundView(context, theme);
        }
        return _LoteDetailView(lote: lote, granjaId: granjaId);
      },
      loading: () => Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(S.of(context).commonError)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text('${S.of(context).batchError}: ${error.toString()}'),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => ref.invalidate(loteByIdProvider(loteId)),
                icon: const Icon(Icons.refresh),
                label: Text(S.of(context).batchRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotFoundView(BuildContext context, ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: Text(S.of(context).batchNotFound)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              S.of(context).batchNotFoundMessage,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: () => context.pop(),
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

/// Vista principal del detalle de lote.
class _LoteDetailView extends ConsumerWidget {
  const _LoteDetailView({required this.lote, required this.granjaId});

  final Lote lote;
  final String granjaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(S.of(context).batchDetails),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          // Indicador de sincronización
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: SyncStatusBadge(),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(
              AppRoutes.loteEditarById(granjaId, lote.galponId, lote.id),
            ),
            tooltip: S.of(context).batchEditBatchTooltip,
          ),
          _buildMenuButton(context, ref, theme),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con nombre y estado
            LoteHeader(lote: lote),

            // Chip de alerta (si requiere atención)
            if (lote.requiereAtencion) ...[
              const SizedBox(height: 12),
              LoteAlertaChip(lote: lote),
            ],

            const SizedBox(height: 24),

            // Título Información General
            LoteSectionTitle(title: S.of(context).batchGeneralInfo),
            const SizedBox(height: 12),

            // Información General
            LoteInformacionGeneral(lote: lote),

            // Guías de Manejo
            const SizedBox(height: 16),
            _GuiasManejoButton(lote: lote, granjaId: granjaId),

            // Sección de notas (si existen)
            if (lote.observaciones != null &&
                lote.observaciones!.isNotEmpty) ...[
              const SizedBox(height: 24),
              LoteSectionTitle(title: S.of(context).batchNotes),
              const SizedBox(height: 12),
              LoteNotasSection(lote: lote),
            ],

            const SizedBox(height: 32),
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
      onSelected: (value) => LoteDetailHandlers.handleMenuAction(
        context,
        ref,
        lote,
        granjaId,
        value,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'cambiar_estado',
          height: 44,
          child: Text(
            S.of(context).batchBatchStatus,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const PopupMenuDivider(height: 8),
        PopupMenuItem(
          value: 'eliminar',
          height: 44,
          child: Text(
            S.of(context).commonDelete,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _GuiasManejoButton extends StatelessWidget {
  const _GuiasManejoButton({required this.lote, required this.granjaId});
  final Lote lote;
  final String granjaId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      color: theme.colorScheme.primary.withValues(alpha: 0.04),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(
          AppRoutes.loteGuiasManejoById(granjaId, lote.id),
          extra: lote,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.menu_book_rounded,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.guiasManejoBotonLabel,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.guiasManejoSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
