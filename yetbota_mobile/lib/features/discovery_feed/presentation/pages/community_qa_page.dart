import 'package:flutter/material.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/common/ui/widgets/bottom_nav.dart';
import 'package:yetbota_mobile/features/discovery_feed/presentation/pages/ask_question_page.dart';
import 'package:yetbota_mobile/features/discovery_feed/presentation/pages/community_qa_detail_page.dart';

const _qaFilters = ['All', 'Housing', 'Safety', 'Nightlife'];

class CommunityQaPage extends StatelessWidget {
  const CommunityQaPage({super.key});

  static const _firstAuthorAvatar =
      'https://www.figma.com/api/mcp/asset/a6bd2d1a-6f38-4a8f-a97f-ad037389e27e';
  static const _firstPostImage =
      'https://www.figma.com/api/mcp/asset/02453409-3395-4b75-a3bc-b502585a0e92';
  static const _secondAuthorAvatar =
      'https://www.figma.com/api/mcp/asset/4c53dc73-a8b4-44d7-bea2-34433af22d31';

  static const _questions = [
    _QaQuestion(
      author: 'Sarah Jenkins',
      badge: 'Expert Guide',
      meta: '2 miles away • 15m ago',
      title:
          'How is the parking situation near 5th and Main during the festival?',
      body:
          "I'm planning to drive down this weekend but heard some streets are closed. Any specific lots...",
      avatarUrl: _firstAuthorAvatar,
      imageUrl: _firstPostImage,
      upVotes: '124',
      replies: '45',
      tag: null,
    ),
    _QaQuestion(
      author: 'Marcus Chen',
      badge: 'Local Legend',
      meta: '0.5 miles away • 2h ago',
      title: 'Anyone know why the police have the dog park cordoned off?',
      body:
          'Just walked by and there are three cruisers and tape around the main entrance.',
      avatarUrl: _secondAuthorAvatar,
      upVotes: '82',
      replies: '12',
      tag: 'Safety',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = _QaPalette.of(context);
    return Scaffold(
      backgroundColor: palette.pageBackground,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _Header(
                  palette: palette,
                  onPostTap: () => _openAskQuestion(context),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 448),
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
                        children: [
                          _SearchBar(palette: palette),
                          const SizedBox(height: 16),
                          _FilterChips(palette: palette),
                          const SizedBox(height: 24),
                          ..._questions.map(
                            (question) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: _QuestionCard(
                                question: question,
                                palette: palette,
                                onTap: () =>
                                    _openQuestionDetail(context, question),
                              ),
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNav(
              activeItem: BottomNavItem.qna,
              onItemTapped: (item) => _handleNavTap(context, item),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavTap(BuildContext context, BottomNavItem item) {
    if (item == BottomNavItem.qna) return;
    if (item == BottomNavItem.feed) {
      Navigator.of(context).maybePop();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name.toUpperCase()} is coming soon.'),
        duration: const Duration(milliseconds: 1100),
      ),
    );
  }

  void _openQuestionDetail(BuildContext context, _QaQuestion question) {
    final relativeTime = question.meta.contains('•')
        ? question.meta.split('•').last.trim()
        : question.meta;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CommunityQaDetailPage(
          questionTitle: question.title,
          questionBody: question.body.replaceAll('...', '.'),
          tagLabel: question.tag == null ? 'Parks & Rec' : question.tag!,
          askedLabel: 'Asked $relativeTime',
          questionImageUrl: question.imageUrl,
        ),
      ),
    );
  }

  void _openAskQuestion(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AskQuestionPage()),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.palette, required this.onPostTap});

  final _QaPalette palette;
  final VoidCallback onPostTap;

  @override
  Widget build(BuildContext context) {
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
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: palette.primaryText,
                        size: 21,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Yet Bota QA',
                        style: TextStyle(
                          color: palette.primaryText,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onPostTap,
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Post',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: palette.softSurface,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          color: palette.iconColor,
                          size: 20,
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
  const _SearchBar({required this.palette});

  final _QaPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: palette.softSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.softBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: palette.mutedText, size: 18),
          const SizedBox(width: 10),
          Text(
            'Search community questions...',
            style: TextStyle(color: palette.placeholderText, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.palette});

  final _QaPalette palette;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final label = _qaFilters[index];
          final isActive = index == 0;
          return Container(
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primary : palette.softSurface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isActive ? Colors.transparent : palette.softBorder,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                color: isActive ? Colors.black : palette.secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemCount: _qaFilters.length,
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.palette,
    required this.onTap,
  });

