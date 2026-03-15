import 'dart:developer';

import 'package:client/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:client/core/error/failure.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_datasource_impl.g.dart';

/// Riverpod provider for [AuthLocalDatasource].
@Riverpod(keepAlive: true)
AuthLocalDatasource authLocalDatasource(AuthLocalDatasourceRef ref) {
  return AuthLocalDatasourceImpl();
}

/// Implementation of [AuthLocalDatasource] using SharedPreferences.
class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  late SharedPreferences _sharedPreferences;

  /// Initializes SharedPreferences instance.
  @override
  ResultVoid init() async {
    try {
      log('Initializing AuthLocalDatasource');
      _sharedPreferences = await SharedPreferences.getInstance();
      return const Right(null);
    } on Exception catch (e, stackTrace) {
      log(
        'SharedPreferences initialization failed',
        error: e,
        stackTrace: stackTrace,
      );
      return const Left(AppFailure('Failed to initialize local storage'));
    }
  }

  /// Stores authentication token locally.
  @override
  void setToken(String? token) {
    if (token != null) {
      _sharedPreferences.setString('x-auth-token', token);
    }
  }

  /// Retrieves stored authentication token.
  @override
  String? getToken() {
    return _sharedPreferences.getString('x-auth-token');
  }

  /// Clears stored authentication token.
  @override
  void clearToken() {
    log('Clearing authentication token');
    _sharedPreferences.remove('x-auth-token');
  }
}
