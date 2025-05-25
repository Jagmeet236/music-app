import 'dart:developer';

import 'package:client/auth/repositories/auth_remote_repository_impl.dart';
import 'package:client/auth/view/pages/signup_page.dart';
import 'package:client/auth/view/widgets/auth_gradient_btn.dart';
import 'package:client/auth/view/widgets/custom_text_field.dart';
import 'package:client/core/constants/strings.dart';
import 'package:client/core/extensions/app_context.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/widgets/custom_text_btn.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' show Left, Right;

/// This widget is part of the authentication module and is responsible for
/// rendering the sign-in page of the application.
class SigninPage extends StatefulWidget {
  /// Creates a [SigninPage] widget.
  const SigninPage({super.key});
  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
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
                CustomTextField(controller: emailController, hintText: 'Email'),
                SizedBox(height: context.height * 0.015),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                sizedBox,
                AuthGradientBtn(
                  onTap: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      final res = await AuthRemoteRepositoryImpl().login(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      final val = switch (res) {
                        Left(value: final l) => l,
                        Right(value: final r) => r.toString(),
                      };
                      log('Login response: $val');
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

  void navigateToSignUpPage() {
    Navigator.of(context).push(
      MaterialPageRoute<dynamic>(builder: (context) => const SignupPage()),
    );
  }
}
