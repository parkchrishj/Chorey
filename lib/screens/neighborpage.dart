import 'package:choreyprototype0712/components/menuselector.dart';
import 'package:choreyprototype0712/components/messagebubble.dart';
import 'package:choreyprototype0712/components/neighborstatus.dart';
import 'package:choreyprototype0712/components/swipingbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'getstarted.dart';
import 'homepage.dart';

enum menu {
  status,
  toDoServices,
}
enum profileOptions {
  signOut,
  backToCustomer,
}

enum online {
  Go,
  Pause,
}
final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class NeighborPage extends StatefulWidget {
  static const id = "neighbor_page";
  @override
  _NeighborPageState createState() => _NeighborPageState();
}

class _NeighborPageState extends State<NeighborPage> {
  menu selectedMenu = menu.status;
  final _auth = FirebaseAuth.instance;
  PageController _pageController;
  int pageChanged = 0;
  online statusChange = online.Pause;

  final messageTextController = TextEditingController();
  String messageText;

  String customerEmail;
  List<String> customerDemands = [];
  String demandImage1 = " ";
  String demandTitle1 = " ";
  String demandAmount1 = " ";
  String demandQuantity1 = " ";
  String demandImage2 = " ";
  String demandTitle2 = " ";
  String demandAmount2 = " ";
  String demandQuantity2 = " ";
  String demandImage3 = " ";
  String demandTitle3 = " ";
  String demandAmount3 = " ";
  String demandQuantity3 = " ";
  String demandImage4 = " ";
  String demandTitle4 = " ";
  String demandAmount4 = " ";
  String demandQuantity4 = " ";
  String demandImage5 = " ";
  String demandTitle5 = " ";
  String demandAmount5 = " ";
  String demandQuantity5 = " ";

