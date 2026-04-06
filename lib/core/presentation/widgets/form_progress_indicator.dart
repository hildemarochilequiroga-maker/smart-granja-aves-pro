/// Widget indicador de progreso visual para formularios multi-step
///
/// Muestra los pasos del formulario con estado visual (completado, actual, pendiente)
library;

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Información de un paso del formulario
class FormStepInfo {
  const FormStepInfo({required this.label, this.icon, this.description});

  /// Etiqueta del paso
  final String label;

  /// Icono opcional del paso
  final IconData? icon;

  /// Descripción opcional del paso
  final String? description;
}

/// Widget que muestra un indicador de progreso horizontal para formularios multi-step
class FormProgressIndicator extends StatelessWidget {
  const FormProgressIndicator({
    super.key,
    required this.currentStep,
    required this.steps,
    this.onStepTapped,
  });

  /// Paso actual (0-indexed)
  final int currentStep;

  /// Lista de pasos del formulario
  final List<FormStepInfo> steps;

  /// Callback opcional al tocar un paso
  final ValueChanged<int>? onStepTapped;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Conector entre pasos
            final stepIndex = index ~/ 2;
            final isCompleted = stepIndex < currentStep;
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(top: 15, left: 4, right: 4),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.primary
                      : theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          }

          // Paso
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < currentStep;
          final isCurrent = stepIndex == currentStep;
          final step = steps[stepIndex];

          return GestureDetector(
            onTap: onStepTapped != null ? () => onStepTapped!(stepIndex) : null,
            behavior: HitTestBehavior.opaque,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? AppColors.primary
                          : isCurrent
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : theme.colorScheme.surfaceContainerHighest,
                      border: isCurrent
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 18,
                              color: AppColors.onPrimary,
                            )
                          : Text(
                              '${stepIndex + 1}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isCurrent
                                    ? AppColors.primaryDark
                                    : theme.colorScheme.onSurfaceVariant,
                                fontWeight: isCurrent
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                    ),
                  ),
                  AppSpacing.gapXxs,
                  Text(
                    step.label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isCurrent || isCompleted
                          ? AppColors.primaryDark
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isCurrent
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
