import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../core/constants/api_constants.dart';
import '../data/local/database.dart';
import '../data/repository/currency_repository_impl.dart';
import '../domain/repository/currency_repository.dart';
import '../presentation/bloc/calculator/calculator_cubit.dart';
import '../presentation/bloc/rates/rates_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    ),
  );

  getIt.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(
      db: getIt<AppDatabase>(),
      dio: getIt<Dio>(),
    ),
  );

  getIt.registerFactory<RatesBloc>(
    () => RatesBloc(getIt<CurrencyRepository>()),
  );

  getIt.registerFactory<CalculatorCubit>(() => CalculatorCubit());
}
