import 'package:currency_converter/di/injection.dart';
import 'package:currency_converter/domain/repository/currency_repository.dart';
import 'package:currency_converter/main.dart';
import 'package:currency_converter/presentation/bloc/calculator/calculator_cubit.dart';
import 'package:currency_converter/presentation/bloc/rates/rates_bloc.dart';
import 'package:currency_converter/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

void main() {
  late MockCurrencyRepository mockRepo;

  setUp(() {
    themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);
    mockRepo = MockCurrencyRepository();
    when(() => mockRepo.watchAllRates()).thenAnswer((_) => Stream.value([]));
    when(() => mockRepo.watchSavedCurrency())
        .thenAnswer((_) => Stream.value(null));
    when(() => mockRepo.fetchAndCacheRates()).thenAnswer((_) async => false);

    getIt.registerFactory<RatesBloc>(() => RatesBloc(mockRepo));
    getIt.registerFactory<CalculatorCubit>(() => CalculatorCubit());
  });

  tearDown(() {
    themeNotifier.dispose();
    getIt.reset();
  });

  Widget buildSubject() => const MaterialApp(home: HomeScreen());

  testWidgets('HomeScreen renders without errors', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Rates'), findsOneWidget);
    expect(find.text('Calculator'), findsOneWidget);
  });

  testWidgets('Switching tabs shows correct screen', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final initialNav = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(initialNav.currentIndex, 0);

    await tester.tap(find.text('Calculator'));
    await tester.pump();

    final updatedNav = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(updatedNav.currentIndex, 1);
  });
}
