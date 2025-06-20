import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:client/auth/model/user_model.dart';
import 'package:client/auth/repositories/auth_remote_repository/auth_remote_repository.dart';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/error/api_error_type.dart';
import 'package:client/core/error/failure.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_remote_repository_impl.g.dart';

/// Provides an instance of [AuthRemoteRepositoryImpl] for remote
/// authentication operations.
@riverpod
AuthRemoteRepositoryImpl authRemoteRepositoryImpl(Ref ref) {
  return AuthRemoteRepositoryImpl();
}

/// Concrete implementation of [AuthRemoteRepository] that handles
/// authentication logic by communicating with a remote server.
class AuthRemoteRepositoryImpl implements AuthRemoteRepository {
  /// Logs in the user with the provided [email] and [password].
  @override
  ResultFuture<UserModel> login({
    required String email,
    required String password,
  }) async {
    log('Logging in user: $email');
    try {
      final response = await http.post(
        Uri.parse('${ServerConstant.serverUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      // Cast decoded response to [DataMap] for better type safety
      final decoded = jsonDecode(response.body) as DataMap;
      if (response.statusCode == 200) {
        debugPrint('User logged in successfully');

        /// If the response is successful, parse the user data
        return Right(
          UserModel.fromJson(
            decoded['user'] as DataMap,
          ).copyWith(token: decoded['token']?.toString()),
        );
      } else {
        final errorMessage =
            decoded['message']?.toString() ??
            decoded['detail']?.toString() ??
            'Unknown error';

        return Left(AppFailure(errorMessage));
      }
    } on http.ClientException {
      return Left(AppFailure(ApiErrorType.network.message));
    } on FormatException {
      return Left(AppFailure(ApiErrorType.badRequest.message));
    } on TimeoutException {
      return Left(AppFailure(ApiErrorType.timeout.message));
    } on Exception catch (e) {
      return Left(AppFailure('Unexpected error: $e'));
    }
  }

  /// Registers a new user using the provided [name], [email], and [password].
  ///
  /// Returns a [ResultFuture] that contains either a [DataMap]
  /// on success or an error [String].
  @override
  ResultFuture<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    log('Signing up user: $name, $email');
    try {
      final response = await http.post(
        Uri.parse('${ServerConstant.serverUrl}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );

      final decoded = jsonDecode(response.body) as DataMap;

      if (response.statusCode == 201) {
        return Right(UserModel.fromJson(decoded));
      } else {
        final errorMessage =
            decoded['message']?.toString() ??
            decoded['detail']?.toString() ??
            'Unknown error';

        return Left(AppFailure(errorMessage));
      }
    } on http.ClientException {
      return Left(AppFailure(ApiErrorType.network.message));
    } on FormatException {
      return Left(AppFailure(ApiErrorType.badRequest.message));
    } on TimeoutException {
      return Left(AppFailure(ApiErrorType.timeout.message));
    } on Exception catch (e) {
      return Left(AppFailure('Unexpected error: $e'));
    }
  }

  /// Retrieves the current user data using the provided [token].
  @override
  ResultFuture<UserModel> getCurrentUserData({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('${ServerConstant.serverUrl}/auth/'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      // Cast decoded response to [DataMap] for better type safety
      final decoded = jsonDecode(response.body) as DataMap;
      if (response.statusCode == 200) {
        debugPrint('User data retrieved successfully');

        /// If the response is successful, parse the user data
        return Right(UserModel.fromJson(decoded).copyWith(token: token));
      } else {
        final errorMessage =
            decoded['message']?.toString() ??
            decoded['detail']?.toString() ??
            'Unknown error';

        return Left(AppFailure(errorMessage));
      }
    } on http.ClientException {
      return Left(AppFailure(ApiErrorType.network.message));
    } on FormatException {
      return Left(AppFailure(ApiErrorType.badRequest.message));
    } on TimeoutException {
      return Left(AppFailure(ApiErrorType.timeout.message));
    } on Exception catch (e) {
      return Left(AppFailure('Unexpected error: $e'));
    }
  }
}
