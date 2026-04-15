import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primary = Color(0xFF22C55E);
  static const lightBackground = Color(0xFFFFFFFF);
  static const darkBackground = Color(0xFF000000);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      surface: lightBackground,
    );

    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    );
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(theme.textTheme);
    return theme.copyWith(
      textTheme: textTheme,
      primaryTextTheme: GoogleFonts.plusJakartaSansTextTheme(theme.primaryTextTheme),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      surface: darkBackground,
    );

    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    );
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(theme.textTheme);
    return theme.copyWith(
      textTheme: textTheme,
      primaryTextTheme: GoogleFonts.plusJakartaSansTextTheme(theme.primaryTextTheme),
    );
  }
}

