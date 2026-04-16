import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/common/ui/widgets/bottom_nav.dart';

class DiscoveryFeedPage extends StatefulWidget {
  const DiscoveryFeedPage({super.key});

  @override
  State<DiscoveryFeedPage> createState() => _DiscoveryFeedPageState();
}

class _DiscoveryFeedPageState extends State<DiscoveryFeedPage> {
  static const _post = _DiscoveryPost(
    avatarUrl:
        'https://www.figma.com/api/mcp/asset/ae191cce-f57d-4cc9-b2b6-b540061423a1',
    title: 'Lalibela Rock Churches',
    location: 'AMHARA, ET',
    handle: '@dawit_tekle',
    likes: '12.4k',
    comments: '452',
    description:
        'Exploring the 12th-century monoliths of Lalibela. A true spiritual and architectural wonder carved deep into the earth. #YetBota #Ethiopia #History',
  );

  static const _media = [
    _PostMedia(
      url:
          'https://www.figma.com/api/mcp/asset/3a2ce89e-ccce-477f-89f6-6f2c9593b987',
    ),
    _PostMedia(
      url:
          'https://www.figma.com/api/mcp/asset/559b498e-9bcf-4350-bb25-95a8966c3509',
    ),
    _PostMedia(
      url:
          'https://www.figma.com/api/mcp/asset/f261449f-2387-4073-ba32-386a08d86429',
    ),
    _PostMedia(
      url:
          'https://www.figma.com/api/mcp/asset/3a2ce89e-ccce-477f-89f6-6f2c9593b987',
      type: DiscoveryMediaType.video,
    ),
  ];
  static const _initialLoopPage = 4000;

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialLoopPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = _DiscoveryFeedPalette.of(context);
    return Scaffold(
      backgroundColor: palette.pageBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              physics: const PageScrollPhysics(),
              itemBuilder: (context, index) {
                final mediaItem = _media[_mediaIndexForPage(index)];
                return _MediaSlide(item: mediaItem);
              },
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Container(color: palette.mediaDimOverlay),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const _TopHeader(),
                  const Spacer(),
                  IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        final activeIndex = _dotIndexFromController();
                        return _BottomInfoOverlay(
                          post: _post,
                          activeIndex: activeIndex,
                          totalSlides: _media.length,
                          onDotTap: _goToSlide,
                        );
                      },
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
            child: BottomNav(activeItem: BottomNavItem.feed),
          ),
        ],
      ),
    );
  }

  void _goToSlide(int index) {
    final normalizedIndex =
        ((index % _media.length) + _media.length) % _media.length;
    final currentPage = _pageController.page?.round() ?? _initialLoopPage;
    final currentIndex = _mediaIndexForPage(currentPage);
    var logicalDelta = normalizedIndex - currentIndex;
    if (logicalDelta.abs() > _media.length / 2) {
      logicalDelta += logicalDelta > 0 ? -_media.length : _media.length;
    }
    final targetPage = currentPage - logicalDelta;
    _pageController.animateToPage(
      targetPage,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  int _mediaIndexForPage(int page) {
    var index = -page % _media.length;
    if (index < 0) index += _media.length;
    return index;
  }

  int _activeIndexFromController() {
    final page = _pageController.hasClients
        ? (_pageController.page ?? _initialLoopPage.toDouble())
        : _initialLoopPage.toDouble();
    return _mediaIndexForPage(page.round());
  }

  int _dotIndexFromController() {
    final activeIndex = _activeIndexFromController();
    return (_media.length - activeIndex) % _media.length;
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    final palette = _DiscoveryFeedPalette.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: palette.tabBarBackground,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: palette.tabBarBorder),
                ),
                child: const Row(
                  children: [
                    _HeaderTab(label: 'Discover', active: true),
                    SizedBox(width: 18),
                    _HeaderTab(label: 'Following'),
                  ],
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: palette.glassBackground,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: palette.glassBorder,
                  ),
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: palette.primaryText,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderTab extends StatelessWidget {
  const _HeaderTab({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final palette = _DiscoveryFeedPalette.of(context);
    final color = active ? palette.tabActiveText : palette.tabInactiveText;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: active ? 62 : 0,
          height: 2,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    );
  }
}

class _RightActionRail extends StatelessWidget {
  const _RightActionRail({
    required this.avatarUrl,
    required this.likes,
    required this.comments,
  });

  final String avatarUrl;
  final String likes;
  final String comments;

  @override
  Widget build(BuildContext context) {
    final palette = _DiscoveryFeedPalette.of(context);
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: palette.primaryText, width: 2),
              ),
              clipBehavior: Clip.antiAlias,
              child: _NetworkImageWithFallback(
                imageUrl: avatarUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: -7,
              child: Center(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: palette.primaryBorder, width: 2),
                  ),
                  child: Icon(Icons.add, color: palette.primaryBorder, size: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _ActionCount(icon: Icons.thumb_up_rounded, label: likes),
        const SizedBox(height: 20),
        const _ActionCount(
          icon: Icons.thumb_down_off_alt_outlined,
          label: 'Dislike',
        ),
        const SizedBox(height: 20),
        _ActionCount(icon: Icons.mode_comment_outlined, label: comments),
        const SizedBox(height: 20),
        Icon(Icons.more_vert_rounded, color: palette.secondaryText),
      ],
    );
  }
}

