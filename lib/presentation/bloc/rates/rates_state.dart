import 'package:equatable/equatable.dart';

import '../../../domain/model/currency_rate.dart';

abstract class RatesState extends Equatable {
  const RatesState();
}

class RatesInitial extends RatesState {
  const RatesInitial();

  @override
  List<Object?> get props => [];
}

class RatesLoading extends RatesState {
  const RatesLoading();

  @override
  List<Object?> get props => [];
}

class RatesLoaded extends RatesState {
  final List<CurrencyRate> rates;
  final CurrencyRate? savedCurrency;
  final DateTime? lastUpdated;
  final bool isUsingCache;
  final bool isRefreshing;

  const RatesLoaded({
    required this.rates,
    required this.savedCurrency,
    required this.lastUpdated,
    required this.isUsingCache,
    this.isRefreshing = false,
  });

  @override
  List<Object?> get props =>
      [rates, savedCurrency, lastUpdated, isUsingCache, isRefreshing];
}

class RatesError extends RatesState {
  final String message;

  const RatesError({required this.message});

  @override
  List<Object?> get props => [message];
}
