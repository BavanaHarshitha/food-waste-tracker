import 'package:flutter/material.dart';

import 'notifications_screen.dart';
import 'tips_screen.dart';
import 'appearance_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Preferences',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                // Notifications
                ListTile(
                  leading: Icon(
                    Icons.notifications_outlined,
                    color:
                        Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Notifications'),
                  subtitle: const Text(
                    'Manage food expiry notifications',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const NotificationsScreen(),
                      ),
                    );
                  },
                ),

                const Divider(height: 1),

                // Appearance
                ListTile(
                  leading: Icon(
                    Icons.dark_mode_outlined,
                    color:
                        Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Appearance'),
                  subtitle: Text(
                    getThemeName(),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AppearanceScreen(
                          themeMode: themeMode,
                          onThemeChanged: onThemeChanged,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'About',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                // About
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color:
                        Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text(
                    'About Food Wastage Tracker',
                  ),
                  subtitle: const Text(
                    'Learn about this application',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName:
                          'Food Wastage Tracker',
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(
                        Icons.eco,
                        size: 40,
                      ),
                      children: const [
                        Text(
                          'Food Wastage Tracker helps users '
                          'manage food inventory, track food waste, '
                          'monitor expiry dates, and reduce unnecessary '
                          'food loss.',
                        ),
                      ],
                    );
                  },
                ),

                const Divider(height: 1),

                // Food Waste Tips
                ListTile(
                  leading: Icon(
                    Icons.eco_outlined,
                    color:
                        Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text(
                    'Food Waste Tips',
                  ),
                  subtitle: const Text(
                    'Learn ways to reduce food waste',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const TipsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.eco,
                    size: 50,
                    color:
                        Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Reduce Food Waste',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Track your food, use it before it expires, '
                    'and help reduce unnecessary waste.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String getThemeName() {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
      case ThemeMode.system:
        return 'System Default';
    }
  }
}