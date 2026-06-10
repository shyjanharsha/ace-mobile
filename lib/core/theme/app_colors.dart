import 'package:flutter/material.dart';

/// Deep space dark gaming color palette for Kazhutha Kali
class AppColors {
  AppColors._();

  // -------------------------------------------------------
  // Backgrounds
  // -------------------------------------------------------
  static const Color background    = Color(0xFF0D0E1A); // deep space navy
  static const Color surface       = Color(0xFF151728); // elevated card surface
  static const Color surfaceLight  = Color(0xFF1E2038); // lighter surface
  static const Color cardBg        = Color(0xFF1A1B2E); // card background

  // -------------------------------------------------------
  // Brand
  // -------------------------------------------------------
  static const Color primary       = Color(0xFF6C63FF); // electric violet
  static const Color primaryLight  = Color(0xFF8B85FF); // hover/lighter
  static const Color primaryDark   = Color(0xFF4F48CC); // pressed
  static const Color secondary     = Color(0xFF00D4FF); // cyan accent

  // -------------------------------------------------------
  // Game-specific
  // -------------------------------------------------------
  static const Color gold          = Color(0xFFFFD700); // coins / winner
  static const Color goldLight     = Color(0xFFFFE55C);
  static const Color tableGreen    = Color(0xFF1A472A); // card table felt
  static const Color tableGreenLight = Color(0xFF2D6A4F);
  static const Color cardRed       = Color(0xFFE53935); // hearts/diamonds
  static const Color cardBlack     = Color(0xFFEEEEEE); // spades/clubs (off-white for dark bg)

  // -------------------------------------------------------
  // Semantic
  // -------------------------------------------------------
  static const Color success       = Color(0xFF00E676); // safe exit / win
  static const Color error         = Color(0xFFFF5252); // donkey / error
  static const Color warning       = Color(0xFFFFAB40); // timeout warning
  static const Color info          = Color(0xFF40C4FF); // info

  // -------------------------------------------------------
  // Text
  // -------------------------------------------------------
  static const Color textPrimary   = Color(0xFFEEEEFF); // near-white
  static const Color textSecondary = Color(0xFF9090BB); // muted
  static const Color textHint      = Color(0xFF5C5C88); // placeholder
  static const Color textDisabled  = Color(0xFF3A3A5C); // disabled

  // -------------------------------------------------------
  // Glass / Overlays
  // -------------------------------------------------------
  static const Color glass         = Color(0x14FFFFFF); // white 8%
  static const Color glassBorder   = Color(0x1FFFFFFF); // white 12%
  static const Color glassLight    = Color(0x28FFFFFF); // white 16%
  static const Color overlay       = Color(0xCC0D0E1A); // 80% background

  // -------------------------------------------------------
  // Online presence indicators
  // -------------------------------------------------------
  static const Color online        = Color(0xFF00E676);
  static const Color away          = Color(0xFFFFAB40);
  static const Color inGame        = Color(0xFF40C4FF);
  static const Color offline       = Color(0xFF5C5C88);

  // -------------------------------------------------------
  // Dividers
  // -------------------------------------------------------
  static const Color divider       = Color(0x1FFFFFFF); // white 12%

  // -------------------------------------------------------
  // Gradients
  // -------------------------------------------------------
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF9C27B0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tableGradient = LinearGradient(
    colors: [tableGreen, Color(0xFF0D2818)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0D0E1A), Color(0xFF12132A), Color(0xFF0D0E1A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient glowGradient = RadialGradient(
    colors: [Color(0x336C63FF), Color(0x006C63FF)],
    radius: 0.8,
  );
}
