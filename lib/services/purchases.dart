import 'package:choreyprototype0712/models/purchase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//this is literally to store the purchases to the database
class PurchaseServices {
  static const USER_ID = 'userId';

  String collection = "purchases";
  Firestore _firestore = Firestore.instance;

  void createPurchase(
      {String id,
      String productName,
      int amount,
      String userId,
      String date,
      String cardId}) {
    _firestore.collection(collection).document(id).setData({
      "id": id,
      "productName": productName,
      "amount": amount,
      "userId": userId,
      "date": DateTime.now().toString(),
      "cardId": cardId
    });
  }

  // Going to firebase and reading all and we'll retrieve all the documents
  Future<List<PurchaseModel>> getPurchaseHistory({String userId}) async =>
      _firestore
          .collection(collection)
          .where(USER_ID, isEqualTo: userId)
          .getDocuments()
          .then((result) {
        //list of document snapshots as the result
        List<PurchaseModel> purchaseHistory = [];
        print("=== RESULT SIZE ${result.documents.length}");
        for (DocumentSnapshot item in result.documents) {
          purchaseHistory.add(PurchaseModel.fromSnapshot(item));
          print(" CARDS ${purchaseHistory.length}");
        }
        return purchaseHistory;
      });
}
