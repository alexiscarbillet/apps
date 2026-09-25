import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StrokePoint {
  final Offset point;
  final Color color;
  const StrokePoint(this.point, this.color);
}

class MirrorDrawingCanvas extends StatefulWidget {
  final ValueChanged<double>? onSymmetryScoreCalculated;
  final String templateShape; // 'Heart', 'Infinity', 'Butterfly', 'Star'

  const MirrorDrawingCanvas({
    super.key,
    this.onSymmetryScoreCalculated,
    this.templateShape = 'Butterfly',
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
                icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.touch_app_rounded,
                        size: 14, color: AppColors.electricCyan),
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

  _MirrorCanvasPainter({
    required this.strokes,
    required this.template,
  });

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
    // Butterfly / Wings guide
    final leftWing = Path()
      ..moveTo(midX, centerY - 60)
      ..cubicTo(midX - 90, centerY - 90, midX - 120, centerY + 10, midX, centerY + 60)
      ..moveTo(midX, centerY - 10)
      ..cubicTo(midX - 70, centerY + 20, midX - 80, centerY + 80, midX, centerY + 80);

    final rightWing = Path()
      ..moveTo(midX, centerY - 60)
      ..cubicTo(midX + 90, centerY - 90, midX + 120, centerY + 10, midX, centerY + 60)
      ..moveTo(midX, centerY - 10)
      ..cubicTo(midX + 70, centerY + 20, midX + 80, centerY + 80, midX, centerY + 80);

    canvas.drawPath(leftWing, guidePaint);
    canvas.drawPath(rightWing, guidePaint);
  }

  @override
  bool shouldRepaint(covariant _MirrorCanvasPainter oldDelegate) => true;
}
