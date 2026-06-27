import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/injection.dart';
import '../../../main.dart';
import '../../bloc/rates/rates_bloc.dart';
import '../../bloc/rates/rates_event.dart';
import '../../bloc/rates/rates_state.dart';
import '../calculator/calculator_screen.dart';
import '../rates/rates_screen.dart';
import 'widgets/theme_picker_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RatesBloc>()..add(const LoadRates()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, themeMode, _) {
              return IconButton(
                icon: Icon(
                  switch (themeMode) {
                    ThemeMode.light => Icons.light_mode,
                    ThemeMode.dark => Icons.dark_mode,
                    ThemeMode.system => Icons.brightness_auto,
                  },
                ),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (_) => ThemePickerBottomSheet(
                    currentTheme: themeNotifier.value,
                  ),
                ),
              );
            },
          ),
          BlocBuilder<RatesBloc, RatesState>(
            builder: (context, state) {
              if (state is RatesLoaded && state.isRefreshing) {
                return const SizedBox(
                  width: 48,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () =>
                    context.read<RatesBloc>().add(const RefreshRates()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          RatesScreen(),
          CalculatorScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Rates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
        ],
      ),
    );
  }
}
