import 'package:client/auth/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'current_user_notifier.g.dart';

@Riverpod(keepAlive: true)
/// Holds the currently authenticated user globally across the app.
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  UserModel? build() {
    // Initialize dependencies
    return null;
  }

  /// Sets the current user
  set user(UserModel? newUser) {
    state = newUser;
  }

  /// Gets the current user
  UserModel? get user => state;

  /// Method to clear the current user
  void clearUser() {
    state = null;
  }
}
