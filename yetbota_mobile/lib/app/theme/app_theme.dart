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

  // --- Semantic UI (errors, warnings) — use Theme.colorScheme.error or
  // Theme.extension<SemanticColors>() so destructive / validation / badges stay consistent.

  /// Maps to [ColorScheme.error] / destructive actions (e.g. sign out).
  static const Color error = Color(0xFFF87171);

  /// Content on solid [error] surfaces (filled buttons, icons on error).
  static const Color onError = Color(0xFF431418);

  static const Color errorContainerLight = Color(0xFFFFE4E6);
  static const Color onErrorContainerLight = Color(0xFF881337);

  static const Color errorContainerDark = Color(0xFF7F1D1D);
  static const Color onErrorContainerDark = Color(0xFFFECACA);

  /// Primary warning accent — prefer [SemanticColors.warning] from the theme.
  static const Color warning = Color(0xFFF59E0B);

  static const Color onWarning = Color(0xFF422006);

  static ThemeData light() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
          surface: lightBackground,
        ).copyWith(
          error: error,
          onError: onError,
          errorContainer: errorContainerLight,
          onErrorContainer: onErrorContainerLight,
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
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(theme.textTheme);
    return theme.copyWith(
      textTheme: textTheme,
      primaryTextTheme: GoogleFonts.plusJakartaSansTextTheme(
        theme.primaryTextTheme,
      ),
      extensions: const <ThemeExtension<dynamic>>[SemanticColors.light],
    );
  }

  static ThemeData dark() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
          surface: darkBackground,
        ).copyWith(
          error: error,
          onError: Colors.white,
          errorContainer: errorContainerDark,
          onErrorContainer: onErrorContainerDark,
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
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(theme.textTheme);
    return theme.copyWith(
      textTheme: textTheme,
      primaryTextTheme: GoogleFonts.plusJakartaSansTextTheme(
        theme.primaryTextTheme,
      ),
      extensions: const <ThemeExtension<dynamic>>[SemanticColors.dark],
    );
  }
}

/// Warning and related accents not covered by [ColorScheme].
@immutable
class SemanticColors extends ThemeExtension<SemanticColors> {
  const SemanticColors({
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
  });

  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  static const SemanticColors light = SemanticColors(
    warning: AppTheme.warning,
    onWarning: AppTheme.onWarning,
    warningContainer: Color(0xFFFEF3C7),
    onWarningContainer: Color(0xFF92400E),
  );

  static const SemanticColors dark = SemanticColors(
    warning: Color(0xFFFBBF24),
    onWarning: Color(0xFF1C1917),
    warningContainer: Color(0xFF78350F),
    onWarningContainer: Color(0xFFFEF3C7),
  );

  @override
  SemanticColors copyWith({
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
  }) {
    return SemanticColors(
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
    );
  }

  @override
  SemanticColors lerp(ThemeExtension<SemanticColors>? other, double t) {
    if (other is! SemanticColors) return this;
    return SemanticColors(
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
    );
  }
}

extension SemanticColorsContext on BuildContext {
  SemanticColors get semanticColors {
    final ext = Theme.of(this).extension<SemanticColors>();
    assert(
      ext != null,
      'SemanticColors extension missing — register it in AppTheme.light/dark.',
    );
    return ext!;
  }
}
