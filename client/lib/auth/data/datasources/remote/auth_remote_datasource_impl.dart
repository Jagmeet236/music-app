import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:client/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:client/auth/data/models/send_otp_response_model.dart';
import 'package:client/auth/data/models/user_model.dart';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/error/api_error_type.dart';
import 'package:client/core/error/failure.dart';
import 'package:client/core/network/web_api_service.dart';
import 'package:client/core/network/web_api_service_provider.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_datasource_impl.g.dart';
/// Provides an instance of [AuthRemoteDatasourceImpl] for remote
/// authentication operations.
@riverpod
AuthRemoteDatasource authRemoteDatasource(
  AuthRemoteDatasourceRef ref,
) {
  final apiService = ref.watch(webApiServiceProvider);
  return AuthRemoteDatasourceImpl(apiService);
}
/// concrete implementation of [AuthRemoteDatasource] that handles
/// authentication logic by communicating with a remote server.
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  /// creates an instance of  [AuthRemoteDatasourceImpl]
  ///  with the provided [WebApiService].
  AuthRemoteDatasourceImpl(this._apiService);

  final WebApiService _apiService;

  @override
  ResultFuture<UserModel> login({
    required String email,
    required String password,
  }) async {
    log('Logging in user: $email');

    try {
      final response = await _apiService.request(
        url: '${ServerConstant.serverUrl}/auth/login',
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final decoded = jsonDecode(response.body) as DataMap;

      if (response.statusCode == 200) {
        return Right(
          UserModel.fromJson(decoded['user'] as DataMap)
              .copyWith(token: decoded['token']?.toString()),
        );
      }

      final message =
          decoded['message']?.toString() ??
          decoded['detail']?.toString() ??
          'Unknown error';

      return Left(AppFailure(message));
    } on TimeoutException {
      return Left(AppFailure(ApiErrorType.timeout.message));
    } on Exception catch (e) {
      return Left(AppFailure('Unexpected error: $e'));
    }
  }

  @override
  ResultFuture<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    log('Signing up user: $name');

    try {
      final response = await _apiService.request(
        url: '${ServerConstant.serverUrl}/auth/signup',
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final decoded = jsonDecode(response.body) as DataMap;

      if (response.statusCode == 201) {
        return Right(UserModel.fromJson(decoded));
      }

      final message =
          decoded['message']?.toString() ??
          decoded['detail']?.toString() ??
          'Unknown error';

      return Left(AppFailure(message));
    } on TimeoutException {
      return Left(AppFailure(ApiErrorType.timeout.message));
    } on Exception catch (e) {
      return Left(AppFailure('Unexpected error: $e'));
    }
  }

  @override
  ResultFuture<UserModel> getCurrentUserData({
    required String token,
  }) async {
    try {
      final response = await _apiService.request(
        url: '${ServerConstant.serverUrl}/auth/',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      final decoded = jsonDecode(response.body) as DataMap;

      if (response.statusCode == 200) {
        return Right(
          UserModel.fromJson(decoded).copyWith(token: token),
        );
      }

      final message =
          decoded['message']?.toString() ??
          decoded['detail']?.toString() ??
          'Unknown error';

      return Left(AppFailure(message));
    } on TimeoutException {
      return Left(AppFailure(ApiErrorType.timeout.message));
    } on Exception catch (e) {
      return Left(AppFailure('Unexpected error: $e'));
    }
  }

  @override
  ResultFuture<SendOtpResponseModel> sendOtp({
    required String email,
  }) async {
    log('Sending OTP to: $email');

    try {
      final response = await _apiService.request(
        url: '${ServerConstant.serverUrl}/auth/send-otp',
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final decoded = jsonDecode(response.body) as DataMap;

      if (response.statusCode == 200) {
        final model = SendOtpResponseModel.fromJson(decoded);
        if (model.success) {
          return Right(model);
        } else {
          return Left(AppFailure(model.message));
        }
      }

      final message =
          decoded['message']?.toString() ??
          decoded['detail']?.toString() ??
          'Unknown error';

      return Left(AppFailure(message));
    } on TimeoutException {
      return Left(AppFailure(ApiErrorType.timeout.message));
    } on Exception catch (e) {
      return Left(AppFailure('Unexpected error: $e'));
    }
  }
}
