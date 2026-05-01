import 'package:flutter/material.dart';

class NewsImagePlaceholder extends StatelessWidget {
  final String type; // 'forex' or 'bitcoin'
  final double height;
  final double? width;
  final bool showDuration;
  final String? duration;

  const NewsImagePlaceholder({
    super.key,
    required this.type,
    this.height = 200,
    this.width,
    this.showDuration = false,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Container(
            width: width ?? double.infinity,
            height: height,
            child: CustomPaint(
              painter: type == 'forex'
                  ? _ForexImagePainter()
                  : _BitcoinImagePainter(),
              size: Size(width ?? double.infinity, height),
            ),
          ),
          // Duration badge (for video articles)
          if (showDuration && duration != null)
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  duration!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Forex thumbnail - green/chart trading look
class _ForexImagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background gradient
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF1a3a1a), Color(0xFF0d1f0d), Color(0xFF1a2d1a)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // FOREX title area (yellow)
    final titleBg = Paint()..color = const Color(0xFFFFCC00);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.35, size.height * 0.08,
          size.width * 0.55, size.height * 0.28),
      titleBg,
    );

    // TRADING red badge
    final redPaint = Paint()..color = const Color(0xFFCC0000);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.37, size.height * 0.32,
          size.width * 0.3, size.height * 0.18),
      redPaint,
    );

    // Chart lines (green)
    final chartPaint = Paint()
      ..color = const Color(0xFF00CC44)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.35, size.height * 0.75);
    path.lineTo(size.width * 0.42, size.height * 0.65);
    path.lineTo(size.width * 0.5, size.height * 0.7);
    path.lineTo(size.width * 0.58, size.height * 0.55);
    path.lineTo(size.width * 0.65, size.height * 0.6);
    path.lineTo(size.width * 0.73, size.height * 0.45);
    path.lineTo(size.width * 0.82, size.height * 0.3);
    canvas.drawPath(path, chartPaint);

    // BUY button (green)
    final buyPaint = Paint()..color = const Color(0xFF00AA33);
    _drawTriangle(canvas, buyPaint,
        Offset(size.width * 0.62, size.height * 0.72), size.height * 0.14);

    // SELL button (red)
    final sellPaint = Paint()..color = const Color(0xFFCC2200);
    _drawTriangleDown(canvas, sellPaint,
        Offset(size.width * 0.78, size.height * 0.72), size.height * 0.14);

    // BUY / SELL text
    const labelStyle = TextStyle(
        color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold);
    _drawText(canvas, 'BUY',
        Offset(size.width * 0.585, size.height * 0.83), labelStyle);
    _drawText(canvas, 'SELL',
        Offset(size.width * 0.748, size.height * 0.83), labelStyle);

    // Person silhouette area (left)
    final personBg = Paint()..color = const Color(0xFF2a4a2a);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width * 0.36, size.height), personBg);

    // Simple head/body silhouette
    final personPaint = Paint()..color = const Color(0xFFCCCCCC);
    canvas.drawCircle(
        Offset(size.width * 0.18, size.height * 0.3), size.height * 0.12, personPaint);
    final bodyPath = Path()
      ..moveTo(size.width * 0.05, size.height * 0.9)
      ..lineTo(size.width * 0.05, size.height * 0.5)
      ..lineTo(size.width * 0.31, size.height * 0.5)
      ..lineTo(size.width * 0.31, size.height * 0.9)
      ..close();
    canvas.drawPath(bodyPath, personPaint);

    // FOR BEGGINERS text
    final forBegPaint = Paint()..color = const Color(0xFF006622);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.35, size.height * 0.52,
          size.width * 0.6, size.height * 0.16),
      forBegPaint,
    );
    _drawText(
      canvas,
      'FOR BEGGINERS',
      Offset(size.width * 0.37, size.height * 0.54),
      const TextStyle(
          color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
    );
  }

  void _drawTriangle(Canvas canvas, Paint paint, Offset center, double size) {
    final path = Path()
      ..moveTo(center.dx - size * 0.6, center.dy + size * 0.5)
      ..lineTo(center.dx + size * 0.6, center.dy + size * 0.5)
      ..lineTo(center.dx, center.dy - size * 0.5)
      ..close();

    // Background rounded rect
    final bgPaint = Paint()..color = const Color(0xFF008833);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: size * 1.6, height: size * 1.6),
          const Radius.circular(4),
        ),
        bgPaint);
    canvas.drawPath(path, paint);
  }

  void _drawTriangleDown(
      Canvas canvas, Paint paint, Offset center, double size) {
    final bgPaint = Paint()..color = const Color(0xFFAA1100);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: size * 1.6, height: size * 1.6),
          const Radius.circular(4),
        ),
        bgPaint);
    final path = Path()
      ..moveTo(center.dx - size * 0.6, center.dy - size * 0.5)
      ..lineTo(center.dx + size * 0.6, center.dy - size * 0.5)
      ..lineTo(center.dx, center.dy + size * 0.5)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Bitcoin thumbnail - dark gold/crypto look
