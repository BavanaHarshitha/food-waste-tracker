import 'package:flutter/material.dart';

import '../services/database_service.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final DatabaseService databaseService = DatabaseService();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isRegistering = false;

  // =======================================================
  // REGISTER USER
  // =======================================================

  Future<void> register() async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim().toLowerCase();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    // -------------------------------------------------------
    // CHECK EMPTY FIELDS
    // -------------------------------------------------------

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    // -------------------------------------------------------
    // CHECK NAME
    // -------------------------------------------------------

    if (name.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name must contain at least 3 characters'),
        ),
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
    // CHECK PASSWORD LENGTH
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
    // CHECK PASSWORD MATCH
    // -------------------------------------------------------

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    // -------------------------------------------------------
    // SHOW LOADING STATE
    // -------------------------------------------------------

    setState(() {
      isRegistering = true;
    });

    try {
      // -----------------------------------------------------
      // SAVE USER TO SQLITE DATABASE
      // -----------------------------------------------------

      final bool registered = await databaseService.registerUser(
        name: name,
        email: email,
        password: password,
      );

      if (!mounted) return;

      // -----------------------------------------------------
      // DUPLICATE EMAIL
      // -----------------------------------------------------

      if (!registered) {
        setState(() {
          isRegistering = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An account with this email already exists'),
          ),
        );

        return;
      }

      // -----------------------------------------------------
      // REGISTRATION SUCCESSFUL
      // -----------------------------------------------------

      setState(() {
        isRegistering = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! Please login.')),
      );

      // Small delay so the user can see the message.
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // -----------------------------------------------------
      // GO TO LOGIN SCREEN
      // -----------------------------------------------------

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            themeMode: widget.themeMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isRegistering = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
    }
  }

  // =======================================================
  // DISPOSE
  // =======================================================

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

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
        appBar: AppBar(title: const Text('Create Account')),
        body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // ------------------------------------------------
              // ICON
              // ------------------------------------------------
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_add, size: 50, color: colors.primary),
              ),

              const SizedBox(height: 20),

              // ------------------------------------------------
              // TITLE
              // ------------------------------------------------
              Text(
                'Create Your Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Join us in reducing food wastage.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 30),

              // ------------------------------------------------
              // NAME
              // ------------------------------------------------
              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 16),

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

              const SizedBox(height: 16),

              // ------------------------------------------------
              // PASSWORD
              // ------------------------------------------------
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Create a password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ------------------------------------------------
              // CONFIRM PASSWORD
              // ------------------------------------------------
              TextField(
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Enter password again',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ------------------------------------------------
              // CREATE ACCOUNT BUTTON
              // ------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isRegistering ? null : register,
                  child: isRegistering
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Create Account',
                          style: TextStyle(fontSize: 17),
                        ),
                ),
              ),

              const SizedBox(height: 15),

              // ------------------------------------------------
              // LOGIN LINK
              // ------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? '),
                  TextButton(
                    onPressed: isRegistering
                        ? null
                        : () {
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
                    child: const Text('Login'),
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
