import 'package:equatable/equatable.dart';

class CurrencyRate extends Equatable {
  final String code;
  final double rate;
  final DateTime updatedAt;

  const CurrencyRate({
    required this.code,
    required this.rate,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [code, rate, updatedAt];
}
