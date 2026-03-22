import 'package:client/auth/data/models/auth_action.dart';
import 'package:client/auth/view/pages/verify_otp_page.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A page for users to reset their password when they forget it.
class ForgotPasswordPage extends ConsumerStatefulWidget {
  /// Creates a [ForgotPasswordPage] widget.
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => ForgotPasswordPageState();
}

/// The state class for the [ForgotPasswordPage] widget,
class ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  /// Controller for the email input field.
  final emailController = TextEditingController();

  /// A key to identify the form and validate its fields.
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    clearOtpContext(ref);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final isLoading =
        authState.isLoading && authState.lastAction == AuthAction.sendOtp;

    // Listen to SEND OTP actions
    AuthListenerUtil.listenForSendOtp(
      ref,
      context,
      navigateToVerifyOtpPage,
      onError: (errorMessage) {
        debugPrint('Send OTP failed: $errorMessage');
      },
    );

    final screenHeight = context.height;

    return AuthLayoutWrapper(
      onBack: () {
        clearOtpContext(ref);
        Navigator.pop(context);
      },
      formKey: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            forgotPasswordHeading,
            style: context.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          Text(
            forgotPasswordBodyText,
            style: context.textTheme.bodyMedium,
          ),
          SizedBox(height: screenHeight * 0.04),
          CustomTextField(
            controller: emailController,
            hintText: emailHint,
          ),
          SizedBox(height: screenHeight * 0.04),
          if (isLoading)
            const Center(child: Loader())
          else
            AuthGradientBtn(
              buttonText: sendVerificationCode,
              onTap: () {
                if (formKey.currentState?.validate() ?? false) {
                  ref.read(authPurposeProvider.notifier).state = null;
                  final email = emailController.text;

                  // Save strict loosely coupled context
                  ref.read(authEmailProvider.notifier).state = email;
                  ref.read(authPurposeProvider.notifier).state =
                      purposeResetPassword;

                  ref
                      .read(authViewModelProvider.notifier)
                      .sendOtp(email: email);
                } else {
                  showSnackBar(context, errPleaseEnterEmail);
                }
              },
            ),
        ],
      ),
    );
  }

  /// Navigates to the [VerifyOtpPage] when the OTP is successfully sent.
  void navigateToVerifyOtpPage() {
    NavigationUtil.push<dynamic>(
      context,
      const VerifyOtpPage(),
      transitionBuilder: AnimationUtil.slide(intensity: 1.5),
    );
  }
}
