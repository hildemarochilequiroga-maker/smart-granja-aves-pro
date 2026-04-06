/// Página wrapper para editar venta.
///
/// Carga la venta existente por ID y luego muestra el formulario de edición.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../application/providers/ventas_provider.dart';
import 'registrar_venta_page.dart';

/// Página que carga una venta existente para editarla.
class EditarVentaPage extends ConsumerWidget {
  const EditarVentaPage({
    required this.ventaId,
    required this.granjaId,
    this.loteId,
    super.key,
  });

  final String ventaId;
  final String granjaId;
  final String? loteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final ventaAsync = ref.watch(ventaProductoPorIdProvider(ventaId));

    return ventaAsync.when(
      data: (venta) {
        if (venta == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l.ventaEditTitle)),
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
                  Text(l.ventaNotFound, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l.commonBack),
                  ),
                ],
              ),
            ),
          );
        }

        return RegistrarVentaPage(
          granjaId: venta.granjaId,
          loteId: venta.loteId,
          ventaExistente: venta,
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l.ventaEditTitle)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(l.ventaEditTitle)),
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
              Text(l.ventaLoadError, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.commonBack),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
