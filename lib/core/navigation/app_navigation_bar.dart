/// Bottom Navigation Bar principal de la aplicacion.
///
/// Implementa un NavigationBar con 4 destinos principales:
/// - Inicio: Dashboard general
/// - Gestión: Granjas y Galpones
/// - Lotes: Lista de lotes activos
/// - Perfil: Configuración y opciones adicionales
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';

/// Destinos de la navegacion principal.
enum AppNavigationDestination {
  inicio(icon: Icons.home_outlined, selectedIcon: Icons.home),
  gestion(icon: Icons.folder_outlined, selectedIcon: Icons.folder),
  lotes(icon: Icons.layers_outlined, selectedIcon: Icons.layers),
  perfil(icon: Icons.person_outlined, selectedIcon: Icons.person);

  const AppNavigationDestination({
    required this.icon,
    required this.selectedIcon,
  });

  final IconData icon;
  final IconData selectedIcon;

  String label(BuildContext context) {
    final l = S.of(context);
    switch (this) {
      case AppNavigationDestination.inicio:
        return l.navHome;
      case AppNavigationDestination.gestion:
        return l.navManagement;
      case AppNavigationDestination.lotes:
        return l.navBatches;
      case AppNavigationDestination.perfil:
        return l.navProfile;
    }
  }
}

/// Bottom Navigation Bar principal con diseño moderno.
class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding > 0 ? 0 : 4, top: 4),
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: AppNavigationDestination.values.asMap().entries.map((
                entry,
              ) {
                final index = entry.key;
                final destination = entry.value;
                return _NavigationItem(
                  destination: destination,
                  isSelected: currentIndex == index,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onDestinationSelected(index);
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Item individual de navegación con diseño mejorado.
class _NavigationItem extends StatefulWidget {
  const _NavigationItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final AppNavigationDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<_NavigationItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Color negro oscuro para seleccionado, gris para no seleccionado
    final selectedColor = theme.colorScheme.onSurface;
    final unselectedColor = theme.colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          width: 64,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  widget.isSelected
                      ? widget.destination.selectedIcon
                      : widget.destination.icon,
                  key: ValueKey(widget.isSelected),
                  color: widget.isSelected ? selectedColor : unselectedColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: 2),
              // Label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: theme.textTheme.labelSmall!.copyWith(
                  fontSize: 12,
                  color: widget.isSelected ? selectedColor : unselectedColor,
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
                child: Text(
                  widget.destination.label(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
