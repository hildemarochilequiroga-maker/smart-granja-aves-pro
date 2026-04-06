import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';

/// Color representativo del Veterinario Virtual IA
const _kVetColor = Color(0xFF6C63FF); // Violeta moderno

/// FAB del Veterinario Virtual IA con animación de pulso.
class VeterinarioVirtualFab extends StatefulWidget {
  const VeterinarioVirtualFab({super.key});

  @override
  State<VeterinarioVirtualFab> createState() => _VeterinarioVirtualFabState();
}

class _VeterinarioVirtualFabState extends State<VeterinarioVirtualFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _pulseAnimation.value, child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: _kVetColor.withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        height: 56,
        child: FloatingActionButton.extended(
          heroTag: 'veterinario_virtual',
          backgroundColor: _kVetColor,
          foregroundColor: AppColors.white,
          elevation: 4,
          onPressed: () => context.push(AppRoutes.veterinarioVirtual),
          label: const Text(
            'Veterinario Virtual',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
