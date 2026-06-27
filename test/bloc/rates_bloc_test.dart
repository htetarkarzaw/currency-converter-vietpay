import 'package:bloc_test/bloc_test.dart';
import 'package:currency_converter/domain/model/currency_rate.dart';
import 'package:currency_converter/domain/repository/currency_repository.dart';
import 'package:currency_converter/presentation/bloc/rates/rates_bloc.dart';
import 'package:currency_converter/presentation/bloc/rates/rates_event.dart';
import 'package:currency_converter/presentation/bloc/rates/rates_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

void main() {
  late MockCurrencyRepository mockRepo;

  final testRate = CurrencyRate(
    code: 'USD',
    rate: 1.0,
    updatedAt: DateTime(2024),
  );

  setUp(() {
    mockRepo = MockCurrencyRepository();
  });

  group('RatesBloc', () {
    blocTest<RatesBloc, RatesState>(
      'emits RatesLoading then RatesLoaded when LoadRates succeeds',
      build: () {
        when(() => mockRepo.fetchAndCacheRates()).thenAnswer((_) async => true);
        when(() => mockRepo.watchAllRates())
            .thenAnswer((_) => Stream.value([testRate]));
        when(() => mockRepo.watchSavedCurrency())
            .thenAnswer((_) => Stream.value(null));
        return RatesBloc(mockRepo);
      },
      act: (bloc) => bloc.add(const LoadRates()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const RatesLoading(),
        RatesLoaded(
          rates: [testRate],
          savedCurrency: null,
          lastUpdated: DateTime(2024),
          isUsingCache: false,
        ),
      ],
    );

    blocTest<RatesBloc, RatesState>(
      'emits RatesLoading then RatesLoaded with isUsingCache true when network fails',
      build: () {
        when(() => mockRepo.fetchAndCacheRates()).thenAnswer((_) async => false);
        when(() => mockRepo.watchAllRates())
            .thenAnswer((_) => Stream.value([testRate]));
        when(() => mockRepo.watchSavedCurrency())
            .thenAnswer((_) => Stream.value(null));
        return RatesBloc(mockRepo);
      },
      act: (bloc) => bloc.add(const LoadRates()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const RatesLoading(),
        RatesLoaded(
          rates: [testRate],
          savedCurrency: null,
          lastUpdated: DateTime(2024),
          isUsingCache: true,
        ),
      ],
    );

    blocTest<RatesBloc, RatesState>(
      'emits RatesLoaded with isRefreshing true then false on RefreshRates',
      build: () {
        when(() => mockRepo.fetchAndCacheRates()).thenAnswer((_) async => true);
        return RatesBloc(mockRepo);
      },
      seed: () => RatesLoaded(
        rates: [testRate],
        savedCurrency: null,
        lastUpdated: DateTime(2024),
        isUsingCache: false,
      ),
      act: (bloc) => bloc.add(const RefreshRates()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        RatesLoaded(
          rates: [testRate],
          savedCurrency: null,
          lastUpdated: DateTime(2024),
          isUsingCache: false,
          isRefreshing: true,
        ),
        RatesLoaded(
          rates: [testRate],
          savedCurrency: null,
          lastUpdated: DateTime(2024),
          isUsingCache: false,
          isRefreshing: false,
        ),
      ],
    );
  });
}
