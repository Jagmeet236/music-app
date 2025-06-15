import 'package:client/auth/model/auth_action.dart';
import 'package:client/auth/view/pages/signin_page.dart';
import 'package:client/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/core/constants/strings.dart';
import 'package:client/core/theme/app_palette.dart';

import 'package:client/core/utils/auth_listener_util.dart';
import 'package:client/core/utils/custom_snack_bar.dart';
import 'package:client/core/utils/media_res.dart';
import 'package:client/home/view/pages/library_page.dart';
import 'package:client/home/view/pages/songs_page.dart';
import 'package:client/home/view/widgets/music_slab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The HomePage widget serves as the main entry point for the
/// home screen of the application.
class HomePage extends ConsumerStatefulWidget {
  /// Creates a [HomePage] widget.
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;
  final pages = const [SongsPage(), LibraryPage()];
  @override
  Widget build(BuildContext context) {
    // Watch the auth state for loading
    final authState = ref.watch(authViewModelProvider);
    final isLoading =
        authState.isLoading && authState.lastAction == AuthAction.logout;

    debugPrint(
      'SignupPage state: $isLoading, lastAction: ${authState.lastAction}',
    );

    /// Listen only to SIGNUP actions
    AuthListenerUtil.listenForLogout(
      ref,
      context,
      navigateToSignInPage,
      onError: () {
        final authState = ref.read(authViewModelProvider);
        showSnackBar(
          context,
          authState.errorMessage ?? 'An error occurred during signup',
        );
        debugPrint('Signup failed');
      },
    );
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authViewModelProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Stack(
        children: [
          pages[selectedIndex],
          const Positioned(bottom: 0, child: MusicSlab()),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              selectedIndex == 0 ? MediaRes.homeFilled : MediaRes.homeUnfilled,
              color:
                  selectedIndex == 0
                      ? Palette.whiteColor
                      : Palette.inactiveBottomBarItemColor,
            ),
            label: home,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              MediaRes.library,
              color:
                  selectedIndex == 1
                      ? Palette.whiteColor
                      : Palette.inactiveBottomBarItemColor,
            ),
            label: library,
          ),
        ],
      ),
    );
  }

  /// Navigates to the SignInPage.
  void navigateToSignInPage() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<dynamic>(builder: (context) => const SigninPage()),
      (_) => false,
    );
  }
}
