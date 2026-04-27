import 'package:flutter/material.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/common/ui/app_snack_bar.dart';

class AskQuestionPage extends StatefulWidget {
  const AskQuestionPage({super.key});

  @override
  State<AskQuestionPage> createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends State<AskQuestionPage> {
  final TextEditingController _questionController = TextEditingController();
  final Set<String> _selectedTags = {'New Tag'};

  static const _availableTags = [
    'New Tag',
    'Recommendations',
    'LocalEvents',
    'Safety',
    'General',
  ];

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = _AskQuestionPalette.of(context);
    return Scaffold(
      backgroundColor: palette.pageBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _AskQuestionHeader(
              palette: palette,
              hasQuestion: _questionController.text.trim().isNotEmpty,
              onClose: () => Navigator.of(context).maybePop(),
              onPost: _handlePost,
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
                    children: [
                      _GuidelinesCard(palette: palette),
                      const SizedBox(height: 20),
                      _SectionLabel(text: 'YOUR QUESTION', palette: palette),
                      const SizedBox(height: 10),
                      _QuestionInput(
                        palette: palette,
                        controller: _questionController,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 22),
                      _SectionLabel(
                        text: 'REFERENCE LOCATION',
                        palette: palette,
                      ),
                      const SizedBox(height: 10),
                      _ReferenceLocationButton(palette: palette),
                      const SizedBox(height: 24),
                      _SectionLabel(text: 'ADD TAGS', palette: palette),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _availableTags.map((tag) {
                          final selected = _selectedTags.contains(tag);
                          return _TagChip(
                            tag: tag,
                            selected: selected,
                            palette: palette,
                            onTap: () => _toggleTag(tag),
                          );
                        }).toList(),
                      ),
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

  void _handlePost() {
    if (_questionController.text.trim().isEmpty) {
      showTopSnackBar(
        context,
        'Write your question first.',
        duration: const Duration(milliseconds: 1100),
      );
      return;
    }
    showTopSnackBar(
      context,
      'Question drafted. Connect to backend next.',
      duration: const Duration(milliseconds: 1100),
    );
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }
}

class _AskQuestionHeader extends StatelessWidget {
  const _AskQuestionHeader({
    required this.palette,
    required this.hasQuestion,
    required this.onClose,
    required this.onPost,
  });

  final _AskQuestionPalette palette;
  final bool hasQuestion;
  final VoidCallback onClose;
  final VoidCallback onPost;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: palette.headerBackground,
        border: Border(bottom: BorderSide(color: palette.sectionBorder)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 448),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onClose,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.close_rounded,
                        color: palette.primaryText,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Ask a Question',
                  style: TextStyle(
                    color: palette.primaryText,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.45,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onPost,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: hasQuestion
                          ? AppTheme.primary
                          : AppTheme.primary.withValues(alpha: 0.6),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GuidelinesCard extends StatelessWidget {
  const _GuidelinesCard({required this.palette});

  final _AskQuestionPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: AppTheme.primary500a0D,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primary900aCC),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: AppTheme.primary,
                size: 17,
              ),
              const SizedBox(width: 8),
              Text(
                'Community Guidelines',
                style: TextStyle(
                  color: palette.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Stay respectful and avoid spam to keep our community helpful.',
            style: TextStyle(
              color: palette.secondaryText,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Read Rules',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(width: 3),
              Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.primary,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text, required this.palette});

  final String text;
  final _AskQuestionPalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: TextStyle(
          color: palette.labelText,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _QuestionInput extends StatelessWidget {
  const _QuestionInput({
    required this.palette,
    required this.controller,
    required this.onChanged,
  });

  final _AskQuestionPalette palette;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 160),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.softBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: 5,
        style: TextStyle(
          color: palette.primaryText,
          fontSize: 16,
          height: 1.52,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'What would you like to ask your local\ncommunity?',
          hintStyle: TextStyle(
            color: palette.placeholderText,
            fontSize: 16,
            height: 1.52,
          ),
          isCollapsed: true,
        ),
      ),
    );
  }
}

class _ReferenceLocationButton extends StatelessWidget {
  const _ReferenceLocationButton({required this.palette});

  final _AskQuestionPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.softBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppTheme.primary500a1A,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.place_outlined,
              color: AppTheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tag a Location',
                  style: TextStyle(
                    color: palette.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Help people nearby find your post',
                  style: TextStyle(
                    color: palette.labelText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.gps_fixed_rounded,
            color: palette.labelText,
            size: 22,
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.tag,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final String tag;
  final bool selected;
  final _AskQuestionPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.black : palette.chipText;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 17),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : palette.chipBackground,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? Colors.transparent : palette.softBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tag == 'New Tag') ...[
              Icon(Icons.add_rounded, color: foreground, size: 16),
              const SizedBox(width: 8),
            ],
            Text(
              tag,
              style: TextStyle(
                color: foreground,
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AskQuestionPalette {
  const _AskQuestionPalette({
    required this.pageBackground,
    required this.headerBackground,
    required this.sectionBorder,
    required this.primaryText,
    required this.secondaryText,
    required this.labelText,
    required this.placeholderText,
    required this.softBorder,
    required this.chipBackground,
    required this.chipText,
  });

  final Color pageBackground;
  final Color headerBackground;
  final Color sectionBorder;
  final Color primaryText;
  final Color secondaryText;
  final Color labelText;
  final Color placeholderText;
  final Color softBorder;
  final Color chipBackground;
  final Color chipText;

  factory _AskQuestionPalette.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const _AskQuestionPalette(
        pageBackground: Color(0xFF000000),
        headerBackground: Color(0xF2000000),
        sectionBorder: Color(0x1AFFFFFF),
        primaryText: Color(0xFFFFFFFF),
        secondaryText: Color(0xFF94A3B8),
        labelText: Color(0xFF64748B),
        placeholderText: Color(0xFF334155),
        softBorder: Color(0x1AFFFFFF),
        chipBackground: Color(0x0DFFFFFF),
        chipText: Color(0xFFCBD5E1),
      );
    }
    return const _AskQuestionPalette(
      pageBackground: Color(0xFFF8FAFC),
      headerBackground: Color(0xF2FFFFFF),
      sectionBorder: Color(0x14000000),
      primaryText: Color(0xFF111827),
      secondaryText: Color(0xFF64748B),
      labelText: Color(0xFF6B7280),
      placeholderText: Color(0xFF9CA3AF),
      softBorder: Color(0x1A000000),
      chipBackground: Color(0xFFF3F4F6),
      chipText: Color(0xFF374151),
    );
  }
}
