import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography scale using Outfit font from Google Fonts
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _base => GoogleFonts.outfit(
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      );

  // -------------------------------------------------------
  // Display — used for major headings (game title, score)
  // -------------------------------------------------------
  static TextStyle get displayLarge => _base.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  static TextStyle get displayMedium => _base.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
      );

  static TextStyle get displaySmall => _base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      );

  // -------------------------------------------------------
  // Headline — section headers, screen titles
  // -------------------------------------------------------
  static TextStyle get headlineLarge => _base.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get headlineMedium => _base.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get headlineSmall => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  // -------------------------------------------------------
  // Title — card titles, list item headers
  // -------------------------------------------------------
  static TextStyle get titleLarge => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleMedium => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get titleSmall => _base.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  // -------------------------------------------------------
  // Body — content text
  // -------------------------------------------------------
  static TextStyle get bodyLarge => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodyMedium => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  // -------------------------------------------------------
  // Label — chips, badges, buttons, tabs
  // -------------------------------------------------------
  static TextStyle get labelLarge => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  static TextStyle get labelMedium => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      );

  static TextStyle get labelSmall => _base.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  // -------------------------------------------------------
  // Special — card values, coins, timer
  // -------------------------------------------------------
  static TextStyle get cardValue => _base.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      );

  static TextStyle get coinsValue => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.gold,
      );

  static TextStyle get timerValue => _base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.warning,
        fontFeatures: [const FontFeature.tabularFigures()],
      );

  static TextStyle get roomCode => _base.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: 8,
        color: AppColors.primary,
      );
}
