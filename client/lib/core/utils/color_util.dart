import 'package:flutter/material.dart';

/// Converts a [Color] object to a hexadecimal RGB string (e.g., 'AABBCC').
///
/// The resulting string represents only the red, green, and blue components
/// of the color (ignores alpha).
///
/// Example:
/// ```dart
/// final color = Color(0xFF42A5F5);
/// final hex = rgbToHex(color); // Returns '42A5F5'
/// ```
String rgbToHex(Color color) {
  // Extract RGB values using bit operations
  final red = (color.value >> 16) & 0xFF;
  final green = (color.value >> 8) & 0xFF;
  final blue = color.value & 0xFF;

  return '${red.toRadixString(16).padLeft(2, '0')}'
          '${green.toRadixString(16).padLeft(2, '0')}'
          '${blue.toRadixString(16).padLeft(2, '0')}'
      .toUpperCase();
}

/// Converts a hexadecimal RGB string (e.g., 'AABBCC') to a [Color] object.
///
/// Assumes the color is fully opaque (alpha = 0xFF).
/// The input string should not include the '#' character.
///
/// Example:
/// ```dart
/// final color = hexToColor('42A5F5'); // Returns Color(0xFF42A5F5)
/// ```
Color hexToColor(String hex) {
  // Remove '#' if present
  var cleanHex = hex;
  if (hex.startsWith('#')) {
    cleanHex = hex.substring(1);
  }

  return Color(int.parse(cleanHex, radix: 16) + 0xFF000000);
}
