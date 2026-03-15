/// A utility class that holds static references to media asset paths
/// (e.g., images).
class MediaRes {
  MediaRes._(); // Prevent instantiation

  /// Base directory for all image assets.
  static const String _baseUrl = 'assets/images';

  /// Image asset: connect-device.png
  static const String connectDevice = '$_baseUrl/connect-device.png';

  /// Image asset: home_filled.png';
  static const String homeFilled = '$_baseUrl/home_filled.png';

  /// Image asset: home_filled.png';
  static const String homeUnfilled = '$_baseUrl/home_unfilled.png';

  /// Image asset: home_filled.png';
  static const String library = '$_baseUrl/library.png';

  /// Image asset: playlist.png';
  static const String playlist = '$_baseUrl/playlist.png';

  /// Image asset: playlist.png';
  static const String shuffle = '$_baseUrl/shuffle.png';

  /// Image asset: previous-song.png';
  static const String previousSong = '$_baseUrl/previous-song.png';

  /// Image asset: next-song.png';
  static const String nextSong = '$_baseUrl/next-song.png';

  /// Image asset: next-song.png';
  static const String repeat = '$_baseUrl/repeat.png';

  /// Image asset: pull-down-arrow.png';
  static const String pullDownArrow = '$_baseUrl/pull-down-arrow.png';

  /// Image asset: app_logo.png';
  static const String appLogo = '$_baseUrl/app_logo.png';

  /// Image asset: logOut.png';
  static const String logOut = '$_baseUrl/log_out_logo.png';
}
