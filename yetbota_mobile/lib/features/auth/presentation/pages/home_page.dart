import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetbota_mobile/app/theme/theme_cubit.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:yetbota_mobile/app/main_shell_page.dart';
import 'package:yetbota_mobile/features/discovery_feed/presentation/pages/discovery_feed_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ThemeCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton(
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthSignOutRequested()),
            child: const Text('Sign out'),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const ListTile(
                title: Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.wb_sunny_outlined),
                title: const Text('Light'),
                trailing: mode == ThemeMode.light
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  context.read<ThemeCubit>().setMode(ThemeMode.light);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.nightlight_round),
                title: const Text('Dark'),
                trailing: mode == ThemeMode.dark
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  context.read<ThemeCubit>().setMode(ThemeMode.dark);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_suggest_outlined),
                title: const Text('System'),
                trailing: mode == ThemeMode.system
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  context.read<ThemeCubit>().setMode(ThemeMode.system);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Token: $token',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MainShellPage(token: token),
                  ),
                );
              },
              icon: const Icon(Icons.explore_outlined),
              label: const Text('Open Location Feed'),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DiscoveryFeedPage()),
                );
              },
              icon: const Icon(Icons.slideshow_rounded),
              label: const Text('Open Discovery Feed'),
            ),
          ],
        ),
      ),
    );
  }
}
