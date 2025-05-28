import 'dart:developer';

import 'package:client/auth/model/user_model.dart';
import 'package:client/auth/repositories/auth_remote_repository_impl.dart';
import 'package:fpdart/fpdart.dart' show Left, Right;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
/// ViewModel for managing authentication state and operations.
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepositoryImpl _authRemoteRepositoryImpl;

  @override
  AsyncValue<UserModel?> build() {
    // Initialize the state or perform any setup if needed
    _authRemoteRepositoryImpl = ref.watch(authRemoteRepositoryImplProvider);
    return const AsyncData(null);
  }

  /// signUp method to register a new user.
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final res = await _authRemoteRepositoryImpl.signUp(
      name: name,
      email: email,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncData(r),
    };
    log('Signup response: $val');
  }

  /// login method to authenticate an existing user.
  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    final res = await _authRemoteRepositoryImpl.login(
      email: email,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncData(r),
    };
    log('Login response: $val');
  }
}
