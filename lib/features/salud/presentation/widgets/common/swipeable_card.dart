/// Widget de acción al deslizar para tarjetas de lista
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Tipo de acción al deslizar
enum SwipeActionType { primary, danger }

/// Datos de una acción de swipe
class SwipeActionData {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onAction;

  const SwipeActionData({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onAction,
  });

  /// Crea una acción de cerrar/completar
  factory SwipeActionData.complete({
    required VoidCallback onAction,
    required String label,
  }) {
    return SwipeActionData(
      icon: Icons.check_circle_outline_rounded,
      label: label,
      backgroundColor: AppColors.success,
      foregroundColor: AppColors.white,
      onAction: onAction,
    );
  }

  /// Crea una acción de aplicar (para vacunaciones)
  factory SwipeActionData.apply({
    required VoidCallback onAction,
    required String label,
  }) {
    return SwipeActionData(
      icon: Icons.vaccines_rounded,
      label: label,
      backgroundColor: AppColors.success,
      foregroundColor: AppColors.white,
      onAction: onAction,
    );
  }

  /// Crea una acción de eliminar
  factory SwipeActionData.delete({
    required VoidCallback onAction,
    required String label,
  }) {
    return SwipeActionData(
      icon: Icons.delete_outline_rounded,
      label: label,
      backgroundColor: AppColors.error,
      foregroundColor: AppColors.white,
      onAction: onAction,
    );
  }
}

/// Widget que envuelve un child y le agrega acciones al deslizar
class SwipeableCard extends StatefulWidget {
  const SwipeableCard({
    super.key,
    required this.child,
    this.leadingAction,
    this.trailingAction,
    this.confirmDismiss = true,
  });

  /// El widget hijo a envolver
  final Widget child;

  /// Acción al deslizar hacia la derecha (start)
  final SwipeActionData? leadingAction;

  /// Acción al deslizar hacia la izquierda (end)
  final SwipeActionData? trailingAction;

  /// Si debe confirmar antes de ejecutar la acción
  final bool confirmDismiss;

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard> {
  double _dragExtent = 0.0;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    // Si no hay acciones, retornar el child directamente
    if (widget.leadingAction == null && widget.trailingAction == null) {
      return widget.child;
    }

    final theme = Theme.of(context);

    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: Stack(
        children: [
          // Background con acciones
          Positioned.fill(
            child: Row(
              children: [
                // Leading action (swipe right)
                if (widget.leadingAction != null)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.leadingAction!.backgroundColor,
                        borderRadius: AppRadius.allMd,
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 150),
                        opacity: _dragExtent > 0 ? 1.0 : 0.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.leadingAction!.icon,
                              color: widget.leadingAction!.foregroundColor,
                              size: 24,
                            ),
                            AppSpacing.hGapSm,
                            Text(
                              widget.leadingAction!.label,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: widget.leadingAction!.foregroundColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                // Trailing action (swipe left)
                if (widget.trailingAction != null)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.trailingAction!.backgroundColor,
                        borderRadius: AppRadius.allMd,
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 150),
                        opacity: _dragExtent < 0 ? 1.0 : 0.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.trailingAction!.label,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: widget.trailingAction!.foregroundColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AppSpacing.hGapSm,
                            Icon(
                              widget.trailingAction!.icon,
                              color: widget.trailingAction!.foregroundColor,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Foreground (card)
          RepaintBoundary(
            child: AnimatedContainer(
              duration: _isDragging
                  ? Duration.zero
                  : const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(_dragExtent, 0, 0),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;
    final newExtent = _dragExtent + delta;

    // Limitar el arrastre según las acciones disponibles
    if (widget.leadingAction == null && newExtent > 0) return;
    if (widget.trailingAction == null && newExtent < 0) return;

    // Limitar el arrastre máximo
    const maxExtent = 100.0;
    setState(() {
      _dragExtent = newExtent.clamp(-maxExtent, maxExtent);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    const threshold = 60.0;
    final velocity = details.primaryVelocity ?? 0;

    setState(() {
      _isDragging = false;
    });

    // Si el arrastre supera el umbral o la velocidad es alta, ejecutar acción
    if (_dragExtent > threshold || velocity > 500) {
      if (widget.leadingAction != null) {
        HapticFeedback.mediumImpact();
        widget.leadingAction!.onAction();
      }
    } else if (_dragExtent < -threshold || velocity < -500) {
      if (widget.trailingAction != null) {
        HapticFeedback.mediumImpact();
        widget.trailingAction!.onAction();
      }
    }

    // Resetear la posición
    setState(() {
      _dragExtent = 0;
    });
  }
}

/// Widget de hint que indica que se puede deslizar
class SwipeHint extends StatelessWidget {
  const SwipeHint({super.key, this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayText = text ?? S.of(context).commonSwipeActions;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.swipe_rounded,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          AppSpacing.hGapSm,
          Text(
            displayText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
