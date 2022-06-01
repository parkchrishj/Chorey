import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'screens/getstarted.dart';
import 'screens/homepage.dart';
import 'screens/neighborpage.dart';

class UserManagement {
  static const id = "user_management";
  Widget handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          Scaffold(
            body: Center(
              child: SpinKitWave(
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.red : Colors.green,
                    ),
                  );
                },
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          return HomePage();
        }
        return GetStarted();
      },
    );
  }

  authorizeAccess(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('/neighbors')
          .where('email', isEqualTo: user.email)
          .getDocuments()
          .then((docs) {
        if (docs.documents[0].exists) {
          if (docs.documents[0].data['role'] == 'neighbor') {
            Navigator.pushReplacementNamed(context, NeighborPage.id);
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Become a Neighbor"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Become a Neighbor and help other'),
                      Text('neighbors with chores through Chorey'),
                      Text('The sign up will be available in the Future.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Got it!'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
            ;
          }
        }
      });
    });
  }
}
