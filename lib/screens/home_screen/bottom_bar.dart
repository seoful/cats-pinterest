import 'package:cats/components/animated_button.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  BottomBar(
      {required this.icons,
      Key? key,
      this.color = Colors.black,
      this.iconsColor = Colors.white38,
      this.selectedIconColor = Colors.white,
      this.borderRadius = 10,
      required this.onTap})
      : assert(icons.isNotEmpty),
        super(key: key);

  final List<IconData> icons;

  final Color color, iconsColor, selectedIconColor;

  final double borderRadius;

  final Function(int oldIndex, int newIndex) onTap;

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  var _chosenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.borderRadius),
            topRight: Radius.circular(widget.borderRadius)),
        child: Container(
          height: 50,
          padding: const EdgeInsets.all(10),
          color: widget.color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.icons
                .asMap()
                .entries
                .map(
                  (entry) => AnimatedButton(
                    onTap: () {
                      widget.onTap(_chosenIndex, entry.key);
                      setState(
                        () {
                          _chosenIndex = entry.key;
                        },
                      );
                    },
                    child: Icon(
                      entry.value,
                      color: entry.key == _chosenIndex
                          ? widget.selectedIconColor
                          : widget.iconsColor,
                      size: 28,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
