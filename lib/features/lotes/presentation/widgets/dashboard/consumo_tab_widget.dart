/// Widget para el tab de Consumo en el dashboard del lote.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/lote.dart';
import '../../pages/historial_consumo_page.dart';

/// Tab de Consumo que muestra el historial completo.
class ConsumoTabWidget extends ConsumerWidget {
  const ConsumoTabWidget({super.key, required this.lote, this.pageKey});

  final Lote lote;
  final GlobalKey<HistorialConsumoPageState>? pageKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HistorialConsumoPage(key: pageKey, lote: lote);
  }
}
