import '../model/currency_rate.dart';

abstract class CurrencyRepository {
  Stream<List<CurrencyRate>> watchAllRates();
  Future<void> fetchAndCacheRates();
  Future<CurrencyRate?> getSavedCurrency();
  Future<void> saveSelectedCurrency(String code);
  Future<DateTime?> getLastUpdated();
}
