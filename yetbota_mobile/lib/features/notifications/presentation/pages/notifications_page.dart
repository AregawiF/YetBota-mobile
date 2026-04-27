import 'package:flutter/material.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  static void open(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const NotificationsPage()),
    );
  }

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  _NotifFilter _filter = _NotifFilter.all;
  bool _hasUnread = true;

  @override
  Widget build(BuildContext context) {
    final palette = _NotificationsPalette.of(context);
    final items = _visibleItems();
    return Scaffold(
      backgroundColor: palette.pageBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(
              palette: palette,
              onBack: () => Navigator.of(context).pop(),
              onMarkAllRead: () => setState(() => _hasUnread = false),
            ),
            _FilterChips(
              palette: palette,
              selected: _filter,
              onSelect: (f) => setState(() => _filter = f),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 120),
                    children: _buildListSections(context, items, palette),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const List<_Notif> _kAllItems = [
    _Notif(
        day: _NotifDay.today,
        kind: _NotifKind.social,
        avatarUrl: _NotifAssets.avatarAlex,
        titleSpans: _TitleSpans.socialLike(user: 'Alex_Green'),
        meta: 'Social • 2m ago',
        isUnread: true,
      ),
      _Notif(
        day: _NotifDay.today,
        kind: _NotifKind.qna,
        avatarUrl: _NotifAssets.avatarSarah,
        titleSpans: _TitleSpans.qnaReply(quoteLines: [
          '"I highly recommend the espresso at',
          'Oxfordshire Coffee House!"',
        ]),
        meta: 'Q&A • 1h ago',
        isUnread: false,
      ),
      _Notif(
        day: _NotifDay.today,
        kind: _NotifKind.badge,
        centerIconUrl: _NotifAssets.trophy,
        useIconCircle: true,
        iconBackground: Color(0x33F59E0B),
        titleSpans: _TitleSpans.achievement(
          subline: 'Thanks for providing 10 helpful answers this week!',
        ),
        meta: 'Achievements • 3h ago',
        isUnread: false,
      ),
      _Notif(
        day: _NotifDay.yesterday,
        kind: _NotifKind.social,
        avatarUrl: _NotifAssets.avatarJordan,
        titleSpans: _TitleSpans.socialLikeBike(user: 'Jordan_92'),
        meta: 'Social • Yesterday',
        isUnread: false,
      ),
      _Notif(
        day: _NotifDay.yesterday,
        kind: _NotifKind.community,
        centerIconUrl: _NotifAssets.mapPin,
        useIconCircle: true,
        titleSpans: _TitleSpans.farmersMarket(),
        meta: 'Community • Yesterday',
        isUnread: false,
      ),
  ];

  List<_Notif> _visibleItems() {
    return _kAllItems.where(_matchesFilter).toList();
  }

  bool _matchesFilter(_Notif n) {
    switch (_filter) {
      case _NotifFilter.all:
        return true;
      case _NotifFilter.social:
        return n.kind == _NotifKind.social;
      case _NotifFilter.qna:
        return n.kind == _NotifKind.qna;
      case _NotifFilter.badges:
        return n.kind == _NotifKind.badge;
    }
  }

  List<Widget> _buildListSections(
    BuildContext context,
    List<_Notif> items,
    _NotificationsPalette palette,
  ) {
    if (items.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No notifications in this view.',
            textAlign: TextAlign.center,
            style: TextStyle(color: palette.muted, fontSize: 15),
          ),
        ),
      ];
    }
    _NotifDay? lastDay;
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final n = items[i];
      if (n.day != lastDay) {
        lastDay = n.day;
        out.add(
          _SectionLabel(
            text: n.day == _NotifDay.today ? 'Today' : 'Yesterday',
            palette: palette,
            isToday: n.day == _NotifDay.today,
          ),
        );
      }
      final effectiveUnread = n.isUnread && _hasUnread;
      out.add(
        _NotificationRow(
          key: ValueKey('notif_${n.day.name}_$i'),
          n: n,
          palette: palette,
          isUnread: effectiveUnread,
          onTap: () {
            if (effectiveUnread) setState(() => _hasUnread = false);
          },
        ),
      );
    }
    if (out.isNotEmpty) {
      out.add(const SizedBox(height: 32));
    }
    return out;
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.palette,
    required this.onBack,
    required this.onMarkAllRead,
  });

  final _NotificationsPalette palette;
  final VoidCallback onBack;
  final VoidCallback onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.headerBackground,
        border: Border(bottom: BorderSide(color: palette.headerBorder)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  icon: Icon(Icons.chevron_left_rounded, size: 28, color: palette.onSurface),
                ),
                Text(
                  'Notifications',
                  style: TextStyle(
                    color: palette.onSurface,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    letterSpacing: -0.75,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onMarkAllRead,
                  style: TextButton.styleFrom(
                    foregroundColor: palette.onSurface,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.done_all_rounded, size: 16, color: palette.muted),
                      const SizedBox(width: 4),
                      Text(
                        'Mark all as read',
                        style: TextStyle(
                          color: palette.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.palette,
    required this.selected,
    required this.onSelect,
  });

  final _NotificationsPalette palette;
  final _NotifFilter selected;
  final void Function(_NotifFilter) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: palette.headerBackground,
        border: Border(bottom: BorderSide(color: palette.headerBorder)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final f in _NotifFilter.values) ...[
              if (f != _NotifFilter.values.first) const SizedBox(width: 8),
              _FilterChip(
                label: f.label,
                selected: selected == f,
                palette: palette,
                onTap: () => onSelect(f),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final _NotificationsPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppTheme.primary : palette.chipInactive,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.black : palette.chipText,
              fontSize: 14,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.text,
    required this.palette,
    this.isToday = false,
  });

  final String text;
  final _NotificationsPalette palette;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, isToday ? 8 : 0),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: palette.muted,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          height: 16 / 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    super.key,
    required this.n,
    required this.palette,
    required this.isUnread,
    required this.onTap,
  });

  final _Notif n;
  final _NotificationsPalette palette;
  final bool isUnread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final showUnreadChrome = isUnread && n.kind == _NotifKind.social;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: palette.divider),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showUnreadChrome)
                  Container(
                    width: 4,
                    color: AppTheme.primary,
                  ),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: showUnreadChrome
                          ? AppTheme.primary500a0F
                          : null,
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        showUnreadChrome ? 16 : 16,
                        16,
                        16,
                        17,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _AvatarBlock(n: n, palette: palette),
                          const SizedBox(width: 16),
                          Expanded(child: _TextBlock(n: n, palette: palette)),
                          if (showUnreadChrome) ...[
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
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

class _AvatarBlock extends StatelessWidget {
  const _AvatarBlock({required this.n, required this.palette});

  final _Notif n;
  final _NotificationsPalette palette;

  @override
  Widget build(BuildContext context) {
    if (n.useIconCircle) {
      return SizedBox(
        width: 48,
        height: 48,
        child: Container(
          decoration: BoxDecoration(
            color: n.iconBackground ?? palette.chipInactive,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: n.centerIconUrl != null
              ? Image.network(
                  n.centerIconUrl!,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    n.kind == _NotifKind.badge
                        ? Icons.emoji_events_rounded
                        : Icons.location_on_rounded,
                    color: n.kind == _NotifKind.badge
                        ? const Color(0xFFF59E0B)
                        : AppTheme.primary,
                    size: 24,
                  ),
                )
              : null,
        ),
      );
    }
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipOval(
              child: n.avatarUrl != null
                  ? Image.network(
                      n.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          ColoredBox(color: palette.chipInactive),
                    )
                  : ColoredBox(color: palette.chipInactive),
            ),
          ),
          if (n.kind == _NotifKind.social)
            _AvatarCornerIcon(social: true, palette: palette)
          else if (n.kind == _NotifKind.qna)
            _AvatarCornerIcon(social: false, palette: palette),
        ],
      ),
    );
  }
}

