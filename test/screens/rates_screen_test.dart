import 'package:currency_converter/di/injection.dart';
import 'package:currency_converter/domain/model/currency_rate.dart';
import 'package:currency_converter/domain/repository/currency_repository.dart';
import 'package:currency_converter/presentation/bloc/calculator/calculator_cubit.dart';
import 'package:currency_converter/presentation/bloc/rates/rates_bloc.dart';
import 'package:currency_converter/presentation/bloc/rates/rates_state.dart';
import 'package:currency_converter/presentation/screens/rates/rates_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

void main() {
  late MockCurrencyRepository mockRepo;
  late RatesBloc ratesBloc;

  final testRate = CurrencyRate(
    code: 'JPY',
    rate: 149.50,
    updatedAt: DateTime(2024),
  );

  setUp(() {
    mockRepo = MockCurrencyRepository();
    when(() => mockRepo.watchAllRates()).thenAnswer((_) => Stream.value([]));
    when(() => mockRepo.watchSavedCurrency())
        .thenAnswer((_) => Stream.value(null));
    when(() => mockRepo.fetchAndCacheRates()).thenAnswer((_) async => false);

    ratesBloc = RatesBloc(mockRepo);

    getIt.registerFactory<RatesBloc>(() => ratesBloc);
    getIt.registerFactory<CalculatorCubit>(() => CalculatorCubit());
    getIt.registerLazySingleton<CurrencyRepository>(() => mockRepo);
  });

  tearDown(() {
    ratesBloc.close();
    getIt.reset();
  });

  Widget buildSubject() => MaterialApp(
        home: BlocProvider<RatesBloc>.value(
          value: ratesBloc,
          child: const Scaffold(body: RatesScreen()),
        ),
      );

  testWidgets('shows loading indicator when RatesLoading', (tester) async {
    ratesBloc.emit(const RatesLoading());

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows saved currency card when RatesLoaded with savedCurrency',
      (tester) async {
    ratesBloc.emit(RatesLoaded(
      rates: [testRate],
      savedCurrency: testRate,
      lastUpdated: DateTime(2024),
      isUsingCache: false,
    ));

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('JPY → USD'), findsOneWidget);
  });

  testWidgets('shows pin prompt when RatesLoaded with no savedCurrency',
      (tester) async {
    ratesBloc.emit(RatesLoaded(
      rates: [testRate],
      savedCurrency: null,
      lastUpdated: DateTime(2024),
      isUsingCache: false,
    ));

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('Tap ★ to pin a currency'), findsOneWidget);
  });

  testWidgets('shows currency list items when RatesLoaded', (tester) async {
    ratesBloc.emit(RatesLoaded(
      rates: [testRate],
      savedCurrency: null,
      lastUpdated: DateTime(2024),
      isUsingCache: false,
    ));

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('JPY'), findsOneWidget);
  });

  testWidgets('shows cached data indicator when isUsingCache is true',
      (tester) async {
    ratesBloc.emit(RatesLoaded(
      rates: [testRate],
      savedCurrency: testRate,
      lastUpdated: null,
      isUsingCache: true,
    ));

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('Using cached data'), findsOneWidget);
  });
}
