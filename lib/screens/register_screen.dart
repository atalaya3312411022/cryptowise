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
  bool _showSuccess = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    setState(() => _showSuccess = true);

    // Auto dismiss & go to login after 2.5s
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
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
                  const SizedBox(height: 48),

                  // Logo
                  const CryptoLogo(size: 70),
                  const SizedBox(height: 20),

                  // Title
                  Text('Daftar Akun', style: AppTextStyles.headline2),
                  const SizedBox(height: 32),

                  // Name field
                  AppTextField(
                    label: 'Nama',
                    hint: 'Nama Lengkap',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),

                  // Email field
                  AppTextField(
                    label: 'Email',
                    hint: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  AppTextField(
                    label: 'Password',
                    hint: 'Password',
                    controller: _passwordController,
                    obscure: true,
                  ),
                  const SizedBox(height: 16),

                  // Confirm password
                  AppTextField(
                    label: 'Konfirmasi Password',
                    hint: 'Konfirmasi Password',
                    controller: _confirmController,
                    obscure: true,
                  ),
                  const SizedBox(height: 32),

                  // Daftar button
                  GoldButton(
                    text: 'Daftar',
                    onPressed: _handleRegister,
                  ),
                  const SizedBox(height: 24),

                  // Already have account
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyGrey,
                      children: [
                        const TextSpan(text: 'Sudah punya akun? '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text('Login', style: AppTextStyles.link),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Page dots
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

            // Success banner overlay at top
            if (_showSuccess)
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: SuccessBanner(
                  message: 'Akun berhasil dibuat',
                  onClose: () => setState(() => _showSuccess = false),
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
        color: active ? AppColors.goldLight : const Color(0xFF555555),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
