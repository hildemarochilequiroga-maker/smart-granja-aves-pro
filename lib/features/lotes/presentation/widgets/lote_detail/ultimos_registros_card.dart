/// Card de últimos registros del lote.
///
/// Widget modular que muestra los registros más
/// recientes de actividad del lote.
library;

// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_radius.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../application/providers/registro_providers.dart';

/// Card que muestra los últimos registros del lote
class UltimosRegistrosCard extends ConsumerWidget {
  const UltimosRegistrosCard({
    super.key,
    required this.loteId,
    required this.granjaId,
  });

  final String loteId;
  final String granjaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final registrosAsync = ref.watch(ultimosRegistrosProvider(loteId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).batchLatestRecords,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(
                    AppRoutes.loteDashboardById(granjaId, loteId),
                  ),
                  child: Text(S.of(context).batchViewRecords),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            registrosAsync.when(
              data: (registros) {
                if (registros.isEmpty) {
                  return _EmptyRegistrosView();
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: registros.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final registro = registros[index];
                    return RegistroTile(registro: registro);
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.base),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.all(AppSpacing.base),
                child: Text(
                  S.of(context).batchError,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyRegistrosView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            S.of(context).batchNoRecentRecords,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.outlineVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            S.of(context).batchRecordsWillAppear,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.outlineVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tile individual de registro
class RegistroTile extends StatelessWidget {
  const RegistroTile({super.key, required this.registro});

  final RegistroReciente registro;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = Formatters.fechaDDMMHHmm;
    final color = registro.color ?? registro.tipo.color;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: AppRadius.allSm,
        ),
        child: Icon(registro.tipo.icono, color: color, size: 20),
      ),
      title: Text(
        registro.tipo.localizedDisplayName(S.of(context)),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        registro.descripcion,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            registro.valor,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            dateFormat.format(registro.fecha),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
