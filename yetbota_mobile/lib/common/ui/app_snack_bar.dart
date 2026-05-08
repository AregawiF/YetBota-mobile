import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yetbota_mobile/common/ui/widgets/bottom_nav.dart';

enum AppSnackBarAppearance {
  accent,
  error,
  neutral,
}

OverlayEntry? _activeSnackBarEntry;
Timer? _activeSnackBarTimer;

void _dismissActiveSnackBar() {
  _activeSnackBarTimer?.cancel();
  _activeSnackBarTimer = null;
  _activeSnackBarEntry?.remove();
  _activeSnackBarEntry = null;
}

void showTopSnackBar(
  BuildContext context,
  String message, {
  Duration? duration,
  AppSnackBarAppearance appearance = AppSnackBarAppearance.accent,
}) {
  final navigator = Navigator.maybeOf(context, rootNavigator: true);
  final overlay = navigator?.overlay;
  if (overlay == null || !context.mounted) return;

  final scheme = Theme.of(context).colorScheme;

  late final Color backgroundColor;
  late final Color foregroundColor;

  switch (appearance) {
    case AppSnackBarAppearance.accent:
      backgroundColor = scheme.primary;
      foregroundColor = scheme.onPrimary;
    case AppSnackBarAppearance.error:
      backgroundColor = scheme.errorContainer;
      foregroundColor = scheme.onErrorContainer;
    case AppSnackBarAppearance.neutral:
      backgroundColor = scheme.surfaceContainerHighest;
      foregroundColor = scheme.onSurface;
  }

  _dismissActiveSnackBar();

  final showDuration = duration ?? const Duration(seconds: 3);

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (overlayContext) {
      return Positioned.fill(
        child: IgnorePointer(
          ignoring: true,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: BottomNav.navBottomPadding(overlayContext),
              ),
              child: SizedBox(
                width: MediaQuery.sizeOf(overlayContext).width,
                child: Material(
                  elevation: 8,
                  color: backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 20,
                    ),
                    child: DefaultTextStyle.merge(
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                      child: Text(message),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  _activeSnackBarEntry = entry;
  overlay.insert(entry);

  _activeSnackBarTimer = Timer(showDuration, () {
    if (_activeSnackBarEntry != entry) return;
    _dismissActiveSnackBar();
  });
}
