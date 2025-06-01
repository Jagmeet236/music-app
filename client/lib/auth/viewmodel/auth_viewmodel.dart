// ignore_for_file: avoid_redundant_argument_values

import 'dart:developer';

import 'package:client/auth/model/auth_action.dart';
import 'package:client/auth/model/auth_state.dart';
import 'package:client/auth/model/user_model.dart';
import 'package:client/auth/repositories/auth_local_repository/auth_local_repository_impl.dart';
import 'package:client/auth/repositories/auth_remote_repository/auth_remote_repository_impl.dart';
import 'package:client/core/error/failure.dart';
import 'package:client/core/providers/current_user_notifier/current_user_notifier.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:fpdart/fpdart.dart' show Left, Right;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
/// ViewModel for managing authentication state and operations.
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepositoryImpl _authRemoteRepositoryImpl;
  late AuthLocalRepositoryImpl _authLocalRepositoryImpl;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AuthState build() {
    // Initialize the state or perform any setup if needed
    _authRemoteRepositoryImpl = ref.watch(authRemoteRepositoryImplProvider);
    _authLocalRepositoryImpl = ref.watch(authLocalRepositoryImplProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);

    return const AuthState();
  }

  /// Initializes shared preferences
  Future<void> init() async {
    await _authLocalRepositoryImpl.init();
  }

  /// signUp method to register a new user.
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, lastAction: AuthAction.signUp);

    final res = await _authRemoteRepositoryImpl.signUp(
      name: name,
      email: email,
      password: password,
    );

    switch (res) {
      case Left(value: final l):
        state = state.copyWith(
          isLoading: false,
          errorMessage: l.message,
          lastAction: AuthAction.signUp,
        );
      case Right(value: final r):
        state = state.copyWith(
          isLoading: false,
          user: r,
          lastAction: AuthAction.signUp,
          errorMessage: null,
        );
    }
    log('Signup response for action: ${state.lastAction}');
  }

  /// login method to authenticate an existing user.
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, lastAction: AuthAction.login);

    final res = await _authRemoteRepositoryImpl.login(
      email: email,
      password: password,
    );

    switch (res) {
      case Left(value: final l):
        state = state.copyWith(
          isLoading: false,
          errorMessage: l.message,
          lastAction: AuthAction.login,
        );

      case Right(value: final r):
        _loginSuccess(r);
    }
    log('Login response for action: ${state.lastAction}');
  }

  void _loginSuccess(UserModel user) {
    _authLocalRepositoryImpl.setToken(user.token);
    _currentUserNotifier.user = user;
    state = state.copyWith(
      isLoading: false,
      user: user,
      lastAction: AuthAction.login,
      errorMessage: null,
    );
  }

  /// gets the current user data.
  Future<UserModel?> getData() async {
    state = state.copyWith(
      isLoading: true,
      lastAction: AuthAction.getCurrentUser,
    );

    final token = _authLocalRepositoryImpl.getToken();

    if (token != null) {
      final res = await _authRemoteRepositoryImpl.getCurrentUserData(
        token: token,
      );

      switch (res) {
        case Left(value: final l):
          state = state.copyWith(
            isLoading: false,
            errorMessage: l.message,
            lastAction: AuthAction.getCurrentUser,
          );
          return null;
        case Right(value: final r):
          return _getDataSuccess(r);
      }
    } else {
      state = state.copyWith(
        isLoading: false,
        lastAction: AuthAction.getCurrentUser,
        errorMessage: null,
      );
    }
    return null;
  }

  UserModel? _getDataSuccess(UserModel user) {
    _currentUserNotifier.user = user;
    state = state.copyWith(
      isLoading: false,
      user: user,
      lastAction: AuthAction.getCurrentUser,
      errorMessage: null,
    );
    return user;
  }

  /// Logs out the current user by clearing local token and user state.
  ResultVoid logout() async {
    state = state.copyWith(isLoading: true, lastAction: AuthAction.logout);

    try {
      // Clear local auth token
      _authLocalRepositoryImpl.clearToken();

      // Clear current user
      _currentUserNotifier.user = null;

      return const Right(null); // success
    } on Exception catch (_) {
      return const Left(AppFailure('An error occurred while logging out'));
    } finally {
      state = state.copyWith(
        user: null,
        isLoading: false,
        lastAction: AuthAction.logout,
        errorMessage: null,
      );
    }
  }

  /// Clear the current action (useful for resetting state)
  void clearAction() {
    state = state.copyWith(lastAction: null, errorMessage: null);
  }

  /// Clear error message explicitly (useful for UI interactions)
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
