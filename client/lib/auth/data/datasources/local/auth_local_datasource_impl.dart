import 'dart:async';
import 'dart:developer';

import 'package:client/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:client/core/error/failure.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:flutter/foundation.dart';
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
  bool _isInitialized = false;
  Timer? _resetTokenTimer;

  /// Initializes SharedPreferences instance.
  @override
  ResultVoid init() async {
    try {
      if (!_isInitialized) {
        if (kDebugMode) {
          log('Initializing AuthLocalDatasource');
        }
        _sharedPreferences = await SharedPreferences.getInstance();
        
        // Clear any leftover reset token from previous sessions on cold start
        if (_sharedPreferences.containsKey('reset-token')) {
          if (kDebugMode) {
            log('Cold start detected: Clearing expired reset token');
          }
          await _sharedPreferences.remove('reset-token');
        }

        if (kDebugMode) {
          log(
            'AuthLocalDatasource Initialized, Token: ${getToken()} '
            'Reset Token: ${getResetToken()}',
          );
        }
        _isInitialized = true;
      }
      return const Right(null);
    } on Exception catch (e, stackTrace) {
      if (kDebugMode) {
        log(
          'SharedPreferences initialization failed',
          error: e,
          stackTrace: stackTrace,
        );
      }
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
    if (kDebugMode) {
      log('Clearing authentication token');
    }
    _sharedPreferences.remove('x-auth-token');
  }

  /// Stores password reset token locally.
  @override
  void setResetToken(String? token) {
    if (token != null) {
      if (kDebugMode) {
        log('Saving new reset token... Old token will be overwritten.');
      }
      _sharedPreferences.setString('reset-token', token);
      
      // Cancel existing timer if any
      _resetTokenTimer?.cancel();
      // Schedule to remove the token after 5 minutes automatically
      _resetTokenTimer = Timer(const Duration(minutes: 5), () {
        if (kDebugMode) {
          log('5 minutes passed. Reset token expired/deleted automatically.');
        }
        clearResetToken();
      });
    }
  }

  /// Retrieves stored password reset token.
  @override
  String? getResetToken() {
    return _sharedPreferences.getString('reset-token');
  }

  /// Clears stored password reset token.
  @override
  void clearResetToken() {
    if (kDebugMode) {
      log('Clearing reset token');
    }
    _sharedPreferences.remove('reset-token');
  }
}
