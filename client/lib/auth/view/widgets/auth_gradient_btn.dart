import 'package:client/core/extensions/app_context.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// A widget that represents a gradient button for authentication purposes.
/// This button can be used for actions like login or signup.
class AuthGradientBtn extends StatefulWidget {
  /// Creates an instance of [AuthGradientBtn].
  const AuthGradientBtn({
    required this.buttonText,
    required this.onTap,
    super.key,
  });

  /// The text to be displayed on the button.
  final String buttonText;

  /// The callback function to be executed when the button is tapped.
  final VoidCallback onTap;
  @override
  State<AuthGradientBtn> createState() => _AuthGradientBtnState();
}

class _AuthGradientBtnState extends State<AuthGradientBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Palette.gradient1, Palette.gradient2],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        onPressed: widget.onTap,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
          backgroundColor: Palette.transparentColor,
          shadowColor: Palette.transparentColor,
        ),
        child: Text(
          widget.buttonText,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
