import 'package:client/auth/data/models/user_model.dart';
import 'package:client/auth/domain/repositories/auth_repository.dart';
import 'package:client/core/usecases/usecase.dart';
import 'package:client/core/utils/typedef.dart';

/// Use case for logging in a user.
class LoginUseCase implements UseCaseWithParams<UserModel, LoginParams> {
  /// Creates a [LoginUseCase].
  const LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  ResultFuture<UserModel> call(LoginParams params) => _authRepository.login(
        email: params.email,
        password: params.password,
      );
}

/// Parameters for the generic [LoginUseCase].
class LoginParams {
  /// Creates [LoginParams].
  const LoginParams({
    required this.email,
    required this.password,
  });

  /// The email of the user.
  final String email;

  /// The password of the user.
  final String password;
}
