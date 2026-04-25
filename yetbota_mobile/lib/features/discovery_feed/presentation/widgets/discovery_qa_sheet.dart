import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/common/ui/app_snack_bar.dart';
import 'package:yetbota_mobile/common/ui/widgets/bottom_nav.dart';

/// Community Q&A bottom sheet (matches Discover Feed QA overlay — grabber, header, list, ask field).
class DiscoveryQaSheet extends StatelessWidget {
  const DiscoveryQaSheet({
    super.key,
    required this.questions,
    required this.currentUserAvatarUrl,
    required this.palette,
  });

  final List<DiscoveryQaItem> questions;
  final String currentUserAvatarUrl;
  final DiscoveryQaSheetPalette palette;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final keyboardInsets = MediaQuery.viewInsetsOf(context).bottom;
    final sheetHeight = (screenHeight * 0.82).clamp(520.0, 700.0);

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: palette.sheetBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: palette.sheetTopBorder)),
        boxShadow: [
          BoxShadow(
            color: palette.sheetShadow,
            blurRadius: 50,
            offset: const Offset(0, -20),
          ),
        ],
      ),
      child: Column(
        children: [
          _Grabber(color: palette.handle),
          _Header(palette: palette),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              itemCount: questions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _QaCard(
                  item: questions[index],
                  palette: palette,
                );
              },
            ),
          ),
          _AskQuestionBar(
            palette: palette,
            currentUserAvatarUrl: currentUserAvatarUrl,
            keyboardInsets: keyboardInsets,
          ),
        ],
      ),
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Center(
        child: Container(
          width: 48,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.palette});

  final DiscoveryQaSheetPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'COMMUNITY HUB',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    height: 15 / 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Questions & Answers',
                  style: TextStyle(
                    color: palette.titleText,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 28 / 20,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: palette.closeButtonFill,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                color: palette.closeIcon,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QaCard extends StatelessWidget {
  const _QaCard({required this.item, required this.palette});

  final DiscoveryQaItem item;
  final DiscoveryQaSheetPalette palette;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: item.dimmed ? 0.8 : 1,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: palette.cardBackground,
          borderRadius: BorderRadius.circular(48),
          border: Border.all(color: palette.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: item.showAvatarRing
                          ? AppTheme.primary500a33
                          : palette.mutedPillBorder,
                    ),
                    color: item.showAvatarRing ? null : palette.cardBackground,
                  ),
                  child: item.avatarIcon != null
                      ? Center(child: item.avatarIcon)
                      : _QaNetworkImage(
                          imageUrl: item.avatarUrl ?? '',
                          fallbackGradient: palette.fallbackGradient,
                          loadingFallback: palette.loadingFallback,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.userName,
                        style: TextStyle(
                          color: palette.nameText,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 21 / 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _RoleBadge(
                        label: item.roleLabel,
                        highlight: item.roleIsPathfinder,
                        palette: palette,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _VoteColumn(
                      upCount: item.upCount,
                      upActive: item.upActive,
                      palette: palette,
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.thumb_down_off_alt_outlined,
                      size: 18,
                      color: palette.voteIconMuted,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.body,
              style: TextStyle(
                color: palette.questionText,
                fontSize: 14,
                height: 22.75 / 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({
    required this.label,
    required this.highlight,
    required this.palette,
  });

  final String label;
  final bool highlight;
  final DiscoveryQaSheetPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: highlight ? AppTheme.primary500a1A : palette.mutedPillBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: highlight ? AppTheme.primary : palette.mutedPillText,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.45,
        ),
      ),
    );
  }
}

class _VoteColumn extends StatelessWidget {
  const _VoteColumn({
    required this.upCount,
    required this.upActive,
    required this.palette,
  });

  final int? upCount;
  final bool upActive;
  final DiscoveryQaSheetPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          upActive ? Icons.thumb_up_rounded : Icons.thumb_up_outlined,
          size: 18,
          color: upActive ? AppTheme.primary : palette.voteIconMuted,
        ),
        if (upCount != null) ...[
          const SizedBox(height: 4),
          Text(
            '$upCount',
            style: TextStyle(
              color: upActive
                  ? AppTheme.primary
                  : (upCount == 0
                      ? palette.voteCountVeryMuted
                      : palette.voteCountMuted),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _AskQuestionBar extends StatefulWidget {
  const _AskQuestionBar({
    required this.palette,
    required this.currentUserAvatarUrl,
    required this.keyboardInsets,
  });

  final DiscoveryQaSheetPalette palette;
  final String currentUserAvatarUrl;
  final double keyboardInsets;

  @override
  State<_AskQuestionBar> createState() => _AskQuestionBarState();
}

class _AskQuestionBarState extends State<_AskQuestionBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.palette;
    final mainShellNavClearance = BottomNav.mainShellHeight(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            24,
            12,
            20,
            8 + widget.keyboardInsets + mainShellNavClearance,
          ),
          decoration: BoxDecoration(
            color: p.askBarBackground,
            border: Border(top: BorderSide(color: p.askBarTopBorder)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: p.inputAvatarBorder),
                ),
                child: _QaNetworkImage(
                  imageUrl: widget.currentUserAvatarUrl,
                  fallbackGradient: p.fallbackGradient,
                  loadingFallback: p.loadingFallback,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color: p.composerFieldFill,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: p.composerFieldBorder),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(
                            color: p.composerText,
                            fontSize: 14,
                          ),
                          cursorColor: AppTheme.primary,
                          decoration: InputDecoration(
                            hintText: 'Ask a Question...',
                            hintStyle: TextStyle(
                              color: p.composerHint,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Material(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(999),
                          child: InkWell(
                            onTap: () {
                              if (_controller.text.isEmpty) return;
                              showTopSnackBar(
                                context,
                                'Question will post when the feed is live.',
                              );
                              _controller.clear();
                            },
                            borderRadius: BorderRadius.circular(999),
                            child: const SizedBox(
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.send_rounded,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QaNetworkImage extends StatelessWidget {
  const _QaNetworkImage({
    required this.imageUrl,
    required this.fallbackGradient,
    required this.loadingFallback,
  });

  final String imageUrl;
  final List<Color> fallbackGradient;
  final Color loadingFallback;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: fallbackGradient,
            ),
          ),
        );
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return ColoredBox(color: loadingFallback);
      },
    );
  }
}

class DiscoveryQaItem {
  const DiscoveryQaItem({
    required this.userName,
    required this.body,
    required this.roleLabel,
    this.roleIsPathfinder = false,
    this.upCount,
    this.upActive = false,
    this.dimmed = false,
    this.avatarUrl,
    this.showAvatarRing = true,
    this.avatarIcon,
  });

  final String userName;
  final String body;
  final String roleLabel;
  final bool roleIsPathfinder;
  final int? upCount;
  final bool upActive;
  final bool dimmed;
  final String? avatarUrl;
  final bool showAvatarRing;
  final Widget? avatarIcon;
}

class DiscoveryQaSheetPalette {
  const DiscoveryQaSheetPalette({
    required this.barrierColor,
    required this.sheetBackground,
    required this.sheetTopBorder,
    required this.sheetShadow,
    required this.handle,
    required this.titleText,
    required this.nameText,
    required this.questionText,
    required this.closeButtonFill,
    required this.closeIcon,
    required this.cardBackground,
    required this.cardBorder,
    required this.fallbackGradient,
    required this.loadingFallback,
    required this.mutedPillBackground,
    required this.mutedPillText,
    required this.mutedPillBorder,
    required this.voteIconMuted,
    required this.voteCountMuted,
    required this.voteCountVeryMuted,
    required this.askBarBackground,
    required this.askBarTopBorder,
    required this.inputAvatarBorder,
    required this.composerFieldFill,
    required this.composerFieldBorder,
    required this.composerText,
    required this.composerHint,
  });

  final Color barrierColor;
  final Color sheetBackground;
  final Color sheetTopBorder;
  final Color sheetShadow;
  final Color handle;
  final Color titleText;
  final Color nameText;
  final Color questionText;
  final Color closeButtonFill;
  final Color closeIcon;
  final Color cardBackground;
  final Color cardBorder;
  final List<Color> fallbackGradient;
  final Color loadingFallback;
  final Color mutedPillBackground;
  final Color mutedPillText;
  final Color mutedPillBorder;
  final Color voteIconMuted;
  final Color voteCountMuted;
  final Color voteCountVeryMuted;
  final Color askBarBackground;
  final Color askBarTopBorder;
  final Color inputAvatarBorder;
  final Color composerFieldFill;
  final Color composerFieldBorder;
  final Color composerText;
  final Color composerHint;

  factory DiscoveryQaSheetPalette.fromTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const DiscoveryQaSheetPalette(
        barrierColor: Color(0xA6000000),
        sheetBackground: Color(0xFF000000),
        sheetTopBorder: Color(0x1AFFFFFF),
        sheetShadow: Color(0xCC000000),
        handle: Color(0x33FFFFFF),
        titleText: Color(0xFFFFFFFF),
        nameText: Color(0xFFFFFFFF),
        questionText: Color(0xFFBACBB6),
        closeButtonFill: Color(0xFF242926),
        closeIcon: Color(0xB3FFFFFF),
        cardBackground: Color(0xFF242926),
        cardBorder: Color(0x0DFFFFFF),
        fallbackGradient: [Color(0xFF1E293B), Color(0xFF0F172A)],
        loadingFallback: Color(0xFF111827),
        mutedPillBackground: Color(0x1AFFFFFF),
        mutedPillText: Color(0x99FFFFFF),
        mutedPillBorder: Color(0x1AFFFFFF),
        voteIconMuted: Color(0x80FFFFFF),
        voteCountMuted: Color(0x99FFFFFF),
        voteCountVeryMuted: Color(0x66FFFFFF),
        askBarBackground: Color(0xCC000000),
        askBarTopBorder: Color(0x1AFFFFFF),
        inputAvatarBorder: Color(0x33FFFFFF),
        composerFieldFill: Color(0xFF333A36),
        composerFieldBorder: Color(0x1AFFFFFF),
        composerText: Color(0xFFFFFFFF),
        composerHint: Color(0x4DFFFFFF),
      );
    }
    return const DiscoveryQaSheetPalette(
      barrierColor: Color(0x66000000),
      sheetBackground: Color(0xFFF8FAFC),
      sheetTopBorder: Color(0x14000000),
      sheetShadow: Color(0x4D000000),
      handle: Color(0x26000000),
      titleText: Color(0xFF0F172A),
      nameText: Color(0xFF0F172A),
      questionText: Color(0xFF475569),
      closeButtonFill: Color(0xFFF1F5F9),
      closeIcon: Color(0xFF64748B),
      cardBackground: Color(0xFFFFFFFF),
      cardBorder: Color(0x14000000),
      fallbackGradient: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
      loadingFallback: Color(0xFFE2E8F0),
      mutedPillBackground: Color(0x0A0F172A),
      mutedPillText: Color(0xFF64748B),
      mutedPillBorder: Color(0x1A000000),
      voteIconMuted: Color(0xFF94A3B8),
      voteCountMuted: Color(0xFF64748B),
      voteCountVeryMuted: Color(0xFF94A3B8),
      askBarBackground: Color(0xF2F8FAFC),
      askBarTopBorder: Color(0x14000000),
      inputAvatarBorder: Color(0x26000000),
      composerFieldFill: Color(0xFFFFFFFF),
      composerFieldBorder: Color(0x1A000000),
      composerText: Color(0xFF0F172A),
      composerHint: Color(0x99334155),
    );
  }
}
