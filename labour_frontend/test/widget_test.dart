// 📦 FLUTTER WIDGET TEST FILE
//
// This test verifies the basic functionality of the counter in the application.
// It ensures the counter starts at 0 and increments correctly when tapped.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labour_frontend/main.dart';

void main() {
  testWidgets('Counter increments test', (WidgetTester tester) async {
    // 🏗️ Build the application and trigger a frame.
    await tester.pumpWidget(const LaborMarketplaceApp());

    // 🔍 Verify that the initial counter value is 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // 👆 Simulate a tap on the '+' button and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // 🔄 Verify that the counter has incremented to 1.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
