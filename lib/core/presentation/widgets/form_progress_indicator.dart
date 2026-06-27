/// Widget indicador de progreso visual para formularios multi-step
///
/// Muestra los pasos del formulario como segmentos conectados tipo "pill":
/// los pasos completados y el actual se rellenan en azul sólido con texto
/// blanco; los pendientes quedan con borde gris y texto gris.
library;

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

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

/// Widget que muestra un indicador de progreso horizontal para formularios
/// multi-step con el estilo de segmentos pill conectados.
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

  /// Radio externo del contenedor pill.
  static const double _radius = 10;

  /// Alto de la barra de segmentos.
  static const double _height = 44;

  /// Azul índigo del diseño de referencia para los segmentos activos.
  static const Color _activeColor = Color(0xFF2E3192);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.colorScheme.surface,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: Container(
          height: _height,
          // Borde gris exterior (visible sobre todo en los segmentos pendientes).
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_radius),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Row(
            children: List.generate(steps.length, (index) {
              final isActive = index <= currentStep;
              final step = steps[index];
              final isFirst = index == 0;
              final isLast = index == steps.length - 1;

              return Expanded(
                child: GestureDetector(
                  onTap: onStepTapped != null
                      ? () => onStepTapped!(index)
                      : null,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isActive ? _activeColor : Colors.transparent,
                      // Divisor blanco delgado entre segmentos activos.
                      border: Border(
                        left: (!isFirst && isActive)
                            ? const BorderSide(
                                color: AppColors.white,
                                width: 1.5,
                              )
                            : BorderSide.none,
                      ),
                      borderRadius: BorderRadius.horizontal(
                        left: isFirst
                            ? const Radius.circular(_radius)
                            : Radius.zero,
                        right: isLast
                            ? const Radius.circular(_radius)
                            : Radius.zero,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        step.label,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: isActive
                              ? AppColors.white
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
