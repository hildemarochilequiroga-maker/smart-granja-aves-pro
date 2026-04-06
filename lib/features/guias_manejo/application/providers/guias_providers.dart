import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../lotes/domain/entities/lote.dart';
import '../services/guias_calculator.dart';

/// Provider que calcula las guías de manejo para un lote dado.
final guiasLoteProvider = Provider.autoDispose.family<GuiaLoteResult, Lote>((
  ref,
  lote,
) {
  return GuiasCalculator.calcular(lote);
});
