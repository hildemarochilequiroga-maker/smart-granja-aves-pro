/// Tabla reutilizable para mostrar datos semanales con resaltado de semana actual.
library;

import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class GuiaTablaFila {
  const GuiaTablaFila({
    required this.semana,
    required this.valores,
    this.esActual = false,
  });

  final int semana;
  final List<String> valores;
  final bool esActual;
}

class GuiaTablaWidget extends StatelessWidget {
  const GuiaTablaWidget({
    required this.columnas,
    required this.filas,
    required this.semanaActual,
    super.key,
  });

  final List<String> columnas;
  final List<GuiaTablaFila> filas;
  final int semanaActual;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 32,
          ),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            ),
            columnSpacing: 20,
            horizontalMargin: 12,
            dataRowMinHeight: 40,
            dataRowMaxHeight: 48,
            headingRowHeight: 44,
            headingTextStyle: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
            dividerThickness: 0.5,
            columns: columnas.map((c) => DataColumn(label: Text(c))).toList(),
            rows: filas.map((fila) {
              final isActual = fila.esActual;
              return DataRow(
                color: isActual
                    ? WidgetStateProperty.all(
                        theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.3,
                        ),
                      )
                    : null,
                cells: [
                  DataCell(
                    Text(
                      '${l.guiaSemanaCol} ${fila.semana}',
                      style: isActual
                          ? theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            )
                          : theme.textTheme.bodySmall,
                    ),
                  ),
                  ...fila.valores.map(
                    (v) => DataCell(
                      Text(
                        v,
                        style: isActual
                            ? theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              )
                            : theme.textTheme.bodySmall,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
