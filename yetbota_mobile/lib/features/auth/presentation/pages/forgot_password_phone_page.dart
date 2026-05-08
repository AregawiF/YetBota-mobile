import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/forgot_password_bloc.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/forgot_password_event.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/forgot_password_state.dart';
import 'package:yetbota_mobile/features/auth/presentation/pages/forgot_password_otp_page.dart';

class ForgotPasswordPhonePage extends StatefulWidget {
  const ForgotPasswordPhonePage({super.key});

  @override
  State<ForgotPasswordPhonePage> createState() =>
      _ForgotPasswordPhonePageState();
}

class _ForgotPasswordPhonePageState extends State<ForgotPasswordPhonePage> {
  final _phoneController = TextEditingController();
  String? _phoneError;
  bool _navigatedToOtp = false;

  @override
  void initState() {
    super.initState();
    context.read<ForgotPasswordBloc>().add(const ForgotPasswordReset());
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    final raw = _phoneController.text.trim();
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');

    String? error;
    if (digits.isEmpty) {
      error = 'Phone number is required';
    } else if (digits.length < 9) {
      error = 'Enter a valid phone number';
    }

    setState(() => _phoneError = error);
    if (error != null) return;

    final mobileE164 = '+251$digits';
    context
        .read<ForgotPasswordBloc>()
        .add(ForgotPasswordMobileSubmitted(mobileE164));
  }

  void _onStateChanged(BuildContext context, ForgotPasswordState state) {
    if (state.step == ForgotPasswordStep.otp && !_navigatedToOtp) {
      _navigatedToOtp = true;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              ForgotPasswordOtpPage(phoneE164: state.mobile ?? ''),
        ),
      ).then((_) {
        if (mounted) _navigatedToOtp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: _onStateChanged,
      builder: (context, state) {
        final remoteError = state.errorMessage;
        final isLoading = state.requestingOtp;
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _TopBar(
                  title: 'Forgot Password',
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
                          child: Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.lock_reset,
                              size: 44,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Reset your password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cs.onSurface,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Enter the phone number tied to your account and we'll send a verification code.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cs.onSurface.withOpacity(dark ? 0.7 : 0.75),
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 12),
                          child: Text(
                            'Phone Number',
                            style: TextStyle(
                              color: cs.onSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 64,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: dark ? const Color(0xFF121212) : cs.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: dark
                                      ? const Color(0xFF2D2D2D)
                                      : cs.outlineVariant,
                                ),
                              ),
                              child: Text(
                                '+251',
                                style: TextStyle(
                                  color: cs.onSurface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                  color: cs.onSurface,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                ),
                                decoration: InputDecoration(
                                  hintText: '912 345 678',
                                  hintStyle: TextStyle(
                                    color: cs.onSurface.withOpacity(0.35),
                                  ),
                                  filled: true,
                                  fillColor: dark
                                      ? const Color(0xFF121212)
                                      : cs.surface,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: dark
                                          ? const Color(0xFF2D2D2D)
                                          : cs.outlineVariant,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppTheme.primary.withOpacity(0.6),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_phoneError != null || remoteError != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            _phoneError ?? remoteError ?? '',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        const SizedBox(height: 18),
                        SizedBox(
                          height: 56,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: isLoading ? null : _sendOtp,
                            child: isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Text(
                                    'Send Code',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});
  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          SizedBox(
            height: 48,
            width: 48,
            child: IconButton(
              onPressed: onBack,
              icon: Icon(Icons.arrow_back_ios_new, color: cs.onSurface, size: 20),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