class _AvatarCornerIcon extends StatelessWidget {
  const _AvatarCornerIcon({required this.social, required this.palette});

  final bool social;
  final _NotificationsPalette palette;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Positioned(
      right: -2,
      bottom: -2,
      child: Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0A0A0A) : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? const Color(0xFF1A1A1A) : palette.headerBorder,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? const Color(0x40000000)
                  : const Color(0x14000000),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: social
            ? const Icon(
                Icons.favorite_rounded,
                size: 12,
                color: Color(0xFFEF4444),
              )
            : const Icon(
                Icons.chat_bubble_rounded,
                size: 12,
                color: Color(0xFF3B82F6),
              ),
      ),
    );
  }
}

class _TextBlock extends StatelessWidget {
  const _TextBlock({required this.n, required this.palette});

  final _Notif n;
  final _NotificationsPalette palette;

  @override
  Widget build(BuildContext context) {
    final metaStyle = TextStyle(
      color: const Color(0xFF64748B),
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 16 / 12,
    );
    if (n.titleSpans.isAchievement) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AchievementRich(palette: palette),
          if (n.titleSpans.achievementSubline != null) ...[
            const SizedBox(height: 4),
            Text(
              n.titleSpans.achievementSubline!,
              style: TextStyle(
                color: palette.achievementSub,
                fontSize: 12,
                height: 16 / 12,
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(n.meta, style: metaStyle),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (n.titleSpans.isQna)
          _QnaBody(titleSpans: n.titleSpans, palette: palette)
        else if (n.titleSpans.isFarmers)
          _FarmersBody(palette: palette)
        else
          _DefaultTitle(titleSpans: n.titleSpans, palette: palette),
        const SizedBox(height: 4),
        Text(n.meta, style: metaStyle),
      ],
    );
  }
}

class _DefaultTitle extends StatelessWidget {
  const _DefaultTitle({required this.titleSpans, required this.palette});

