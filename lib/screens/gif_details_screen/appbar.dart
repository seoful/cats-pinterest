import 'package:cats/components/animated_button.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar(
      {Key? key,
        this.buttonsInCircles = false,
        required this.onBackPressed,
        required this.onClosePressed})
      : assert(onClosePressed != null),
        assert(onClosePressed != null),
        super(key: key);

  final bool buttonsInCircles;

  final Function()? onBackPressed, onClosePressed;

  final _duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedButton(
          onTap: onBackPressed,
          child: AnimatedContainer(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: buttonsInCircles ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: buttonsInCircles ? Colors.black54 : Colors.white,
            ),
            duration: _duration,
            curve: Curves.linear,
          ),
        ),
        AnimatedButton(
          onTap: onClosePressed,
          child: AnimatedContainer(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: buttonsInCircles ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close_rounded,
              color: buttonsInCircles ? Colors.black54 : Colors.white,
            ),
            duration: _duration,
            curve: Curves.linear,
          ),
        )
      ],
    );
  }
}
