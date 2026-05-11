import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'register_screen.dart';
import 'news_screen.dart';
import 'package:cryptowise/main_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const NewsScreen(key: ValueKey('news')),
      ),
    );
  }

  void _handleAdminLogin() {
    // TODO: implement admin login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login sebagai Admin')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
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
              Text('Login', style: AppTextStyles.headline2),
              const SizedBox(height: 40),

              // Email field
              AppTextField(
                label: 'Email',
                hint: 'Your Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Password field
              AppTextField(
                label: 'Password',
                hint: 'Your Password',
                controller: _passwordController,
                obscure: true,
              ),
              const SizedBox(height: 32),

              // Login button
              GoldButton(
                text: 'Login',
                onPressed: () async {
                  // Simulate a delay for login process
                  await Future.delayed(const Duration(seconds: 2));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainPage()),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Register link
              RichText(
                text: TextSpan(
                  style: AppTextStyles.bodyGrey,
                  children: [
                    const TextSpan(text: 'Belum punya akun? '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterScreen()),
                          );
                        },
                        child: Text(
                          'Daftar Sekarang',
                          style: AppTextStyles.link,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // // Admin login
              // GestureDetector(
              //   onTap: _handleAdminLogin,
              //   child: Text(
              //     'Login sebagai Admin',
              //     style: AppTextStyles.bodyGrey.copyWith(
              //       decoration: TextDecoration.underline,
              //       decorationColor: AppColors.grey,
              //     ),
              //   ),
              // ),

              const SizedBox(height: 40),

              // Page dots indicator
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
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      width: active ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.goldLight : const Color(0xFF555555),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
