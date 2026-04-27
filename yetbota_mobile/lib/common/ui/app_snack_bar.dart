import 'package:flutter/material.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';

/// Short SnackBar below the status bar so it is not covered by the main shell bottom nav.
void showTopSnackBar(
  BuildContext context,
  String message, {
  Duration? duration,
}) {
  final m = MediaQuery.of(context);
  final h = m.size.height;
  final t = m.viewPadding.top + 60.0;
  const kSnackBarHeight = 56.0;
  final bottom = (h - t - kSnackBarHeight).clamp(0.0, h);
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final messenger = ScaffoldMessenger.of(context);
  messenger.removeCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: isDark ? AppTheme.primary : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : AppTheme.primary,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.fromLTRB(16, t, 16, bottom),
      duration: duration ?? const Duration(seconds: 3),
    ),
  );
}
