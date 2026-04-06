/// Widget para el tab de Mortalidad en el dashboard del lote.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/lote.dart';
import '../../pages/historial_mortalidad_page.dart';

/// Tab de Mortalidad que muestra el historial completo.
class MortalidadTabWidget extends ConsumerWidget {
  const MortalidadTabWidget({super.key, required this.lote, this.pageKey});

  final Lote lote;
  final GlobalKey<HistorialMortalidadPageState>? pageKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HistorialMortalidadPage(key: pageKey, lote: lote);
  }
}
