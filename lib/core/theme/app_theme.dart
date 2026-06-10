import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Full dark gaming ThemeData for Kazhutha Kali
class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        // -------------------------------------------------------
        // Color Scheme
        // -------------------------------------------------------
        colorScheme: const ColorScheme.dark(
          primary:          AppColors.primary,
          onPrimary:        Colors.white,
          secondary:        AppColors.secondary,
          onSecondary:      Colors.white,
          surface:          AppColors.surface,
          onSurface:        AppColors.textPrimary,
          error:            AppColors.error,
          onError:          Colors.white,
          outline:          AppColors.glassBorder,
          shadow:           Colors.black,
          scrim:            Colors.black54,
          primaryContainer: Color(0xFF2A2458),
          tertiaryContainer: Color(0xFF1A1B2E),
        ),

        scaffoldBackgroundColor: AppColors.background,

        // -------------------------------------------------------
        // Typography
        // -------------------------------------------------------
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
          displayLarge:  AppTextStyles.displayLarge,
          displayMedium: AppTextStyles.displayMedium,
          displaySmall:  AppTextStyles.displaySmall,
          headlineLarge: AppTextStyles.headlineLarge,
          headlineMedium: AppTextStyles.headlineMedium,
          headlineSmall: AppTextStyles.headlineSmall,
          titleLarge:    AppTextStyles.titleLarge,
          titleMedium:   AppTextStyles.titleMedium,
          titleSmall:    AppTextStyles.titleSmall,
          bodyLarge:     AppTextStyles.bodyLarge,
          bodyMedium:    AppTextStyles.bodyMedium,
          bodySmall:     AppTextStyles.bodySmall,
          labelLarge:    AppTextStyles.labelLarge,
          labelMedium:   AppTextStyles.labelMedium,
          labelSmall:    AppTextStyles.labelSmall,
        ),

        // -------------------------------------------------------
        // AppBar
        // -------------------------------------------------------
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: AppTextStyles.headlineSmall,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppColors.background,
          ),
        ),

        // -------------------------------------------------------
        // Bottom Navigation
        // -------------------------------------------------------
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),

        // -------------------------------------------------------
        // Cards
        // -------------------------------------------------------
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.divider, width: 0.5),
          ),
          margin: EdgeInsets.zero,
        ),

        // -------------------------------------------------------
        // Input Fields
        // -------------------------------------------------------
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.glass,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.glassBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.glassBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          hintStyle: const TextStyle(color: AppColors.textHint),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),

        // -------------------------------------------------------
        // Elevated Button
        // -------------------------------------------------------
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: AppTextStyles.labelLarge,
          ),
        ),

        // -------------------------------------------------------
        // Text Button
        // -------------------------------------------------------
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTextStyles.labelLarge,
          ),
        ),

        // -------------------------------------------------------
        // Outlined Button
        // -------------------------------------------------------
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: AppTextStyles.labelLarge,
          ),
        ),

        // -------------------------------------------------------
        // Chip
        // -------------------------------------------------------
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.glass,
          selectedColor: AppColors.primary.withValues(alpha: 0.3),
          labelStyle: AppTextStyles.labelMedium,
          side: const BorderSide(color: AppColors.glassBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),

        // -------------------------------------------------------
        // Dialog
        // -------------------------------------------------------
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.glassBorder),
          ),
          titleTextStyle: AppTextStyles.headlineSmall,
          contentTextStyle: AppTextStyles.bodyMedium,
        ),

        // -------------------------------------------------------
        // Bottom Sheet
        // -------------------------------------------------------
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          showDragHandle: true,
          dragHandleColor: AppColors.divider,
        ),

        // -------------------------------------------------------
        // Snackbar
        // -------------------------------------------------------
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surfaceLight,
          contentTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),

        // -------------------------------------------------------
        // Divider
        // -------------------------------------------------------
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 0.5,
          space: 0,
        ),

        // -------------------------------------------------------
        // Icon
        // -------------------------------------------------------
        iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 24),
        primaryIconTheme: const IconThemeData(color: AppColors.primary),

        // -------------------------------------------------------
        // Progress indicator
        // -------------------------------------------------------
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
          linearTrackColor: AppColors.glass,
        ),

        // -------------------------------------------------------
        // Switch & Checkbox
        // -------------------------------------------------------
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected) ? AppColors.primary : AppColors.textSecondary,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.primary.withValues(alpha: 0.4)
                : AppColors.glass,
          ),
        ),

        // Page transitions
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS:     CupertinoPageTransitionsBuilder(),
          },
        ),
      );
}
