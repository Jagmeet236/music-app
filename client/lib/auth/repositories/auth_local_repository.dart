import 'package:client/core/utils/typedef.dart';

/// Repository for managing local authentication data.
abstract class AuthLocalRepository {
  /// Initializes the local repository, typically setting up shared preferences.
  ResultVoid init();

  /// Saves the user token to local storage.
  void setToken(String? token);

  /// Retrieves the user token from local storage.
  String? getToken();
}
