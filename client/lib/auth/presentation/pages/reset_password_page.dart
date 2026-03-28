import 'package:client/auth/data/models/auth_action.dart';
import 'package:client/auth/presentation/pages/signin_page.dart';
import 'package:client/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:client/auth/presentation/widgets/auth_gradient_btn.dart';
import 'package:client/auth/presentation/widgets/auth_layout_wrapper.dart';
import 'package:client/core/constants/strings.dart';
import 'package:client/core/extensions/app_context.dart';
import 'package:client/core/utils/auth_reset_util.dart';
import 'package:client/core/utils/custom_snack_bar.dart';
import 'package:client/core/utils/navigation_util.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A page that allows users to set a new password after verifying OTP.
class ResetPasswordPage extends ConsumerStatefulWidget {
  /// Creates a [ResetPasswordPage].
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        showSnackBar(context, errPasswordsDoNotMatch);
        return;
      }
      ref
          .read(authViewModelProvider.notifier)
          .resetPassword(newPassword: _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.height;
    final authState = ref.watch(authViewModelProvider);
    final isLoading =
        authState.isLoading && authState.lastAction == AuthAction.resetPassword;

    // Listen for reset password success or failure
    ref.listen(authViewModelProvider, (previous, next) {
      if ((previous?.isLoading ?? false) &&
          !next.isLoading &&
          next.lastAction == AuthAction.resetPassword) {
        if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
          showSnackBar(context, next.errorMessage!);
        } else {
          showSnackBar(context, successPasswordReset);
          clearOtpContext(ref);
          NavigationUtil.pushAndRemoveUntil<dynamic>(
            context,
            const SigninPage(),
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          );
        }
      }
    });

    return AuthLayoutWrapper(
      formKey: _formKey,
      onBack: () {
        clearOtpContext(ref);
        Navigator.pop(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resetPasswordHeading,
            style: context.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          Text(
            resetPasswordBodyText,
            style: context.textTheme.bodyMedium,
          ),
          SizedBox(height: screenHeight * 0.04),
          CustomTextField(
            controller: _passwordController,
            hintText: newPasswordText,
            isPassword: true,
          ),
          SizedBox(height: screenHeight * 0.015),
          CustomTextField(
            controller: _confirmPasswordController,
            hintText: confirmPasswordHint,
            isPassword: true,
          ),
          SizedBox(height: screenHeight * 0.04),
          if (isLoading)
            const Center(child: Loader())
          else
            AuthGradientBtn(
              buttonText: resetPasswordBtnText,
              onTap: _resetPassword,
            ),
        ],
      ),
    );
  }
}
