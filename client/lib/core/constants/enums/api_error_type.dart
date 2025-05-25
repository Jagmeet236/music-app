/// Represents different types of errors that can occur during API calls.
enum ApiErrorType {
  /// The request was malformed or missing required parameters.
  badRequest,

  /// Authentication is required and has failed or not been provided.
  unauthorized,

  /// The user does not have the necessary permissions.
  forbidden,

  /// The requested resource was not found.
  notFound,

  /// The server encountered an unexpected condition.
  internalServerError,

  /// The request took too long to complete.
  timeout,

  /// A network-related error occurred.
  network,

  /// An unspecified error occurred.
  unknown,
}

/// Extension on [ApiErrorType] to provide readable error messages.
extension ApiErrorTypeExtension on ApiErrorType {
  /// A user-friendly message corresponding to each [ApiErrorType].
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
