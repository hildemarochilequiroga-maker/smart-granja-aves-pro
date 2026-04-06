/// Widget para el tab de Producción en el dashboard del lote.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/lote.dart';
import '../../pages/historial_produccion_page.dart';

/// Tab de Producción que muestra el historial completo.
class ProduccionTabWidget extends ConsumerWidget {
  const ProduccionTabWidget({super.key, required this.lote, this.pageKey});

  final Lote lote;
  final GlobalKey<HistorialProduccionPageState>? pageKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HistorialProduccionPage(key: pageKey, lote: lote);
  }
}
