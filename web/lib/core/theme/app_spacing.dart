/// Application spacing constants following the design system.
/// All spacing values are multiples of 4.
/// DO NOT use arbitrary spacing values.
class AppSpacing {
  AppSpacing._(); // Private constructor to prevent instantiation

  // ═══════════════════════════════════════════════════════════════
  // BASE UNIT
  // ═══════════════════════════════════════════════════════════════

  /// Base spacing unit - all spacing is a multiple of this
  static const double spacingUnit = 4.0;

  // ═══════════════════════════════════════════════════════════════
  // SPACING SCALE
  // ═══════════════════════════════════════════════════════════════

  /// Micro spacing (2px)
  static const double spacing2 = 2.0;

  /// Extra small spacing (4px)
  static const double spacing4 = 4.0;

  /// Small spacing (8px)
  static const double spacing8 = 8.0;

  /// Small-medium spacing (12px)
  static const double spacing12 = 12.0;

  /// Medium spacing (16px) - DEFAULT
  static const double spacing16 = 16.0;

  /// Medium-large spacing (20px)
  static const double spacing20 = 20.0;

  /// Large spacing (24px)
  static const double spacing24 = 24.0;

  /// Extra large spacing (32px)
  static const double spacing32 = 32.0;

  /// 2X Extra large spacing (40px)
  static const double spacing40 = 40.0;

  /// 3X Extra large spacing (48px)
  static const double spacing48 = 48.0;

  /// Section spacing (64px)
  static const double spacing64 = 64.0;
}
