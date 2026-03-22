/// enum representing different authentication actions
enum AuthAction {
  /// Action to log in a user
  login,

  /// Action to sign up a new user
  signUp,

  /// Action to log out a user
  logout,

  /// Action to get the current user data
  getCurrentUser,

  /// Action to send an OTP
  sendOtp,

  /// Action to verify an OTP
  verifyOtp,

  /// Action to reset the user's password.
  resetPassword,
}
