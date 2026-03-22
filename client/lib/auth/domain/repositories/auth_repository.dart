import 'package:client/auth/data/models/reset_password_response_model.dart';
import 'package:client/auth/data/models/send_otp_response_model.dart';
import 'package:client/auth/data/models/user_model.dart';
import 'package:client/auth/data/models/verify_otp_response_model.dart';
import 'package:client/core/utils/typedef.dart';

/// Defines the contract for remote authentication operations.
abstract class AuthRepository {
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

  /// Retrieves the current user data using the provided
  ResultFuture<UserModel> getCurrentUser();

  /// log out the user and  clear any store user data
  Future<void> logout();

  /// Sends an OTP to the provided [email].
  ResultFuture<SendOtpResponseModel> sendOtp({
    required String email,
  });

  /// Verifies an OTP based on [email], [otp], and [purpose].
  ResultFuture<VerifyOtpResponseModel> verifyOtp({
    required String email,
    required String otp,
    required String? purpose,
  });

  /// Resets the user's password using the newly provided [newPassword].
  ResultFuture<ResetPasswordResponseModel> resetPassword({
    required String newPassword,
  });
}
