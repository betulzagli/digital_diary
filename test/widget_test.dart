import 'package:flutter_test/flutter_test.dart';
import 'package:deary/main.dart';

void main() {
  testWidgets('DearyApp renders main navigation and home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const DearyApp());
    await tester.pumpAndSettle();

    // Uygulama başlığı ve navigasyon varlığını kontrol et
    expect(find.text('Deary'), findsOneWidget);
    expect(find.text('Günlük'), findsOneWidget);
    expect(find.text('Yaz'), findsOneWidget);
    expect(find.text('Rapor'), findsOneWidget);
    expect(find.text('Ayarlar'), findsOneWidget);
  });
}
