import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/model/currency_rate.dart';
import 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit() : super(const CalculatorState());

  void setFromCurrency(CurrencyRate currency) {
    emit(state.copyWith(fromCurrency: currency));
    _calculate();
  }

  void setToCurrency(CurrencyRate currency) {
    emit(state.copyWith(toCurrency: currency));
    _calculate();
  }

  void setAmount(double amount) {
    emit(state.copyWith(amount: amount));
    _calculate();
  }

  void _calculate() {
    final from = state.fromCurrency;
    final to = state.toCurrency;

    if (from == null || to == null) {
      emit(state.copyWith(clearResult: true));
      return;
    }

    final result = state.amount / from.rate * to.rate;
    emit(state.copyWith(result: result));
  }
}
