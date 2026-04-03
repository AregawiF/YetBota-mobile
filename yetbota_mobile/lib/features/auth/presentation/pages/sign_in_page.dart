import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:yetbota_mobile/features/auth/presentation/pages/sign_in_phone_page.dart';
import 'package:yetbota_mobile/features/auth/presentation/pages/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    String? emailError;
    String? passwordError;

    if (email.isEmpty) {
      emailError = 'Email is required';
    } else if (!email.contains('@')) {
      emailError = 'Enter a valid email';
    }

    if (password.isEmpty) passwordError = 'Password is required';

    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
    });

    if (emailError != null || passwordError != null) return;

    context.read<AuthBloc>().add(
          AuthSignInRequested(
            email: email,
            password: password,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final state = context.watch<AuthBloc>().state;
    final error = state is AuthUnauthenticated ? state.errorMessage : null;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, next) => next is AuthAuthenticated,
      listener: (context, state) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        body: Stack(
          children: [
            const _MapBackdrop(),
            SafeArea(
              child: Column(
                children: [
                  _TopBar(
                    title: 'Sign In',
                    onBack: () => Navigator.of(context).maybePop(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          _IconMark(),
                          const SizedBox(height: 20),
                          Text(
                            'Welcome Back.',
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
                            'Stay connected with your local community.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: cs.onSurface.withOpacity(dark ? 0.65 : 0.7),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 28),
                          _LabeledField(
                            label: 'Email',
                            child: _DarkTextField(
                              controller: _emailController,
                              hintText: 'Enter your email',
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          if (_emailError != null || error != null) ...[
                            const SizedBox(height: 8),
                            _FieldErrorText(text: _emailError ?? error!),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Text(
                                  'Password',
                                  style: TextStyle(
                                    color: cs.onSurface,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          _DarkPasswordField(
                            controller: _passwordController,
                            hintText: '••••••••',
                            obscure: _obscure,
                            onToggle: () => setState(() => _obscure = !_obscure),
                            onSubmitted: (_) => _submit(),
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
                              onPressed: state is AuthAuthenticating ? null : _submit,
                              child: Text(
                                state is AuthAuthenticating ? 'Signing In...' : 'Sign In',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          const _DividerLabel(text: 'Or continue with'),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 56,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    dark ? const Color(0xFF121212) : cs.surface,
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
                              icon: Icon(
                                Icons.call,
                                color: dark ? AppTheme.primary : AppTheme.primary,
                              ),
                              label: const Text(
                                'Continue with Phone Number',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          _BottomBar(
                            text: "Don't have an account?",
                            actionText: 'Sign Up',
                            onAction: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const SignUpPage()),
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
      ),
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
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final VoidCallback onToggle;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fill = dark ? const Color(0xFF121212) : cs.surface;
    final border = dark ? const Color(0xFF222222) : cs.outlineVariant;
    return TextField(
      controller: controller,
      obscureText: obscure,
      onSubmitted: onSubmitted,
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
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.6,
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

