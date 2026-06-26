import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/model/currency_rate.dart';
import '../../../domain/repository/currency_repository.dart';
import 'rates_event.dart';
import 'rates_state.dart';

class RatesBloc extends Bloc<RatesEvent, RatesState> {
  final CurrencyRepository _repository;

  RatesBloc(this._repository) : super(const RatesInitial()) {
    on<LoadRates>(_onLoadRates);
    on<RefreshRates>(_onRefreshRates);
  }

  Future<void> _onLoadRates(
    LoadRates event,
    Emitter<RatesState> emit,
  ) async {
    emit(const RatesLoading());
    await _repository.fetchAndCacheRates();

    await Future.wait([
      emit.forEach<List<CurrencyRate>>(
        _repository.watchAllRates(),
        onData: (rates) {
          final lastUpdated =
              rates.isNotEmpty ? rates.first.updatedAt : null;
          final saved =
              state is RatesLoaded ? (state as RatesLoaded).savedCurrency : null;
          return RatesLoaded(
            rates: rates,
            savedCurrency: saved,
            lastUpdated: lastUpdated,
            isUsingCache: lastUpdated != null,
          );
        },
      ),
      emit.forEach<CurrencyRate?>(
        _repository.watchSavedCurrency(),
        onData: (saved) {
          final current = state is RatesLoaded ? state as RatesLoaded : null;
          return RatesLoaded(
            rates: current?.rates ?? const [],
            savedCurrency: saved,
            lastUpdated: current?.lastUpdated,
            isUsingCache: current?.lastUpdated != null,
          );
        },
      ),
    ]);
  }

  Future<void> _onRefreshRates(
    RefreshRates event,
    Emitter<RatesState> emit,
  ) async {
    await _repository.fetchAndCacheRates();
  }
}
