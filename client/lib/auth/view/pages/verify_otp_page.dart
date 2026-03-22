import 'dart:developer';

import 'package:client/auth/data/models/auth_action.dart';
import 'package:client/auth/view/pages/reset_password_page.dart';
import 'package:client/auth/view/widgets/auth_gradient_btn.dart';
import 'package:client/auth/view/widgets/auth_layout_wrapper.dart';

import 'package:client/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/core/constants/strings.dart';
import 'package:client/core/extensions/app_context.dart';

import 'package:client/core/utils/animation_util.dart';
import 'package:client/core/utils/auth_listener_util.dart';
import 'package:client/core/utils/auth_reset_util.dart';
import 'package:client/core/utils/custom_snack_bar.dart';
import 'package:client/core/utils/navigation_util.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A page where users enter the 6-digit OTP received via email.
class VerifyOtpPage extends ConsumerStatefulWidget {
  /// Creates a [VerifyOtpPage].
  const VerifyOtpPage({super.key});

  @override
  ConsumerState<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends ConsumerState<VerifyOtpPage> {
  final _formKey = GlobalKey<FormState>();

  /// Single controller for OTP (IMPORTANT CHANGE)
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    if (kDebugMode) {
      log('verify_otp_screen disposed');
    }
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    if (_formKey.currentState?.validate() ?? false) {
      final otp = _otpController.text.trim();

      if (otp.length != 6) {
        showSnackBar(context, errPleaseEnterCompleteOtp);
        return;
      }

      final email = ref.read(authEmailProvider);
      final purpose = ref.read(authPurposeProvider);

      if (email == null) {
        showSnackBar(context, errNoEmailContext);
        return;
      }

      ref
          .read(authViewModelProvider.notifier)
          .verifyOtp(email: email, otp: otp, purpose: purpose);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.height;

    final authState = ref.watch(authViewModelProvider);
    final isLoading =
        authState.isLoading && authState.lastAction == AuthAction.verifyOtp;

    // Listen to VERIFY OTP actions
    AuthListenerUtil.listenForVerifyOtp(
      ref,
      context,
      () {
        showSnackBar(context, successOtpVerified);

        final purpose = ref.read(authPurposeProvider);
        if (purpose == purposeResetPassword) {
          NavigationUtil.pushReplacement<dynamic, dynamic>(
            context,
            const ResetPasswordPage(),
            transitionBuilder: AnimationUtil.slide(intensity: 1.5),
          );
        } else {
          clearOtpContext(ref);
          // Navigate to home or whatever else
        }
      },
      onError: (String errorMessage) {
        showSnackBar(context, errorMessage);
      },
    );

    return AuthLayoutWrapper(
      onBack: () {
        clearOtpContext(ref);
        Navigator.pop(context);
      },
      formKey: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            verifyCodeText,
            style: context.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          Text(verifyCodeBodyText, style: context.textTheme.bodyMedium),
          SizedBox(height: screenHeight * 0.04),

          /// 🔥 OTP FIELD (CLEAN + FIXED)
          CustomTextField(
            hintText: hintEnterOtp,
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 8, // 🔥 looks like OTP boxes
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: screenHeight * 0.06),

          if (isLoading)
            const Center(child: Loader())
          else
            AuthGradientBtn(buttonText: verifyOtpBtnText, onTap: _verifyOtp),
        ],
      ),
    );
  }
}
