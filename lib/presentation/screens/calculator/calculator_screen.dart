import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/injection.dart';
import '../../../domain/model/currency_rate.dart';
import '../../bloc/calculator/calculator_cubit.dart';
import '../../bloc/calculator/calculator_state.dart';
import '../../bloc/rates/rates_bloc.dart';
import '../../bloc/rates/rates_state.dart';
import 'currency_picker_bottom_sheet.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CalculatorCubit>(),
      child: const _CalculatorView(),
    );
  }
}

class _CalculatorView extends StatelessWidget {
  const _CalculatorView();

  CurrencyRate? _lookup(List<CurrencyRate> rates, String? code) {
    if (code == null) return null;
    for (final r in rates) {
      if (r.code == code) return r;
    }
    return null;
  }

  Future<void> _showPicker(
    BuildContext context,
    List<CurrencyRate> rates,
    void Function(String code) onSelected,
  ) async {
    final selected = await showModalBottomSheet<CurrencyRate>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => CurrencyPickerBottomSheet(rates: rates),
    );
    if (selected != null) onSelected(selected.code);
  }

  Widget _buildCurrencySelector(
    BuildContext context, {
    required CurrencyRate? currency,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                child: Text(
                  currency != null ? currency.code.substring(0, 2) : '??',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  currency?.code ?? 'Select currency',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: currency != null
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_down,
                  color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<RatesBloc, RatesState>(
      builder: (context, ratesState) {
        final rates =
            ratesState is RatesLoaded ? ratesState.rates : <CurrencyRate>[];

        return BlocBuilder<CalculatorCubit, CalculatorState>(
          builder: (context, calcState) {
            final cubit = context.read<CalculatorCubit>();
            final from = _lookup(rates, calcState.fromCurrencyCode);
            final to = _lookup(rates, calcState.toCurrencyCode);
            final result = from != null && to != null
                ? calcState.amount / from.rate * to.rate
                : null;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // From
                    Text('From',
                        style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 8),
                    _buildCurrencySelector(
                      context,
                      currency: from,
                      onTap: () => _showPicker(
                        context,
                        rates,
                        cubit.setFromCurrency,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Amount
                    Text('Amount',
                        style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 8),
                    TextField(
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      onChanged: (value) =>
                          cubit.setAmount(double.tryParse(value) ?? 0),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        filled: true,
                        fillColor: colorScheme.surfaceContainerLow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    // Swap button
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.swap_vert),
                        onPressed: cubit.swapCurrencies,
                      ),
                    ),

                    // To
                    Text('To', style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 8),
                    _buildCurrencySelector(
                      context,
                      currency: to,
                      onTap: () => _showPicker(
                        context,
                        rates,
                        cubit.setToCurrency,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Result card
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: result == null
                          ? Center(
                              child: Text(
                                'Select currencies to convert',
                                style: TextStyle(
                                    color: colorScheme.onSurfaceVariant),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${result.toStringAsFixed(2)} ${to!.code}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '1 ${from!.code} = ${(to.rate / from.rate).toStringAsFixed(4)} ${to.code}',
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
