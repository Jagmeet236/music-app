import 'package:client/auth/viewmodel/auth_viewmodel.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_viewmodel.g.dart';

/// Fetches the app version and initializes the app
///  data with a minimum 3.5-second delay.
@riverpod
Future<String> splashViewModel(SplashViewModelRef ref) async {
  final stopwatch = Stopwatch()..start();

  final packageInfo = await PackageInfo.fromPlatform();
  
  // Initialize current user state
  await ref.read(authViewModelProvider.notifier).getCurrentUser();

  stopwatch.stop();
  final elapsedMs = stopwatch.elapsedMilliseconds;
  
  // Ensure a minimum of 3.5 seconds passes for the 
  //bouncy animation to be enjoyed
  if (elapsedMs < 3500) {
    await Future<void>.delayed(Duration(milliseconds: 3500 - elapsedMs));
  }

  return packageInfo.version;
}
