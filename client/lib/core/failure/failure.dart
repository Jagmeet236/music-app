/// A base class representing a failure or error that occurred in the app.
///
/// This class is used to encapsulate error messages and provide
/// a consistent way to handle failures throughout the application.
class Failure {
  /// Creates a [Failure] instance with the provided error [message].
  const Failure(this.message);

  /// The error message describing the failure.
  final String message;

  @override
  String toString() {
    return 'Failure: $message';
  }
}
