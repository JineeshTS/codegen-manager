/// Application border radius constants following the design system.
/// DO NOT use arbitrary radius values.
class AppRadius {
  AppRadius._(); // Private constructor to prevent instantiation

  // ═══════════════════════════════════════════════════════════════
  // RADIUS SCALE
  // ═══════════════════════════════════════════════════════════════

  /// Small radius (4px) - Tags, badges
  static const double radiusSmall = 4.0;

  /// Medium radius (8px) - Buttons, inputs
  static const double radiusMedium = 8.0;

  /// Large radius (12px) - Cards
  static const double radiusLarge = 12.0;

  /// Extra large radius (16px) - Modals, bottom sheets
  static const double radiusXLarge = 16.0;

  /// Round radius (999px) - Circular elements (avatars, pills)
  static const double radiusRound = 999.0;
}
