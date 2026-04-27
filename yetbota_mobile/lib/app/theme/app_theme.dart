import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  /// Primary green scale: 500 is the main brand color (#22C55E).
  static const Color primary100 = Color(0xFFD3F3DF);
  static const Color primary200 = Color(0xFFA7E8BF);
  static const Color primary300 = Color(0xFF7ADC9E);
  static const Color primary400 = Color(0xFF4ED17E);
  static const Color primary500 = Color(0xFF22C55E);
  static const Color primary600 = Color(0xFF1B9E4B);
  static const Color primary700 = Color(0xFF147638);
  static const Color primary800 = Color(0xFF0E4F26);
  static const Color primary900 = Color(0xFF072713);

  /// Semitransparent overlays on [primary500] and [primary900] (const-friendly for palettes).
  static const Color primary500a0D = Color(0x0D22C55E);
  static const Color primary500a0F = Color(0x0F22C55E);
  static const Color primary500a14 = Color(0x1422C55E);
  static const Color primary500a1A = Color(0x1A22C55E);
  static const Color primary500a1F = Color(0x1F22C55E);
  static const Color primary500a26 = Color(0x2622C55E);
  static const Color primary500a33 = Color(0x3322C55E);
  static const Color primary500a4D = Color(0x4D22C55E);
  static const Color primary500a66 = Color(0x6622C55E);
  static const Color primary500aE6 = Color(0xE622C55E);
  static const Color primary900aCC = Color(0xCC072713);

  /// Alias for [primary500] — use for accents, seed color, and existing call sites.
  static const primary = primary500;
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

