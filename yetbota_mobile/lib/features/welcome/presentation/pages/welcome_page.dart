import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/features/auth/presentation/pages/sign_in_page.dart';
import 'package:yetbota_mobile/features/auth/presentation/pages/sign_up_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _WelcomeBackdrop(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bottomCardHeight = constraints.maxHeight * 0.55;

                return Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: _TitleWithPin(isDark: isDark),
                      ),
                    ),
                    _BottomCard(height: bottomCardHeight),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class _WelcomeBackdrop extends StatelessWidget {
  const _WelcomeBackdrop();

  static const _heroHeightFraction = 0.50;
  static const _fadeToDark = Color(0xFF0D0D0D);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final heroHeight = MediaQuery.sizeOf(context).height * _heroHeightFraction;
    final bottomFill = isDark ? _fadeToDark : AppTheme.lightBackground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: heroHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/welcome_background.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? [
                            Colors.black.withValues(alpha: 0.035),
                            _fadeToDark,
                          ]
                        : [
                            Colors.black.withValues(alpha: 0.08),
                            Colors.transparent,
                          ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ColoredBox(color: bottomFill),
        ),
      ],
    );
  }
}

class _TitleWithPin extends StatelessWidget {
  const _TitleWithPin({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final pinAsset = isDark
        ? 'assets/icons/location_pin_no_highlight.svg'
        : 'assets/icons/location_pin.svg';

    const pinW = 192.0;
    const pinH = 182.0;
    const highlightScale = 1.09;

    final pin = SvgPicture.asset(
      pinAsset,
      height: pinH,
      width: pinW,
      fit: BoxFit.contain,
    );

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: pinH),
            Text(
              'Yet Bota',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.55 : 0.42),
                    blurRadius: 14,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 40,
          child: isDark
              ? pin
              : Transform.scale(
                  scale: highlightScale,
                  alignment: Alignment.center,
                  child: pin,
                ),
        ),
      ],
    );
  }
}

class _BottomCard extends StatelessWidget {
  const _BottomCard({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.55 : 0.22),
              blurRadius: 32,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Text(
                  'Welcome',
                  style: textTheme.headlineSmall?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover and connect with your local community in Ethiopia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cs.onSurface.withOpacity(0.75),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: const Color(0xFF0A0A0A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor: AppTheme.primary.withOpacity(0.3),
                      elevation: 8,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SignUpPage()),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDark
                            ? AppTheme.primary
                            : const Color.fromRGBO(211, 242, 222, 1),
                        width: 2,
                      ),
                      // backgroundColor: isDark ? Colors.transparent : Colors.white,
                      foregroundColor: isDark ? AppTheme.primary : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SignInPage()),
                      );
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                const _FooterLinksRow(),
                const SizedBox(height: 16),
                Text(
                  'YET BOTA © 2024',
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurface.withOpacity(0.45),
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        color: cs.onSurface.withOpacity(0.6),
        fontSize: 13,
      ),
    );
  }
}

class _FooterLinksRow extends StatelessWidget {
  const _FooterLinksRow();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _FooterLink(text: 'About Us'),
            _FooterSeparator(),
            _FooterLink(text: 'Guidelines'),
            _FooterSeparator(),
            _FooterLink(text: 'Contact'),
          ],
        ),
      ),
    );
  }
}

class _FooterSeparator extends StatelessWidget {
  const _FooterSeparator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: _FooterDot(),
    );
  }
}

class _FooterDot extends StatelessWidget {
  const _FooterDot();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: SizedBox(
        height: 4,
        width: 4,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cs.onSurface.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

