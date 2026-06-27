import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/model/currency_rate.dart';

class SavedCurrencyCard extends StatelessWidget {
  final CurrencyRate? savedCurrency;
  final DateTime? lastUpdated;
  final bool isUsingCache;

  const SavedCurrencyCard({
    super.key,
    required this.savedCurrency,
    required this.lastUpdated,
    required this.isUsingCache,
  });

  static const _borderRadius = BorderRadius.all(Radius.circular(16));

  @override
  Widget build(BuildContext context) {
    if (savedCurrency == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: _borderRadius,
          ),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: Row(
            children: [
              Icon(Icons.star_border,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 12),
              const Text('Tap ★ to pin a currency'),
            ],
          ),
        ),
      );
    }

    final rate = 1 / savedCurrency!.rate;
    final formatted = rate.toStringAsFixed(4);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF1B5E20),
          borderRadius: _borderRadius,
        ),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${savedCurrency!.code} → USD',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '1 ${savedCurrency!.code} = $formatted USD',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isUsingCache
                  ? 'Using cached data'
                  : 'Updated ${DateFormat('HH:mm').format(lastUpdated!)}',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
