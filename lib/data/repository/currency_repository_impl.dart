import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../../domain/model/currency_rate.dart';
import '../../domain/repository/currency_repository.dart';
import '../local/database.dart' as local;

class CurrencyRepositoryImpl implements CurrencyRepository {
  final local.AppDatabase _db;
  final Dio _dio;

  CurrencyRepositoryImpl({
    required local.AppDatabase db,
    required Dio dio,
  })  : _db = db,
        _dio = dio;

  @override
  Stream<List<CurrencyRate>> watchAllRates() {
    return _db.watchAllRates().map(
          (rows) => rows
              .map((r) => CurrencyRate(
                    code: r.code,
                    rate: r.rate,
                    updatedAt: r.updatedAt,
                  ))
              .toList(),
        );
  }

  @override
  Future<void> fetchAndCacheRates() async {
    try {
      final response = await _dio.get(
        '$baseUrl/rates/latest',
        queryParameters: {'apikey': apiKey},
      );
      final Map<String, dynamic> rates =
          response.data['rates'] as Map<String, dynamic>;
      final now = DateTime.now();
      final companions = rates.entries
          .map(
            (e) => local.CurrencyRatesCompanion.insert(
              code: e.key,
              rate: double.parse(e.value as String),
              updatedAt: now,
            ),
          )
          .toList();
      await _db.upsertRates(companions);
    } catch (_) {}
  }

  @override
  Future<CurrencyRate?> getSavedCurrency() async {
    final saved = await _db.getSavedCurrency();
    if (saved == null) return null;
    final rates = await _db.watchAllRates().first;
    final matches = rates.where((r) => r.code == saved.code);
    if (matches.isEmpty) return null;
    final match = matches.first;
    return CurrencyRate(
      code: match.code,
      rate: match.rate,
      updatedAt: match.updatedAt,
    );
  }

  @override
  Future<void> saveSelectedCurrency(String code) =>
      _db.upsertSavedCurrency(code);

  @override
  Future<DateTime?> getLastUpdated() => _db.getLastUpdated();
}
