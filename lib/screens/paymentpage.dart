import 'package:choreyprototype0712/components/roundedbutton.dart';
import 'package:choreyprototype0712/components/serviceslist.dart';
import 'package:choreyprototype0712/models/servicesdata.dart';
import 'package:choreyprototype0712/services/stripe_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
enum purchaseButton {
  confirm,
  cancel,
}

class PaymentPage extends StatefulWidget {
  static const String id = "payment_page";
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _auth = FirebaseAuth.instance;
  String message = "";
  purchaseButton buttonSwitch = purchaseButton.confirm;
  String orderID = "";

  @override
  void initState() {
    super.initState();

    getCurrentUser();
    StripeService.init();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  onItemPress(BuildContext context, int index, String price,
      ServicesData servicesData) async {
    switch (index) {
      case 0:
        payViaNewCard(context, price, servicesData);
        break;
//      case 1:
//        Navigator.pushNamed(context, '/existing-cards');
//        break;
    }
  }

  payViaNewCard(
      BuildContext context, String amount, ServicesData servicesData) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        amount: amount, currency: 'USD', email: loggedInUser.email);
    if (response.success) {
      _firestore.collection('orders').add({
        'email': loggedInUser.email,
        'services': servicesData.listOfDemands,
        'taken': false,
        'complete': false,
        'neighbor': "TBD",
      }).then((value) => orderID = value.documentID.toString());
      _firestore.collection('demands').document(loggedInUser.uid).setData({
        'email': loggedInUser.email,
        'services': servicesData.listOfDemands,
        'taken': false,
        'complete': false,
        'neighbor': "TBD",
        'orderid': orderID,
      });
      setState(() {
        buttonSwitch = purchaseButton.cancel;
        message =
            "Looking for a Neighbor to assist you with requested services. Please wait.";
      });
    }
    await dialog.hide();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesData>(
      builder: (context, servicesData, child) {
        return StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('demands')
                .where('email', isEqualTo: loggedInUser.email)
                .where('taken', isEqualTo: true)
                .where('complete', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
//              if (_firestore
//                  .collection('cards')
//                  .where().getDocuments());
              //  i need to get the user's card information.
              if (snapshot.data.documents.length > 0) {
                return Scaffold(
                    body: Center(
                  child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Your Neighbor has accepted your request and is on the way to assist you with the house chores. Click on the text to continue to chat. Thank you!",
                        style: TextStyle(fontSize: 25.0),
                      )),
                ));
              }
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  leading: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () async {
                        _firestore
                            .collection('demands')
                            .document(loggedInUser.uid)
                            .updateData({'complete': true});
                        _firestore
                            .collection('orders')
                            .document(orderID)
                            .updateData({'complete': true});
                        Navigator.pop(context);
                      }),
                ),
                body: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: ServicesList(null),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Text(
                          "Service only available around Clarksville, TN area from 7 A.M. to 9:30 P.M.*",
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: buttonSwitch == purchaseButton.confirm,
                      child: Container(
                        child: RoundedButton(
                          onPressed: () async {
                            onItemPress(context, 0, '1500', servicesData);
//                            _firestore
//                                .collection('demands')
//                                .document(loggedInUser.uid)
//                                .setData({
//                              'email': loggedInUser.email,
//                              'services': servicesData.listOfDemands,
//                              'taken': false,
//                              'complete': false,
//                              'neighbor': "TBD",
//                            });
//                            _firestore.collection('demands').add({
//                              'email': loggedInUser.email,
//                              'services': servicesData.listOfDemands,
//                              'taken': false,
//                              'complete': false,
//                              'neighbor': "TBD",
//                            });
//                            setState(() {
//                              buttonSwitch = purchaseButton.cancel;
//                              message =
//                                  "Looking for a Neighbor to assist you with requested services. Please wait.";
//                            });
                          },
                          colour: Colors.purple,
                          title: "payment confirm",
                        ),
                      ),
                      replacement: Container(
                        child: RoundedButton(
                          onPressed: () async {
                            _firestore
                                .collection('demands')
                                .document(loggedInUser.uid)
                                .updateData({'complete': true});
                            _firestore
                                .collection('orders')
                                .document(orderID)
                                .updateData({'complete': true});
                            setState(() {
                              buttonSwitch = purchaseButton.confirm;
                              message = "";
                            });
                          },
                          colour: Colors.purpleAccent,
                          title: "Cancel order",
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 10.0),
                        child: Column(
                          children: <Widget>[
                            Visibility(
                              visible: buttonSwitch == purchaseButton.cancel,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.lightBlueAccent,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              message,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ],
                ),
              );
            });
      },
    );
  }
}
