import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class CurrencyRates extends Table {
  TextColumn get code => text()();
  RealColumn get rate => real()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {code};
}

class SavedCurrencies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()();
}

@DriftDatabase(tables: [CurrencyRates, SavedCurrencies])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<CurrencyRate>> watchAllRates() =>
      select(currencyRates).watch();

  Future<void> upsertRates(List<CurrencyRatesCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(currencyRates, rows));
  }

  Future<SavedCurrency?> getSavedCurrency() =>
      (select(savedCurrencies)..limit(1)).getSingleOrNull();

  Future<void> upsertSavedCurrency(String code) async {
    await transaction(() async {
      await delete(savedCurrencies).go();
      await into(savedCurrencies).insert(
        SavedCurrenciesCompanion.insert(code: code),
      );
    });
  }

  Stream<CurrencyRate?> watchSavedCurrencyWithRate() {
    final query = select(savedCurrencies).join([
      innerJoin(
        currencyRates,
        currencyRates.code.equalsExp(savedCurrencies.code),
      ),
    ])..limit(1);

    return query.watch().map((rows) {
      if (rows.isEmpty) return null;
      return rows.first.readTable(currencyRates);
    });
  }

  Future<DateTime?> getLastUpdated() async {
    final query = selectOnly(currencyRates)
      ..addColumns([currencyRates.updatedAt])
      ..orderBy([OrderingTerm.desc(currencyRates.updatedAt)])
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row?.read(currencyRates.updatedAt);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = p.join(dir.path, 'currency_converter.db');
    return NativeDatabase.createInBackground(File(file));
  });
}