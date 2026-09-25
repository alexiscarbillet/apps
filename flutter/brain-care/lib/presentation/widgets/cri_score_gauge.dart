import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CriScoreGauge extends StatelessWidget {
  final double score; // 0 to 100
  final double size;

  const CriScoreGauge({
    super.key,
    required this.score,
    this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CriGaugePainter(score: score),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                score.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: size * 0.22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -1,
                ),
              ),
              Text(
                'CRI SCORE',
                style: TextStyle(
                  fontSize: size * 0.065,
                  fontWeight: FontWeight.w700,
                  color: AppColors.electricCyan,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _getReserveTier(score),
                style: TextStyle(
                  fontSize: size * 0.055,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getReserveTier(double val) {
    if (val >= 85) return 'High Reserve';
    if (val >= 70) return 'Optimal Neuroplasticity';
    if (val >= 50) return 'Moderate Buffer';
    return 'Rebuilding Baseline';
  }
}

class _CriGaugePainter extends CustomPainter {
  final double score;

  _CriGaugePainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;
    const strokeWidth = 12.0;

    // Background Arc
    final bgPaint = Paint()
      ..color = AppColors.surfaceElevated
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = 0.75 * pi;
    const sweepTotal = 1.5 * pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal,
      false,
      bgPaint,
    );

    // Active Gradient Arc
    final activeSweep = sweepTotal * (score.clamp(0.0, 100.0) / 100.0);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final activePaint = Paint()
      ..shader = const SweepGradient(
        colors: [
          AppColors.electricCyan,
          AppColors.deepIndigo,
          AppColors.vividViolet,
          AppColors.neuralRose,
        ],
        startAngle: startAngle,
        endAngle: startAngle + sweepTotal,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      startAngle,
      activeSweep,
      false,
      activePaint,
    );

    // Outer glow dots / ticks
    final tickPaint = Paint()
      ..color = AppColors.borderLight
      ..style = PaintingStyle.fill;

    for (int i = 0; i <= 10; i++) {
      final angle = startAngle + (sweepTotal * (i / 10));
      final tickRadius = radius + 14;
      final x = center.dx + tickRadius * cos(angle);
      final y = center.dy + tickRadius * sin(angle);
      canvas.drawCircle(Offset(x, y), 2.0, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CriGaugePainter oldDelegate) =>
      oldDelegate.score != score;
}
