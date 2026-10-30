import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/screens/login_screen.dart';

void main() {
  testWidgets(
    'Login button should show validation SnackBar',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(
            themeMode: ThemeMode.light,
            onThemeChanged: (_) {},
          ),
        ),
      );

      // Find the Login button.
      final loginButton = find.widgetWithText(
        ElevatedButton,
        'Login',
      );

      expect(loginButton, findsOneWidget);

      // Tap the Login button.
      await tester.tap(loginButton);

      // Allow the SnackBar to appear.
      await tester.pump();

      // Check that a SnackBar appeared.
      expect(
        find.byType(SnackBar),
        findsOneWidget,
      );
    },
  );
}