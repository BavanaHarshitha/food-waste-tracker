import 'package:flutter/material.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<AppearanceScreen> createState() =>
      _AppearanceScreenState();
}

class _AppearanceScreenState
    extends State<AppearanceScreen> {
  String get selectedTheme {
    switch (widget.themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  void selectTheme(ThemeMode mode) {
    widget.onThemeChanged(mode);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> themes = [
      {
        'name': 'Light Mode',
        'subtitle': 'Always use the light theme',
        'icon': Icons.light_mode_outlined,
        'value': ThemeMode.light,
      },
      {
        'name': 'Dark Mode',
        'subtitle': 'Always use the dark theme',
        'icon': Icons.dark_mode_outlined,
        'value': ThemeMode.dark,
      },
      {
        'name': 'System Default',
        'subtitle': 'Follow your device theme',
        'icon': Icons.settings_suggest_outlined,
        'value': ThemeMode.system,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Theme',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Choose how the Food Wastage Tracker should look.',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: Column(
              children: themes.map((theme) {
                final ThemeMode value =
                    theme['value'] as ThemeMode;

                final bool isSelected =
                    widget.themeMode == value;

                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        selectTheme(value);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.12),
                              child: Icon(
                                theme['icon'] as IconData,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary,
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    theme['name'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    theme['subtitle'] as String,
                                    style: TextStyle(
                                      color:
                                          Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Icon(
                              isSelected
                                  ? Icons
                                      .radio_button_checked
                                  : Icons
                                      .radio_button_unchecked,
                              color: isSelected
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                  : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (value != ThemeMode.system)
                      const Divider(height: 1),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 28),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    size: 50,
                    color:
                        Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'App Appearance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Selected theme: $selectedTheme',
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
}