import 'package:client/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:client/auth/data/datasources/local/auth_local_datasource_impl.dart';

import 'package:client/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:client/auth/data/datasources/remote/auth_remote_datasource_impl.dart';
import 'package:client/auth/data/models/user_model.dart';
import 'package:client/auth/domain/repositories/auth_repository.dart';
import 'package:client/core/error/failure.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_impl.g.dart';
/// Provider an instance of [AuthRepositoryImpl] that combines both
/// remote and local data sources to manage authentication operations.
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final remote = ref.watch(authRemoteDatasourceProvider);
  final local = ref.watch(authLocalDatasourceProvider);

  return AuthRepositoryImpl(remote, local);
}
/// concrete implemetation of [AuthRepository] that orchestrates
///  authentication logic
class AuthRepositoryImpl implements AuthRepository {
  /// creates an instance of [AuthRepositoryImpl] with the provided
  AuthRepositoryImpl(this._remote, this._local);

  final AuthRemoteDatasource _remote;
  final AuthLocalDatasource _local;

  // 🔐 LOGIN = Remote + Local Combined
  @override
  ResultFuture<UserModel> login({
    required String email,
    required String password,
  }) async {
    final result = await _remote.login(
      email: email,
      password: password,
    );

    return result.fold(
      Left.new,
      (user) async {
        await _local.init();
        _local.setToken(user.token);
        return Right(user);
      },
    );
  }

  // 📝 SIGNUP = Just remote
  @override
  ResultFuture<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return _remote.signUp(
      name: name,
      email: email,
      password: password,
    );
  }

  // 👤 GET CURRENT USER = Local + Remote Combined
  @override
  ResultFuture<UserModel> getCurrentUser() async {
    await _local.init();
    final token = _local.getToken();

    if (token == null) {
      return const Left(AppFailure('No token found'));
    }

    return _remote.getCurrentUserData(token: token);
  }

  // 🚪 LOGOUT = Local only
  @override
  Future<void> logout() async {
    await _local.init();
    _local.clearToken();
  }
}
