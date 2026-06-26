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
