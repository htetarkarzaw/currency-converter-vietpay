import 'package:equatable/equatable.dart';

import '../../../domain/model/currency_rate.dart';

class CalculatorState extends Equatable {
  final CurrencyRate? fromCurrency;
  final CurrencyRate? toCurrency;
  final double amount;
  final double? result;

  const CalculatorState({
    this.fromCurrency,
    this.toCurrency,
    this.amount = 1.0,
    this.result,
  });

  CalculatorState copyWith({
    CurrencyRate? fromCurrency,
    CurrencyRate? toCurrency,
    double? amount,
    double? result,
    bool clearResult = false,
  }) {
    return CalculatorState(
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      amount: amount ?? this.amount,
      result: clearResult ? null : result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [fromCurrency, toCurrency, amount, result];
}
