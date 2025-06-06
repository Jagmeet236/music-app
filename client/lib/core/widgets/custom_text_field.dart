import 'package:flutter/material.dart';

/// A custom reusable text field widget.
class CustomTextField extends StatelessWidget {
  /// Creates a [CustomTextField] widget.
  const CustomTextField({
    required this.hintText,
    this.controller,
    super.key,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
  });

  /// The hint text to display inside the text field.
  /// This text provides a hint to the user about what to enter in the field.
  final String hintText;

  /// The controller to manage the text input in the field.
  final TextEditingController? controller;

  //// A boolean value indicating whether the text should be obscured (e.g., for passwords).
  final bool obscureText;

  /// allows the text field to be read-only.
  final bool readOnly;

  /// to handle tap events on the text field.
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
