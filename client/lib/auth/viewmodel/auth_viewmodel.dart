// ignore_for_file: avoid_redundant_argument_values

import 'dart:developer';

import 'package:client/auth/data/models/auth_action.dart';
import 'package:client/auth/data/models/auth_state.dart';
import 'package:client/auth/data/models/user_model.dart';
import 'package:client/auth/data/repositories/auth_repository_impl.dart';
import 'package:client/auth/domain/repositories/auth_repository.dart';
import 'package:client/core/providers/current_song_notifier/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier/current_user_notifier.dart';
import 'package:fpdart/fpdart.dart' show Left, Right;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

/// Manages authentication state and operations using [AuthRepository].
@riverpod
class AuthViewModel extends _$AuthViewModel {
  /// Authentication contract from the domain layer.
  late AuthRepository _authRepository;

  /// Global notifier holding the current authenticated user.
  late CurrentUserNotifier _currentUserNotifier;

  /// Initializes dependencies and returns the initial [AuthState].
  @override
  AuthState build() {
    _authRepository = ref.watch(authRepositoryProvider);
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

    final result = await _authRepository.signUp(
      name: name,
      email: email,
      password: password,
    );

    switch (result) {
      case Left(value: final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);

      case Right(value: final user):
        _currentUserNotifier.user = user;
        state = state.copyWith(
          isLoading: false,
          user: user,
          errorMessage: null,
          lastAction: AuthAction.signUp,
        );
    }

    log('SignUp completed');
  }

  /// Authenticates a user and updates the authentication state.
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, lastAction: AuthAction.login);

    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    switch (result) {
      case Left(value: final failure):
        state = state.copyWith(
          user: state.user,
          isLoading: false,
          errorMessage: failure.message,
          lastAction: null,
        );

      case Right(value: final user):
        _currentUserNotifier.user = user;

        state = state.copyWith(
          isLoading: false,
          user: user,
          errorMessage: null,
          lastAction: AuthAction.login,
        );
    }

    log('Login completed');
  }

  /// Fetches the currently authenticated user.
  Future<UserModel?> getCurrentUser() async {
    state = state.copyWith(
      isLoading: true,
      lastAction: AuthAction.getCurrentUser,
    );

    final result = await _authRepository.getCurrentUser();

    switch (result) {
      case Left(value: final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return null;

      case Right(value: final user):
        _currentUserNotifier.user = user;
        state = state.copyWith(
          isLoading: false,
          user: user,
          errorMessage: null,
        );
        return user;
    }
  }

  /// Logs out the current user and clears authentication state.
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, lastAction: AuthAction.logout);

    // Stop any playing audio before clearing session
    await ref.read(currentSongNotifierProvider.notifier).stopAndClear();

    await _authRepository.logout();
    _currentUserNotifier.user = null;

    state = state.copyWith(
      user: null,
      isLoading: false,
      errorMessage: null,
      lastAction: AuthAction.logout,
    );

    log('Logout completed');
  }

  /// Resets the last authentication action and error message.
  void clearAction() {
    state = AuthState(
      user: state.user,
      isLoading: false,
      lastAction: null,
      errorMessage: null,
    );
  }

  /// Clears the current error message.
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
