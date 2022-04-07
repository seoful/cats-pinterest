import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({Key? key, this.child, this.onTap})
      : assert(child != null),
        super(key: key);

  final Widget? child;
  final void Function()? onTap;

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 50), value: 1);

    _animation =
        Tween<double>(begin: _minScale, end: _maxScale).animate(_controller);
    super.initState();
  }

  final double _minScale = 0.96, _maxScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) widget.onTap!();
      },
      onPanDown: (_) => _animateTo(0),
      onPanStart: (_) => _animateTo(1),
      onPanCancel: () => _animateTo(1),
      onTapUp: (_) => _animateTo(1),
      onTapDown: (_) => _animateTo(0),
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
   _controller.animateTo(target);
  }
}
