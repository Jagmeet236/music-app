import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A utility class for custom page transitions and animations.
///
/// ------------------------------------------------------------
/// ✅ QUICK USAGE
/// ------------------------------------------------------------
///
/// 🔹 Default slide (recommended)
/// ```dart
/// transitionBuilder: AnimationUtil.slide()
/// ```
///
/// 🔹 With bounce + custom intensity
/// ```dart
/// transitionBuilder: AnimationUtil.slide(
///   bounce: true,
///   intensity: 1.2,
///   duration: 400,
/// )
/// ```
///
/// 🔹 Without bounce
/// ```dart
/// transitionBuilder: AnimationUtil.slide(bounce: false)
/// ```
///
/// 🔹 Fade jump
/// ```dart
/// transitionBuilder: AnimationUtil.fadeJumpTransition
/// ```
///
/// ------------------------------------------------------------
/// ⚠️ IMPORTANT
/// ------------------------------------------------------------
/// Always pass a FUNCTION, not a widget
/// ------------------------------------------------------------
class AnimationUtil {
  /// ------------------------------------------------------------
  /// 🔥 Fade + slight scale (premium feel)
  /// ------------------------------------------------------------
  static Widget fadeJumpTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(curved),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
        child: child,
      ),
    );
  }

  /// ------------------------------------------------------------
  /// 🚀 Slide Transition Core (Internal)
  /// ------------------------------------------------------------
  static Widget _slideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child, {
    required bool bounce,
    required double intensity,
  }) {
    final Animation<Offset> positionAnimation;

    if (bounce) {
      /// 🔥 Bounce with intensity control
      positionAnimation = Tween<Offset>(
        begin: Offset(0, 0.2 * intensity),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack, // bounce feel
          reverseCurve: Curves.easeIn,
        ),
      );
    } else {
      /// Smooth slide (no bounce)
      positionAnimation = Tween<Offset>(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ),
      );
    }

    return SlideTransition(
      position: positionAnimation,
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: animation, curve: const Interval(0, 0.85)),
        ),
        child: child,
      ),
    );
  }

  /// ------------------------------------------------------------
  /// 🎯 PUBLIC BUILDER (MAIN API)
  /// ------------------------------------------------------------
  ///
  /// Parameters:
  /// - [bounce] → enable ricochet effect (default: true)
  /// - [intensity] → bounce strength (default: 1.0)
  /// - [duration] → transition duration in ms (default: 350)
  ///
  /// Example:
  /// ```dart
  /// AnimationUtil.slide(
  ///   bounce: true,
  ///   intensity: 1.2,
  ///   duration: 400,
  /// )
  /// ```
  static Widget Function(
    BuildContext,
    Animation<double>,
    Animation<double>,
    Widget,
  )
  slide({bool bounce = true, double intensity = 1.0, int duration = 350}) {
    return (context, animation, secondary, child) {
      return _slideTransition(
        context,
        animation,
        secondary,
        child,
        bounce: bounce,
        intensity: intensity,
      );
    };
  }
}

/// ------------------------------------------------------------
/// 🍏 Custom PageRoute (iOS + Android optimized)
/// ------------------------------------------------------------
class CustomCupertinoPageRoute<T> extends PageRouteBuilder<T> {
  /// Creates a [CustomCupertinoPageRoute] with the given child
  ///  and transition builder.
  CustomCupertinoPageRoute({
    required this.child,
    required this.transitionsBuilderPlay,
    super.settings,
    this.duration = const Duration(milliseconds: 350),
  }) : super(
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final isIos =
               Theme.of(context).platform == TargetPlatform.iOS ||
               Theme.of(context).platform == TargetPlatform.macOS;

           /// 🍏 iOS → native animation
           if (isIos) {
             return CupertinoPageTransition(
               primaryRouteAnimation: animation,
               secondaryRouteAnimation: secondaryAnimation,
               linearTransition: false,
               child: child,
             );
           }

           /// 🤖 Android → custom animation
           return transitionsBuilderPlay(
             context,
             animation,
             secondaryAnimation,
             child,
           );
         },
       );
/// The child widget to be displayed and the duration of the transition.
  final Widget child;
  /// The duration of the transition animation.
  final Duration duration;

  final Widget Function(
    BuildContext,
    Animation<double>,
    Animation<double>,
    Widget,
  )
  /// The custom transition builder function to be used for Android transitions.
  transitionsBuilderPlay;
}
