/// Barra de búsqueda unificada con soporte de filtros
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_radius.dart';
import '../theme/app_shadow.dart';
import '../theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

/// Barra de búsqueda reutilizable que reemplaza las 4+ copias
/// distribuidas en lotes, granjas, galpones y salud.
///
/// Incluye:
/// - Campo de búsqueda con prefijo animado y sufijo de limpiar
/// - Fila horizontal de filtros opcionales (generados por [filterBuilder])
/// - Sombra sutil inferior
/// - Semántica de accesibilidad
///
/// ```dart
/// AppSearchBar(
///   controller: _searchCtrl,
///   searchQuery: _query,
///   hintText: 'Buscar por nombre, código...',
///   onSearchChanged: (q) => setState(() => _query = q),
///   onClearSearch: () { _searchCtrl.clear(); setState(() => _query = ''); },
///   filterBuilder: (theme) => _buildMyFilters(theme),
/// )
/// ```
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
    this.hintText = 'Buscar...',
    this.filterBuilder,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
  });

  /// Controlador del campo de texto
  final TextEditingController controller;

  /// Query actual (para animar el ícono de prefijo)
  final String searchQuery;

  /// Callback cuando el texto cambia
  final ValueChanged<String> onSearchChanged;

  /// Callback para limpiar la búsqueda
  final VoidCallback onClearSearch;

  /// Texto de placeholder
  final String hintText;

  /// Builder opcional para la fila de filtros debajo del campo
  final Widget Function(ThemeData theme)? filterBuilder;

  /// Focus node opcional
  final FocusNode? focusNode;

  /// Si el campo debe auto-enfocar
  final bool autofocus;

  /// Etiqueta de accesibilidad (por defecto usa [hintText])
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: AppShadow.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSearchField(context, theme),
          if (filterBuilder != null) ...[
            const SizedBox(height: AppSpacing.xs),
            filterBuilder!(theme),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.base,
        AppSpacing.sm,
        AppSpacing.base,
        0,
      ),
      child: Semantics(
        textField: true,
        label: semanticLabel ?? hintText,
        child: SizedBox(
          height: 48,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: autofocus,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              hintMaxLines: 1,
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest,
              prefixIcon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.search_rounded,
                  key: ValueKey(searchQuery.isNotEmpty),
                  color: searchQuery.isNotEmpty
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: searchQuery.isNotEmpty
                  ? Semantics(
                      button: true,
                      label: S.of(context).commonClearSearch,
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        color: theme.colorScheme.onSurfaceVariant,
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          onClearSearch();
                        },
                        tooltip: S.of(context).commonClearSearch,
                      ),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.allMd,
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.allMd,
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.allMd,
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            onChanged: onSearchChanged,
          ),
        ),
      ),
    );
  }
}
