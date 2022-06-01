import 'package:flutter/material.dart';

class SignUpCard extends StatelessWidget {
  final String images;
  final String messages;

  SignUpCard({this.images, this.messages});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Image.asset(images),
        ),
        Container(
          padding: EdgeInsets.only(top: 0, right: 20.0, left: 20, bottom: 40),
          child: Text(
            messages,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
