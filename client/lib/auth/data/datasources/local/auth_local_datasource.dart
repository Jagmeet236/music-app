import 'package:client/core/utils/typedef.dart';

/// Contract for managing authentication data in local storage.
abstract class AuthLocalDatasource {
  /// Initializes the local storage instance.
  ResultVoid init();

  /// Saves the authentication token locally.
  void setToken(String? token);

  /// Returns the stored authentication token.
  String? getToken();

  /// Removes the stored authentication token.
  void clearToken();

  /// Saves the password reset token locally.
  void setResetToken(String? token);

  /// Returns the stored password reset token.
  String? getResetToken();

  /// Removes the stored password reset token.
  void clearResetToken();
}