  String documentIdentity;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    getCurrentUser();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('demands')
            .where('taken', isEqualTo: false)
            .where('complete', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
//            String documentNumber = snapshot.data.documents[0].documentID;
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          right: 18,
                          bottom: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              Icons.notification_important,
                              size: 40.0,
                            ),
                            PopupMenuButton<profileOptions>(
                                onSelected: (profileOptions selected) {
                                  if (profileOptions.signOut == selected) {
                                    _auth.signOut();
                                    Navigator.popAndPushNamed(
                                        context, GetStarted.id);
                                  }
                                  if (profileOptions.backToCustomer ==
                                      selected) {
                                    Navigator.popAndPushNamed(
                                        context, HomePage.id);
                                  }
                                },
                                icon: Icon(
                                  Icons.account_circle,
                                  size: 40.0,
                                ),
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<profileOptions>>[
                                      const PopupMenuItem(
                                        value: profileOptions.signOut,
                                        child: Text("Sign Out"),
                                      ),
                                      const PopupMenuItem(
                                        child: Text("Chorey Services"),
                                        value: profileOptions.backToCustomer,
                                      )
                                    ]),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Text(
                          "Status & To-Do Services",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: MenuSelector(
                              colour: selectedMenu == menu.status
                                  ? Colors.black
                                  : Colors.black38,
                              borderWidth:
                                  selectedMenu == menu.status ? 2.0 : 1.0,
                              onPress: () {
                                setState(() {
                                  pageChanged = 0;
                                  selectedMenu = menu.status;
                                });
                                _pageController.animateToPage(
                                  pageChanged,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              },
                              cardChild: Container(
                                margin:
                                    EdgeInsets.only(top: 25.0, bottom: 10.0),
                                child: Text(
                                  "Status",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: selectedMenu == menu.status
                                        ? Colors.black
                                        : Colors.black38,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
//                    The To do services Section
                          Expanded(
                            child: MenuSelector(
                              colour: selectedMenu == menu.toDoServices
                                  ? Colors.black
                                  : Colors.black38,
                              borderWidth:
                                  selectedMenu == menu.toDoServices ? 2.0 : 1.0,
                              onPress: () {
                                setState(() {
                                  pageChanged = 1;
                                  selectedMenu = menu.toDoServices;
                                });
                                _pageController.animateToPage(
                                  pageChanged,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              },
                              cardChild: Container(
                                margin:
                                    EdgeInsets.only(top: 25.0, bottom: 10.0),
                                child: Text(
                                  "To-Do Services",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: selectedMenu == menu.toDoServices
                                        ? Colors.black
                                        : Colors.black38,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              pageChanged = index;
                              selectedMenu = pageChanged == 0
                                  ? menu.status
                                  : menu.toDoServices;
                            });
                          },
                          children: <Widget>[
                            NeighborStatus(
                              colour: statusChange == online.Go
                                  ? Colors.orange
                                  : Colors.green,
                              circleSize:
                                  statusChange == online.Pause ? 200.0 : 100.0,
                              textColour: statusChange == online.Pause
                                  ? Colors.orange
                                  : Colors.green,
                              statusTitle:
                                  statusChange == online.Go ? "Pause" : "Go",
                              statusText: statusChange == online.Go
                                  ? "You're Online"
                                  : "You're Offline",
                              onPressed: () {
                                setState(() {
                                  statusChange == online.Go
                                      ? statusChange = online.Pause
                                      : statusChange = online.Go;
                                });
                              },
                            ),
//                            Text("Hello"),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  "$demandTitle1   $demandAmount1   $demandQuantity1",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "$demandTitle2   $demandAmount2   $demandQuantity2",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "$demandTitle3   $demandAmount3   $demandQuantity3",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "$demandTitle4   $demandAmount4   $demandQuantity4",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "$demandTitle5   $demandAmount5   $demandQuantity5",
                                  style: TextStyle(fontSize: 20.0),
                                ),
//                                Container(
//                                  child: CompleteButton(
//                                    neighborEmail: loggedInUser.email,
//                                    completion: () async {
//                                      setState(() {
//                                        _firestore
//                                            .collection('demands')
//                                            .document(documentIdentity)
//                                            .updateData({
//                                          'complete': true,
//                                        });
//                                      });
//                                    },
//                                  ),
//                                ),
//
                                MessagesStream(
                                  customerEmail: customerEmail,
                                ),
                                Container(
                                  decoration: kMessageContainerDecoration,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: TextField(
                                          controller: messageTextController,
                                          onChanged: (value) {
                                            messageText = value;
                                          },
                                          decoration:
                                              kMessageTextFieldDecoration,
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          messageTextController.clear();
                                          _firestore
                                              .collection('messages')
                                              .add({
                                            'customer': customerEmail,
                                            'neighbor': loggedInUser.email,
                                            'text': messageText,
                                            'sender': loggedInUser.email,
                                          });
                                        },
                                        child: Text(
                                          'Send',
                                          style: kSendButtonTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Visibility(
                      visible: statusChange == online.Go &&
                          (snapshot.data.documents.length > 0),
                      child: ListeningForDemands(
                        acceptFunction: () async {
                          int totalDemands = 0;
                          final demands =
                              snapshot.data.documents[0].data['services'];
                          for (var services in demands) {
                            totalDemands++;
                          }
                          print(totalDemands);
                          setState(() {
                            if (totalDemands > 3) {
                              demandTitle1 = snapshot
                                  .data.documents[0].data['services'][1];
                              demandAmount1 = snapshot
                                  .data.documents[0].data['services'][2];
                              demandQuantity1 = snapshot
                                  .data.documents[0].data['services'][3];
                              demandImage2 = " ";
                              demandTitle2 = " ";
                              demandAmount2 = " ";
                              demandQuantity2 = " ";
                              demandImage3 = " ";
                              demandTitle3 = " ";
                              demandAmount3 = " ";
                              demandQuantity3 = " ";
                              demandImage4 = " ";
                              demandTitle4 = " ";
                              demandAmount4 = " ";
                              demandQuantity4 = " ";
                              demandImage5 = " ";
                              demandTitle5 = " ";
                              demandAmount5 = " ";
                              demandQuantity5 = " ";
                            }
                            if (totalDemands > 7) {
                              demandTitle2 = snapshot
                                  .data.documents[0].data['services'][5];
                              demandAmount2 = snapshot
                                  .data.documents[0].data['services'][6];
                              demandQuantity2 = snapshot
                                  .data.documents[0].data['services'][7];
                            }
                            if (totalDemands > 11) {
                              demandTitle3 = snapshot
                                  .data.documents[0].data['services'][9];
                              demandAmount3 = snapshot
                                  .data.documents[0].data['services'][10];
                              demandQuantity3 = snapshot
                                  .data.documents[0].data['services'][11];
                            }
                            if (totalDemands > 15) {
                              demandTitle4 = snapshot
                                  .data.documents[0].data['services'][13];
                              demandAmount4 = snapshot
                                  .data.documents[0].data['services'][14];
                              demandQuantity4 = snapshot
                                  .data.documents[0].data['services'][15];
                            }
                            if (totalDemands > 19) {
                              demandTitle5 = snapshot
                                  .data.documents[0].data['services'][17];
                              demandAmount5 = snapshot
                                  .data.documents[0].data['services'][18];
                              demandQuantity5 = snapshot
                                  .data.documents[0].data['services'][19];
                            }
                            customerEmail =
                                snapshot.data.documents[0].data['email'];
                            final orderID =
                                snapshot.data.documents[0].data['orderid'];
                            print(snapshot.data.documents[0].documentID);
                            print(customerEmail);
                            _firestore
                                .collection('demands')
                                .document(snapshot.data.documents[0].documentID)
                                .updateData({
                              'taken': true,
                              'complete': true,
                              'neighbor': loggedInUser.email
                            });
                            _firestore
                                .collection('orders')
                                .document(orderID)
                                .updateData({
                              'taken': true,
                              'complete': true,
                              'neighbor': loggedInUser.email
                            });

//                            Firestore.instance
//                                .collection('demands')
//                                .document(snapshot
//                                    .data
//                                    .documents[
//                                        snapshot.data.documents.length - 1]
//                                    .documentID)
//                                .updateData({
//                              'taken': true,
//                              'neighbor': loggedInUser.email
//                            });
                            _firestore.collection('messages').add({
                              'customer': customerEmail,
                              'neighbor': loggedInUser.email,
                              'text':
                                  "Hi Neighbor, I'll be helping you out with your chores. Could you kindly let me know your address and unit number? Thank you!",
                              'sender': loggedInUser.email,
                            });

                            statusChange = online.Pause;
                            _pageController.animateToPage(
                              1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                            selectedMenu = menu.toDoServices;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class ListeningForDemands extends StatelessWidget {
  final Function acceptFunction;

  ListeningForDemands({this.acceptFunction});

  @override
  Widget build(BuildContext context) {
    // bool taken = false;
    return SwipingButton(
      text: "→ Swipe to Accept! →",
      onSwipeCallback: acceptFunction,
    );
//      StreamBuilder<QuerySnapshot>(
//      stream: _firestore
//          .collection('demands')
//          .where('taken', isEqualTo: taken)
//          .snapshots(),
//      builder: (context, snapshot) {
//        print("Hello");
//        //snapshot.data.documents[0].documentID;
////        Firestore.instance
////            .collection('demands')
////            .document(snapshot.data.documents[0].documentID)
////            .updateData({"taken": true});
//        print(snapshot.data.documents);
////This is a bigger scale of adding to the firestore Firestore.instance.runTransaction((transaction) {
////  CollectionReference reference = Firestore.instance.collection('demands');
////  return reference.add({'email': "Hello"});
////});
//        if (snapshot.data != null) {
//          return SwipingButton(
//            text: "→ Swipe to Accept! →",
//            onSwipeCallback: acceptFunction,
//          );
//        }
//        return Text("Hello");
//      },
//    );
  }
}

class MessagesStream extends StatelessWidget {
  MessagesStream({
    this.customerEmail,
  });

  final String customerEmail;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .where('customer', isEqualTo: customerEmail)
          .where('neighbor', isEqualTo: loggedInUser.email)
          .snapshots(),
//      _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data.documents.length == 0) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

//
//
//class DemandsStream extends StatelessWidget {
//
//  Function swipe;
//
//  DemandsStream({this.swipe});
//
//  @override
//  Widget build(BuildContext context) {
//    return StreamBuilder<QuerySnapshot>(
//      stream: _firestore.collection('demands').snapshots(),
//      builder: (context, snapshot) {
//        if (!snapshot.hasData) {
//          return SwipingButton(
//            text: "→ Swipe to Accept! →",
//            onSwipeCallback: swipe,
//          );
//        }
//        final demands = snapshot.data.documents;
//        List<ToDoList> messageBubbles = [];
//        for (var demand in demands) {
//          final demandTitle = demand.data['text'];
//          final demandAmount = demand.data['sender'];
//
//          final currentUser = loggedInUser.email;
//
//          final messageBubble = MessageBubble(
//            sender: messageSender,
//            text: messageText,
//            isMe: currentUser == messageSender,
//          );
//
//          messageBubbles.add(messageBubble);
//        }
//        return Expanded(
//          child: ListView(
//            reverse: true,
//            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
//            children: messageBubbles,
//          ),
//        );
//      },
//    );
//  }
//}
//
//class ToDoList extends StatelessWidget {
//  final String choreTitle;
//  final String choreAmount;
//
//  ToDoList({this.choreTitle, this.choreAmount,})
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      children: <Widget>[
//        Text(choreTitle),
//        Text(choreAmount),
//      ],
//    );
//  }
//}
