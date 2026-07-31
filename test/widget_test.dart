import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wellstride_app/app/app.dart';
import 'package:wellstride_app/providers/auth_provider.dart';

void main() {
  testWidgets('Shows the login screen when signed out', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateChangesProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: const WellStrideApp(),
      ),
    );
    await tester.pump();

    expect(find.text('WellStride'), findsOneWidget);
    expect(
      find.widgetWithText(TextButton, "Don't have an account? Sign up"),
      findsOneWidget,
    );
  });
}
