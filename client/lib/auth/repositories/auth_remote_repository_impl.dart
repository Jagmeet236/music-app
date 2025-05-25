import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:client/auth/repositories/auth_remote_repository.dart';
import 'package:client/core/constants/strings.dart';
import 'package:client/core/exceptions/api_exceptions.dart';

import 'package:client/core/utils/typedef.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

/// Concrete implementation of [AuthRemoteRepository] that handles
/// authentication logic by communicating with a remote server.
class AuthRemoteRepositoryImpl implements AuthRemoteRepository {
  /// Logs in the user with the provided [email] and [password].
  @override
  Future<void> login({required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse('$kBaseURL/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('User logged in successfully');
        // You can parse user data here if needed
      } else {
        // Cast decoded response to [DataMap] for better type safety
        final decoded = jsonDecode(response.body) as DataMap;
        throw ApiException.fromStatusCode(
          response.statusCode,
          decoded['message']?.toString() ?? 'Unknown error',
        );
      }
    } catch (error) {
      throw ApiException.fromError(error);
    }
  }

  /// Registers a new user using the provided [name], [email], and [password].
  ///
  /// Returns a [ResultFuture] that contains either a [DataMap]
  /// on success or an error [String].
  @override
  ResultFuture<DataMap> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$kBaseURL/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );

      // Decode JSON explicitly as DataMap for better type safety
      final decoded = jsonDecode(response.body) as DataMap;

      if (response.statusCode == 201) {
        // Success case: return Right with user data
        return Right(decoded);
      } else {
        // Error case: get error message safely and return Left with message
        final errorMessage =
            decoded['message']?.toString() ??
            decoded['detail']?.toString() ??
            'Unknown error';
        log(response.body);
        log(response.statusCode.toString());
        return Left(
          ApiException.fromStatusCode(
            response.statusCode,
            errorMessage,
          ).message,
        );
      }
    } on http.ClientException {
      return Left(ApiErrorType.network.message);
    } on FormatException {
      return Left(ApiErrorType.badRequest.message);
    } on TimeoutException {
      return Left(ApiErrorType.timeout.message);
    } on Exception catch (error) {
      return Left(ApiException.fromError(error).message);
    }
  }
}
