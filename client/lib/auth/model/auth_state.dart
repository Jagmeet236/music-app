import 'package:client/auth/model/auth_action.dart';
import 'package:client/auth/model/user_model.dart';
import 'package:equatable/equatable.dart';

/// Represents the current authentication state of the user.
///
/// This includes the currently authenticated [user], the last
/// [AuthAction] performed (e.g., login, signup), an optional
/// [errorMessage] for failed actions, and a [isLoading] flag
/// to indicate if an operation is in progress.
class AuthState extends Equatable {
  /// Creates a new instance of [AuthState].
  ///
  /// All parameters are optional and default to `null` or `false`.
  const AuthState({
    this.user,
    this.lastAction,
    this.errorMessage,
    this.isLoading = false,
  });

  /// The currently authenticated user, or `null` if no user is logged in.
  final UserModel? user;

  /// The last authentication-related action performed (e.g., login, signup).
  final AuthAction? lastAction;

  /// An error message returned from the last failed action, if any.
  final String? errorMessage;

  /// Indicates whether an authentication operation is currently in progress.
  final bool isLoading;

  /// Creates a copy of the current [AuthState] with updated fields.
  ///
  /// Any non-null parameter will override the corresponding field in
  /// the new instance.
  AuthState copyWith({
    UserModel? user,
    AuthAction? lastAction,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      lastAction: lastAction,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [isLoading, user, errorMessage, lastAction];

  @override
  String toString() {
    return 'AuthState(user: $user, lastAction: $lastAction, errorMessage:'
        ' $errorMessage, isLoading: $isLoading)';
  }
}
