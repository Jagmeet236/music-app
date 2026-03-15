import 'package:client/auth/data/models/user_model.dart';
import 'package:client/core/utils/typedef.dart';
/// Define the contract for remote authentication operations.
abstract class AuthRemoteDatasource {
  /// logs in the user using the provided [email] and [password].
  ResultFuture<UserModel> login({
    required String email,
    required String password,
  });
/// signs up a new user with the given [email] and [password].
  ResultFuture<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });
/// Retrieves the current user data using the provided token.
  ResultFuture<UserModel> getCurrentUserData({
    required String token,
  });
}
