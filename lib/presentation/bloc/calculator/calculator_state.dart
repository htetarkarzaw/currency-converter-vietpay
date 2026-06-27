import 'package:equatable/equatable.dart';

class CalculatorState extends Equatable {
  final String? fromCurrencyCode;
  final String? toCurrencyCode;
  final double amount;

  const CalculatorState({
    this.fromCurrencyCode,
    this.toCurrencyCode,
    this.amount = 1.0,
  });

  CalculatorState copyWith({
    String? fromCurrencyCode,
    String? toCurrencyCode,
    double? amount,
  }) {
    return CalculatorState(
      fromCurrencyCode: fromCurrencyCode ?? this.fromCurrencyCode,
      toCurrencyCode: toCurrencyCode ?? this.toCurrencyCode,
      amount: amount ?? this.amount,
    );
  }

  @override
  List<Object?> get props => [fromCurrencyCode, toCurrencyCode, amount];
}
