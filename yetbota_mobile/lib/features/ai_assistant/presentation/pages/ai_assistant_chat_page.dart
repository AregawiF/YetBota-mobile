import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/common/ui/widgets/bottom_nav.dart';

/// Figma-exported imagery (temporary CDN URLs).
const _kAiAvatarA =
    'https://www.figma.com/api/mcp/asset/5a0bb6df-5f4d-4214-9f5c-c9c88776c548';
const _kUserAvatar =
    'https://www.figma.com/api/mcp/asset/c0b52843-9d37-478d-b619-d7cabf29d8e2';
const _kAiAvatarB =
    'https://www.figma.com/api/mcp/asset/9e4e9075-86a6-46b3-8ba3-8c86f161a714';
const _kCafeThumb =
    'https://www.figma.com/api/mcp/asset/889dc165-a2fd-405d-ab0f-7847f47e021b';
const _kAiAvatarTyping =
    'https://www.figma.com/api/mcp/asset/15fd2067-d95b-4e42-b147-b77adf96d285';

class AiAssistantChatPage extends StatefulWidget {
  const AiAssistantChatPage({super.key, this.onBackFromRoot});
  final VoidCallback? onBackFromRoot;

  @override
  State<AiAssistantChatPage> createState() => _AiAssistantChatPageState();
}

class _AiAssistantChatPageState extends State<AiAssistantChatPage> {
  final TextEditingController _composerController = TextEditingController();
  final List<String> _pendingUserMessages = [];

  @override
  void dispose() {
    _composerController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _composerController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _pendingUserMessages.add(text);
      _composerController.clear();
    });
  }

  void _handleBack() {
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
      return;
    }
    widget.onBackFromRoot?.call();
  }

  @override
  Widget build(BuildContext context) {
    final palette = _AssistantPalette.of(context);
    final shellBottom = BottomNav.mainShellHeight(context);
    final bottomPad = math.max(0.0, shellBottom - 14);

    return Scaffold(
      backgroundColor: palette.pageBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _ChatHeader(palette: palette, onBack: _handleBack),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8 + bottomPad),
                    children: [
                      const SizedBox(height: 8),
                      _AiLabeledBubble(
                        palette: palette,
                        label: 'Yet Bota AI',
                        avatarUrl: _kAiAvatarA,
                        child: Text(
                          "Hey there! I'm your Yet Bota guide.\n"
                          'Ask me about local events,\n'
                          'trending spots, or community\n'
                          'insights.',
                          style: palette.aiBodyStyle,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _UserLabeledBubble(
                        palette: palette,
                        label: 'You',
                        avatarUrl: _kUserAvatar,
                        child: Text(
                          "What's the best spot for a quick "
                          'coffee near the park?',
                          style: palette.userBodyStyle,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _AiPlaceRecommendationBlock(
                        palette: palette,
                        avatarUrl: _kAiAvatarB,
                      ),
                      const SizedBox(height: 24),
                      ..._pendingUserMessages.map(
                        (msg) => Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _UserLabeledBubble(
                            palette: palette,
                            label: 'You',
                            avatarUrl: _kUserAvatar,
                            child: Text(
                              msg,
                              style: palette.userBodyStyle,
                            ),
                          ),
                        ),
                      ),
                      _TypingRow(palette: palette, avatarUrl: _kAiAvatarTyping),
                    ],
                  ),
                ),
              ),
            ),
            _ComposerDock(
              palette: palette,
              bottomInset: bottomPad,
              controller: _composerController,
              onSend: _send,
            ),
          ],
        ),
      ),
    );
  }
}

class _AssistantPalette {
  const _AssistantPalette({
    required this.pageBackground,
    required this.headerBackground,
    required this.headerBorder,
    required this.labelMuted,
    required this.aiBubbleFill,
    required this.aiBubbleBorder,
    required this.aiPrimaryText,
    required this.userBubbleFill,
    required this.userBubbleText,
    required this.placeCardBg,
    required this.placeCardBorder,
    required this.secondaryMuted,
    required this.accentGreen,
    required this.onlineLabel,
    required this.chipFill,
    required this.chipBorder,
    required this.chipIcon,
    required this.composerFill,
    required this.composerBorder,
    required this.composerPlaceholder,
    required this.attachButtonBg,
    required this.attachIcon,
    required this.divider,
    required this.userAvatarBorder,
  });

