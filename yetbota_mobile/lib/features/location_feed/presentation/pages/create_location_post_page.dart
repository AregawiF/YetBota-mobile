import 'package:flutter/material.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/common/ui/app_snack_bar.dart';

class CreateLocationPostPage extends StatefulWidget {
  const CreateLocationPostPage({super.key});

  @override
  State<CreateLocationPostPage> createState() => _CreateLocationPostPageState();
}

class _CreateLocationPostPageState extends State<CreateLocationPostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Set<String> _selectedTags = {'#History'};

  static const _popularTags = [
    '#History',
    '#CoffeeCulture',
    '#Lalibela',
    '#Nature',
  ];

  /// Figma-exported assets (remote; valid ~7 days from export).
  static const _kCameraArt =
      'https://www.figma.com/api/mcp/asset/13066616-1682-4fe4-ae99-2b089ef6c814';
  static const _kLocationPinArt =
      'https://www.figma.com/api/mcp/asset/08571ab2-2824-4a45-b2be-22dff4cd9f70';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = _CreateLocationPostPalette.of(context);
    return Scaffold(
      backgroundColor: p.pageBackground,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: _Header(
              palette: p,
              onClose: () => Navigator.of(context).maybePop(),
              onPost: _handlePost,
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 448),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 160),
                  children: [
                    _AddPhotosCard(
                      palette: p,
                      onUpload: () {
                        showTopSnackBar(
                          context,
                          'Image upload will connect to gallery next.',
                          duration: const Duration(milliseconds: 1200),
                          appearance: AppSnackBarAppearance.neutral,
                        );
                      },
                      cameraUrl: _kCameraArt,
                    ),
                    const SizedBox(height: 24),
                    _LabeledField(
                      palette: p,
                      label: 'Title',
                      controller: _titleController,
                      hint: 'e.g. Exploring the Simien Mountains',
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 24),
                    _LabeledField(
                      palette: p,
                      label: 'Description',
                      controller: _descriptionController,
                      hint: 'Describe the vibe at the local Buna ceremony...',
                      maxLines: 5,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 24),
                    _SetLocationButton(
                      palette: p,
                      pinUrl: _kLocationPinArt,
                      onTap: () {
                        showTopSnackBar(
                          context,
                          'Location picker coming soon.',
                          duration: const Duration(milliseconds: 1200),
                          appearance: AppSnackBarAppearance.neutral,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          'Popular Tags',
                          style: TextStyle(
                            color: p.label,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 20 / 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _TagWrap(
                      palette: p,
                      tags: _popularTags,
                      selected: _selectedTags,
                      onToggle: (t) {
                        setState(() {
                          if (_selectedTags.contains(t)) {
                            _selectedTags.remove(t);
                          } else {
                            _selectedTags.add(t);
                          }
                        });
                      },
                      onAddTap: () {
                        showTopSnackBar(
                          context,
                          'Custom tag: connect next.',
                          duration: const Duration(milliseconds: 1200),
                          appearance: AppSnackBarAppearance.neutral,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePost() {
    if (_titleController.text.trim().isEmpty) {
      showTopSnackBar(
        context,
        'Add a title for your post.',
        duration: const Duration(milliseconds: 1100),
        appearance: AppSnackBarAppearance.error,
      );
      return;
    }
    showTopSnackBar(
      context,
      'Post drafted. Connect to backend next.',
      duration: const Duration(milliseconds: 1200),
    );
  }
}

class _CreateLocationPostPalette {
  const _CreateLocationPostPalette({
    required this.pageBackground,
    required this.headerBorder,
    required this.label,
    required this.hint,
    required this.chip,
    required this.chipSelectedBg,
    required this.chipSelectedBorder,
    required this.addPhotosBorder,
    required this.addPhotosFill,
  });

  final Color pageBackground;
  final Color headerBorder;
  final Color label;
  final Color hint;
  final Color chip;
  final Color chipSelectedBg;
  final Color chipSelectedBorder;
  final Color addPhotosBorder;
  final Color addPhotosFill;

  factory _CreateLocationPostPalette.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const _CreateLocationPostPalette(
        pageBackground: Color(0xFF000000),
        headerBorder: Color(0x1AFFFFFF),
        label: Color(0xFF94A3B8),
        hint: Color(0xFF475569),
        chip: Color(0xFFCBD5E1),
        chipSelectedBg: AppTheme.primary500a33,
        chipSelectedBorder: AppTheme.primary500a66,
        addPhotosBorder: Color(0xFF222222),
        addPhotosFill: Color(0xFF121212),
      );
    }
    return const _CreateLocationPostPalette(
      pageBackground: Color(0xFFF8FAFC),
      headerBorder: Color(0x14000000),
      label: Color(0xFF64748B),
      hint: Color(0xFF94A3B8),
      chip: Color(0xFF475569),
      chipSelectedBg: AppTheme.primary500a33,
      chipSelectedBorder: AppTheme.primary500a66,
      addPhotosBorder: Color(0xFFE2E8F0),
      addPhotosFill: Color(0xFFF1F5F9),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.palette,
    required this.onClose,
    required this.onPost,
  });

  final _CreateLocationPostPalette palette;
  final VoidCallback onClose;
  final VoidCallback onPost;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: palette.headerBorder)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 448),
          child: SizedBox(
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onClose,
                          customBorder: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(
                              Icons.close_rounded,
                              color: Color(0xFFFFFFFF),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(999),
                        child: InkWell(
                          onTap: onPost,
                          borderRadius: BorderRadius.circular(999),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 6,
                            ),
                            child: Text(
                              'Post',
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                height: 20 / 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Create Post',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF0F172A),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 28 / 18,
                    letterSpacing: -0.45,
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

class _AddPhotosCard extends StatelessWidget {
  const _AddPhotosCard({
    required this.palette,
    required this.onUpload,
    required this.cameraUrl,
  });

  final _CreateLocationPostPalette palette;
  final VoidCallback onUpload;
  final String cameraUrl;

  @override
  Widget build(BuildContext context) {
    const radius = 24.0;
    return CustomPaint(
      foregroundPainter: _DashedRRectBorderPainter(
        color: palette.addPhotosBorder,
        borderRadius: radius,
        strokeWidth: 2,
        dash: 6,
        gap: 4,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        decoration: BoxDecoration(
          color: palette.addPhotosFill,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 57,
              width: 60,
              child: Image.network(
                cameraUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.add_a_photo_rounded,
                  size: 48,
                  color: AppTheme.primary.withValues(alpha: 0.9),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Add Photos',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF0F172A),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 28 / 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Share the beauty of the landscape (Optional)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: palette.label,
                fontSize: 14,
                height: 20 / 14,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: onUpload,
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF0F172A),
                side: BorderSide(color: palette.addPhotosBorder),
                backgroundColor: palette.addPhotosFill,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Upload Image',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedRRectBorderPainter extends CustomPainter {
  _DashedRRectBorderPainter({
    required this.color,
    required this.borderRadius,
    this.strokeWidth = 2,
    this.dash = 6,
    this.gap = 4,
  });

  final Color color;
  final double borderRadius;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = strokeWidth / 2;
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        inset,
        inset,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(borderRadius - inset),
    );
    final path = Path()..addRRect(r);
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        final e = d + dash;
        final extract = metric.extractPath(
          d,
          e > metric.length ? metric.length : e,
        );
        canvas.drawPath(
          extract,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..isAntiAlias = true,
        );
        d = e + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.borderRadius != borderRadius;
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.palette,
    required this.label,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.onChanged,
  });

  final _CreateLocationPostPalette palette;
  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            label,
            style: TextStyle(
              color: palette.label,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 20 / 14,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          minLines: maxLines == 1 ? 1 : 4,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontSize: 16,
            height: maxLines == 1 ? 1.25 : 24 / 16,
          ),
          cursorColor: AppTheme.primary,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 17,
            ),
            fillColor: palette.addPhotosFill,
            filled: true,
            hintText: hint,
            hintStyle: TextStyle(
              color: palette.hint,
              fontSize: 16,
              height: 1.2,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: palette.addPhotosBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: AppTheme.primary, width: 1.4),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
          ),
        ),
      ],
    );
  }
}

class _SetLocationButton extends StatelessWidget {
  const _SetLocationButton({
    required this.palette,
    required this.pinUrl,
    required this.onTap,
  });

  final _CreateLocationPostPalette palette;
  final String pinUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.addPhotosFill,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: palette.addPhotosBorder),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                height: 36,
                child: Image.network(
                  pinUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: AppTheme.primary,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set Location',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF0F172A),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 20 / 14,
                      ),
                    ),
                    Text(
                      'Pin your post to a specific spot',
                      style: TextStyle(
                        color: palette.label,
                        fontSize: 12,
                        height: 16 / 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: palette.hint, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _TagWrap extends StatelessWidget {
  const _TagWrap({
    required this.palette,
    required this.tags,
    required this.selected,
    required this.onToggle,
    required this.onAddTap,
  });

  final _CreateLocationPostPalette palette;
  final List<String> tags;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...tags.map(
          (t) => _TagPill(
            label: t,
            selected: selected.contains(t),
            palette: palette,
            onTap: () => onToggle(t),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onAddTap,
            borderRadius: BorderRadius.circular(999),
            child: CustomPaint(
              painter: _DashedPillBorderPainter(color: palette.addPhotosBorder),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, size: 14, color: AppTheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Add',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 16 / 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedPillBorderPainter extends CustomPainter {
  _DashedPillBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(999),
    );
    final path = Path()..addRRect(r);
    for (final metric in path.computeMetrics()) {
      const dash = 4.0;
      const gap = 3.0;
      double d = 0;
      while (d < metric.length) {
        final e = d + dash;
        final extract = metric.extractPath(
          d,
          e > metric.length ? metric.length : e,
        );
        canvas.drawPath(
          extract,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
        d = e + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedPillBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _TagPill extends StatelessWidget {
  const _TagPill({
    required this.label,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final _CreateLocationPostPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? palette.chipSelectedBg : palette.addPhotosFill,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? palette.chipSelectedBorder
                  : palette.addPhotosBorder,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppTheme.primary : palette.chip,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 16 / 12,
            ),
          ),
        ),
      ),
    );
  }
}
