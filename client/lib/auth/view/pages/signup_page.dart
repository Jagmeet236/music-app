import 'package:client/auth/model/auth_action.dart';
import 'package:client/auth/view/pages/signin_page.dart';
import 'package:client/auth/view/widgets/auth_gradient_btn.dart';
import 'package:client/auth/view/widgets/custom_text_field.dart';
import 'package:client/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/core/constants/strings.dart';
import 'package:client/core/extensions/app_context.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils/auth_listener_util.dart';
import 'package:client/core/utils/custom_snack_bar.dart';
import 'package:client/core/widgets/custom_text_btn.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///  for the signing up the new user
class SignupPage extends ConsumerStatefulWidget {
  /// Creates a [SignupPage] widget.
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the auth state for loading
    final authState = ref.watch(authViewModelProvider);
    final isLoading =
        authState.isLoading && authState.lastAction == AuthAction.signUp;

    debugPrint(
      'SignupPage state: $isLoading, lastAction: ${authState.lastAction}',
    );

    // Listen only to SIGNUP actions
    AuthListenerUtil.listenForSignUp(
      ref,
      context,
      navigateToSignInPage,
      onError: () {
        showSnackBar(
          context,
          authState.errorMessage ?? 'An error occurred during signup',
        );
        debugPrint('Signup failed');
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
                  signUp,
                  style: context.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                sizedBox,
                CustomTextField(controller: nameController, hintText: 'Name'),
                SizedBox(height: context.height * 0.015),
                CustomTextField(controller: emailController, hintText: 'Email'),
                SizedBox(height: context.height * 0.015),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
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
                            .signUp(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                            );
                      } else {
                        showSnackBar(context, 'Please fill in all fields');
                      }
                    },
                    buttonText: textSignUp,
                  ),
                sizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      alreadyHaveAnAccount,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    CustomTextBtn(
                      text: textSignIn,
                      textColor: Palette.gradient2,
                      onTap: navigateToSignInPage,
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

  void navigateToSignInPage() {
    Navigator.of(context).push(
      MaterialPageRoute<dynamic>(builder: (context) => const SigninPage()),
    );
  }
}
