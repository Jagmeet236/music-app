import 'dart:developer';

import 'package:client/auth/repositories/auth_local_repository/auth_local_repository.dart';
import 'package:client/core/error/failure.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_repository_impl.g.dart';

/// Provides an instance of [AuthLocalRepositoryImpl] for
/// local storage management
@Riverpod(keepAlive: true)
AuthLocalRepositoryImpl authLocalRepositoryImpl(Ref ref) {
  return AuthLocalRepositoryImpl();
}

/// A repository for managing local authentication data using SharedPreferences.
class AuthLocalRepositoryImpl implements AuthLocalRepository {
  late SharedPreferences _sharedPreferences;

  /// initializes the SharedPreferences instance.
  @override
  ResultVoid init() async {
    try {
      log('Initializing AuthLocalRepositoryImpl');
      _sharedPreferences = await SharedPreferences.getInstance();
      return const Right(null);
    } on Exception catch (e, stackTrace) {
      log('SharedPreferences init failed', error: e, stackTrace: stackTrace);
      return const Left(AppFailure('Failed to initialize local storage'));
    }
  }

  /// saves the user token to local storage.
  @override
  void setToken(String? token) {
    if (token != null) {
      _sharedPreferences.setString('x-auth-token', token);
    }
  }

  /// retrieves the user token from local storage.
  @override
  String? getToken() {
    return _sharedPreferences.getString('x-auth-token');
  }

  @override
  void clearToken() {
    log('Clearing user token from local storage');
    _sharedPreferences.remove('x-auth-token');
  }
}
