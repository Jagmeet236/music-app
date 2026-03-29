import 'package:client/auth/data/models/user_model.dart';
import 'package:client/auth/domain/repositories/auth_repository.dart';
import 'package:client/core/usecases/usecase.dart';
import 'package:client/core/utils/typedef.dart';

/// Use case for fetching the currently authenticated user.
class GetCurrentUserUseCase implements UseCaseWithoutParams<UserModel> {

  /// Creates an instance of [GetCurrentUserUseCase] with
  /// the provided [AuthRepository].
  const GetCurrentUserUseCase(this._authRepository);
  final AuthRepository _authRepository;

  @override
  ResultFuture<UserModel> call() => _authRepository.getCurrentUser();
}
