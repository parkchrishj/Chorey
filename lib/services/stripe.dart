import 'dart:convert';

import 'package:choreyprototype0712/services/cards.dart';
import 'package:choreyprototype0712/services/purchases.dart';
import 'package:choreyprototype0712/services/user.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class StripeServices {
  static const PUBLISHABLE_KEY =
      "pk_test_51HDyzYArso29heHRfo4ZsfUXE8x5AMnkxX18hAtVx99QqoJcsMtFOhtW0vg0eQ2kWvjXwcyVrV84mIbS6DT0jcio00hKbwKXq4";
  static const SECRET_KEY =
      "sk_test_51HDyzYArso29heHRfvxkHJbiWYJXIOlZetUXUxOcsHq7MNsxlDL29hKJVYhyI531wiI8C95GQvDYmALGzXeiKsht00mU6f9J5M";
  static const PAYMENT_METHOD_URL = "https://api.stripe.com/v1/payment_methods";
  static const CUSTOMERS_URL = "https://api.stripe.com/v1/customers";
  static const CHARGE_URL = "https://api.stripe.com/v1/charges";

  // this is where we can communicate to Stripe
  Map<String, String> headers = {
    'Authorization': "Bearer  $SECRET_KEY",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  Future<String> createStripeCustomer({String email, String userId}) async {
    Map<String, String> body = {
      'email': email,
    };
    //Create customer on postman so it could communicate to stripe.
    String stripeId = await http
        .post(CUSTOMERS_URL, body: body, headers: headers)
        .then((response) {
      //Retrieve the stripeID
      String stripeId = jsonDecode(response.body)["id"];
      print("The stripe id is: $stripeId");
      //Update that stripeID to firebase
      UserService userService = UserService();
      userService.updateDetails({"id": userId, "stripeId": stripeId});
      return stripeId;
    }).catchError((err) {
      print("==== THERE WAS AN ERROR ====: ${err.toString()}");
      return null;
    });

    return stripeId;
  }

  Future<void> addCard(
      {int cardNumber,
      int month,
      int year,
      int cvc,
      String stripeId,
      String userId}) async {
    Map body = {
      "type": "card",
      "card[number]": cardNumber,
      "card[exp_month]": month,
      "card[exp_year]": year,
      "card[cvc]": cvc
    };
    //Add a card. This creates a payment method.
    Dio()
        .post(PAYMENT_METHOD_URL,
            data: body,
            options: Options(
                contentType: Headers.formUrlEncodedContentType,
                headers: headers))
        .then((response) {
      //this retrieves the id of the payment method
      String paymentMethod = response.data["id"];
      print("=== The payment mathod id is ===: $paymentMethod");
      //then add the particular card to the user/customer to the stripe server.
      //attach is a future payment intent
      http
          .post(
              "https://api.stripe.com/v1/payment_methods/$paymentMethod/attach",
              body: {"customer": stripeId},
              headers: headers)
          .catchError((err) {
        print("ERROR ATTACHING CARD TO CUSTOMER");
        print("ERROR: ${err.toString()}");
      });
      //Creates a new card to firebase
      CardServices cardServices = CardServices();
      cardServices.createCard(
          id: paymentMethod,
          last4: int.parse(cardNumber.toString().substring(11)),
          exp_month: month,
          exp_year: year,
          userId: userId);
      //Update that card to active card to firebase
      UserService userService = UserService();
      userService.updateDetails({"id": userId, "activeCard": paymentMethod});
    });
  }

  Future<bool> charge(
      {String customer,
      int amount,
      String userId,
      String cardId,
      String productName}) async {
    Map<String, dynamic> data = {
      "amount": amount,
      "currency": "usd",
      "source": cardId,
      "customer": customer
    };
    //Create a charge object on postman to stripe
    try {
      Dio()
          .post(CHARGE_URL,
              data: data,
              options: Options(
                  contentType: Headers.formUrlEncodedContentType,
                  headers: headers))
          .then((response) {
        print(response.toString());
      });
      //Create purchase history in firebase
      PurchaseServices purchaseServices = PurchaseServices();
      var uuid = Uuid();
      var purchaseId = uuid.v1();
      purchaseServices.createPurchase(
          id: purchaseId,
          amount: amount,
          cardId: cardId,
          userId: userId,
          productName: productName);
      return true;
    } catch (e) {
      print("there was an error charging the customer: ${e.toString()}");
      return false;
    }
  }
}
