import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    const FoodWastageTrackerApp(),
  );
}
class FoodWastageTrackerApp extends StatefulWidget {
  const FoodWastageTrackerApp({super.key});

  @override
  State<FoodWastageTrackerApp> createState() =>
      _FoodWastageTrackerAppState();
}

class _FoodWastageTrackerAppState
    extends State<FoodWastageTrackerApp> {
  ThemeMode themeMode = ThemeMode.system;

  void changeTheme(ThemeMode mode) {
    setState(() {
      themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Wastage Tracker',

      // Light theme
      theme: AppTheme.lightTheme,

      // Dark theme
      darkTheme: AppTheme.darkTheme,

      // Current theme selection
      themeMode: themeMode,

      home: SplashScreen(
  themeMode: themeMode,
  onThemeChanged: changeTheme,
),
    );
  }
}