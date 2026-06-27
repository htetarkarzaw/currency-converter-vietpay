import 'package:flutter_bloc/flutter_bloc.dart';

import 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit() : super(const CalculatorState());

  void setFromCurrency(String code) =>
      emit(state.copyWith(fromCurrencyCode: code));

  void setToCurrency(String code) =>
      emit(state.copyWith(toCurrencyCode: code));

  void setAmount(double amount) => emit(state.copyWith(amount: amount));

  void swapCurrencies() {
    emit(CalculatorState(
      fromCurrencyCode: state.toCurrencyCode,
      toCurrencyCode: state.fromCurrencyCode,
      amount: state.amount,
    ));
  }
}
