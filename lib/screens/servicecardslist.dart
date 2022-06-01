//import 'package:choreyprototype0712/components/servicecard.dart';
//import 'package:choreyprototype0712/components/servicestile.dart';
//import 'package:choreyprototype0712/models/servicesdata.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//
//class ServicesCardsList extends StatelessWidget {
//  final double quantityOfDishes = 2;
//  final String displayedNumberOfDishes = "Medium";
//  final String dishImages = "images/lightdishes.png";
//
//  final double quantityOfLoads = 2;
//  final String displayedNumberOfLoads = "Medium";
//  final String loadsImages = "images/mediumload.png";
//
//  final double quantityOfFootage = 2;
//  final String displayedNumberOfFootage = "2-4";
//  final String footageImages = "images/mediumhome.png";
//
//  ServicesCardsList(
//  {this.quantityOfDishes,
//  this.displayedNumberOfDishes,
//  this.dishImages,
//  this.quantityOfLoads,
//  this.displayedNumberOfLoads,
//  this.loadsImages,
//  this.quantityOfFootage,
//  this.displayedNumberOfFootage,
//  this.footageImages,}
//      );
//
//  @override
//  Widget build(BuildContext context) {
//    return Expanded(
//      child: ListView(
//        padding: const EdgeInsets.fromLTRB(55.0, 50.0, 55.0, 100.0),
//        children: <Widget>[
//          ServiceCard(
//            title: "Dishwashing",
//            subTitle: "Supervision",
//            infoPage: () {
//              showDialog(
//                context: context,
//                builder: (context) => AlertDialog(
//                  title: Text("Quantities defined below"),
//                  content: SingleChildScrollView(
//                    child: ListBody(
//                      children: <Widget>[
//                        Text('Light is at most 25 pieces.'),
//                        Text('Medium is at most 50 pieces.'),
//                        Text('Heavy is at most 75 pieces.'),
//                      ],
//                    ),
//                  ),
//                  actions: <Widget>[
//                    FlatButton(
//                      child: Text('Got it!'),
//                      onPressed: () {
//                        Navigator.of(context).pop();
//                      },
//                    ),
//                  ],
//                ),
//              );
//            },
//            mainImage: dishImages,
//            serviceAmount: quantityOfDishes,
//            displayedServiceAmount: displayedNumberOfDishes,
//            minimum: 1,
//            maximum: 3,
//            sections: 2,
//            units: "Amount",
//            servicePicture: (newValue) {
//              setState(() {
//                quantityOfDishes = newValue;
//                if (newValue == 1) {
//                  displayedNumberOfDishes = "Light";
//                } else if (newValue == 2) {
//                  displayedNumberOfDishes = "Medium";
//                } else {
//                  displayedNumberOfDishes = "Heavy";
//                }
//                if (newValue == 1) {
//                  dishImages = "images/lightdishes.png";
//                } else if (newValue == 2) {
//                  dishImages = "images/mediumdishes.png";
//                } else {
//                  dishImages = "images/heavydishes.png";
//                }
//              });
//            },
//            addService: () {
//              Provider.of<ServicesData>(context, listen: false)
//                  .addServices(
//                  newServiceTitle: "Dishwashing Supervision",
//                  newServiceAmount:
//                  "$displayedNumberOfDishes Amount",
//                  newServicesImage: dishImages,
//                  newServicesQuantifiedAmount:
//                  "At most 50 pieces");
//            },
//          ),
//          ServiceCard(
//            title: "Laundry",
//            subTitle: "Dry Cleaners",
//            infoPage: () {
//              showDialog(
//                context: context,
//                builder: (context) => AlertDialog(
//                  title: Text("Quantities defined below"),
//                  content: SingleChildScrollView(
//                    child: ListBody(
//                      children: <Widget>[
//                        Text('Light is 1 load.'),
//                        Text('Medium is at most 2 loads.'),
//                        Text('Heavy is at most 3 loads.'),
//                      ],
//                    ),
//                  ),
//                  actions: <Widget>[
//                    FlatButton(
//                      child: Text('Got it!'),
//                      onPressed: () {
//                        Navigator.of(context).pop();
//                      },
//                    ),
//                  ],
//                ),
//              );
//            },
//            mainImage: loadsImages,
//            serviceAmount: quantityOfLoads,
//            displayedServiceAmount: displayedNumberOfLoads,
//            minimum: 1,
//            maximum: 3,
//            sections: 2,
//            units: quantityOfLoads == 1 ? "Load" : "Loads",
//            servicePicture: (newValue) {
//              setState(() {
//                quantityOfLoads = newValue;
//                if (newValue == 1) {
//                  displayedNumberOfLoads = "Light";
//                } else if (newValue == 2) {
//                  displayedNumberOfLoads = "Medium";
//                } else {
//                  displayedNumberOfLoads = "Heavy";
//                }
//                if (newValue == 1) {
//                  loadsImages = "images/oneload.png";
//                } else if (newValue == 2) {
//                  loadsImages = "images/mediumload.png";
//                } else {
//                  loadsImages = "images/largeload.png";
//                }
//              });
//            },
//            addService: () {
//              Provider.of<ServicesData>(context, listen: false)
//                  .addServices(
//                  newServiceTitle: "Laundry Dry Cleaners",
//                  newServiceAmount:
//                  "$displayedNumberOfLoads Loads",
//                  newServicesImage: loadsImages,
//                  newServicesQuantifiedAmount:
//                  "At most 2 loads");
//            },
//          ),
//          ServiceCard(
//            title: "Cleaning",
//            subTitle: "Additional",
//            infoPage: () {
//              showDialog(
//                context: context,
//                builder: (context) => AlertDialog(
//                  title: Text("Service includes"),
//                  content: SingleChildScrollView(
//                    child: ListBody(
//                      children: <Widget>[
//                        Text(
//                            'Dusting the furnitures, Vacumming the floor/carpet, Throwing out trash'),
//                      ],
//                    ),
//                  ),
//                  actions: <Widget>[
//                    FlatButton(
//                      child: Text('Got it!'),
//                      onPressed: () {
//                        Navigator.of(context).pop();
//                      },
//                    ),
//                  ],
//                ),
//              );
//            },
//            mainImage: footageImages,
//            serviceAmount: quantityOfFootage,
//            displayedServiceAmount: displayedNumberOfFootage,
//            minimum: 1,
//            maximum: 3,
//            sections: 2,
//            units: quantityOfFootage == 1
//                ? "1 bedroom / studio"
//                : "Bedrooms",
//            servicePicture: (newValue) {
//              setState(() {
//                quantityOfFootage = newValue;
//                if (newValue == 1) {
//                  displayedNumberOfFootage = "";
//                } else if (newValue == 2) {
//                  displayedNumberOfFootage = "2-4";
//                } else {
//                  displayedNumberOfFootage = "5+";
//                }
//                if (newValue == 1) {
//                  footageImages = "images/smallhome.png";
//                } else if (newValue == 2) {
//                  footageImages = "images/mediumhome.png";
//                } else {
//                  footageImages = "images/largehome.png";
//                }
//              });
//            },
//            addService: () {
//              Provider.of<ServicesData>(context, listen: false)
//                  .addServices(
//                  newServiceTitle: "Additional Cleaning",
//                  newServiceAmount:
//                  "$displayedNumberOfFootage Bedrooms",
//                  newServicesImage: footageImages,
//                  newServicesQuantifiedAmount:
//                  "Dusting, Vacumming, etc...");
//            },
//          ),
//        ],
//      ),
//    );
//  }
//}
