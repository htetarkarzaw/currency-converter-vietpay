import 'package:currency_converter/di/injection.dart';
import 'package:currency_converter/domain/model/currency_rate.dart';
import 'package:currency_converter/domain/repository/currency_repository.dart';
import 'package:currency_converter/presentation/bloc/calculator/calculator_cubit.dart';
import 'package:currency_converter/presentation/bloc/rates/rates_bloc.dart';
import 'package:currency_converter/presentation/bloc/rates/rates_state.dart';
import 'package:currency_converter/presentation/screens/calculator/calculator_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

void main() {
  late MockCurrencyRepository mockRepo;
  late RatesBloc ratesBloc;

  final testRate1 = CurrencyRate(
    code: 'USD',
    rate: 1.0,
    updatedAt: DateTime(2024),
  );
  final testRate2 = CurrencyRate(
    code: 'THB',
    rate: 35.0,
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
  });

  tearDown(() {
    ratesBloc.close();
    getIt.reset();
  });

  Widget buildSubject() => MaterialApp(
        home: BlocProvider<RatesBloc>.value(
          value: ratesBloc,
          child: const Scaffold(body: CalculatorScreen()),
        ),
      );

  RatesLoaded loadedState(List<CurrencyRate> rates) => RatesLoaded(
        rates: rates,
        savedCurrency: null,
        lastUpdated: null,
        isUsingCache: false,
      );

  testWidgets('shows Select currency placeholders initially', (tester) async {
    ratesBloc.emit(loadedState([testRate1, testRate2]));

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('Select currency'), findsWidgets);
    expect(find.text('Select currency'), findsAtLeastNWidgets(2));
  });

  testWidgets('shows result card placeholder when no currencies selected',
      (tester) async {
    ratesBloc.emit(loadedState([testRate1, testRate2]));

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('Select currencies to convert'), findsOneWidget);
  });

  testWidgets('shows From and To labels', (tester) async {
    ratesBloc.emit(loadedState([testRate1, testRate2]));

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('From'), findsOneWidget);
    expect(find.text('To'), findsOneWidget);
  });

  testWidgets('shows Amount label', (tester) async {
    ratesBloc.emit(loadedState([testRate1, testRate2]));

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('Amount'), findsOneWidget);
  });
}
