/// Campo de entrada de tags/etiquetas.
///
/// Permite agregar y eliminar etiquetas de texto,
/// útil para protocolos y áreas de acceso.
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../core/widgets/app_snackbar.dart';

/// Campo para entrada de tags.
class TagInputField extends StatefulWidget {
  const TagInputField({
    super.key,
    required this.tags,
    required this.onTagsChanged,
    this.hintText,
    this.icon,
    this.maxTags,
  });

  final List<String> tags;
  final ValueChanged<List<String>> onTagsChanged;
  final String? hintText;
  final IconData? icon;
  final int? maxTags;

  @override
  State<TagInputField> createState() => _TagInputFieldState();
}

class _TagInputFieldState extends State<TagInputField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isEmpty) return;
    if (widget.tags.contains(trimmedTag)) {
      AppSnackBar.warning(context, message: S.of(context).shedTagExists);
      return;
    }
    if (widget.maxTags != null && widget.tags.length >= widget.maxTags!) {
      AppSnackBar.warning(
        context,
        message: S.of(context).shedMaxTags(widget.maxTags!.toString()),
      );
      return;
    }

    final newTags = List<String>.from(widget.tags)..add(trimmedTag);
    widget.onTagsChanged(newTags);
    _controller.clear();
  }

  void _removeTag(int index) {
    final newTags = List<String>.from(widget.tags)..removeAt(index);
    widget.onTagsChanged(newTags);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Campo de texto
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: widget.hintText ?? S.of(context).shedAddTagHint,
            prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _addTag(_controller.text),
              color: theme.colorScheme.primary,
            ),
          ),
          onSubmitted: _addTag,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 12),

        // Lista de tags
        if (widget.tags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.tags.asMap().entries.map((entry) {
              final index = entry.key;
              final tag = entry.value;
              return Chip(
                label: Text(tag),
                onDeleted: () => _removeTag(index),
                deleteIcon: const Icon(Icons.close, size: 16),
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                side: BorderSide(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
                labelStyle: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              );
            }).toList(),
          )
        else
          Text(
            S.of(context).shedNoTags,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }
}
