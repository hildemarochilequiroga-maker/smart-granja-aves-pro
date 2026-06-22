/// Centralized haptic feedback patterns.
///
/// Provides consistent tactile feedback across the app for common actions.
/// Use these instead of calling [HapticFeedback] directly to ensure a
/// uniform feel across the entire UX.
library;

import 'package:flutter/services.dart';

/// Helper class for consistent haptic feedback across the app.
class AppHaptics {
  AppHaptics._();

  /// Light tap — for primary actions, button presses, navigation.
  static Future<void> tap() async {
    await HapticFeedback.lightImpact();
  }

  /// Selection click — for picker changes, toggles, step changes.
  static Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  /// Medium impact — for confirmations, important actions.
  static Future<void> confirm() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy impact + vibration — for successful save / completion.
  static Future<void> success() async {
    await HapticFeedback.heavyImpact();
  }

  /// Vibration pattern for errors / validation failures.
  static Future<void> error() async {
    await HapticFeedback.vibrate();
  }

  /// Warning pattern — for high-impact warnings before destructive actions.
  static Future<void> warning() async {
    await HapticFeedback.heavyImpact();
  }
}
