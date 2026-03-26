import 'package:client/auth/view/pages/signup_page.dart';
import 'package:client/core/providers/current_user_notifier/current_user_notifier.dart';
import 'package:client/core/utils/animation_util.dart';
import 'package:client/core/utils/media_res.dart';
import 'package:client/core/utils/navigation_util.dart';
import 'package:client/home/view/pages/home_page.dart';
import 'package:client/splash/viewmodel/splash_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// The splash screen which acts as the initial entry point of the application.
class SplashPage extends ConsumerStatefulWidget {
  /// Creates a [SplashPage].
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  String? _version;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );

    // Delay animation start by 500ms to clear Android native splash
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _animController.forward();
      }
    });

    _fetchVersion();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _fetchVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _version = packageInfo.version);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashViewModelProvider, (previous, next) {
      if (next is AsyncData) {
        final currentUser = ref.read(currentUserNotifierProvider);
        // Replace Splash Screen gently with a bounce slide
        NavigationUtil.pushReplacement<dynamic, dynamic>(
          context,
          currentUser == null ? const SignupPage() : const HomePage(),
          transitionBuilder: AnimationUtil.slide(intensity: 2),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(MediaRes.appLogo, width: 250, height: 250),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child:
                    _version != null
                        ? FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'v$_version',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.5,
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
