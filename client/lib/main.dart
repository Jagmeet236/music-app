import 'package:client/auth/view/pages/signup_page.dart';
import 'package:client/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/core/providers/current_user_notifier/current_user_notifier.dart';
import 'package:client/core/theme/theme.dart';
import 'package:client/home/view/pages/home_page.dart';
import 'package:client/home/view/pages/upload_song_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).init();
  final userModel =
      await container.read(authViewModelProvider.notifier).getData();
  debugPrint('UserModel: $userModel');

  runApp(
    UncontrolledProviderScope(container: container, child: const MusicApp()),
  );
}

/// Staring point root  widget
class MusicApp extends ConsumerWidget {
  /// creates a [MusicApp] widget
  const MusicApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      title: 'Music App',
      theme: AppTheme.darkThemeMode,

      home: currentUser == null ? const SignupPage() : const UploadSongPage(),
    );
  }
}
