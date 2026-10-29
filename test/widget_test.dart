import 'package:flutter_test/flutter_test.dart';
import 'package:carbuy_khodro/main.dart';

void main() {
  testWidgets('CarBuyKhodro home screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const CarBuyApp());
    expect(find.text('کاربای خودرو'), findsOneWidget);
    expect(find.text('ماشین بعدی‌ات\nاینجاست.'), findsOneWidget);
  });
}
