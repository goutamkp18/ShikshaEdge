import 'package:flutter/material.dart';

class AppColors {
  // Required palette from specification
  static const Color primaryIndigo = Color(0xFF4F46E5);
  static const Color deepIndigo = Color(0xFF312E81);
  static const Color successGreen = Color(0xFF16A34A);
  static const Color warmYellow = Color(0xFFF59E0B);
  static const Color skyBlue = Color(0xFF0EA5E9);
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF0F172A);
  static const Color secondaryText = Color(0xFF64748B);
  static const Color errorRed = Color(0xFFEF4444);

  // Dark Theme Palette
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkCardBackground = Color(0xFF1E293B);
  static const Color darkPrimaryText = Color(0xFFF8FAFC);
  static const Color darkSecondaryText = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);

  // Mastery Level Colors
  static const Color masteryNeedsPractice = Color(0xFFEF4444); // < 40%
  static const Color masteryDeveloping = Color(0xFFF59E0B);    // 40% - 75%
  static const Color masteryProficient = Color(0xFF16A34A);    // > 75%
}
