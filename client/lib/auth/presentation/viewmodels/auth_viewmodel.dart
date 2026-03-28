import 'dart:developer';

import 'package:client/auth/data/models/auth_action.dart';
import 'package:client/auth/data/models/auth_state.dart';
import 'package:client/auth/data/models/user_model.dart';
import 'package:client/auth/data/repositories/auth_repository_impl.dart';
import 'package:client/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:client/auth/domain/usecases/login_usecase.dart';
import 'package:client/auth/domain/usecases/logout_usecase.dart';
import 'package:client/auth/domain/usecases/reset_password_usecase.dart';
import 'package:client/auth/domain/usecases/send_otp_usecase.dart';
import 'package:client/auth/domain/usecases/signup_usecase.dart';
import 'package:client/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:client/core/providers/current_song_notifier/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier/current_user_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' show Left, Right;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

/// Manages authentication state and
///  operations using [AuthViewModel].
@riverpod
class AuthViewModel extends _$AuthViewModel {
  late LoginUseCase _loginUseCase;
  late SignUpUseCase _signUpUseCase;
  late GetCurrentUserUseCase _getCurrentUserUseCase;
  late LogoutUseCase _logoutUseCase;
  late SendOtpUseCase _sendOtpUseCase;
  late VerifyOtpUseCase _verifyOtpUseCase;
  late ResetPasswordUseCase _resetPasswordUseCase;

  /// Global notifier holding the current authenticated user.
  late CurrentUserNotifier _currentUserNotifier;

  /// Initializes dependencies and returns the initial [AuthState].
  @override
  AuthState build() {
    final authRepository = ref.watch(authRepositoryProvider);
    _loginUseCase = LoginUseCase(authRepository);
    _signUpUseCase = SignUpUseCase(authRepository);
    _getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);
    _logoutUseCase = LogoutUseCase(authRepository);
    _sendOtpUseCase = SendOtpUseCase(authRepository);
    _verifyOtpUseCase = VerifyOtpUseCase(authRepository);
    _resetPasswordUseCase = ResetPasswordUseCase(authRepository);
    
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);

    return const AuthState();
  }

  /// Registers a new user and updates state accordingly.
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, lastAction: AuthAction.signUp);

    final result = await _signUpUseCase(SignUpParams(
      name: name,
      email: email,
      password: password,
    ));

    switch (result) {
      case Left(value: final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);

      case Right(value: final user):
        _currentUserNotifier.user = user;
        state = state.copyWith(
          isLoading: false,
          user: user,
          lastAction: AuthAction.signUp,
        );
    }

    if (kDebugMode) {
      log('SignUp completed');
    }
  }

  /// Authenticates a user and updates the authentication state.
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, lastAction: AuthAction.login);

    final result = await _loginUseCase(LoginParams(
      email: email,
      password: password,
    ));

    switch (result) {
      case Left(value: final failure):
        state = state.copyWith(
          user: state.user,
          isLoading: false,
          errorMessage: failure.message,
        );

      case Right(value: final user):
        _currentUserNotifier.user = user;

        state = state.copyWith(
          isLoading: false,
          user: user,
          lastAction: AuthAction.login,
        );
    }

    if (kDebugMode) {
      log('Login completed');
    }
  }

  /// Fetches the currently authenticated user.
  Future<UserModel?> getCurrentUser() async {
    state = state.copyWith(
      isLoading: true,
      lastAction: AuthAction.getCurrentUser,
    );

    final result = await _getCurrentUserUseCase();

    switch (result) {
      case Left(value: final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return null;

      case Right(value: final user):
        _currentUserNotifier.user = user;
        state = state.copyWith(isLoading: false, user: user);
        return user;
    }
  }

  /// Logs out the current user and clears authentication state.
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, lastAction: AuthAction.logout);

    // Stop any playing audio before clearing session
    await ref.read(currentSongNotifierProvider.notifier).stopAndClear();

    await _logoutUseCase();
    _currentUserNotifier.user = null;

    state = state.copyWith(isLoading: false, lastAction: AuthAction.logout);

    if (kDebugMode) {
      log('Logout completed');
    }
  }

  /// Sends an OTP to the given email address.
  Future<void> sendOtp({required String email}) async {
    state = state.copyWith(isLoading: true, lastAction: AuthAction.sendOtp);

    final result = await _sendOtpUseCase(SendOtpParams(email: email));

    switch (result) {
      case Left(value: final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);

      case Right():
        state = state.copyWith(
          isLoading: false,
          lastAction: AuthAction.sendOtp,
        );
    }

    if (kDebugMode) {
      log('Send OTP completed');
    }
  }

  /// Verifies an OTP based on the given email, otp, and purpose.
  Future<void> verifyOtp({
    required String email,
    required String otp,
    required String? purpose,
  }) async {
    state = state.copyWith(isLoading: true, lastAction: AuthAction.verifyOtp);

    final result = await _verifyOtpUseCase(VerifyOtpParams(
      email: email,
      otp: otp,
      purpose: purpose,
    ));

    switch (result) {
      case Left(value: final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);

      case Right():
        state = state.copyWith(
          isLoading: false,
          lastAction: AuthAction.verifyOtp,
        );
    }

    if (kDebugMode) {
      log('Verify OTP completed');
    }
  }

  /// Resets the user's password using the locally stored reset token.
  Future<void> resetPassword({required String newPassword}) async {
    state = state.copyWith(
      isLoading: true,
      lastAction: AuthAction.resetPassword,
    );

    final result = await _resetPasswordUseCase(ResetPasswordParams(
      newPassword: newPassword,
    ));

    switch (result) {
      case Left(value: final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);

      case Right():
        state = state.copyWith(
          isLoading: false,
          lastAction: AuthAction.resetPassword,
        );
    }

    if (kDebugMode) {
      log('Reset Password completed');
    }
  }

  /// Resets the last authentication action and error message.
  void clearAction() {
    state = AuthState(user: state.user);
  }

  /// Clears the current error message.
  void clearError() {
    state = state.copyWith();
  }
}

/// Provider to store the email email being used for OTP verification.
final authEmailProvider = StateProvider<String?>((ref) => null);

/// Provider to store the purpose of the OTP (e.g. 'reset_password' or null).
final authPurposeProvider = StateProvider<String?>((ref) => null);
