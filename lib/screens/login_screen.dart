import 'package:flutter/material.dart';

import '../services/database_service.dart';
import '../theme/app_theme.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final DatabaseService databaseService = DatabaseService();

  bool obscurePassword = true;
  bool isLoggingIn = false;

  // =======================================================
  // LOGIN
  // =======================================================

  Future<void> login() async {
    final String email = emailController.text.trim().toLowerCase();

    final String password = passwordController.text.trim();

    // -------------------------------------------------------
    // CHECK EMPTY FIELDS
    // -------------------------------------------------------

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    // -------------------------------------------------------
    // CHECK EMAIL
    // -------------------------------------------------------

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    // -------------------------------------------------------
    // CHECK PASSWORD
    // -------------------------------------------------------

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must contain at least 6 characters'),
        ),
      );
      return;
    }

    // -------------------------------------------------------
    // SHOW LOADING
    // -------------------------------------------------------

    setState(() {
      isLoggingIn = true;
    });

    try {
      // -----------------------------------------------------
      // CHECK USER FROM SQLITE DATABASE
      // -----------------------------------------------------

      final bool isValid = await databaseService.loginUser(
        email: email,
        password: password,
      );

      if (!mounted) return;

      // -----------------------------------------------------
      // INVALID LOGIN
      // -----------------------------------------------------

      if (!isValid) {
        setState(() {
          isLoggingIn = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );

        return;
      }

      // -----------------------------------------------------
      // LOGIN SUCCESSFUL
      // -----------------------------------------------------

      setState(() {
        isLoggingIn = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            themeMode: widget.themeMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoggingIn = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
  }

  // =======================================================
  // DISPOSE
  // =======================================================

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  // =======================================================
  // UI
  // =======================================================

  @override
  Widget build(BuildContext context) {
    final ThemeData authTheme = AppTheme.authTheme(Theme.of(context));
    final ColorScheme colors = authTheme.colorScheme;

    return Theme(
      data: authTheme,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                // ------------------------------------------------
                // APP ICON
                // ------------------------------------------------
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.eco, size: 60, color: colors.primary),
                ),

                const SizedBox(height: 20),

                // ------------------------------------------------
                // APP TITLE
                // ------------------------------------------------
                Text(
                  'Food Wastage Tracker',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Login to manage your food and reduce waste.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),

                const SizedBox(height: 35),

                // ------------------------------------------------
                // EMAIL
                // ------------------------------------------------
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: 18),

                // ------------------------------------------------
                // PASSWORD
                // ------------------------------------------------
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // ------------------------------------------------
                // LOGIN BUTTON
                // ------------------------------------------------
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoggingIn ? null : login,
                    child: isLoggingIn
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Login', style: TextStyle(fontSize: 17)),
                  ),
                ),

                const SizedBox(height: 20),

                // ------------------------------------------------
                // REGISTER LINK
                // ------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: isLoggingIn
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(
                                    themeMode: widget.themeMode,
                                    onThemeChanged: widget.onThemeChanged,
                                  ),
                                ),
                              );
                            },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