class _BitcoinImagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Dark background
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF1a1200), Color(0xFF0d0800), Color(0xFF1a1000)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Glow effect circles
    for (int i = 4; i >= 1; i--) {
      final glowPaint = Paint()
        ..color = const Color(0xFFB8860B).withOpacity(0.06 * i)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.55),
        size.height * 0.15 * i,
        glowPaint,
      );
    }

    // Chart line going up (gold)
    final chartPaint = Paint()
      ..color = const Color(0xFFD4A017)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final chartPath = Path();
    chartPath.moveTo(size.width * 0.1, size.height * 0.85);
    chartPath.lineTo(size.width * 0.25, size.height * 0.72);
    chartPath.lineTo(size.width * 0.38, size.height * 0.78);
    chartPath.lineTo(size.width * 0.52, size.height * 0.55);
    chartPath.lineTo(size.width * 0.65, size.height * 0.45);
    chartPath.lineTo(size.width * 0.78, size.height * 0.28);
    chartPath.lineTo(size.width * 0.92, size.height * 0.18);
    canvas.drawPath(chartPath, chartPaint);

    // Bitcoin coin (center)
    final coinOuter = Paint()
      ..color = const Color(0xFFB8860B)
      ..style = PaintingStyle.fill;
    final coinInner = Paint()
      ..color = const Color(0xFFD4A017)
      ..style = PaintingStyle.fill;

    final coinCenter = Offset(size.width * 0.5, size.height * 0.58);
    final coinR = size.height * 0.22;
    canvas.drawCircle(coinCenter, coinR, coinOuter);
    canvas.drawCircle(coinCenter, coinR * 0.85, coinInner);

    // Bitcoin ₿ symbol
    _drawText(
      canvas,
      '₿',
      Offset(coinCenter.dx - coinR * 0.35, coinCenter.dy - coinR * 0.5),
      TextStyle(
        color: const Color(0xFF8B6914),
        fontSize: coinR * 1.0,
        fontWeight: FontWeight.bold,
      ),
    );

    // Gold coin stacks bottom
    for (int i = 0; i < 4; i++) {
      final stackPaint = Paint()..color = const Color(0xFF8B6914);
      final rx = size.width * (0.12 + i * 0.19);
      final ry = size.height * 0.88;
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(rx, ry),
            width: size.height * 0.12,
            height: size.height * 0.06),
        stackPaint,
      );
      final stackPaint2 = Paint()..color = const Color(0xFFB8860B);
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(rx, ry - size.height * 0.04),
            width: size.height * 0.12,
            height: size.height * 0.06),
        stackPaint2,
      );
    }

    // Top right corner bar chart
    final barPaint = Paint()
      ..color = const Color(0xFF555555)
      ..style = PaintingStyle.fill;
    final barHeights = [0.12, 0.18, 0.10, 0.14, 0.08];
    for (int i = 0; i < barHeights.length; i++) {
      final bx = size.width * (0.78 + i * 0.035);
      final bh = size.height * barHeights[i];
      canvas.drawRect(
        Rect.fromLTWH(bx, size.height * 0.06, size.width * 0.025, bh),
        barPaint,
      );
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
