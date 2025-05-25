import 'package:client/core/utils/typedef.dart';

/// Defines the contract for remote authentication operations.
abstract class AuthRemoteRepository {
  /// Logs in the user using the provided [email] and [password].
  ///
  /// Throws an exception if authentication fails.
  Future<void> login({required String email, required String password});

  /// Signs up a new user with the given [email] and [password].
  ///
  /// Throws an exception if the registration fails.
  ResultFuture<DataMap> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Signs out the currently logged-in user.
  ///
  /// Should clear any session or token.
  // Future<void> signOut();

  /// Sends a password reset email to the given [email].
  ///
  /// Throws an exception if the process fails.
  // Future<void> resetPassword({required String email});
}
