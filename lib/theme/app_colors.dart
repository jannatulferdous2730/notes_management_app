import 'package:flutter/material.dart';

/// Semantic color constants for the app.
/// Use these names in your theme — never raw hex in widget code.
class AppColors {
  const AppColors._();

  /// Brand seed — deep indigo-teal
  static const Color seed = Color(0xFF4F6AF5);

  /// Surface background
  static const Color surface = Color(0xFFF8F9FF);

  /// Card background
  static const Color cardSurface = Color(0xFFFFFFFF);

  /// Primary text
  static const Color textPrimary = Color(0xFF1A1D27);

  /// Secondary text / timestamps
  static const Color textSecondary = Color(0xFF6B7280);

  /// Subtle divider / border
  static const Color border = Color(0xFFE5E7EB);

  /// Floating Action Button label color
  static const Color fabForeground = Color(0xFFFFFFFF);

  /// Error / destructive actions
  static const Color error = Color(0xFFEF4444);
}
