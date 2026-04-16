import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/common/ui/widgets/bottom_nav.dart';
import 'package:yetbota_mobile/app/theme/theme_cubit.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:yetbota_mobile/features/discovery_feed/presentation/pages/discovery_feed_page.dart';

class LocationFeedPage extends StatelessWidget {
  const LocationFeedPage({super.key, required this.token});

  final String token;

  static const _headerProfileImage =
      'https://www.figma.com/api/mcp/asset/9970d698-6dc8-4b66-9c79-17f3ccaadb45';
  static const _firstAuthorAvatar =
      'https://www.figma.com/api/mcp/asset/e702ce4c-9888-4fff-9f04-220d97ea0c6e';
  static const _firstPostImage =
      'https://www.figma.com/api/mcp/asset/559b498e-9bcf-4350-bb25-95a8966c3509';
  static const _secondAuthorAvatar =
      'https://www.figma.com/api/mcp/asset/0ed7f7e3-1955-409d-a808-288556f18dbe';
  static const _secondPostImage =
      'https://www.figma.com/api/mcp/asset/f261449f-2387-4073-ba32-386a08d86429';

  static const _posts = [
    _PostData(
      author: 'Dawit Tekle',
      location: 'LALIBELA, AMHARA',
      imageUrl: _firstPostImage,
      avatarUrl: _firstAuthorAvatar,
      likes: '4.8k',
      comments: '128',
      body:
          'The rock-hewn churches of Lalibela are truly a testament to faith and architecture. Breathtaking views during the morning prayers.',
      tags: ['#heritage', '#ethiopia', '#travel'],
      badge: 'Highly Rated',
    ),
    _PostData(
      author: 'Selam Ayele',
      location: 'UNITY PARK, ADDIS ABABA',
      imageUrl: _secondPostImage,
      avatarUrl: _secondAuthorAvatar,
      likes: '2.1k',
      comments: '45',
      body:
          'A wonderful afternoon at Unity Park. The mix of historical exhibits and beautiful gardens makes it a must-visit in Addis.',
      tags: ['#addisababa', '#unitypark'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = _LocationFeedPalette.of(context);
    return Scaffold(
      backgroundColor: palette.pageBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _TopHeader(
                    profileImageUrl: _headerProfileImage,
                    onProfileTap: () => _showProfileMenu(context),
                  ),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 448),
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
                          children: [
                            const _SearchBar(),
                            const SizedBox(height: 16),
                            const _FilterChips(),
                            const SizedBox(height: 24),
                            _FeedList(
                              posts: _posts,
                              onPostTap: () => _openDiscoveryFeed(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(left: 0, right: 0, bottom: 0, child: BottomNav()),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    final mode = context.read<ThemeCubit>().state;
    final palette = _LocationFeedPalette.of(context);
    final shortToken = token.length <= 14
        ? token
        : '${token.substring(0, 14)}...';
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: palette.sheetBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: palette.dragHandle,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 14),
              ListTile(
                title: Text(
                  'Signed-in token',
                  style: TextStyle(color: palette.primaryText),
                ),
                subtitle: Text(
                  shortToken,
                  style: TextStyle(color: palette.mutedText),
                ),
                leading: const Icon(
                  Icons.key_outlined,
                  color: Color(0xFF22C55E),
                ),
              ),
              _ThemeTile(
                title: 'Light',
                icon: Icons.wb_sunny_outlined,
                selected: mode == ThemeMode.light,
                onTap: () {
                  context.read<ThemeCubit>().setMode(ThemeMode.light);
                  Navigator.of(sheetContext).pop();
                },
              ),
              _ThemeTile(
                title: 'Dark',
                icon: Icons.nightlight_round,
                selected: mode == ThemeMode.dark,
                onTap: () {
                  context.read<ThemeCubit>().setMode(ThemeMode.dark);
                  Navigator.of(sheetContext).pop();
                },
              ),
              _ThemeTile(
                title: 'System',
                icon: Icons.settings_suggest_outlined,
                selected: mode == ThemeMode.system,
                onTap: () {
                  context.read<ThemeCubit>().setMode(ThemeMode.system);
                  Navigator.of(sheetContext).pop();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFF87171),
                ),
                title: Text(
                  'Sign out',
                  style: TextStyle(color: palette.primaryText),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.read<AuthBloc>().add(const AuthSignOutRequested());
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _openDiscoveryFeed(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const DiscoveryFeedPage()));
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader({required this.profileImageUrl, required this.onProfileTap});

  final String profileImageUrl;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    final palette = _LocationFeedPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        color: palette.headerBackground,
        border: Border(bottom: BorderSide(color: palette.headerBorder)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 448),
          child: SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/discover_icon.png',
                        width: 34,
                        height: 34,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Discover',
                        style: TextStyle(
                          color: palette.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications_none_rounded,
                              color: palette.iconSecondary,
                            ),
                          ),
                          const Positioned(
                            top: 10,
                            right: 12,
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: onProfileTap,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: palette.avatarBackground,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: palette.headerBorder),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _NetworkImageWithFallback(
                            imageUrl: profileImageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
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

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final palette = _LocationFeedPalette.of(context);
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: palette.surfaceSoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.borderSoft),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: palette.placeholderText, size: 18),
            const SizedBox(width: 10),
            Text(
              'Search Ethiopian locations...',
              style: TextStyle(color: palette.placeholderText, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          _PillChip(
            label: 'Proximity',
            icon: Icons.location_on_outlined,
            selected: true,
          ),
          SizedBox(width: 10),
          _PillChip(
            label: 'Trending',
            icon: Icons.local_fire_department_outlined,
          ),
          SizedBox(width: 10),
          _PillChip(label: 'Coffee Houses', icon: Icons.local_cafe_outlined),
          SizedBox(width: 10),
          _PillChip(label: 'Nature', icon: Icons.park_outlined),
        ],
      ),
    );
  }
}

class _FeedList extends StatelessWidget {
  const _FeedList({required this.posts, required this.onPostTap});

