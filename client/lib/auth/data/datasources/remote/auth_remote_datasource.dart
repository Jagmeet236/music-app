import 'package:client/auth/data/models/reset_password_response_model.dart';
import 'package:client/auth/data/models/send_otp_response_model.dart';
import 'package:client/auth/data/models/user_model.dart';
import 'package:client/auth/data/models/verify_otp_response_model.dart';
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

  /// Sends an OTP to the provided [email].
  ResultFuture<SendOtpResponseModel> sendOtp({
    required String email,
  });

  /// Verifies an OTP with the provided  /// Verifies the OTP sent to the user.
  ResultFuture<VerifyOtpResponseModel> verifyOtp({
    required String email,
    required String otp,
    required String? purpose,
  });

  /// Resets user password given a reset token and new password
  ResultFuture<ResetPasswordResponseModel> resetPassword({
    required String resetToken,
    required String newPassword,
  });
}
