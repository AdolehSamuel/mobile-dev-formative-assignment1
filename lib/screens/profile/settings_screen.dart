import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_header.dart';
import '../auth/sign_in_screen.dart';

/// Theme toggle, app info, and sign out (with a confirmation dialog).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'You can sign back in anytime with your ALU account. Your '
          'RSVPs, saved items and clubs will still be here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    await context.read<AppState>().signOut();

    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SignInScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = appState.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SectionHeader(title: 'Appearance'),
            const SizedBox(height: 8),
            Card(
              child: SwitchListTile(
                secondary: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                ),
                title: const Text('Dark Mode'),
                subtitle: Text(
                  isDark ? 'Dark theme is on' : 'Light theme is on',
                ),
                value: isDark,
                onChanged: (_) => appState.toggleTheme(),
              ),
            ),
            const SizedBox(height: 24),
            SectionHeader(title: 'About'),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.info_outline_rounded),
                    title: Text('ALU Connect'),
                    subtitle: Text('Version 1.0.0 • Formative assignment'),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.diversity_3_rounded),
                    title: Text('African Leadership University'),
                    subtitle: Text('Kigali • Mauritius • Online'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SecondaryButton(
              label: 'Sign Out',
              icon: Icons.logout_rounded,
              onPressed: () => _confirmSignOut(context),
            ),
          ],
        ),
      ),
    );
  }
}
