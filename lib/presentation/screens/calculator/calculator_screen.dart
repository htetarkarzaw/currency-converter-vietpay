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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RatesBloc, RatesState>(
      builder: (context, ratesState) {
        final rates =
            ratesState is RatesLoaded ? ratesState.rates : <CurrencyRate>[];

        return BlocBuilder<CalculatorCubit, CalculatorState>(
          builder: (context, calcState) {
            final from = _lookup(rates, calcState.fromCurrencyCode);
            final to = _lookup(rates, calcState.toCurrencyCode);
            final result = from != null && to != null
                ? calcState.amount / from.rate * to.rate
                : null;

            return OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.landscape) {
                  return _LandscapeLayout(
                    from: from,
                    to: to,
                    result: result,
                    rates: rates,
                    onShowFromPicker: () => _showPicker(
                      context,
                      rates,
                      (code) =>
                          context.read<CalculatorCubit>().setFromCurrency(code),
                    ),
                    onShowToPicker: () => _showPicker(
                      context,
                      rates,
                      (code) =>
                          context.read<CalculatorCubit>().setToCurrency(code),
                    ),
                    onAmountChanged: (value) => context
                        .read<CalculatorCubit>()
                        .setAmount(double.tryParse(value) ?? 0),
                    onSwap: () =>
                        context.read<CalculatorCubit>().swapCurrencies(),
                  );
                }
                return _PortraitLayout(
                  from: from,
                  to: to,
                  result: result,
                  rates: rates,
                  onShowFromPicker: () => _showPicker(
                    context,
                    rates,
                    (code) =>
                        context.read<CalculatorCubit>().setFromCurrency(code),
                  ),
                  onShowToPicker: () => _showPicker(
                    context,
                    rates,
                    (code) =>
                        context.read<CalculatorCubit>().setToCurrency(code),
                  ),
                  onAmountChanged: (value) => context
                      .read<CalculatorCubit>()
                      .setAmount(double.tryParse(value) ?? 0),
                  onSwap: () =>
                      context.read<CalculatorCubit>().swapCurrencies(),
                );
              },
            );
          },
        );
      },
    );
  }
}

// ── Layouts ──────────────────────────────────────────────────────────────────

class _PortraitLayout extends StatelessWidget {
  const _PortraitLayout({
    required this.from,
    required this.to,
    required this.result,
    required this.rates,
    required this.onShowFromPicker,
    required this.onShowToPicker,
    required this.onAmountChanged,
    required this.onSwap,
  });

  final CurrencyRate? from;
  final CurrencyRate? to;
  final double? result;
  final List<CurrencyRate> rates;
  final VoidCallback onShowFromPicker;
  final VoidCallback onShowToPicker;
  final ValueChanged<String> onAmountChanged;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('From', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            _CurrencySelector(currency: from, onTap: onShowFromPicker),
            const SizedBox(height: 16),
            Text('Amount', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            _AmountInput(onChanged: onAmountChanged),
            Center(child: _SwapButton(onSwap: onSwap)),
            Text('To', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            _CurrencySelector(currency: to, onTap: onShowToPicker),
            const SizedBox(height: 24),
            _ResultCard(from: from, to: to, result: result),
          ],
        ),
      ),
    );
  }
}

class _LandscapeLayout extends StatelessWidget {
  const _LandscapeLayout({
    required this.from,
    required this.to,
    required this.result,
    required this.rates,
    required this.onShowFromPicker,
    required this.onShowToPicker,
    required this.onAmountChanged,
    required this.onSwap,
  });

  final CurrencyRate? from;
  final CurrencyRate? to;
  final double? result;
  final List<CurrencyRate> rates;
  final VoidCallback onShowFromPicker;
  final VoidCallback onShowToPicker;
  final ValueChanged<String> onAmountChanged;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('From',
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 8),
                  _CurrencySelector(currency: from, onTap: onShowFromPicker),
                  const SizedBox(height: 16),
                  Text('Amount',
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 8),
                  _AmountInput(onChanged: onAmountChanged),
                  Center(child: _SwapButton(onSwap: onSwap)),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('To', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 8),
                  _CurrencySelector(currency: to, onTap: onShowToPicker),
                  const SizedBox(height: 24),
                  _ResultCard(from: from, to: to, result: result),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

class _CurrencySelector extends StatelessWidget {
  const _CurrencySelector({required this.currency, required this.onTap});

  final CurrencyRate? currency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                  currency != null ? currency!.code.substring(0, 2) : '??',
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
}

class _AmountInput extends StatelessWidget {
  const _AmountInput({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: '0.00',
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.from, required this.to, required this.result});

  final CurrencyRate? from;
  final CurrencyRate? to;
  final double? result;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: result == null
          ? Center(
              child: Text(
                'Select currencies to convert',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${result!.toStringAsFixed(2)} ${to!.code}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '1 ${from!.code} = ${(to!.rate / from!.rate).toStringAsFixed(4)} ${to!.code}',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
    );
  }
}

class _SwapButton extends StatelessWidget {
  const _SwapButton({required this.onSwap});

  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.swap_vert),
      onPressed: onSwap,
    );
  }
}
