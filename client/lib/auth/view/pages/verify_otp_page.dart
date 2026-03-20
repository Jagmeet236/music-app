import 'package:flutter/material.dart';

/// A simple Verify OTP screen.
class VerifyOtpPage extends StatelessWidget {
  /// Creates a [VerifyOtpPage] widget.
  const VerifyOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: const Center(
        child: Text('Verify OTP Screen Example'),
      ),
    );
  }
}
