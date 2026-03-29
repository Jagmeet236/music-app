import 'dart:developer';

import 'package:client/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Utility function to clear OTP-related context from providers
void clearOtpContext(WidgetRef ref) {
  log('i am getting called');
  ref.read(authEmailProvider.notifier).state = null;
  ref.read(authPurposeProvider.notifier).state = null;
}
