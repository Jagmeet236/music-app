import 'package:client/auth/view/pages/signup_page.dart';
import 'package:client/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MusicApp()));
}

/// Staring point root  widget
class MusicApp extends StatelessWidget {
  /// creates a [MusicApp] widget
  const MusicApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      theme: AppTheme.darkThemeMode,
      home: const SignupPage(),
    );
  }
}
