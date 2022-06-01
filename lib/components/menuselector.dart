import 'package:flutter/material.dart';

class MenuSelector extends StatelessWidget {
  MenuSelector(
      {@required this.colour, this.cardChild, this.onPress, this.borderWidth});

  final Color colour;
  final Widget cardChild;
  final Function onPress;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: cardChild,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: borderWidth, color: colour),
          ),
        ),
      ),
    );
  }
}
