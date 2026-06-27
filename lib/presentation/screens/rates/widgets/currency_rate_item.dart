import 'package:flutter/material.dart';

import '../../../../core/utils/currency_formatter.dart';
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
          rate.code.length >= 2 ? rate.code.substring(0, 2) : rate.code,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      title: Text(
        rate.code,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${CurrencyFormatter.formatRate(rate.rate)} per USD'),
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
