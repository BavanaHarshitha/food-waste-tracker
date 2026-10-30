import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/screens/register_screen.dart';

void main() {
  testWidgets(
    'Register screen should contain Login link',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RegisterScreen(
            themeMode: ThemeMode.light,
            onThemeChanged: (_) {},
          ),
        ),
      );

      final loginLink = find.text('Login');

      expect(
        loginLink,
        findsOneWidget,
      );

      // Scroll the Login link into the visible area.
      await tester.ensureVisible(loginLink);

      await tester.pump();

      // Tap the Login link.
      await tester.tap(loginLink);

      // Allow navigation to finish.
      await tester.pumpAndSettle();

      // Login screen should now be displayed.
      expect(
        find.text('Welcome back!'),
        findsOneWidget,
      );
    },
  );
}