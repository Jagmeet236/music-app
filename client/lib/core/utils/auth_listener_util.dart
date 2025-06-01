// File: lib/core/utils/auth_listener_util.dart
import 'package:client/auth/model/auth_action.dart';
import 'package:client/auth/viewmodel/auth_viewmodel.dart';

import 'package:client/core/utils/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Configuration for auth action listeners
class AuthListenerConfig {
  /// Creates a new [AuthListenerConfig] instance
  const AuthListenerConfig({
    required this.action,
    required this.onSuccess,
    this.successMessage,
    this.onError,
    this.customErrorMessage,
    this.onLoading,
    this.showDefaultErrorMessage = true,
  });

  /// The specific authentication action to listen for
  final AuthAction action;

  /// Callbacks for success, error, and loading states
  final VoidCallback onSuccess;

  /// Optional success message to display on successful action
  final String? successMessage;

  /// Optional callbacks for error handling and loading state
  final VoidCallback? onError;

  /// Optional custom error message to display on error
  final String? customErrorMessage;

  /// Optional callback for loading state
  final VoidCallback? onLoading;

  /// Whether to show the default error message in the snackbar
  final bool showDefaultErrorMessage;
}

/// This utility class provides methods to
///  listen to authentication state changes
class AuthListenerUtil {
  /// Main listener method that handles specific auth actions
  static void listenForAction(
    WidgetRef ref,
    BuildContext context,
    AuthListenerConfig config,
  ) {
    ref.listen(authViewModelProvider, (prev, next) {
      // Only react if the last action matches the one we're listening for
      if (next.lastAction == config.action) {
        if (next.isLoading) {
          config.onLoading?.call();
        } else if (next.errorMessage != null) {
          // Handle error
          final errorMsg = config.customErrorMessage ?? next.errorMessage!;
          if (config.showDefaultErrorMessage) {
            showSnackBar(context, errorMsg);
          }
          config.onError?.call();
        } else {
          // Handle success (no error and not loading)
          if (config.successMessage != null) {
            showSnackBar(context, config.successMessage!);
          }
          config.onSuccess();
        }
      }
    });
  }

  /// Multiple action listener for complex flows
  static void listenForMultipleActions(
    WidgetRef ref,
    BuildContext context,
    List<AuthListenerConfig> configs,
  ) {
    ref.listen(authViewModelProvider, (prev, next) {
      // Find the config that matches the current action
      final matchingConfig = configs.firstWhere(
        (config) => config.action == next.lastAction,
        orElse:
            () =>
                throw StateError(
                  'No config found for action: ${next.lastAction}',
                ),
      );

      if (next.isLoading) {
        matchingConfig.onLoading?.call();
      } else if (next.errorMessage != null) {
        final errorMsg =
            matchingConfig.customErrorMessage ?? next.errorMessage!;
        if (matchingConfig.showDefaultErrorMessage) {
          showSnackBar(context, errorMsg);
        }
        matchingConfig.onError?.call();
      } else {
        if (matchingConfig.successMessage != null) {
          showSnackBar(context, matchingConfig.successMessage!);
        }
        matchingConfig.onSuccess();
      }
    });
  }

  /// Convenience method for sign up
  static void listenForSignUp(
    WidgetRef ref,
    BuildContext context,
    VoidCallback navigateToSignIn, {
    String? customSuccessMessage,
    VoidCallback? onError,
  }) {
    listenForAction(
      ref,
      context,
      AuthListenerConfig(
        action: AuthAction.signUp,
        onSuccess: navigateToSignIn,
        successMessage:
            customSuccessMessage ??
            'Account created successfully! Please Login',
        onError: onError,
      ),
    );
  }

  /// Convenience method for login
  static void listenForLogin(
    WidgetRef ref,
    BuildContext context,
    VoidCallback navigateToHome, {
    String? customSuccessMessage,
    VoidCallback? onError,
  }) {
    listenForAction(
      ref,
      context,
      AuthListenerConfig(
        action: AuthAction.login,
        onSuccess: navigateToHome,
        successMessage: customSuccessMessage ?? 'Login successful!',
        onError: onError,
      ),
    );
  }

  /// Convenience method for logout
  static void listenForLogout(
    WidgetRef ref,
    BuildContext context,
    VoidCallback navigateToLogin, {
    String? customSuccessMessage,
    VoidCallback? onError,
  }) {
    listenForAction(
      ref,
      context,
      AuthListenerConfig(
        action: AuthAction.logout,
        onSuccess: navigateToLogin,
        successMessage: customSuccessMessage ?? 'Logged out successfully',
        onError: onError,
      ),
    );
  }
}
