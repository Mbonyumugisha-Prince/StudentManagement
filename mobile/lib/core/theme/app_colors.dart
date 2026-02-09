import 'package:flutter/material.dart';

class AppColors {
  // ALU Official Brand Colors
  static const Color primaryBlue = Color(0xFF003366); // Navy Blue - Primary background
  static const Color primaryRed = Color(0xFFE31837); // Red - Warnings & High Priority
  static const Color primaryWhite = Color(0xFFFFFFFF); // White - Text & Section backgrounds
  static const Color accentYellow = Color(0xFFFFC72C); // Yellow - Highlights
  
  // Supporting colors
  static const Color darkBlue = Color(0xFF002244); // Darker blue for depth
  static const Color lightBlue = Color(0xFF004488); // Lighter blue for variations
  static const Color background = Color(0xFFF8F9FA); // Very light background
  static const Color textPrimary = Color(0xFF003366); // Dark blue text
  static const Color textSecondary = Color(0xFF6C757D); // Grey text
  static const Color textOnDark = Color(0xFFFFFFFF); // White text on dark backgrounds
  
  // Functional colors
  static const Color error = Color(0xFFE31837); // Red for errors
  static const Color success = Color(0xFF10B981); // Green for success
  static const Color warning = Color(0xFFFFC72C); // Yellow for warnings
  
  // Legacy aliases for backward compatibility
  static const Color primaryDark = primaryBlue;
  static const Color primaryGold = accentYellow;
}
