import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/mental_rotation_controller.dart';

class IsometricVoxelWidget extends StatelessWidget {
  final List<VoxelPoint> voxels;
  final double size;
  final Color primaryColor;
  final bool showGridFloor;

  const IsometricVoxelWidget({
    super.key,
    required this.voxels,
    this.size = 140,
    this.primaryColor = AppColors.electricCyan,
    this.showGridFloor = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _IsometricPainter(
          voxels: voxels,
          primaryColor: primaryColor,
          showGridFloor: showGridFloor,
        ),
      ),
    );
  }
}

class _IsometricPainter extends CustomPainter {
  final List<VoxelPoint> voxels;
  final Color primaryColor;
  final bool showGridFloor;

  _IsometricPainter({
    required this.voxels,
    required this.primaryColor,
    required this.showGridFloor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.58);
    const voxelRadius = 14.0;
    const cos30 = 0.866025404; // cos(30 deg)
    const sin30 = 0.5; // sin(30 deg)

    // Sort voxels by depth for proper painter algorithm rendering: (x + y + z)
    final sortedVoxels = List<VoxelPoint>.from(voxels)
      ..sort((a, b) {
        final depthA = a.x + a.y - a.z;
        final depthB = b.x + b.y - b.z;
        return depthA.compareTo(depthB);
      });

    // Floor grid
    if (showGridFloor) {
      final floorPaint = Paint()
        ..color = AppColors.borderLight.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;

      for (int i = -2; i <= 3; i++) {
        final start = _isoProject(i.toDouble(), -2.0, 0, voxelRadius, center);
        final end = _isoProject(i.toDouble(), 3.0, 0, voxelRadius, center);
        canvas.drawLine(start, end, floorPaint);

        final start2 = _isoProject(-2.0, i.toDouble(), 0, voxelRadius, center);
        final end2 = _isoProject(3.0, i.toDouble(), 0, voxelRadius, center);
        canvas.drawLine(start2, end2, floorPaint);
      }
    }

    // Render Voxels
    for (final v in sortedVoxels) {
      _drawCube(canvas, v, voxelRadius, center, cos30, sin30);
    }
  }

  Offset _isoProject(
      double x, double y, double z, double r, Offset center) {
    const cos30 = 0.866025404;
    const sin30 = 0.5;
    final isoX = center.dx + (x - y) * cos30 * r;
    final isoY = center.dy + (x + y) * sin30 * r - z * r;
    return Offset(isoX, isoY);
  }

  void _drawCube(Canvas canvas, VoxelPoint v, double r, Offset center,
      double cos30, double sin30) {
    final origin = _isoProject(
        v.x.toDouble(), v.y.toDouble(), v.z.toDouble(), r, center);

    // Top face
    final pTop = Path()
      ..moveTo(origin.dx, origin.dy - r)
      ..lineTo(origin.dx + r * cos30, origin.dy - r + r * sin30)
      ..lineTo(origin.dx, origin.dy)
      ..lineTo(origin.dx - r * cos30, origin.dy - r + r * sin30)
      ..close();

    final topPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(pTop, topPaint);

    // Left face (slightly darker)
    final pLeft = Path()
      ..moveTo(origin.dx - r * cos30, origin.dy - r + r * sin30)
      ..lineTo(origin.dx, origin.dy)
      ..lineTo(origin.dx, origin.dy + r)
      ..lineTo(origin.dx - r * cos30, origin.dy + r * sin30)
      ..close();

    final leftPaint = Paint()
      ..color = HSLColor.fromColor(primaryColor)
          .withLightness(
              (HSLColor.fromColor(primaryColor).lightness * 0.75).clamp(0.0, 1.0))
          .toColor()
      ..style = PaintingStyle.fill;
    canvas.drawPath(pLeft, leftPaint);

    // Right face (darkest side)
    final pRight = Path()
      ..moveTo(origin.dx, origin.dy)
      ..lineTo(origin.dx + r * cos30, origin.dy - r + r * sin30)
      ..lineTo(origin.dx + r * cos30, origin.dy + r * sin30)
      ..lineTo(origin.dx, origin.dy + r)
      ..close();

    final rightPaint = Paint()
      ..color = HSLColor.fromColor(primaryColor)
          .withLightness(
              (HSLColor.fromColor(primaryColor).lightness * 0.55).clamp(0.0, 1.0))
          .toColor()
      ..style = PaintingStyle.fill;
    canvas.drawPath(pRight, rightPaint);

    // Borders / wireframe
    final edgePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawPath(pTop, edgePaint);
    canvas.drawPath(pLeft, edgePaint);
    canvas.drawPath(pRight, edgePaint);
  }

  @override
  bool shouldRepaint(covariant _IsometricPainter oldDelegate) => true;
}
