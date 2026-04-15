import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/app/theme/theme_cubit.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_event.dart';

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
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
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
                          children: const [
                            _SearchBar(),
                            SizedBox(height: 16),
                            _FilterChips(),
                            SizedBox(height: 24),
                            _FeedList(posts: _posts),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomNavBar(),
          ),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    final mode = context.read<ThemeCubit>().state;
    final shortToken = token.length <= 14
        ? token
        : '${token.substring(0, 14)}...';
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF121212),
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
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 14),
              ListTile(
                title: const Text(
                  'Signed-in token',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  shortToken,
                  style: const TextStyle(color: Color(0xFF94A3B8)),
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
                title: const Text(
                  'Sign out',
                  style: TextStyle(color: Colors.white),
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
}

class _TopHeader extends StatelessWidget {
  const _TopHeader({required this.profileImageUrl, required this.onProfileTap});

  final String profileImageUrl;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xCC000000),
        border: Border(bottom: BorderSide(color: Color(0x0DFFFFFF))),
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
                      const Text(
                        'Discover',
                        style: TextStyle(
                          color: Colors.white,
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
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              color: Color(0xFFCBD5E1),
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
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: const Color(0x1AFFFFFF)),
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
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0x0DFFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1AFFFFFF)),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 18),
            SizedBox(width: 10),
            Text(
              'Search Ethiopian locations...',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
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
  const _FeedList({required this.posts});

  final List<_PostData> posts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < posts.length; i++) ...[
          _PostCard(post: posts[i]),
          if (i != posts.length - 1) const SizedBox(height: 24),
        ],
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final _PostData post;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF242926),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x0DFFFFFF)),
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
              style: const TextStyle(
                color: Color(0xFFCBD5E1),
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
    );
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({required this.post});

  final _PostData post;

  @override
  Widget build(BuildContext context) {
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
                border: Border.all(color: const Color(0x1AFFFFFF)),
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
                  style: const TextStyle(
                    color: Colors.white,
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
          icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF94A3B8)),
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
                      color: const Color(0x99000000),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0x33FFFFFF)),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.map_outlined,
                          color: AppTheme.primary,
                          size: 14,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Show on Map',
                          style: TextStyle(
                            color: Colors.white,
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
            const Icon(
              Icons.share_outlined,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
          ],
        ),
        const Icon(
          Icons.bookmark_border_rounded,
          color: Color(0xFF94A3B8),
          size: 20,
        ),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    const fabSize = 56.0;
    const fabRadius = fabSize / 2;
    const navTopInset = fabRadius;
    const navBodyHeight = 64.0;
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
                  decoration: const BoxDecoration(
                    color: Color(0xF2000000),
                    border: Border(top: BorderSide(color: Color(0x1AFFFFFF))),
                  ),
                  padding: EdgeInsets.only(bottom: bottomInset + 2),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 448),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(14, 8, 14, 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _NavItem(
                              icon: Icons.home_filled,
                              label: 'Feed',
                              active: true,
                            ),
                            _NavItem(
                              icon: Icons.question_answer_outlined,
                              label: 'Q&A',
                            ),
                            SizedBox(width: 72),
                            _NavItem(
                              icon: Icons.assistant_outlined,
                              label: 'AI Assistant',
                            ),
                            _NavItem(
                              icon: Icons.person_outline_rounded,
                              label: 'Profile',
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
              child: Container(
                width: fabSize,
                height: fabSize,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.38),
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkImageWithFallback extends StatelessWidget {
  const _NetworkImageWithFallback({required this.imageUrl, this.fit});

  final String imageUrl;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Color(0xFF94A3B8),
            ),
          ),
        );
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const ColoredBox(color: Color(0xFF111827));
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: selected ? AppTheme.primary : const Color(0x0DFFFFFF),
        borderRadius: BorderRadius.circular(999),
        border: selected ? null : Border.all(color: const Color(0x1AFFFFFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: selected ? Colors.black : const Color(0xFFCBD5E1),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.black : const Color(0xFFCBD5E1),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0x33000000),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x0DFFFFFF)),
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
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppTheme.primary : const Color(0xFF64748B);
    return SizedBox(
      width: label == 'AI Assistant' ? 66 : 52,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 19, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
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
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFCBD5E1)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: selected
          ? const Icon(Icons.check, color: AppTheme.primary)
          : null,
      onTap: onTap,
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
