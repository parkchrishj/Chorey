import 'package:choreyprototype0712/components/roundedbutton.dart';
import 'package:choreyprototype0712/components/signupcard.dart';
import 'package:choreyprototype0712/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'homepage.dart';

final _firestore = Firestore.instance;

class SignUp extends StatefulWidget {
  static const String id = 'sign_up';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String name;
  PageController _pageController;
  int pageChanged = 0;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    return Consumer<UserProvider>(builder: (context, user, child) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      pageChanged = index;
                    });
                  },
                  children: <Widget>[
                    SignUpCard(
                      images: "images/neighbors.png",
                      messages:
                          "Hire Friendly Neighbors To Help You Out With House Chores",
                    ),
                    SignUpCard(
                      images: "images/family.png",
                      messages:
                          "Be Able To Spend More Time With Friends And Family",
                    ),
                    SignUpCard(
                      images: "images/happyhome.png",
                      messages: "Stay Happy At Home With Our Services",
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Flexible(
                              child:
                                  Image.asset("images/ChoreyIconwWords.png")),
                          TextField(
                            textAlign: TextAlign.center,
//                              controller: user.name,
                            onChanged: (value) {
                              name = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                hintText: 'New Username'),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.center,
//                              controller: user.email,
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Enter your email'),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          TextField(
                            obscureText: true,
                            textAlign: TextAlign.center,
//                              controller: user.email,
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Enter your password'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Password must be at least 6 characters.'),
                          SizedBox(
                            height: 24.0,
                          ),
                          RoundedButton(
                              title: 'Register',
                              colour: Colors.purpleAccent,
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
//                                    user.signUp();
                                  final newUser = await _auth
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password);
//                                  final newUser = await _auth
//                                      .createUserWithEmailAndPassword(
//                                          email: email.trim(),
//                                          password: password.trim())
//                                      .then((result) {
                                  _firestore
                                      .collection('users')
                                      .document(newUser.user.uid)
                                      .setData({
                                    'name': name,
                                    'email': email,
                                    'uid': newUser.user.uid,
                                    'stripeId': null
//                                    });
                                  });
                                  if (newUser != null) {
                                    Navigator.pushNamed(context, HomePage.id);
                                  }
//                                    user.clearController();
//                                    if (user != null) {
//                                      Navigator.pushNamed(context, HomePage.id);
//                                    }
                                } catch (e) {
                                  print(e);
                                }
                                setState(() {
                                  showSpinner = false;
                                });
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      if (pageChanged <= 0) {
                        Navigator.pop(context);
                      }
                      if (_pageController.hasClients) {
                        _pageController.animateToPage(
                          --pageChanged,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      "Back",
                      style: TextStyle(
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 15.0,
                      inactiveTrackColor: Colors.white,
                      activeTrackColor: Colors.white,
                      thumbColor: Colors.purple,
                      activeTickMarkColor: Colors.purpleAccent,
                      inactiveTickMarkColor: Colors.purpleAccent,
                      tickMarkShape:
                          RoundSliderTickMarkShape(tickMarkRadius: 5.0),
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 10.0),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 10.0),
                    ),
                    child: Slider(
                      value: pageChanged.toDouble(),
                      min: 0,
                      max: 3,
                      onChanged: (newPage) {
                        setState(() {
                          pageChanged = newPage.toInt();
                          if (_pageController.hasClients) {
                            _pageController.animateToPage(
                              pageChanged,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        });
                      },
                      divisions: 3,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      if (pageChanged <= 2) {
                        if (_pageController.hasClients) {
                          _pageController.animateToPage(
                            ++pageChanged,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      }
                    },
                    child: Text(
                      "Next",
                      style: TextStyle(
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
//    });
  }
}
