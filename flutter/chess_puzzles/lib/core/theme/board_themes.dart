import 'package:flutter/material.dart';

enum BoardThemeType {
  walnut('Classic Walnut', Color(0xFFF0D9B5), Color(0xFFB58863), Color(0xFF3E2723)),
  emerald('Emerald Forest', Color(0xFFEEEED2), Color(0xFF769656), Color(0xFF1B382B)),
  midnight('Midnight Slate', Color(0xFFE2E8F0), Color(0xFF64748B), Color(0xFF0F172A)),
  cyberpunk('Cyberpunk Neon', Color(0xFFE0E7FF), Color(0xFF6366F1), Color(0xFF1E1B4B)),
  sapphire('Royal Sapphire', Color(0xFFE0F2FE), Color(0xFF0284C7), Color(0xFF0C4A6E));

  final String displayName;
  final Color lightSquare;
  final Color darkSquare;
  final Color borderColor;

  const BoardThemeType(this.displayName, this.lightSquare, this.darkSquare, this.borderColor);

  Color get lastMoveHighlight => Colors.amber.withValues(alpha: 0.5);
  Color get selectedSquareHighlight => Colors.yellow.withValues(alpha: 0.6);
  Color get legalMoveDot => Colors.black.withValues(alpha: 0.25);
  Color get legalCaptureRing => Colors.red.withValues(alpha: 0.45);
  Color get checkSquareGlow => Colors.redAccent.withValues(alpha: 0.7);
  Color get hintSquareGlow => Colors.cyanAccent.withValues(alpha: 0.65);
}
