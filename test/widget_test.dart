import 'package:flutter_test/flutter_test.dart';

import 'package:wellstride_app/app/app.dart';

void main() {
  testWidgets('WellStrideApp renders without crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const WellStrideApp());

    expect(find.text('WellStride'), findsOneWidget);
  });
}
