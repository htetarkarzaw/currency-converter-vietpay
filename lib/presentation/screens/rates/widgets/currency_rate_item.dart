import 'package:flutter/material.dart';

import '../../../../domain/model/currency_rate.dart';

class CurrencyRateItem extends StatelessWidget {
  final CurrencyRate rate;
  final bool isSaved;
  final VoidCallback onSaveToggle;

  const CurrencyRateItem({
    super.key,
    required this.rate,
    required this.isSaved,
    required this.onSaveToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        child: Text(
          rate.code.substring(0, 2),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      title: Text(
        rate.code,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${rate.rate.toStringAsFixed(4)} per USD'),
      trailing: IconButton(
        icon: Icon(
          isSaved ? Icons.star : Icons.star_border,
          color: isSaved ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
        onPressed: onSaveToggle,
      ),
    );
  }
}
