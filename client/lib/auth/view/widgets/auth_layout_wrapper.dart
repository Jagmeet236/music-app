import 'package:client/core/extensions/app_context.dart';
import 'package:client/core/utils/media_res.dart';
import 'package:client/core/widgets/bouncy_scale_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A reusable wrapper that provides the Scaffold, SafeArea,
/// back button, and app logo for auth pages.
class AuthLayoutWrapper extends StatelessWidget {
  /// Creates an [AuthLayoutWrapper] widget.
  const AuthLayoutWrapper({
    required this.child,
    this.onBack,
    this.formKey,
    super.key,
  });

  /// The main content of the authentication page snippet.
  final Widget child;

  /// Optional custom callback invoked when the back button is pressed.
  final VoidCallback? onBack;

  /// Optional form key if the content has a form.
  final GlobalKey<FormState>? formKey;

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.height;

    Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.03),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          alignment: Alignment.centerLeft,
          onPressed: () {
            if (onBack != null) {
              onBack!();
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(CupertinoIcons.back),
        ),
        SizedBox(height: screenHeight * 0.02),
        BouncyScaleAnimation(
          child: Image.asset(
            MediaRes.appLogo,
            height: screenHeight * 0.25,
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
        child,
      ],
    );

    if (formKey != null) {
      body = Form(key: formKey, child: body);
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: onBack == null,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          if (onBack != null) {
            onBack!();
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}
