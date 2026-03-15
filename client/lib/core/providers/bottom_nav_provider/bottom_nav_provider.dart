import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to manage the bottom navigation index smoothly.
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
