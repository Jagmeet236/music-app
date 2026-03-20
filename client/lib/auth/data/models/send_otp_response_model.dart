import 'package:client/core/utils/typedef.dart';
/// This model represents the response received
///  after sending an OTP (One-Time Password).
class SendOtpResponseModel {
  /// Creates a [SendOtpResponseModel] instance.
  SendOtpResponseModel({
    required this.success,
    required this.message,
    this.data,
  });
  /// Factory constructor to create a [SendOtpResponseModel] from a JSON map.
  factory SendOtpResponseModel.fromJson(DataMap map) {
    return SendOtpResponseModel(
      success: map['success'] as bool? ?? false,
      message: map['message'] as String? ?? '',
      data: map['data'],
    );
  }
  /// Indicates whether the OTP was sent successfully.
  final bool success;
  /// A message providing additional information about the OTP sending result.
  final String message;
  /// Additional data related to the OTP sending result, if any.
  final dynamic data;
}
