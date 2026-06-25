import 'package:flutter_test/flutter_test.dart';

import 'package:currency_converter/main.dart';

void main() {
  testWidgets('CurrencyConverterApp loads without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const CurrencyConverterApp());
    await tester.pumpAndSettle();

    expect(find.text('Currency Converter'), findsOneWidget);
  });
}