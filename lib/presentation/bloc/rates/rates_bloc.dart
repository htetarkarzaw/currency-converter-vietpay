import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/model/currency_rate.dart';
import '../../../domain/repository/currency_repository.dart';
import 'rates_event.dart';
import 'rates_state.dart';

class RatesBloc extends Bloc<RatesEvent, RatesState> {
  final CurrencyRepository _repository;

  static final _isoPattern = RegExp(r'^[A-Z]+$');
  static bool _isIso(String code) =>
      code.length == 3 && _isoPattern.hasMatch(code);

  static List<CurrencyRate> _sorted(List<CurrencyRate> rates) =>
      [...rates]..sort((a, b) {
          final aIso = _isIso(a.code);
          final bIso = _isIso(b.code);
          if (aIso && !bIso) return -1;
          if (!aIso && bIso) return 1;
          return a.code.compareTo(b.code);
        });

  RatesBloc(this._repository) : super(const RatesInitial()) {
    on<LoadRates>(_onLoadRates);
    on<RefreshRates>(_onRefreshRates);
    on<SaveCurrencyEvent>(_onSaveCurrency);
  }

  Future<void> _onLoadRates(
    LoadRates event,
    Emitter<RatesState> emit,
  ) async {
    emit(const RatesLoading());
    final networkSucceeded = await _repository.fetchAndCacheRates();

    if (!networkSucceeded) {
      final cached = await _repository.watchAllRates().first;
      if (cached.isEmpty) {
        emit(const RatesError(
            message: 'No data available. Please check your connection.'));
        return;
      }
    }

    await Future.wait([
      emit.forEach<List<CurrencyRate>>(
        _repository.watchAllRates(),
        onData: (rates) {
          final sorted = _sorted(rates);
          final lastUpdated = sorted.isNotEmpty
              ? sorted.map((r) => r.updatedAt).reduce((a, b) => a.isAfter(b) ? a : b)
              : null;
          final saved =
              state is RatesLoaded ? (state as RatesLoaded).savedCurrency : null;
          return RatesLoaded(
            rates: sorted,
            savedCurrency: saved,
            lastUpdated: lastUpdated,
            isUsingCache: !networkSucceeded,
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
            isUsingCache: !networkSucceeded,
          );
        },
      ),
    ]);
  }

  Future<void> _onSaveCurrency(
    SaveCurrencyEvent event,
    Emitter<RatesState> emit,
  ) async {
    await _repository.saveSelectedCurrency(event.code);
  }

  Future<void> _onRefreshRates(
    RefreshRates event,
    Emitter<RatesState> emit,
  ) async {
    if (state is! RatesLoaded) return;

    final before = state as RatesLoaded;
    emit(RatesLoaded(
      rates: before.rates,
      savedCurrency: before.savedCurrency,
      lastUpdated: before.lastUpdated,
      isUsingCache: before.isUsingCache,
      isRefreshing: true,
    ));

    final networkSucceeded = await _repository.fetchAndCacheRates();

    if (state is RatesLoaded) {
      final after = state as RatesLoaded;
      emit(RatesLoaded(
        rates: after.rates,
        savedCurrency: after.savedCurrency,
        lastUpdated: after.lastUpdated,
        isUsingCache: !networkSucceeded,
        isRefreshing: false,
      ));
    }
  }
}
