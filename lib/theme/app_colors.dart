import 'package:flutter/material.dart';

/// Design tokens derived from UI/UX Pro Max Design System
/// Category: Productivity Tool (Teal Focus + Action Orange)
class AppColors {
  AppColors._();

  // Core Brand Tokens
  static const Color primary = Color(0xFF0D9488); // Teal 600
  static const Color primaryDark = Color(0xFF0F766E); // Teal 700
  static const Color primaryLight = Color(0xFF14B8A6); // Teal 500
  static const Color secondary = Color(0xFF2DD4BF); // Teal 400
  static const Color accent = Color(0xFFEA580C); // Warm Orange 600
  static const Color accentLight = Color(0xFFFB923C); // Orange 400

  // Semantic Status Colors
  static const Color success = Color(0xFF059669); // Emerald 600
  static const Color successBg = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFD97706); // Amber 600
  static const Color destructive = Color(0xFFDC2626); // Red 600
  static const Color destructiveBg = Color(0xFFFEE2E2);

  // Light Mode Tokens
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9); // Slate 100
  static const Color lightBorder = Color(0xFFE2E8F0); // Slate 200
  static const Color lightBorderFocus = Color(0xFF0D9488);
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF475569); // Slate 600 (contrast >= 4.5:1)
  static const Color lightTextMuted = Color(0xFF64748B); // Slate 500

  // Dark Mode Tokens
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkSurfaceVariant = Color(0xFF334155); // Slate 700
  static const Color darkBorder = Color(0xFF334155); // Slate 700
  static const Color darkBorderFocus = Color(0xFF2DD4BF);
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFFCBD5E1); // Slate 300
  static const Color darkTextMuted = Color(0xFF94A3B8); // Slate 400
}
