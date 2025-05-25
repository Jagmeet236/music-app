import 'package:flutter/material.dart';

/// Extension on BuildContext for convenient access to common properties
extension ContextExtensions on BuildContext {
  /// Returns the screen width
  double get width => MediaQuery.of(this).size.width;

  /// Returns the screen height
  double get height => MediaQuery.of(this).size.height;

  /// Provides access to the current ThemeData
  ThemeData get theme => Theme.of(this);

  /// Provides access to the current TextTheme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Provides access to the current MediaQueryData
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns true if the current theme mode is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
