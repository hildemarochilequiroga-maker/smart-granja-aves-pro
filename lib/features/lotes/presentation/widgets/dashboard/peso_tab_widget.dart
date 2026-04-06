/// Widget para el tab de Peso en el dashboard del lote.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/lote.dart';
import '../../pages/historial_peso_page.dart';

/// Tab de Peso que muestra el historial completo.
class PesoTabWidget extends ConsumerWidget {
  const PesoTabWidget({super.key, required this.lote, this.pageKey});

  final Lote lote;
  final GlobalKey<HistorialPesoPageState>? pageKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HistorialPesoPage(key: pageKey, lote: lote);
  }
}
