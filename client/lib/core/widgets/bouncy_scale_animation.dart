import 'package:flutter/material.dart';

/// A reusable widget that scales its child from 0 to its full size
/// with a bouncy/spring effect.
class BouncyScaleAnimation extends StatefulWidget {
  /// Creates a [BouncyScaleAnimation].
  const BouncyScaleAnimation({
    required this.child,
    this.duration = const Duration(milliseconds: 1400),
    this.delay = Duration.zero,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The duration of the scale animation.
  final Duration duration;

  /// An optional delay before starting the animation.
  final Duration delay;

  @override
  State<BouncyScaleAnimation> createState() => _BouncyScaleAnimationState();
}

class _BouncyScaleAnimationState extends State<BouncyScaleAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // Restored the classic bouncy effect
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
