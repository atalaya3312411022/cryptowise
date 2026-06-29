import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'register_screen.dart';
import 'package:cryptowise/main_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showAuthAlert = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => _showAuthAlert = true);

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _showAuthAlert = false);
        }
      });

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    width: 160,
                  ),

                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'Welcome Back',
                    style: AppTextStyles.headline2,
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'Sign in to access cryptocurrency news, market insights, and portfolio tracking tools.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyGrey,
                  ),

                  const SizedBox(height: 40),

                  // Email Field
                  AppTextField(
                    label: 'Email',
                    hint: 'Enter your email address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 20),

                  // Password Field
                  AppTextField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: _passwordController,
                    obscure: true,
                  ),

                  const SizedBox(height: 32),

                  // Sign In Button
                  GoldButton(
                    text: 'Sign In',
                    onPressed: _handleLogin,
                  ),

                  const SizedBox(height: 20),

                  // Register Link
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyGrey,
                      children: [
                        const TextSpan(
                          text: "Don't have an account? ",
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Create Account',
                              style: AppTextStyles.link,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Page Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _dot(false),
                      const SizedBox(width: 6),
                      _dot(false),
                      const SizedBox(width: 6),
                      _dot(true),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),

            // Authentication Alert
            if (_showAuthAlert)
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF0000),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Authentication Required. Please sign in or create an account to continue.',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      width: active ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active
            ? AppColors.goldLight
            : const Color(0xFF555555),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}