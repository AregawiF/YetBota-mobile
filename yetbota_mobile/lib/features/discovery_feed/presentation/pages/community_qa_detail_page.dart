import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';

class CommunityQaDetailPage extends StatelessWidget {
  const CommunityQaDetailPage({
    super.key,
    required this.questionTitle,
    required this.questionBody,
    required this.tagLabel,
    required this.askedLabel,
    this.questionImageUrl,
  });

  final String questionTitle;
  final String questionBody;
  final String tagLabel;
  final String askedLabel;
  final String? questionImageUrl;

  static const _defaultQuestionImage =
      'https://www.figma.com/api/mcp/asset/385c5d75-bfc9-45c2-a42e-616259996c8a';
  static const _topAnswerAvatar =
      'https://www.figma.com/api/mcp/asset/1a4f4b88-cdb0-48e7-9931-06f6cd8fcc23';
  static const _secondAnswerAvatar =
      'https://www.figma.com/api/mcp/asset/4981674e-fb94-402b-99d2-96914026f9f7';

  @override
  Widget build(BuildContext context) {
    final palette = _QaDetailPalette.of(context);
    final heroImage = questionImageUrl ?? _defaultQuestionImage;
    return Scaffold(
      backgroundColor: palette.pageBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(
              palette: palette,
              onBackTap: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 160),
                    children: [
                      _QuestionHero(imageUrl: heroImage, palette: palette),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            child: const Text(
                              'LOCAL INSIGHT',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            askedLabel,
                            style: TextStyle(
                              color: palette.metaText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        questionTitle,
                        style: TextStyle(
                          color: palette.primaryText,
                          fontSize: 24,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        questionBody,
                        style: TextStyle(
                          color: palette.secondaryText,
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: palette.softSurface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: palette.softBorder),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 7,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.park_outlined,
                                size: 12,
                                color: palette.secondaryText,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                tagLabel,
                                style: TextStyle(
                                  color: palette.secondaryText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: palette.sectionBorder,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '24 COMMUNITY ANSWERS',
                              style: TextStyle(
                                color: palette.metaText,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.65,
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Top Rated',
                                  style: TextStyle(
                                    color: AppTheme.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppTheme.primary,
                                  size: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _AnswerCard(
                        palette: palette,
                        highlighted: true,
                        score: '142',
                        author: 'Alex Rivera',
                        badge: 'Local Guide',
                        timeAgo: '45m ago',
                        avatarUrl: _topAnswerAvatar,
                        body:
                            "Check out Elizabeth Street Garden. It's exactly what you're looking for. Very hidden, lots of statues, and plenty of benches for reading.",
                        replyLabel: 'Reply',
                        nestedReply: const _NestedReplyData(
                          score: '8',
                          author: 'Sarah Chen',
                          timeAgo: '30m ago',
                          body:
                              'The cats there are so friendly too! Perfect reading companions.',
                        ),
                        showMoreComments: 'SHOW 4 MORE COMMENTS...',
                      ),
                      const SizedBox(height: 14),
                      _AnswerCard(
                        palette: palette,
                        highlighted: true,
                        score: '89',
                        author: 'Sarah Chen',
                        badge: 'Reading Enthusiast',
                        timeAgo: '1h ago',
                        avatarUrl: _secondAnswerAvatar,
                        body:
                            "There's a tiny pocket park on 2nd and Main. It has a beautiful waterfall wall that masks the city noise perfectly.",
                        replyLabel: 'Reply',
                      ),
                      const SizedBox(height: 18),
                      _YourAnswerComposer(palette: palette),
                    ],
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.palette, required this.onBackTap});

  final _QaDetailPalette palette;
  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: palette.headerBackground,
            border: Border(bottom: BorderSide(color: palette.sectionBorder)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                child: IconButton(
                  onPressed: onBackTap,
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: palette.primaryText,
                    size: 19,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Question Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: palette.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                width: 56,
                child: Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestionHero extends StatelessWidget {
  const _QuestionHero({required this.imageUrl, required this.palette});

  final String imageUrl;
  final _QaDetailPalette palette;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1.83,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, palette.pageBackground],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Icon(
                Icons.place_rounded,
                color: Color.alphaBlend(
                  Colors.black.withValues(alpha: 0.28),
                  AppTheme.primary,
                ),
                size: 42,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  const _AnswerCard({
    required this.palette,
    required this.highlighted,
    required this.score,
    required this.author,
    required this.badge,
    required this.timeAgo,
    required this.avatarUrl,
    required this.body,
    required this.replyLabel,
    this.nestedReply,
    this.showMoreComments,
  });

  final _QaDetailPalette palette;
  final bool highlighted;
  final String score;
  final String author;
  final String badge;
  final String timeAgo;
  final String avatarUrl;
  final String body;
  final String replyLabel;
  final _NestedReplyData? nestedReply;
  final String? showMoreComments;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: highlighted ? palette.answerHighlight : palette.answerBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlighted
              ? palette.answerHighlightBorder
              : palette.answerBorder,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 44,
                child: Column(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: palette.iconMuted,
                    ),
                    SizedBox(
                      width: 44,
                      height: 24,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _formatVoteCount(score),
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: palette.iconMuted,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(avatarUrl),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    author,
                                    style: TextStyle(
                                      color: palette.primaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppTheme.primary.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),
                                    child: Text(
                                      badge.toUpperCase(),
                                      style: const TextStyle(
                                        color: AppTheme.primary,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 1),
                              Text(
                                timeAgo,
                                style: TextStyle(
                                  color: palette.metaText,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.flag_outlined,
                          color: palette.iconMuted,
                          size: 14,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      body,
                      style: TextStyle(
                        color: palette.answerText,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.reply_rounded,
                          color: palette.iconMuted,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          replyLabel,
                          style: TextStyle(
                            color: palette.iconMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (nestedReply != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.only(left: 2),
                        padding: const EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: palette.answerBorder),
                          ),
                        ),
                        child: _NestedReply(
                          palette: palette,
                          data: nestedReply!,
                        ),
                      ),
                    ],
                    if (showMoreComments != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        showMoreComments!,
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _formatVoteCount(String rawCount) {
  final parsed = int.tryParse(rawCount.replaceAll(',', ''));
  if (parsed == null) return rawCount;
  if (parsed <= 9999) return parsed.toString();
  if (parsed < 100000) {
    final compact = (parsed / 1000).toStringAsFixed(1);
    final normalized = compact.endsWith('.0')
        ? compact.substring(0, compact.length - 2)
        : compact;
    return '${normalized}k';
  }
  return '${(parsed / 1000).round()}k';
}

class _NestedReply extends StatelessWidget {
  const _NestedReply({required this.palette, required this.data});

  final _QaDetailPalette palette;
  final _NestedReplyData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 16,
          child: Column(
            children: [
              Icon(
                Icons.keyboard_arrow_up_rounded,
                color: palette.iconMuted,
                size: 12,
              ),
              Text(
                data.score,
                style: TextStyle(
                  color: palette.iconMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: palette.iconMuted,
                size: 12,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    data.author,
                    style: TextStyle(
                      color: palette.secondaryText,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    data.timeAgo,
                    style: TextStyle(color: palette.metaText, fontSize: 9),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                data.body,
                style: TextStyle(
                  color: palette.iconMuted,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'REPLY',
                style: TextStyle(
                  color: palette.metaText,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _YourAnswerComposer extends StatelessWidget {
  const _YourAnswerComposer({required this.palette});

  final _QaDetailPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.composerBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.answerBorder),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR ANSWER',
            style: TextStyle(
              color: palette.metaText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: palette.softSurface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: palette.softBorder),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Type your answer...',
                        style: TextStyle(color: palette.metaText, fontSize: 14),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.image_outlined,
                        color: palette.metaText,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.2),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.black,
                  size: 19,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NestedReplyData {
  const _NestedReplyData({
    required this.score,
    required this.author,
    required this.timeAgo,
    required this.body,
  });

  final String score;
  final String author;
  final String timeAgo;
  final String body;
}

class _QaDetailPalette {
  const _QaDetailPalette({
    required this.pageBackground,
    required this.headerBackground,
    required this.sectionBorder,
    required this.answerBackground,
    required this.answerBorder,
    required this.answerHighlight,
    required this.answerHighlightBorder,
    required this.composerBackground,
    required this.softSurface,
    required this.softBorder,
    required this.primaryText,
    required this.secondaryText,
    required this.answerText,
    required this.metaText,
    required this.iconMuted,
  });

  final Color pageBackground;
  final Color headerBackground;
  final Color sectionBorder;
  final Color answerBackground;
  final Color answerBorder;
  final Color answerHighlight;
  final Color answerHighlightBorder;
  final Color composerBackground;
  final Color softSurface;
  final Color softBorder;
  final Color primaryText;
  final Color secondaryText;
  final Color answerText;
  final Color metaText;
  final Color iconMuted;

  factory _QaDetailPalette.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const _QaDetailPalette(
        pageBackground: Color(0xFF000000),
        headerBackground: Color(0xCC000000),
        sectionBorder: Color(0x1AFFFFFF),
        answerBackground: Color(0x8018181B),
        answerBorder: Color(0x1AFFFFFF),
        answerHighlight: AppTheme.primary500a0F,
        answerHighlightBorder: AppTheme.primary500a1F,
        composerBackground: Color(0x8018181B),
        softSurface: Color(0xFF18181B),
        softBorder: Color(0x1AFFFFFF),
        primaryText: Color(0xFFFFFFFF),
        secondaryText: Color(0xFFD4D4D8),
        answerText: Color(0xFFE4E4E7),
        metaText: Color(0xFF71717A),
        iconMuted: Color(0xFFA1A1AA),
      );
    }
    return const _QaDetailPalette(
      pageBackground: Color(0xFFF8FAFC),
      headerBackground: Color(0xF2FFFFFF),
      sectionBorder: Color(0x14000000),
      answerBackground: Color(0x80FFFFFF),
      answerBorder: Color(0x14000000),
      answerHighlight: AppTheme.primary500a0F,
      answerHighlightBorder: AppTheme.primary500a1F,
      composerBackground: Color(0xFFFFFFFF),
      softSurface: Color(0xFFF3F4F6),
      softBorder: Color(0x1A000000),
      primaryText: Color(0xFF111827),
      secondaryText: Color(0xFF374151),
      answerText: Color(0xFF111827),
      metaText: Color(0xFF6B7280),
      iconMuted: Color(0xFF9CA3AF),
    );
  }
}
