import 'package:client/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A custom reusable text field widget.
class CustomTextField extends StatefulWidget {
  /// Creates a [CustomTextField] widget.
  const CustomTextField({
    required this.hintText,
    this.controller,
    super.key,
    this.isPassword = false,
    this.readOnly = false,
    this.onTap,

    /// ✅ NEW PROPERTIES
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.style,
  });

  /// The hint text to display inside the text field.
  /// This text provides a hint to the user about what to enter in the field.
  final String hintText;

  /// The controller to manage the text input in the field.
  final TextEditingController? controller;

  //// A boolean value indicating whether the text is a password (adds eye icon).
  final bool isPassword;

  /// allows the text field to be read-only.
  final bool readOnly;

  /// to handle tap events on the text field.
  final VoidCallback? onTap;

  /// ✅ NEW: keyboard type (number, email, etc.)
  final TextInputType? keyboardType;

  /// ✅ NEW: input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// ✅ NEW: max length
  final int? maxLength;

  /// ✅ NEW: custom text style
  final TextStyle? style;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      controller: widget.controller,
      obscureText: obscureText,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,

      /// ✅ FIX TEXT VISIBILITY ISSUE
      style: widget.style ?? const TextStyle(color: Colors.white, fontSize: 16),

      cursorColor: Colors.white,

      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },

      decoration: InputDecoration(
        counterText: '', // ✅ removes counter for OTP
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey),

        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Palette.gradient2, width: 2),
        ),

        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                )
                : null,
      ),
    );
  }
}
