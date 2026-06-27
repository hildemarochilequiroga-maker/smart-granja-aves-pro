/// Shell principal de la aplicación con Bottom Navigation Bar.
///
/// Envuelve las páginas principales y proporciona navegación
/// persistente entre las secciones de la app.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_exit_confirm_sheet.dart';
import '../../l10n/app_localizations.dart';
import 'app_navigation_bar.dart';

/// Provider para el índice actual de navegación.
final navigationIndexProvider = StateProvider<int>((ref) => 0);

/// Shell principal con Bottom Navigation Bar.
///
/// Implementa [StatefulShellRoute.indexedStack] para mantener
/// el estado de cada branch de navegación.
///
/// Maneja el botón "atrás" del sistema:
/// - Si no estamos en el primer tab → volvemos al primer tab.
/// - Si estamos en el primer tab → al presionar atrás se avisa al usuario; si
///   vuelve a presionar atrás dentro de 2 segundos se muestra un bottom sheet
///   que confirma la salida de la app.
class MainShellPage extends ConsumerStatefulWidget {
  const MainShellPage({super.key, required this.navigationShell});

  /// Shell de navegación proporcionado por GoRouter.
  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends ConsumerState<MainShellPage> {
  /// Momento del último "atrás" presionado estando en el primer tab.
  DateTime? _lastBackPress;

  /// Ventana de tiempo para considerar un "doble atrás".
  static const _backWindow = Duration(seconds: 2);

  @override
  Widget build(BuildContext context) {
    final shell = widget.navigationShell;

    return PopScope(
      // Nunca dejamos que el sistema cierre la app directamente: lo manejamos
      // nosotros para volver al primer tab o pedir confirmación.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        body: shell,
        bottomNavigationBar: AppNavigationBar(
          currentIndex: shell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
        ),
      ),
    );
  }

  Future<void> _handleBack() async {
    final shell = widget.navigationShell;

    // Si no estamos en el primer tab, volvemos a él en lugar de salir.
    if (shell.currentIndex != 0) {
      ref.read(navigationIndexProvider.notifier).state = 0;
      shell.goBranch(0, initialLocation: false);
      _lastBackPress = null;
      return;
    }

    // Estamos en el primer tab: lógica de doble "atrás".
    final now = DateTime.now();
    final isSecondPress =
        _lastBackPress != null &&
        now.difference(_lastBackPress!) <= _backWindow;

    if (!isSecondPress) {
      // Primer "atrás": avisamos y esperamos un segundo press.
      _lastBackPress = now;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(S.of(context).appExitPressAgain),
            duration: _backWindow,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    // Segundo "atrás" dentro de la ventana: confirmamos salida.
    _lastBackPress = null;
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();

    final shouldExit = await showAppExitConfirmSheet(context);
    if (shouldExit) {
      // Cierra la app de forma controlada.
      await SystemNavigator.pop();
    }
  }

  /// Navega al branch seleccionado.
  void _onDestinationSelected(int index) {
    // Actualizar el provider para tracking
    ref.read(navigationIndexProvider.notifier).state = index;

    // Navegar al branch usando GoRouter
    widget.navigationShell.goBranch(
      index,
      // Si se toca el mismo tab, ir a la raíz de ese branch
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
