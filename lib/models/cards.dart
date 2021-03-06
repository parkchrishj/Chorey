import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  static const ID = 'id';
  static const USER_ID = 'userId';
  static const MONTH = 'exp_month';
  static const YEAR = 'exp_year';
  static const LAST_FOUR = 'last4';

  String _id;
  String _userId;
  int _month;
  int _year;
  int _last4;

//  getters
  String get id => _id;
  String get userId => _userId;
  int get month => _month;
  int get year => _year;
  int get last4 => _last4;

  // getting id being able to snapshot data id
  CardModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data[ID];
    _userId = snapshot.data[USER_ID];
    _month = snapshot.data[MONTH];
    _year = snapshot.data[YEAR];
    _last4 = snapshot.data[LAST_FOUR];
  }

  // getting values from our api, it's going to return map
  CardModel.fromMap(Map data, {String customerId}) {
    _id = data[ID];
    _userId = data[USER_ID];
    _month = data[MONTH];
    _year = data[YEAR];
    _last4 = data[LAST_FOUR];
  }

  // when we want to insert data, we want to convert an object
  // of the type credit card model and we want to insert that data
  // inside our firebase
  Map<String, dynamic> toMap() {
    return {
      ID: _id,
      USER_ID: _userId,
      MONTH: _month,
      YEAR: _year,
      LAST_FOUR: _last4
    };
  }
}
