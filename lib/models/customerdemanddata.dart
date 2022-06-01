import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'customerdemand.dart';

class CustomerDemandData extends ChangeNotifier {
  List<CustomerDemand> _demands = [];

  UnmodifiableListView<CustomerDemand> get services {
    return UnmodifiableListView(_demands);
  }

  int get demandCount {
    return _demands.length;
  }

  List<String> get listOfDemands {
    List<String> demands = [];
    for (int i = 0; i < _demands.length; i++) {
      demands.add(_demands[i].servicesImage);
      demands.add(_demands[i].servicesTitle);
      demands.add(_demands[i].servicesAmount);
      demands.add(_demands[i].servicesQuantifiedAmount);
    }
    return demands;
  }

  void addDemands(
      {String newServiceTitle,
      String newServiceAmount,
      String newServicesImage,
      String newServicesQuantifiedAmount}) {
    final demands = CustomerDemand(
        servicesTitle: newServiceTitle,
        servicesAmount: newServiceAmount,
        servicesImage: newServicesImage,
        servicesQuantifiedAmount: newServicesQuantifiedAmount);
    _demands.add(demands);
    //_services.insert(0, services);
    notifyListeners();
  }

//  void deleteServices(CustomerDemand services) {
//    _demands.remove(services);
//    notifyListeners();
//  }
}
