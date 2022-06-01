import 'package:choreyprototype0712/models/user.dart';
import 'package:flutter/foundation.dart';

import 'cards.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> _user = [];

  UserModel get userModel => _userModel;
  UserModel _userModel;
  List<CardModel> cards = [];
  bool hasStripeId = true;
}
