import 'package:flutter/material.dart';

/// A utility class that holds the application's color palette.
///
/// This class defines a set of constant colors used throughout the app
/// for consistent theming and styling. These include background colors,
/// gradients, button states, and text colors.
///
/// All values are immutable and should be accessed via `Palette.<colorName>`.
class Palette {
  /// The primary color used for cards or containers.
  static const Color cardColor = Color.fromRGBO(30, 30, 30, 1);

  /// A standard green color used for indicating success or active states.
  static const Color greenColor = Colors.green;

  /// A light gray color used for subtitles or secondary text.
  static const Color subtitleText = Color(0xffa7a7a7);

  /// The color for inactive items in the bottom navigation bar.
  static const Color inactiveBottomBarItemColor = Color(0xffababab);

  /// The global background color of the app.
  static const Color backgroundColor = Color.fromRGBO(18, 18, 18, 1);

  /// The first gradient color in a multicolor gradient.
  static const Color gradient1 = Color.fromRGBO(187, 63, 221, 1);

  /// The second gradient color in a multicolor gradient.
  static const Color gradient2 = Color.fromRGBO(251, 109, 169, 1);

  /// The third gradient color in a multicolor gradient.
  static const Color gradient3 = Color.fromRGBO(255, 159, 124, 1);

  /// The color used for borders around input fields or containers.
  static const Color borderColor = Color.fromRGBO(52, 51, 67, 1);

  /// A pure white color, typically used for text and icons.
  static const Color whiteColor = Colors.white;

  /// A default gray color for neutral elements.
  static const Color greyColor = Colors.grey;

  /// The color used to indicate errors or alert states.
  static const Color errorColor = Colors.redAccent;

  /// A fully transparent color.
  static const Color transparentColor = Colors.transparent;

  /// The color used for inactive portions of sliders or seek bars.
  static const Color inactiveSeekColor = Colors.white38;
}
