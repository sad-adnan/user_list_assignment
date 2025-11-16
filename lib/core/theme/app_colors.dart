import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors - Indigo
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryDark = Color(0xFF4338CA);
  static const Color primaryLight = Color(0xFF6366F1);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Secondary/Accent Colors - Violet
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color secondaryDark = Color(0xFF7C3AED);
  static const Color secondaryLight = Color(0xFFA78BFA);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Background & Surface
  static const Color background = Color(0xFFF8F8FB);
  static const Color backgroundDark = Color(0xFF0F0F1E);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A1A2E);
  static const Color surfaceVariant = Color(0xFFEEF2FF);
  static const Color surfaceContainerLow = Color(0xFFF5F7FF);
  static const Color surfaceContainerHigh = Color(0xFFE0E7FF);
  static const Color surfaceContainer = Color(0xFFF1F5F9);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFF8FAFC);

  // Border & Outline
  static const Color outline = Color(0xFF475569);
  static const Color outlineVariant = Color(0xFFF1F5F9);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFD1D5DB);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF059669);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFFD97706);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFFDC2626);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color infoDark = Color(0xFF2563EB);

  // Semantic Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundElevated = Color(0xFFFAFAFC);
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  static const Color scrim = Color(0x99000000);

  // Shimmer/Skeleton
  static const Color shimmerBase = Color(0xFFE5E7EB);
  static const Color shimmerHighlight = Color(0xFFF9FAFB);

  // Interaction States
  static const Color hover = Color(0x0A4F46E5);
  static const Color pressed = Color(0x1A4F46E5);
  static const Color focus = Color(0x1F4F46E5);
  static const Color selected = Color(0x144F46E5);
  static const Color disabled = Color(0xFFF1F5F9);

  // Badge & Tag
  static const Color badgePrimary = Color(0xFF4F46E5);
  static const Color badgeSuccess = Color(0xFF10B981);
  static const Color badgeWarning = Color(0xFFF59E0B);
  static const Color badgeError = Color(0xFFEF4444);
  static const Color badgeNeutral = Color(0xFF64748B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0F0F1E), Color(0xFF1A1A2E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFE5E7EB),
      Color(0xFFF9FAFB),
      Color(0xFFE5E7EB),
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, -0.5),
    end: Alignment(1.0, 0.5),
  );

  // Radial Gradients
  static const RadialGradient spotlightGradient = RadialGradient(
    colors: [
      Color(0x1A4F46E5),
      Color(0x004F46E5),
    ],
    radius: 1.5,
  );

  // Shadows
  static const Color shadowColor = Color(0x1A1E293B);

  static List<BoxShadow> get cardShadow => const [
        BoxShadow(
          color: Color(0x0D1E293B),
          blurRadius: 24,
          offset: Offset(0, 8),
          spreadRadius: -4,
        ),
      ];

  static List<BoxShadow> get softShadow => const [
        BoxShadow(
          color: Color(0x0A1E293B),
          blurRadius: 12,
          offset: Offset(0, 4),
          spreadRadius: -2,
        ),
      ];

  static List<BoxShadow> get elevatedShadow => const [
        BoxShadow(
          color: Color(0x121E293B),
          blurRadius: 32,
          offset: Offset(0, 12),
          spreadRadius: -8,
        ),
      ];

  static List<BoxShadow> get buttonShadow => const [
        BoxShadow(
          color: Color(0x1A4F46E5),
          blurRadius: 16,
          offset: Offset(0, 4),
          spreadRadius: -2,
        ),
      ];

  static List<BoxShadow> get innerShadow => const [
        BoxShadow(
          color: Color(0x0F000000),
          blurRadius: 8,
          offset: Offset(0, 2),
          spreadRadius: -4,
        ),
      ];

  // Color with Opacity helpers
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  // Dark mode variants
  static Color primaryForTheme(bool isDark) {
    return isDark ? primaryLight : primary;
  }

  static Color backgroundForTheme(bool isDark) {
    return isDark ? backgroundDark : background;
  }

  static Color surfaceForTheme(bool isDark) {
    return isDark ? surfaceDark : surface;
  }

  static Color textPrimaryForTheme(bool isDark) {
    return isDark ? textOnDark : textPrimary;
  }
}

extension AppColorExtensions on Color {
  Color get onColor {
    final luminance = computeLuminance();
    return luminance > 0.5 ? AppColors.textPrimary : AppColors.textOnPrimary;
  }

  Color lighten([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color darken([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}
