import 'package:client/auth/data/models/auth_action.dart';
import 'package:client/auth/presentation/pages/forgot_password_page.dart';
import 'package:client/auth/presentation/pages/signup_page.dart';
import 'package:client/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:client/auth/presentation/widgets/auth_gradient_btn.dart';
import 'package:client/core/constants/strings.dart';
import 'package:client/core/extensions/app_context.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils/animation_util.dart';
import 'package:client/core/utils/auth_listener_util.dart';
import 'package:client/core/utils/custom_snack_bar.dart';
import 'package:client/core/utils/navigation_util.dart';
import 'package:client/core/widgets/custom_text_btn.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This widget is part of the authentication module and is responsible for
/// rendering the sign-in page of the application.
class SigninPage extends ConsumerStatefulWidget {
  /// Creates a [SigninPage] widget.
  const SigninPage({super.key});
  @override
  ConsumerState<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the auth state for loading
    final authState = ref.watch(authViewModelProvider);
    final isLoading =
        authState.isLoading && authState.lastAction == AuthAction.login;

    debugPrint(
      'SignupPage state: $isLoading, lastAction: ${authState.lastAction}',
    );

    // Listen only to LOGIN actions
    AuthListenerUtil.listenForLogin(
      ref,
      context,
      navigateToHomePage,
      onError: (errorMessage) {
        debugPrint('Login failed: $errorMessage');
      },
    );

    final sizedBox = SizedBox(height: context.height * 0.02);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  signIn,
                  style: context.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                sizedBox,
                CustomTextField(
                  controller: emailController,
                  hintText: emailHint,
                ),
                SizedBox(height: context.height * 0.015),
                CustomTextField(
                  controller: passwordController,
                  hintText: passwordHint,
                  isPassword: true,
                ),
                SizedBox(height: context.height * 0.015),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextBtn(
                    text: forgotPasswordQuestion,
                    onTap: navigateToForgotPasswordPage,
                  ),
                ),
                sizedBox,
                if (isLoading)
                  const Loader()
                else
                  AuthGradientBtn(
                    onTap: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        await ref
                            .read(authViewModelProvider.notifier)
                            .login(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                      } else {
                        showSnackBar(context, errPleaseFillAllFields);
                      }
                    },
                    buttonText: textSignIn,
                  ),
                sizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dontHaveAnAccount,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    CustomTextBtn(
                      text: textSignUp,
                      textColor: Palette.gradient2,
                      onTap: navigateToSignUpPage,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateToForgotPasswordPage() {
    NavigationUtil.push<dynamic>(
      context,
      const ForgotPasswordPage(),
      transitionBuilder: AnimationUtil.slide(intensity: 1.5),
    );
  }

  void navigateToSignUpPage() {
    NavigationUtil.pushReplacement<dynamic, dynamic>(
      context,
      const SignupPage(),
      transitionBuilder: AnimationUtil.slide(intensity: 1.5),
    );
  }

  void navigateToHomePage() {
    NavigationUtil.pushAndRemoveUntil<dynamic>(
      context,
      const HomePage(),
      transitionBuilder: AnimationUtil.slide(bounce: false),
    );
  }
}
