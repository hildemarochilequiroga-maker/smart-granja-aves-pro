/// Shell principal de la aplicación con Bottom Navigation Bar.
///
/// Envuelve las páginas principales y proporciona navegación
/// persistente entre las secciones de la app.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_navigation_bar.dart';

/// Provider para el índice actual de navegación.
final navigationIndexProvider = StateProvider<int>((ref) => 0);

/// Shell principal con Bottom Navigation Bar.
///
/// Implementa [StatefulShellRoute.indexedStack] para mantener
/// el estado de cada branch de navegación.
class MainShellPage extends ConsumerWidget {
  const MainShellPage({super.key, required this.navigationShell});

  /// Shell de navegación proporcionado por GoRouter.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onDestinationSelected(index, ref),
      ),
    );
  }

  /// Navega al branch seleccionado.
  void _onDestinationSelected(int index, WidgetRef ref) {
    // Actualizar el provider para tracking
    ref.read(navigationIndexProvider.notifier).state = index;

    // Navegar al branch usando GoRouter
    navigationShell.goBranch(
      index,
      // Si se toca el mismo tab, ir a la raíz de ese branch
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
