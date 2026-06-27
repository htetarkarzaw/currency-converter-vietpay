import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/injection.dart';
import '../../../domain/repository/currency_repository.dart';
import '../../bloc/rates/rates_bloc.dart';
import '../../bloc/rates/rates_state.dart';
import 'widgets/currency_rate_item.dart';
import 'widgets/saved_currency_card.dart';

class RatesScreen extends StatelessWidget {
  const RatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RatesBloc, RatesState>(
      builder: (context, state) {
        if (state is RatesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is RatesLoaded) {
          final isoPattern = RegExp(r'^[A-Z]+$');
          bool isIso(String code) =>
              code.length == 3 && isoPattern.hasMatch(code);
          final sortedRates = [...state.rates]
            ..sort((a, b) {
              final aIso = isIso(a.code);
              final bIso = isIso(b.code);
              if (aIso && !bIso) return -1;
              if (!aIso && bIso) return 1;
              return a.code.compareTo(b.code);
            });
          return Column(
            children: [
              SavedCurrencyCard(
                savedCurrency: state.savedCurrency,
                lastUpdated: state.lastUpdated,
                isUsingCache: state.isUsingCache,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sortedRates.length,
                  itemBuilder: (context, index) {
                    final rate = sortedRates[index];
                    final isSaved =
                        rate.code == state.savedCurrency?.code;
                    return CurrencyRateItem(
                      rate: rate,
                      isSaved: isSaved,
                      onSaveToggle: () => getIt<CurrencyRepository>()
                          .saveSelectedCurrency(rate.code),
                    );
                  },
                ),
              ),
            ],
          );
        }

        if (state is RatesError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox.shrink();
      },
    );
  }
}
