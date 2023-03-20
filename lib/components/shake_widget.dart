import 'package:flutter/material.dart';

class ShakeController {
  final AnimationController _controller;

  ShakeController({required TickerProvider vsync})
      : _controller = AnimationController(
            vsync: vsync, duration: const Duration(milliseconds: 500));

  void shake(bool isShaking) {
    if (isShaking) {
      _controller.forward(from: 0.0);
    } else {
      _controller.reverse(from: 1.0);
    }
  }

  void dispose() {
    _controller.dispose();
  }
}

class ShakeWidget extends StatefulWidget {
  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;
  final ShakeController? controller;

  const ShakeWidget({
    Key? key,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.bounceOut,
    required this.child,
    this.controller,
  }) : super(key: key);

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  /// convert 0-1 to 0-1-0
  double shake(double animation) =>
      2 * (0.5 - (0.5 - widget.curve.transform(animation)).abs());

  @override
  Widget build(BuildContext context) {
    final animationController = widget.controller?._controller ??
        AnimationController(vsync: this, duration: widget.duration);
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) => Transform.translate(
        offset: Offset(widget.deltaX * shake(animationController.value), 0),
        child: child,
      ),
      child: widget.child,
    );
  }
}
