import 'package:client/auth/data/models/send_otp_response_model.dart';
import 'package:client/auth/domain/repositories/auth_repository.dart';
import 'package:client/core/usecases/usecase.dart';
import 'package:client/core/utils/typedef.dart';

/// Use case for sending an OTP to the user's email.
class SendOtpUseCase
    implements UseCaseWithParams<SendOtpResponseModel, SendOtpParams> {
  /// Creates a [SendOtpUseCase].
  const SendOtpUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  ResultFuture<SendOtpResponseModel> call(SendOtpParams params) =>
      _authRepository.sendOtp(email: params.email);
}

/// Parameters for [SendOtpUseCase].
class SendOtpParams {
  /// Creates [SendOtpParams].
  const SendOtpParams({required this.email});

  /// The email address to send the OTP to.
  final String email;
}
