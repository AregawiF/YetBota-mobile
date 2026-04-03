import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/app/theme/theme_cubit.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:yetbota_mobile/features/auth/presentation/pages/home_page.dart';
import 'package:yetbota_mobile/features/welcome/presentation/pages/welcome_page.dart';

class YetBotaApp extends StatelessWidget {
  const YetBotaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'YetBota',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          home: const _AuthGate(),
        );
      },
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return switch (state) {
          AuthUnknown() => const Scaffold(body: Center(child: CircularProgressIndicator())),
          AuthAuthenticating() =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
          AuthAuthenticated(token: final token) => HomePage(token: token),
          AuthUnauthenticated() => const WelcomePage(),
        };
      },
    );
  }
}

