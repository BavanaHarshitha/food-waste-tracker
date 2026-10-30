import 'package:flutter/material.dart';

class AppTheme {
  static const Color _authGreen = Color(0xFF2E7D32);
  static const Color _authGreenDark = Color(0xFF81C784);

  static ThemeData withAccent(
    ThemeData base, {
    required Color primary,
    required Color onPrimary,
    required Color primaryContainer,
    required Color onPrimaryContainer,
  }) {
    final ColorScheme colorScheme = base.colorScheme.copyWith(
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: primary,
        foregroundColor: onPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        focusedBorder: base.inputDecorationTheme.focusedBorder?.copyWith(
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        indicatorColor: primaryContainer,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
      ),
      iconTheme: base.iconTheme.copyWith(color: primary),
    );
  }

  static ThemeData authTheme(ThemeData base) {
    final bool isDark = base.brightness == Brightness.dark;
    return withAccent(
      base,
      primary: isDark ? _authGreenDark : _authGreen,
      onPrimary: isDark ? const Color(0xFF102B12) : Colors.white,
      primaryContainer:
          isDark ? const Color(0xFF28532D) : const Color(0xFFDDF1DA),
      onPrimaryContainer:
          isDark ? const Color(0xFFD9F1D5) : const Color(0xFF183B1B),
    );
  }

  static ThemeData tabTheme(ThemeData base, int index) {
    final bool isDark = base.brightness == Brightness.dark;
    final (Color, Color, Color, Color) accent = switch (index) {
      0 => isDark
          ? (
              const Color(0xFFFF8A80),
              const Color(0xFF3E1F22),
              const Color(0xFF63383A),
              const Color(0xFFFFDAD6),
            )
          : (
              const Color(0xFFB44D58),
              Colors.white,
              const Color(0xFFF7DDE0),
              const Color(0xFF4B1720),
            ),
      1 => isDark
          ? (
              const Color(0xFF8CC7F0),
              const Color(0xFF10283A),
              const Color(0xFF26465D),
              const Color(0xFFD2E9FF),
            )
          : (
              const Color(0xFF3B7197),
              Colors.white,
              const Color(0xFFDCECF6),
              const Color(0xFF173B55),
            ),
      2 => isDark
          ? (
              const Color(0xFFFFB77A),
              const Color(0xFF3B2415),
              const Color(0xFF5A3823),
              const Color(0xFFFFDCC2),
            )
          : (
              const Color(0xFFB85F32),
              Colors.white,
              const Color(0xFFF8E2D3),
              const Color(0xFF4A2410),
            ),
      _ => isDark
          ? (
              const Color(0xFFD0A5F2),
              const Color(0xFF30203E),
              const Color(0xFF4A3560),
              const Color(0xFFEEDBFF),
            )
          : (
              const Color(0xFF76539A),
              Colors.white,
              const Color(0xFFEDE1F5),
              const Color(0xFF38204F),
            ),
    };

    return withAccent(
      base,
      primary: accent.$1,
      onPrimary: accent.$2,
      primaryContainer: accent.$3,
      onPrimaryContainer: accent.$4,
    );
  }

  static final ColorScheme _lightColorScheme =
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF9B3F59),
        brightness: Brightness.light,
      ).copyWith(
        secondary: const Color(0xFFC8753E),
        onSecondary: Colors.white,
        tertiary: const Color(0xFF718356),
        onTertiary: Colors.white,
      );

  static final ColorScheme _darkColorScheme =
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF9B3F59),
        brightness: Brightness.dark,
      ).copyWith(
        secondary: const Color(0xFFE5A16B),
        onSecondary: const Color(0xFF321B12),
        tertiary: const Color(0xFFB4C28D),
        onTertiary: const Color(0xFF202914),
      );

  // =========================
  // LIGHT THEME
  // =========================

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: _lightColorScheme,

    scaffoldBackgroundColor: const Color(0xFFFFF7F1),

    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: _lightColorScheme.primary,
      foregroundColor: _lightColorScheme.onPrimary,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF382A30),
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF382A30),
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF382A30),
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF382A30)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF796970)),
    ),

    cardTheme: const CardThemeData(
      elevation: 2,
      color: Color(0xFFFFFCF9),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFFFCF9),

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8D5D4)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _lightColorScheme.primary, width: 2),
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightColorScheme.primary,
        foregroundColor: Colors.white,

        minimumSize: const Size(double.infinity, 50),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xFFFFFCF9),
      indicatorColor: Color(0xFFF7DFD5),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _lightColorScheme.primary,
      foregroundColor: _lightColorScheme.onPrimary,
    ),

    iconTheme: IconThemeData(color: _lightColorScheme.primary),

    dividerTheme: const DividerThemeData(
      color: Color(0xFFE8D5D4),
      thickness: 1,
    ),
  );

  // =========================
  // DARK THEME
  // =========================

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,

    colorScheme: _darkColorScheme,

    scaffoldBackgroundColor: const Color(0xFF1C171B),

    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: const Color(0xFF40232D),
      foregroundColor: Colors.white,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFD0BDC2)),
    ),

    // Dark cards
    cardTheme: const CardThemeData(
      elevation: 2,
      color: Color(0xFF2A2026),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
    ),

    // Dark text fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2026),

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF62414C)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _darkColorScheme.secondary, width: 2),
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    ),

    // Dark buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkColorScheme.primary,
        foregroundColor: _darkColorScheme.onPrimary,

        minimumSize: const Size(double.infinity, 50),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    // Dark navigation
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xFF261D22),
      indicatorColor: Color(0xFF58303F),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _darkColorScheme.secondary,
      foregroundColor: _darkColorScheme.onSecondary,
    ),

    iconTheme: IconThemeData(color: _darkColorScheme.secondary),

    dividerTheme: const DividerThemeData(
      color: Color(0xFF49343D),
      thickness: 1,
    ),
  );
}
