import 'package:client/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:client/auth/data/datasources/local/auth_local_datasource_impl.dart';
import 'package:client/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:client/auth/data/datasources/remote/auth_remote_datasource_impl.dart';
import 'package:client/auth/data/models/reset_password_response_model.dart';
import 'package:client/auth/data/models/send_otp_response_model.dart';
import 'package:client/auth/data/models/user_model.dart';
import 'package:client/auth/data/models/verify_otp_response_model.dart';
import 'package:client/auth/domain/repositories/auth_repository.dart';
import 'package:client/core/constants/strings.dart';
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
    final result = await _remote.login(email: email, password: password);

    return result.fold(Left.new, (user) async {
      await _local.init();
      _local.setToken(user.token);
      return Right(user);
    });
  }

  // 📝 SIGNUP = Just remote
  @override
  ResultFuture<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return _remote.signUp(name: name, email: email, password: password);
  }

  // 👤 GET CURRENT USER = Local + Remote Combined
  @override
  ResultFuture<UserModel> getCurrentUser() async {
    await _local.init();
    final token = _local.getToken();

    if (token == null) {
      return const Left(AppFailure(errNoTokenFound));
    }

    return _remote.getCurrentUserData(token: token);
  }

  // 🚪 LOGOUT = Local only
  @override
  Future<void> logout() async {
    await _local.init();
    _local.clearToken();
  }

  // ✉️ OTP = Remote only
  @override
  ResultFuture<SendOtpResponseModel> sendOtp({required String email}) {
    return _remote.sendOtp(email: email);
  }

  // ✅ VERIFY OTP = Remote + Local Save (for reset token)
  @override
  ResultFuture<VerifyOtpResponseModel> verifyOtp({
    required String email,
    required String otp,
    required String? purpose,
  }) async {
    final result = await _remote.verifyOtp(
      email: email,
      otp: otp,
      purpose: purpose,
    );

    switch (result) {
      case Left(value: final failure):
        return Left(failure);

      case Right(value: final response):
        // If the purpose is reset_password, securely store the resetToken
        if (purpose == 'reset_password' && response.resetToken != null) {
          await _local.init();
          _local.setResetToken(response.resetToken);
        }
        return Right(response);
    }
  }

  // 🔑 RESET PASSWORD = Local Read + Remote
  @override
  ResultFuture<ResetPasswordResponseModel> resetPassword({
    required String newPassword,
  }) async {
    await _local.init();
    final resetToken = _local.getResetToken();

    if (resetToken == null) {
      return const Left(AppFailure(errResetTokenExpired));
    }

    final result = await _remote.resetPassword(
      resetToken: resetToken,
      newPassword: newPassword,
    );

    return result.fold(Left.new, (response) {
      _local.clearResetToken();
      return Right(response);
    });
  }
}