  final _TitleSpans titleSpans;
  final _NotificationsPalette palette;

  @override
  Widget build(BuildContext context) {
    return _RichFromSpans(
      titleSpans: titleSpans,
      palette: palette,
    );
  }
}

class _QnaBody extends StatelessWidget {
  const _QnaBody({required this.titleSpans, required this.palette});

  final _TitleSpans titleSpans;
  final _NotificationsPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Sarah',
                style: TextStyle(
                  color: palette.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: ' replied to your question:',
                style: TextStyle(
                  color: palette.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 19.25 / 14,
                ),
              ),
            ],
          ),
        ),
        if (titleSpans.qnaLines != null) ...[
          const SizedBox(height: 4),
          ...titleSpans.qnaLines!.map(
            (line) => Text(
              line,
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AchievementRich extends StatelessWidget {
  const _AchievementRich({required this.palette});

  final _NotificationsPalette palette;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'Achievement Unlocked! ',
            style: TextStyle(
              color: Color(0xFFF59E0B),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 19.25 / 14,
            ),
          ),
          TextSpan(
            text: "You've earned the ",
            style: TextStyle(
              color: palette.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 19.25 / 14,
            ),
          ),
          TextSpan(
            text: 'Local Guide',
            style: TextStyle(
              color: palette.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 19.25 / 14,
              decoration: TextDecoration.underline,
              decorationColor: const Color(0x80F59E0B),
            ),
          ),
          TextSpan(
            text: ' badge.',
            style: TextStyle(
              color: palette.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 19.25 / 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _FarmersBody extends StatelessWidget {
  const _FarmersBody({required this.palette});

  final _NotificationsPalette palette;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'New post in your area: ',
        style: TextStyle(
          color: palette.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 19.25 / 14,
        ),
        children: const [
          TextSpan(
            text: 'Farmers Market',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: ' is\nnow open!'),
        ],
      ),
    );
  }
}

class _RichFromSpans extends StatelessWidget {
  const _RichFromSpans({
    required this.titleSpans,
    required this.palette,
  });

  final _TitleSpans titleSpans;
  final _NotificationsPalette palette;

  @override
  Widget build(BuildContext context) {
    if (titleSpans.bike) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: titleSpans.s1,
              style: TextStyle(
                color: palette.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 19.25 / 14,
              ),
            ),
            TextSpan(
              text: titleSpans.s2,
              style: TextStyle(
                color: palette.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 19.25 / 14,
              ),
            ),
            const TextSpan(
              text: 'Bike Path',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 19.25 / 14,
              ),
            ),
            TextSpan(
              text: titleSpans.s3,
              style: TextStyle(
                color: palette.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 19.25 / 14,
              ),
            ),
          ],
        ),
      );
    }
    if (titleSpans.alex) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: titleSpans.s1,
              style: TextStyle(
                color: palette.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 19.25 / 14,
              ),
            ),
            TextSpan(
              text: titleSpans.s2,
              style: TextStyle(
                color: palette.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 19.25 / 14,
              ),
            ),
            const TextSpan(
              text: 'Downtown Park',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 19.25 / 14,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

enum _NotifFilter {
  all,
  social,
  qna,
  badges,
}

extension on _NotifFilter {
  String get label => switch (this) {
    _NotifFilter.all => 'All',
    _NotifFilter.social => 'Social',
    _NotifFilter.qna => 'Q&A',
    _NotifFilter.badges => 'Badges',
  };
}

enum _NotifDay { today, yesterday }

enum _NotifKind { social, qna, badge, community }

class _Notif {
  const _Notif({
    required this.day,
    required this.kind,
    this.avatarUrl,
    this.centerIconUrl,
    this.useIconCircle = false,
    this.iconBackground,
    required this.titleSpans,
    required this.meta,
    this.isUnread = false,
  });

  final _NotifDay day;
  final _NotifKind kind;
  final String? avatarUrl;
  final String? centerIconUrl;
  final bool useIconCircle;
  final Color? iconBackground;
  final _TitleSpans titleSpans;
  final String meta;
  final bool isUnread;
}

class _TitleSpans {
  const _TitleSpans._({
    this.alex = false,
    this.bike = false,
    this.s1 = '',
    this.s2 = '',
    this.s3 = '',
    this.qnaLines,
    this.isAchievement = false,
    this.achievementSubline,
    this.isFarmers = false,
  });

  const _TitleSpans.socialLike({required String user})
    : this._(alex: true, s1: user, s2: ' liked your post in ');

  const _TitleSpans.socialLikeBike({required String user})
    : this._(bike: true, s1: user, s2: ' liked your post about the new ', s3: '.');

  const _TitleSpans.qnaReply({required List<String> quoteLines})
    : this._(qnaLines: quoteLines);

  const _TitleSpans.achievement({String? subline})
    : this._(isAchievement: true, achievementSubline: subline);

  const _TitleSpans.farmersMarket() : this._(isFarmers: true);

  final bool alex;
  final bool bike;
  final String s1;
  final String s2;
  final String s3;
  final List<String>? qnaLines;
  final bool isAchievement;
  final String? achievementSubline;
  final bool isFarmers;

  bool get isQna => qnaLines != null;
}

class _NotifAssets {
  static const avatarAlex = 'https://www.figma.com/api/mcp/asset/180df898-cea3-4d79-bf39-cb3a73addb48';
  static const avatarSarah = 'https://www.figma.com/api/mcp/asset/ba641c15-12cf-4f2f-8449-9e8357373ee8';
  static const avatarJordan = 'https://www.figma.com/api/mcp/asset/7dce075d-b76a-4980-82c6-2fbafbe55e02';
  static const trophy = 'https://www.figma.com/api/mcp/asset/69150d67-470b-4221-96e7-347477421b20';
  static const mapPin = 'https://www.figma.com/api/mcp/asset/236d04de-f80f-47d7-ba27-9b6e2ce57347';
}

class _NotificationsPalette {
  const _NotificationsPalette({
    required this.pageBackground,
    required this.headerBackground,
    required this.headerBorder,
    required this.onSurface,
    required this.muted,
    required this.chipInactive,
    required this.chipText,
    required this.divider,
    required this.achievementSub,
  });

  final Color pageBackground;
  final Color headerBackground;
  final Color headerBorder;
  final Color onSurface;
  final Color muted;
  final Color chipInactive;
  final Color chipText;
  final Color divider;
  final Color achievementSub;

  static _NotificationsPalette of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const _NotificationsPalette(
        pageBackground: Color(0xFF000000),
        headerBackground: Color(0xCC000000),
        headerBorder: Color(0xFF1A1A1A),
        onSurface: Colors.white,
        muted: Color(0xFF64748B),
        chipInactive: Color(0xFF1A1A1A),
        chipText: Color(0xFFCBD5E1),
        divider: Color(0xFF1A1A1A),
        achievementSub: Color(0xFF94A3B8),
      );
    }
    return const _NotificationsPalette(
      pageBackground: Color(0xFFF8FAFC),
      headerBackground: Color(0xF2FFFFFF),
      headerBorder: Color(0x14000000),
      onSurface: Color(0xFF0F172A),
      muted: Color(0xFF64748B),
      chipInactive: Color(0xFFE2E8F0),
      chipText: Color(0xFF334155),
      divider: Color(0xFFE2E8F0),
      achievementSub: Color(0xFF64748B),
    );
  }
}
