import 'package:flutter/material.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';

class DiscoveryCommentsSheet extends StatelessWidget {
  const DiscoveryCommentsSheet({
    super.key,
    required this.commentCount,
    required this.currentUserAvatarUrl,
    required this.comments,
    required this.palette,
  });

  final String commentCount;
  final String currentUserAvatarUrl;
  final List<DiscoveryCommentThread> comments;
  final DiscoveryCommentsSheetPalette palette;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final keyboardInsets = MediaQuery.viewInsetsOf(context).bottom;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final sheetHeight = (screenHeight * 0.76).clamp(560.0, 680.0);
    return Container(
      height: sheetHeight.toDouble(),
      decoration: BoxDecoration(
        color: palette.sheetBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        border: Border(top: BorderSide(color: palette.strongBorder)),
        boxShadow: [
          BoxShadow(
            color: palette.sheetShadow,
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Center(
              child: Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(
                  color: palette.handle,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 17),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: palette.weakBorder)),
            ),
            child: Row(
              children: [
                Text(
                  'Comments',
                  style: TextStyle(
                    color: palette.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 28 / 18,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: palette.countChipBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    commentCount,
                    style: TextStyle(
                      color: palette.countChipText,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: palette.closeBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: palette.secondaryText,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              itemBuilder: (context, index) {
                return _CommentThreadView(
                  comment: comments[index],
                  palette: palette,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 32),
              itemCount: comments.length,
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              24,
              17,
              24,
              20 + keyboardInsets + bottomPadding,
            ),
            decoration: BoxDecoration(
              color: palette.sheetBackground,
              border: Border(top: BorderSide(color: palette.strongBorder)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: palette.inputAvatarBorder),
                  ),
                  child: _NetworkImageWithFallback(
                    imageUrl: currentUserAvatarUrl,
                    fallbackGradient: palette.fallbackGradient,
                    loadingFallback: palette.loadingFallback,
                    fallbackIconColor: palette.secondaryText,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: palette.inputBackground,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: palette.primaryText,
                        fontSize: 14,
                      ),
                      cursorColor: palette.primaryText,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: TextStyle(
                          color: palette.inputHint,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 13,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'POST',
                    style: TextStyle(
                      color: palette.postButtonText,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
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

class _CommentThreadView extends StatelessWidget {
  const _CommentThreadView({required this.comment, required this.palette});

  final DiscoveryCommentThread comment;
  final DiscoveryCommentsSheetPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: palette.avatarBorder),
              ),
              child: _NetworkImageWithFallback(
                imageUrl: comment.avatarUrl,
                fallbackGradient: palette.fallbackGradient,
                loadingFallback: palette.loadingFallback,
                fallbackIconColor: palette.secondaryText,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              comment.userName,
              style: TextStyle(
                color: palette.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (comment.isTopGuide) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: palette.guideBadgeBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: palette.guideBadgeBorder),
                ),
                child: Text(
                  'TOP GUIDE',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.45,
                  ),
                ),
              ),
            ],
            const Spacer(),
            Text(
              comment.timeAgo,
              style: TextStyle(color: palette.secondaryText, fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          comment.body,
          style: TextStyle(color: palette.bodyText, fontSize: 14, height: 1.62),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(
              Icons.thumb_up_alt_rounded,
              color: AppTheme.primary,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              '${comment.likes}',
              style: TextStyle(
                color: palette.primaryText,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.thumb_down_alt_outlined,
              color: palette.primaryText,
              size: 16,
            ),
          ],
        ),
        const SizedBox(height: 9),
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.subdirectory_arrow_left_rounded,
              color: AppTheme.primary,
              size: 14,
            ),
            SizedBox(width: 4),
            Text(
              'Reply',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        if (comment.replies.isNotEmpty) ...[
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 18),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: palette.weakBorder, width: 2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final reply in comment.replies) ...[
                  _CommentReplyView(reply: reply, palette: palette),
                ],
                if (comment.moreRepliesLabel != null) ...[
                  const SizedBox(height: 23),
                  Text(
                    comment.moreRepliesLabel!,
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _CommentReplyView extends StatelessWidget {
  const _CommentReplyView({required this.reply, required this.palette});

  final DiscoveryCommentReply reply;
  final DiscoveryCommentsSheetPalette palette;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: _NetworkImageWithFallback(
            imageUrl: reply.avatarUrl,
            fallbackGradient: palette.fallbackGradient,
            loadingFallback: palette.loadingFallback,
            fallbackIconColor: palette.secondaryText,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    reply.userName,
                    style: TextStyle(
                      color: palette.primaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    reply.timeAgo,
                    style: TextStyle(color: palette.secondaryText, fontSize: 9),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                reply.body,
                style: TextStyle(
                  color: palette.replyBodyText,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.thumb_up_alt_outlined,
                    color: palette.primaryText,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${reply.likes}',
                    style: TextStyle(
                      color: palette.primaryText,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.thumb_down_alt_outlined,
                    color: palette.primaryText,
                    size: 14,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'REPLY',
                style: TextStyle(
                  color: palette.replyActionText,
                  fontSize: 10,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NetworkImageWithFallback extends StatelessWidget {
  const _NetworkImageWithFallback({
    required this.imageUrl,
    required this.fallbackGradient,
    required this.loadingFallback,
    required this.fallbackIconColor,
    this.fit,
  });

  final String imageUrl;
  final List<Color> fallbackGradient;
  final Color loadingFallback;
  final Color fallbackIconColor;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: fallbackGradient,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: fallbackIconColor,
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

class DiscoveryCommentThread {
  const DiscoveryCommentThread({
    required this.userName,
    required this.timeAgo,
    required this.body,
    required this.likes,
    required this.avatarUrl,
    this.isTopGuide = false,
    this.replies = const [],
    this.moreRepliesLabel,
  });

  final String userName;
  final String timeAgo;
  final String body;
  final int likes;
  final String avatarUrl;
  final bool isTopGuide;
  final List<DiscoveryCommentReply> replies;
  final String? moreRepliesLabel;
}

class DiscoveryCommentReply {
  const DiscoveryCommentReply({
    required this.userName,
    required this.timeAgo,
    required this.body,
    required this.likes,
    required this.avatarUrl,
  });

  final String userName;
  final String timeAgo;
  final String body;
  final int likes;
  final String avatarUrl;
}

class DiscoveryCommentsSheetPalette {
  const DiscoveryCommentsSheetPalette({
    required this.barrierColor,
    required this.sheetBackground,
    required this.strongBorder,
    required this.weakBorder,
    required this.sheetShadow,
    required this.handle,
    required this.primaryText,
    required this.secondaryText,
    required this.bodyText,
    required this.replyBodyText,
    required this.replyActionText,
    required this.countChipBackground,
    required this.countChipText,
    required this.closeBackground,
    required this.avatarBorder,
    required this.guideBadgeBackground,
    required this.guideBadgeBorder,
    required this.inputAvatarBorder,
    required this.inputBackground,
    required this.inputHint,
    required this.postButtonText,
    required this.fallbackGradient,
    required this.loadingFallback,
  });

  final Color barrierColor;
  final Color sheetBackground;
  final Color strongBorder;
  final Color weakBorder;
  final Color sheetShadow;
  final Color handle;
  final Color primaryText;
  final Color secondaryText;
  final Color bodyText;
  final Color replyBodyText;
  final Color replyActionText;
  final Color countChipBackground;
  final Color countChipText;
  final Color closeBackground;
  final Color avatarBorder;
  final Color guideBadgeBackground;
  final Color guideBadgeBorder;
  final Color inputAvatarBorder;
  final Color inputBackground;
  final Color inputHint;
  final Color postButtonText;
  final List<Color> fallbackGradient;
  final Color loadingFallback;

  factory DiscoveryCommentsSheetPalette.fromTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? const DiscoveryCommentsSheetPalette(
            barrierColor: Color(0xA6000000),
            sheetBackground: Colors.black,
            strongBorder: Color(0x1AFFFFFF),
            weakBorder: Color(0x0DFFFFFF),
            sheetShadow: Color(0xCC000000),
            handle: Color(0x33FFFFFF),
            primaryText: Colors.white,
            secondaryText: Color(0x4DFFFFFF),
            bodyText: Color(0xCCFFFFFF),
            replyBodyText: Color(0xB3FFFFFF),
            replyActionText: Color(0x66FFFFFF),
            countChipBackground: Color(0x1AFFFFFF),
            countChipText: Color(0x99FFFFFF),
            closeBackground: Color(0x0DFFFFFF),
            avatarBorder: Color(0x1AFFFFFF),
            guideBadgeBackground: AppTheme.primary500a1A,
            guideBadgeBorder: AppTheme.primary500a33,
            inputAvatarBorder: Color(0x33FFFFFF),
            inputBackground: Color(0x0DFFFFFF),
            inputHint: Color(0x4DFFFFFF),
            postButtonText: Colors.black,
            fallbackGradient: [Color(0xFF1E293B), Color(0xFF0F172A)],
            loadingFallback: Color(0xFF111827),
          )
        : const DiscoveryCommentsSheetPalette(
            barrierColor: Color(0x66000000),
            sheetBackground: Colors.white,
            strongBorder: Color(0x14000000),
            weakBorder: Color(0x0D000000),
            sheetShadow: Color(0x4D000000),
            handle: Color(0x26000000),
            primaryText: Color(0xFF0F172A),
            secondaryText: Color(0x80334155),
            bodyText: Color(0xE6334155),
            replyBodyText: Color(0xCC334155),
            replyActionText: Color(0x99334155),
            countChipBackground: Color(0x0D000000),
            countChipText: Color(0x800F172A),
            closeBackground: Color(0x0A000000),
            avatarBorder: Color(0x1A000000),
            guideBadgeBackground: AppTheme.primary500a14,
            guideBadgeBorder: AppTheme.primary500a26,
            inputAvatarBorder: Color(0x26000000),
            inputBackground: Color(0x0A000000),
            inputHint: Color(0x66334155),
            postButtonText: Colors.white,
            fallbackGradient: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
            loadingFallback: Color(0xFFE2E8F0),
          );
  }
}
