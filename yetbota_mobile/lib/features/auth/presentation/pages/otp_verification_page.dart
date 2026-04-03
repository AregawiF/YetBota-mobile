import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key, required this.phoneE164});

  final String phoneE164;

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _nodes = List.generate(6, (_) => FocusNode());
  Timer? _timer;
  int _secondsRemaining = 55;
  String? _otpError;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_secondsRemaining <= 0) return;
      setState(() => _secondsRemaining -= 1);
    });
    _nodes.first.requestFocus();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _editPhone() {
    Navigator.of(context).maybePop();
  }

  void _resend() {
    if (_secondsRemaining > 0) return;
    setState(() {
      _secondsRemaining = 55;
      _otpError = null;
      for (final c in _controllers) {
        c.clear();
      }
    });
    _nodes.first.requestFocus();
  }

  void _verify() {
    final code = _code;
    if (code.length != 6 || code.contains(RegExp(r'[^0-9]'))) {
      setState(() => _otpError = 'Enter the 6-digit code');
      return;
    }
    setState(() => _otpError = null);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final phoneMasked = _mask(widget.phoneE164);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              title: 'Verify OTP',
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: const Icon(Icons.sms, color: AppTheme.primary, size: 38),
                          ),
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.darkBackground, width: 4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Check your phone',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "We've sent a 6-digit verification code to",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            phoneMasked,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppTheme.primary.withOpacity(0.10),
                            foregroundColor: AppTheme.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          onPressed: _editPhone,
                          child: const Text(
                            'Edit',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final maxWidth = constraints.maxWidth;
                        const gap = 8.0;
                        const groupGap = 10.0;
                        const dotWidth = 6.0;

                        final availableForBoxes =
                            maxWidth - (gap * 4) - (groupGap * 2) - dotWidth;
                        final boxSize = (availableForBoxes / 6).clamp(36.0, 48.0);

                        return Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 0; i < 3; i++) ...[
                                _OtpBox(
                                  size: boxSize,
                                  controller: _controllers[i],
                                  node: _nodes[i],
                                  onChanged: (v) => _onChanged(i, v),
                                  onBackspaceAtEmpty: () => _onBackspace(i),
                                ),
                                if (i != 2) const SizedBox(width: gap),
                              ],
                              const SizedBox(width: groupGap),
                              const _OtpDot(),
                              const SizedBox(width: groupGap),
                              for (int i = 3; i < 6; i++) ...[
                                _OtpBox(
                                  size: boxSize,
                                  controller: _controllers[i],
                                  node: _nodes[i],
                                  onChanged: (v) => _onChanged(i, v),
                                  onBackspaceAtEmpty: () => _onBackspace(i),
                                ),
                                if (i != 5) const SizedBox(width: gap),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                    if (_otpError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _otpError!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.schedule, color: Color(0xFF9CA3AF), size: 16),
                            const SizedBox(width: 8),
                            Text(
                              _formatSeconds(_secondsRemaining),
                              style: const TextStyle(
                                color: Color(0xFFD1D5DB),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: TextButton(
                        onPressed: _secondsRemaining > 0 ? null : _resend,
                        child: Text.rich(
                          TextSpan(
                            text: "Didn't get it? ",
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: _secondsRemaining > 0
                                    ? 'Resend in ${_secondsRemaining}s'
                                    : 'Resend',
                                style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final maxWidth = constraints.maxWidth;
                        final minHeight = 56.0;
                        final height = minHeight.clamp(52.0, 56.0);
                        final maxTextWidth = maxWidth - 24;

                        return SizedBox(
                          height: height,
                          width: double.infinity,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 12,
                              shadowColor: AppTheme.primary.withOpacity(0.18),
                            ),
                            onPressed: _verify,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxTextWidth),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'Verify & Continue',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.check_circle, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    const Text.rich(
                      TextSpan(
                        text: "By continuing, you agree to Yet Bota's\n",
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 11,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text: 'Community Guidelines',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0x4D22C55E),
                            ),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0x4D22C55E),
                            ),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onChanged(int index, String value) {
    final v = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (v.isEmpty) return;
    if (v.length > 1) {
      _controllers[index].text = v.substring(v.length - 1);
      _controllers[index].selection = TextSelection.collapsed(offset: 1);
    }
    setState(() => _otpError = null);
    if (index < _nodes.length - 1) {
      _nodes[index + 1].requestFocus();
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  void _onBackspace(int index) {
    if (index == 0) return;
    _controllers[index - 1].clear();
    _nodes[index - 1].requestFocus();
  }

  static String _formatSeconds(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  static String _mask(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (digits.length <= 5) return digits;
    final end = digits.substring(digits.length - 2);
    return '${digits.substring(0, 2)} ••• ••• $end';
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.onBack,
  });

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: cs.onSurface.withOpacity(0.10),
                foregroundColor: cs.onSurface,
                shape: const CircleBorder(),
              ),
              onPressed: onBack,
              child: const Icon(Icons.arrow_back_ios_new, size: 20),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.size,
    required this.controller,
    required this.node,
    required this.onChanged,
    required this.onBackspaceAtEmpty,
  });

  final double size;
  final TextEditingController controller;
  final FocusNode node;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspaceAtEmpty;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: size,
      width: size,
      child: KeyboardListener(
        focusNode: FocusNode(skipTraversal: true),
        onKeyEvent: (event) {
          if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
            if (controller.text.isEmpty) onBackspaceAtEmpty();
          }
        },
        child: TextField(
          controller: controller,
          focusNode: node,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: dark ? const Color(0xFF121212) : cs.surface,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: dark ? const Color(0xFF333333) : cs.outlineVariant,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
              borderRadius: BorderRadius.circular(18),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: (size - 24) / 2),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _OtpDot extends StatelessWidget {
  const _OtpDot();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 52,
      width: 6,
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xFF333333),
            shape: BoxShape.circle,
          ),
          child: SizedBox(height: 6, width: 6),
        ),
      ),
    );
  }
}

