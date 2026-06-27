import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatRate(double rate) =>
      NumberFormat('#,##0.0000').format(rate);

  static String formatAmount(double amount) =>
      NumberFormat('#,##0.00').format(amount);
}
