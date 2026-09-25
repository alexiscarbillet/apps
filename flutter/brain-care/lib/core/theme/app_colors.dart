import 'package:flutter/material.dart';

class AppColors {
  // Deep space / obsidian backgrounds
  static const Color background = Color(0xFF080D1A);
  static const Color surface = Color(0xFF0F172A);
  static const Color surfaceElevated = Color(0xFF1E293B);
  static const Color surfaceHighlight = Color(0xFF334155);

  // Light theme alternatives
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceElevatedLight = Color(0xFFEDF2F7);

  // Accent & Neural Gradients
  static const Color electricCyan = Color(0xFF00F2FE);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color deepIndigo = Color(0xFF4FACFE);
  static const Color primaryIndigo = Color(0xFF6366F1);
  static const Color vividViolet = Color(0xFF8B5CF6);
  static const Color electricPurple = Color(0xFFA855F7);
  static const Color neuralRose = Color(0xFFEC4899);
  static const Color coralPulse = Color(0xFFFF5252);
  static const Color amberGold = Color(0xFFF59E0B);
  static const Color emeraldSynapse = Color(0xFF10B981);
  static const Color mintGreen = Color(0xFF34D399);

  // Text colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);

  // Border & Glows
  static const Color borderLight = Color(0xFF334155);
  static const Color borderSubtle = Color(0xFF1E293B);
  static const Color glowCyan = Color(0x3300F2FE);
  static const Color glowViolet = Color(0x338B5CF6);
  static const Color glowEmerald = Color(0x3310B981);

  // Gradients
  static const LinearGradient neuralGradient = LinearGradient(
    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient violetRoseGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emeraldCyanGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF131D33), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient gammaGlowGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFFF5252)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
