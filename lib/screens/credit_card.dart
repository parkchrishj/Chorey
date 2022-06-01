import 'package:choreyprototype0712/models/userdata.dart';
import 'package:choreyprototype0712/services/stripe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';

FirebaseUser loggedInUser;
final _firestore = Firestore.instance;

class CreditCard extends StatefulWidget {
  CreditCard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('cards')
            .where('userid', isEqualTo: loggedInUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: <Widget>[
                    CreditCardWidget(
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      showBackView:
                          isCvvFocused, //true when you want to show cvv(back) view
                    ),
                    CreditCardForm(
                      themeColor: Colors.red,
                      onCreditCardModelChange: (CreditCardModel data) {
                        setState(() {
                          cardNumber = data.cardNumber;
                          expiryDate = data.expiryDate;
                          cardHolderName = data.cardHolderName;
                          cvvCode = data.cvvCode;
                          isCvvFocused = data.isCvvFocused;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                int cvc = int.tryParse(cvvCode);
                int carNo = int.tryParse(
                    cardNumber.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
                int exp_year = int.tryParse(expiryDate.substring(3, 5));
                int exp_month = int.tryParse(expiryDate.substring(0, 2));

                print("cvc num: ${cvc.toString()}");
                print("card num: ${carNo.toString()}");
                print("exp year: ${exp_year.toString()}");
                print("exp month: ${exp_month.toString()}");
                print(cardNumber.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
//
                StripeServices stripeServices = StripeServices();
                if (snapshot.data.documents.length == 0) {
                  String stripeID = await stripeServices.createStripeCustomer(
                      email: loggedInUser.email, userId: loggedInUser.uid);
                  print("stripe id: $stripeID");
                  print("stripe id: $stripeID");
                  print("stripe id: $stripeID");
                  print("stripe id: $stripeID");

                  stripeServices.addCard(
                      stripeId: stripeID,
                      month: exp_month,
                      year: exp_year,
                      cvc: cvc,
                      cardNumber: carNo,
                      userId: loggedInUser.uid); //user.user.uid);
                } else {
                  stripeServices.addCard(
                      stripeId: user.userModel.stripeId,
                      month: exp_month,
                      year: exp_year,
                      cvc: cvc,
                      cardNumber: carNo,
                      userId: loggedInUser.uid);
                }
                user.hasCard();
                user.loadCardsAndPurchase(userId: user.user.uid);

                //this is where the page changes from adding a card screen to SOMETHING
              },
              tooltip: 'Submit',
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        });
  }
}
