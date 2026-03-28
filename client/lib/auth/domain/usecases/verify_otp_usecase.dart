import 'package:client/auth/data/models/verify_otp_response_model.dart';
import 'package:client/auth/domain/repositories/auth_repository.dart';
import 'package:client/core/usecases/usecase.dart';
import 'package:client/core/utils/typedef.dart';

/// Use case for verifying the OTP sent to the user.
class VerifyOtpUseCase
    implements UseCaseWithParams<VerifyOtpResponseModel, VerifyOtpParams> {
  /// Creates a [VerifyOtpUseCase].
  const VerifyOtpUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  ResultFuture<VerifyOtpResponseModel> call(VerifyOtpParams params) =>
      _authRepository.verifyOtp(
        email: params.email,
        otp: params.otp,
        purpose: params.purpose,
      );
}

/// Parameters for [VerifyOtpUseCase].
class VerifyOtpParams {
  /// Creates [VerifyOtpParams].
  const VerifyOtpParams({required this.email, required this.otp, this.purpose});

  /// The email address of the user.
  final String email;

  /// The OTP to verify.
  final String otp;

  /// The optional purpose of the OTP verification.
  final String? purpose;
}
