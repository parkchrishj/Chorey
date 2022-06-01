import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/servicesdata.dart';
import 'screens/chatscreen.dart';
import 'screens/getstarted.dart';
import 'screens/homepage.dart';
import 'screens/login.dart';
import 'screens/neighborpage.dart';
import 'screens/paymentpage.dart';
import 'screens/signup.dart';
import 'usermanagement.dart';

//const darkThemeColor = 0xFF151011;

void main() => runApp(ChoreyPrototype());

class ChoreyPrototype extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ServicesData(),
        ),
//        ChangeNotifierProvider.value(
//          value: UserProvider.initialize(),
//        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: UserManagement.id,
//        home: ScreensController(),
        routes: {
          GetStarted.id: (context) => GetStarted(),
          LogIn.id: (context) => LogIn(),
          SignUp.id: (context) => SignUp(),
          HomePage.id: (context) => HomePage(),
          PaymentPage.id: (context) => PaymentPage(),
          ChatScreen.id: (context) => ChatScreen(),
          UserManagement.id: (context) => UserManagement().handleAuth(),
          NeighborPage.id: (context) => NeighborPage(),
        },
      ),
    );
  }
}

//class ScreensController extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final user = Provider.of<UserProvider>(context);
//
//    switch (user.status) {
//      case Status.Uninitialized:
//        return Loading();
//      case Status.Unauthenticated:
//      case Status.Authenticating:
//        return LogIn();
//      case Status.Authenticated:
//        return HomePage();
//      default:
//        return LogIn();
//    }
//  }
//}
