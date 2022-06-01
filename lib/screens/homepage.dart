import 'package:choreyprototype0712/components/menuselector.dart';
import 'package:choreyprototype0712/components/messagebubble.dart';
import 'package:choreyprototype0712/components/servicecard.dart';
import 'package:choreyprototype0712/components/serviceslist.dart';
import 'package:choreyprototype0712/models/servicesdata.dart';
import 'package:choreyprototype0712/screens/paymentpage.dart';
import 'package:choreyprototype0712/usermanagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'getstarted.dart';
import 'login.dart';

enum menu {
  services,
  order,
}

enum profileOptions {
  signOut,
  becomeNeighbor,
}

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double quantityOfDishes = 2;
  String displayedNumberOfDishes = "Medium";
  String dishImages = "images/mediumdishes.png";

  double quantityOfLoads = 2;
  String displayedNumberOfLoads = "Medium";
  String loadsImages = "images/mediumload.png";

  double quantityOfFootage = 2;
  String displayedNumberOfFootage = "2-4";
  String footageImages = "images/mediumhome.png";

  menu selectedMenu = menu.services;
  int pageChanged = 0;
  final _auth = FirebaseAuth.instance;
  PageController _pageController;

  final messageTextController = TextEditingController();
  String messageText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    _pageController = PageController();
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
//    return Consumer<ServicesData>(builder: (context, servicesData, child) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('demands')
            .where('email',
                isEqualTo: loggedInUser
                    .email) //user.userModel.email) //loggedInUser.email)
            .where('taken', isEqualTo: true)
            .where('complete', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (loggedInUser.email == null) return LogIn();
          if (snapshot.data == null)
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          String neighborEmail = snapshot.data.documents.length > 0
              ? snapshot.data.documents[0].data['neighbor']
              : "no@gmail.com";
          print("Hello" + neighborEmail);
          return Scaffold(
            body: Stack(
              children: <Widget>[
                SafeArea(
                  child: Column(
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
                                      if (profileOptions.becomeNeighbor ==
                                          selected) {
                                        UserManagement()
                                            .authorizeAccess(context);
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
                                            child: Text("Chorey Neighbor Only"),
                                            value:
                                                profileOptions.becomeNeighbor,
                                          )
                                        ]),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: Text(
                              "Services & Orders",
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
                                  colour: selectedMenu == menu.services
                                      ? Colors.black
                                      : Colors.black38,
                                  borderWidth:
                                      selectedMenu == menu.services ? 2.0 : 1.0,
                                  onPress: () {
                                    setState(() {
                                      selectedMenu = menu.services;
                                      pageChanged = 0;
                                    });
                                    _pageController.animateToPage(
                                      pageChanged,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  cardChild: Container(
                                    margin: EdgeInsets.only(
                                        top: 25.0, bottom: 10.0),
                                    child: Text(
                                      "Services",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: selectedMenu == menu.services
                                            ? Colors.black
                                            : Colors.black38,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
//                    The Favorite Section
                              Expanded(
                                child: MenuSelector(
                                  colour: selectedMenu == menu.order
                                      ? Colors.black
                                      : Colors.black38,
                                  borderWidth:
                                      selectedMenu == menu.order ? 2.0 : 1.0,
                                  onPress: () {
                                    setState(() {
                                      selectedMenu = menu.order;
                                      pageChanged = 1;
                                    });
                                    _pageController.animateToPage(
                                      pageChanged,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  cardChild: Container(
                                    margin: EdgeInsets.only(
                                        top: 25.0, bottom: 10.0),
                                    child: Text(
                                      "Order",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: selectedMenu == menu.order
                                            ? Colors.black
                                            : Colors.black38,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              pageChanged = index;
                              selectedMenu =
                                  pageChanged == 0 ? menu.services : menu.order;
                            });
                          },
                          children: <Widget>[
                            ListView(
                              padding: const EdgeInsets.fromLTRB(
                                  55.0, 50.0, 55.0, 100.0),
                              children: <Widget>[
                                ServiceCard(
                                  title: "Dishwashing",
                                  subTitle: "Supervision",
                                  infoPage: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Quantities defined below"),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  'Light is at most 25 pieces.'),
                                              Text(
                                                  'Medium is at most 50 pieces.'),
                                              Text(
                                                  'Heavy is at most 75 pieces.'),
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
                                  },
                                  mainImage: dishImages,
                                  serviceAmount: quantityOfDishes,
                                  displayedServiceAmount:
                                      displayedNumberOfDishes,
                                  minimum: 1,
                                  maximum: 3,
                                  sections: 2,
                                  units: "Amount",
                                  servicePicture: (newValue) {
                                    setState(() {
                                      quantityOfDishes = newValue;
                                      if (newValue == 1) {
                                        displayedNumberOfDishes = "Light";
                                      } else if (newValue == 2) {
                                        displayedNumberOfDishes = "Medium";
                                      } else {
                                        displayedNumberOfDishes = "Heavy";
                                      }
                                      if (newValue == 1) {
                                        dishImages = "images/lightdishes.png";
                                      } else if (newValue == 2) {
                                        dishImages = "images/mediumdishes.png";
                                      } else {
                                        dishImages = "images/heavydishes.png";
                                      }
                                    });
                                  },
                                  addService: () {
                                    Provider.of<ServicesData>(context,
                                            listen: false)
                                        .addServices(
                                            newServiceTitle:
                                                "Dishwashing Supervision",
                                            newServiceAmount:
                                                "$displayedNumberOfDishes Amount",
                                            newServicesImage: dishImages,
                                            newServicesQuantifiedAmount:
                                                "At most 50 pieces");
                                  },
                                ),
                                ServiceCard(
                                  title: "Laundry",
                                  subTitle: "Dry Cleaners",
                                  infoPage: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Quantities defined below"),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text('Light is 1 load.'),
                                              Text(
                                                  'Medium is at most 2 loads.'),
                                              Text('Heavy is at most 3 loads.'),
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
                                  },
                                  mainImage: loadsImages,
                                  serviceAmount: quantityOfLoads,
                                  displayedServiceAmount:
                                      displayedNumberOfLoads,
                                  minimum: 1,
                                  maximum: 3,
                                  sections: 2,
                                  units:
                                      quantityOfLoads == 1 ? "Load" : "Loads",
                                  servicePicture: (newValue) {
                                    setState(() {
                                      quantityOfLoads = newValue;
                                      if (newValue == 1) {
                                        displayedNumberOfLoads = "Light";
                                      } else if (newValue == 2) {
                                        displayedNumberOfLoads = "Medium";
                                      } else {
                                        displayedNumberOfLoads = "Heavy";
                                      }
                                      if (newValue == 1) {
                                        loadsImages = "images/oneload.png";
                                      } else if (newValue == 2) {
                                        loadsImages = "images/mediumload.png";
                                      } else {
                                        loadsImages = "images/largeload.png";
                                      }
                                    });
                                  },
                                  addService: () {
                                    Provider.of<ServicesData>(context,
                                            listen: false)
                                        .addServices(
                                            newServiceTitle:
                                                "Laundry Dry Cleaners",
                                            newServiceAmount:
                                                "$displayedNumberOfLoads Loads",
                                            newServicesImage: loadsImages,
                                            newServicesQuantifiedAmount:
                                                "At most 2 loads");
                                  },
                                ),
                                ServiceCard(
                                  title: "Cleaning",
                                  subTitle: "Additional",
                                  infoPage: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Service includes"),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  'Dusting the furnitures, Vacumming the floor/carpet, Throwing out trash'),
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
                                  },
                                  mainImage: footageImages,
                                  serviceAmount: quantityOfFootage,
                                  displayedServiceAmount:
                                      displayedNumberOfFootage,
                                  minimum: 1,
                                  maximum: 3,
                                  sections: 2,
                                  units: quantityOfFootage == 1
                                      ? "bedroom"
                                      : "Bedrooms",
                                  servicePicture: (newValue) {
                                    setState(() {
                                      quantityOfFootage = newValue;
                                      if (newValue == 1) {
                                        displayedNumberOfFootage = "Studio / 1";
                                      } else if (newValue == 2) {
                                        displayedNumberOfFootage = "2-4";
                                      } else {
                                        displayedNumberOfFootage = "5+";
                                      }
                                      if (newValue == 1) {
                                        footageImages = "images/smallhome.png";
                                      } else if (newValue == 2) {
                                        footageImages = "images/mediumhome.png";
                                      } else {
                                        footageImages = "images/largehome.png";
                                      }
                                    });
                                  },
                                  addService: () {
                                    Provider.of<ServicesData>(context,
                                            listen: false)
                                        .addServices(
                                            newServiceTitle:
                                                "Additional Cleaning",
                                            newServiceAmount:
                                                "$displayedNumberOfFootage Bedrooms",
                                            newServicesImage: footageImages,
                                            newServicesQuantifiedAmount:
                                                "Dusting, Vacumming, etc...");
                                  },
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                MessagesStream(
                                  neighborEmail: neighborEmail,
                                  userEmail: loggedInUser
                                      .email, //user.userModel.email,
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
                                            'customer': loggedInUser
                                                .email, //user.userModel.email,
                                            //loggedInUser.email,
                                            'neighbor': neighborEmail,
                                            'text': messageText,
                                            'sender':
                                                loggedInUser //user.userModel.email, //loggedInUser.email,
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
                ),
                Visibility(
                  visible: selectedMenu == menu.services,
                  child: SizedBox.expand(
                    child: DraggableScrollableSheet(
                      builder: (context, scrollController) {
                        return Stack(
                          alignment: Alignment.bottomCenter,
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Container(
                              child: ServicesList(scrollController),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50.0),
                                  topRight: Radius.circular(50.0),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 48, right: 10),
                                child: Container(
                                  child: Text(
                                    "To delete, hold down the item",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  //padding: EdgeInsets.only(top: 10.0),
                                  child: SizedBox(
                                    width: 50,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 10.0,
                                          color: Colors.purpleAccent),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              left: 20,
                              child: Material(
                                elevation: 3.0,
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(30.0),
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      if (Provider.of<ServicesData>(context,
                                                  listen: false)
                                              .servicesCount >
                                          0) {
                                        selectedMenu = menu.order;
                                        Navigator.pushNamed(
                                            context, PaymentPage.id);
                                        pageChanged = 1;
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Please Add Services"),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                      "Add service item using the 'Add Service' Button"),
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
                                      }
                                      _pageController.animateToPage(
                                        pageChanged,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    });
                                  },
                                  minWidth: 150.0,
                                  height: 32.0,
                                  child: Text(
                                    "Add Services to Cart",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      maxChildSize: 0.5,
                      minChildSize: 0.15,
                      initialChildSize: 0.15,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
//    });
  }
}

class MessagesStream extends StatelessWidget {
  MessagesStream({this.neighborEmail, this.userEmail});

  final String neighborEmail;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .where('customer', isEqualTo: userEmail) //loggedInUser.email)
          .where('neighbor', isEqualTo: neighborEmail)
          .snapshots(),
//      _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
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

          final currentUser = userEmail; //loggedInUser.email;

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
