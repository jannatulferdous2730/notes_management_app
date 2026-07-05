import 'package:flutter/material.dart';

/// Shared motion constants — nothing in the app animates longer than [medium].
class AppMotion {
  const AppMotion._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 250);
  static const Curve curve = Curves.easeOutCubic;
}
