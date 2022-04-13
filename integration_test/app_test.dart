import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:gps_tracker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
    (WidgetTester tester) async {
      app.main();
      
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 10));

      final Finder button = find.byIcon(Icons.add_location_alt_rounded);
      // Verify the counter starts at 0.
      // expect(find.text('Start Tracking'), findsOneWidget);
      expect(button, findsOneWidget);

      // // Finds the floating action button to tap on.
      // final Finder fab = find.byTooltip('Start');

      // // Emulate a tap on the floating action button.
      await tester.tap(button);
      await Future.delayed(const Duration(seconds: 10));
      // // Trigger a frame.
      await tester.pumpAndSettle();

      // // Verify the counter increments by 1.
      expect(find.text('Rotas'), findsOneWidget);
    });
  });
}