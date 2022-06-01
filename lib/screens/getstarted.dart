import 'package:choreyprototype0712/components/roundedbutton.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'signup.dart';

class GetStarted extends StatefulWidget {
  static const String id = 'get_started';
  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  double pageNumber = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(children: <Widget>[
          Expanded(
            child: Image.asset(
              "images/ChoreyIconwWords.png",
              //height: 500.0,
              scale: 0.75,
            ),
          ),
          RoundedButton(
            onPressed: () {
              Navigator.pushNamed(context, SignUp.id);
            },
            colour: Colors.purple,
            title: "Get Started",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Already have an account?"),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, LogIn.id);
                },
                child: Text(
                  "Log in",
                  style: TextStyle(
                    color: Colors.purpleAccent,
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
