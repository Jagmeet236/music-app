import 'package:client/auth/model/auth_action.dart';
import 'package:client/auth/view/pages/signin_page.dart';
import 'package:client/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/core/extensions/app_context.dart';

import 'package:client/core/utils/auth_listener_util.dart';
import 'package:client/core/utils/custom_snack_bar.dart';
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
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authViewModelProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to the Home Page!',
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
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
