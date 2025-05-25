import 'package:client/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Defines the app's custom dark theme and UI styling.
class AppTheme {
  /// Creates a rounded [OutlineInputBorder] with the given [color].
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 3),
    borderRadius: BorderRadius.circular(10),
  );

  /// Custom dark theme configuration for the app.
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Palette.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _border(Palette.borderColor),
      focusedBorder: _border(Palette.gradient2),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Palette.backgroundColor,
    ),
  );
}