  final _QaQuestion question;
  final _QaPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: palette.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.cardBorder),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(question.avatarUrl),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          children: [
                            Text(
                              question.author,
                              style: TextStyle(
                                color: palette.primaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            _ExpertBadge(
                              label: question.badge,
                              palette: palette,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          question.meta,
                          style: TextStyle(
                            color: palette.mutedText,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -16),
                    child: Icon(
                      Icons.more_horiz,
                      color: palette.mutedText,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                question.title,
                style: TextStyle(
                  color: palette.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                question.body,
                style: TextStyle(
                  color: palette.secondaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              if (question.imageUrl != null) ...[
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 322 / 208,
                    child: Image.network(question.imageUrl!, fit: BoxFit.cover),
                  ),
                ),
              ],
              if (question.tag != null) ...[
                const SizedBox(height: 14),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.24),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 5,
                  ),
                  child: Text(
                    question.tag!.toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0x1AFFFFFF)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: palette.softSurface,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: palette.softBorder),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          size: 18,
                          color: palette.mutedText,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          question.upVotes,
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.arrow_downward,
                          size: 18,
                          color: palette.mutedText,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.mode_comment_outlined,
                        size: 18,
                        color: palette.mutedText,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        question.replies,
                        style: TextStyle(
                          color: palette.mutedText,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Icon(
                        Icons.share_outlined,
                        size: 18,
                        color: palette.mutedText,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpertBadge extends StatelessWidget {
  const _ExpertBadge({required this.label, required this.palette});

  final String label;
  final _QaPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.1),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.28)),
        borderRadius: BorderRadius.circular(3),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Text(
        label.trim().replaceAll(RegExp(r'\s+'), ' ').toUpperCase(),
        style: TextStyle(
          color: AppTheme.primary,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.45,
        ),
      ),
    );
  }
}

class _QaQuestion {
  const _QaQuestion({
    required this.author,
    required this.badge,
    required this.meta,
    required this.title,
    required this.body,
    required this.avatarUrl,
    required this.upVotes,
    required this.replies,
    this.imageUrl,
    this.tag,
  });

  final String author;
  final String badge;
  final String meta;
  final String title;
  final String body;
  final String avatarUrl;
  final String upVotes;
  final String replies;
  final String? imageUrl;
  final String? tag;
}

class _QaPalette {
  const _QaPalette({
    required this.pageBackground,
    required this.headerBackground,
    required this.headerBorder,
    required this.cardBackground,
    required this.cardBorder,
    required this.softSurface,
    required this.softBorder,
    required this.primaryText,
    required this.secondaryText,
    required this.placeholderText,
    required this.mutedText,
    required this.iconColor,
  });

  final Color pageBackground;
  final Color headerBackground;
  final Color headerBorder;
  final Color cardBackground;
  final Color cardBorder;
  final Color softSurface;
  final Color softBorder;
  final Color primaryText;
  final Color secondaryText;
  final Color placeholderText;
  final Color mutedText;
  final Color iconColor;

  factory _QaPalette.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const _QaPalette(
        pageBackground: Color(0xFF000000),
        headerBackground: Color(0xE6000000),
        headerBorder: Color(0x1AFFFFFF),
        cardBackground: Color(0xFF0A0A0A),
        cardBorder: Color(0x1AFFFFFF),
        softSurface: Color(0x0DFFFFFF),
        softBorder: Color(0x1AFFFFFF),
        primaryText: Color(0xFFFFFFFF),
        secondaryText: Color(0x99FFFFFF),
        placeholderText: Color(0x4DFFFFFF),
        mutedText: Color(0x66FFFFFF),
        iconColor: Color(0xFFFFFFFF),
      );
    }
    return const _QaPalette(
      pageBackground: Color(0xFFF8FAFC),
      headerBackground: Color(0xF2FFFFFF),
      headerBorder: Color(0x14000000),
      cardBackground: Color(0xFFFFFFFF),
      cardBorder: Color(0x14000000),
      softSurface: Color(0xFFF3F4F6),
      softBorder: Color(0x1A000000),
      primaryText: Color(0xFF111827),
      secondaryText: Color(0xFF4B5563),
      placeholderText: Color(0xFF9CA3AF),
      mutedText: Color(0xFF6B7280),
      iconColor: Color(0xFF111827),
    );
  }
}
