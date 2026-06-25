// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CurrencyRatesTable extends CurrencyRates
    with TableInfo<$CurrencyRatesTable, CurrencyRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrencyRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
      'rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [code, rate, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currency_rates';
  @override
  VerificationContext validateIntegrity(Insertable<CurrencyRate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
          _rateMeta, rate.isAcceptableOrUnknown(data['rate']!, _rateMeta));
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  CurrencyRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurrencyRate(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      rate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rate'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CurrencyRatesTable createAlias(String alias) {
    return $CurrencyRatesTable(attachedDatabase, alias);
  }
}

class CurrencyRate extends DataClass implements Insertable<CurrencyRate> {
  final String code;
  final double rate;
  final DateTime updatedAt;
  const CurrencyRate(
      {required this.code, required this.rate, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['rate'] = Variable<double>(rate);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CurrencyRatesCompanion toCompanion(bool nullToAbsent) {
    return CurrencyRatesCompanion(
      code: Value(code),
      rate: Value(rate),
      updatedAt: Value(updatedAt),
    );
  }

  factory CurrencyRate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurrencyRate(
      code: serializer.fromJson<String>(json['code']),
      rate: serializer.fromJson<double>(json['rate']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'rate': serializer.toJson<double>(rate),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CurrencyRate copyWith({String? code, double? rate, DateTime? updatedAt}) =>
      CurrencyRate(
        code: code ?? this.code,
        rate: rate ?? this.rate,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CurrencyRate copyWithCompanion(CurrencyRatesCompanion data) {
    return CurrencyRate(
      code: data.code.present ? data.code.value : this.code,
      rate: data.rate.present ? data.rate.value : this.rate,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurrencyRate(')
          ..write('code: $code, ')
          ..write('rate: $rate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, rate, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurrencyRate &&
          other.code == this.code &&
          other.rate == this.rate &&
          other.updatedAt == this.updatedAt);
}

class CurrencyRatesCompanion extends UpdateCompanion<CurrencyRate> {
  final Value<String> code;
  final Value<double> rate;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CurrencyRatesCompanion({
    this.code = const Value.absent(),
    this.rate = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurrencyRatesCompanion.insert({
    required String code,
    required double rate,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        rate = Value(rate),
        updatedAt = Value(updatedAt);
  static Insertable<CurrencyRate> custom({
    Expression<String>? code,
    Expression<double>? rate,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (rate != null) 'rate': rate,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurrencyRatesCompanion copyWith(
      {Value<String>? code,
      Value<double>? rate,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CurrencyRatesCompanion(
      code: code ?? this.code,
      rate: rate ?? this.rate,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrencyRatesCompanion(')
          ..write('code: $code, ')
          ..write('rate: $rate, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedCurrenciesTable extends SavedCurrencies
    with TableInfo<$SavedCurrenciesTable, SavedCurrency> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedCurrenciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, code];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_currencies';
  @override
  VerificationContext validateIntegrity(Insertable<SavedCurrency> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedCurrency map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedCurrency(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
    );
  }

  @override
  $SavedCurrenciesTable createAlias(String alias) {
    return $SavedCurrenciesTable(attachedDatabase, alias);
  }
}

class SavedCurrency extends DataClass implements Insertable<SavedCurrency> {
  final int id;
  final String code;
  const SavedCurrency({required this.id, required this.code});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    return map;
  }

  SavedCurrenciesCompanion toCompanion(bool nullToAbsent) {
    return SavedCurrenciesCompanion(
      id: Value(id),
      code: Value(code),
    );
  }

  factory SavedCurrency.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedCurrency(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
    };
  }

  SavedCurrency copyWith({int? id, String? code}) => SavedCurrency(
        id: id ?? this.id,
        code: code ?? this.code,
      );
  SavedCurrency copyWithCompanion(SavedCurrenciesCompanion data) {
    return SavedCurrency(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedCurrency(')
          ..write('id: $id, ')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedCurrency &&
          other.id == this.id &&
          other.code == this.code);
}

class SavedCurrenciesCompanion extends UpdateCompanion<SavedCurrency> {
  final Value<int> id;
  final Value<String> code;
  const SavedCurrenciesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
  });
  SavedCurrenciesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
  }) : code = Value(code);
  static Insertable<SavedCurrency> custom({
    Expression<int>? id,
    Expression<String>? code,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
    });
  }

  SavedCurrenciesCompanion copyWith({Value<int>? id, Value<String>? code}) {
    return SavedCurrenciesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedCurrenciesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CurrencyRatesTable currencyRates = $CurrencyRatesTable(this);
  late final $SavedCurrenciesTable savedCurrencies =
      $SavedCurrenciesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [currencyRates, savedCurrencies];
}

typedef $$CurrencyRatesTableCreateCompanionBuilder = CurrencyRatesCompanion
    Function({
  required String code,
  required double rate,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CurrencyRatesTableUpdateCompanionBuilder = CurrencyRatesCompanion
    Function({
  Value<String> code,
  Value<double> rate,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CurrencyRatesTableFilterComposer
    extends Composer<_$AppDatabase, $CurrencyRatesTable> {
  $$CurrencyRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CurrencyRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrencyRatesTable> {
  $$CurrencyRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CurrencyRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrencyRatesTable> {
  $$CurrencyRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CurrencyRatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CurrencyRatesTable,
    CurrencyRate,
    $$CurrencyRatesTableFilterComposer,
    $$CurrencyRatesTableOrderingComposer,
    $$CurrencyRatesTableAnnotationComposer,
    $$CurrencyRatesTableCreateCompanionBuilder,
    $$CurrencyRatesTableUpdateCompanionBuilder,
    (
      CurrencyRate,
      BaseReferences<_$AppDatabase, $CurrencyRatesTable, CurrencyRate>
    ),
    CurrencyRate,
    PrefetchHooks Function()> {
  $$CurrencyRatesTableTableManager(_$AppDatabase db, $CurrencyRatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrencyRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrencyRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrencyRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<double> rate = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CurrencyRatesCompanion(
            code: code,
            rate: rate,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required double rate,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CurrencyRatesCompanion.insert(
            code: code,
            rate: rate,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CurrencyRatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CurrencyRatesTable,
    CurrencyRate,
    $$CurrencyRatesTableFilterComposer,
    $$CurrencyRatesTableOrderingComposer,
    $$CurrencyRatesTableAnnotationComposer,
    $$CurrencyRatesTableCreateCompanionBuilder,
    $$CurrencyRatesTableUpdateCompanionBuilder,
    (
      CurrencyRate,
      BaseReferences<_$AppDatabase, $CurrencyRatesTable, CurrencyRate>
    ),
    CurrencyRate,
    PrefetchHooks Function()>;
typedef $$SavedCurrenciesTableCreateCompanionBuilder = SavedCurrenciesCompanion
    Function({
  Value<int> id,
  required String code,
});
typedef $$SavedCurrenciesTableUpdateCompanionBuilder = SavedCurrenciesCompanion
    Function({
  Value<int> id,
  Value<String> code,
});

class $$SavedCurrenciesTableFilterComposer
    extends Composer<_$AppDatabase, $SavedCurrenciesTable> {
  $$SavedCurrenciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));
}

class $$SavedCurrenciesTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedCurrenciesTable> {
  $$SavedCurrenciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));
}

class $$SavedCurrenciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedCurrenciesTable> {
  $$SavedCurrenciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);
}

class $$SavedCurrenciesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SavedCurrenciesTable,
    SavedCurrency,
    $$SavedCurrenciesTableFilterComposer,
    $$SavedCurrenciesTableOrderingComposer,
    $$SavedCurrenciesTableAnnotationComposer,
    $$SavedCurrenciesTableCreateCompanionBuilder,
    $$SavedCurrenciesTableUpdateCompanionBuilder,
    (
      SavedCurrency,
      BaseReferences<_$AppDatabase, $SavedCurrenciesTable, SavedCurrency>
    ),
    SavedCurrency,
    PrefetchHooks Function()> {
  $$SavedCurrenciesTableTableManager(
      _$AppDatabase db, $SavedCurrenciesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedCurrenciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedCurrenciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedCurrenciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
          }) =>
              SavedCurrenciesCompanion(
            id: id,
            code: code,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
          }) =>
              SavedCurrenciesCompanion.insert(
            id: id,
            code: code,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SavedCurrenciesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SavedCurrenciesTable,
    SavedCurrency,
    $$SavedCurrenciesTableFilterComposer,
    $$SavedCurrenciesTableOrderingComposer,
    $$SavedCurrenciesTableAnnotationComposer,
    $$SavedCurrenciesTableCreateCompanionBuilder,
    $$SavedCurrenciesTableUpdateCompanionBuilder,
    (
      SavedCurrency,
      BaseReferences<_$AppDatabase, $SavedCurrenciesTable, SavedCurrency>
    ),
    SavedCurrency,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CurrencyRatesTableTableManager get currencyRates =>
      $$CurrencyRatesTableTableManager(_db, _db.currencyRates);
  $$SavedCurrenciesTableTableManager get savedCurrencies =>
      $$SavedCurrenciesTableTableManager(_db, _db.savedCurrencies);
}
