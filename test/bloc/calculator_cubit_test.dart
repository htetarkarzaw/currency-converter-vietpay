import 'package:bloc_test/bloc_test.dart';
import 'package:currency_converter/presentation/bloc/calculator/calculator_cubit.dart';
import 'package:currency_converter/presentation/bloc/calculator/calculator_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalculatorCubit', () {
    late CalculatorCubit cubit;

    setUp(() => cubit = CalculatorCubit());
    tearDown(() => cubit.close());

    test('initial state is empty', () {
      expect(cubit.state, const CalculatorState());
      expect(cubit.state.fromCurrencyCode, isNull);
      expect(cubit.state.toCurrencyCode, isNull);
      expect(cubit.state.amount, 1.0);
    });

    blocTest<CalculatorCubit, CalculatorState>(
      'setFromCurrency updates fromCurrencyCode',
      build: () => CalculatorCubit(),
      act: (cubit) => cubit.setFromCurrency('USD'),
      expect: () => [
        const CalculatorState(fromCurrencyCode: 'USD'),
      ],
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'setToCurrency updates toCurrencyCode',
      build: () => CalculatorCubit(),
      act: (cubit) => cubit.setToCurrency('EUR'),
      expect: () => [
        const CalculatorState(toCurrencyCode: 'EUR'),
      ],
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'setAmount updates amount',
      build: () => CalculatorCubit(),
      act: (cubit) => cubit.setAmount(100.0),
      expect: () => [
        const CalculatorState(amount: 100.0),
      ],
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'swapCurrencies swaps from and to codes',
      build: () => CalculatorCubit(),
      seed: () => const CalculatorState(
        fromCurrencyCode: 'USD',
        toCurrencyCode: 'EUR',
      ),
      act: (cubit) => cubit.swapCurrencies(),
      expect: () => [
        const CalculatorState(
          fromCurrencyCode: 'EUR',
          toCurrencyCode: 'USD',
        ),
      ],
    );
  });
}
