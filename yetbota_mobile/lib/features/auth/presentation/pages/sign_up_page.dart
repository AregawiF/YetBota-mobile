import 'package:flutter/material.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/features/auth/presentation/pages/sign_in_phone_page.dart';
import 'package:yetbota_mobile/features/auth/presentation/pages/sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          const _MapBackdrop(),
          SafeArea(
            child: Column(
              children: [
                _TopBar(
                  title: 'Sign Up',
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
                        const SizedBox(height: 20),
                        Text(
                          'Join Yet Bota.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Start exploring your local community today.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cs.onSurface.withOpacity(dark ? 0.65 : 0.7),
                            fontSize: 16,
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
                        if (_firstNameError != null || _lastNameError != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _FieldErrorText(text: _firstNameError ?? ''),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _FieldErrorText(text: _lastNameError ?? ''),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 16),
                        _LabeledField(
                          label: 'Email',
                          child: _DarkTextField(
                            controller: _emailController,
                            hintText: 'name@example.com',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        if (_emailError != null) ...[
                          const SizedBox(height: 8),
                          _FieldErrorText(text: _emailError!),
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
                            onPressed: _submit,
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const _DividerLabel(text: 'Or Register With'),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 56,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  dark ? Colors.transparent : cs.surface,
                              foregroundColor: cs.onSurface,
                              side: BorderSide(
                                color: dark ? const Color(0xFF222222) : cs.outlineVariant,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const SignInPhonePage()),
                              );
                            },
                            icon: Icon(Icons.call, color: dark ? Colors.white : AppTheme.primary),
                            label: const Text(
                              'Continue with Phone Number',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text.rich(
                          TextSpan(
                            text: 'By signing up, you agree to our ',
                            style: TextStyle(
                              color: cs.onSurface.withOpacity(0.55),
                              fontSize: 12,
                              height: 1.4,
                            ),
                            children: [
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
                        const SizedBox(height: 28),
                        _BottomBar(
                          text: 'Already have an account?',
                          actionText: 'Sign In',
                          onAction: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const SignInPage()),
                            );
                          },
                        ),
                      ],
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

  void _submit() {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    String? firstErr;
    String? lastErr;
    String? emailErr;
    String? passErr;

    if (first.isEmpty) firstErr = 'Required';
    if (last.isEmpty) lastErr = 'Required';
    if (email.isEmpty) {
      emailErr = 'Email is required';
    } else if (!email.contains('@')) {
      emailErr = 'Enter a valid email';
    }
    if (password.isEmpty) {
      passErr = 'Password is required';
    } else if (password.length < 8) {
      passErr = 'Use at least 8 characters';
    }

    setState(() {
      _firstNameError = firstErr;
      _lastNameError = lastErr;
      _emailError = emailErr;
      _passwordError = passErr;
    });
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
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            'assets/yetbota-logo-v1.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _MapBackdrop extends StatelessWidget {
  const _MapBackdrop();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Positioned.fill(
      child: Opacity(
        opacity: dark ? 0.06 : 0.025,
        child: ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.2, 0.2, 0.2, 0, 0,
            0.2, 0.2, 0.2, 0, 0,
            0.2, 0.2, 0.2, 0, 0,
            0, 0, 0, 1, 0,
          ]),
          child: const Image(
            image: NetworkImage(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuA7zINrRusqsP3CTtpRFpwF3TMBhzC2c69hObvO-uJHrpfCnIGNl_OhtzgZA7Cpghhpc2Dgzw9-eS81WwUtrSP36Z3ZxnkepB-301vseaNfYC4HC3FEy-XjHR4eVDOMoLvYxZWzV2eetlvYNEfCEUepenzuHjbTBwab0n_TXf4scFNi-LCksvPrlJOzvm3X5hTNla4qs_0k2KjbqsIH1fisSOZNrA-8mzyWY76MWRMNQhPDMjli29oGTiKpqtRzecVEhNt35N_X5jtE',
            ),
            fit: BoxFit.cover,
          ),
        ),
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
          borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.6), width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.6), width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
          color: cs.onSurface.withOpacity(0.55),
        ),
      ),
    );
  }
}

class _DividerLabel extends StatelessWidget {
  const _DividerLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = dark ? const Color(0xFF222222) : cs.outlineVariant;
    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: TextStyle(
              color: cs.onSurface.withOpacity(0.5),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        Expanded(child: Divider(color: dividerColor)),
      ],
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

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.text,
    required this.actionText,
    required this.onAction,
  });

  final String text;
  final String actionText;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: dark ? Colors.black.withOpacity(0.8) : cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant.withOpacity(0.7))),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: TextButton(
        onPressed: onAction,
        child: Text.rich(
          TextSpan(
            text: '$text ',
            style: TextStyle(color: cs.onSurface.withOpacity(0.7), fontSize: 14),
            children: [
              TextSpan(
                text: actionText,
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

