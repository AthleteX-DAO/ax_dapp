import 'package:flutter/material.dart';

/// Gold theme styling for prediction market UI components
/// Provides consistent panel, emphasis, and color styling across the platform
class GoldTheme {
  // Gold color palette matching platform branding
  static const Color gold = Color.fromRGBO(254, 197, 0, 1);
  static const Color goldLight = Color.fromRGBO(254, 197, 0, 0.2);
  static const Color goldDark = Color.fromRGBO(204, 158, 0, 1);

  // Create a panel decoration for content containers
  // Combines gradient background with subtle border
  static BoxDecoration panel({
    double radius = 12,
    bool withGoldAccent = false,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.08),
          Colors.white.withOpacity(0.04),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: withGoldAccent ? gold.withOpacity(0.3) : Colors.white.withOpacity(0.15),
        width: withGoldAccent ? 1.5 : 1,
      ),
    );
  }

  // Create an emphasis decoration for highlighted UI elements
  // Uses gold-tinted styling to draw attention
  static BoxDecoration emphasis({
    double radius = 12,
  }) {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.06),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: gold.withOpacity(0.4),
        width: 1.5,
      ),
    );
  }

  // Create a gold-highlighted panel for premium or featured content
  static BoxDecoration goldPanel({
    double radius = 12,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          gold.withOpacity(0.15),
          gold.withOpacity(0.08),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: gold.withOpacity(0.5),
        width: 1.5,
      ),
    );
  }

  // Create a dark panel decoration for contrast
  static BoxDecoration darkPanel({
    double radius = 12,
  }) {
    return BoxDecoration(
      color: Colors.black.withOpacity(0.3),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: Colors.white.withOpacity(0.1),
      ),
    );
  }

  // Create a gold accent button decoration
  static BoxDecoration goldButton({
    double radius = 8,
  }) {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          gold,
          goldDark,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: gold.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Get gold color with opacity
  static Color goldWithOpacity(double opacity) {
    return Color.fromARGB(
      (255 * opacity).toInt(),
      254,
      197,
      0,
    );
  }
}
