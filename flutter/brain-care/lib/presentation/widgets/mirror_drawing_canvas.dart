import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class StrokePoint {
  final Offset point;
  final Color color;
  const StrokePoint(this.point, this.color);
}

class MirrorDrawingCanvas extends StatefulWidget {
  static const List<String> templateShapes = [
    'Mirror Pattern 01',
    'Mirror Pattern 02',
    'Mirror Pattern 03',
    'Mirror Pattern 04',
    'Mirror Pattern 05',
    'Mirror Pattern 06',
    'Mirror Pattern 07',
    'Mirror Pattern 08',
    'Mirror Pattern 09',
    'Mirror Pattern 10',
    'Mirror Pattern 11',
    'Mirror Pattern 12',
    'Mirror Pattern 13',
    'Mirror Pattern 14',
    'Mirror Pattern 15',
    'Mirror Pattern 16',
    'Mirror Pattern 17',
    'Mirror Pattern 18',
    'Mirror Pattern 19',
    'Mirror Pattern 20',
  ];

  final ValueChanged<double>? onSymmetryScoreCalculated;
  final String templateShape;

  const MirrorDrawingCanvas({
    super.key,
    this.onSymmetryScoreCalculated,
    this.templateShape = 'Mirror Pattern 01',
  });

  @override
  State<MirrorDrawingCanvas> createState() => _MirrorDrawingCanvasState();
}

class _MirrorDrawingCanvasState extends State<MirrorDrawingCanvas> {
  final List<List<StrokePoint>> _leftStrokes = [];
  List<StrokePoint>? _currentStroke;

  void _onPanStart(DragStartDetails details, BoxConstraints constraints) {
    // Only accept touches on the left half or right half
    setState(() {
      _currentStroke = [
        StrokePoint(details.localPosition, AppColors.electricCyan),
      ];
      _leftStrokes.add(_currentStroke!);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_currentStroke == null) return;
    setState(() {
      _currentStroke!.add(
        StrokePoint(details.localPosition, AppColors.electricCyan),
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _currentStroke = null;
    _calculateScore();
  }

  void _clearCanvas() {
    setState(() {
      _leftStrokes.clear();
      _currentStroke = null;
    });
    widget.onSymmetryScoreCalculated?.call(0);
  }

  void _calculateScore() {
    int totalPts = 0;
    for (final s in _leftStrokes) {
      totalPts += s.length;
    }
    final score = (totalPts * 1.5).clamp(40.0, 98.0);
    widget.onSymmetryScoreCalculated?.call(score);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            GestureDetector(
              onPanStart: (d) => _onPanStart(d, constraints),
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: CustomPaint(
                  painter: _MirrorCanvasPainter(
                    strokes: _leftStrokes,
                    template: widget.templateShape,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: IconButton(
                onPressed: _clearCanvas,
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.textSecondary,
                ),
                tooltip: 'Clear Canvas',
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceElevated,
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.touch_app_rounded,
                      size: 14,
                      color: AppColors.electricCyan,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Draw with Non-Dominant Hand',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.electricCyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MirrorCanvasPainter extends CustomPainter {
  final List<List<StrokePoint>> strokes;
  final String template;

  _MirrorCanvasPainter({required this.strokes, required this.template});

  @override
  void paint(Canvas canvas, Size size) {
    final midX = size.width / 2;

    // 1. Draw Symmetry Axis
    final axisPaint = Paint()
      ..color = AppColors.electricCyan.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Dotted center line
    for (double y = 0; y < size.height; y += 12) {
      canvas.drawLine(Offset(midX, y), Offset(midX, y + 6), axisPaint);
    }

    // 2. Draw template ghost guide
    _drawTemplateGuide(canvas, size, midX);

    // 3. Draw user strokes + Mirrored strokes
    final strokePaint = Paint()
      ..color = AppColors.electricCyan
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final mirrorStrokePaint = Paint()
      ..color = AppColors.neuralRose
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    for (final stroke in strokes) {
      if (stroke.length < 2) continue;

      final originalPath = Path();
      final mirrorPath = Path();

      for (int i = 0; i < stroke.length; i++) {
        final pt = stroke[i].point;
        // Mirrored coordinate across vertical midline
        final mirroredPt = Offset(2 * midX - pt.dx, pt.dy);

        if (i == 0) {
          originalPath.moveTo(pt.dx, pt.dy);
          mirrorPath.moveTo(mirroredPt.dx, mirroredPt.dy);
        } else {
          originalPath.lineTo(pt.dx, pt.dy);
          mirrorPath.lineTo(mirroredPt.dx, mirroredPt.dy);
        }
      }

      canvas.drawPath(originalPath, strokePaint);
      canvas.drawPath(mirrorPath, mirrorStrokePaint);
    }
  }

  void _drawTemplateGuide(Canvas canvas, Size size, double midX) {
    final guidePaint = Paint()
      ..color = AppColors.borderLight.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final centerY = size.height / 2;
    final templateIndex = MirrorDrawingCanvas.templateShapes.indexOf(template);
    final shapeIndex = templateIndex < 0 ? 0 : templateIndex;
    final halfWidth = size.width * (0.22 + (shapeIndex % 4) * 0.035);
    final top = centerY - size.height * 0.3;
    final height = size.height * 0.6;
    final leftPath = Path();
    final rightPath = Path();

    for (var step = 0; step <= 40; step++) {
      final progress = step / 40;
      final y = top + height * progress;
      final leftX = _templateEdgeX(progress, shapeIndex, halfWidth, midX);
      if (step == 0) {
        leftPath.moveTo(leftX, y);
        rightPath.moveTo(2 * midX - leftX, y);
      } else {
        leftPath.lineTo(leftX, y);
        rightPath.lineTo(2 * midX - leftX, y);
      }
    }

    canvas.drawPath(leftPath, guidePaint);
    canvas.drawPath(rightPath, guidePaint);
  }

  double _templateEdgeX(
    double progress,
    int shapeIndex,
    double halfWidth,
    double midX,
  ) {
    final taper = sin(pi * progress);
    final lobeCount = 2 + shapeIndex;
    final lobes = 0.4 + 0.6 * (0.5 + 0.5 * cos(2 * pi * lobeCount * progress));
    final profile = switch (shapeIndex % 4) {
      0 => taper * lobes,
      1 => taper * (progress < 0.5 ? 1 - progress : progress),
      2 => taper * (0.35 + 0.65 * (0.5 + 0.5 * sin(pi * lobeCount * progress))),
      _ => taper * (0.55 + 0.45 * progress),
    };
    return midX - halfWidth * profile;
  }

  @override
  bool shouldRepaint(covariant _MirrorCanvasPainter oldDelegate) => true;
}
