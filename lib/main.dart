import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'di/injection.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/theme/app_theme.dart';

late ValueNotifier<ThemeMode> themeNotifier;

Future<ThemeMode> _loadTheme() async {
  final prefs = await SharedPreferences.getInstance();
  return switch (prefs.getString('theme_mode')) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final savedTheme = await _loadTheme();
  themeNotifier = ValueNotifier<ThemeMode>(savedTheme);
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Currency Converter',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          home: const HomeScreen(),
        );
      },
    );
  }
}