  final Color pageBackground;
  final Color headerBackground;
  final Color headerBorder;
  final Color labelMuted;
  final Color aiBubbleFill;
  final Color aiBubbleBorder;
  final Color aiPrimaryText;
  final Color userBubbleFill;
  final Color userBubbleText;
  final Color placeCardBg;
  final Color placeCardBorder;
  final Color secondaryMuted;
  final Color accentGreen;
  final Color onlineLabel;
  final Color chipFill;
  final Color chipBorder;
  final Color chipIcon;
  final Color composerFill;
  final Color composerBorder;
  final Color composerPlaceholder;
  final Color attachButtonBg;
  final Color attachIcon;
  final Color divider;
  final Color userAvatarBorder;

  TextStyle get aiBodyStyle => TextStyle(
        color: aiPrimaryText,
        fontSize: 14,
        height: 22.75 / 14,
        fontWeight: FontWeight.w400,
      );

  TextStyle get userBodyStyle => TextStyle(
        color: userBubbleText,
        fontSize: 14,
        height: 22.75 / 14,
        fontWeight: FontWeight.w600,
      );

  factory _AssistantPalette.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const _AssistantPalette(
        pageBackground: Color(0xFF000000),
        headerBackground: Color(0xFF000000),
        headerBorder: Color(0x80262626),
        labelMuted: Color(0xFF737373),
        aiBubbleFill: Color(0xB31E2D24),
        aiBubbleBorder: Color(0x14FFFFFF),
        aiPrimaryText: Color(0xFFE5E5E5),
        userBubbleFill: AppTheme.primary500,
        userBubbleText: Color(0xFF000000),
        placeCardBg: Color(0x66000000),
        placeCardBorder: Color(0x0DFFFFFF),
        secondaryMuted: Color(0xFFA3A3A3),
        accentGreen: AppTheme.primary500,
        onlineLabel: Color(0xCC22C55E),
        chipFill: Color(0xCC262626),
        chipBorder: Color(0xFF404040),
        chipIcon: AppTheme.primary500,
        composerFill: Color(0x80171717),
        composerBorder: Color(0xFF262626),
        composerPlaceholder: Color(0xFF737373),
        attachButtonBg: Colors.transparent,
        attachIcon: Color(0xFF737373),
        divider: Color(0xFF171717),
        userAvatarBorder: Color(0xFF262626),
      );
    }
    return const _AssistantPalette(
      pageBackground: Color(0xFFF8FAFC),
      headerBackground: Color(0xFFF8FAFC),
      headerBorder: Color(0x14000000),
      labelMuted: Color(0xFF6B7280),
      aiBubbleFill: Color(0xFFE8F8EE),
      aiBubbleBorder: Color(0x3322C55E),
      aiPrimaryText: Color(0xFF111827),
      userBubbleFill: AppTheme.primary500,
      userBubbleText: Color(0xFF000000),
      placeCardBg: Color(0xFFF3F4F6),
      placeCardBorder: Color(0x14000000),
      secondaryMuted: Color(0xFF6B7280),
      accentGreen: AppTheme.primary600,
      onlineLabel: Color(0xFF15803D),
      chipFill: Color(0xFFF3F4F6),
      chipBorder: Color(0xFFE5E7EB),
      chipIcon: AppTheme.primary600,
      composerFill: Color(0xFFFFFFFF),
      composerBorder: Color(0xFFE5E7EB),
      composerPlaceholder: Color(0xFF9CA3AF),
      attachButtonBg: Color(0xFFF3F4F6),
      attachIcon: Color(0xFF4B5563),
      divider: Color(0x14000000),
      userAvatarBorder: Color(0xFFE5E7EB),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.palette, required this.onBack});

  final _AssistantPalette palette;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.headerBackground,
        border: Border(bottom: BorderSide(color: palette.headerBorder)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 448),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 8, 12),
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  onPressed: onBack,
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    size: 28,
                    color: palette.aiPrimaryText,
                  ),
                ),
                const SizedBox(width: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppTheme.primary500,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.smart_toy_rounded,
                        size: 18,
                        color: palette.userBubbleText,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Yet Bota AI',
                          style: TextStyle(
                            color: palette.aiPrimaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                            height: 20 / 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: palette.accentGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'ASSISTANT ONLINE',
                              style: TextStyle(
                                color: palette.onlineLabel,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                height: 15 / 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: palette.pageBackground,
                        builder: (ctx) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.info_outline_rounded,
                                  color: palette.aiPrimaryText,
                                ),
                                title: Text(
                                  'About Yet Bota AI',
                                  style: TextStyle(color: palette.aiPrimaryText),
                                ),
                                onTap: () => Navigator.pop(ctx),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      color: palette.aiPrimaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundAvatar extends StatelessWidget {
  const _RoundAvatar({
    required this.imageUrl,
    required this.borderColor,
  });

  final String imageUrl;
  final Color borderColor;

  static const double _kSize = 32;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kSize,
      height: _kSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => ColoredBox(
          color: borderColor.withValues(alpha: 0.2),
          child: Icon(
            Icons.person_rounded,
            size: _kSize * 0.5,
            color: borderColor,
          ),
        ),
      ),
    );
  }
}

