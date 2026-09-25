import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/mole_record_model.dart';

class BodySilhouetteWidget extends StatelessWidget {
  final bool isBackView;
  final List<MoleRecord> moles;
  final Function(MoleRecord mole) onSelectMole;
  final Function(double xPercent, double yPercent, bool isBackView)? onAddMoleAtCoordinates;

  const BodySilhouetteWidget({
    super.key,
    required this.isBackView,
    required this.moles,
    required this.onSelectMole,
    this.onAddMoleAtCoordinates,
  });

  @override
  Widget build(BuildContext context) {
    final filteredMoles = moles.where((m) => m.isBackView == isBackView).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight.isFinite ? constraints.maxHeight : 420.0;

        return GestureDetector(
          onTapUp: (details) {
            if (onAddMoleAtCoordinates != null) {
              final xPct = (details.localPosition.dx / width).clamp(0.05, 0.95);
              final yPct = (details.localPosition.dy / height).clamp(0.05, 0.95);
              onAddMoleAtCoordinates!(xPct, yPct, isBackView);
            }
          },
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: const Color(0xFF0D1424),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.surfaceDark.withValues(alpha: 0.8)),
            ),
            child: Stack(
              children: [
                // Custom Painted Anatomical Body Silhouette
                CustomPaint(
                  size: Size(width, height),
                  painter: BodySilhouettePainter(isBackView: isBackView),
                ),

                // View label badge (Front vs Back)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.surfaceDark),
                    ),
                    child: Text(
                      isBackView ? 'POSTERIOR (BACK)' : 'ANTERIOR (FRONT)',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${filteredMoles.length} Moles Logged',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Interactive Mole Pins
                ...filteredMoles.map((mole) {
                  final px = mole.xPercent * width;
                  final py = mole.yPercent * height;
                  return Positioned(
                    left: px - 14,
                    top: py - 14,
                    child: _MolePin(
                      mole: mole,
                      onTap: () => onSelectMole(mole),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MolePin extends StatelessWidget {
  final MoleRecord mole;
  final VoidCallback onTap;

  const _MolePin({required this.mole, required this.onTap});

  Color _getRiskColor() {
    switch (mole.riskRating) {
      case MoleRiskRating.benign:
        return AppColors.success;
      case MoleRiskRating.monitor:
        return const Color(0xFFFFB703); // Amber
      case MoleRiskRating.doctorReview:
        return AppColors.error;
      case MoleRiskRating.biopsied:
        return const Color(0xFF8B5CF6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getRiskColor();

    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: '${mole.label} (${mole.currentSizeMm}mm)',
        child: Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.25),
            border: Border.all(color: color, width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

class BodySilhouettePainter extends CustomPainter {
  final bool isBackView;

  BodySilhouettePainter({required this.isBackView});

  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;

    final paintStroke = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final paintAccent = Paint()
      ..color = const Color(0xFF00B4D8).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final cx = size.width / 2.0;
    final w = size.width;
    final h = size.height;

    // Draw Anatomical Body Silhouette
    final bodyPath = Path();

    // Head
    bodyPath.addOval(Rect.fromCenter(
      center: Offset(cx, h * 0.12),
      width: w * 0.22,
      height: h * 0.16,
    ));

    // Neck
    bodyPath.addRect(Rect.fromCenter(
      center: Offset(cx, h * 0.21),
      width: w * 0.10,
      height: h * 0.05,
    ));

    // Torso / Chest / Back
    final torsoPath = Path();
    torsoPath.moveTo(cx - w * 0.26, h * 0.24); // Left shoulder
    torsoPath.lineTo(cx + w * 0.26, h * 0.24); // Right shoulder
    torsoPath.lineTo(cx + w * 0.20, h * 0.52); // Right waist
    torsoPath.lineTo(cx + w * 0.22, h * 0.58); // Right hip
    torsoPath.lineTo(cx - w * 0.22, h * 0.58); // Left hip
    torsoPath.lineTo(cx - w * 0.20, h * 0.52); // Left waist
    torsoPath.close();
    bodyPath.addPath(torsoPath, Offset.zero);

    // Left Arm
    final leftArm = Path();
    leftArm.moveTo(cx - w * 0.26, h * 0.24);
    leftArm.lineTo(cx - w * 0.36, h * 0.44); // Elbow
    leftArm.lineTo(cx - w * 0.38, h * 0.58); // Wrist
    leftArm.lineTo(cx - w * 0.32, h * 0.58);
    leftArm.lineTo(cx - w * 0.30, h * 0.44);
    leftArm.lineTo(cx - w * 0.20, h * 0.28);
    leftArm.close();
    bodyPath.addPath(leftArm, Offset.zero);

    // Right Arm
    final rightArm = Path();
    rightArm.moveTo(cx + w * 0.26, h * 0.24);
    rightArm.lineTo(cx + w * 0.36, h * 0.44); // Elbow
    rightArm.lineTo(cx + w * 0.38, h * 0.58); // Wrist
    rightArm.lineTo(cx + w * 0.32, h * 0.58);
    rightArm.lineTo(cx + w * 0.30, h * 0.44);
    rightArm.lineTo(cx + w * 0.20, h * 0.28);
    rightArm.close();
    bodyPath.addPath(rightArm, Offset.zero);

    // Left Leg
    final leftLeg = Path();
    leftLeg.moveTo(cx - w * 0.20, h * 0.58);
    leftLeg.lineTo(cx - w * 0.18, h * 0.76); // Knee
    leftLeg.lineTo(cx - w * 0.16, h * 0.94); // Ankle
    leftLeg.lineTo(cx - w * 0.06, h * 0.94);
    leftLeg.lineTo(cx - w * 0.08, h * 0.76);
    leftLeg.lineTo(cx - w * 0.03, h * 0.58);
    leftLeg.close();
    bodyPath.addPath(leftLeg, Offset.zero);

    // Right Leg
    final rightLeg = Path();
    rightLeg.moveTo(cx + w * 0.20, h * 0.58);
    rightLeg.lineTo(cx + w * 0.18, h * 0.76); // Knee
    rightLeg.lineTo(cx + w * 0.16, h * 0.94); // Ankle
    rightLeg.lineTo(cx + w * 0.06, h * 0.94);
    rightLeg.lineTo(cx + w * 0.08, h * 0.76);
    rightLeg.lineTo(cx + w * 0.03, h * 0.58);
    rightLeg.close();
    bodyPath.addPath(rightLeg, Offset.zero);

    // Render Body
    canvas.drawPath(bodyPath, paintFill);
    canvas.drawPath(bodyPath, paintStroke);

    // Subtle Anatomical Guideline Grid
    canvas.drawLine(Offset(cx, h * 0.24), Offset(cx, h * 0.58), paintAccent); // Spine/Sternum line
    canvas.drawLine(Offset(cx - w * 0.22, h * 0.38), Offset(cx + w * 0.22, h * 0.38), paintAccent); // Chest / Mid-back line
    canvas.drawLine(Offset(cx - w * 0.20, h * 0.52), Offset(cx + w * 0.20, h * 0.52), paintAccent); // Waist line
  }

  @override
  bool shouldRepaint(covariant BodySilhouettePainter oldDelegate) =>
      oldDelegate.isBackView != isBackView;
}
