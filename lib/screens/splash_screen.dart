import 'dart:async';

import 'package:flutter/material.dart';

import 'login_screen.dart';
import '../services/notification_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    initializeNotification();

    Timer(
      const Duration(seconds: 4),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(
              themeMode: widget.themeMode,
              onThemeChanged: widget.onThemeChanged,
            ),
          ),
        );
      },
    );
  }

  Future<void> initializeNotification() async {
    await NotificationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/splash_screen.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}