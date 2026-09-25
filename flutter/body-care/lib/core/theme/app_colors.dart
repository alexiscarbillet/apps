import 'package:flutter/material.dart';

class AppColors {
  // Longevity & Health Palette (Vibrant Emerald, Teal, Sage, Clean Slate)
  static const Color primary = Color(0xFF00A884);       // Deep Vibrant Emerald
  static const Color primaryLight = Color(0xFF26D07C);  // Glowing Mint
  static const Color primaryDark = Color(0xFF086A53);   // Forest Depth
  static const Color secondary = Color(0xFF00B4D8);     // Cyan / Aquatic
  static const Color accent = Color(0xFF7209B7);        // Longevity Purple

  // Neutral tones (Dark & Light)
  static const Color backgroundDark = Color(0xFF0F172A); // Deep Navy Slate
  static const Color cardDark = Color(0xFF1E293B);       // Slate 800
  static const Color surfaceDark = Color(0xFF334155);    // Slate 700
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // Status & Health Indicator Colors
  static const Color success = Color(0xFF10B981);  // Green (Optimal)
  static const Color info = Color(0xFF0EA5E9);     // Blue (Normal)
  static const Color warning = Color(0xFFF59E0B);  // Amber (Borderline)
  static const Color error = Color(0xFFEF4444);    // Coral/Red (Action needed)
  static const Color uvExtreme = Color(0xFF8B5CF6); // Purple (UV Extreme)

  // Gradient accents
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00A884), Color(0xFF00B4D8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF131D2D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient flameGradient = LinearGradient(
    colors: [Color(0xFFFF7A00), Color(0xFFFF0055)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
