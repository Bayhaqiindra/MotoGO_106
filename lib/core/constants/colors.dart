// lib/core/constants/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary & Accent Colors (Modern Blue)
  static const Color primary = Color(0xFFDCCBAF);// A vibrant, clear blue
  static const Color primaryDark = Color(
    0xFF1976D2,
  ); // Darker shade of primary blue
  static const Color accent = Color(0xFF42A5F5); // Lighter accent blue

  // Grayscale Palette (Dominant Black & Aesthetic Dark Grey)
  static const Color black = Color(
    0xFF0A0A0A,
  ); // Deep, rich black for main backgrounds
  static const Color darkBackground = Color(
    0xFF1C1C1C,
  ); // Aesthetic dark grey for container backgrounds
  static const Color darkGrey = Color(
    0xFF2C2C2C,
  ); // Very dark grey, close to black for secondary elements
  static const Color mediumGrey = Color(
    0xFF4A4A4A,
  ); // Standard grey for secondary text
  static const Color grey = Color(
    0xFF757575,
  ); // Lighter grey for subtle elements
  static const Color lightGrey = Color(0xFFE0E0E0); // For borders, dividers
  static const Color backgroundLight = Color(
    0xFFF8F8F8,
  ); // Very light, almost white background for content areas
  static const Color white = Color(
    0xFFFFFFFF,
  ); // Pure white for strong contrast

  // --- BAGIAN INI YANG HARUS DITAMBAHKAN ---
  // Card Accent Colors (Subtle & Modern)
  static const Color cardAccentBlue = Color(0xFF2A3F54); // Muted dark blue
  static const Color cardAccentGreen = Color(0xFF2A4A42); // Muted dark green
  static const Color cardAccentPurple = Color(0xFF3F2A4A); // Muted dark purple
  static const Color cardAccentOrange = Color(0xFF4A3C2A); // Muted dark orange
  // --- AKHIR BAGIAN YANG HARUS DITAMBAHKAN ---

  // Status & Semantic Colors (No Change Needed)
  static const Color success = Color(0xFF4CAF50); // Green for success
  static const Color warning = Color(0xFFFFC107); // Amber for warning
  static const Color error = Color(0xFFF44336); // Red for error
  static const Color info = Color(
    0xFF2196F3,
  ); // Blue for informational (can reuse primary)

  static const Color backgroundGrey = Color(0xFFF0F2F5);
}
