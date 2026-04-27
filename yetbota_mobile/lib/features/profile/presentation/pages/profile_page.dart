import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/common/ui/widgets/bottom_nav.dart';

const _kCoverImage =
    'https://www.figma.com/api/mcp/asset/99478b22-4531-40fe-a17d-17246cfa4153';
const _kAvatarImage =
    'https://www.figma.com/api/mcp/asset/23eb3319-f5e7-4509-b024-749fa38c8c30';
const _kVerifiedIcon =
    'https://www.figma.com/api/mcp/asset/c63f93f6-101a-4b0c-ad91-3b664a3abc42';

const _kBadgeExplorer =
    'https://www.figma.com/api/mcp/asset/e9f47b65-f7bf-46f1-a3b7-af652052a4a6';
const _kBadgeGuide =
    'https://www.figma.com/api/mcp/asset/f5ce25af-a892-4e27-aab8-8238a470f7ca';
const _kBadgeElite =
    'https://www.figma.com/api/mcp/asset/8a714736-46a3-4deb-9ffb-26df10d80697';
const _kBadgeHelper =
    'https://www.figma.com/api/mcp/asset/c4cb64ba-395d-4c3d-8957-e982a83f630b';
const _kBadgeStreak =
    'https://www.figma.com/api/mcp/asset/8881b327-e901-47f5-ad24-0182c73be3a4';
const _kBadgePatron =
    'https://www.figma.com/api/mcp/asset/205469f6-1df1-41d7-a8c9-e791830c40dc';

const _kRepBadgeIcon =
    'https://www.figma.com/api/mcp/asset/05b8f2c8-96b7-4247-bd01-49729eed7937';
const _kRepChatIcon =
    'https://www.figma.com/api/mcp/asset/47b9f019-cee9-4208-ac01-5dd10c318311';

const _kGridPost1 =
    'https://www.figma.com/api/mcp/asset/70d8d96c-62d5-41a2-8569-9d77ac5e6f70';
const _kGridPost2 =
    'https://www.figma.com/api/mcp/asset/36ee6fd5-88e2-4708-a306-db4cf53128a4';
const _kGridPost3 =
    'https://www.figma.com/api/mcp/asset/4b789e2a-04ee-447f-863f-d5eb4cd0bc33';

