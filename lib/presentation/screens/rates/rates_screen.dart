import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/rates/rates_bloc.dart';
import '../../bloc/rates/rates_event.dart';
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
          return Column(
            children: [
              SavedCurrencyCard(
                savedCurrency: state.savedCurrency,
                lastUpdated: state.lastUpdated,
                isUsingCache: state.isUsingCache,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.rates.length,
                  itemBuilder: (context, index) {
                    final rate = state.rates[index];
                    final isSaved =
                        rate.code == state.savedCurrency?.code;
                    return CurrencyRateItem(
                      rate: rate,
                      isSaved: isSaved,
                      onSaveToggle: () => context.read<RatesBloc>()
                          .add(SaveCurrencyEvent(rate.code)),
                    );
                  },
                ),
              ),
            ],
          );
        }

        if (state is RatesError) {
          final colorScheme = Theme.of(context).colorScheme;
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off, size: 64, color: colorScheme.onSurfaceVariant),
                const SizedBox(height: 16),
                Text(state.message, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.read<RatesBloc>().add(const LoadRates()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
