// lib/core/widgets/text_btn.dart

import 'package:client/core/extensions/app_context.dart';
import 'package:flutter/material.dart';

/// A reusable [TextButton] widget with customizable text, text color,
/// and an onTap callback.

class CustomTextBtn extends StatelessWidget {
  /// Creates a [CustomTextBtn] widget.
  const CustomTextBtn({
    required this.text,
    required this.textColor,
    required this.onTap,
    super.key,
  });

  /// The text to be displayed on the button.
  final String text;

  /// The color of the text.
  final Color textColor;

  /// The callback function to be executed when the button is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, // Remove padding
        minimumSize: Size.zero, // Remove minimum size constraints
        tapTargetSize:
            MaterialTapTargetSize.shrinkWrap, // Shrink tap target size
        foregroundColor: textColor,
        textStyle: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(text),
    );
  }
}
