/// Animated success overlay shown briefly after a successful save.
///
/// Displays a scaling green check icon with optional message. Provides
/// instant, satisfying visual feedback that replaces the awkward
/// "snackbar + 500ms delay before pop" pattern used in older forms.
library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_haptics.dart';

/// Lightweight overlay helper for successful saves.
class SaveSuccessOverlay {
  SaveSuccessOverlay._();

  /// Shows an animated success overlay over the current screen and
  /// completes after [duration]. Triggers a success haptic.
  ///
  /// Use this instead of [Future.delayed] + snackbar before navigation.
  /// Typical pattern:
  /// ```dart
  /// await SaveSuccessOverlay.show(context, message: 'Guardado');
  /// if (mounted) Navigator.of(context).pop(true);
  /// ```
  static Future<void> show(
    BuildContext context, {
    required String message,
    String? detail,
    Duration duration = const Duration(milliseconds: 900),
  }) async {
    if (!context.mounted) return;
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    unawaited(AppHaptics.success());

    final entry = OverlayEntry(
      builder: (_) =>
          _SaveSuccessOverlayWidget(message: message, detail: detail),
    );

    overlay.insert(entry);
    await Future<void>.delayed(duration);
    entry.remove();
  }
}

class _SaveSuccessOverlayWidget extends StatefulWidget {
  const _SaveSuccessOverlayWidget({required this.message, this.detail});

  final String message;
  final String? detail;

  @override
  State<_SaveSuccessOverlayWidget> createState() =>
      _SaveSuccessOverlayWidgetState();
}

class _SaveSuccessOverlayWidgetState extends State<_SaveSuccessOverlayWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned.fill(
      child: IgnorePointer(
        child: FadeTransition(
          opacity: _fade,
          child: ColoredBox(
            color: Colors.black.withValues(alpha: 0.25),
            child: Center(
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.6, end: 1).animate(_scale),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 24,
                  ),
                  constraints: const BoxConstraints(maxWidth: 320),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      if (widget.detail != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          widget.detail!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
