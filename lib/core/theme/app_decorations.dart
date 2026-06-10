import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Reusable decorations — glassmorphism, cards, inputs, buttons
class AppDecorations {
  AppDecorations._();

  // -------------------------------------------------------
  // Glassmorphism Card
  // -------------------------------------------------------
  static BoxDecoration glassCard({
    double radius = 20,
    Color? borderColor,
    List<BoxShadow>? shadows,
  }) =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.10),
            Colors.white.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? AppColors.glassBorder,
          width: 1.0,
        ),
        boxShadow: shadows ??
            [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.12),
                blurRadius: 20,
                spreadRadius: -4,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: -2,
              ),
            ],
      );

  // -------------------------------------------------------
  // Surface card (non-glass)
  // -------------------------------------------------------
  static BoxDecoration surfaceCard({double radius = 16}) => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.divider, width: 0.5),
      );

  // -------------------------------------------------------
  // Input field decoration
  // -------------------------------------------------------
  static InputDecoration inputDecoration({
    required String label,
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
        filled: true,
        fillColor: AppColors.glass,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.glassBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.glassBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );

  // -------------------------------------------------------
  // Primary gradient button
  // -------------------------------------------------------
  static BoxDecoration primaryButton({double radius = 14}) => BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // -------------------------------------------------------
  // Gold button (for wagered rooms / premium actions)
  // -------------------------------------------------------
  static BoxDecoration goldButton({double radius = 14}) => BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // -------------------------------------------------------
  // Game table (felt green radial)
  // -------------------------------------------------------
  static BoxDecoration gameTable = BoxDecoration(
    gradient: RadialGradient(
      colors: [
        AppColors.tableGreenLight,
        AppColors.tableGreen,
        const Color(0xFF0D2818),
      ],
      stops: const [0.0, 0.6, 1.0],
      radius: 1.2,
    ),
    borderRadius: BorderRadius.circular(200),
    border: Border.all(
      color: const Color(0xFF2D6A4F).withValues(alpha: 0.5),
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.5),
        blurRadius: 40,
        spreadRadius: 10,
      ),
    ],
  );

  // -------------------------------------------------------
  // Player avatar border (based on status)
  // -------------------------------------------------------
  static BoxDecoration avatarBorder({Color? color, double size = 48}) =>
      BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color ?? AppColors.primary,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (color ?? AppColors.primary).withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      );
}

/// Blur widget wrapper for glassmorphism effect
class GlassBlur extends StatelessWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;

  const GlassBlur({
    super.key,
    required this.child,
    this.sigmaX = 12,
    this.sigmaY = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: child,
      ),
    );
  }
}
