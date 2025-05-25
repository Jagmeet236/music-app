/// A base class representing a failure or error that occurred in the app.
///
/// This class is used to encapsulate error messages and provide
/// a consistent way to handle failures throughout the application.
class AppFailure {
  /// Creates a [AppFailure] instance with the provided error [message].
  const AppFailure([this.message = 'An unexpected error occurred.']);

  /// The error message describing the failure.
  final String message;

  @override
  String toString() => 'AppFailure(message: $message)';
}
