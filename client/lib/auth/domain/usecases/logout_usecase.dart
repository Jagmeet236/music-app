import 'package:client/auth/domain/repositories/auth_repository.dart';
import 'package:client/core/usecases/usecase.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:fpdart/fpdart.dart';
/// Use case for logging out the currently authenticated user.
class LogoutUseCase implements UseCaseWithoutParams<void> {
  /// Creates an instance of [LogoutUseCase] with
  /// the provided [AuthRepository].
  const LogoutUseCase(this._authRepository);
  final AuthRepository _authRepository;

  @override
  ResultFuture<void> call() async {
    await _authRepository.logout();
    return const Right(null);
  }
}
