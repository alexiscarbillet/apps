import 'package:flutter/material.dart';
import '../../core/chess/chess_models.dart';

class ChessPieceWidget extends StatelessWidget {
  final ChessPiece piece;
  final double size;

  const ChessPieceWidget({
    super.key,
    required this.piece,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final isWhite = piece.color == PieceColor.white;
    return CustomPaint(
      size: Size(size, size),
      painter: _ChessPiecePainter(type: piece.type, isWhite: isWhite),
    );
  }
}

class _ChessPiecePainter extends CustomPainter {
  final PieceType type;
  final bool isWhite;

  _ChessPiecePainter({required this.type, required this.isWhite});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final fillPaint = Paint()
      ..color = isWhite ? const Color(0xFFFFFFFF) : const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = isWhite ? const Color(0xFF334155) : const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.04
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final highlightPaint = Paint()
      ..color = isWhite ? Colors.white : const Color(0xFF475569)
      ..style = PaintingStyle.fill;

    // Draw stylized shadow underneath
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, size.height * 0.88),
        width: size.width * 0.65,
        height: size.height * 0.14,
      ),
      shadowPaint,
    );

    switch (type) {
      case PieceType.pawn:
        _drawPawn(canvas, size, fillPaint, strokePaint, highlightPaint);
        break;
      case PieceType.knight:
        _drawKnight(canvas, size, fillPaint, strokePaint, highlightPaint);
        break;
      case PieceType.bishop:
        _drawBishop(canvas, size, fillPaint, strokePaint, highlightPaint);
        break;
      case PieceType.rook:
        _drawRook(canvas, size, fillPaint, strokePaint, highlightPaint);
        break;
      case PieceType.queen:
        _drawQueen(canvas, size, fillPaint, strokePaint, highlightPaint);
        break;
      case PieceType.king:
        _drawKing(canvas, size, fillPaint, strokePaint, highlightPaint);
        break;
    }
  }

  void _drawPawn(Canvas canvas, Size size, Paint fill, Paint stroke, Paint highlight) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    // Base
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.22, h * 0.76, w * 0.56, h * 0.12),
      Radius.circular(w * 0.05),
    ));

    // Body
    path.moveTo(w * 0.3, h * 0.76);
    path.cubicTo(w * 0.34, h * 0.52, w * 0.4, h * 0.42, w * 0.42, h * 0.38);
    path.lineTo(w * 0.58, h * 0.38);
    path.cubicTo(w * 0.6, h * 0.42, w * 0.66, h * 0.52, w * 0.7, h * 0.76);
    path.close();

    // Head circle
    path.addOval(Rect.fromCircle(center: Offset(w * 0.5, h * 0.28), radius: w * 0.18));

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  void _drawKnight(Canvas canvas, Size size, Paint fill, Paint stroke, Paint highlight) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    // Base
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.2, h * 0.78, w * 0.6, h * 0.12),
      Radius.circular(w * 0.05),
    ));

    // Horse head silhouette
    path.moveTo(w * 0.28, h * 0.78);
    path.lineTo(w * 0.24, h * 0.55);
    path.cubicTo(w * 0.2, h * 0.42, w * 0.26, h * 0.32, w * 0.38, h * 0.22);
    // Ears
    path.lineTo(w * 0.44, h * 0.12);
    path.lineTo(w * 0.52, h * 0.2);
    // Mane / Back
    path.cubicTo(w * 0.68, h * 0.28, w * 0.78, h * 0.45, w * 0.72, h * 0.78);
    path.close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);

    // Muzzle eye detail
    final eyePaint = Paint()
      ..color = isWhite ? const Color(0xFF334155) : const Color(0xFFF8FAFC)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.42, h * 0.32), w * 0.04, eyePaint);
  }

  void _drawBishop(Canvas canvas, Size size, Paint fill, Paint stroke, Paint highlight) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    // Base
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.22, h * 0.78, w * 0.56, h * 0.12),
      Radius.circular(w * 0.05),
    ));

    // Body
    path.moveTo(w * 0.3, h * 0.78);
    path.cubicTo(w * 0.32, h * 0.58, w * 0.38, h * 0.48, w * 0.42, h * 0.45);
    path.lineTo(w * 0.58, h * 0.45);
    path.cubicTo(w * 0.62, h * 0.48, w * 0.68, h * 0.58, w * 0.7, h * 0.78);
    path.close();

    // Mitre / Head Oval
    path.addOval(Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.32),
      width: w * 0.36,
      height: h * 0.38,
    ));

    // Top cross/orb
    path.addOval(Rect.fromCircle(center: Offset(w * 0.5, h * 0.11), radius: w * 0.05));

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);

    // Bishop slit
    final slitPaint = Paint()
      ..color = isWhite ? const Color(0xFF334155) : const Color(0xFFF8FAFC)
      ..strokeWidth = w * 0.035
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.45, h * 0.22), Offset(w * 0.58, h * 0.36), slitPaint);
  }

  void _drawRook(Canvas canvas, Size size, Paint fill, Paint stroke, Paint highlight) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    // Base
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.2, h * 0.78, w * 0.6, h * 0.12),
      Radius.circular(w * 0.05),
    ));

    // Tower body
    path.moveTo(w * 0.28, h * 0.78);
    path.lineTo(w * 0.32, h * 0.4);
    path.lineTo(w * 0.68, h * 0.4);
    path.lineTo(w * 0.72, h * 0.78);
    path.close();

    // Battlements / Castle Top
    path.moveTo(w * 0.22, h * 0.4);
    path.lineTo(w * 0.22, h * 0.22);
    path.lineTo(w * 0.34, h * 0.22);
    path.lineTo(w * 0.34, h * 0.28);
    path.lineTo(w * 0.44, h * 0.28);
    path.lineTo(w * 0.44, h * 0.22);
    path.lineTo(w * 0.56, h * 0.22);
    path.lineTo(w * 0.56, h * 0.28);
    path.lineTo(w * 0.66, h * 0.28);
    path.lineTo(w * 0.66, h * 0.22);
    path.lineTo(w * 0.78, h * 0.22);
    path.lineTo(w * 0.78, h * 0.4);
    path.close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  void _drawQueen(Canvas canvas, Size size, Paint fill, Paint stroke, Paint highlight) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    // Base
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.18, h * 0.8, w * 0.64, h * 0.11),
      Radius.circular(w * 0.05),
    ));

    // Body
    path.moveTo(w * 0.26, h * 0.8);
    path.cubicTo(w * 0.3, h * 0.55, w * 0.38, h * 0.48, w * 0.4, h * 0.45);
    path.lineTo(w * 0.6, h * 0.45);
    path.cubicTo(w * 0.62, h * 0.48, w * 0.7, h * 0.55, w * 0.74, h * 0.8);
    path.close();

    // Crown Points
    final crown = Path();
    crown.moveTo(w * 0.22, h * 0.46);
    crown.lineTo(w * 0.16, h * 0.24);
    crown.lineTo(w * 0.34, h * 0.34);
    crown.lineTo(w * 0.5, h * 0.18);
    crown.lineTo(w * 0.66, h * 0.34);
    crown.lineTo(w * 0.84, h * 0.24);
    crown.lineTo(w * 0.78, h * 0.46);
    crown.close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
    canvas.drawPath(crown, fill);
    canvas.drawPath(crown, stroke);

    // Crown Jewels / Orbs
    final jewelRadii = w * 0.04;
    canvas.drawCircle(Offset(w * 0.16, h * 0.22), jewelRadii, fill);
    canvas.drawCircle(Offset(w * 0.16, h * 0.22), jewelRadii, stroke);
    canvas.drawCircle(Offset(w * 0.5, h * 0.16), jewelRadii * 1.2, fill);
    canvas.drawCircle(Offset(w * 0.5, h * 0.16), jewelRadii * 1.2, stroke);
    canvas.drawCircle(Offset(w * 0.84, h * 0.22), jewelRadii, fill);
    canvas.drawCircle(Offset(w * 0.84, h * 0.22), jewelRadii, stroke);
  }

  void _drawKing(Canvas canvas, Size size, Paint fill, Paint stroke, Paint highlight) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    // Base
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.18, h * 0.8, w * 0.64, h * 0.11),
      Radius.circular(w * 0.05),
    ));

    // Body
    path.moveTo(w * 0.26, h * 0.8);
    path.cubicTo(w * 0.3, h * 0.58, w * 0.36, h * 0.45, w * 0.4, h * 0.42);
    path.lineTo(w * 0.6, h * 0.42);
    path.cubicTo(w * 0.64, h * 0.45, w * 0.7, h * 0.58, w * 0.74, h * 0.8);
    path.close();

    // Crown Dome
    path.addArc(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.38), width: w * 0.52, height: h * 0.3),
      3.14159,
      3.14159,
    );

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);

    // Cross on top
    final crossPaint = Paint()
      ..color = isWhite ? const Color(0xFF334155) : const Color(0xFFFFFFFF)
      ..strokeWidth = w * 0.06
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(w * 0.5, h * 0.08), Offset(w * 0.5, h * 0.24), crossPaint);
    canvas.drawLine(Offset(w * 0.4, h * 0.15), Offset(w * 0.6, h * 0.15), crossPaint);
  }

  @override
  bool shouldRepaint(covariant _ChessPiecePainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.isWhite != isWhite;
  }
}
