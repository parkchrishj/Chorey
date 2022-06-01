import 'package:choreyprototype0712/components/roundedbutton.dart';
import 'package:choreyprototype0712/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'homepage.dart';
import 'signup.dart';

const darkThemeColor = 0xFF151011;

class LogIn extends StatefulWidget {
  static const String id = 'log_in';
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String passwordTest;
  String emailTest;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
//    return Consumer<UserProvider>(builder: (context, user, child) {
    return Scaffold(
      backgroundColor: Colors.white, //Color(0xFF312d2a),
      appBar: AppBar(
        title: SizedBox(
          child: Image.asset("images/ChoreyIcon.png"),
          width: 100.0,
          height: 100.0,
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Image.asset("images/loginimage.jpg"),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: Color(0xFF312d2a)),
                        child: Container(
                          padding:
                              EdgeInsets.only(top: 40.0, right: 30, left: 30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Welcome,",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Enter your email and password",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 20,
                                  )),
                              SizedBox(
                                height: 25,
                              ),
                              Text(
                                "Email",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
//                                  controller: user.email,
                                onChanged: (value) {
                                  emailTest = value;
                                },
                                decoration: kTextFieldDecoration.copyWith(
                                    hintText: 'Enter your email'),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Text(
                                "Password",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                obscureText: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
//                                  controller: user.password,
                                onChanged: (value) {
                                  passwordTest = value;
                                },
                                decoration: kTextFieldDecoration.copyWith(
                                    hintText: 'Enter your password'),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Forgot Password",
                                      style: TextStyle(
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                error,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 14.0),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RoundedButton(
                                    onPressed: () async {
                                      setState(() {
                                        showSpinner = true;
                                      });
                                      try {
//                                          user.signIn();
                                        final user = await _auth
                                            .signInWithEmailAndPassword(
                                                email: emailTest,
                                                password: passwordTest);
//                                          user.clearController();
                                        if (user != null) {
                                          Navigator.pushNamed(
                                              context, HomePage.id);
                                        }
                                      } catch (e) {
                                        error =
                                            'Could not sign in with those credentials';
                                      }
                                      setState(() {
                                        showSpinner = false;
                                      });
                                    },
                                    colour: Colors.purple,
                                    title: "Log In",
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("I am a new user.",
                                      style: TextStyle(color: Colors.black)),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, SignUp.id);
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
//    });
  }
}
