import 'package:client/auth/data/models/reset_password_response_model.dart';
import 'package:client/auth/domain/repositories/auth_repository.dart';
import 'package:client/core/usecases/usecase.dart';
import 'package:client/core/utils/typedef.dart';

/// Use case for resetting a user's password.
class ResetPasswordUseCase implements UseCaseWithParams<
ResetPasswordResponseModel, ResetPasswordParams> {
  /// Creates a [ResetPasswordUseCase].
  const ResetPasswordUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  ResultFuture<ResetPasswordResponseModel> 
  call(ResetPasswordParams params) => _authRepository.resetPassword(
        newPassword: params.newPassword,
      );
}

/// Parameters for [ResetPasswordUseCase].
class ResetPasswordParams {
  /// Creates [ResetPasswordParams].
  const ResetPasswordParams({
    required this.newPassword,
  });

  /// The non-empty new password.
  final String newPassword;
}