  final List<_PostData> posts;
  final VoidCallback onPostTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < posts.length; i++) ...[
          _PostCard(post: posts[i], onTap: onPostTap),
          if (i != posts.length - 1) const SizedBox(height: 24),
        ],
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.onTap});

  final _PostData post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = _LocationFeedPalette.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: palette.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.borderSoft),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PostHeader(post: post),
                const SizedBox(height: 16),
                _PostImage(post: post),
                const SizedBox(height: 14),
                _PostActions(post: post),
                const SizedBox(height: 12),
                Text(
                  post.body,
                  style: TextStyle(
                    color: palette.bodyText,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [for (final tag in post.tags) _TagChip(tag: tag)],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({required this.post});

  final _PostData post;

  @override
  Widget build(BuildContext context) {
    final palette = _LocationFeedPalette.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: palette.borderSoft),
              ),
              clipBehavior: Clip.antiAlias,
              child: _NetworkImageWithFallback(
                imageUrl: post.avatarUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.author,
                  style: TextStyle(
                    color: palette.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppTheme.primary,
                      size: 12,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      post.location,
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          visualDensity: VisualDensity.compact,
          icon: Icon(Icons.more_horiz_rounded, color: palette.iconSecondary),
        ),
      ],
    );
  }
}

class _PostImage extends StatelessWidget {
  const _PostImage({required this.post});

  final _PostData post;

  @override
  Widget build(BuildContext context) {
    final palette = _LocationFeedPalette.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AspectRatio(
        aspectRatio: 0.92,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _NetworkImageWithFallback(
              imageUrl: post.imageUrl,
              fit: BoxFit.cover,
            ),
            if (post.badge != null)
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xE622C55E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    post.badge!.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 16,
              bottom: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: palette.overlayPillBackground,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: palette.overlayPillBorder),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.map_outlined,
                          color: AppTheme.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Show on Map',
                          style: TextStyle(
                            color: palette.primaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostActions extends StatelessWidget {
  const _PostActions({required this.post});

  final _PostData post;

  @override
  Widget build(BuildContext context) {
    final palette = _LocationFeedPalette.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _Counter(icon: Icons.favorite_outline, value: post.likes),
            const SizedBox(width: 18),
            _Counter(
              icon: Icons.chat_bubble_outline_rounded,
              value: post.comments,
            ),
            const SizedBox(width: 18),
            Icon(
              Icons.share_outlined,
              color: palette.iconSecondary,
              size: 20,
            ),
          ],
        ),
        Icon(
          Icons.bookmark_border_rounded,
          color: palette.iconSecondary,
          size: 20,
        ),
      ],
    );
  }
}

class _NetworkImageWithFallback extends StatelessWidget {
  const _NetworkImageWithFallback({required this.imageUrl, this.fit});

  final String imageUrl;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    final palette = _LocationFeedPalette.of(context);
    return Image.network(
      imageUrl,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: palette.fallbackGradient,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: palette.iconSecondary,
            ),
          ),
        );
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return ColoredBox(color: palette.loadingFallback);
      },
    );
  }
}

class _PillChip extends StatelessWidget {
  const _PillChip({
    required this.label,
    required this.icon,
    this.selected = false,
  });

