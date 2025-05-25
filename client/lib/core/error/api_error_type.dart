/// Represents different types of API errors that can occur
/// during HTTP requests.
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
