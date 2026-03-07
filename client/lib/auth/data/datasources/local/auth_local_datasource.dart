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
}
