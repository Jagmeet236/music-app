import 'package:client/core/theme/theme.dart';
import 'package:client/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(child: MusicApp()),
  );
}

/// Staring point root  widget
class MusicApp extends ConsumerWidget {
  /// creates a [MusicApp] widget
  const MusicApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Music App',
      theme: AppTheme.darkThemeMode,
      home: const SplashPage(),
    );
  }
}
