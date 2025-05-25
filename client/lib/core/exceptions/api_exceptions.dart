import 'dart:async';
import 'package:http/http.dart' as http;

/// Represents different types of API errors.
/// Types of API errors that can occur during HTTP requests.
enum ApiErrorType {
  /// The request was invalid or malformed.
  badRequest,

  /// Authentication failed or user is not authorized.
  unauthorized,

  /// Access to the requested resource is forbidden.
  forbidden,

  /// The requested resource could not be found.
  notFound,

  /// Server encountered an internal error.
  internalServerError,

  /// The request timed out before completion.
  timeout,

  /// Network connection failed or is unavailable.
  network,

  /// An unknown or unexpected error occurred.
  unknown,
}

/// Extension on [ApiErrorType] to provide user-friendly error messages.
extension ApiErrorTypeExtension on ApiErrorType {
  /// Returns a readable error message corresponding to the [ApiErrorType].
  String get message {
    switch (this) {
      case ApiErrorType.badRequest:
        return 'Bad request';
      case ApiErrorType.unauthorized:
        return 'Unauthorized';
      case ApiErrorType.forbidden:
        return 'Forbidden';
      case ApiErrorType.notFound:
        return 'Not found';
      case ApiErrorType.internalServerError:
        return 'Internal server error';
      case ApiErrorType.timeout:
        return 'Request timed out';
      case ApiErrorType.network:
        return 'Network error';
      case ApiErrorType.unknown:
        return 'Unknown error';
    }
  }
}

/// A custom exception used to handle API-related errors
/// consistently across the app.
class ApiException implements Exception {
  /// Constructs an [ApiException] with a provided message.
  const ApiException(this.message);

  /// Creates an [ApiException] from various known Dart exceptions.
  factory ApiException.fromError(Object error) {
    if (error is ApiException) {
      return error;
    } else if (error is http.ClientException) {
      return const ApiException('Network error');
    } else if (error is FormatException) {
      return const ApiException('Bad request: Invalid format');
    } else if (error is TimeoutException) {
      return const ApiException('Request timed out');
    } else {
      return ApiException('Unexpected error: $error');
    }
  }

  /// Creates an [ApiException] based on an HTTP status code
  /// and optional custom message.
  factory ApiException.fromStatusCode(int statusCode, [String? customMessage]) {
    switch (statusCode) {
      case 400:
        return ApiException(customMessage ?? ApiErrorType.badRequest.message);
      case 401:
        return ApiException(customMessage ?? ApiErrorType.unauthorized.message);
      case 403:
        return ApiException(customMessage ?? ApiErrorType.forbidden.message);
      case 404:
        return ApiException(customMessage ?? ApiErrorType.notFound.message);
      case 500:
        return ApiException(
          customMessage ?? ApiErrorType.internalServerError.message,
        );
      default:
        return ApiException(customMessage ?? ApiErrorType.unknown.message);
    }
  }

  /// The user-friendly error message.
  final String message;

  @override
  String toString() => message;
}
