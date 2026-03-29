import 'package:flutter/material.dart';

/// Converts a [Color] to a 6-character hexadecimal RGB string (e.g., 'AABBCC').
///
/// - Ignores the alpha channel (transparency).
/// - Uses [Color.toARGB32()] to safely access color components
///   instead of the deprecated `value` property.
///
/// Example:
/// ```dart
/// final color = Color(0xFF42A5F5);
/// final hex = rgbToHex(color); // '42A5F5'
/// ```
String rgbToHex(Color color) {
  // Get the 32-bit ARGB representation of the color
  final argb = color.toARGB32();

  // Extract individual color channels using bitwise operations
  final red = (argb >> 16) & 0xFF;
  final green = (argb >> 8) & 0xFF;
  final blue = argb & 0xFF;

  // Convert each channel to a 2-digit hexadecimal string and combine
  return '${red.toRadixString(16).padLeft(2, '0')}'
          '${green.toRadixString(16).padLeft(2, '0')}'
          '${blue.toRadixString(16).padLeft(2, '0')}'
      .toUpperCase();
}

/// Converts a hexadecimal RGB string (e.g., 'AABBCC' or '#AABBCC')
/// into a fully opaque [Color].
///
/// - Automatically handles strings with or without a leading '#'.
/// - Assumes alpha = 0xFF (fully opaque).
///
/// Example:
/// ```dart
/// final color = hexToColor('42A5F5'); // Color(0xFF42A5F5)
/// final colorWithHash = hexToColor('#42A5F5'); // also valid
/// ```
Color hexToColor(String hex) {
  // Remove '#' prefix if present
  final cleanHex = hex.startsWith('#') ? hex.substring(1) : hex;

  // Parse the hex string and add full opacity (0xFF000000)
  return Color(int.parse(cleanHex, radix: 16) + 0xFF000000);
}
