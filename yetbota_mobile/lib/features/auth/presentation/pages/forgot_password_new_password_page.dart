import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/forgot_password_bloc.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/forgot_password_event.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/forgot_password_state.dart';
import 'package:yetbota_mobile/features/auth/presentation/pages/sign_in_page.dart';

class ForgotPasswordNewPasswordPage extends StatefulWidget {
  const ForgotPasswordNewPasswordPage({super.key});

  @override
  State<ForgotPasswordNewPasswordPage> createState() =>
      _ForgotPasswordNewPasswordPageState();
}

class _ForgotPasswordNewPasswordPageState
    extends State<ForgotPasswordNewPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  String? _localError;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final pw = _passwordController.text;
    final cf = _confirmController.text;

    String? error;
    if (pw.length < 8) {
      error = 'Password must be at least 8 characters';
    } else if (pw != cf) {
      error = 'Passwords do not match';
    }
    setState(() => _localError = error);
    if (error != null) return;

    context
        .read<ForgotPasswordBloc>()
        .add(ForgotPasswordNewPasswordSubmitted(pw));
  }

  void _onStateChanged(BuildContext context, ForgotPasswordState state) {
    if (state.step == ForgotPasswordStep.done) {
      final nav = Navigator.of(context);
      nav.popUntil((route) => route.isFirst);
      nav.push<void>(
        MaterialPageRoute<void>(
          builder: (_) => const SignInPage(afterPasswordReset: true),
        ),
      );
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
        final isSubmitting = state.submittingPassword;
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _TopBar(
                  title: 'New Password',
                  onBack: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        Center(
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: const Icon(
                              Icons.lock_outline,
                              color: AppTheme.primary,
                              size: 38,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Set a new password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cs.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Choose a strong password you have not used before. It must be at least 8 characters.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cs.onSurface.withOpacity(dark ? 0.7 : 0.75),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _LabeledPasswordField(
                          label: 'New Password',
                          controller: _passwordController,
                          obscure: _obscure1,
                          onToggle: () =>
                              setState(() => _obscure1 = !_obscure1),
                        ),
                        const SizedBox(height: 16),
                        _LabeledPasswordField(
                          label: 'Confirm Password',
                          controller: _confirmController,
                          obscure: _obscure2,
                          onToggle: () =>
                              setState(() => _obscure2 = !_obscure2),
                        ),
                        if (_localError != null || remoteError != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _localError ?? remoteError ?? '',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
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
                            onPressed: isSubmitting ? null : _submit,
                            child: isSubmitting
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Text(
                                    'Update Password',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
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

class _LabeledPasswordField extends StatelessWidget {
  const _LabeledPasswordField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: dark ? const Color(0xFF121212) : cs.surface,
            hintText: '••••••••',
            hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.35)),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: cs.onSurface.withOpacity(0.6),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: dark ? const Color(0xFF2D2D2D) : cs.outlineVariant,
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          ),
        ),
      ],
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
              icon:
                  Icon(Icons.arrow_back_ios_new, color: cs.onSurface, size: 20),
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
