import 'package:flutter/material.dart';

/// Centralized color palette for ALU Connect.
class AppColors {
  AppColors._();

  // Core brand
  static const Color primary = Color(0xFFF5A623); // amber/gold
  static const Color primaryDark = Color(0xFFD98C12);

  // Dark theme surfaces
  static const Color darkBackground = Color(0xFF0C1626);
  static const Color darkSurface = Color(0xFF16263E);
  static const Color darkSurfaceAlt = Color(0xFF1E3151);
  static const Color darkBorder = Color(0xFF2A3C5C);

  // Light theme surfaces
  static const Color lightBackground = Color(0xFFF4F6FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFEDF1F9);
  static const Color lightBorder = Color(0xFFE0E6F2);

  // Text
  static const Color darkTextPrimary = Color(0xFFF5F7FB);
  static const Color darkTextSecondary = Color(0xFF9BAAC4);
  static const Color lightTextPrimary = Color(0xFF18233A);
  static const Color lightTextSecondary = Color(0xFF6B7A99);

  // Category / accent colors
  static const Color accentEvent = Color(0xFFF5A623); // amber
  static const Color accentOpportunity = Color(0xFF8C7CF6); // purple
  static const Color accentWorkshop = Color(0xFF36C2CE); // teal
  static const Color accentAcademic = Color(0xFF5B9CF6); // blue
  static const Color accentAnnouncement = Color(0xFFEF6F8E); // pink
  static const Color accentStudyGroup = Color(0xFF4ADE80); // green

  // Status
  static const Color success = Color(0xFF34D399);
  static const Color danger = Color(0xFFEF4444);
  static const Color going = Color(0xFF34D399);
  static const Color interested = Color(0xFFF5A623);
}

/// A small visual preset (gradient + icon) used for post cover banners.
class CoverTheme {
  final String key;
  final String label;
  final IconData icon;
  final List<Color> gradient;

  const CoverTheme({
    required this.key,
    required this.label,
    required this.icon,
    required this.gradient,
  });
}

const List<CoverTheme> kCoverThemes = [
  CoverTheme(
    key: 'leadership',
    label: 'Leadership',
    icon: Icons.emoji_events_rounded,
    gradient: [Color(0xFFF5A623), Color(0xFFD9622B)],
  ),
  CoverTheme(
    key: 'tech',
    label: 'Tech & Innovation',
    icon: Icons.memory_rounded,
    gradient: [Color(0xFF5B9CF6), Color(0xFF8C7CF6)],
  ),
  CoverTheme(
    key: 'community',
    label: 'Community',
    icon: Icons.diversity_3_rounded,
    gradient: [Color(0xFF36C2CE), Color(0xFF34D399)],
  ),
  CoverTheme(
    key: 'business',
    label: 'Entrepreneurship',
    icon: Icons.rocket_launch_rounded,
    gradient: [Color(0xFF8C7CF6), Color(0xFFEF6F8E)],
  ),
  CoverTheme(
    key: 'academics',
    label: 'Academics',
    icon: Icons.menu_book_rounded,
    gradient: [Color(0xFF4ADE80), Color(0xFF36C2CE)],
  ),
  CoverTheme(
    key: 'social',
    label: 'Social & Culture',
    icon: Icons.celebration_rounded,
    gradient: [Color(0xFFEF6F8E), Color(0xFFF5A623)],
  ),
];

CoverTheme coverThemeFor(String key) {
  return kCoverThemes.firstWhere(
    (c) => c.key == key,
    orElse: () => kCoverThemes.first,
  );
}

/// Builds the light/dark [ThemeData] for the app.
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => _build(Brightness.dark);
  static ThemeData get lightTheme => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final background =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: const Color(0xFF1A1300),
      secondary: AppColors.accentOpportunity,
      onSecondary: Colors.white,
      error: AppColors.danger,
      onError: Colors.white,
      surface: surface,
      onSurface: textPrimary,
    );

    final baseTextTheme = ThemeData(brightness: brightness).textTheme;
    final textTheme = baseTextTheme
        .apply(
          bodyColor: textPrimary,
          displayColor: textPrimary,
        )
        .copyWith(
          headlineSmall: baseTextTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: -0.2,
          ),
          titleLarge: baseTextTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
          titleMedium: baseTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          titleSmall: baseTextTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          bodyMedium: baseTextTheme.bodyMedium?.copyWith(
            color: textSecondary,
            height: 1.4,
          ),
          bodySmall: baseTextTheme.bodySmall?.copyWith(
            color: textSecondary,
          ),
          labelLarge: baseTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: 'Roboto',
      dividerColor: border,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: border, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: AppColors.primary,
        labelStyle: textTheme.labelLarge?.copyWith(color: textPrimary),
        secondaryLabelStyle: const TextStyle(color: Color(0xFF1A1300)),
        side: BorderSide(color: border),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: const Color(0xFF1A1300),
          minimumSize: const Size.fromHeight(52),
          textStyle:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size.fromHeight(52),
          textStyle:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.darkSurfaceAlt : textPrimary,
        contentTextStyle: TextStyle(
          color: isDark ? textPrimary : surface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.primary
                : null),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.primary.withValues(alpha: 0.4)
                : null),
      ),
    );
  }
}
