import 'package:client/auth/data/models/user_model.dart';
import 'package:client/auth/domain/repositories/auth_repository.dart';
import 'package:client/core/usecases/usecase.dart';
import 'package:client/core/utils/typedef.dart';

/// Use case for registering a new user.
class SignUpUseCase implements UseCaseWithParams<UserModel, SignUpParams> {
  /// Creates a [SignUpUseCase].
  const SignUpUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  ResultFuture<UserModel> call(SignUpParams params) => _authRepository.signUp(
        name: params.name,
        email: params.email,
        password: params.password,
      );
}

/// Parameters for the generic [SignUpUseCase].
class SignUpParams {
  /// Creates [SignUpParams].
  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });

  /// The name of the user.
  final String name;

  /// The email of the user.
  final String email;

  /// The password of the user.
  final String password;
}
