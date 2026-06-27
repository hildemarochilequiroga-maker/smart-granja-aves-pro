/// Selectores de formularios de registro basados en bottom sheets.
///
/// Reemplazan los dropdowns y el `showDatePicker` de Material por bottom sheets
/// con estilo neutro (negro / onSurface, sin color primary):
/// - [RegistroSelectorField]: campo que abre un bottom sheet para elegir de una
///   lista de opciones (causa, método de pesaje, tipo de alimento…).
/// - [RegistroDateField] + [showRegistroDatePicker]: campo de fecha que abre un
///   bottom sheet con un selector de rueda (estilo Cupertino).
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/app_bottom_sheet.dart';
import '../../widgets/app_button.dart';
import 'form_text_scale.dart';

/// Estilo del label superior, consistente con AppFormField / RegistroFormField.
Widget _fieldLabel(BuildContext context, String label, bool required) {
  final theme = Theme.of(context);
  return Text(
    required ? '$label *' : label,
    style: theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
      fontWeight: FontWeight.w500,
    ),
  );
}

/// Contenedor "caja" tappable de un campo (mismo borde neutro en todos).
Widget _fieldBox({required BuildContext context, required Widget child}) {
  final theme = Theme.of(context);
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.base,
    ),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: AppRadius.allSm,
      border: Border.all(
        color: theme.colorScheme.outline.withValues(alpha: 0.4),
        width: 1,
      ),
    ),
    child: child,
  );
}

// ============================================================================
// SELECTOR FIELD (causa, método, tipo de alimento…)
// ============================================================================

/// Campo que abre un bottom sheet para elegir un valor de [options].
///
/// Genérico en [T]. El render de cada opción se define con los callbacks
/// [labelOf] (obligatorio), [subtitleOf], [colorOf] y [trailingOf].
class RegistroSelectorField<T> extends StatelessWidget {
  const RegistroSelectorField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onSelected,
    required this.labelOf,
    this.subtitleOf,
    this.colorOf,
    this.trailingOf,
    this.hint,
    this.required = false,
    this.sheetTitle,
  });

  final String label;
  final T? value;
  final List<T> options;
  final ValueChanged<T> onSelected;
  final String Function(T) labelOf;
  final String? Function(T)? subtitleOf;
  final Color? Function(T)? colorOf;
  final Widget? Function(T)? trailingOf;
  final String? hint;
  final bool required;
  final String? sheetTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = value;
    final color = selected != null ? colorOf?.call(selected) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _fieldLabel(context, label, required),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _openSheet(context),
          borderRadius: AppRadius.allSm,
          child: _fieldBox(
            context: context,
            child: Row(
              children: [
                if (color != null) ...[
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    selected != null ? labelOf(selected) : (hint ?? label),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: selected != null
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openSheet(BuildContext context) async {
    final result = await showAppBottomSheet<T>(
      context: context,
      title: sheetTitle ?? label,
      isScrollControlled: true,
      scrollable: true,
      builder: (context) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        children: [
          for (final option in options)
            AppSheetOptionTile(
              label: labelOf(option),
              subtitle: subtitleOf?.call(option),
              leading: colorOf?.call(option) != null
                  ? Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: colorOf!.call(option),
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
              trailing: trailingOf?.call(option),
              selected: option == value,
              onTap: () => Navigator.pop(context, option),
            ),
        ],
      ),
    );
    if (result != null) onSelected(result);
  }
}

// ============================================================================
// DATE FIELD + DATE BOTTOM SHEET
// ============================================================================

/// Campo de fecha que abre [showRegistroDatePicker] al tocarse.
class RegistroDateField extends StatelessWidget {
  const RegistroDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.required = false,
  });

  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _fieldLabel(context, label, required),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showRegistroDatePicker(
              context: context,
              initialDate: value,
              firstDate: firstDate,
              lastDate: lastDate,
            );
            if (picked != null) onChanged(picked);
          },
          borderRadius: AppRadius.allSm,
          child: _fieldBox(
            context: context,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(value),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Muestra un bottom sheet con un selector de fecha de rueda (estilo Cupertino),
/// con colores neutros. Devuelve la fecha elegida o `null` si se cancela.
Future<DateTime?> showRegistroDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  // Asegurar que initialDate quede dentro del rango.
  var initial = initialDate;
  if (initial.isBefore(firstDate)) initial = firstDate;
  if (initial.isAfter(lastDate)) initial = lastDate;

  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _RegistroDateSheet(
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    ),
  );
}

class _RegistroDateSheet extends StatefulWidget {
  const _RegistroDateSheet({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_RegistroDateSheet> createState() => _RegistroDateSheetState();
}

class _RegistroDateSheetState extends State<_RegistroDateSheet> {
  late DateTime _selected = widget.initialDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return FormTextScale(
      factor: 1.25,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header con título + fecha elegida
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Column(
                  children: [
                    Text(
                      S.of(context).batchSelectDate,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, d MMMM yyyy', 'es').format(_selected),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              // Rueda de fecha (Cupertino) en español, con texto neutro grande
              SizedBox(
                height: 210,
                child: Localizations.override(
                  context: context,
                  locale: const Locale('es'),
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      brightness: theme.brightness,
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle:
                            theme.textTheme.titleMedium?.copyWith(
                              color: onSurface,
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                            ) ??
                            TextStyle(color: onSurface, fontSize: 19),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: widget.initialDate,
                      minimumDate: widget.firstDate,
                      maximumDate: widget.lastDate,
                      onDateTimeChanged: (date) =>
                          setState(() => _selected = date),
                    ),
                  ),
                ),
              ),
              // Botones (negros, sin primary)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton.primary(
                        label: S.of(context).commonClose,
                        onPressed: () => Navigator.pop(context),
                        expanded: true,
                        backgroundColor: AppColors.error,
                        foregroundColor: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppButton.primary(
                        label: S.of(context).commonAccept,
                        onPressed: () => Navigator.pop(context, _selected),
                        expanded: true,
                        backgroundColor: onSurface,
                        foregroundColor: theme.colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