class _AiLabeledBubble extends StatelessWidget {
  const _AiLabeledBubble({
    required this.palette,
    required this.label,
    required this.avatarUrl,
    required this.child,
  });

  final _AssistantPalette palette;
  final String label;
  final String avatarUrl;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final aiRing = palette.accentGreen.withValues(alpha: 0.2);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _RoundAvatar(imageUrl: avatarUrl, borderColor: aiRing),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: palette.labelMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.9,
                    height: 13.5 / 9,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 265),
                      padding: const EdgeInsets.fromLTRB(17, 13, 23, 13),
                      decoration: BoxDecoration(
                        color: palette.aiBubbleFill,
                        border: Border.all(color: palette.aiBubbleBorder),
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UserLabeledBubble extends StatelessWidget {
  const _UserLabeledBubble({
    required this.palette,
    required this.label,
    required this.avatarUrl,
    required this.child,
  });

  final _AssistantPalette palette;
  final String label;
  final String avatarUrl;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4, bottom: 4),
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: palette.labelMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.9,
                    height: 13.5 / 9,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 265),
                  padding: const EdgeInsets.fromLTRB(16, 12, 38, 12),
                  decoration: BoxDecoration(
                    color: palette.userBubbleFill,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _RoundAvatar(
          imageUrl: avatarUrl,
          borderColor: palette.userAvatarBorder,
        ),
      ],
    );
  }
}

class _AiPlaceRecommendationBlock extends StatelessWidget {
  const _AiPlaceRecommendationBlock({
    required this.palette,
    required this.avatarUrl,
  });

