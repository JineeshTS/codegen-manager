import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Application typography styles following the design system.
/// DO NOT create custom TextStyles outside of this class.
class AppTextStyles {
  AppTextStyles._(); // Private constructor to prevent instantiation

  // ═══════════════════════════════════════════════════════════════
  // FONT FAMILY
  // ═══════════════════════════════════════════════════════════════

  static const String fontFamily = 'Inter';

  // ═══════════════════════════════════════════════════════════════
  // DISPLAY STYLES
  // ═══════════════════════════════════════════════════════════════

  /// Display Large - Hero text, splash screens (32px, Bold)
  static TextStyle get displayLarge => const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
        fontFamily: fontFamily,
      );

  /// Display Medium - Page titles (28px, Bold)
  static TextStyle get displayMedium => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
        fontFamily: fontFamily,
      );

  // ═══════════════════════════════════════════════════════════════
  // HEADING STYLES
  // ═══════════════════════════════════════════════════════════════

  /// Heading Large - Section headers (24px, SemiBold)
  static TextStyle get headingLarge => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
        fontFamily: fontFamily,
      );

  /// Heading Medium - Card titles (20px, SemiBold)
  static TextStyle get headingMedium => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
        fontFamily: fontFamily,
      );

  /// Heading Small - Subsection headers (18px, SemiBold)
  static TextStyle get headingSmall => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
        fontFamily: fontFamily,
      );

  // ═══════════════════════════════════════════════════════════════
  // BODY STYLES
  // ═══════════════════════════════════════════════════════════════

  /// Body Large - Main content (16px, Regular)
  static TextStyle get bodyLarge => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
        fontFamily: fontFamily,
      );

  /// Body Medium - Secondary content (14px, Regular)
  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
        fontFamily: fontFamily,
      );

  /// Body Small - Captions, labels (12px, Regular)
  static TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        height: 1.4,
        fontFamily: fontFamily,
      );

  /// Micro - Badges, tags (10px, Regular)
  static TextStyle get micro => const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        height: 1.4,
        fontFamily: fontFamily,
      );

  // ═══════════════════════════════════════════════════════════════
  // COMPONENT-SPECIFIC STYLES
  // ═══════════════════════════════════════════════════════════════

  /// Button text style (16px, SemiBold)
  static TextStyle get buttonText => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textInverse,
        height: 1.0,
        fontFamily: fontFamily,
      );

  /// Input field text style (16px, Regular)
  static TextStyle get inputText => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
        fontFamily: fontFamily,
      );

  /// Input label style (14px, Medium)
  static TextStyle get inputLabel => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.4,
        fontFamily: fontFamily,
      );

  /// Input hint/placeholder style (16px, Regular)
  static TextStyle get inputHint => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        height: 1.5,
        fontFamily: fontFamily,
      );

  // ═══════════════════════════════════════════════════════════════
  // FONT WEIGHTS (for custom usage)
  // ═══════════════════════════════════════════════════════════════

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}
