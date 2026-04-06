/// Componentes auxiliares para detalle del lote.
///
/// Widget de error, lote no encontrado,
/// y otros componentes de estado.
library;

// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Vista cuando el lote no se encuentra
class LoteNoEncontrado extends StatelessWidget {
  const LoteNoEncontrado({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).batchError)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            AppSpacing.gapBase,
            Text(
              S.of(context).batchErrorDetail(S.of(context).batchError),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.outlineVariant,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              S.of(context).batchMayHaveBeenDeleted,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.outlineVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vista de error genérica
class LoteErrorView extends StatelessWidget {
  const LoteErrorView({super.key, required this.error, this.onRetry});

  final String error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).commonError)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error.withValues(alpha: 0.7),
            ),
            AppSpacing.gapBase,
            Text(
              S.of(context).batchLoadingBatch,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapSm,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                error,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.outlineVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (onRetry != null) ...[
              AppSpacing.gapXl,
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(S.of(context).batchRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Vista de carga
class LoteLoadingView extends StatelessWidget {
  const LoteLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

/// Diálogo para poner lote en cuarentena
class CuarentenaDialog extends StatefulWidget {
  const CuarentenaDialog({
    super.key,
    required this.loteNombre,
    required this.onConfirm,
  });

  final String loteNombre;
  final void Function(String motivo) onConfirm;

  @override
  State<CuarentenaDialog> createState() => _CuarentenaDialogState();
}

class _CuarentenaDialogState extends State<CuarentenaDialog> {
  final _motivoController = TextEditingController();

  @override
  void dispose() {
    _motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(S.of(context).batchPutInQuarantine),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).batchQuarantineConfirm(widget.loteNombre),
            style: theme.textTheme.bodyMedium,
          ),
          AppSpacing.gapBase,
          TextField(
            controller: _motivoController,
            decoration: InputDecoration(
              labelText: S.of(context).batchQuarantineReason,
              hintText: S.of(context).batchQuarantineReasonHint,
              border: OutlineInputBorder(borderRadius: AppRadius.allMd),
            ),
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(S.of(context).commonCancel),
        ),
        FilledButton(
          onPressed: () {
            if (_motivoController.text.trim().isNotEmpty) {
              widget.onConfirm(_motivoController.text.trim());
              Navigator.pop(context);
            }
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.warning,
            foregroundColor: AppColors.white,
          ),
          child: Text(S.of(context).commonConfirm),
        ),
      ],
    );
  }
}

/// Menú de opciones del lote
class LoteOptionsMenu extends StatelessWidget {
  const LoteOptionsMenu({
    super.key,
    required this.estaActivo,
    required this.onEditar,
    required this.onCuarentena,
    required this.onCerrar,
  });

  final bool estaActivo;
  final VoidCallback onEditar;
  final VoidCallback onCuarentena;
  final VoidCallback onCerrar;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'editar':
            onEditar();
            break;
          case 'cuarentena':
            onCuarentena();
            break;
          case 'cerrar':
            onCerrar();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'editar',
          child: ListTile(
            leading: const Icon(Icons.edit),
            title: Text(S.of(context).commonEdit),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        if (estaActivo) ...[
          PopupMenuItem(
            value: 'cuarentena',
            child: ListTile(
              leading: const Icon(
                Icons.warning_amber,
                color: AppColors.warning,
              ),
              title: Text(S.of(context).batchPutInQuarantine),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          PopupMenuItem(
            value: 'cerrar',
            child: ListTile(
              leading: const Icon(Icons.lock, color: AppColors.error),
              title: Text(S.of(context).batchCloseBatchTitle),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ],
    );
  }
}
