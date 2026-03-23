import 'package:client/core/constants/strings.dart';
import 'package:client/core/utils/typedef.dart';

/// The response model for the reset password API.
class ResetPasswordResponseModel {
  /// Creates a [ResetPasswordResponseModel].
  const ResetPasswordResponseModel({
    required this.success,
    required this.message,
  });

  /// Factory constructor to create an instance from JSON data.
  factory ResetPasswordResponseModel.fromJson(DataMap json) {
    return ResetPasswordResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? errUnknownError,
    );
  }

  /// Indicates if the password reset was successful.
  final bool success;

  /// The response message from the server.
  final String message;
}
