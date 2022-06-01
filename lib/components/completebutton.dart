import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'neighborstatus.dart';

final _firestore = Firestore.instance;

class CompleteButton extends StatelessWidget {
  final String neighborEmail;
  final Function completion;

  CompleteButton({this.neighborEmail, this.completion});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('demands')
            .where('taken', isEqualTo: true)
            .where('complete', isEqualTo: false)
            .where('neighbor', isEqualTo: neighborEmail)
            .snapshots(),
        builder: (context, snapshot) {
          return NeighborStatus(
            onPressed: completion,
            circleSize: 50.0,
            colour: Colors.orange,
            textColour: Colors.white,
            statusText: "Press if Service is Completed",
            statusTitle: "Service Complete",
          );
        });
  }
}
