import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/cognitive_domains.dart';
import '../../core/theme/app_colors.dart';

class CognitiveRadarChart extends StatelessWidget {
  final Map<CognitiveDomainType, double> domainScores;
  final double size;

  const CognitiveRadarChart({
    super.key,
    required this.domainScores,
    this.size = 280,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RadarChartPainter(domainScores: domainScores),
      ),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final Map<CognitiveDomainType, double> domainScores;

  _RadarChartPainter({required this.domainScores});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 64) / 2;
    final domains = CognitiveDomainType.values;
    final count = domains.length;
    final angleStep = (2 * pi) / count;

    // 1. Draw web grid rings (25%, 50%, 75%, 100%)
    final gridPaint = Paint()
      ..color = AppColors.borderLight.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int ring = 1; ring <= 4; ring++) {
      final ringRadius = radius * (ring / 4.0);
      final path = Path();
      for (int i = 0; i < count; i++) {
        final angle = -pi / 2 + i * angleStep;
        final x = center.dx + ringRadius * cos(angle);
        final y = center.dy + ringRadius * sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // 2. Draw spokes
    for (int i = 0; i < count; i++) {
      final angle = -pi / 2 + i * angleStep;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), gridPaint);
    }

    // 3. Draw polygon for user scores
    final dataPath = Path();
    final pointOffsets = <Offset>[];

    for (int i = 0; i < count; i++) {
      final domain = domains[i];
      final score = (domainScores[domain] ?? 70.0).clamp(10.0, 100.0);
      final r = radius * (score / 100.0);
      final angle = -pi / 2 + i * angleStep;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      final pt = Offset(x, y);
      pointOffsets.add(pt);

      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }
    dataPath.close();

    // Fill polygon with gradient
    final fillPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.electricCyan.withValues(alpha: 0.45),
          AppColors.vividViolet.withValues(alpha: 0.2),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
    canvas.drawPath(dataPath, fillPaint);

    // Stroke polygon
    final strokePaint = Paint()
      ..color = AppColors.electricCyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(dataPath, strokePaint);

    // Draw vertex glowing dots
    final dotPaint = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.fill;
    final dotGlow = Paint()
      ..color = AppColors.electricCyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final pt in pointOffsets) {
      canvas.drawCircle(pt, 3.5, dotPaint);
      canvas.drawCircle(pt, 6.0, dotGlow);
    }

    // 4. Draw labels
    for (int i = 0; i < count; i++) {
      final domain = domains[i];
      final info = CognitiveDomains.getInfo(domain);
      final angle = -pi / 2 + i * angleStep;
      final labelRadius = radius + 22;
      final x = center.dx + labelRadius * cos(angle);
      final y = center.dy + labelRadius * sin(angle);

      final label = _shortName(info.title);
      final textSpan = TextSpan(
        text: label,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 70);

      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  String _shortName(String title) {
    if (title.contains('Cross-Modal')) return 'Cross-Modal';
    if (title.contains('Spatial')) return '3D Spatial';
    if (title.contains('Working Memory')) return 'Memory';
    if (title.contains('Task Switching')) return 'Switching';
    if (title.contains('Divergent')) return 'Divergent';
    if (title.contains('Motor-Cortex')) return 'Motor Hand';
    return title;
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) => true;
}
