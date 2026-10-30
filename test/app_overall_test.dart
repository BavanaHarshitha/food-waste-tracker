import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/screens/login_screen.dart';
import '../lib/screens/register_screen.dart';

void main() {
  testWidgets(
    'Food Wastage Tracker overall UI test',
    (WidgetTester tester) async {
      // -----------------------------
      // LOGIN SCREEN TEST
      // -----------------------------

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(
            themeMode: ThemeMode.light,
            onThemeChanged: (_) {},
          ),
        ),
      );

      await tester.pump();

      expect(
        find.text('Food Wastage Tracker'),
        findsOneWidget,
      );

      expect(
        find.text('Welcome back!'),
        findsOneWidget,
      );

      expect(
        find.widgetWithText(
          ElevatedButton,
          'Login',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Register'),
        findsOneWidget,
      );

      // -----------------------------
      // REGISTER SCREEN TEST
      // -----------------------------

      await tester.pumpWidget(
        MaterialApp(
          home: RegisterScreen(
            themeMode: ThemeMode.light,
            onThemeChanged: (_) {},
          ),
        ),
      );

      await tester.pump();

      expect(
        find.text('Create Account'),
        findsNWidgets(2),
      );

      expect(
        find.text('Create Your Account'),
        findsOneWidget,
      );

      expect(
        find.text('Join us in reducing food wastage.'),
        findsOneWidget,
      );

      expect(
        find.widgetWithText(
          ElevatedButton,
          'Create Account',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Login'),
        findsOneWidget,
      );

      expect(
        find.byType(TextField),
        findsNWidgets(4),
      );
    },
  );
}