class _ActionCount extends StatelessWidget {
  const _ActionCount({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = _DiscoveryFeedPalette.of(context);
    return Column(
      children: [
        Icon(icon, color: palette.primaryText, size: 34),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: palette.primaryText,
            fontSize: 26 * 0.46,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _BottomInfoOverlay extends StatelessWidget {
  const _BottomInfoOverlay({
    required this.post,
    required this.activeIndex,
    required this.totalSlides,
    required this.onDotTap,
  });

  final _DiscoveryPost post;
  final int activeIndex;
  final int totalSlides;
  final ValueChanged<int> onDotTap;

  @override
  Widget build(BuildContext context) {
    final palette = _DiscoveryFeedPalette.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: palette.bottomGradient,
          stops: [0, 0.65, 1],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 124),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CarouselDots(
                      activeIndex: activeIndex,
                      total: totalSlides,
                      onDotTap: onDotTap,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            post.title,
                            style: TextStyle(
                              color: palette.primaryText,
                              fontSize: 38 * 0.52,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: palette.bottomAccent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: palette.bottomAccent.withValues(alpha: 0.32),
                            ),
                          ),
                          child: Text(
                            post.location,
                            style: TextStyle(
                              color: palette.bottomAccent,
                              fontSize: 10,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          post.handle,
                          style: TextStyle(
                            color: palette.bottomAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: palette.glassBackground,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: palette.glassBorder,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified_user_outlined,
                                    color: palette.bottomAccent,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'TOP GUIDE',
                                    style: TextStyle(
                                      color: palette.primaryText,
                                      fontSize: 10,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.description,
                      style: TextStyle(
                        color: palette.bodyText,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: palette.glassBackground,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: palette.glassBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.map_outlined,
                                color: AppTheme.primary,
                                size: 12,
                              ),
                              const SizedBox(width: 8),
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
                  ],
                ),
              ),
              const SizedBox(width: 14),
              _RightActionRail(
                avatarUrl: post.avatarUrl,
                likes: post.likes,
                comments: post.comments,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CarouselDots extends StatelessWidget {
  const _CarouselDots({
    required this.activeIndex,
    required this.total,
    required this.onDotTap,
  });

  final int activeIndex;
  final int total;
  final ValueChanged<int> onDotTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onDotTap(activeIndex - 1),
          child: Icon(
            Icons.chevron_left_rounded,
            color: AppTheme.primary,
            size: 16,
          ),
        ),
        const SizedBox(width: 6),
        for (var i = 0; i < total; i++) ...[
          GestureDetector(
            onTap: () => onDotTap(i),
            child: _Dot(active: i == activeIndex),
          ),
          if (i != total - 1) const SizedBox(width: 6),
        ],
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () => onDotTap(activeIndex + 1),
          child: Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.primary,
            size: 16,
          ),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({this.active = false});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final palette = _DiscoveryFeedPalette.of(context);
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? AppTheme.primary : palette.inactiveDot,
        shape: BoxShape.circle,
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
    final palette = _DiscoveryFeedPalette.of(context);
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
              color: palette.secondaryText,
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

class _MediaSlide extends StatelessWidget {
  const _MediaSlide({required this.item});

  final _PostMedia item;

  @override
  Widget build(BuildContext context) {
    final palette = _DiscoveryFeedPalette.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        _NetworkImageWithFallback(imageUrl: item.url, fit: BoxFit.cover),
        if (item.type == DiscoveryMediaType.video)
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: palette.videoOverlay,
                shape: BoxShape.circle,
                border: Border.all(color: palette.videoOverlayBorder),
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: palette.primaryText,
                size: 40,
              ),
            ),
          ),
      ],
    );
  }
}

enum DiscoveryMediaType { image, video }

class _PostMedia {
  const _PostMedia({required this.url, this.type = DiscoveryMediaType.image});

  final String url;
  final DiscoveryMediaType type;
}

class _DiscoveryPost {
  const _DiscoveryPost({
    required this.avatarUrl,
    required this.title,
    required this.location,
    required this.handle,
    required this.likes,
    required this.comments,
    required this.description,
  });

  final String avatarUrl;
  final String title;
  final String location;
  final String handle;
  final String likes;
  final String comments;
  final String description;
}

class _DiscoveryFeedPalette {
  const _DiscoveryFeedPalette({
    required this.pageBackground,
    required this.primaryText,
    required this.secondaryText,
    required this.bodyText,
    required this.glassBackground,
    required this.glassBorder,
    required this.bottomGradient,
    required this.inactiveDot,
    required this.fallbackGradient,
    required this.loadingFallback,
    required this.videoOverlay,
    required this.videoOverlayBorder,
    required this.mediaDimOverlay,
    required this.primaryBorder,
    required this.bottomAccent,
    required this.tabBarBackground,
    required this.tabBarBorder,
    required this.tabActiveText,
    required this.tabInactiveText,
  });

  final Color pageBackground;
  final Color primaryText;
  final Color secondaryText;
  final Color bodyText;
  final Color glassBackground;
  final Color glassBorder;
  final List<Color> bottomGradient;
  final Color inactiveDot;
  final List<Color> fallbackGradient;
  final Color loadingFallback;
  final Color videoOverlay;
  final Color videoOverlayBorder;
  final Color mediaDimOverlay;
  final Color primaryBorder;
  final Color bottomAccent;
  final Color tabBarBackground;
  final Color tabBarBorder;
  final Color tabActiveText;
  final Color tabInactiveText;

  static _DiscoveryFeedPalette of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? const _DiscoveryFeedPalette(
            pageBackground: Colors.black,
            primaryText: Colors.white,
            secondaryText: Color(0xB3FFFFFF),
            bodyText: Color(0xE6FFFFFF),
            glassBackground: Color(0x1AFFFFFF),
            glassBorder: Color(0x33FFFFFF),
            bottomGradient: [Color(0x00000000), Color(0xCC000000), Color(0xFF000000)],
            inactiveDot: Color(0x4DFFFFFF),
            fallbackGradient: [Color(0xFF1E293B), Color(0xFF0F172A)],
            loadingFallback: Color(0xFF111827),
            videoOverlay: Color(0x73000000),
            videoOverlayBorder: Color(0x59FFFFFF),
            mediaDimOverlay: Color(0x33000000),
            primaryBorder: Colors.black,
            bottomAccent: Color(0xFF16A34A),
            tabBarBackground: Color(0x1F000000),
            tabBarBorder: Color(0x33FFFFFF),
            tabActiveText: Colors.white,
            tabInactiveText: Color(0xB3FFFFFF),
          )
        : const _DiscoveryFeedPalette(
            pageBackground: Color(0xFFF8FAFC),
            primaryText: Color(0xFF0F172A),
            secondaryText: Color(0xCC334155),
            bodyText: Color(0xE6334155),
            glassBackground: Color(0xCCFFFFFF),
            glassBorder: Color(0x14000000),
            bottomGradient: [Color(0x00FFFFFF), Color(0xD9FFFFFF), Color(0xF5FFFFFF)],
            inactiveDot: Color(0x4D334155),
            fallbackGradient: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
            loadingFallback: Color(0xFFE2E8F0),
            videoOverlay: Color(0xBFFFFFFF),
            videoOverlayBorder: Color(0x1A0F172A),
            mediaDimOverlay: Color(0x14FFFFFF),
            primaryBorder: Colors.white,
            bottomAccent: Color(0xFF15803D),
            tabBarBackground: Color(0xCCFFFFFF),
            tabBarBorder: Color(0x26000000),
            tabActiveText: Color(0xFF0F172A),
            tabInactiveText: Color(0xFF334155),
          );
  }
}
