import 'package:client/auth/model/user_model.dart';
import 'package:client/core/utils/typedef.dart';

/// Defines the contract for remote authentication operations.
abstract class AuthRemoteRepository {
  /// Logs in the user using the provided [email] and [password].
  ///
  /// Throws an exception if authentication fails.
  ResultFuture<UserModel> login({
    required String email,
    required String password,
  });

  /// Signs up a new user with the given [email] and [password].
  ///
  /// Throws an exception if the registration fails.
  ResultFuture<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Retrieves the current user data using the provided [token].
  ResultFuture<UserModel> getCurrentUserData({required String token});
}
