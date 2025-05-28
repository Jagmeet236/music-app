import 'package:client/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// This widget is a placeholder for a loader widget that can be used
/// to indicate loading states in the application.
class Loader extends StatelessWidget {
  /// Creates a [Loader] widget.
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator.adaptive(
      backgroundColor: Palette.gradient2,
    );
  }
}