  final _AssistantPalette palette;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    final aiRing = palette.accentGreen.withValues(alpha: 0.2);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _RoundAvatar(imageUrl: avatarUrl, borderColor: aiRing),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  'YET BOTA AI',
                  style: TextStyle(
                    color: palette.labelMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.9,
                    height: 13.5 / 9,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 265),
                    decoration: BoxDecoration(
                      color: palette.aiBubbleFill,
                      border: Border.all(color: palette.aiBubbleBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(17, 13, 17, 0),
                          child: Text.rich(
                            TextSpan(
                              style: palette.aiBodyStyle,
                              children: [
                                const TextSpan(text: 'Our community members are\n'),
                                const TextSpan(text: 'currently loving '),
                                TextSpan(
                                  text: 'Green Bean Cafe',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: palette.accentGreen,
                                  ),
                                ),
                                const TextSpan(text: '.\n'),
                                const TextSpan(
                                  text:
                                      "It's just a 3-minute walk from the\nNorth entrance.",
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: Container(
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: palette.placeCardBg,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: palette.placeCardBorder),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Green Bean Cafe',
                                        style: TextStyle(
                                          color: palette.aiPrimaryText,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          height: 16 / 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star_rounded,
                                            size: 12,
                                            color: palette.accentGreen,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '4.9 · 120 reviews',
                                            style: TextStyle(
                                              color: palette.secondaryMuted,
                                              fontSize: 10,
                                              height: 16.25 / 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'OPEN NOW · 0.2 MILES AWAY',
                                        style: TextStyle(
                                          color: palette.accentGreen,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.25,
                                          height: 16.25 / 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: palette.aiBubbleBorder,
                                      ),
                                    ),
                                    child: Image.network(
                                      _kCafeThumb,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => ColoredBox(
                                        color: palette.placeCardBg,
                                        child: Icon(
                                          Icons.local_cafe_rounded,
                                          color: palette.secondaryMuted,
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
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 8),
                child: Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      onPressed: () {},
                      icon: Icon(
                        Icons.thumb_up_outlined,
                        size: 18,
                        color: palette.secondaryMuted,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      onPressed: () {},
                      icon: Icon(
                        Icons.thumb_down_outlined,
                        size: 18,
                        color: palette.secondaryMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TypingRow extends StatelessWidget {
  const _TypingRow({required this.palette, required this.avatarUrl});

  final _AssistantPalette palette;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    final aiRing = palette.accentGreen.withValues(alpha: 0.2);

    return Opacity(
      opacity: 0.6,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _RoundAvatar(imageUrl: avatarUrl, borderColor: aiRing),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
                decoration: BoxDecoration(
                  color: palette.aiBubbleFill,
                  border: Border.all(color: palette.aiBubbleBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    3,
                    (i) => Container(
                      margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: palette.secondaryMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
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

class _ComposerDock extends StatelessWidget {
  const _ComposerDock({
    required this.palette,
    required this.bottomInset,
    required this.controller,
    required this.onSend,
  });

  final _AssistantPalette palette;
  final double bottomInset;
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.pageBackground,
        border: Border(
          top: BorderSide(color: palette.divider),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 448),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _QuickChip(
                        palette: palette,
                        icon: Icons.confirmation_number_outlined,
                        label: 'Events',
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      _QuickChip(
                        palette: palette,
                        icon: Icons.explore_outlined,
                        label: 'Guides',
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      _QuickChip(
                        palette: palette,
                        icon: Icons.forum_outlined,
                        label: 'Community Q&A',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: palette.composerFill,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: palette.composerBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Material(
                          color: palette.attachButtonBg,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {},
                            child: SizedBox(
                              width: 36,
                              height: 36,
                              child: Icon(
                                Icons.add_rounded,
                                color: palette.attachIcon,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller,
                            style: TextStyle(
                              color: palette.aiPrimaryText,
                              fontSize: 14,
                            ),
                            cursorColor: palette.accentGreen,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'Ask Yet Bota AI...',
                              hintStyle: TextStyle(
                                color: palette.composerPlaceholder,
                                fontSize: 14,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 9,
                              ),
                            ),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => onSend(),
                          ),
                        ),
                        Material(
                          color: AppTheme.primary500,
                          shape: const CircleBorder(),
                          elevation: 2,
                          shadowColor: Colors.black26,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: onSend,
                            child: SizedBox(
                              width: 36,
                              height: 36,
                              child: Icon(
                                Icons.arrow_upward_rounded,
                                color: palette.userBubbleText,
                                size: 20,
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
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.palette,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final _AssistantPalette palette;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.chipFill,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: palette.chipBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: palette.chipIcon),
              const SizedBox(width: 6),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: palette.aiPrimaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.275,
                  height: 16.5 / 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
