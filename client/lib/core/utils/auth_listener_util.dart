// File: lib/core/utils/auth_listener_util.dart

import 'package:client/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/core/utils/custom_snack_bar.dart'; // Assuming you have this
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This utility class provides methods to listen to
///  authentication state changes
class AuthListenerUtil {
  /// Creates a listener for authentication operations with custom callbacks
  static void listen(
    WidgetRef ref,
    BuildContext context, {
    required VoidCallback onSuccess,
    String? successMessage,
    VoidCallback? onError,
    VoidCallback? onLoading,
  }) {
    ref.listen(authViewModelProvider, (prev, next) {
      next.when(
        data: (data) {
          if (successMessage != null) {
            showSnackBar(context, successMessage);
          }
          onSuccess();
        },
        error: (error, st) {
          showSnackBar(context, error.toString());
          onError?.call();
        },
        loading: () {
          onLoading?.call();
        },
      );
    });
  }

  /// Specific listener for sign up operations
  static void listenForSignUp(
    WidgetRef ref,
    BuildContext context,
    VoidCallback navigateToSignIn,
  ) {
    listen(
      ref,
      context,
      onSuccess: navigateToSignIn,
      successMessage: 'Account created successfully! Please Login in',
    );
  }

  /// Specific listener for login operations
  static void listenForLogin(
    WidgetRef ref,
    BuildContext context,
    VoidCallback navigateToHome,
  ) {
    listen(
      ref,
      context,
      onSuccess: navigateToHome,
      successMessage: 'Login successful!',
    );
  }
}
