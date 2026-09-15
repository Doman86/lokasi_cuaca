import 'package:flutter_test/flutter_test.dart';

import 'package:api_test2/main.dart';

void main() {
  testWidgets('Aplikasi berhasil dibuka', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MyApp), findsOneWidget);
  });
}