import 'package:flutter/material.dart';

class NeighborStatus extends StatelessWidget {
  final Color colour;
  final Function onPressed;
  final String statusTitle;
  final String statusText;
  final Color textColour;
  final double circleSize;

  NeighborStatus({
    this.colour,
    this.onPressed,
    this.statusTitle,
    this.statusText,
    this.textColour,
    this.circleSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 5.0,
            color: colour,
            borderRadius: BorderRadius.circular(circleSize / 2.0),
            child: MaterialButton(
              onPressed: onPressed,
              minWidth: circleSize,
              height: circleSize,
              child: Text(
                statusTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 24.0,
        ),
        Text(
          statusText,
          style: (TextStyle(
            color: textColour,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          )),
        ),
      ],
    );
  }
}
