// lib/utils/constants.dart

import 'package:flutter/material.dart';

/// 🎨 AppColors: Defines the color palette based on color psychology.
/// - Blue: Trust, dependability, and stability.
/// - Orange: Vibrant call‑to‑action elements.
/// - Gray: A soft, neutral background.
/// - Red: Used for errors/alerts.
class AppColors {
  static const Color primaryBlue = Color(0xFF0074D9); // 💙 Blue for trust.
  static const Color accentOrange = Color(0xFFFF851B);  // 🟠 Vibrant orange.
  static const Color backgroundGray = Color(0xFFDDDDDD); // ⚪️ Soft neutral gray.
  static const Color errorRed = Color(0xFFE53935);       // 🔴 Red for errors.
}

/// 📏 AppSizes: Standardized sizes for consistent spacing and styling.
class AppSizes {
  static const double paddingLarge = 24.0; // Uniform large padding.
  static const double borderRadius = 12.0;   // Rounded corners for inputs/buttons.
  static const double iconSize = 28.0;       // Standard icon size.
}

/// ⏱️ AppDurations: Predefined animation durations.
class AppDurations {
  static const Duration splashDuration = Duration(seconds: 2);    // Splash/loader display duration.
  static const Duration fadeDuration = Duration(milliseconds: 500); // Fade-out duration.
}
