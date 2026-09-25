import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class WaveformVisualizer extends StatefulWidget {
  final double frequencyHz; // e.g. 40.0
  final bool isPulsing;
  final Color primaryColor;
  final double height;

  const WaveformVisualizer({
    super.key,
    required this.frequencyHz,
    required this.isPulsing,
    this.primaryColor = AppColors.electricCyan,
    this.height = 120,
  });

  @override
  State<WaveformVisualizer> createState() => _WaveformVisualizerState();
}

class _WaveformVisualizerState extends State<WaveformVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animCtrl,
      builder: (context, child) {
        return SizedBox(
          width: double.infinity,
          height: widget.height,
          child: CustomPaint(
            painter: _WaveformPainter(
              progress: _animCtrl.value,
              frequencyHz: widget.frequencyHz,
              isPulsing: widget.isPulsing,
              primaryColor: widget.primaryColor,
            ),
          ),
        );
      },
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double progress;
  final double frequencyHz;
  final bool isPulsing;
  final Color primaryColor;

  _WaveformPainter({
    required this.progress,
    required this.frequencyHz,
    required this.isPulsing,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final midY = size.height / 2;
    final width = size.width;

    // Draw multiple harmonic wave layers
    for (int layer = 0; layer < 3; layer++) {
      final path = Path();
      final phaseOffset = progress * 2 * pi + (layer * pi / 3);
      final amplitude = (size.height * 0.35) * (1.0 - layer * 0.25);
      final freqMult = 1.0 + layer * 0.5;

      final wavePaint = Paint()
        ..color = primaryColor.withValues(
          alpha: isPulsing ? (0.8 - layer * 0.25) : (0.3 - layer * 0.08),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = (3.0 - layer * 0.8);

      for (double x = 0; x <= width; x += 3) {
        final normX = x / width;
        final waveCycles = (frequencyHz > 20 ? 8 : 4) * freqMult;
        final y = midY +
            sin(normX * waveCycles * 2 * pi - phaseOffset) *
                amplitude *
                sin(normX * pi); // envelope taper at edges

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, wavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) => true;
}
