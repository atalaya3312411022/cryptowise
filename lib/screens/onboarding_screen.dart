import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      isFirstPage: true,
      title: 'INVEST IN\nCRYPTOCURRENCY',
      subtitle: 'Learn Crypto\nthe Smart Way.',
    ),
    _OnboardingData(
      isFirstPage: false,
      title: 'SAVING IN\nCRYPTOCURRENCY',
      subtitle: 'Save Smart\nGrow with Crypto',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) =>
                _OnboardingPage(data: _pages[index]),
          ),

          // Page indicator at bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: _pages.length,
                  effect: const WormEffect(
                    dotWidth: 8,
                    dotHeight: 8,
                    spacing: 6,
                    dotColor: Color(0xFF555555),
                    activeDotColor: AppColors.goldLight,
                  ),
                ),
              ],
            ),
          ),

          // Skip / Next button overlay
          Positioned(
            bottom: 90,
            right: 32,
            child: GestureDetector(
              onTap: () {
                if (_currentPage < _pages.length - 1) {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LoginScreen()),
                  );
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  _currentPage < _pages.length - 1 ? 'Lanjut →' : 'Mulai →',
                  style: AppTextStyles.button.copyWith(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final bool isFirstPage;
  final String title;
  final String subtitle;

  const _OnboardingData({
    required this.isFirstPage,
    required this.title,
    required this.subtitle,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80),

          // Icon / Logo area
          if (data.isFirstPage)
            _CryptoIconLarge()
          else
            _WalletIconLarge(),

          const SizedBox(height: 48),

          // Title in gold
          ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.goldGradient.createShader(bounds),
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.goldTitle.copyWith(
                fontSize: 18,
                color: Colors.white,
                letterSpacing: 2.5,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Subtitle in white italic
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.tagline,
          ),

          const Spacer(),
        ],
      ),
    );
  }
}

class _CryptoIconLarge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      child: CustomPaint(painter: _LargeCLogoPainter()),
    );
  }
}

class _LargeCLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Outer C
    final paintOuter = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFD4A017), Color(0xFF8B6914), Color(0xFFB8860B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round;

    final outerRadius = size.width * 0.42;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      0.5,
      5.4,
      false,
      paintOuter,
    );

    // Inner C
    final paintInner = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFB8860B), Color(0xFFFFD700)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;

    final innerRadius = outerRadius * 0.62;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      0.6,
      5.2,
      false,
      paintInner,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WalletIconLarge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 100,
      child: CustomPaint(painter: _WalletPainter()),
    );
  }
}

class _WalletPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4A017)
      ..style = PaintingStyle.fill;

    // Wallet body
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height * 0.2, size.width * 0.85, size.height * 0.7),
      const Radius.circular(12),
    );
    canvas.drawRRect(rect, paint);

    // Wallet flap
    final flapPaint = Paint()
      ..color = const Color(0xFFB8860B)
      ..style = PaintingStyle.fill;

    final flap = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          0, size.height * 0.05, size.width * 0.7, size.height * 0.35),
      const Radius.circular(8),
    );
    canvas.drawRRect(flap, flapPaint);

    // Card slot line
    final linePaint = Paint()
      ..color = const Color(0xFF8B6914)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.6),
      linePaint,
    );

    // Chip rectangle
    final chipPaint = Paint()
      ..color = const Color(0xFF8B6914)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            size.width * 0.15, size.height * 0.68, size.width * 0.2, size.height * 0.12),
        const Radius.circular(3),
      ),
      chipPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
