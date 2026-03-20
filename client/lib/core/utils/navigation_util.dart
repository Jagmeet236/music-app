import 'package:client/core/utils/animation_util.dart';
import 'package:flutter/material.dart';

/// A custom page route that allows for flexible transition animations.
class NavigationUtil {
  /// Push
  static Future<T?> push<T>(
    BuildContext context,
    Widget page, {
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transitionBuilder,
  }) {
    return Navigator.of(context).push(_buildRoute(page, transitionBuilder));
  }

  /// Push Replacement
  static Future<T?> pushReplacement<T, TO>(
    BuildContext context,
    Widget page, {
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transitionBuilder,
    TO? result,
  }) {
    return Navigator.of(
      context,
    ).pushReplacement(_buildRoute(page, transitionBuilder), result: result);
  }

  /// Push and Remove Until
  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    Widget page, {
    bool Function(Route<dynamic>)? predicate,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transitionBuilder,
  }) {
    return Navigator.of(context).pushAndRemoveUntil(
      _buildRoute(page, transitionBuilder),
      predicate ?? (route) => false,
    );
  }

  /// Pop
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }

  /// Internal route builder
  static Route<T> _buildRoute<T>(
    Widget page,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transitionBuilder,
  ) {
    if (transitionBuilder != null) {
      return CustomCupertinoPageRoute<T>(
        child: page,
        transitionsBuilderPlay: transitionBuilder,
      );
    }

    return MaterialPageRoute<T>(builder: (_) => page);
  }
}
