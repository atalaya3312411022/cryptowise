import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _showBanner = false;
  bool _isSuccess = false;
  String _bannerMessage = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmController.text.isEmpty) {
      setState(() {
        _showBanner = true;
        _isSuccess = false;
        _bannerMessage =
            'All fields are required. Please complete the registration form.';
      });

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _showBanner = false);
        }
      });

      return;
    }

    if (_passwordController.text != _confirmController.text) {
      setState(() {
        _showBanner = true;
        _isSuccess = false;
        _bannerMessage =
            'Passwords do not match. Please try again.';
      });

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _showBanner = false);
        }
      });

      return;
    }

    setState(() {
      _showBanner = true;
      _isSuccess = true;
      _bannerMessage =
          'Account created successfully. You can now sign in to CryptoWise.';
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
          (route) => false,
        );
      }
    });
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
                    'Create Account',
                    style: AppTextStyles.headline2,
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'Join CryptoWise and stay updated with the latest cryptocurrency trends, market insights, and portfolio tracking tools.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyGrey,
                  ),

                  const SizedBox(height: 40),

                  // Full Name
                  AppTextField(
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    controller: _nameController,
                  ),

                  const SizedBox(height: 20),

                  // Email
                  AppTextField(
                    label: 'Email',
                    hint: 'Enter your email address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 20),

                  // Password
                  AppTextField(
                    label: 'Password',
                    hint: 'Create a secure password',
                    controller: _passwordController,
                    obscure: true,
                  ),

                  const SizedBox(height: 20),

                  // Confirm Password
                  AppTextField(
                    label: 'Confirm Password',
                    hint: 'Re-enter your password',
                    controller: _confirmController,
                    obscure: true,
                  ),

                  const SizedBox(height: 32),

                  // Create Account Button
                  GoldButton(
                    text: 'Create Account',
                    onPressed: _handleRegister,
                  ),

                  const SizedBox(height: 20),

                  // Sign In Link
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyGrey,
                      children: [
                        const TextSpan(
                          text: 'Already have an account? ',
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Sign In',
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
                      _dot(false),
                      const SizedBox(width: 6),
                      _dot(true),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),

            // Banner Notification
            if (_showBanner)
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
                    color: _isSuccess
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFFF0000),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isSuccess
                            ? Icons.check_circle
                            : Icons.error_outline,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _bannerMessage,
                          style: const TextStyle(
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