/// Widget de estado de carga para la lista de costos
library;

import 'package:flutter/material.dart';
import '../../../../../core/widgets/skeleton_loading.dart';

/// Estado de carga con shimmer para la lista de costos
class CostosLoadingState extends StatelessWidget {
  const CostosLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListLoadingState(showResumen: true, itemCount: 5);
  }
}
