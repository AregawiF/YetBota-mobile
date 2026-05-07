import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/register_bloc.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/register_event.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/register_state.dart';

/// Final step of the phone-OTP signup flow: collect profile details, call `Register`, then auto-Login. On success
class CompleteRegistrationPage extends StatefulWidget {
  const CompleteRegistrationPage({super.key});

  @override
  State<CompleteRegistrationPage> createState() =>
      _CompleteRegistrationPageState();
}

class _CompleteRegistrationPageState extends State<CompleteRegistrationPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  String? _firstNameError;
  String? _lastNameError;
  String? _usernameError;
  String? _passwordError;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    String? firstErr;
    String? lastErr;
    String? userErr;
    String? passErr;

    if (first.isEmpty) firstErr = 'Required';
    if (last.isEmpty) lastErr = 'Required';
    if (username.isEmpty) {
      userErr = 'Username is required';
    } else if (username.length < 3) {
      userErr = 'Use at least 3 characters';
    }
    if (password.isEmpty) {
      passErr = 'Password is required';
    } else if (password.length < 8) {
      passErr = 'Use at least 8 characters';
    }

    setState(() {
      _firstNameError = firstErr;
      _lastNameError = lastErr;
      _usernameError = userErr;
      _passwordError = passErr;
    });

    if (firstErr != null ||
        lastErr != null ||
        userErr != null ||
        passErr != null) {
      return;
    }

    context.read<RegisterBloc>().add(
          RegisterDetailsSubmitted(
            firstName: first,
            lastName: last,
            username: username,
            password: password,
          ),
        );
  }

  void _onStateChanged(BuildContext context, RegisterState state) {
    final session = state.session;
    if (state.step == RegisterStep.done && session != null) {
      context.read<AuthBloc>().add(AuthSessionEstablished(session));
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: _onStateChanged,
      builder: (context, state) {
        final remoteError = state.errorMessage;
        final isBusy = state.registering;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _TopBar(
                  title: 'Complete Sign Up',
                  onBack: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        const _IconMark(),
                        Text(
                          'Tell us about you.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Just a few more details to finish creating your account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cs.onSurface.withOpacity(dark ? 0.65 : 0.7),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: _LabeledField(
                                label: 'First Name',
                                child: _DarkTextField(
                                  controller: _firstNameController,
                                  hintText: 'John',
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _LabeledField(
                                label: 'Last Name',
                                child: _DarkTextField(
                                  controller: _lastNameController,
                                  hintText: 'Doe',
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_firstNameError != null ||
                            _lastNameError != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _FieldErrorText(
                                    text: _firstNameError ?? ''),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child:
                                    _FieldErrorText(text: _lastNameError ?? ''),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 16),
                        _LabeledField(
                          label: 'Username',
                          child: _DarkTextField(
                            controller: _usernameController,
                            hintText: 'choose a username',
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        if (_usernameError != null) ...[
                          const SizedBox(height: 8),
                          _FieldErrorText(text: _usernameError!),
                        ],
                        const SizedBox(height: 16),
                        _LabeledField(
                          label: 'Password',
                          child: _DarkPasswordField(
                            controller: _passwordController,
                            hintText: 'Create a password',
                            obscure: _obscure,
                            onToggle: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        if (_passwordError != null) ...[
                          const SizedBox(height: 8),
                          _FieldErrorText(text: _passwordError!),
                        ],
                        if (remoteError != null) ...[
                          const SizedBox(height: 12),
                          _FieldErrorText(text: remoteError),
                        ],
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 56,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 10,
                              shadowColor: AppTheme.primary.withOpacity(0.18),
                            ),
                            onPressed: isBusy ? null : _submit,
                            child: isBusy
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text.rich(
                          TextSpan(
                            text: 'By creating an account, you agree to our ',
                            style: TextStyle(
                              color: cs.onSurface.withOpacity(0.55),
                              fontSize: 12,
                              height: 1.4,
                            ),
                            children: const [
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  decoration: TextDecoration.underline,
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
              icon: Icon(Icons.arrow_back_ios, color: cs.onSurface, size: 20),
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

class _IconMark extends StatelessWidget {
  const _IconMark();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/icons/pin_icon.png',
        width: 96,
        height: 96,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
        child,
      ],
    );
  }
}

class _DarkTextField extends StatelessWidget {
  const _DarkTextField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fill = dark ? const Color(0xFF121212) : cs.surface;
    final border = dark ? const Color(0xFF222222) : cs.outlineVariant;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: TextStyle(color: cs.onSurface),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.45)),
        filled: true,
        fillColor: fill,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: border),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: AppTheme.primary.withOpacity(0.6), width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

class _DarkPasswordField extends StatelessWidget {
  const _DarkPasswordField({
    required this.controller,
    required this.hintText,
    required this.obscure,
    required this.onToggle,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fill = dark ? const Color(0xFF121212) : cs.surface;
    final border = dark ? const Color(0xFF222222) : cs.outlineVariant;
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: cs.onSurface),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.45)),
        filled: true,
        fillColor: fill,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: border),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: AppTheme.primary.withOpacity(0.6), width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
          color: cs.onSurface.withOpacity(0.55),
        ),
      ),
    );
  }
}

class _FieldErrorText extends StatelessWidget {
  const _FieldErrorText({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.error,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
