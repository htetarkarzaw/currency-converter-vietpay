import 'package:equatable/equatable.dart';

abstract class RatesEvent extends Equatable {
  const RatesEvent();
}

class LoadRates extends RatesEvent {
  const LoadRates();

  @override
  List<Object?> get props => [];
}

class RefreshRates extends RatesEvent {
  const RefreshRates();

  @override
  List<Object?> get props => [];
}

class SaveCurrencyEvent extends RatesEvent {
  final String code;
  const SaveCurrencyEvent(this.code);

  @override
  List<Object?> get props => [code];
}