enum _ProfileGridTab { posts, qa, saved }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.onBackFromRoot});

  final VoidCallback? onBackFromRoot;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  _ProfileGridTab _gridTab = _ProfileGridTab.posts;

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
    final palette = _ProfilePalette.of(context);
    final topInset = MediaQuery.paddingOf(context).top;
    const coverH = 176.0;
    const avatarSize = 96.0;
    const avatarOverhang = 48.0;
    final bottomPad = math.max(0.0, BottomNav.mainShellHeight(context) + 16);

    return Scaffold(
      backgroundColor: palette.pageBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: bottomPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: topInset + coverH + avatarOverhang,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: topInset,
                        left: 0,
                        right: 0,
                        height: coverH,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              _kCoverImage,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  ColoredBox(color: palette.cardBackground),
                            ),
                            ColoredBox(color: palette.coverOverlay),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 24,
                        top: topInset + coverH - avatarOverhang,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: avatarSize,
                              height: avatarSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: palette.avatarRingOuter,
                                  width: 3,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                _kAvatarImage,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => ColoredBox(
                                  color: AppTheme.primary100,
                                  child: Icon(
                                    Icons.person,
                                    size: 48,
                                    color: AppTheme.primary700,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppTheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: palette.pageBackground,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Image.network(
                                  _kVerifiedIcon,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.verified,
                                    size: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alex Rivers',
                              style: palette.nameStyle,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '@arivers • Local Expert',
                              style: palette.handleStyle,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _StatPair(
                                  palette: palette,
                                  value: '1.2k',
                                  label: 'Followers',
                                ),
                                const SizedBox(width: 16),
                                _StatPair(
                                  palette: palette,
                                  value: '842',
                                  label: 'Following',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Material(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(9999),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(9999),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                            child: Text(
                              'EDIT PROFILE',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Text(
                    'Exploring the hidden gems of Ethiopia. Coffee lover '
                    '& historical guide. Coffee is my life.',
                    style: palette.bioStyle,
                  ),
                ),
                const SizedBox(height: 24),
                _EarnedBadgesSection(palette: palette),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _ReputationCard(palette: palette),
                ),
                const SizedBox(height: 32),
                _RecentActivitySection(palette: palette),
                const SizedBox(height: 24),
                _ProfileContentTabs(
                  palette: palette,
                  tab: _gridTab,
                  onChanged: (t) => setState(() => _gridTab = t),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: _ProfilePostGrid(
                    palette: palette,
                    tab: _gridTab,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _ProfileTopBar(
              palette: palette,
              topInset: topInset,
              onBack: _handleBack,
              onSettings: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar({
    required this.palette,
    required this.topInset,
    required this.onBack,
    required this.onSettings,
  });

  final _ProfilePalette palette;
  final double topInset;
  final VoidCallback onBack;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: palette.topBarFill,
            border: Border(
              bottom: BorderSide(color: palette.topBarBorder),
            ),
          ),
          padding: EdgeInsets.only(top: topInset),
          child: SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: IconButton(
                      onPressed: onBack,
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: palette.topBarIcon,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'My Profile',
                      textAlign: TextAlign.center,
                      style: palette.topBarTitleStyle,
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    child: IconButton(
                      onPressed: onSettings,
                      icon: Icon(
                        Icons.settings_outlined,
                        color: AppTheme.primary,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatPair extends StatelessWidget {
  const _StatPair({
    required this.palette,
    required this.value,
    required this.label,
  });

  final _ProfilePalette palette;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(value, style: palette.statValueStyle),
        const SizedBox(width: 6),
        Text(label, style: palette.statLabelStyle),
      ],
    );
  }
}

class _EarnedBadgesSection extends StatelessWidget {
  const _EarnedBadgesSection({required this.palette});

  final _ProfilePalette palette;

  static const _badges = <({String label, String url, bool highlight})>[
    (label: 'Explorer', url: _kBadgeExplorer, highlight: true),
    (label: 'Guide', url: _kBadgeGuide, highlight: false),
    (label: 'Elite', url: _kBadgeElite, highlight: false),
    (label: 'Helper', url: _kBadgeHelper, highlight: false),
    (label: 'Streak', url: _kBadgeStreak, highlight: false),
    (label: 'Patron', url: _kBadgePatron, highlight: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EARNED BADGES',
                style: palette.sectionTitleStyle.copyWith(fontWeight: FontWeight.w900),
              ),
              Text(
                '12 Total',
                style: palette.sectionAccentStyle,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 92,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: _badges.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, i) {
              final b = _badges[i];
              return Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: palette.badgeTileBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: b.highlight
                            ? AppTheme.primary500a33
                            : palette.badgeTileBorder,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Image.network(
                      b.url,
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.emoji_events_outlined,
                        color: b.highlight
                            ? AppTheme.primary
                            : palette.mutedText,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    b.label,
                    style: palette.badgeLabelStyle,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ReputationCard extends StatelessWidget {
  const _ReputationCard({required this.palette});

  final _ProfilePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REPUTATION STATUS',
                      style: palette.repHeaderStyle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Level 8 Contributor',
                      style: palette.repTitleStyle,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                decoration: BoxDecoration(
                  color: AppTheme.primary500a1A,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: AppTheme.primary500a4D),
                ),
                child: Text(
                  '2,450 XP',
                  style: palette.xpPillStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: palette.dividerMuted),
                bottom: BorderSide(color: palette.dividerMuted),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 17),
            child: Row(
              children: [
                Expanded(
                  child: _RepStatColumn(
                    palette: palette,
                    iconUrl: _kRepBadgeIcon,
                    value: '12',
                    label: 'BADGES EARNED',
                  ),
                ),
                Container(
                  width: 1,
                  height: 70,
                  color: palette.dividerMuted,
                ),
                Expanded(
                  child: _RepStatColumn(
                    palette: palette,
                    iconUrl: _kRepChatIcon,
                    value: '156',
                    label: 'ANSWERS PROVIDED',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PROGRESS TO LEVEL 9',
                style: palette.progressLabelStyle,
              ),
              Text(
                '75%',
                style: palette.progressPercentStyle,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: SizedBox(
              height: 6,
              child: Stack(
                children: [
                  ColoredBox(
                    color: palette.progressTrack,
                    child: const SizedBox.expand(),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.75,
                    child: ColoredBox(
                      color: AppTheme.primary,
                      child: const SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RepStatColumn extends StatelessWidget {
  const _RepStatColumn({
    required this.palette,
    required this.iconUrl,
    required this.value,
    required this.label,
  });

  final _ProfilePalette palette;
  final String iconUrl;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Image.network(
            iconUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => Icon(
              Icons.workspace_premium_outlined,
              size: 18,
              color: AppTheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: palette.repStatValueStyle),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: palette.repStatLabelStyle,
        ),
      ],
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  const _RecentActivitySection({required this.palette});

  final _ProfilePalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'RECENT ACTIVITY',
            style: palette.activitySectionStyle,
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              Positioned(
                left: 3,
                top: 8,
                bottom: 8,
                child: Container(
                  width: 1,
                  color: palette.timelineLine,
                ),
              ),
              Column(
                children: [
                  _ActivityRow(
                    palette: palette,
                    highlightDot: true,
                    action: 'Posted',
                    rest: ' in Lalibela, Ethiopia',
                    time: '2 hours ago',
                  ),
                  const SizedBox(height: 24),
                  _ActivityRow(
                    palette: palette,
                    highlightDot: false,
                    action: 'Answered',
                    rest: ' a question about Entoto Park',
                    time: 'Yesterday',
                  ),
                  const SizedBox(height: 24),
                  _ActivityRow(
                    palette: palette,
                    highlightDot: false,
                    action: 'Earned',
                    rest: ' "Helpful Guide" badge',
                    time: '3 days ago',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.palette,
    required this.highlightDot,
    required this.action,
    required this.rest,
    required this.time,
  });

  final _ProfilePalette palette;
  final bool highlightDot;
  final String action;
  final String rest;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: highlightDot
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary500a66,
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                )
              : Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3F3F46),
                    shape: BoxShape.circle,
                  ),
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  style: palette.activityLineStyle,
                  children: [
                    TextSpan(
                      text: action,
                      style: palette.activityActionStyle,
                    ),
                    TextSpan(
                      text: rest,
                      style: palette.activityLineStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(time, style: palette.activityTimeStyle),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileContentTabs extends StatelessWidget {
  const _ProfileContentTabs({
    required this.palette,
    required this.tab,
    required this.onChanged,
  });

  final _ProfilePalette palette;
  final _ProfileGridTab tab;
  final ValueChanged<_ProfileGridTab> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget tabCell({
      required _ProfileGridTab value,
      required IconData icon,
    }) {
      final active = tab == value;
      return Expanded(
        child: InkWell(
          onTap: () => onChanged(value),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: active ? AppTheme.primary : palette.tabBarBorder,
                  width: active ? 2 : 1,
                ),
              ),
            ),
            padding: const EdgeInsets.only(top: 16, bottom: 18),
            child: Icon(
              icon,
              size: value == _ProfileGridTab.qa ? 20 : 18,
              color: active ? AppTheme.primary : palette.tabIconIdle,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: palette.tabBarBorder, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          tabCell(value: _ProfileGridTab.posts, icon: Icons.grid_view_rounded),
          tabCell(
            value: _ProfileGridTab.qa,
            icon: Icons.chat_bubble_outline_rounded,
          ),
          tabCell(
            value: _ProfileGridTab.saved,
            icon: Icons.bookmark_border_rounded,
          ),
        ],
      ),
    );
  }
}

class _ProfilePostGrid extends StatelessWidget {
  const _ProfilePostGrid({
    required this.palette,
    required this.tab,
  });

  final _ProfilePalette palette;
  final _ProfileGridTab tab;

  static const _posts = <({String url, String title})>[
    (url: _kGridPost1, title: 'Lalibela Church'),
    (url: _kGridPost2, title: 'Tomoca Coffee'),
    (url: _kGridPost3, title: 'Piazza Streets'),
    (url: _kCoverImage, title: 'Bole Atlas'),
  ];

  @override
  Widget build(BuildContext context) {
    final label = switch (tab) {
      _ProfileGridTab.posts => 'Posts',
      _ProfileGridTab.qa => 'Q&A',
      _ProfileGridTab.saved => 'Saved',
    };

    if (tab != _ProfileGridTab.posts) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text(
            '$label — coming soon',
            style: palette.handleStyle,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final spacing = 12.0;
        final cellW = (w - spacing) / 2;
        const cellH = 173.0;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: _posts.map((p) {
            return SizedBox(
              width: cellW,
              height: cellH,
              child: _GridTile(
                palette: palette,
                imageUrl: p.url,
                title: p.title,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _GridTile extends StatelessWidget {
  const _GridTile({
    required this.palette,
    required this.imageUrl,
    required this.title,
  });

  final _ProfilePalette palette;
  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                ColoredBox(color: palette.cardBackground),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.9),
                  Colors.transparent,
                  Colors.transparent,
                ],
                stops: const [0, 0.5, 1],
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 10,
            right: 12,
            child: Row(
              children: [
                Icon(Icons.location_on, size: 14, color: AppTheme.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: palette.gridTitleStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilePalette {
  const _ProfilePalette({
    required this.pageBackground,
    required this.coverOverlay,
    required this.cardBackground,
    required this.cardBorder,
    required this.topBarFill,
    required this.topBarBorder,
    required this.topBarIcon,
    required this.topBarTitleStyle,
    required this.nameStyle,
    required this.handleStyle,
    required this.bioStyle,
    required this.statValueStyle,
    required this.statLabelStyle,
    required this.sectionTitleStyle,
    required this.sectionAccentStyle,
    required this.badgeTileBackground,
    required this.badgeTileBorder,
    required this.badgeLabelStyle,
    required this.repHeaderStyle,
    required this.repTitleStyle,
    required this.xpPillStyle,
    required this.dividerMuted,
    required this.repStatValueStyle,
    required this.repStatLabelStyle,
    required this.progressLabelStyle,
    required this.progressPercentStyle,
    required this.progressTrack,
    required this.activitySectionStyle,
    required this.timelineLine,
    required this.activityActionStyle,
    required this.activityLineStyle,
    required this.activityTimeStyle,
    required this.tabBarBorder,
    required this.tabIconIdle,
    required this.gridTitleStyle,
    required this.avatarRingOuter,
    required this.mutedText,
  });

  final Color pageBackground;
  final Color coverOverlay;
  final Color cardBackground;
  final Color cardBorder;
  final Color topBarFill;
  final Color topBarBorder;
  final Color topBarIcon;
  final TextStyle topBarTitleStyle;
  final TextStyle nameStyle;
  final TextStyle handleStyle;
  final TextStyle bioStyle;
  final TextStyle statValueStyle;
  final TextStyle statLabelStyle;
  final TextStyle sectionTitleStyle;
  final TextStyle sectionAccentStyle;
  final Color badgeTileBackground;
  final Color badgeTileBorder;
  final TextStyle badgeLabelStyle;
  final TextStyle repHeaderStyle;
  final TextStyle repTitleStyle;
  final TextStyle xpPillStyle;
  final Color dividerMuted;
  final TextStyle repStatValueStyle;
  final TextStyle repStatLabelStyle;
  final TextStyle progressLabelStyle;
  final TextStyle progressPercentStyle;
  final Color progressTrack;
  final TextStyle activitySectionStyle;
  final Color timelineLine;
  final TextStyle activityActionStyle;
  final TextStyle activityLineStyle;
  final TextStyle activityTimeStyle;
  final Color tabBarBorder;
  final Color tabIconIdle;
  final TextStyle gridTitleStyle;
  final Color avatarRingOuter;
  final Color mutedText;

  factory _ProfilePalette.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return _ProfilePalette(
        pageBackground: Colors.black,
        coverOverlay: Colors.black.withValues(alpha: 0.5),
        cardBackground: const Color(0xFF121212),
        cardBorder: const Color(0xFF27272A),
        topBarFill: const Color(0xD9000000),
        topBarBorder: const Color(0x0DFFFFFF),
        topBarIcon: Colors.white,
        topBarTitleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
        nameStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          height: 32 / 24,
        ),
        handleStyle: const TextStyle(
          color: Color(0xFFA1A1AA),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 20 / 14,
        ),
        bioStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          height: 22.75 / 14,
        ),
        statValueStyle: const TextStyle(
          color: AppTheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.w800,
          height: 24 / 16,
        ),
        statLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 16 / 12,
        ),
        sectionTitleStyle: const TextStyle(
          color: Color(0xFF71717A),
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          height: 15 / 10,
        ),
        sectionAccentStyle: const TextStyle(
          color: AppTheme.primary,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 15 / 10,
        ),
        badgeTileBackground: const Color(0xFF121212),
        badgeTileBorder: const Color(0xFF27272A),
        badgeLabelStyle: const TextStyle(
          color: Color(0xFF71717A),
          fontSize: 9,
          fontWeight: FontWeight.w700,
          height: 13.5 / 9,
        ),
        repHeaderStyle: const TextStyle(
          color: AppTheme.primary,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          height: 15 / 10,
        ),
        repTitleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          height: 28 / 18,
        ),
        xpPillStyle: const TextStyle(
          color: AppTheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          height: 16 / 12,
        ),
        dividerMuted: const Color(0x8027272A),
        repStatValueStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          height: 28 / 18,
        ),
        repStatLabelStyle: const TextStyle(
          color: Color(0xFF71717A),
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.45,
          height: 13.5 / 9,
        ),
        progressLabelStyle: const TextStyle(
          color: Color(0xFF71717A),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.55,
          height: 16.5 / 11,
        ),
        progressPercentStyle: const TextStyle(
          color: AppTheme.primary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.55,
          height: 16.5 / 11,
        ),
        progressTrack: const Color(0xFF27272A),
        activitySectionStyle: const TextStyle(
          color: Color(0xFF71717A),
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.2,
          height: 16.5 / 11,
        ),
        timelineLine: const Color(0xFF27272A),
        activityActionStyle: const TextStyle(
          color: AppTheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 17.5 / 14,
        ),
        activityLineStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 17.5 / 14,
        ),
        activityTimeStyle: const TextStyle(
          color: Color(0xFF71717A),
          fontSize: 11,
          height: 16.5 / 11,
        ),
        tabBarBorder: const Color(0xFF18181B),
        tabIconIdle: const Color(0xFF71717A),
        gridTitleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 16.5 / 11,
        ),
        avatarRingOuter: AppTheme.primary,
        mutedText: const Color(0xFF71717A),
      );
    }

    return _ProfilePalette(
      pageBackground: const Color(0xFFF8FAFC),
      coverOverlay: Colors.black.withValues(alpha: 0.35),
      cardBackground: Colors.white,
      cardBorder: const Color(0x14000000),
      topBarFill: const Color(0xE6FFFFFF),
      topBarBorder: const Color(0x14000000),
      topBarIcon: const Color(0xFF0F172A),
      topBarTitleStyle: const TextStyle(
        color: Color(0xFF0F172A),
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      nameStyle: const TextStyle(
        color: Color(0xFF0F172A),
        fontSize: 24,
        fontWeight: FontWeight.w800,
        height: 32 / 24,
      ),
      handleStyle: const TextStyle(
        color: Color(0xFF64748B),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
      ),
      bioStyle: const TextStyle(
        color: Color(0xFF334155),
        fontSize: 14,
        height: 22.75 / 14,
      ),
      statValueStyle: const TextStyle(
        color: AppTheme.primary600,
        fontSize: 16,
        fontWeight: FontWeight.w800,
        height: 24 / 16,
      ),
      statLabelStyle: const TextStyle(
        color: Color(0xFF0F172A),
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
      ),
      sectionTitleStyle: const TextStyle(
        color: Color(0xFF64748B),
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
        height: 15 / 10,
      ),
      sectionAccentStyle: const TextStyle(
        color: AppTheme.primary600,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        height: 15 / 10,
      ),
      badgeTileBackground: const Color(0xFFF1F5F9),
      badgeTileBorder: const Color(0xFFE2E8F0),
      badgeLabelStyle: const TextStyle(
        color: Color(0xFF64748B),
        fontSize: 9,
        fontWeight: FontWeight.w700,
        height: 13.5 / 9,
      ),
      repHeaderStyle: const TextStyle(
        color: AppTheme.primary600,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        height: 15 / 10,
      ),
      repTitleStyle: const TextStyle(
        color: Color(0xFF0F172A),
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 28 / 18,
      ),
      xpPillStyle: const TextStyle(
        color: AppTheme.primary700,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 16 / 12,
      ),
      dividerMuted: const Color(0x14000000),
      repStatValueStyle: const TextStyle(
        color: Color(0xFF0F172A),
        fontSize: 18,
        fontWeight: FontWeight.w800,
        height: 28 / 18,
      ),
      repStatLabelStyle: const TextStyle(
        color: Color(0xFF64748B),
        fontSize: 9,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.45,
        height: 13.5 / 9,
      ),
      progressLabelStyle: const TextStyle(
        color: Color(0xFF64748B),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.55,
        height: 16.5 / 11,
      ),
      progressPercentStyle: const TextStyle(
        color: AppTheme.primary600,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.55,
        height: 16.5 / 11,
      ),
      progressTrack: const Color(0xFFE2E8F0),
      activitySectionStyle: const TextStyle(
        color: Color(0xFF64748B),
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 2.2,
        height: 16.5 / 11,
      ),
      timelineLine: const Color(0xFFCBD5E1),
      activityActionStyle: TextStyle(
        color: AppTheme.primary600,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 17.5 / 14,
      ),
      activityLineStyle: const TextStyle(
        color: Color(0xFF0F172A),
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 17.5 / 14,
      ),
      activityTimeStyle: const TextStyle(
        color: Color(0xFF64748B),
        fontSize: 11,
        height: 16.5 / 11,
      ),
      tabBarBorder: const Color(0xFFE2E8F0),
      tabIconIdle: const Color(0xFF94A3B8),
      gridTitleStyle: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 16.5 / 11,
      ),
      avatarRingOuter: AppTheme.primary600,
      mutedText: const Color(0xFF64748B),
    );
  }
}