  final String label;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final palette = _LocationFeedPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: selected ? AppTheme.primary : palette.surfaceSoft,
        borderRadius: BorderRadius.circular(999),
        border: selected ? null : Border.all(color: palette.borderSoft),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: selected ? Colors.black : palette.bodyText,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.black : palette.bodyText,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    final palette = _LocationFeedPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: palette.tagBackground,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.borderSoft),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: AppTheme.primary,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = _LocationFeedPalette.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: palette.iconSecondary),
        const SizedBox(width: 6),
        Text(
          value,
          style: TextStyle(
            color: palette.iconSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = _LocationFeedPalette.of(context);
    return ListTile(
      leading: Icon(icon, color: palette.iconSecondary),
      title: Text(title, style: TextStyle(color: palette.primaryText)),
      trailing: selected
          ? const Icon(Icons.check, color: AppTheme.primary)
          : null,
      onTap: onTap,
    );
  }
}

class _LocationFeedPalette {
  const _LocationFeedPalette({
    required this.pageBackground,
    required this.cardBackground,
    required this.headerBackground,
    required this.headerBorder,
    required this.surfaceSoft,
    required this.borderSoft,
    required this.primaryText,
    required this.bodyText,
    required this.mutedText,
    required this.iconSecondary,
    required this.placeholderText,
    required this.avatarBackground,
    required this.tagBackground,
    required this.overlayPillBackground,
    required this.overlayPillBorder,
    required this.loadingFallback,
    required this.fallbackGradient,
    required this.sheetBackground,
    required this.dragHandle,
  });

  final Color pageBackground;
  final Color cardBackground;
  final Color headerBackground;
  final Color headerBorder;
  final Color surfaceSoft;
  final Color borderSoft;
  final Color primaryText;
  final Color bodyText;
  final Color mutedText;
  final Color iconSecondary;
  final Color placeholderText;
  final Color avatarBackground;
  final Color tagBackground;
  final Color overlayPillBackground;
  final Color overlayPillBorder;
  final Color loadingFallback;
  final List<Color> fallbackGradient;
  final Color sheetBackground;
  final Color dragHandle;

  static _LocationFeedPalette of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? const _LocationFeedPalette(
            pageBackground: AppTheme.darkBackground,
            cardBackground: Color(0xFF242926),
            headerBackground: Color(0xCC000000),
            headerBorder: Color(0x0DFFFFFF),
            surfaceSoft: Color(0x0DFFFFFF),
            borderSoft: Color(0x1AFFFFFF),
            primaryText: Colors.white,
            bodyText: Color(0xFFCBD5E1),
            mutedText: Color(0xFF94A3B8),
            iconSecondary: Color(0xFF94A3B8),
            placeholderText: Color(0xFF64748B),
            avatarBackground: Color(0xFF1E293B),
            tagBackground: Color(0x33000000),
            overlayPillBackground: Color(0x99000000),
            overlayPillBorder: Color(0x33FFFFFF),
            loadingFallback: Color(0xFF111827),
            fallbackGradient: [Color(0xFF1E293B), Color(0xFF0F172A)],
            sheetBackground: Color(0xFF121212),
            dragHandle: Colors.white24,
          )
        : const _LocationFeedPalette(
            pageBackground: Color(0xFFF8FAFC),
            cardBackground: Colors.white,
            headerBackground: Color(0xF2FFFFFF),
            headerBorder: Color(0x14000000),
            surfaceSoft: Color(0xFFF1F5F9),
            borderSoft: Color(0x14000000),
            primaryText: Color(0xFF0F172A),
            bodyText: Color(0xFF334155),
            mutedText: Color(0xFF64748B),
            iconSecondary: Color(0xFF64748B),
            placeholderText: Color(0xFF64748B),
            avatarBackground: Color(0xFFE2E8F0),
            tagBackground: Color(0x0A0F172A),
            overlayPillBackground: Color(0xE6FFFFFF),
            overlayPillBorder: Color(0x14000000),
            loadingFallback: Color(0xFFE2E8F0),
            fallbackGradient: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
            sheetBackground: Color(0xFFFFFFFF),
            dragHandle: Color(0x33000000),
          );
  }
}

class _PostData {
  const _PostData({
    required this.author,
    required this.location,
    required this.imageUrl,
    required this.avatarUrl,
    required this.likes,
    required this.comments,
    required this.body,
    required this.tags,
    this.badge,
  });

  final String author;
  final String location;
  final String imageUrl;
  final String avatarUrl;
  final String likes;
  final String comments;
  final String body;
  final List<String> tags;
  final String? badge;
}
