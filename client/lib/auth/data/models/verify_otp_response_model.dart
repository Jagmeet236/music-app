import 'package:client/auth/data/models/user_model.dart';
import 'package:client/core/utils/typedef.dart';

/// This model represents the polymorphic response received
/// after verifying an OTP for different purposes (e.g. signup, reset_password).
class VerifyOtpResponseModel {
  /// Creates a [VerifyOtpResponseModel] instance.
  VerifyOtpResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.resetToken,
    this.user,
    this.accessToken,
  });

  /// Factory constructor to create a [VerifyOtpResponseModel] from a JSON map.
  factory VerifyOtpResponseModel.fromJson(DataMap map) {
    final data = map['data'];

    String? parsedResetToken;
    String? parsedAccessToken;
    UserModel? parsedUser;

    if (data is Map<String, dynamic>) {
      parsedResetToken = data['reset_token'] as String?;
      parsedAccessToken = data['token'] as String?;

      if (data['user'] != null && data['user'] is Map<String, dynamic>) {
        parsedUser = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      }
    }

    return VerifyOtpResponseModel(
      success: map['success'] as bool? ?? false,
      message: map['message'] as String? ?? 'Unknown message',
      data: data,
      resetToken: parsedResetToken,
      user: parsedUser,
      accessToken: parsedAccessToken,
    );
  }

  /// Indicates whether the OTP was verified successfully.
  final bool success;

  /// A message providing additional information about the API result.
  final String message;

  /// The raw polymorphic data payload.
  final dynamic data;

  /// An optional convenience parameter mapped from data['reset_token'].
  final String? resetToken;

  /// An optional parameter mapped from data['token'] (e.g. for signups).
  final String? accessToken;

  /// An optional user model mapped from data['user'] (e.g. for signups).
  final UserModel? user;
}
