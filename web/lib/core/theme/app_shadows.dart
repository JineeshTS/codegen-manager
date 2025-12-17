import 'package:flutter/material.dart';

/// Application shadow styles following the design system.
/// DO NOT create custom shadow values.
class AppShadows {
  AppShadows._(); // Private constructor to prevent instantiation

  // ═══════════════════════════════════════════════════════════════
  // ELEVATION LEVELS
  // ═══════════════════════════════════════════════════════════════

  /// Small shadow - Cards, bottom navigation
  static List<BoxShadow> get shadowSmall => [
        const BoxShadow(
          color: Color(0x0A000000), // 4% opacity black
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ];

  /// Medium shadow - Dropdowns, floating buttons
  static List<BoxShadow> get shadowMedium => [
        const BoxShadow(
          color: Color(0x0F000000), // 6% opacity black
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ];

  /// Large shadow - Modals, dialogs
  static List<BoxShadow> get shadowLarge => [
        const BoxShadow(
          color: Color(0x14000000), // 8% opacity black
          blurRadius: 16,
          offset: Offset(0, 8),
        ),
      ];
}
