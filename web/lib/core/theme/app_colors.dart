import 'package:flutter/material.dart';

/// Application color palette following the design system.
/// DO NOT create colors outside of this class.
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // ═══════════════════════════════════════════════════════════════
  // BRAND COLORS
  // ═══════════════════════════════════════════════════════════════

  /// Primary brand color - used for main actions, primary buttons
  static const Color primary = Color(0xFF2563EB);

  /// Primary light variant - used for hover states
  static const Color primaryLight = Color(0xFF3B82F6);

  /// Primary dark variant - used for pressed states
  static const Color primaryDark = Color(0xFF1D4ED8);

  /// Secondary accent color
  static const Color secondary = Color(0xFF7C3AED);

  /// Secondary light variant
  static const Color secondaryLight = Color(0xFF8B5CF6);

  /// Secondary dark variant
  static const Color secondaryDark = Color(0xFF6D28D9);

  // ═══════════════════════════════════════════════════════════════
  // NEUTRAL COLORS - BACKGROUNDS
  // ═══════════════════════════════════════════════════════════════

  /// Main background color for screens
  static const Color backgroundPrimary = Color(0xFFFFFFFF);

  /// Card background color
  static const Color backgroundSecondary = Color(0xFFF8FAFC);

  /// Disabled/muted background color
  static const Color backgroundTertiary = Color(0xFFF1F5F9);

  // ═══════════════════════════════════════════════════════════════
  // NEUTRAL COLORS - TEXT
  // ═══════════════════════════════════════════════════════════════

  /// Main text color
  static const Color textPrimary = Color(0xFF0F172A);

  /// Subtitle/caption text color
  static const Color textSecondary = Color(0xFF475569);

  /// Placeholder/disabled text color
  static const Color textTertiary = Color(0xFF94A3B8);

  /// Text on dark backgrounds
  static const Color textInverse = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════════════════════════════
  // NEUTRAL COLORS - BORDERS
  // ═══════════════════════════════════════════════════════════════

  /// Default border color
  static const Color borderLight = Color(0xFFE2E8F0);

  /// Input border color
  static const Color borderMedium = Color(0xFFCBD5E1);

  /// Active border color
  static const Color borderDark = Color(0xFF94A3B8);

  // ═══════════════════════════════════════════════════════════════
  // SEMANTIC COLORS
  // ═══════════════════════════════════════════════════════════════

  /// Success state color
  static const Color success = Color(0xFF22C55E);

  /// Success background color
  static const Color successLight = Color(0xFFDCFCE7);

  /// Error state color
  static const Color error = Color(0xFFEF4444);

  /// Error background color
  static const Color errorLight = Color(0xFFFEE2E2);

  /// Warning state color
  static const Color warning = Color(0xFFF59E0B);

  /// Warning background color
  static const Color warningLight = Color(0xFFFEF3C7);

  /// Info state color
  static const Color info = Color(0xFF3B82F6);

  /// Info background color
  static const Color infoLight = Color(0xFFDBEAFE);
}
