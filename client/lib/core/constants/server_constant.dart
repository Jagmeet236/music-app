import 'dart:io';

import 'package:client/core/constants/strings.dart';

/// A class that holds server-related constants.
class ServerConstant {
  /// The base URL for the Android server.
  static String serverUrl =
      Platform.isAndroid
          ? kAndroid
          : kIOS; // Replace with your actual server URL

  // Add more constants as needed
}
