import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';

enum BottomNavItem { feed, qna, assistant, profile }

class BottomNav extends StatelessWidget {
  /// Total vertical space taken by the main shell bottom nav (FAB half-height + bar + safe area).
  /// Use to pad modals / sheets so content stays above the nav.
  static double mainShellHeight(BuildContext context) {
    const double navTopInset = fabSize / 2;
    return navTopInset + navBodyHeight + MediaQuery.paddingOf(context).bottom;
  }

  static const double fabSize = 56.0;
  static const double navBodyHeight = 64.0;

  const BottomNav({
    super.key,
    this.activeItem = BottomNavItem.feed,
    this.onItemTapped,
    this.onPrimaryActionTap,
    this.suppressActiveTab = false,
  });

  final BottomNavItem activeItem;
  final ValueChanged<BottomNavItem>? onItemTapped;
  final VoidCallback? onPrimaryActionTap;

  /// When true, no tab uses the "active" highlight (e.g. create flows where only the center FAB is emphasized).
  final bool suppressActiveTab;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBackground = isDark
        ? const Color(0xF2000000)
        : const Color(0xF2FFFFFF);
    final navBorder = isDark
        ? const Color(0x1AFFFFFF)
        : const Color(0x14000000);
    final fabBorder = isDark ? Colors.black : Colors.white;
    final fabIcon = isDark ? Colors.black : AppTheme.primary800;
    const fabRadius = fabSize / 2;
    const navTopInset = fabRadius;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return SizedBox(
      height: navTopInset + navBodyHeight + bottomInset,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: navTopInset,
            bottom: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: navBackground,
                    border: Border(top: BorderSide(color: navBorder)),
                  ),
                  padding: EdgeInsets.only(bottom: bottomInset + 2),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 448),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _NavItem(
                              icon: Icons.home_filled,
                              label: 'Feed',
                              active: !suppressActiveTab &&
                                  activeItem == BottomNavItem.feed,
                              onTap: () =>
                                  onItemTapped?.call(BottomNavItem.feed),
                            ),
                            _NavItem(
                              icon: Icons.question_answer_outlined,
                              label: 'Q&A',
                              active: !suppressActiveTab &&
                                  activeItem == BottomNavItem.qna,
                              onTap: () =>
                                  onItemTapped?.call(BottomNavItem.qna),
                            ),
                            const SizedBox(width: 72),
                            _NavItem(
                              icon: Icons.assistant_outlined,
                              label: 'Assistant',
                              active: !suppressActiveTab &&
                                  activeItem == BottomNavItem.assistant,
                              onTap: () =>
                                  onItemTapped?.call(BottomNavItem.assistant),
                            ),
                            _NavItem(
                              icon: Icons.person_outline_rounded,
                              label: 'Profile',
                              active: !suppressActiveTab &&
                                  activeItem == BottomNavItem.profile,
                              onTap: () =>
                                  onItemTapped?.call(BottomNavItem.profile),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Center(
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onPrimaryActionTap,
                  child: Container(
                    width: fabSize,
                    height: fabSize,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: fabBorder, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.38),
                          blurRadius: 30,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(Icons.add_rounded, color: fabIcon, size: 30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = active
        ? AppTheme.primary
        : (isDark ? const Color(0xFF64748B) : const Color(0xFF6B7280));
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          width: label == 'Assistant' ? 66 : 52,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 19, color: color),
              const SizedBox(height: 4),
              Text(
                label.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  letterSpacing: 1,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
