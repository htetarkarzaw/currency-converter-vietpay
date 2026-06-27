import 'package:flutter/material.dart';

import '../../../../main.dart';

class ThemePickerBottomSheet extends StatelessWidget {
  const ThemePickerBottomSheet({super.key, required this.currentTheme});

  final ThemeMode currentTheme;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 16;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _ThemeOption(
            icon: Icons.light_mode,
            label: 'Light',
            mode: ThemeMode.light,
            currentTheme: currentTheme,
          ),
          _ThemeOption(
            icon: Icons.dark_mode,
            label: 'Dark',
            mode: ThemeMode.dark,
            currentTheme: currentTheme,
          ),
          _ThemeOption(
            icon: Icons.brightness_auto,
            label: 'System (follow device)',
            mode: ThemeMode.system,
            currentTheme: currentTheme,
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.mode,
    required this.currentTheme,
  });

  final IconData icon;
  final String label;
  final ThemeMode mode;
  final ThemeMode currentTheme;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = currentTheme == mode;

    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: isSelected ? Icon(Icons.check, color: colorScheme.primary) : null,
      onTap: () {
        themeNotifier.value = mode;
        Navigator.pop(context);
      },
    );
  }
}
